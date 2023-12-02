#specify the base OS
FROM ubuntu:latest

WORKDIR /scores
ENV SSDIR=/scores/samples
ENV SADIR=/scores/analysis

ARG CACHEBUST=1

#Running apt updates on OS
ENV DEBIAN_FRONTEND noninteractive

RUN sed -i -- 's/#deb-src/deb-src/g' /etc/apt/sources.list && sed -i -- 's/# deb-src/deb-src/g' /etc/apt/sources.list

RUN apt-get update -y && \
  apt-get upgrade -y && \
  apt-get install git cmake g++ vim wget -y && \
  apt-get build-dep libcsound64-6.0 csound -y  && \
  git clone https://github.com/csound/csound.git && \
  mkdir cs6make && \
  cd cs6make && cmake ../csound && make -j6 && make install && \
  ldconfig

ENV DEVCONTAINER=true
