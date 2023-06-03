set -e

SCRIPT_PATH="$(realpath "${0}")"
PARENT_DIR="$(dirname "${SCRIPT_PATH}")"
SAMPLE_NAME="${1}"

NAME="toolchain-${SAMPLE_NAME}"

case "$SAMPLE_NAME" in
  *x86_64*)
    TOOLCHAIN_PLATFORM="linux/arm64"
    ;;
  *aarch64*)
    TOOLCHAIN_PLATFORM="linux/arm64/v8"
  ;;
  *armv7*)
    TOOLCHAIN_PLATFORM="linux/arm/v7"
  ;;
  *)
    echo -e "Can not determine CPU architecture by SAMPLE_NAME: '${SAMPLE_NAME}'"
    exit 1
  ;;
esac

case "$SAMPLE_NAME" in
  *-gnu*)
    DISTRO="ubuntu"
    ;;
  *-musl*)
    DISTRO="alpine"
  ;;
  *)
    echo -e "Can not determine distro by SAMPLE_NAME: '${SAMPLE_NAME}'"
    exit 1
  ;;
esac

GHA_SCOPE="toolchain-8"

docker buildx build -t "${NAME}" \
  --build-arg="SAMPLE_NAME=${SAMPLE_NAME}" \
  --build-arg="DISTRO=${DISTRO}" \
  --build-arg="TOOLCHAIN_TYPE=cross" \
  --build-arg="TOOLCHAIN_PLATFORM=${TOOLCHAIN_PLATFORM}" \
  --cache-from="type=gha,scope=${GHA_SCOPE}-${SAMPLE_NAME}" \
  --cache-to=type="gha,mode=min,scope=${GHA_SCOPE}-${SAMPLE_NAME}" \
  "${PARENT_DIR}" --progress=plain --load

