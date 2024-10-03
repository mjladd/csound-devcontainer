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
  apt-get install git cmake g++ vim wget libsndfile1-dev libjack-dev portaudio19-dev \
   libportmidi-dev libpulse-dev swig liblua5.1-0-dev default-jdk libfluidsynth-dev \
   liblo-dev fluid ladspa-sdk libpng-dev dssi-dev libgmm++-dev \
   libportsmf-dev  libeigen3-dev libcunit1-dev gettext flex bison -y  && \
  git clone https://github.com/csound/csound.git && \
  mkdir cs6make && \
  cd cs6make && cmake ../csound && make -j6 && make install && \
  ldconfig

RUN rm -fr csound cs6make

ENV DEVCONTAINER=true
