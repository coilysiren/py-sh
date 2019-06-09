FROM ubuntu:18.04

RUN mkdir -p /repo
WORKDIR /repo

RUN apt-get update
RUN apt-get install curl -y

# TODO: something that watches for new python version releases
RUN curl https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tgz --output python.tgz
