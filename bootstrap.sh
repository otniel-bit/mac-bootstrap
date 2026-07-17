#!/usr/bin/env bash

set -Eeuo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly BREWFILE="${SCRIPT_DIR}/Brewfile"

DRY_RUN=false
OPEN_APPS=true

usage() {
  cat <<'EOF'
Usage: ./bootstrap.sh [options]

Options:
  --dry-run       Show what would happen without installing anything.
  --no-open-apps  Do not open Chrome when setup finishes.
  -h, --help      Show this help.
EOF
}

for argument in "$@"; do
  case "${argument}" in
    --dry-run) DRY_RUN=true ;;
    --no-open-apps) OPEN_APPS=false ;;
    -h|--help) usage; exit 0 ;;
    *)
      printf 'Unknown option: %s\n\n' "${argument}" >&2
      usage >&2
      exit 64
      ;;
  esac
done

log() {
  printf '\n==> %s\n' "$1"
}

run() {
  if [[ "${DRY_RUN}" == true ]]; then
    printf 'DRY RUN:'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

if [[ "$(uname -s)" != "Darwin" ]]; then
  printf 'This setup is intended for macOS.\n' >&2
  exit 1
fi

if [[ ! -f "${BREWFILE}" ]]; then
  printf 'Brewfile not found at %s\n' "${BREWFILE}" >&2
  exit 1
fi

log "Preparing this Mac"

if ! xcode-select -p >/dev/null 2>&1; then
  if [[ "${DRY_RUN}" == true ]]; then
    printf 'DRY RUN: xcode-select --install\n'
  else
    xcode-select --install
    cat <<'EOF'

macOS opened the Command Line Tools installer.
Finish that installation, then run this setup again.
EOF
    exit 2
  fi
fi

if ! command -v brew >/dev/null 2>&1; then
  log "Installing Homebrew"
  if [[ "${DRY_RUN}" == true ]]; then
    printf 'DRY RUN: download and run the official Homebrew installer\n'
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
fi

# Homebrew is not automatically placed on PATH in every new shell.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

if [[ "${DRY_RUN}" == false ]] && ! command -v brew >/dev/null 2>&1; then
  printf 'Homebrew installation did not complete successfully.\n' >&2
  exit 1
fi

log "Installing applications and terminal tools"
run brew bundle install --no-upgrade --file "${BREWFILE}"

log "Setting Google Chrome as the default browser"
if [[ "${DRY_RUN}" == true ]]; then
  printf 'DRY RUN: defaultbrowser chrome\n'
elif ! defaultbrowser chrome; then
  cat <<'EOF' >&2
Chrome was installed, but macOS did not accept the automatic default-browser change.
Open System Settings > Desktop & Dock > Default web browser and select Google Chrome.
EOF
fi

if [[ "${OPEN_APPS}" == true ]]; then
  log "Opening Google Chrome for sign-in"
  run open -a "Google Chrome"
fi

cat <<'EOF'

Setup complete.

Finish these interactive steps:
  1. Approve Chrome as the default browser if macOS asks for confirmation.
  2. Sign in to Chrome, Google Drive on the web, and your other applications.
  3. Run `gh auth login` to connect GitHub CLI to your account.

Re-running this script is safe; Homebrew skips items that are already installed.
EOF
