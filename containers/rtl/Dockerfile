FROM debian:bookworm-slim

ARG DEBIAN_FRONTEND=nointeractive
RUN apt update \
  && apt upgrade -y \
  && apt install -y --no-install-recommends \
  wget ca-certificates xz-utils git \
  && echo 'v0.1.0' > /version

ARG CONTAINER_USER
ARG CONTAINER_UID
ARG CONTAINER_GID

ENV CONTAINER_USER=${CONTAINER_USER}
ENV CONTAINER_UID=${CONTAINER_UID}
ENV CONTAINER_GID=${CONTAINER_GID}
ENV PATH=/home/${CONTAINER_USER}/nodejs/nodejs/bin:${PATH}

COPY ./volume/scripts /scripts

RUN /scripts/user_setup.sh ${CONTAINER_USER} ${CONTAINER_UID} ${CONTAINER_GID} \
  && su -c '/scripts/setup_nodejs.sh' ${CONTAINER_USER}

ENTRYPOINT ["/scripts/init.sh"]
