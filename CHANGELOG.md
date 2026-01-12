# Changelog

## 0.2.0 (2026-01-12)

- Default `use` behavior is now patch-mode: keeps a single `config.toml` and only patches `model_provider` + provider `base_url` (preserves other config like `mcp_servers` and helps share history across profiles)
- Add `cx-list` shortcut to list saved profiles
- Add `CODEX_SWITCH_USE_MODE=copy` to opt back into legacy full `config.toml` replacement

## 0.1.3 (2026-01-05)

- Fix missing prompts on some terminals by writing prompts to a TTY (stderr or stdout)
- Make the hidden `auth` input step more explicit

## 0.1.4 (2026-01-05)

- Force interactive prompts to use `/dev/tty` when available (more robust on some terminals)

## 0.1.5 (2026-01-05)

- Fix `cx-add` interactive prompts on some terminals by using `read -p` (no `/dev/tty` dependency)

## 0.1.6 (2026-01-05)

- Ensure prompts always work even if stdin isn't a TTY (read input from `/dev/tty` when available)

## 0.1.7 (2026-01-05)

- Open `/dev/tty` once and reuse its fd for prompts (more robust on AlmaLinux)

## 0.1.8 (2026-01-05)

- Rework interactive prompts to avoid `/dev/tty` and bracketed-paste toggling; sanitize pasted input instead (fix AlmaLinux "blank prompt" cases)

## 0.1.9 (2026-01-05)

- Fix `cx-add` auth generation when config has `[features]` boolean flags (only update root-level `model_provider`)

## 0.1.2 (2026-01-05)

- Improve interactive prompts on some terminals (readline + bracketed-paste stripping)
- README examples now use `<xxx>` placeholders (no local profile names)

## 0.1.1 (2026-01-05)

- Install is now resilient to moving the repo (copies to `~/.local/share/codex-switch`)
- Add `SECURITY.md` and `VERSION`

## 0.1.0 (2026-01-05)

- Initial release: `cx-add`, `cx-use`, `cx-save`, `cx-del`, `cx-edit`
- Profiles stored in `~/.codex-switch/profiles/<name>/`
- Automatic backups (default keep last 10)
