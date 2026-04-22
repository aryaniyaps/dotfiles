# Aryan Iyappan's dotfiles

This is a fully automated development environment setup managed by [chezmoi](https://github.com/twpayne/chezmoi). It provides a complete shell configuration and tooling setup that can be deployed with a single command on any Linux system.

## Quickstart

Deploy the entire setup on a fresh Linux instance with one command:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply aryaniyaps
```

Sit back and watch your environment get configured automatically!

## What's Included

### Shell Environment
- **ZSH** - Zsh shell with Oh My Zsh framework
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
- **git** - Git integration with powerful aliases
- **docker** & **docker-compose** - Container management shortcuts
- **terraform** - Infrastructure-as-code tool completions
- **aws**, **gcloud**, **azure** - Cloud provider CLI support

### Programming Languages & Package Managers
- **python** & **pip** - Python development tools
- **node**, **npm**, **yarn** - JavaScript/Node.js ecosystem
- **golang** - Go language with proper PATH setup
- **rust** - Rust toolchain integration

### Enhanced Features
- **zsh-syntax-highlighting** - Real-time command syntax validation
- **zsh-autosuggestions** - Fish-like auto-completion from history
- **Go configuration** - Pre-configured `$GOPATH`, `$GOROOT`, and `$PATH` exports

## Requirements

- Linux system (tested on Ubuntu, Debian, Fedora)
- Internet connection for initial download
- `curl` available in the base system