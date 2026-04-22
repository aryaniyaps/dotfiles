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
# NOTE: --latest-npm can fail on some fresh installs (Arch/Fedora CI) with:
# "Unable to obtain node version. Detected node version none".
# Use bundled npm from the LTS release for reliability.
if ! nvm install --lts; then
  echo "Initial nvm install failed, cleaning npm cache and retrying..."
  npm cache clean --force >/dev/null 2>&1 || true
  nvm install --lts
fi

nvm alias default 'lts/*'
nvm use default >/dev/null

# Verify tooling is usable in this non-interactive shell.
node -v
npm -v
