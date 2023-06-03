ARG DISTRO
ARG TOOLCHAIN_TYPE
ARG TOOLCHAIN_PLATFORM

FROM ubuntu:22.04 as base
ENV DEBIAN_FRONTEND="noninteractive"
RUN apt-get update && apt-get install -y gcc g++ gperf bison flex texinfo help2man make libncurses5-dev \
    python3-dev python3-distutils autoconf automake libtool libtool-bin gawk wget bzip2 xz-utils unzip \
    patch libstdc++6 rsync git meson ninja-build curl gnupg2

ARG CTNG_UID=1000
ARG CTNG_GID=1000
RUN groupadd -g $CTNG_GID ctng
RUN useradd -d /home/ctng -m -g $CTNG_GID -u $CTNG_UID -s /bin/bash ctng
RUN chown -R ctng /home/ctng

FROM base as ctosstools_ng_build

ARG CROSSTOOLS_VERSION=1.25.0
RUN wget http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-${CROSSTOOLS_VERSION}.tar.bz2
RUN wget http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-${CROSSTOOLS_VERSION}.tar.bz2.sig

ADD crosstools_ng_public_key.gpg  public_key.gpg
RUN gpg2 --import public_key.gpg

RUN gpg2 --verify crosstool-ng-${CROSSTOOLS_VERSION}.tar.bz2.sig

RUN tar xf crosstool-ng-${CROSSTOOLS_VERSION}.tar.bz2

WORKDIR crosstool-ng-${CROSSTOOLS_VERSION}

RUN ./configure --prefix=/usr/local
RUN make -j "$(nproc)"
RUN make DESTDIR=/tmp/ct-ng install

FROM base as build
COPY --from=ctosstools_ng_build /tmp/ct-ng /

ARG HOST
ARG TARGET

WORKDIR /home/ctng
ADD samples/${HOST} samples/${HOST}

USER root
RUN chown -R ctng samples

USER ctng

RUN ct-ng ${HOST}
RUN ct-ng build --quiet -j "$(nproc)"


RUN cp -a "samples/${TARGET}" "samples/${HOST},${TARGET}"
RUN echo "CT_CANADIAN=y" >> "samples/${HOST},${TARGET}/crosstool.config"
RUN echo 'CT_HOST="${HOST}"' >> "samples/${HOST},${TARGET}/crosstool.config"


ENV PATH="/home/ctng/x-tools/${HOST}/bin:${PATH}"
RUN ct-ng "${HOST},${TARGET}"
RUN ct-ng build --quiet -j "$(nproc)"

RUN mkdir -p /tmp/cross
RUN cp -a /home/ctng/x-tools/${HOST} /tmp/cross

RUN mkdir -p /tmp/native
RUN cp -a /home/ctng/x-tools/HOST-${HOST}/${TARGET} /tmp/native

FROM scratch as toolchain_cross
COPY --from=build /tmp/cross /tmp/toolchain

FROM scratch as toolchain_native
COPY --from=build /tmp/native /tmp/toolchain

FROM toolchain_${TOOLCHAIN_TYPE} as toolchain


FROM --platform=${TOOLCHAIN_PLATFORM} ubuntu:22.04 as base_ubuntu
FROM --platform=${TOOLCHAIN_PLATFORM} alpine:3.18 as base_alpine

FROM base_${DISTRO}
RUN mkdir -p /opt/x-tools
COPY --from=toolchain /tmp/toolchain/. /opt/x-tools




#FROM ubuntu:22.04 as distro-ubuntu
#
#FROM alpine:3.18 as distro-alpine
#
#FROM distro-$DISTRO
#
#ARG SAMPLE_NAME
#COPY --from=build /home/ctng/x-tools/${SAMPLE_NAME} /opt/${SAMPLE_NAME}-cross
#COPY --from=build /home/ctng/x-tools/HOST-${SAMPLE_NAME}/${SAMPLE_NAME} /opt/${SAMPLE_NAME}-native





