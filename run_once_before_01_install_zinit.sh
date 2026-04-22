#!/usr/bin/env bash
set -euo pipefail

set_default_shell_to_zsh() {
  local zsh_path current_shell

  zsh_path="$(command -v zsh || true)"
  if [ -z "$zsh_path" ]; then
    echo "zsh is not installed yet; cannot set default shell."
    return 0
  fi

  current_shell="${SHELL:-}"
  if [ -z "$current_shell" ] && command -v getent >/dev/null 2>&1; then
    current_shell="$(getent passwd "${USER}" | cut -d: -f7 || true)"
  fi

  if [ "$current_shell" = "$zsh_path" ]; then
    echo "Default shell is already zsh ($zsh_path)."
    return 0
  fi

  if [ ! -t 0 ]; then
    echo "No interactive TTY detected; skipping default shell change to zsh."
    return 0
  fi

  if ! command -v chsh >/dev/null 2>&1; then
    echo "chsh is not available; cannot set default shell automatically."
    return 0
  fi

  echo "Setting default shell to zsh ($zsh_path)..."
  if chsh -s "$zsh_path" "$USER"; then
    echo "Default shell updated to zsh."
  else
    echo "Warning: Failed to set default shell to zsh automatically."
  fi
}

install_zinit() {
  local zinit_home
  zinit_home="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

  if [ -f "$zinit_home/zinit.zsh" ]; then
    echo "zinit already installed at $zinit_home, skipping."
    return 0
  fi

  echo "Installing zinit to $zinit_home..."
  mkdir -p "$(dirname "$zinit_home")"
  git clone https://github.com/zdharma-continuum/zinit.git "$zinit_home"
}

set_default_shell_to_zsh
install_zinit
