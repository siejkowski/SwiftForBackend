FROM ubuntu:15.10
MAINTAINER Krzysztof Siejkowski (github.com/siejkowski)

WORKDIR /

ARG swift_version=swift-DEVELOPMENT-SNAPSHOT-2016-03-01-a
ARG clion_version=2016.1
# 145.256.37
# 2016.1

# Install Swift dependencies
RUN apt-get update && \
    apt-get install -y \
    wget \
    curl \
    clang \
    libicu-dev \
    libpython2.7

# Import Swift keys
RUN wget -q -O - https://swift.org/keys/all-keys.asc | gpg --import -

# Download Swift binaries
RUN wget -q https://swift.org/builds/development/ubuntu1510/$swift_version/$swift_version-ubuntu15.10.tar.gz

# Download Swift binaries signature
RUN wget -q https://swift.org/builds/development/ubuntu1510/$swift_version/$swift_version-ubuntu15.10.tar.gz.sig

# Verify Swift binaries
RUN gpg --keyserver hkp://pool.sks-keyservers.net --refresh-keys Swift && \
    gpg --verify $swift_version-ubuntu15.10.tar.gz.sig

# Extract Swift binaries
RUN tar xzf $swift_version-ubuntu15.10.tar.gz

# Add extracted binaries to path
ENV PATH /$swift_version-ubuntu15.10/usr/bin:$PATH

# Install Swift corelibs dependencies
RUN apt-get install -y \
    git \
    pkg-config \
    autoconf \
    libtool \
    systemtap-sdt-dev \
    libkqueue-dev \
    libblocksruntime-dev \ 
    libbsd-dev

# Download Swift corelibs libdispatch
RUN git clone https://github.com/apple/swift-corelibs-libdispatch.git

# Build Swift corelibs libdispatch
RUN cd swift-corelibs-libdispatch && \
    git submodule init && \
    git submodule update && \
    sh ./autogen.sh && \ 
    ./configure --with-swift-toolchain=/$swift_version-ubuntu15.10/usr --prefix=/$swift_version-ubuntu15.10/usr && \
    make && \
    make install

## Install Clion
RUN wget http://download.jetbrains.com/cpp/CLion-$clion_version.tar.gz
RUN wget -O ideavim.plugin.zip "https://plugins.jetbrains.com/plugin/download?pr=objc&updateId=22030"
RUN wget -O clion-swift-$clion_version.jar "https://plugins.jetbrains.com/plugin/download?pr=objc&updateId=24729"
# 256.37 => 24576
# 257.16 => 24671
# 258.14 => 24729
RUN tar xzf CLion-$clion_version.tar.gz

# Install VNC and other useful tools
RUN apt-get install -y \
    vim \
    x11vnc \
    xvfb \
    x11-xserver-utils \
    unzip

RUN unzip ideavim.plugin.zip

# Setup VNC
RUN mkdir ~/.vnc
RUN x11vnc -storepasswd 1234 ~/.vnc/passwd

# Install JDK
RUN apt-get install -y \
    openjdk-8-jre \
    openjdk-8-jre-headless \
    openjdk-8-jdk

## Setup Clion
COPY clion_start.sh /clion_start.sh
COPY xmodmaprc /xmodmaprc
RUN chmod +xX /clion_start.sh

RUN echo "xmodmap /xmodmaprc" >> /root/.bashrc
RUN echo "./clion_start.sh" >> /root/.bashrc

# Start VNC by default
CMD x11vnc -clip 1280x800+0+0 -repeat -modtweak -xkb -remap Meta_L-Alt_L,Alt_L-Meta_L -forever -usepw -create 
