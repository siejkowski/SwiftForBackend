FROM ubuntu:15.10
MAINTAINER Krzysztof Siejkowski (github.com/siejkowski)

WORKDIR /

# Install Swift dependencies
RUN apt-get update && \
    apt-get install -y \
    wget \
    clang \
    libicu-dev

# Import Swift keys
RUN wget -q -O - https://swift.org/keys/all-keys.asc | gpg --import -

# Download Swift binaries
RUN wget -q https://swift.org/builds/development/ubuntu1510/swift-DEVELOPMENT-SNAPSHOT-2016-03-01-a/swift-DEVELOPMENT-SNAPSHOT-2016-03-01-a-ubuntu15.10.tar.gz

# Download Swift binaries signature
RUN wget -q https://swift.org/builds/development/ubuntu1510/swift-DEVELOPMENT-SNAPSHOT-2016-03-01-a/swift-DEVELOPMENT-SNAPSHOT-2016-03-01-a-ubuntu15.10.tar.gz.sig

# Verify Swift binaries
RUN gpg --keyserver hkp://pool.sks-keyservers.net --refresh-keys Swift && \
    gpg --verify swift-DEVELOPMENT-SNAPSHOT-2016-03-01-a-ubuntu15.10.tar.gz.sig

# Extract Swift binaries
RUN tar xzf swift-DEVELOPMENT-SNAPSHOT-2016-03-01-a-ubuntu15.10.tar.gz

# Add extracted binaries to path
RUN export PATH=/usr/bin:"${PATH}"

# Install Kitura dependencies
RUN apt-get install -y \
    autoconf \
    libtool \
    libkqueue-dev libkqueue0 \
    libdispatch-dev libdispatch0 \
    libhttp-parser-dev \
    libcurl4-openssl-dev \
    libhiredis-dev 
    
# Install Swift corelibs dependencies
RUN apt-get install -y \
    git \
    pkg-config \
    systemtap-sdt-dev \
    libblocksruntime-dev \ 
    libbsd-dev

# Download Swift corelibs libdispatch
RUN git clone https://github.com/apple/swift-corelibs-libdispatch.git

# Build Swift corelibs libdispatch
RUN cd swift-corelibs-libdispatch && \
    git submodule init && \
    git submodule update && \
    sh ./autogen.sh && \ 
    ./configure --with-swift-toolchain=/usr --prefix=/usr && \
    make 
    #&& \
    #make install

