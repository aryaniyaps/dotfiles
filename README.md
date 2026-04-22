# Aryan Iyappan's dotfiles

This is a fully automated development environment setup managed by [chezmoi](https://github.com/twpayne/chezmoi). It provides a complete shell configuration and tooling setup that can be deployed with a single command on any Linux system.

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

### Shell Environment
- **ZSH** - Zsh shell with Oh My Zsh framework
- **tmux** - Terminal multiplexer for persistent and split-pane workflows (mouse enabled by default)
- **Theme** - robbyrussell theme for a clean, minimal prompt
- **Custom PATH** - Optimized for local binaries and development tools

### Productivity Plugins
- **sudo** - Press ESC twice to add `sudo` to the previous command
- **extract** - Universal archive extractor supporting `.tar`, `.zip`, `.gz`, `.rar`, and more
- **z** - Jump to frequently used directories with fuzzy matching
- **history** - Enhanced history search and navigation
- **command-not-found** - Automatically suggests packages for missing commands
- **vscode** - VS Code aliases and workspace shortcuts

### Version Control & DevOps
- **git** - Automatically configured via `~/.gitconfig` template
- **gh** - GitHub CLI (installed via upstream release tarball for broad distro compatibility)
- **docker** & **docker-compose** - Container management shortcuts
- **terraform** - Infrastructure-as-code tool completions
- **aws**, **gcloud**, **azure** - Cloud provider CLI support

### Programming Languages & Package Managers
- **Python 3.14** (via `uv`) & **pip** - Python development tools
- **Node.js LTS** & **npm** - JavaScript runtime and package management
- **pnpm** - Fast, disk-efficient package manager
- **uv** - Ultra-fast Python package/project manager and Python installer
- **yarn** - JavaScript package manager
- **golang** - Go language with proper PATH setup
- **rust** - Rust toolchain integration

### Enhanced Features
- **zsh-syntax-highlighting** - Real-time command syntax validation
- **zsh-autosuggestions** - Fish-like auto-completion from history
- **Go configuration** - Pre-configured `$GOPATH`, `$GOROOT`, and `$PATH` exports

## Requirements

- Linux system (tested on Ubuntu, Debian, Fedora, Arch)
- Internet connection for initial download
- `curl` available in the base system