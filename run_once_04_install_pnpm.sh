#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Linux" ]]; then
  exit 0
fi

NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
export NVM_DIR

if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  # shellcheck disable=SC1090
  source "$NVM_DIR/nvm.sh"
  nvm use default >/dev/null 2>&1 || true
fi

if ! command -v npm >/dev/null 2>&1; then
  echo "npm is required to install/activate pnpm."
  exit 1
fi

if command -v corepack >/dev/null 2>&1; then
  echo "Enabling corepack and activating pnpm..."
  corepack enable
  corepack prepare pnpm@latest --activate
else
  echo "corepack not found; installing pnpm via npm..."
  npm install -g pnpm
fi
