#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Linux" ]]; then
  exit 0
fi

ok() {
  echo "[OK] $1"
}

fail() {
  echo "[FAIL] $1" >&2
  FAILED=1
}

FAILED=0

# Ensure nvm/Node are available in this non-interactive shell.
NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  # shellcheck disable=SC1090
  source "$NVM_DIR/nvm.sh"
  nvm use default >/dev/null 2>&1 || true
fi

if command -v node >/dev/null 2>&1; then
  ok "node $(node -v)"
else
  fail "node is not installed"
fi

if command -v npm >/dev/null 2>&1; then
  ok "npm $(npm -v)"
else
  fail "npm is not installed"
fi

if command -v pnpm >/dev/null 2>&1; then
  ok "pnpm $(pnpm -v)"
else
  fail "pnpm is not installed"
fi

export PATH="$HOME/.local/bin:$PATH"

if command -v gh >/dev/null 2>&1; then
  ok "gh $(gh --version | head -n1)"
else
  fail "gh CLI is not installed"
fi

if command -v tmux >/dev/null 2>&1; then
  ok "tmux $(tmux -V)"
else
  fail "tmux is not installed"
fi

if command -v uv >/dev/null 2>&1; then
  ok "uv $(uv --version)"
else
  fail "uv is not installed"
fi

if command -v uv >/dev/null 2>&1; then
  if uv python find 3.14 >/dev/null 2>&1; then
    ok "Python 3.14 is installed (managed by uv)"
  else
    fail "Python 3.14 not found via uv"
  fi
fi

if [[ "$FAILED" -ne 0 ]]; then
  echo "Tooling verification failed." >&2
  exit 1
fi

echo "All requested tooling verified successfully."
