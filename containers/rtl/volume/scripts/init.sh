#!/usr/bin/env bash
####################
set -e
####################
su -c '/app/scripts/setup_rtl.sh' ${CONTAINER_USER}
su -c 'node /app/data/rtl/rtl' ${CONTAINER_USER}
