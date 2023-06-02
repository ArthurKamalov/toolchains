
SCRIPT_PATH="${0}"
BUILD_DIR="$(dirname "${SCRIPT_PATH}")"
SOURCE_ROOT="$(dirname "${BUILD_DIR}")"
SAMPLE_NAME="${1}"

NAME="toolchain-${SAMPLE_NAME}"

docker buildx build -t "${NAME}" --load --build-arg="SAMPLE_NAME=${SAMPLE_NAME}" --cache-from=type=gha --cache-to=type=gha "${BUILD_DIR}/docker"

docker rm -f "${NAME}"
docker create --name "${NAME}" "${NAME}"
docker cp "${NAME}:/tmp/${SAMPLE_NAME}-native.tar.gz" "${SOURCE_ROOT}"
docker cp "${NAME}:/tmp/${SAMPLE_NAME}-cross.tar.gz" "${SOURCE_ROOT}"

docker rm "${NAME}"

