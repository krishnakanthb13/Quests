# Tauri Version Setup Guide

## Prerequisites

1. **Node.js** - Download from [nodejs.org](https://nodejs.org/)
2. **Rust** - Can be installed automatically (see below)

## Quick Setup

### Option 1: Automatic Rust Installation (Recommended)

1. Run `setup_rust.bat` - This will download and install Rust automatically
2. Restart your terminal/PowerShell after installation
3. Run `launch_tauri.bat`

### Option 2: Manual Rust Installation

1. Download Rust from [rustup.rs](https://rustup.rs/)
2. Run the installer and follow instructions
3. Restart your terminal/PowerShell
4. Run `launch_tauri.bat`

## Troubleshooting

### Error: "program not found" or "cargo: command not found"

**Solution:** Rust is not installed or not in your PATH.

1. Run `setup_rust.bat` to install Rust automatically
2. OR install manually from [rustup.rs](https://rustup.rs/)
3. **Important:** Restart your terminal/PowerShell after installation
4. Verify with: `cargo --version`

### Error persists after installing Rust

1. Close and reopen your terminal/PowerShell
2. Verify Rust is installed: `cargo --version`
3. If still not found, add Rust to PATH manually:
   - Add `C:\Users\YourUsername\.cargo\bin` to your system PATH
   - Restart terminal

### Don't want to install Rust?

Use the **Python version** instead - it's even lighter and doesn't require Rust:
- Run `launch_python.bat` (only needs Python, usually pre-installed)

## Building Executable

After setup is complete:

```bash
cd tauri
npm run build
```

Executable will be in `src-tauri/target/release/`

## Size

- Development setup: ~500 MB (Rust one-time install)
- Final executable: ~5-10 MB (very lightweight!)

