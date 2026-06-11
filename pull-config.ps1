# pull-config.ps1
# GitHubから最新設定を取得して ~/.claude に反映
# Usage: powershell -File pull-config.ps1

$dst = "$env:USERPROFILE\.claude"
$repo = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "📥 GitHub → PC 同期開始"

Set-Location $repo
git pull
Write-Host "  ✅ git pull完了"

$items = @("settings.json", "CLAUDE.md", "commands", "skills", "agents", "helpers")
foreach ($item in $items) {
    $srcPath = Join-Path $repo $item
    if (Test-Path $srcPath) {
        Copy-Item $srcPath $dst -Recurse -Force
        Write-Host "  ✅ $item → ~/.claude/"
    }
}

Write-Host "✅ 同期完了！claude を再起動してください。"
