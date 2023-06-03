ARG SAMPLE_NAME
ARG DISTRO

FROM crosstools_ng as build

ARG SAMPLE_NAME
ARG CANADIAN_SAMPLE="${SAMPLE_NAME},${SAMPLE_NAME}"

WORKDIR /home/ctng
ADD samples/${SAMPLE_NAME} samples/${SAMPLE_NAME}

USER root
RUN chown -R ctng samples

USER ctng

RUN ct-ng ${SAMPLE_NAME}
RUN ct-ng build --quiet -j "$(nproc)"
RUN ct-ng distclean


RUN cp -a "samples/${SAMPLE_NAME}" "samples/${CANADIAN_SAMPLE}"
RUN echo "CT_CANADIAN=y" >> "samples/${CANADIAN_SAMPLE}/crosstool.config"
RUN echo 'CT_HOST="${SAMPLE_NAME}"' >> "samples/${CANADIAN_SAMPLE}/crosstool.config"


ENV PATH="/home/ctng/x-tools/${SAMPLE_NAME}/bin:${PATH}"
RUN ct-ng "${CANADIAN_SAMPLE}"
RUN ct-ng build --quiet -j "$(nproc)"
RUN ct-ng distclean


#USER root
#ADD create_links.sh /tmp/create_links.sh
#RUN bash /tmp/create_links.sh "/home/ctng/x-tools/${SAMPLE_NAME}" "${SAMPLE_NAME}"
#RUN bash /tmp/create_links.sh "/home/ctng/x-tools/HOST-${SAMPLE_NAME}/${SAMPLE_NAME}" "${SAMPLE_NAME}"

FROM ubuntu:22.04


COPY --from=build /home/ctng/x-tools/${SAMPLE_NAME} /opt/cross/${SAMPLE_NAME}
COPY --from=build /home/ctng/x-tools/HOST-${SAMPLE_NAME}/${SAMPLE_NAME} /opt/native/${SAMPLE_NAME}







#FROM ubuntu:22.04 as distro-ubuntu
#
#FROM alpine:3.18 as distro-alpine
#
#FROM distro-$DISTRO
#
#ARG SAMPLE_NAME
#COPY --from=build /home/ctng/x-tools/${SAMPLE_NAME} /opt/${SAMPLE_NAME}-cross
#COPY --from=build /home/ctng/x-tools/HOST-${SAMPLE_NAME}/${SAMPLE_NAME} /opt/${SAMPLE_NAME}-native





