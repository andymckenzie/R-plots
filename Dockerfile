FROM ubuntu:16.04

MAINTAINER Andrew McKenzie <amckenz@gmail.com>
# Adapted from https://github.com/DaisukeMiyamoto/docker-neuron

ARG NRN_VERSION="7.6.2"
ARG NRN_ARCH="x86_64"
ARG NRN_CONFIGURE_OPT="--without-iv --with-nrnpython=/usr/bin/python --with-paranrn --enable-static=yes"
ARG NRN_CFLAGS="-O3"
ARG NRN_CXXFLAGS="-O3"

WORKDIR /home

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update \
    && apt-get install -y \
        apt-utils \
        locales \
        wget \
        gcc \
        g++ \
        build-essential \
        libncurses-dev \
        python \
        python-pip \
        libpython-dev \
        cython \
        openmpi-bin \
        openmpi-common \
        libopenmpi-dev \
        mpich \
        libxext-dev \
        libx11-dev \
        zlib1g-dev \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
    && apt-get clean

RUN pip install --upgrade pip \
    && hash -r pip \
#    && pip install mpi4pi \
    && pip install neo \
    && pip install numpy \
    && pip install lazyarray \
    && pip install matplotlib
# && pip install --upgrade pip \ - causing errors?

RUN mkdir neuron \
    && cd neuron \
    && wget https://www.neuron.yale.edu/ftp/neuron/versions/v7.6/${NRN_VERSION}/nrn-${NRN_VERSION}.tar.gz \
    && wget https://neuron.yale.edu/ftp/neuron/versions/v7.6/iv-19.tar.gz

RUN cd neuron \
    && tar xvzf nrn-${NRN_VERSION}.tar.gz \
    && tar xvzf iv-19.tar.gz \
    && mv nrn-7.6 nrn \
    && mv iv-19 iv

RUN cd neuron/iv \
    && ./configure --prefix=`pwd` \
    && make \
    && make install

RUN cd neuron/nrn \
    && ./configure --prefix=`pwd` --with-iv=/home/neuron/iv --with-nrnpython=/usr/bin/python \
    && make \
    && make install

# apparently this no longer needed, but the error is still happening https://www.neuron.yale.edu/phpBB/viewtopic.php?t=3062
#RUN cd neuron/nrn \
#    && cd src/nrnpython \
#    && python setup.py install

#    && rm nrn-${NRN_VERSION}.tar.gz \
#    && cd nrn-7.6 \
#    && ./configure --prefix=`pwd` ${NRN_CONFIGURE_OPT} CFLAGS=${NRN_CFLAGS} CXXFLAGS=${NRN_CXXFLAGS} \
#    && make \
#    && make install \
#    && rm -rf /var/lib/apt/lists/* \

#    && wget http://www.neuron.yale.edu/ftp/neuron/versions/v7.6/${NRN_VERSION}/nrn-${NRN_VERSION}.${NRN_ARCH}-linux-py-36-35-27.tar.gz \
#    && apt-get install -y ./nrn-${NRN_VERSION}.${NRN_ARCH}-linux-py-36-35-27.deb \
#    && rm -rf /var/lib/apt/lists/* \
#    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
#    && apt-get clean

RUN useradd -m neuron
USER neuron

ENV LANG en_US.utf8
ENV PATH $PATH:/home/neuron/nrn
