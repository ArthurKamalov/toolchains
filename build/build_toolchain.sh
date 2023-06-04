set -e

SCRIPT_PATH="$(realpath "${0}")"
PARENT_DIR="$(dirname "${SCRIPT_PATH}")"
HOST="${1}"
TARGET="${2}"

case "$HOST" in
  x86_64-*-*-*)
    TOOLCHAIN_PLATFORM="linux/amd64"
    ;;
  *aarch64-*-*-*)
    TOOLCHAIN_PLATFORM="linux/arm64/v8"
  ;;
  *armv7-*-*-*)
    TOOLCHAIN_PLATFORM="linux/arm/v7"
  ;;
  *)
    echo -e "Can not determine CPU architecture by HOST: '${HOST}'"
    exit 1
  ;;
esac

case "$HOST" in
  *-*-*-gnu*)
    DISTRO="ubuntu"
    ;;
  *-*-*-musl*)
    DISTRO="alpine"
  ;;
  *)
    echo -e "Can not determine distro by HOST: '${HOST}'"
    exit 1
  ;;
esac

GHA_SCOPE="toolchain-${HOST}-${TARGET}-8"

docker buildx build \
  --build-arg="HOST=${HOST}" \
  --build-arg="TARGET=${TARGET}" \
  --build-arg="DISTRO=${DISTRO}" \
  --build-arg="TOOLCHAIN_TYPE=native" \
  --build-arg="TOOLCHAIN_PLATFORM=${TOOLCHAIN_PLATFORM}" \
  --cache-from="type=gha,scope=${GHA_SCOPE}" \
  --cache-to=type="gha,mode=min,scope=${GHA_SCOPE}" \
  --progress=plain \
  "$@" \
  "${PARENT_DIR}"

