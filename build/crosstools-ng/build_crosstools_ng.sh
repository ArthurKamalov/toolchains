SCRIPT_PATH="${0}"
PARENT_DIR="$(dirname "${SCRIPT_PATH}")"

CROSSTOOLS_SCOPE="crosstools-ng-7"

docker buildx build \
  --cache-from="type=gha,scope=$CROSSTOOLS_SCOPE" \
  --cache-to=type="gha,mode=min,scope=$CROSSTOOLS_SCOPE" \
  "$@" \
  "${PARENT_DIR}"

