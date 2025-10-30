# ===========================
# Auto Install Essential Apps (No Emoji Version)
# ===========================

$apps = @(
    "Google.Chrome",
    "Google.Drive",
    "Microsoft.Office",
    "RARLab.WinRAR",
    "Unikey.Unikey"
)

foreach ($app in $apps) {
    Write-Host "Installing $app ..." -ForegroundColor Cyan
    try {
        winget install --id=$app -e --accept-package-agreements --accept-source-agreements -h
        Write-Host "Done: $app" -ForegroundColor Green
    } catch {
        Write-Host "Failed: $app" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "All selected applications have been installed successfully!" -ForegroundColor Yellow
