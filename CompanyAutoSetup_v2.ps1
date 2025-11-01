# ======================================================
# Company Auto Setup v2 – Modular Winget Installer
# Author: anh Điền (with AI Assistant)
# ======================================================

$logPath = "C:\CompanySetupLog.txt"
$licenseKey = "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX" # <-- Điền key Office 365 vào đây nếu có
Write-Host "=== Company Auto Setup v2 ===" -ForegroundColor Cyan
Write-Host "Log file: $logPath`n"

# ------------------------------------------------------
# Kiểm tra kết nối Internet
# ------------------------------------------------------
Write-Host "🔍 Kiểm tra Internet..."
if (-not (Test-Connection -ComputerName google.com -Count 1 -Quiet)) {
    Write-Host "❌ Không có kết nối Internet. Thoát chương trình." -ForegroundColor Red
    exit
}
Write-Host "✅ Internet OK." -ForegroundColor Green

# ------------------------------------------------------
# Chọn gói cài đặt
# ------------------------------------------------------
Write-Host "`nChọn gói phần mềm cần cài:" -ForegroundColor Yellow
Write-Host "1. Basic - Nhân viên văn phòng (Chrome, Office, Unikey, Drive)"
Write-Host "2. Full - IT/Admin (thêm WinRAR, VSCode, 7zip, Everything)"
Write-Host "3. Developer - Kỹ sư phần mềm (thêm Git, NodeJS, Python, Docker)"
$choice = Read-Host "Nhập lựa chọn (1-3)"

switch ($choice) {
    1 {
        $apps = @(
            "Google.Chrome",
            "Google.Drive",
            "Unikey.UniKey",
            "Microsoft.Office"
        )
    }
    2 {
        $apps = @(
            "Google.Chrome",
            "Google.Drive",
            "Unikey.UniKey",
            "Microsoft.Office",
            "WinRAR.WinRAR",
            "Microsoft.VisualStudioCode",
            "voidtools.Everything",
            "7zip.7zip"
        )
    }
    3 {
        $apps = @(
            "Google.Chrome",
            "Google.Drive",
            "Unikey.UniKey",
            "Microsoft.Office",
            "Git.Git",
            "Microsoft.VisualStudioCode",
            "Python.Python.3.12",
            "OpenJS.NodeJS",
            "Docker.DockerDesktop"
        )
    }
    default {
        Write-Host "❌ Lựa chọn không hợp lệ, thoát." -ForegroundColor Red
        exit
    }
}

# ------------------------------------------------------
# Cài đặt từng ứng dụng
# ------------------------------------------------------
foreach ($app in $apps) {
    Write-Host "`n------------------------" -ForegroundColor DarkGray
    Write-Host "Đang xử lý: $app" -ForegroundColor Cyan
    $check = winget list --id $app 2>$null
    if ($check) {
        Write-Host "↳ Đã cài đặt rồi, bỏ qua." -ForegroundColor Green
        Add-Content $logPath "$(Get-Date) - $app: Đã có sẵn."
    } else {
        Write-Host "↳ Cài đặt $app..." -ForegroundColor Yellow
        try {
            winget install --id $app --accept-package-agreements --accept-source-agreements -h
            Add-Content $logPath "$(Get-Date) - $app: Cài thành công."
            Write-Host "✅ Hoàn tất." -ForegroundColor Green
        } catch {
            Add-Content $logPath "$(Get-Date) - $app: Lỗi khi cài."
            Write-Host "❌ Lỗi khi cài đặt $app" -ForegroundColor Red
        }
    }
}

# ------------------------------------------------------
# Kích hoạt Office nếu có key
# ------------------------------------------------------
if ($licenseKey -ne "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX") {
    Write-Host "`n🔑 Kích hoạt Office..."
    try {
        cscript "C:\Program Files\Microsoft Office\Office16\OSPP.VBS" /inpkey:$licenseKey
        cscript "C:\Program Files\Microsoft Office\Office16\OSPP.VBS" /act
        Add-Content $logPath "$(Get-Date) - Office kích hoạt bằng key."
        Write-Host "✅ Office đã kích hoạt!" -ForegroundColor Green
    } catch {
        Write-Host "⚠️ Không thể kích hoạt Office (kiểm tra lại key hoặc phiên bản)." -ForegroundColor Yellow
    }
}

Write-Host "`n🎯 Hoàn tất cài đặt tất cả ứng dụng!" -ForegroundColor Green
Write-Host "Xem log tại: $logPath"
pause
