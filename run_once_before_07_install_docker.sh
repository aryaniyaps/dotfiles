#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Linux" ]]; then
  exit 0
fi

if [[ -r /etc/os-release ]]; then
  # shellcheck disable=SC1091
  source /etc/os-release
else
  echo "Cannot detect Linux distribution (/etc/os-release missing). Skipping Docker installation."
  exit 0
fi

manager=""

case "${ID:-}" in
  ubuntu|debian)
    manager="apt-get"
    ;;
  arch)
    manager="pacman"
    ;;
  fedora)
    manager="dnf"
    ;;
esac

if [[ -z "$manager" && -n "${ID_LIKE:-}" ]]; then
  for like in $ID_LIKE; do
    case "$like" in
      debian)
        manager="apt-get"
        break
        ;;
      arch)
        manager="pacman"
        break
        ;;
      fedora)
        manager="dnf"
        break
        ;;
    esac
  done
fi

has_docker=0
has_compose=0

if command -v docker >/dev/null 2>&1; then
  has_docker=1
  if docker compose version >/dev/null 2>&1; then
    has_compose=1
  fi
fi

if [[ "$has_compose" -eq 0 ]] && command -v docker-compose >/dev/null 2>&1; then
  has_compose=1
fi

if [[ "$has_docker" -eq 1 && "$has_compose" -eq 1 ]]; then
  echo "Docker and Docker Compose already installed."
  exit 0
fi

install_ok=0

case "$manager" in
  apt-get)
    sudo apt-get update -y
    if sudo apt-get install -y docker.io docker-compose-v2; then
      install_ok=1
    elif sudo apt-get install -y docker.io docker-compose-plugin; then
      install_ok=1
    elif sudo apt-get install -y docker.io docker-compose; then
      install_ok=1
    fi
    ;;
  pacman)
    if sudo pacman -Sy --noconfirm --needed docker docker-compose; then
      install_ok=1
    fi
    ;;
  dnf)
    if sudo dnf install -y docker docker-compose-plugin; then
      install_ok=1
    elif sudo dnf install -y moby-engine docker-compose; then
      install_ok=1
    elif sudo dnf install -y moby-engine docker-compose-plugin; then
      install_ok=1
    fi
    ;;
  "")
    echo "No package-manager mapping for distro '${ID:-unknown}'. Skipping Docker installation."
    exit 0
    ;;
esac

if [[ "$install_ok" -ne 1 ]]; then
  echo "Failed to install Docker and Docker Compose for manager '$manager'." >&2
  exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker install appears incomplete: 'docker' command not found." >&2
  exit 1
fi

if docker compose version >/dev/null 2>&1; then
  exit 0
fi

if command -v docker-compose >/dev/null 2>&1; then
  exit 0
fi

echo "Docker Compose install appears incomplete: neither 'docker compose' nor 'docker-compose' is available." >&2
exit 1
