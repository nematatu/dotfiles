#!/usr/bin/env bash
set -euo pipefail

REPO="linux-jm/manual"

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
INSTALL_DIR="${DOTFILES_DIR}/man/ja"
WORK_DIR="${TMPDIR:-/tmp}/jm-manual"

mkdir -p "$INSTALL_DIR"
rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR"

cd "$WORK_DIR"

ASSET_URL="$(
  curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" |
    grep '"browser_download_url":' |
    grep 'man-pages-.*\.tar\.gz' |
    sed -E 's/.*"browser_download_url": "([^"]+)".*/\1/' |
    head -n 1
)"

if [[ -z "$ASSET_URL" ]]; then
  echo "Failed to find latest JM manual archive."
  exit 1
fi

ARCHIVE_NAME="$(basename "$ASSET_URL")"

echo "Downloading: $ASSET_URL"
curl -fL -o "$ARCHIVE_NAME" "$ASSET_URL"

tar xf "$ARCHIVE_NAME"

SRC_DIR="$(find . -maxdepth 1 -type d -name 'man-pages-*' | head -n 1)"

if [[ -z "$SRC_DIR" ]]; then
  echo "Failed to find extracted manual directory."
  exit 1
fi

cd "$SRC_DIR"

echo "Install directory:"
echo "  $INSTALL_DIR"
echo

make config
make install
