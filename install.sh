#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PREFIX="${PREFIX:-$HOME/.local/bin}"
INSTALL_ROOT="${INSTALL_ROOT:-$HOME/.local/share/codex-switch}"

mkdir -p "$PREFIX"
mkdir -p "$INSTALL_ROOT"

install_file() {
  local name="$1"
  install -m 0755 "$ROOT_DIR/$name" "$INSTALL_ROOT/$name"
}

install_doc() {
  local name="$1"
  install -m 0644 "$ROOT_DIR/$name" "$INSTALL_ROOT/$name"
}

link_bin() {
  local name="$1"
  ln -sf "$INSTALL_ROOT/$name" "$PREFIX/$name"
}

install_doc LICENSE
install_doc CHANGELOG.md
install_doc README.md
install_doc SECURITY.md
install_doc VERSION
install_doc .gitignore

install_file codex-switch
install_file cx-add
install_file cx-use
install_file cx-save
install_file cx-list
install_file cx-current
install_file cx-del
install_file cx-edit
install_file release.sh
install_file uninstall.sh

link_bin codex-switch
link_bin cx-add
link_bin cx-use
link_bin cx-save
link_bin cx-list
link_bin cx-current
link_bin cx-del
link_bin cx-edit

cat <<EOF
OK: installed to $INSTALL_ROOT
OK: installed symlinks into $PREFIX
- codex-switch
- cx-add cx-use cx-save cx-list cx-current cx-del cx-edit

Make sure $PREFIX is in PATH.
EOF
