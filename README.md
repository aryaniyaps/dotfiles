# Aryan Iyappan's dotfiles

This is a fully automated development environment setup managed by [chezmoi](https://github.com/twpayne/chezmoi). It provides a complete shell configuration and tooling setup that can be deployed with a single command on any Linux system.

<p align="left">
  <img src=".github/banner.png" alt="Dottler dotfiles banner"  height="260" />
  <p><em>Dotfile wrangler extraordinaire! 🧠📁 Managing your configs like a psychic boss—no more config chaos!</em></p>
</p>

## Supported distros

| Distro / family | Package manager path | CI status |
|---|---|---|
| Ubuntu | `apt` | [![ubuntu](https://img.shields.io/github/actions/workflow/status/aryaniyaps/dotfiles/chezmoi-apply-linux.yml?branch=main&event=push&job=ubuntu&label=ubuntu)](https://github.com/aryaniyaps/dotfiles/actions/workflows/chezmoi-apply-linux.yml) |
| Debian | `apt` | [![debian](https://img.shields.io/github/actions/workflow/status/aryaniyaps/dotfiles/chezmoi-apply-linux.yml?branch=main&event=push&job=debian&label=debian)](https://github.com/aryaniyaps/dotfiles/actions/workflows/chezmoi-apply-linux.yml) |
| Fedora | `dnf` | [![fedora](https://img.shields.io/github/actions/workflow/status/aryaniyaps/dotfiles/chezmoi-apply-linux.yml?branch=main&event=push&job=fedora&label=fedora)](https://github.com/aryaniyaps/dotfiles/actions/workflows/chezmoi-apply-linux.yml) |
| Arch Linux | `pacman` | [![arch](https://img.shields.io/github/actions/workflow/status/aryaniyaps/dotfiles/chezmoi-apply-linux.yml?branch=main&event=push&job=arch&label=arch)](https://github.com/aryaniyaps/dotfiles/actions/workflows/chezmoi-apply-linux.yml) |

> These badges are dynamic and show the latest status (pass/fail) of the relevant distro job in `chezmoi-apply-linux.yml` on `main`.

## Quickstart

Deploy the entire setup on a fresh Linux instance with one command:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply aryaniyaps
```

Sit back and watch your environment get configured automatically!


### Git identity prompt during `chezmoi init`

On first `chezmoi init`, chezmoi prompts for your Git name and email, validates them (non-empty name, email format), and stores them in your chezmoi config data. `~/.gitconfig` is then rendered automatically from that data.

If you need to update those values later, run:

```bash
chezmoi update --init --apply
```

## What's Included

### Declarative base packages (per distro)
Installed by `run_once_before_00_install_packages.sh.tmpl`:

- **apt/debian/ubuntu**: `git`, `zsh`, `curl`, `tmux`, `fzf`, `zoxide`, `golang-go`
- **pacman/arch**: `git`, `zsh`, `curl`, `tmux`, `fzf`, `zoxide`, `go`
- **dnf/fedora**: `git`, `zsh`, `curl`, `tmux`, `fzf`, `zoxide`, `golang`

### Installed tooling (bootstrap scripts)
- **zinit** (loads Oh My Zsh theme/plugins + community plugins)
- **nvm**
- **Node.js LTS** + **npm**
- **pnpm** (via Corepack when available)
- **uv**
- **Python 3.14** (via `uv python install 3.14`)
- **Docker Engine** + **Docker Compose** (`docker compose` plugin or `docker-compose` fallback)
- **GitHub CLI (`gh`)**

### Shell and editor environment
- **ZSH** with **zinit**
- Sets **zsh** as the default login shell during installation (interactive sessions)
- Theme: **robbyrussell**
- **tmux** configuration (`dot_tmux.conf`, mouse enabled)
- PATH wiring for `~/.local/bin`, `nvm`, and Go workspace binaries

### Plugins enabled (loaded via zinit)
- Version control: `git`
- Cloud/infra: `docker`, `docker-compose`, `terraform`, `aws`, `gcloud`, `azure`
- Language/tooling: `python`, `pip`, `node`, `npm`, `yarn`, `golang`, `rust`, `fzf`
- Distro-specific (conditional): `archlinux` (Arch), `debian` (Debian), `ubuntu` (Ubuntu)
- Productivity: `sudo`, `extract`, `z`, `history`, `command-not-found`, `vscode`
- Community plugins: `zsh-autosuggestions`, `zsh-completions`, `zsh-syntax-highlighting`

### Language/runtime config included
- **Go**: defaults for `$GOPATH` and `$GOBIN`, with `$GOBIN` added to `PATH`
- **Node**: `nvm` initialized in shell startup
- **Python**: `uv` in `PATH` for Python/tool management

### Verification included
`run_once_after_99_verify_tooling.sh` checks:
- `node`, `npm`, `pnpm`
- `gh`, `tmux`, `fzf`
- `docker` + compose availability
- `uv` + Python 3.14 availability via `uv`
- `go` installation plus `go env` + zsh PATH/GOBIN integration

## Script execution model (chezmoi)

This repo follows chezmoi script phase attributes for deterministic bootstrap:

- `run_once_before_*` - one-time bootstrap/install tasks before dotfiles are applied
- `run_onchange_after_*` - post-apply tasks that run when script content changes
- `run_once_after_*` - one-time post-setup validation/check tasks

Scripts are executed alphabetically within each phase (numbered prefixes are intentional).

## Requirements

- Linux system (tested on Ubuntu, Debian, Fedora, Arch)
- Internet connection for initial download
- `curl` available in the base system