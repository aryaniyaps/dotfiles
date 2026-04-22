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

set_default_shell_to_zsh

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo ".oh-my-zsh already found, skipping."
fi

# Ensure required Oh My Zsh community plugins are present.
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$ZSH_CUSTOM/plugins"

sync_plugin() {
  local repo="$1"
  local target="$2"
  if [ ! -d "$target/.git" ]; then
    git clone --depth 1 "$repo" "$target"
  else
    git -C "$target" pull --ff-only || true
  fi
}

sync_plugin "https://github.com/zsh-users/zsh-autosuggestions" "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
sync_plugin "https://github.com/zsh-users/zsh-completions" "$ZSH_CUSTOM/plugins/zsh-completions"
sync_plugin "https://github.com/zsh-users/zsh-syntax-highlighting" "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
