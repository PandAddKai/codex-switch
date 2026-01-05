# codex-switch

Simple profile switcher for OpenAI Codex CLI (`~/.codex/config.toml` + `~/.codex/auth.json`).

一个简单的 Codex 多账号配置切换工具（只切换 `config.toml` + `auth.json`），方便在不同中转平台/账号之间快速切换。

## 设计约定（对应你的选择 A）

- `CODEX_HOME` 默认为 `~/.codex`（可通过环境变量 `CODEX_HOME` 覆盖）
- Profile 仅包含：
  - `config.toml`
  - `auth.json`
- Profile 存储位置：
  - `~/.codex-switch/profiles/<profile>/config.toml`
  - `~/.codex-switch/profiles/<profile>/auth.json`
- 切换时会自动备份当前 `CODEX_HOME` 下的 `config.toml`/`auth.json` 到：
  - `~/.codex-switch/backups/<timestamp>-before-<profile>/`
- 备份保留策略：
  - 默认仅保留最近 10 条（自动删除更旧的备份目录）
  - 可用环境变量 `CODEX_SWITCH_BACKUP_LIMIT` 覆盖

## 安装

把脚本放到 PATH 中即可（推荐用安装脚本）：

```bash
./install.sh
```

安装脚本会把文件复制到 `~/.local/share/codex-switch`，再在 `~/.local/bin` 建 symlink，
所以你之后可以随意移动仓库目录而不会把命令弄坏。

卸载：

```bash
./uninstall.sh
```

## 常用命令

```bash
codex-switch init

# 把当前 ~/.codex/config.toml + ~/.codex/auth.json 存成一个 profile
codex-switch save right

# 切换到某个 profile（原子替换 + 自动备份）
codex-switch use right

cx-save right
cx-use right
cx-add rightcode          # 交互式创建（会问 base_url；auth 直接输入 API key，回车则复制当前 auth.json）
cx-add rightcode --auth-edit  # 交互创建后用编辑器设置 auth.json
cx-del rightcode          # 删除 profile（会二次确认）
cx-del rightcode -y       # 直接删除（无确认）
cx-edit rightcode         # 编辑 profile 的 config/auth（用 $EDITOR）

codex-switch list
codex-switch current

# 回滚到最近一次切换前的备份
codex-switch rollback
```

## 适配“不同中转平台”的建议

- 每个 profile 的 `config.toml` 里配置对应的 `base_url` / `model_provider` 等即可。
- `auth.json` 对应不同账号的登录态/凭据；建议每个账号单独一个 profile，不要复用。

## 环境变量

- `CODEX_HOME`：Codex 配置目录（默认 `~/.codex`）
- `CODEX_SWITCH_HOME`：profile/备份目录（默认 `~/.codex-switch`）
- `CODEX_SWITCH_BACKUP_LIMIT`：备份保留数量（默认 `10`）
- `CODEX_SWITCH_CODEX_BIN`：指定原生 `codex` 可执行文件路径（仅用于 `cx-add` 把 API key 写入正确格式的 auth.json）

## 安全说明

- 工具不会打印 `config.toml` 或 `auth.json` 内容（把它们当作不透明文件处理）。
- 文件权限会强制设为 `0600`（避免凭据意外变得可读）。
