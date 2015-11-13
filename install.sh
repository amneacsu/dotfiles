#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(pwd)"

FILES=(
  .bash_profile
  .config/gh/config.yml
  .config/gh/hosts.yml
  .config/karabiner/karabiner.json
  .config/mpv/input.conf
  .config/mpv/mpv.conf
  .editorconfig
  .gitconfig
  .gitignore
  .inputrc
  .npmrc
  .vimrc
  "Library/Application Support/Code/User/keybindings.json"
  "Library/Application Support/Code/User/settings.json"
  "Library/Application Support/Code/User/tasks.json"
  bin
)

echo "Linking dotfiles from $DOTFILES_DIR"

for file in "${FILES[@]}"; do
  target="$HOME/$file"
  source="$DOTFILES_DIR/$file"

  if [[ -e "$target" || -L "$target" ]]; then
    echo "Removing existing $target"
    rm -r "$target"
  fi

  echo "Linking $file"
  mkdir -p "$(dirname "$target")"
  ln -s "$source" "$target"
done

echo "Dotfiles installed."
