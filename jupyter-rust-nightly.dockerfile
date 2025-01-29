# Use the base image with Rust and Ubuntu
FROM hywooo/rust-stable-ubuntu:master

# Add metadata (labels to the image)
LABEL description="Docker image for Jupyter Lab with Rust and Conda support."

# Install system dependencies
RUN . "$HOME/.cargo/env" && cargo --version && \
    apt-get update -qq && \
    apt-get install -y --quiet git curl

# Configure apt mirrors and update
ENV USE_MIRROR=1
RUN sh -c "$(curl -sSL https://gcore.jsdelivr.net/gh/HYwooo/install@master/mirror-apt.sh)"

# Install Miniconda
RUN curl -LO http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -p /miniconda -b && \
    rm Miniconda3-latest-Linux-x86_64.sh

ENV PATH=/miniconda/bin:$PATH

# Initialize Conda
RUN conda init bash && \
    conda update -y conda

# Install dependencies
RUN conda install -c anaconda cmake -y && \
    conda install -y -c conda-forge nb_conda_kernels jupyterlab

# Install Rust Jupyter kernel
RUN . "$HOME/.cargo/env" && \
    cargo install evcxr_jupyter && \
    evcxr_jupyter --install

# Setup workspace
WORKDIR /root
RUN git clone https://github.com/HYwooo/docker-jupyter-rust.git

EXPOSE 8888


ENTRYPOINT ["jupyter", "lab", \
    "--ip=0.0.0.0", \
    "--port=8888", \
    "--notebook-dir=/root/docker-jupyter-rust", \
    "--allow-root", \
    "--no-browser", \
    "--NotebookApp.token=''"]