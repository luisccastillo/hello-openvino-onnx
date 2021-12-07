FROM ubuntu:20.04

RUN  apt-get update \
    && apt-get install -y --no-install-recommends \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* && \
    wget https://repo.anaconda.com/miniconda/Miniconda3-py37_4.8.3-Linux-x86_64.sh && \
    bash Miniconda3-py37_4.8.3-Linux-x86_64.sh -b -p /root/miniconda

ENV PATH=/root/miniconda/bin:$PATH
ENV CONDA_AUTO_UPDATE_CONDA="false"

RUN conda install numpy
RUN conda install openvino-ie4py-ubuntu20 -c intel

COPY ./src /app

ENTRYPOINT ["/root/miniconda/bin/python3.7", "/app/app.py"]
