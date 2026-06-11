# push-config.ps1
# ~/.claude の設定をリポにコピーしてGitHubにpush
# Usage: powershell -File push-config.ps1

$src = "$env:USERPROFILE\.claude"
$dst = Split-Path -Parent $MyInvocation.MyCommand.Path
$logFile = Join-Path $dst "sync.log"

function Log($msg) {
    $line = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') $msg"
    Add-Content $logFile $line
}

Log "=== 同期開始 ==="

$items = @("settings.json", "CLAUDE.md", "commands", "skills", "agents", "helpers")
foreach ($item in $items) {
    $srcPath = Join-Path $src $item
    if (Test-Path $srcPath) {
        Copy-Item $srcPath $dst -Recurse -Force
        Log "  コピー: $item"
    }
}

Set-Location $dst
git add -A | Out-Null

# 変更があればコミット、なければスキップ
$status = git status --porcelain
if ($status) {
    $msg = "auto-sync $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    git commit -m $msg | Out-Null
    Log "  コミット: $msg"
} else {
    Log "  変更なし、コミットスキップ"
}

# 常にpush（他マシンからの変更も取り込む）
git pull --rebase --quiet 2>&1 | Out-Null
git push --quiet 2>&1 | Out-Null
Log "=== 同期完了 ==="
exit 0
