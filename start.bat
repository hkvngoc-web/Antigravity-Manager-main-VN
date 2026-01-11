@echo off
:: Chay file PowerShell voi quyen Admin va bo qua Execution Policy
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0start.ps1"
if %errorLevel% neq 0 pause
