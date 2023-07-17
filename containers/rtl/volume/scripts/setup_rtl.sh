#!/usr/bin/env bash
####################
set -e
####################
readonly RTL_PATH='/app/data/rtl'
readonly RTL_REPO='https://github.com/Ride-The-Lightning/RTL'
# readonly RTL_COMMIT='895b1de27d8505d781b1d4c43b9962581da3dcf0'
readonly RTL_COMMIT='cf0cb040d72cffdcdbb51d23f5e5c669484269a8'
####################
clone_and_install_rtl(){
  if [ -e ${RTL_PATH} ]; then return 0; fi
  git clone ${RTL_REPO} ${RTL_PATH}
  cd ${RTL_PATH}
  git checkout ${RTL_COMMIT}
  npm install --omit=dev --legacy-peer-deps
  npm install request
}
configure_rtl(){
  ln -sf /app/data/config/RTL-Config.json /app/data/rtl/RTL-Config.json  
}
####################
clone_and_install_rtl
configure_rtl

