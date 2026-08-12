FROM debian:bookworm AS base

ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Optional: Uncomment this block to use the TUNA Debian mirror when the
# default Debian repositories are slow or unavailable in your network.
# RUN sed -i \
#     -e 's|http://deb.debian.org/debian-security|http://mirrors.tuna.tsinghua.edu.cn/debian-security|g' \
#     -e 's|http://deb.debian.org/debian|http://mirrors.tuna.tsinghua.edu.cn/debian|g' \
#     /etc/apt/sources.list.d/debian.sources

# install build tools(alphabetic order)
RUN apt-get update && apt-get -o Acquire::Retries=5 install -y \
    bash-completion \
    bison \
    bzip2 \
    ccache \
    cpanminus \
    cron \
    curl \
    flex \
    fswatch \
    gcc g++ \
    gdb \
    git \
    htop \
    iproute2 \
    libclang-dev \
    libcurl4-gnutls-dev \
    libgdal-dev \
    libgeos-dev \
    libicu-dev \
    libkrb5-dev \
    liblz4-dev \
    libossp-uuid-dev \
    libpam0g-dev \
    libperl-dev \
    libproj-dev \
    libprotobuf-c-dev \
    libreadline-dev \
    libselinux1-dev \
    libssl-dev \
    libxml2-dev \
    libxslt-dev \
    libzstd-dev \
    linux-perf \
    locales \
    lsb-release \
    lsof \
    make \
    man \
    meson \
    neovim \
    ninja-build \
    perl \
    pkg-config \
    procps \
    protobuf-c-compiler \
    pspg \
    python3 python3-pip \
    stow \
    strace \
    sudo \
    tmux \
    tree \
    unzip \
    uuid-dev \
    valgrind \
    wget \
    zlib1g-dev \
 && apt-get remove libpq-dev -y \
 && apt-get autoremove -y \
 && apt-get clean

# Tools used to process the documentation
# https://www.postgresql.org/docs/current/docguide-toolsets.html#DOCGUIDE-TOOLSETS-INST-DEBIAN
RUN apt-get install -y docbook-xml docbook-xsl libxml2-utils xsltproc && apt-get clean

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

RUN cpanm install IPC::Run
RUN cpanm https://cpan.metacpan.org/authors/id/S/SH/SHANCOCK/Perl-Tidy-20230309.tar.gz

# add the postgres user to sudoers and allow all sudoers to login without a password prompt
RUN useradd -ms /bin/bash postgres \
 && usermod -aG sudo postgres \
 && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN mkdir -p /home/postgres/.codex \
 && chown postgres:postgres /home/postgres/.codex

WORKDIR /home/postgres
USER postgres

COPY --chown=postgres:postgres .psqlrc .

RUN sudo mkdir -p /opt/freedom \
 && sudo chown -R postgres:postgres /opt/freedom

# Use the Debug installation by default in interactive container shells.
# Release tasks use explicit paths under /home/postgres/postgres/Release.
ENV PATH="/home/postgres/.local/node_modules/.bin:/home/postgres/postgres/Debug/install/bin:$PATH"
ENV PGPORT=5433
ENV PGDATA=/home/postgres/postgres/Debug/data
EXPOSE 5433
