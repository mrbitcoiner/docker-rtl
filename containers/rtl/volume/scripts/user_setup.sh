#!/usr/bin/env bash
####################
set -e
####################
readonly CONTAINER_USER="${1}"
readonly CONTAINER_UID="${2}"
readonly CONTAINER_GID="${3}"
####################

if [ -z "${CONTAINER_USER}" ] || [ -z "${CONTAINER_UID}" ] || [ -z "${CONTAINER_GID}" ]; then
    printf "Expected: [ username ] [ user_id ] [ group_id ]";
    exit 1
fi

groupadd -g ${CONTAINER_GID} -o ${CONTAINER_USER}
useradd -m -u ${CONTAINER_UID} -g ${CONTAINER_GID} -o -s /bin/bash ${CONTAINER_USER}
