# codex-switch

Simple profile switcher for OpenAI Codex CLI (`~/.codex/config.toml` + `~/.codex/auth.json`).

一个简单的 Codex 多账号配置切换工具（只切换 `config.toml` + `auth.json`），方便在不同中转平台/账号之间快速切换。

## 设计约定（默认：patch 模式）

- `CODEX_HOME` 默认为 `~/.codex`（可通过环境变量 `CODEX_HOME` 覆盖）
- Profile 仍然保存 `config.toml` + `auth.json`，但**默认切换不会整体替换** `CODEX_HOME/config.toml`：
  - `codex-switch use <profile>` 默认只会在同一个 `config.toml` 内 patch 两件事：
    - `model_provider`
    - 对应 provider 的 `base_url`
  - 然后替换 `auth.json`
- Profile 存储位置：
  - `~/.codex-switch/profiles/<profile>/config.toml`
  - `~/.codex-switch/profiles/<profile>/auth.json`
- 切换时会自动备份当前 `CODEX_HOME` 下的 `config.toml`/`auth.json` 到：
  - `~/.codex-switch/backups/<timestamp>-before-<profile>/`
- 备份保留策略：
  - 默认仅保留最近 10 条（自动删除更旧的备份目录）
  - 可用环境变量 `CODEX_SWITCH_BACKUP_LIMIT` 覆盖
- 如需旧行为（整体替换 `config.toml`），可设置：
  - `export CODEX_SWITCH_USE_MODE=copy`

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
codex-switch save <xxx>

# 切换到某个 profile（patch base_url + 自动备份）
codex-switch use <xxx>

cx-save <xxx>
cx-use <xxx>
cx-list               # 列出所有 profiles
cx-add <xxx>          # 交互式创建（会问 base_url；auth 直接输入 API key，回车则复制当前 auth.json）
cx-add <xxx> --auth-edit  # 交互创建后用编辑器设置 auth.json
cx-del <xxx>          # 删除 profile（会二次确认）
cx-del <xxx> -y       # 直接删除（无确认）
cx-edit <xxx>         # 编辑 profile 的 config/auth（用 $EDITOR）

codex-switch list
codex-switch current

# 回滚到最近一次切换前的备份
codex-switch rollback
```

## 让不同 profile 共享历史（推荐）

Codex 的会话/历史显示经常会按 `model_provider`（以及 cwd 等）分组/过滤；如果你每个 profile 都用不同的 provider 名，就会出现“切换后历史不见了”的错觉。

推荐做法：**让所有 profile 使用同一个 provider 名**（例如 `shared`），但每个 profile 的 `base_url` / `auth.json` 各自不同。

```bash
# 让 `codex-switch add` 默认用 shared 作为 provider
export CODEX_SWITCH_SHARED_PROVIDER=shared

# 新建 profile（仍然会分别写入各自的 base_url/auth）
codex-switch add <a>
codex-switch add <b>

# 把已有 profiles 统一成同一个 provider（会自动备份原 config.toml）
codex-switch unify-provider shared

# 看不到旧会话时，先试试（关闭 cwd 过滤）
codex resume --all
```

## 适配“不同中转平台”的建议

- 每个 profile 的 `config.toml` 里配置对应的 `base_url` / `model_provider` 等即可。
- `auth.json` 对应不同账号的登录态/凭据；建议每个账号单独一个 profile，不要复用。

## 环境变量

- `CODEX_HOME`：Codex 配置目录（默认 `~/.codex`）
- `CODEX_SWITCH_HOME`：profile/备份目录（默认 `~/.codex-switch`）
- `CODEX_SWITCH_BACKUP_LIMIT`：备份保留数量（默认 `10`）
- `CODEX_SWITCH_CODEX_BIN`：指定原生 `codex` 可执行文件路径（仅用于 `cx-add` 把 API key 写入正确格式的 auth.json）
- `CODEX_SWITCH_SHARED_PROVIDER`：`codex-switch add` 默认的 provider 名（用于让多个 profile 共享历史）

## 安全说明

- 工具不会打印 `config.toml` 或 `auth.json` 内容（把它们当作不透明文件处理）。
- 文件权限会强制设为 `0600`（避免凭据意外变得可读）。
