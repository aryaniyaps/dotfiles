#!/usr/bin/env bash
set -euo pipefail

set_default_shell_to_zsh() {
  local zsh_path login_shell user shell_for_chsh shells_file

  user="$(id -un)"
  zsh_path="$(command -v zsh || true)"
  if [ -z "$zsh_path" ]; then
    echo "zsh is not installed yet; cannot set default shell."
    return 0
  fi

  login_shell=""
  if command -v getent >/dev/null 2>&1; then
    login_shell="$(getent passwd "$user" | cut -d: -f7 || true)"
  fi
  if [ -z "$login_shell" ]; then
    login_shell="${SHELL:-}"
  fi

  if [ "${login_shell##*/}" = "zsh" ] && [ -x "$login_shell" ]; then
    echo "Default shell is already zsh ($login_shell)."
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

  shell_for_chsh="$zsh_path"
  shells_file="/etc/shells"

  # chsh only accepts shells listed in /etc/shells on most Linux systems.
  if [ -r "$shells_file" ] && ! grep -qxF "$zsh_path" "$shells_file"; then
    echo "Detected zsh at '$zsh_path', but it is not listed in $shells_file."

    if command -v sudo >/dev/null 2>&1; then
      echo "Trying to add '$zsh_path' to $shells_file (may prompt for sudo password once)..."
      if sudo sh -c "grep -qxF '$zsh_path' '$shells_file' || echo '$zsh_path' >> '$shells_file'"; then
        echo "Added '$zsh_path' to $shells_file."
      else
        echo "Warning: Could not add '$zsh_path' to $shells_file."
      fi
    fi

    # If the detected zsh path still isn't allowed, fallback to any allowed zsh path.
    if ! grep -qxF "$zsh_path" "$shells_file"; then
      shell_for_chsh="$(grep -E '/zsh$' "$shells_file" | head -n1 || true)"
      if [ -z "$shell_for_chsh" ]; then
        echo "Warning: No valid zsh entry found in $shells_file; skipping default shell change."
        return 0
      fi
      echo "Using listed zsh shell from $shells_file: $shell_for_chsh"
    fi
  fi

  if [ "$shell_for_chsh" != "$zsh_path" ]; then
    echo "Info: 'command -v zsh' is '$zsh_path', but chsh requires an entry from $shells_file; using '$shell_for_chsh'."
  fi

  echo "Setting default shell to zsh ($shell_for_chsh)..."
  if chsh -s "$shell_for_chsh" "$user"; then
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
