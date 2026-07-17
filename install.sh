#!/usr/bin/env bash

set -Eeuo pipefail

readonly REPOSITORY_ARCHIVE="https://github.com/otniel-bit/mac-bootstrap/archive/refs/heads/main.tar.gz"

if [[ "$(uname -s)" != "Darwin" ]]; then
  printf 'This installer is intended for macOS.\n' >&2
  exit 1
fi

bootstrap_dir="$(mktemp -d "${TMPDIR:-/tmp}/mac-bootstrap.XXXXXX")"

cleanup() {
  rm -rf "${bootstrap_dir}"
}
trap cleanup EXIT

printf '\n==> Downloading the Mac bootstrap repository\n'
curl -fsSL "${REPOSITORY_ARCHIVE}" | tar -xz -C "${bootstrap_dir}"

bash "${bootstrap_dir}/mac-bootstrap-main/bootstrap.sh" "$@"
