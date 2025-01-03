FROM rust:latest

# System packages 

RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources

RUN apt update -y && apt install -y curl git nodejs

# Install miniconda to /miniconda
RUN curl -LO http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -p /miniconda -b && \
    rm Miniconda3-latest-Linux-x86_64.sh

# configure & update conda
ENV PATH=/miniconda/bin:${PATH} \
    SHELL=/bin/bash
    
RUN conda init bash && conda update -y conda 

RUN conda install -c anaconda cmake -y

RUN conda install -y -c conda-forge nb_conda_kernels jupyterlab

# install evcxr_jupyter
RUN cargo install evcxr_jupyter 

RUN evcxr_jupyter --install
    
RUN mkdir /root/workspace

EXPOSE 8888

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--notebook-dir=/root/workspace", "--allow-root", "--no-browser","--NotebookApp.token=''"]