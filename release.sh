#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION="${VERSION:-}"
if [[ -z "$VERSION" && -f "$ROOT_DIR/VERSION" ]]; then
  VERSION="$(head -n 1 "$ROOT_DIR/VERSION" | tr -d '\r\n')"
fi
VERSION="${VERSION:-0.1.0}"
OUT_DIR="${OUT_DIR:-$ROOT_DIR/dist}"

mkdir -p "$OUT_DIR"

name="codex-switch-$VERSION"
tarball="$OUT_DIR/$name.tar.gz"

tmp="$(mktemp -d)"
cleanup() { rm -rf "$tmp"; }
trap cleanup EXIT

mkdir -p "$tmp/$name"
cp -a \
  "$ROOT_DIR/codex-switch" \
  "$ROOT_DIR/cx-add" \
  "$ROOT_DIR/cx-use" \
  "$ROOT_DIR/cx-save" \
  "$ROOT_DIR/cx-list" \
  "$ROOT_DIR/cx-del" \
  "$ROOT_DIR/cx-edit" \
  "$ROOT_DIR/install.sh" \
  "$ROOT_DIR/uninstall.sh" \
  "$ROOT_DIR/release.sh" \
  "$ROOT_DIR/README.md" \
  "$ROOT_DIR/SECURITY.md" \
  "$ROOT_DIR/VERSION" \
  "$ROOT_DIR/LICENSE" \
  "$ROOT_DIR/CHANGELOG.md" \
  "$ROOT_DIR/.gitignore" \
  "$tmp/$name/"

chmod +x \
  "$tmp/$name/codex-switch" \
  "$tmp/$name/cx-add" \
  "$tmp/$name/cx-use" \
  "$tmp/$name/cx-save" \
  "$tmp/$name/cx-list" \
  "$tmp/$name/cx-del" \
  "$tmp/$name/cx-edit" \
  "$tmp/$name/install.sh" \
  "$tmp/$name/uninstall.sh" \
  "$tmp/$name/release.sh"

(cd "$tmp" && tar -czf "$tarball" "$name")

echo "OK: wrote $tarball"
