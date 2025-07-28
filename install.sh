#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(pwd)"

FILES=(
  .gitconfig
  .config/krusaderrc
  .bashrc.d
)

echo "🔗 Linking dotfiles from $DOTFILES_DIR"

for file in "${FILES[@]}"; do
  target="$HOME/$file"
  source="$DOTFILES_DIR/$file"

  if [[ -e "$target" || -L "$target" ]]; then
    echo "❌ Removing existing $target"
    rm -rf "$target"
  fi

  echo "➡️  Linking $file"
  mkdir -p "$(dirname "$target")"
  ln -s "$source" "$target"
done

echo "✅ Dotfiles installed."

