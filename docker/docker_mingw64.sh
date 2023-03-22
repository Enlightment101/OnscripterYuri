# export SKIP_PORTS=yes && ./docker_mingw64.sh

PROJECT_PATH=$(pwd)/..
DOCKER_TYPE=mingw64
DOCKER_IMAGE=onsyuri_${DOCKER_TYPE}
DOCKER_RUN=${DOCKER_IMAGE}_run
DOKCER_FILE=Dockerfile_${DOCKER_TYPE}

if [ -z "$(docker images | grep ${DOCKER_IMAGE})" ]; then 
    docker build -f ${DOKCER_FILE} -t ${DOCKER_IMAGE} ./
fi

if [ -z "$(docker ps | grep ${DOCKER_RUN})" ]; then
    docker run -d -it --rm -v ${PROJECT_PATH}:/project \
        --name ${DOCKER_RUN} ${DOCKER_IMAGE} bash
fi

docker exec -i -e TARGETS=$@ \
    -e BUILD_TYPE=$BUILD_TYPE -e SKIP_PORTS=$SKIP_PORTS \
     ${DOCKER_RUN} bash -c "cd /project/script && bash cross_mingw64.sh"

docker exec -i -e TARGETS=$@ \
    -e BUILD_TYPE=$BUILD_TYPE -e SKIP_PORTS=$SKIP_PORTS \
     ${DOCKER_RUN} bash -c "cd /project/script && bash cross_mingw32.sh"