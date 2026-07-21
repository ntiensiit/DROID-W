FROM runpod/pytorch:2.1.0-py3.10-cuda11.8.0-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /workspace

RUN apt-get update && apt-get install -y \
    git \
    wget \
    build-essential \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --recursive https://github.com/MoyangLi00/DROID-W.git /workspace/DROID-W

WORKDIR /workspace/DROID-W

RUN pip install numpy==1.26.3

RUN pip install torch==2.1.0 torchvision==0.16.0 torchaudio==2.1.0 --index-url https://download.pytorch.org/whl/cu118

RUN pip install torch-scatter -f https://pytorch-geometric.com/whl/torch-2.1.0+cu118.html

RUN pip install -U xformers==0.0.22.post7+cu118 --index-url https://download.pytorch.org/whl/cu118

RUN python -m pip install -e thirdparty/lietorch --no-build-isolation

RUN python -m pip install -e thirdparty/diff-gaussian-rasterization-w-pose --no-build-isolation

RUN python -m pip install -e thirdparty/simple-knn --no-build-isolation

RUN python -m pip install -e . --no-build-isolation

RUN python -m pip install -r requirements.txt

RUN pip install mmcv-full -f https://download.openmmlab.com/mmcv/dist/cu118/torch2.1.0/index.html

CMD ["/bin/bash"]
