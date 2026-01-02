@echo off
echo ========================================
echo Tauri Setup - Rust Installation
echo ========================================
echo.

REM Check if Rust is already installed
where cargo >nul 2>&1
if %errorlevel% == 0 (
    echo Rust/Cargo is already installed!
    cargo --version
    echo.
    echo Setup complete. You can now run launch_tauri.bat
    pause
    exit /b 0
)

echo Rust is not installed. Installing now...
echo.
echo IMPORTANT: This will download and install Rust (~500 MB).
echo.
echo This is a ONE-TIME setup cost. Once you build the app, the
echo final executable will be only 5-10 MB and won't need Rust.
echo.
echo If you just want to RUN the widget without building, use
echo the Python version instead (launch_python.bat) - it needs 0 MB setup!
echo.
echo Press Ctrl+C to cancel, or
pause

echo.
echo Downloading Rust installer...
powershell -Command "Invoke-WebRequest -Uri 'https://win.rustup.rs/x86_64' -OutFile '%TEMP%\rustup-init.exe'"

if not exist "%TEMP%\rustup-init.exe" (
    echo.
    echo Error: Failed to download Rust installer.
    echo Please download manually from: https://rustup.rs/
    pause
    exit /b 1
)

echo.
echo Running Rust installer...
echo Please follow the on-screen instructions.
echo Recommended: Press Enter to accept defaults.
echo.
"%TEMP%\rustup-init.exe"

if errorlevel 1 (
    echo.
    echo Rust installation may have failed or was cancelled.
    pause
    exit /b 1
)

echo.
echo Refreshing environment variables...
call refreshenv >nul 2>&1
if errorlevel 1 (
    echo.
    echo Please restart your terminal/PowerShell and run launch_tauri.bat again.
    echo Or manually add Rust to your PATH.
    pause
    exit /b 0
)

echo.
echo Verifying installation...
call cargo --version
if errorlevel 1 (
    echo.
    echo Rust installed but not in PATH. Please restart your terminal.
    pause
    exit /b 1
)

echo.
echo ========================================
echo Rust installation complete!
echo ========================================
echo.
echo You can now run launch_tauri.bat
pause

