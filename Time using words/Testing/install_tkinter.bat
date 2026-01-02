@echo off
echo ========================================
echo Installing tkinter for Python
echo ========================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH.
    echo Please install Python from https://python.org first.
    pause
    exit /b 1
)

echo Python found. Attempting to install tkinter...
echo.

REM Try installing tk via pip
python -m pip install tk

if errorlevel 1 (
    echo.
    echo pip install failed. Trying alternative method...
    echo.
    echo If this doesn't work, you may need to reinstall Python with tkinter included.
    echo.
    echo Option 1: Reinstall Python from https://python.org
    echo   - Make sure "tcl/tk and IDLE" is checked during installation
    echo.
    echo Option 2: Use the Electron or Tauri versions instead
    echo   - They don't require tkinter
    echo.
    pause
    exit /b 1
)

echo.
echo Verifying tkinter installation...
python -c "import tkinter; print('tkinter is now available!')"

if errorlevel 1 (
    echo.
    echo tkinter installation may have failed.
    echo Please reinstall Python with tkinter included.
    pause
    exit /b 1
)

echo.
echo ========================================
echo tkinter installed successfully!
echo ========================================
echo.
echo You can now run launch_python.bat
pause

