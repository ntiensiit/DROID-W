#!/bin/bash
set -e

apt-get update && apt-get install -y git wget build-essential unzip

if [ ! -d "miniconda" ]; then
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
    bash miniconda.sh -b -p ./miniconda
    rm miniconda.sh
fi
export PATH="$(pwd)/miniconda/bin:$PATH"

conda init bash
source ~/.bashrc
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

[ ! -d ".git" ] && git submodule update --init --recursive .

conda create --name droid-w python=3.10 -y
source activate droid-w

pip install numpy==1.26.3
pip install "setuptools<81"
conda install --channel "nvidia/label/cuda-11.8.0" cuda-toolkit
pip install torch==2.1.0 torchvision==0.16.0 torchaudio==2.1.0 --index-url https://download.pytorch.org/whl/cu118
pip install torch-scatter -f https://pytorch-geometric.com/whl/torch-2.1.0+cu118.html
pip3 install -U xformers==0.0.22.post7+cu118 --index-url https://download.pytorch.org/whl/cu118

python -m pip install -e thirdparty/lietorch --no-build-isolation
python -m pip install -e thirdparty/diff-gaussian-rasterization-w-pose --no-build-isolation
python -m pip install -e thirdparty/simple-knn --no-build-isolation

python -c "import torch; import lietorch; import simple_knn; import diff_gaussian_rasterization; print(torch.cuda.is_available())"

python -m pip install -e . --no-build-isolation
python -m pip install -r requirements.txt

pip install mmcv-full -f https://download.openmmlab.com/mmcv/dist/cu118/torch2.1.0/index.html

mkdir -p pretrained
pip install gdown
gdown https://drive.google.com/uc?id=1PpqVt1H4maBa_GbPJp4NwxRsd9jk-elh -O pretrained/droid.pth
