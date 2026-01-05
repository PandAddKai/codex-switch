# Security Notes

This tool copies/stores Codex credentials as opaque files (`config.toml` + `auth.json`).

- Profile path: `~/.codex-switch/profiles/<profile>/`
- The tool forces file permissions to `0600` where possible.

Recommendations:

- Treat `auth.json` as sensitive.
- Avoid committing any `~/.codex-switch/` contents to git.
- Use separate profiles per account/provider.

