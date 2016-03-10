FROM siejkowski/swift-clion:latest
MAINTAINER Krzysztof Siejkowski (github.com/siejkowski)

# Install Kitura dependencies
RUN apt-get install -y \
    autoconf \
    libtool \
    libkqueue-dev libkqueue0 \
    libdispatch-dev libdispatch0 \
    libhttp-parser-dev \
    libcurl4-openssl-dev \
    libhiredis-dev 
    
# Download pcre2 package
RUN wget http://ftp.exim.org/pub/pcre/pcre2-10.20.tar.gz

# Unpack pcre2 package
RUN tar xzf pcre2-10.20.tar.gz

# Build pcre2
RUN cd pcre2-10.20 && \
    ./configure && \
    make && \
    make install

