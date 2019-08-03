FROM ubuntu:18.04

MAINTAINER Michael Spector <spektom@gmail.com>

LABEL Description="Build environment for ViyaDB"

ENV TERM=xterm

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    autoconf \
    automake \
    binutils-dev \
    bison \
    git \
    flex \
    libfl-dev \
    libbz2-dev \
    libevent-dev \
    liblz4-dev \
    libssl-dev \
    libtool \
    pkg-config \
    python \
    ca-certificates \
    zlib1g-dev \
    clang-format \
    gdb \
    g++-8 \
  && apt-get autoremove -y gcc-7 \
  && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 60 --slave /usr/bin/g++ g++ /usr/bin/g++-8 \
  && update-alternatives --install /usr/bin/gcov gcov /usr/bin/gcov-8 100 \
  && curl -sS -L https://cmake.org/files/v3.14/cmake-3.14.0-Linux-x86_64.sh -o cmake-install.sh \
    && sh ./cmake-install.sh --prefix=/usr/local --skip-license \
    && rm -f ./cmake-install.sh \
  && curl -sS -L https://dl.bintray.com/boostorg/release/1.65.1/source/boost_1_65_1.tar.gz | tar -zxf - \
    && cd boost_1_65_1 \
    && ./bootstrap.sh \
    && ./b2 --without-python -j 4 link=static runtime-link=shared install \
    && cd .. \
    && rm -rf boost_1_65_1 \
  && curl -sS -L https://netix.dl.sourceforge.net/project/ltp/Coverage%20Analysis/LCOV-1.14/lcov-1.14.tar.gz | tar -zxf - \
    && cd lcov-1.14 \
    && make install \
    && cd .. \
    && rm -rf lcov-1.14 \
  && ldconfig \
  && apt-get clean \
  && rm -rf \
    /usr/local/doc \
    /usr/local/man \
    /usr/local/share/man \
    /usr/local/bin/cmake-gui \
    /usr/local/bin/cpack \
    /usr/local/bin/ctest \
    /usr/local/bin/ccmake \
    /usr/share/doc* \
    /usr/share/man \
    /usr/share/info \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

RUN mkdir /viyadb

VOLUME /viyadb

CMD bash
