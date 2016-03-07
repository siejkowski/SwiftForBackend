FROM ubuntu:15.10
MAINTAINER Krzysztof Siejkowski (github.com/siejkowski)

WORKDIR /

ARG swift_version=swift-DEVELOPMENT-SNAPSHOT-2016-03-01-a

# Install Swift dependencies
RUN apt-get update && \
    apt-get install -y \
    wget \
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
    ./configure && \
    make && \
    make install

# Download pcre2 package
RUN wget http://ftp.exim.org/pub/pcre/pcre2-10.20.tar.gz

# Unpack pcre2 package
RUN tar xzf pcre2-10.20.tar.gz

# Build pcre2
RUN cd pcre2-10.20 && \
    ./configure && \
    make && \
    make install



