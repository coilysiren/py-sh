FROM ubuntu:18.04

RUN mkdir -p /assets
WORKDIR /assets

# setup system dependencies
RUN apt-get update
RUN apt-get install curl -y

ARG pythonVersion

# download the python version
RUN curl https://www.python.org/ftp/python/$pythonVersion/Python-$pythonVersion.tgz --output python.tgz
RUN ls python.tgz

# rename to a generic name
RUN tar -xf /assets/python.tgz --directory /assets
RUN mv /assets/Python-$pythonVersion/ /assets/python/
