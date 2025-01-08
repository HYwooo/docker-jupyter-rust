FROM hywooo/rust-stable-ubuntu:v0.0.1

# System packages 
RUN curl -sSL https://gcore.jsdelivr.net/gh/HYwooo/install@master/aptmirror.sh | sudo sh


# Install miniconda to /miniconda
RUN curl -LO http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -p /miniconda -b && \
    rm Miniconda3-latest-Linux-x86_64.sh

# configure & update conda
ENV PATH=/miniconda/bin:${PATH} \
    SHELL=/usr/bin/zsh
    
RUN conda init zsh && conda update -y conda 

RUN conda install -c anaconda cmake -y

RUN conda install -y -c conda-forge nb_conda_kernels jupyterlab

# install evcxr_jupyter
RUN cargo install evcxr_jupyter 

RUN evcxr_jupyter --install
    
RUN cd /root && git clone https://github.com/HYwooo/docker-jupyter-rust.git 

EXPOSE 8888

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--notebook-dir=/root/docker-jupyter-rust", "--allow-root", "--no-browser","--NotebookApp.token=''"]
