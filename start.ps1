# Antigravity Tools - Tu dong hoa khoi dong (PowerShell)
# Yeu cau quyen quan tri (Administrator)

param([string]$OriginalDir = $PSScriptRoot)

$ErrorActionPreference = "Stop"

# 1. Tu dong nang quyen Admin neu chua co
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[!] Dang nang quyen quan tri..." -ForegroundColor Yellow
    # Truyen thu muc hien tai vao script moi
    $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" -OriginalDir `"$PSScriptRoot`""
    Start-Process powershell.exe -ArgumentList $arguments -Verb RunAs
    exit
}

# 1b. Khoi phuc thu muc lam viec
Set-Location -Path $OriginalDir

Clear-Host
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "   ANTIGRAVITY TOOLS - HE THONG TU DONG HOA (PS)" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "   Thu muc: $OriginalDir" -ForegroundColor Gray
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

# 2. Thiet lap Execution Policy
Write-Host "[1/5] Dang thiet lap quyen thuc thi script..." -ForegroundColor Green
try {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
}
catch {
    Write-Host "[!] Luu y: Chinh sach thuc thi dang duoc quan ly boi he thong, dang tiep tuc..." -ForegroundColor Gray
}
Write-Host "[OK] Da kiem tra xong."

# 3. Kiem tra va cai dat Node.js
Write-Host "`n[2/5] Kiem tra Node.js..." -ForegroundColor Green
try {
    $nodeVersion = node -v
    Write-Host "[OK] Node.js da duoc cai dat: $nodeVersion"
}
catch {
    Write-Host "[!] Khong tim thay Node.js. Dang tien hanh cai dat tu dong..." -ForegroundColor Yellow
    winget install OpenJS.NodeJS.LTS --silent --accept-source-agreements --accept-package-agreements
    Write-Host "[OK] Da cai dat Node.js thành công."
}

# 4. Kiem tra va cai dat Rust
Write-Host "`n[3/5] Kiem tra Rust..." -ForegroundColor Green
$cargoFound = Get-Command cargo -ErrorAction SilentlyContinue
if ($cargoFound) {
    Write-Host "[OK] Rust da duoc cai dat: $(cargo --version)"
}
else {
    Write-Host "[!] Khong tim thay Rust. Dang tien hanh cai dat tu dong..." -ForegroundColor Yellow
    winget install Rustlang.Rustup --silent --accept-source-agreements --accept-package-agreements
    Write-Host "[OK] Da cai dat Rust. Vui long cho trong giay lat de cap nhat PATH..."
    $env:Path += ";$env:USERPROFILE\.cargo\bin"
}

# 5. Kiem tra C++ Build Tools
Write-Host "`n[4/5] Kiem tra Microsoft C++ Build Tools..." -ForegroundColor Green
$vsWherePath = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
$btInstalled = $false
if (Test-Path $vsWherePath) {
    $btPath = & $vsWherePath -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
    if ($btPath) { $btInstalled = $true }
}

if (-not $btInstalled) {
    Write-Host "[!] Khong tim thay C++ Build Tools. Dang tien hanh cai dat..." -ForegroundColor Yellow
    Write-Host "[!] Qua trinh nay se tai ve khoang 1-2GB du lieu, vui long cho doi." -ForegroundColor Gray
    winget install Microsoft.VisualStudio.2022.BuildTools --silent --override "--passive --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended"
    Write-Host "[OK] Da bat dau cai dat Build Tools."
}
else {
    Write-Host "[OK] C++ Build Tools da duoc cai dat."
}

# 6. Cai dat dependencies va khoi dong
Write-Host "`n[5/5] Dang chuan bi du an..." -ForegroundColor Green
Write-Host "[*] Dang chay npm install..." -ForegroundColor Gray
npm install

Write-Host "`n[*] Dang khoi dong ung dung (tauri dev)..." -ForegroundColor Cyan
Write-Host "[!] Luu y: Lan dau khoi dong se mat 5-10 phut de bien dich Rust." -ForegroundColor Gray
npm run tauri dev

Write-Host "`nNhan phim bat ky de thoat..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
