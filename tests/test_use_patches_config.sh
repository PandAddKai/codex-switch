#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
BIN="$ROOT_DIR/codex-switch"

fail() { echo "FAIL: $*" >&2; exit 1; }

tmp="$(mktemp -d)"
trap 'rm -rf -- "$tmp"' EXIT

export CODEX_HOME="$tmp/codex"
export CODEX_SWITCH_HOME="$tmp/switch"

mkdir -p "$CODEX_HOME" "$CODEX_SWITCH_HOME/profiles/p1"

cat >"$CODEX_HOME/config.toml" <<'TOML'
model_provider = "shared"
model = "gpt-5.2"

[mcp_servers.keepme]
command = "echo"
args = ["hello"]

[model_providers.shared]
name = "shared"
base_url = "https://old.example/v1"
wire_api = "responses"
requires_openai_auth = true
TOML
chmod 600 "$CODEX_HOME/config.toml"

cat >"$CODEX_HOME/auth.json" <<'JSON'
{"api_key":"old"}
JSON
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

cat >"$CODEX_SWITCH_HOME/profiles/p1/auth.json" <<'JSON'
{"api_key":"new"}
JSON
chmod 600 "$CODEX_SWITCH_HOME/profiles/p1/auth.json"

"$BIN" use p1 >/dev/null

grep -qF '[mcp_servers.keepme]' "$CODEX_HOME/config.toml" || fail "expected existing mcp_servers table preserved"
grep -qF 'base_url = "https://new.example/v1"' "$CODEX_HOME/config.toml" || fail "expected shared provider base_url updated"
grep -qF '"api_key":"new"' "$CODEX_HOME/auth.json" || fail "expected auth.json updated"

cur="$("$BIN" current)"
[[ "$cur" == "p1" ]] || fail "expected current profile to be p1, got: $cur"

echo "ok"

