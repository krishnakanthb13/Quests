@echo off
echo Starting Time Widget (Python Version)...
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH.
    echo.
    echo Please install Python from https://python.org
    echo Make sure to check "Add Python to PATH" during installation.
    pause
    exit /b 1
)

REM Check if tkinter is available
python -c "import tkinter" >nul 2>&1
if errorlevel 1 (
    echo ERROR: tkinter module is not available.
    echo.
    echo tkinter should come with Python, but it's missing from your installation.
    echo.
    echo Solutions:
    echo 1. Reinstall Python from https://python.org and make sure to install
    echo    "tcl/tk and IDLE" component (it's usually checked by default)
    echo.
    echo 2. Or install tkinter manually:
    echo    python -m pip install tk
    echo.
    echo 3. Or use the Electron/Tauri versions instead (they don't need tkinter)
    echo.
    pause
    exit /b 1
)

echo Python and tkinter found. Starting widget...
echo.
python time_widget.py
if errorlevel 1 (
    echo.
    echo Error running the widget.
    pause
    exit /b 1
)

