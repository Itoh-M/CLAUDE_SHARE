# push-config.ps1
# ~/.claude の設定をリポにコピーしてGitHubにpush
# Usage: powershell -File push-config.ps1

$src = "$env:USERPROFILE\.claude"
$dst = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "📤 PC → GitHub 同期開始"

$items = @("settings.json", "CLAUDE.md", "commands", "skills", "agents", "helpers")
foreach ($item in $items) {
    $srcPath = Join-Path $src $item
    if (Test-Path $srcPath) {
        Copy-Item $srcPath $dst -Recurse -Force
        Write-Host "  ✅ $item"
    }
}

Set-Location $dst
git add -A
$msg = "sync $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
git commit -m $msg
git push
Write-Host "✅ GitHubにpush完了: $msg"
