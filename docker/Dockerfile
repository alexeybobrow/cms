FROM ruby:2.4.10-slim

LABEL "co.anadea.newgit.project"="cms"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get install -y \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    gcc \
    git \
    gnupg \
    imagemagick \
    libicu-dev \
    libpq-dev \
    lsb-release \
    make \
    pkg-config \
    unzip \
    wget
# Postgres
## lsb-release gnupg
# Node
## ca-certificates
# gem 'rugged'
## cmake

RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
RUN curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update && apt-get upgrade -y && apt-get install -y postgresql-client-9.5 && apt-get clean all

ARG NODE_VERSION=12.22.12
ARG NODE_PACKAGE=node-v$NODE_VERSION-linux-x64
ARG NODE_HOME=/opt/$NODE_PACKAGE

ENV NODE_PATH $NODE_HOME/lib/node_modules
ENV PATH $NODE_HOME/bin:$PATH

RUN curl https://nodejs.org/dist/v$NODE_VERSION/$NODE_PACKAGE.tar.gz | tar -xzC /opt/

COPY bin/setup_chrome ./
# Install Chrome WebDriver
RUN ./setup_chrome

WORKDIR /app
