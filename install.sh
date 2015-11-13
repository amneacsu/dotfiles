#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(pwd)"

FILES=(
  .config/mpv/input.conf
  .editorconfig
  .gitconfig
  .gitignore
  .npmrc
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
