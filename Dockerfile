# common image for some bioshop images
# sthysel/bioshopcommon
FROM debian:jessie
MAINTAINER sthysel <sthysel@gmail.com>
ENV REFRESHED_AT 2016-10-09

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates \
  apt-transport-https \
  build-essential \
  git \
  wget \
  python3 \
  python3-dev \
  python3-pip \
  unzip \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN env --unset=DEBIAN_FRONTEND

# cost of layering is better than cost of rebuilding
RUN pip3 install numpy

# build biopython from source
ENV BUILD_HOME /build/
RUN mkdir ${BUILD_HOME}
WORKDIR ${BUILD_HOME}
RUN wget https://github.com/biopython/biopython/archive/master.zip
RUN unzip master.zip
WORKDIR ${BUILD_HOME}/biopython-master/
RUN python3 setup.py build
RUN python3 setup.py install

WORKDIR /data

CMD ["/bin/bash"]
