FROM mcr.microsoft.com/devcontainers/base:debian-13

# Install git, gh, Chromium, and other dependencies.
#
# Git build dependencies for asdf-git: build-essential, gettext,
# libcurl4-openssl-dev, libexpat1-dev, zlib1g-dev, and the Rust toolchain
# (rustc/cargo). Git 2.55+ compiles its Rust code by default (NO_RUST is not
# defined by this plugin), so Cargo is required to build Git from source.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    git \
    gh \
    openssh-client \
    iptables \
    curl \
    ca-certificates \
    gpg \
    gnupg \
    build-essential \
    cargo \
    rustc \
    gettext \
    libcurl4-openssl-dev \
    libexpat1-dev \
    libssl-dev \
    libyaml-dev \
    libreadline6-dev \
    zlib1g-dev \
    libncurses5-dev \
    libffi-dev \
    libgdbm6 \
    libgdbm-dev \
    dbus \
    kmod \
    chromium \
    chromium-driver \
    wget

# Install mise
RUN install -dm 755 /etc/apt/keyrings \
    && wget -qO - https://mise.jdx.dev/gpg-key.pub | gpg --dearmor -o /etc/apt/keyrings/mise-archive-keyring.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=amd64] https://mise.jdx.dev/deb stable main" | tee /etc/apt/sources.list.d/mise.list \
    && apt-get update \
    && apt-get install -y mise

# Install asdf (https://asdf-vm.com/guide/getting-started.html)
ARG ASDF_VERSION=0.19.0
RUN curl -fsSL "https://github.com/asdf-vm/asdf/releases/download/v${ASDF_VERSION}/asdf-v${ASDF_VERSION}-linux-$(dpkg --print-architecture).tar.gz" \
    | tar -xz -C /usr/local/bin asdf

USER vscode
ENV MISE_DATA_DIR=/home/vscode/.local/share/mise
ENV MISE_CONFIG_DIR=/home/vscode/.config/mise
ENV PATH="/home/vscode/.asdf/shims:/home/vscode/.local/bin:/home/vscode/.local/share/mise/shims:${PATH}"

# Install tools
RUN mise use -g node@24
RUN npm install -g @devcontainers/cli
# Install Claude Code via the native installer (https://code.claude.com/docs/ja/quickstart)
RUN curl -fsSL https://claude.ai/install.sh | bash
# Antigravity CLI is distributed as a native binary (installed to ~/.local/bin/agy), not via npm
RUN curl -fsSL https://antigravity.google/cli/install.sh | bash
RUN mise use -g ruby@latest

# Setup shell for mise and asdf
RUN echo 'eval "$(mise activate bash)"' >> ~/.bashrc \
    && echo '. <(asdf completion bash)' >> ~/.bashrc \
    && echo 'eval "$(mise activate zsh)"' >> ~/.zshrc
