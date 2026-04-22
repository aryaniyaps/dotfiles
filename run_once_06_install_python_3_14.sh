#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Linux" ]]; then
  exit 0
fi

export PATH="$HOME/.local/bin:$PATH"

if ! command -v uv >/dev/null 2>&1; then
  echo "uv is required to install Python 3.14."
  exit 1
fi

echo "Installing Python 3.14 via uv..."
uv python install 3.14
