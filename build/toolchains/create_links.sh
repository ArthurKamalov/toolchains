#!/usr/bin/env bash

set -e

TOOLCHAIN_PATH="${1}"
TOOLCHAIN_NAME="${2}"

for file_path in "${TOOLCHAIN_PATH}/bin"/*; do
  filename="$(basename "${file_path}")"

  ln -s "${filename}" "${TOOLCHAIN_PATH}/bin/${filename//${TOOLCHAIN_NAME}-/}"
done

