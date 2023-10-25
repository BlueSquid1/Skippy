# syntax=docker/dockerfile:1

FROM ubuntu

# Use bash instead of shell
SHELL ["/bin/bash", "-c"]

WORKDIR /app

RUN apt-get update -y
RUN apt-get install -y \
    build-essential \
    curl \
    wget

# Install rust
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=1.72.0

RUN wget -O rustup-init.sh https://sh.rustup.rs ; \
    bash ./rustup-init.sh -y ; \
    rm rustup-init.sh

RUN rustup --version; \
    cargo --version; \
    rustc --version

# Install wasm-pack
RUN wget https://rustwasm.github.io/wasm-pack/installer/init.sh ; \
    bash ./init.sh ; \
    rm init.sh

RUN wasm-pack -V

# Install npm
RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
RUN source /root/.nvm/nvm.sh \
    && nvm install 16.13.2 \
    && nvm alias default 16.13.2 \
    && nvm use default
ENV NODE_PATH /root/.nvm/versions/node/v16.13.2/lib/node_modules
ENV PATH      /root/.nvm/versions/node/v16.13.2/bin:$PATH
RUN npm --version

# Copy the code
COPY . .

# Compile the code
RUN wasm-pack build --out-dir pkg

# install NPM dependancies
WORKDIR /app/www
RUN npm install

# Open web port
EXPOSE 8080

# Start the server
ENTRYPOINT npm run start