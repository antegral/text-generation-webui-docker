ROM docker.io/continuumio/anaconda3
MAINTAINER SeongUk Moon <antegral@antegral.net>
 
RUN apt update
RUN conda create -n textgen python=3.10
CMD conda init bash
CMD conda activate textgen
RUN conda install torchvision torchaudio pytorch-cuda=11.7 git -c pytorch -c nvidia
RUN git clone https://github.com/oobabooga/text-generation-webui
RUN cd text-generation-webui && pip install -r requirements.txt
RUN cd text-generation-webui && python download-model.py decapoda-research/llama-30b-hf
CMD mkdir /text-generation-webui/repositories
RUN cd text-generation-webui/repositories && git clone https://github.com/qwopqwop200/GPTQ-for-LLaMA
RUN cd text-generation-webui/repositories/GPTQ-for-LLaMA && python setup_cuda.py install
RUN pip uninstall transformers
RUN pip install git+https://github.com/zphang/transformers@llama_push
RUN wget https://raw.githubusercontent.com/antegral/LLaMA-Autoinstall/main/start.sh && chmod a+x start.sh
ENTRYPOINT /start.sh
