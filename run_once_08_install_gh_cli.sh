#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Linux" ]]; then
  exit 0
fi

export PATH="$HOME/.local/bin:$PATH"

if command -v gh >/dev/null 2>&1; then
  echo "gh CLI already installed, skipping."
  exit 0
fi

case "$(uname -m)" in
  x86_64)
    arch="amd64"
    ;;
  aarch64|arm64)
    arch="arm64"
    ;;
  *)
    echo "Unsupported architecture for gh CLI: $(uname -m)" >&2
    exit 1
    ;;
esac

latest_url="$(curl -fsSLI -o /dev/null -w '%{url_effective}' https://github.com/cli/cli/releases/latest)"
tag="${latest_url##*/}"
version="${tag#v}"

tarball="gh_${version}_linux_${arch}.tar.gz"
url="https://github.com/cli/cli/releases/download/${tag}/${tarball}"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

curl -fsSL "$url" -o "$tmpdir/$tarball"
tar -xzf "$tmpdir/$tarball" -C "$tmpdir"

mkdir -p "$HOME/.local/bin"
install -m 0755 "$tmpdir/gh_${version}_linux_${arch}/bin/gh" "$HOME/.local/bin/gh"

echo "Installed gh CLI: $(gh --version | head -n1)"
