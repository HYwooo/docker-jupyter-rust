# Use the base image with Rust and Ubuntu
FROM hywooo/rust-stable-ubuntu:latest

# Add metadata (labels) to the image
LABEL description="Docker image for Jupyter Lab with Rust and Conda support."

# Install system packages using a custom script
# The script configures apt mirrors and updates the package list
RUN $(which zsh) -c "curl -sSL https://gcore.jsdelivr.net/gh/HYwooo/install@master/mirror-apt.sh"

# Install Miniconda to /miniconda
RUN curl -LO http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -p /miniconda -b && \
    rm Miniconda3-latest-Linux-x86_64.sh

# Add Miniconda to the PATH environment variable
ENV PATH=/miniconda/bin:${PATH}

# Initialize Conda for zsh and update Conda to the latest version
RUN conda init zsh && conda update -y conda

# Install CMake using Conda
RUN conda install -c anaconda cmake -y

# Install nb_conda_kernels for Jupyter Notebook Conda environment support
RUN conda install -y -c conda-forge nb_conda_kernels

# Install JupyterLab using Conda
RUN conda install -y -c conda-forge jupyterlab

# Install evcxr_jupyter (Rust Jupyter kernel) using Cargo
RUN cargo install evcxr_jupyter

# Install the evcxr_jupyter kernel for Jupyter
RUN evcxr_jupyter --install

# Set the working directory to /root
WORKDIR /root

# Clone the repository containing Jupyter Rust examples
RUN git clone https://github.com/HYwooo/docker-jupyter-rust.git

# Expose port 8888 for Jupyter Lab
EXPOSE 8888

# Set the entrypoint to start Jupyter Lab
# Jupyter Lab will be accessible on all network interfaces (0.0.0.0) and port 8888
# No token is required for authentication, and the root user is allowed
ENTRYPOINT ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--notebook-dir=/root/docker-jupyter-rust", "--allow-root", "--no-browser", "--NotebookApp.token=''"]