
SCRIPT_PATH="$(realpath "${0}")"
PARENT_DIR="$(dirname "${SCRIPT_PATH}")"
BUILD_DIR="$(dirname "${PARENT_DIR}")"
SAMPLE_NAME="${1}"
DISTRO="${2}"

NAME="toolchain-${SAMPLE_NAME}"

GHA_SCOPE="toolchain-7"

CROSSTOOLS_NG_IMAGE_NAME="crosstools_ng"

OCI_IMAGES_PATH="${PARENT_DIR}/~build"
rm -rf "${OCI_IMAGES_PATH}"
mkdir -p "${OCI_IMAGES_PATH}"
CROSSTOOLS_NG_OCI_IMAGE_PATH="${OCI_IMAGES_PATH}/crosstools_ng"
CROSSTOOLS_NG_OCI_IMAGE_TARBALL_PATH="${CROSSTOOLS_NG_OCI_IMAGE_PATH}.tar"

bash "${BUILD_DIR}/crosstools-ng/build_crosstools_ng.sh" \
  -t "${CROSSTOOLS_NG_IMAGE_NAME}" \
  --output "type=oci,dest=${CROSSTOOLS_NG_OCI_IMAGE_TARBALL_PATH}"

mkdir -p "${CROSSTOOLS_NG_OCI_IMAGE_PATH}"
tar -xf "${CROSSTOOLS_NG_OCI_IMAGE_TARBALL_PATH}" -C "${CROSSTOOLS_NG_OCI_IMAGE_PATH}"

docker buildx build -t "${NAME}" --load \
  --build-arg="SAMPLE_NAME=${SAMPLE_NAME}" \
  --build-arg="DISTRO=${DISTRO}" \
  --cache-from="type=gha,scope=${GHA_SCOPE}-${SAMPLE_NAME}" \
  --cache-to=type="gha,mode=min,scope=${GHA_SCOPE}-${SAMPLE_NAME}" \
  --build-context "crosstools_ng=oci-layout://${CROSSTOOLS_NG_OCI_IMAGE_PATH}" \
  "${PARENT_DIR}" --progress=plain


rm -rf "${OCI_IMAGES_PATH}"

