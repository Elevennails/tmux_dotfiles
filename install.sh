#!/usr/bin/env bash

set -euo pipefail

DOTFILES="$HOME/.tmux_dotfiles"

# Clone the repo if we don't have it locally
if [ ! -d "$DOTFILES" ]; then
  git clone https://github.com/Elevennails/tmux_dotfiles.git "$DOTFILES"
fi

# Symlink config (backup any existing one)
[ -e ~/.tmux.conf ] && [ ! -L ~/.tmux.conf ] && mv ~/.tmux.conf ~/.tmux.conf.bak
ln -sf "$DOTFILES/tmux/.tmux.conf" ~/.tmux.conf

# Install TPM if missing
if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install JetBrainsMono Nerd Font
FONT_DIR="$HOME/.local/share/fonts"
if ! fc-list | grep -qi "JetBrainsMono"; then
  echo "Installing JetBrainsMono Nerd Font..."
  FONT_TMP=$(mktemp -d)
  curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz \
    | tar -xJ -C "$FONT_TMP"
  mkdir -p "$FONT_DIR"
  mv "$FONT_TMP"/*.ttf "$FONT_DIR"/
  rm -rf "$FONT_TMP"
  fc-cache -f "$FONT_DIR"
  echo "JetBrainsMono Nerd Font installed."
else
  echo "JetBrainsMono Nerd Font already installed, skipping."
fi

# Install plugins headlessly (requires a running tmux server)
tmux new-session -d -s setup 2>/dev/null || true
~/.tmux/plugins/tpm/bin/install_plugins
