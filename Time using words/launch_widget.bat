@echo off
setlocal
cd /d "%~dp0"
echo Launching Floating Time Widget...
powershell -NoProfile -ExecutionPolicy Bypass -File "launch_widget.ps1"
endlocal
