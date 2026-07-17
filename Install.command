#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
"${SCRIPT_DIR}/bootstrap.sh"

printf '\nYou can close this window. Press Return to finish.\n'
read -r
