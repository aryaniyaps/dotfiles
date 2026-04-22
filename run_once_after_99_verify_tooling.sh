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

if command -v fzf >/dev/null 2>&1; then
  ok "fzf $(fzf --version | head -n1)"
else
  fail "fzf is not installed"
fi

if command -v zoxide >/dev/null 2>&1; then
  ok "zoxide $(zoxide --version)"
else
  fail "zoxide is not installed"
fi

if command -v xdg-open >/dev/null 2>&1; then
  ok "xdg-open is available (browser link opener)"
else
  fail "xdg-open is not installed (install xdg-utils)"
fi

if command -v zsh >/dev/null 2>&1; then
  zsh_path="$(command -v zsh)"
  login_shell=""

  if command -v getent >/dev/null 2>&1; then
    login_shell="$(getent passwd "$USER" | cut -d: -f7 || true)"
  fi
  if [[ -z "$login_shell" ]]; then
    login_shell="${SHELL:-}"
  fi

  if [[ "$login_shell" == */zsh && -x "$login_shell" ]]; then
    ok "default login shell is zsh ($login_shell)"
  else
    echo "[WARN] default login shell is '$login_shell' (expected a zsh path, e.g. '$zsh_path')" >&2
  fi
else
  fail "zsh is not installed"
fi

if command -v docker >/dev/null 2>&1; then
  ok "docker $(docker --version)"
else
  fail "docker is not installed"
fi

if docker compose version >/dev/null 2>&1; then
  ok "docker compose $(docker compose version --short 2>/dev/null || docker compose version)"
elif command -v docker-compose >/dev/null 2>&1; then
  ok "docker-compose $(docker-compose --version)"
else
  fail "docker compose is not installed"
fi

if command -v uv >/dev/null 2>&1; then
  ok "uv $(uv --version)"
else
  fail "uv is not installed"
fi

if [[ -n "${GOROOT:-}" && ! -d "$GOROOT" ]]; then
  echo "[WARN] GOROOT is set to a missing directory ($GOROOT); unsetting for verification" >&2
  unset GOROOT
fi

if command -v go >/dev/null 2>&1; then
  if go version >/dev/null 2>&1; then
    ok "go $(go version)"
  else
    fail "go is installed but not runnable (check GOROOT/GOPATH)"
  fi
else
  fail "go is not installed"
fi

if command -v go >/dev/null 2>&1; then
  if go env GOPATH >/dev/null 2>&1 && go env GOROOT >/dev/null 2>&1; then
    ok "go env works in non-interactive shell"
  else
    fail "go env failed in non-interactive shell"
  fi

  if command -v zsh >/dev/null 2>&1; then
    if zsh -ic 'command -v go >/dev/null 2>&1 && go env GOPATH >/dev/null 2>&1 && go env GOBIN >/dev/null 2>&1 && gobin="$(go env GOBIN)" && [[ -n "$gobin" && ":$PATH:" == *":$gobin:"* ]]' >/dev/null 2>&1; then
      ok "go env and GOBIN PATH wiring work in zsh"
    else
      fail "go env or GOBIN PATH wiring failed in zsh"
    fi
  fi
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
