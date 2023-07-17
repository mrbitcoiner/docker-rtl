#!/usr/bin/env bash
####################
set -e
####################
if [ -e .env ]; then
  source .env
fi
####################
set_scripts_permissions(){
  if [ -e containers/rtl/volume/scripts/init.sh ]; then
    chmod +x containers/rtl/volume/scripts/*.sh
  fi
}
env_check(){
  if ! [ -e .env ]; then printf 'You must copy .env.example to .env\n' 1>&2; return 1; fi
  if [ -z "${CONTAINER_NAME}" ]; then printf "Undefined env CONTAINER_NAME\n" 1>&2; return 1; fi
  if [ -z "${RTL_EXT_PORT}" ]; then printf "Undefined env RTL_EXT_PORT\n" 1>&2; return 1; fi
  if [ -z "${RTL_INT_PORT}" ]; then printf "Undefined env RTL_INT_PORT\n" 1>&2; return 1; fi
  if [ -z "${NETWORK}" ]; then printf "Undefined env NETWORK\n" 1>&2; return 1; fi
}
mk_docker_compose(){
  cat << EOF > docker-compose.yml
services:
  rtl:
    container_name: ${CONTAINER_NAME} 
    build: ./containers/rtl
    volumes:
      - ./containers/rtl/volume:/app
    ports:
      - ${RTL_EXT_PORT}:${RTL_INT_PORT}
    environment:
      - RTL_INT_PORT=${RTL_INT_PORT}
    networks:
      - rtl

networks:
  rtl:
    name: ${NETWORK} 
    external: true
EOF
}
create_network(){
  if ! docker network ls | awk '{print $2}' | grep "^${NETWORK}$" > /dev/null; then
    docker network create -d bridge ${NETWORK}
  fi
}
rtl_config_check(){
  if ! [ -e RTL-Config.json ]; then 
    printf 'You must copy the RTL-Config.json.example to RTL-Config.json\n' 1>&2; return 1
  fi 
}
mkdirs(){
  mkdir -p containers/rtl/volume/data/config
  mkdir -p cln_rest_certs
}
copy_rtl_config(){
  cp RTL-Config.json containers/rtl/volume/data/config/RTL-Config.json
}
copy_cln_rest_certs(){
  if ! ls cln_rest_certs/* > /dev/null 2>&1; then 
    printf 'Please, copy the cln_rest certs folder to ./cln_rest_certs/<node_name> and set the respective settings on ./RTL-Config.json\n' \
    1>&2; return 1
  fi
  cp -a cln_rest_certs/* ./containers/rtl/volume/data/certs/
}
up_build_common(){
  set_scripts_permissions
  env_check
  mk_docker_compose
  create_network
  rtl_config_check
  mkdirs
  copy_rtl_config
  copy_cln_rest_certs
}
up(){
  up_build_common
  docker-compose up --remove-orphans &
}
build(){
  up_build_common
  docker-compose build \
    --build-arg CONTAINER_USER=${USER} \
    --build-arg CONTAINER_UID=$(id -u) \
    --build-arg CONTAINER_GID=$(id -g)
  printf 'Image build finished!\n'
}
down(){
  docker-compose down
}
clean(){
  printf 'Are you sure? This will delete all container data. (Y/n): '
  read input
  if [ "${input}" != 'Y' ]; then printf 'Abort!\n' 1>&2; return 1; fi
  rm -rfv containers/rtl/volume/data
}
####################
case ${1} in 
  build) build ;;
  up) up ;;
  down) down ;;
  clean) clean ;;
  *) printf 'Usage: [ build | up | down | clean ]\n' 1>&2; exit 1 ;;
esac
####################
