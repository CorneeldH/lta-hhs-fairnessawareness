FROM rocker/r-ver:4.4.2

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    libglpk-dev \
    libgsl-dev \
    libcairo2-dev \
    libbz2-dev \
    libsodium-dev \
    libmagick++-dev \
    curl \
    wget \
    # fonts-firacode \
    && rm -rf /var/lib/apt/lists/*

# Install Quarto
RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.6.39/quarto-1.6.39-linux-amd64.deb \
    && dpkg -i quarto-1.6.39-linux-amd64.deb \
    && rm quarto-1.6.39-linux-amd64.deb

# Set working directory
WORKDIR /workspaces

# Install renv
RUN R -e "install.packages('languageserver', repos = 'https://cloud.r-project.org/')"
RUN R -e "install.packages('httpgd', repos = c('https://cranhaven.r-universe.dev', 'https://cloud.r-project.org'))"

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
# Add uv to PATH
ENV PATH="/root/.local/bin:$PATH"

Use uv to install Python packages
RUN uv pip install radian jupyter

# Create the R library directories with appropriate permissions
RUN mkdir -p /home/vscode/R/library && \
    chmod -R 777 /home/vscode/R && \
    chmod -R 777 /usr/local/lib/R/site-library

# Set R library path environment variables
ENV R_LIBS_USER=/home/vscode/R/library
ENV R_LIBS_SITE=/usr/local/lib/R/site-library

CMD ["bash"]
