FROM python:3.11-slim
ENV PYTHONDONTWRITEBYTECODE=1
USER root
RUN apt-get update && apt-get install -y libsndfile1-dev espeak-ng time git
ENV VIRTUAL_ENV=/usr/local
RUN pip --no-cache-dir install uv
RUN uv venv
RUN uv pip install --no-cache-dir -U pip setuptools
RUN uv pip install --no-cache "pytest<8.0.1" "fsspec>=2023.5.0,<2023.10.0" pytest-subtests pytest-xdist

RUN uv pip install --no-cache --upgrade 'torch' --index-url https://download.pytorch.org/whl/cpu
RUN uv pip install --upgrade 'scikit-learn' 'torch-stft' 'nose' 'accelerate' 'dataset'
RUN uv pip install --no-cache-dir "transformers[sklearn,torch,testing,sentencepiece,torch-speech,vision,timm]"'

RUN pip uninstall -y transformers
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip cache remove "nvidia-*" triton