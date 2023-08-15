FROM ubuntu:22.04 as scr_build


ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
RUN apt update && apt install --no-install-recommends --no-install-suggests -y \
    build-essential autoconf libtool m4 automake pkg-config libboost-all-dev \
    bsdmainutils libzmq3-dev gdb

WORKDIR /bdb
COPY . /bdb/

WORKDIR /bdb/build_unix
RUN ../dist/configure --includedir=/usr/include --libdir=/usr/lib --enable-cxx --with-pic
RUN make -j20
RUN make install