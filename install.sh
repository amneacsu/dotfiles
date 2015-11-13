#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(pwd)"

FILES=(
  .bashrc.d
  .config/mpv/input.conf
  .config/mpv/mpv.conf
  .config/kcminputrc
  .config/kwinrc
  .config/kglobalshortcutsrc
  .config/doublecmd/doublecmd.xml
  .config/plasmaparc
  .editorconfig
  .gitconfig
  .gitignore
  .npmrc
  .var/app/com.visualstudio.code/config/Code/User/keybindings.json
  .var/app/com.visualstudio.code/config/Code/User/settings.json
  .var/app/com.visualstudio.code/config/Code/User/tasks.json
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
