@echo off
echo Building Time Widget executable...
echo.

REM Check if electron-builder is installed
call npm list electron-builder >nul 2>&1
if errorlevel 1 (
    echo Installing electron-builder...
    call npm install --save-dev electron-builder
)

echo.
echo Building Windows executable...
call npx electron-builder --win --x64

echo.
echo Build complete! Check the 'dist' folder for the executable.
pause

