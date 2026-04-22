#!/usr/bin/env bash

set -euo pipefail
DOTFILES="$(cd "$(dirname "$0")" && pwd)"

# symlink config (backup any existing one)
[ -e ~/.tmux.conf ] && [ ! -L ~/.tmux.conf ] && mv ~/.tmux.conf ~/.tmux.conf.bak
ln -sf "$DOTFILES/tmux/.tmux.conf" ~/.tmux.conf

# install TPM if missing
if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# install plugins headlessly
~/.tmux/plugins/tpm/bin/install_plugins

