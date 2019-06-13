FROM ubuntu:18.04

RUN mkdir -p /assets
WORKDIR /assets

# setup system dependencies
RUN apt-get update
# TODO: move these into an ubuntu dev buildpack
RUN apt-get install curl git shellcheck build-essential -y

ARG pythonVersion

# download the python version
RUN curl https://www.python.org/ftp/python/$pythonVersion/Python-$pythonVersion.tgz --output python.tgz
RUN ls python.tgz

# rename to a generic name
RUN tar -xf /assets/python.tgz --directory /assets
RUN mv /assets/Python-$pythonVersion/ /assets/python/

WORKDIR /assets/python/
RUN ./configure
