# Quick Start Guide

## Which Version Should I Use?

### 🐍 Python Version (⭐ Easiest - Recommended!)
- **Best if:** Python is already installed
- **Executable Size:** ~10-20 MB
- **Setup Size:** **0 MB** (if Python installed)
- **Setup:** Just run `python time_widget.py`
- **No build step needed!**

### ⚡ Tauri Version (Smallest Executable)
- **Best if:** You want the smallest possible executable
- **Executable Size:** ~5-10 MB (smallest!)
- **Setup Size:** ~500 MB (Rust - one-time, only to build)
- **Important:** The 500 MB is ONLY needed to BUILD. End users get a 5-10 MB executable with no Rust needed!
- **Setup:** Requires Node.js + Rust (~500 MB one-time install)

### 🖥️ Electron Version (Full-Featured)
- **Best if:** You need maximum compatibility
- **Size:** ~150-200 MB executable
- **Setup:** Requires Node.js
- **First run:** `npm install && npm start`

## Quick Commands

### Python
```bash
python time_widget.py
# or
launch_python.bat
```

### Tauri
```bash
cd tauri
npm install
npm run dev        # Development
npm run build      # Build executable
```

### Electron
```bash
npm install
npm start          # Development
npm run build      # Build executable
```

## First Time Setup

### Python
1. Check Python: `python --version` (needs 3.x)
2. Run: `python time_widget.py`
3. Done! ✅

### Tauri
1. Install Node.js from [nodejs.org](https://nodejs.org/)
2. `cd tauri`
3. Run `setup_rust.bat` (downloads ~500 MB Rust - one-time only)
4. Restart terminal, then `npm install`
5. `npm run dev`
6. Done! ✅

**Note:** The 500 MB Rust is only needed to BUILD. Once built, the executable is 5-10 MB and doesn't need Rust!

### Electron
1. Install Node.js from [nodejs.org](https://nodejs.org/)
2. `npm install`
3. `npm start`
4. Done! ✅

## Building Executables

All versions can be built into standalone `.exe` files:

- **Python**: Use PyInstaller (see README)
- **Tauri**: `cd tauri && npm run build` → Output in `src-tauri/target/release/`
- **Electron**: `npm run build` → Output in `dist/`

## Troubleshooting

### Python: "Python not found"
- Install Python from [python.org](https://python.org)
- Make sure to check "Add Python to PATH" during installation

### Python: "ModuleNotFoundError: No module named 'tkinter'"
- Run `install_tkinter.bat` to install tkinter
- Or reinstall Python and make sure "tcl/tk and IDLE" is checked
- tkinter should come with Python, but sometimes it's missing

### Tauri: Build errors
- Make sure Rust is installed (runs automatically on first `npm install`)
- Check that you have Visual Studio Build Tools (Windows)

### Electron: "npm not found"
- Install Node.js from [nodejs.org](https://nodejs.org/)
- Restart your terminal after installation

