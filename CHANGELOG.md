# Changelog

## 0.1.3 (2026-01-05)

- Fix missing prompts on some terminals by writing prompts to a TTY (stderr or stdout)
- Make the hidden `auth` input step more explicit

## 0.1.4 (2026-01-05)

- Force interactive prompts to use `/dev/tty` when available (more robust on some terminals)

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
