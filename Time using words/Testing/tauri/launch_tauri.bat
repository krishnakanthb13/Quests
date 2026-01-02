@echo off
echo Starting Time Widget (Tauri Version)...
echo.

REM Check if Rust/Cargo is installed
where cargo >nul 2>&1
if errorlevel 1 (
    echo.
    echo ERROR: Rust/Cargo is not installed!
    echo.
    echo Please run setup_rust.bat first to install Rust.
    echo Or install manually from: https://rustup.rs/
    echo.
    echo Alternatively, use the Python version (launch_python.bat) which doesn't require Rust.
    echo.
    pause
    exit /b 1
)

echo Rust/Cargo found. Continuing...
echo.

REM Check if we're in the tauri directory
if not exist "package.json" (
    echo Changing to tauri directory...
    cd tauri
)

REM Install npm dependencies
echo Installing npm dependencies...
call npm install
if errorlevel 1 (
    echo.
    echo Error installing npm dependencies.
    pause
    exit /b 1
)

echo.
echo Starting Tauri development server...
call npm run dev
if errorlevel 1 (
    echo.
    echo Error running Tauri. Make sure Rust is properly installed.
    pause
    exit /b 1
)
pause

