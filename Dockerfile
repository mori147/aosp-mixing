FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=Asia/Shanghai

# 时区
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

# 基础工具
RUN apt-get update && apt-get install -y \
    bash \
    sudo \
    git \
    curl \
    wget \
    vim \
    tzdata \
    locales \
    openjdk-11-jdk \
    ccache \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Java
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin

# Locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# 用户（toor 强烈建议非 root）
ARG USER_ID=1000
ARG GROUP_ID=1000

RUN set -eux; \
    # 删除 Ubuntu 24.04 默认用户
    deluser --remove-home ubuntu || true; \
    getent group ${GROUP_ID} || groupadd -g ${GROUP_ID} toor; \
    id toor >/dev/null 2>&1 || \
    useradd -m -u ${USER_ID} -g ${GROUP_ID} -s /bin/bash toor; \
    echo 'toor ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/toor; \
    chmod 0440 /etc/sudoers.d/toor

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    gnupg \
    flex \
    bison \
    build-essential \
    zip \
    curl \
    zlib1g-dev \
    gcc-multilib \
    g++-multilib \
    libc6-dev-i386 \
    lib32ncurses-dev \
    lib32z1-dev \
    libgl1-mesa-dev \
    libxml2-utils \
    xsltproc \
    unzip \
    fontconfig \
    python3 \
    python3-pip \
    python-is-python3 \
    rsync \
    libssl-dev \
    bc \
    ccache \
    m4 \
    make \
    wget \
    openjdk-17-jdk \
    repo \
    locales \
    tzdata \
    gperf \
    && rm -rf /var/lib/apt/lists/*

USER toor

WORKDIR /mnt/storage/lineageos23
