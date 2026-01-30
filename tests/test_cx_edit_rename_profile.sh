#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
BIN="$ROOT_DIR/codex-switch"

fail() { echo "FAIL: $*" >&2; exit 1; }

tmp="$(mktemp -d)"
trap 'rm -rf -- "$tmp"' EXIT

export CODEX_HOME="$tmp/codex"
export CODEX_SWITCH_HOME="$tmp/switch"
export PATH="$ROOT_DIR:$PATH"
export EDITOR=true

mkdir -p "$CODEX_HOME" "$CODEX_SWITCH_HOME/profiles/a"

cat >"$CODEX_HOME/config.toml" <<'TOML'
model_provider = "shared"

[model_providers.shared]
name = "shared"
base_url = "https://old.example/v1"
wire_api = "responses"
requires_openai_auth = true
TOML
chmod 600 "$CODEX_HOME/config.toml"

printf '%s\n' '{}' >"$CODEX_HOME/auth.json"
chmod 600 "$CODEX_HOME/auth.json"

cat >"$CODEX_SWITCH_HOME/profiles/a/config.toml" <<'TOML'
model_provider = "a"

[model_providers.a]
name = "a"
base_url = "https://a.example/v1"
wire_api = "responses"
requires_openai_auth = true
TOML
chmod 600 "$CODEX_SWITCH_HOME/profiles/a/config.toml"

printf '%s\n' '{}' >"$CODEX_SWITCH_HOME/profiles/a/auth.json"
chmod 600 "$CODEX_SWITCH_HOME/profiles/a/auth.json"

"$BIN" use a >/dev/null

printf '%s\n' 'b' | cx-edit a --rename >/dev/null

[[ -d "$CODEX_SWITCH_HOME/profiles/b" ]] || fail "expected profile dir renamed to b"
[[ ! -d "$CODEX_SWITCH_HOME/profiles/a" ]] || fail "expected old profile dir removed"

cur="$("$BIN" current)"
[[ "$cur" == "b" ]] || fail "expected current profile to be b, got: $cur"

echo "ok"

