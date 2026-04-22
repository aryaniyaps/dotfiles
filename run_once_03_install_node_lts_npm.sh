#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Linux" ]]; then
  exit 0
fi

NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
export NVM_DIR

if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
  echo "nvm is required but not found at $NVM_DIR."
  exit 1
fi

# shellcheck disable=SC1090
source "$NVM_DIR/nvm.sh"

echo "Installing Node.js LTS (includes npm)..."
nvm install --lts --latest-npm
nvm alias default 'lts/*'
nvm use default >/dev/null
