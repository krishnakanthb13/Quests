@echo off
echo Building Time Widget (Tauri Version)...
echo.
cd tauri
call npm install
if errorlevel 1 (
    echo.
    echo Error installing dependencies.
    pause
    exit /b 1
)
call npm run build
echo.
echo Build complete! Check the 'src-tauri/target/release' folder for the executable.
pause

