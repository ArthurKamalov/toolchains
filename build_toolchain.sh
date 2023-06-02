
SCRIPT_PATH="${0}"
PARENT_DIR="$(dirname "${SCRIPT_PATH}")"
SAMPLE_NAME="${1}"

NAME="toolchain-${SAMPLE_NAME}"

docker buildx build -t "${NAME}" --build-arg="SAMPLE_NAME=${SAMPLE_NAME}" "${PARENT_DIR}/build"

docker rm -f "${NAME}"
docker create --name "${NAME}" "${NAME}"
docker cp "${NAME}:/tmp/${SAMPLE_NAME}-native.tar.gz" "${PARENT_DIR}"
docker cp "${NAME}:/tmp/${SAMPLE_NAME}-cross.tar.gz" "${PARENT_DIR}"

docker rm "${NAME}"

