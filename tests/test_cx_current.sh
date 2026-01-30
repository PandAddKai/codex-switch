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

mkdir -p "$CODEX_HOME" "$CODEX_SWITCH_HOME/profiles/p1"

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

cat >"$CODEX_SWITCH_HOME/profiles/p1/config.toml" <<'TOML'
model_provider = "p1"

[model_providers.p1]
name = "p1"
base_url = "https://new.example/v1"
wire_api = "responses"
requires_openai_auth = true
TOML
chmod 600 "$CODEX_SWITCH_HOME/profiles/p1/config.toml"

printf '%s\n' '{}' >"$CODEX_SWITCH_HOME/profiles/p1/auth.json"
chmod 600 "$CODEX_SWITCH_HOME/profiles/p1/auth.json"

"$BIN" use p1 >/dev/null

cur1="$("$BIN" current)"
cur2="$(cx-current)"
[[ "$cur2" == "$cur1" ]] || fail "expected cx-current=$cur1, got: $cur2"

echo "ok"

