FROM ubuntu:22.04

ENV DEBIAN_FRONTEND="noninteractive"
RUN apt-get update
RUN apt-get install -y gcc g++ gperf bison flex texinfo help2man make libncurses5-dev \
    python3-dev python3-distutils autoconf automake libtool libtool-bin gawk wget bzip2 xz-utils unzip \
    patch libstdc++6 rsync git meson ninja-build curl gnupg2


ARG CROSSTOOLS_VERSION=1.25.0
RUN wget http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-${CROSSTOOLS_VERSION}.tar.bz2
RUN wget http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-${CROSSTOOLS_VERSION}.tar.bz2.sig

ADD crosstools_ng_public_key.gpg  public_key.gpg
RUN gpg2 --import public_key.gpg

RUN gpg2 --verify crosstool-ng-${CROSSTOOLS_VERSION}.tar.bz2.sig

RUN tar xfv crosstool-ng-${CROSSTOOLS_VERSION}.tar.bz2

WORKDIR crosstool-ng-${CROSSTOOLS_VERSION}

RUN ./configure --prefix=/usr/local
RUN make -j "$(nproc)"
RUN make install

ARG CTNG_UID=1000
ARG CTNG_GID=1000
RUN groupadd -g $CTNG_GID ctng
RUN useradd -d /home/ctng -m -g $CTNG_GID -u $CTNG_UID -s /bin/bash ctng

ARG SAMPLE_NAME
ARG CANADIAN_SAMPLE="${SAMPLE_NAME},${SAMPLE_NAME}"


RUN echo "GGG"

WORKDIR /home/ctng
ADD samples/${SAMPLE_NAME} samples/${SAMPLE_NAME}
RUN echo "CT_ZLIB_SRC_DEVEL=y" >> "samples/${SAMPLE_NAME}/crosstool.config"
RUN echo "CT_LOG_PROGRESS_BAR=n" >> "samples/${SAMPLE_NAME}/crosstool.config"


RUN chown -R ctng /home/ctng

USER ctng
WORKDIR /home/ctng

RUN ct-ng ${SAMPLE_NAME}
#RUN ct-ng build --quiet -j "$(nproc)" STOP=companion_tools_for_build

RUN cp -a "samples/${SAMPLE_NAME}" "samples/${CANADIAN_SAMPLE}"
RUN echo "CT_CANADIAN=y" >> "samples/${CANADIAN_SAMPLE}/crosstool.config"
RUN echo 'CT_HOST="${SAMPLE_NAME}"' >> "samples/${CANADIAN_SAMPLE}/crosstool.config"


#ENV PATH="/home/ctng/x-tools/${SAMPLE_NAME}/bin:${PATH}"
#RUN ct-ng "${CANADIAN_SAMPLE}"
#RUN ct-ng build --quiet -j "$(nproc)"


#USER root
#ADD create_links.sh /tmp/create_links.sh
#RUN bash /tmp/create_links.sh "/home/ctng/x-tools/HOST-${SAMPLE_NAME}/${SAMPLE_NAME}" "${SAMPLE_NAME}"


USER ctng

RUN tar cvfz "/tmp/${SAMPLE_NAME}-cross.tar.gz" -C "/home/ctng/x-tools" "${SAMPLE_NAME}"
#RUN tar cvfz "/tmp/${SAMPLE_NAME}-native.tar.gz" -C "/home/ctng/x-tools/HOST-${SAMPLE_NAME}" "${SAMPLE_NAME}"

#RUN touch "/tmp/${SAMPLE_NAME}-cross.tar.gz"
#RUN touch "/tmp/${SAMPLE_NAME}-native.tar.gz"

