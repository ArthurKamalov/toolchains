ARG SAMPLE_NAME
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

ARG SAMPLE_NAME
ARG CANADIAN_SAMPLE="${SAMPLE_NAME},${SAMPLE_NAME}"

WORKDIR /home/ctng
ADD samples/${SAMPLE_NAME} samples/${SAMPLE_NAME}

USER root
RUN chown -R ctng samples

USER ctng

RUN ct-ng ${SAMPLE_NAME}
RUN ct-ng build --quiet -j "$(nproc)"


RUN cp -a "samples/${SAMPLE_NAME}" "samples/${CANADIAN_SAMPLE}"
RUN echo "CT_CANADIAN=y" >> "samples/${CANADIAN_SAMPLE}/crosstool.config"
RUN echo 'CT_HOST="${SAMPLE_NAME}"' >> "samples/${CANADIAN_SAMPLE}/crosstool.config"


ENV PATH="/home/ctng/x-tools/${SAMPLE_NAME}/bin:${PATH}"
RUN ct-ng "${CANADIAN_SAMPLE}"
RUN ct-ng build --quiet -j "$(nproc)"


FROM --platform=${TOOLCHAIN_PLATFORM} ubuntu:22.04 as toolchain_cross_ubuntu
COPY --from=build /home/ctng/x-tools/${SAMPLE_NAME} /opt/${SAMPLE_NAME}

FROM --platform=${TOOLCHAIN_PLATFORM} ubuntu:22.04 as toolchain_native_ubuntu
COPY --from=build /home/ctng/x-tools/HOST-${SAMPLE_NAME}/${SAMPLE_NAME} /opt/${SAMPLE_NAME}

FROM --platform=${TOOLCHAIN_PLATFORM} alpine:3.18 as toolchain_native_alpine
COPY --from=build /home/ctng/x-tools/HOST-${SAMPLE_NAME}/${SAMPLE_NAME} /opt/${SAMPLE_NAME}

FROM toolchain_${TOOLCHAIN_TYPE}_${DISTRO}





#FROM ubuntu:22.04 as distro-ubuntu
#
#FROM alpine:3.18 as distro-alpine
#
#FROM distro-$DISTRO
#
#ARG SAMPLE_NAME
#COPY --from=build /home/ctng/x-tools/${SAMPLE_NAME} /opt/${SAMPLE_NAME}-cross
#COPY --from=build /home/ctng/x-tools/HOST-${SAMPLE_NAME}/${SAMPLE_NAME} /opt/${SAMPLE_NAME}-native





