FROM nvcr.io/nvidia/pytorch
MAINTAINER SeongUk Moon <antegral@antegral.net>

ENV TORCH_CUDA_ARCH_LIST="5.2 6.0 6.1 7.0 7.5 8.0 8.6+PTX"

RUN apt update
RUN apt install -y gcc g++

WORKDIR /var
RUN wget https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh
RUN Anaconda3-2020.11-Linux-x86_64.sh
RUN export $HOME/anaconda3/bin:$PATH
RUN source ~/.bashrc
RUN mkdir /app

WORKDIR /app
RUN conda create -n textgen python=3.10
CMD conda init bash
CMD conda activate textgen
RUN conda install torchvision torchaudio pytorch-cuda=11.7 git -c pytorch -c nvidia
RUN git clone https://github.com/oobabooga/text-generation-webui

WORKDIR /app/text-generation-webui
RUN pip install -r requirements.txt
RUN mkdir /text-generation-webui/repositories

WORKDIR /app/text-generation-webui/repositories
RUN git clone https://github.com/qwopqwop200/GPTQ-for-LLaMA

WORKDIR /app/text-generation-webui/repositories/GPTQ-for-LLaMA
RUN python setup_cuda.py install
RUN pip uninstall transformers
RUN pip install git+https://github.com/zphang/transformers@llama_push

WORKDIR /app/text-generation-webui
RUN wget https://raw.githubusercontent.com/antegral/LLaMA-Autoinstall/main/start.sh && chmod a+x start.sh

ENTRYPOINT /start.sh
