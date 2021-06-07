FROM ubuntu:20.04 AS builder
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true
ARG TAG_VERSION=master
WORKDIR /build
RUN apt-get update && \
    apt-get install -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils libboost-all-dev git && \
    git clone https://github.com/dogecoin/dogecoin.git && \
    cd dogecoin && \
    git checkout $TAG_VERSION && \
    ./autogen.sh && \
    ./configure --enable-hardening --disable-wallet --without-gui && \
    make && \
    make install

FROM ubuntu:20.04
WORKDIR /usr/local/bin
COPY --from=builder /build/dogecoin/src/dogecoind .
EXPOSE 22556
CMD ["./dogecoind"]
