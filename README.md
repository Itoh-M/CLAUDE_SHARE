# Claude Code 設定同期リポ (PC ↔ Mac)

## 同期対象
- `settings.json` — グローバル設定
- `CLAUDE.md` — グローバル指示
- `commands/` — カスタムコマンド
- `skills/` — カスタムスキル
- `agents/` — エージェント定義
- `helpers/` — ヘルパースクリプト

## 使い方

### PC (Windows)
```powershell
# 設定をGitHubに送る
powershell -File C:\Users\itoh-\claude-config\push-config.ps1

# GitHubから最新を取得
powershell -File C:\Users\itoh-\claude-config\pull-config.ps1
```

### Mac
```bash
# 初回セットアップ
git clone https://github.com/Itoh-M/CLAUDE_SHARE.git ~/claude-config
bash ~/claude-config/sync.sh pull

# 設定をGitHubに送る
bash ~/claude-config/sync.sh push

# GitHubから最新を取得
bash ~/claude-config/sync.sh pull
```

## 同期しないもの (`.gitignore`)
sessions, backups, cache, credentials, telemetry など
