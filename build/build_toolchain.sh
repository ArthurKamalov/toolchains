
SCRIPT_PATH="${0}"
BUILD_DIR="$(dirname "${SCRIPT_PATH}")"
SOURCE_ROOT="$(dirname "${BUILD_DIR}")"
SAMPLE_NAME="${1}"

NAME="toolchain-${SAMPLE_NAME}"

CROSSTOOLS_SCOPE="crosstools-ng-1"

docker buildx build -t "crossstools-ng" --load \
  --cache-from="type=gha,scope=$CROSSTOOLS_SCOPE" \
  --cache-to=type="gha,mode=min,scope=$CROSSTOOLS_SCOPE" \
  "${BUILD_DIR}/docker/crosstools-ng"


#docker buildx build -t "${NAME}" --load --build-arg="SAMPLE_NAME=${SAMPLE_NAME}" \
#  --cache-from="type=gha,scope=$GITHUB_REF_NAME-${SAMPLE_NAME}-1" \
#  --cache-to=type="gha,mode=min,scope=$GITHUB_REF_NAME-${SAMPLE_NAME}-1" \
#  "${BUILD_DIR}/docker"

#docker rm -f "${NAME}"
#docker create --name "${NAME}" "${NAME}"
#docker cp "${NAME}:/tmp/${SAMPLE_NAME}-native.tar.gz" "${SOURCE_ROOT}"
#docker cp "${NAME}:/tmp/${SAMPLE_NAME}-cross.tar.gz" "${SOURCE_ROOT}"
#
#docker rm "${NAME}"

