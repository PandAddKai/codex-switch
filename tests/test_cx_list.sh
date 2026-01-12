#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

tmp="$(mktemp -d)"
trap 'rm -rf -- "$tmp"' EXIT

export CODEX_HOME="$tmp/codex"
export CODEX_SWITCH_HOME="$tmp/switch"
export PATH="$ROOT_DIR:$PATH"

mkdir -p "$CODEX_HOME"
printf '%s\n' 'model_provider="shared"' >"$CODEX_HOME/config.toml"
printf '%s\n' '{}' >"$CODEX_HOME/auth.json"
chmod 600 "$CODEX_HOME/config.toml" "$CODEX_HOME/auth.json"

mkdir -p "$CODEX_SWITCH_HOME/profiles/a" "$CODEX_SWITCH_HOME/profiles/b"
printf '%s\n' 'model_provider="shared"' >"$CODEX_SWITCH_HOME/profiles/a/config.toml"
printf '%s\n' '{}' >"$CODEX_SWITCH_HOME/profiles/a/auth.json"
printf '%s\n' 'model_provider="shared"' >"$CODEX_SWITCH_HOME/profiles/b/config.toml"
printf '%s\n' '{}' >"$CODEX_SWITCH_HOME/profiles/b/auth.json"
chmod 600 "$CODEX_SWITCH_HOME/profiles/a/config.toml" "$CODEX_SWITCH_HOME/profiles/a/auth.json"
chmod 600 "$CODEX_SWITCH_HOME/profiles/b/config.toml" "$CODEX_SWITCH_HOME/profiles/b/auth.json"

out="$(cx-list)"
echo "$out" | grep -qxF "a" || { echo "$out" >&2; exit 1; }
echo "$out" | grep -qxF "b" || { echo "$out" >&2; exit 1; }

echo "ok"

