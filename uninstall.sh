#!/usr/bin/env bash
set -euo pipefail

PREFIX="${PREFIX:-$HOME/.local/bin}"
INSTALL_ROOT="${INSTALL_ROOT:-$HOME/.local/share/codex-switch}"

rm -f \
  "$PREFIX/codex-switch" \
  "$PREFIX/cx-add" \
  "$PREFIX/cx-use" \
  "$PREFIX/cx-save" \
  "$PREFIX/cx-list" \
  "$PREFIX/cx-current" \
  "$PREFIX/cx-del" \
  "$PREFIX/cx-edit"

if [[ "${1:-}" == "--purge" ]]; then
  rm -rf -- "$INSTALL_ROOT"
  echo "OK: removed from $PREFIX"
  echo "OK: purged $INSTALL_ROOT"
else
  echo "OK: removed from $PREFIX"
  echo "Note: kept $INSTALL_ROOT (run: uninstall.sh --purge)"
fi
