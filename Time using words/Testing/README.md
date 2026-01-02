# Time Using Words Widget

A lightweight floating Windows widget that displays the current time in words. Available in three versions: **Electron**, **Tauri** (lightweight), and **Python + Tkinter** (ultra-lightweight).

## Features

- ✅ Always-on-top floating window
- ✅ Two time format options:
  - **Numeric**: "Three fifteen"
  - **Natural**: "A quarter past three"
- ✅ Dark mode with aesthetic design
- ✅ Beautiful typography (Playfair Display & Inter fonts)
- ✅ Resizable window with text wrapping
- ✅ Adjustable text size (16px - 64px)
- ✅ Draggable window
- ✅ Settings persistence
- ✅ Minimal resource usage

## Versions Comparison

| Version | Executable Size | Dev Setup Size | Requirements | Best For |
|---------|----------------|----------------|--------------|----------|
| **Python** | ~10-20 MB | **0 MB** (if Python installed) | Python 3.x | **Easiest - no build tools needed!** |
| **Tauri** | ~5-10 MB | ~500 MB (Rust one-time) | Rust + Node.js (dev only) | Smallest executable |
| **Electron** | ~150-200 MB | ~400 MB (Node.js) | Node.js | Full-featured, cross-platform |

## Quick Start

### Python Version (⭐ Recommended - Easiest & Lightweight)

**Requirements:** Python 3.x with tkinter (usually included)

```bash
# Run directly
python time_widget.py

# Or use the batch file
launch_python.bat
```

**Size:** 
- **Executable:** ~10-20 MB
- **Setup:** 0 MB (if Python already installed)
- **No build tools needed!** Just run the script.

**Note:** If you get "ModuleNotFoundError: No module named 'tkinter'":
- Run `install_tkinter.bat` to install it
- Or reinstall Python from [python.org](https://python.org) with "tcl/tk and IDLE" component

### Tauri Version (Smallest Executable, but Requires Build Setup)

**Requirements:** 
- Node.js
- Rust (~500 MB one-time install for building)

```bash
# First time: Install Rust (~500 MB one-time)
cd tauri
setup_rust.bat

# Then run (after restarting terminal)
launch_tauri.bat
```

**Size:** 
- **Executable:** ~5-10 MB (smallest!)
- **Setup:** ~500 MB (Rust one-time install)
- **Note:** End users only need the executable, not Rust!

**⚠️ Important:** The 500 MB is only needed to BUILD the app. Once built, the executable is only 5-10 MB and doesn't require Rust.

### Electron Version (Full-Featured)

**Requirements:** Node.js

```bash
npm install
npm start
```

**Size:** ~150-200 MB executable

## Installation & Setup

### Python Version

1. Ensure Python 3.x is installed (check with `python --version`)
2. Run `python time_widget.py` or double-click `launch_python.bat`
3. No additional dependencies needed!

### Tauri Version

1. Install Node.js from [nodejs.org](https://nodejs.org/)
2. Navigate to `tauri` folder
3. Run `npm install` (this will also set up Rust if needed)
4. Run `npm run dev` to test or `npm run build` to create executable

**First-time setup:** Tauri will automatically install Rust and required tools (~500 MB one-time download)

### Electron Version

1. Install Node.js from [nodejs.org](https://nodejs.org/)
2. Run `npm install`
3. Run `npm start` or double-click `launch.bat`
4. To build executable: Run `build.bat` or `npm run build`

## Building Executables

### Python
```bash
# Use PyInstaller (optional)
pip install pyinstaller
pyinstaller --onefile --windowed time_widget.py
```

### Tauri
```bash
cd tauri
npm run build
# Executable will be in src-tauri/target/release/
```

### Electron
```bash
npm run build
# Executable will be in dist/
```

## Usage

- **Click ⚙** to open settings
- **Choose time format**: Numeric or Natural
- **Adjust text size**: Use the slider (16px - 64px)
- **Click Save** to apply changes
- **Click ×** to close the widget
- **Drag the window** to move it around
- **Resize** by dragging window edges

## File Structure

```
.
├── time_widget.py          # Python version (standalone)
├── launch_python.bat       # Launch script for Python
├── time_widget_config.json # Python config (auto-generated)
│
├── tauri/                  # Tauri version
│   ├── src/                # Frontend (HTML/CSS/JS)
│   ├── src-tauri/          # Rust backend
│   ├── package.json
│   ├── launch_tauri.bat
│   └── build_tauri.bat
│
├── index.html              # Electron frontend
├── styles.css
├── app.js
├── timeConverter.js
├── main.js                 # Electron main process
├── package.json
├── launch.bat
└── build.bat
```

## Configuration

Settings are automatically saved:
- **Python**: `time_widget_config.json`
- **Tauri/Electron**: Browser localStorage

## Requirements Summary

### Python Version
- Python 3.x (~50-100 MB if not installed)
- No additional packages needed (uses built-in tkinter)

### Tauri Version
- Node.js (~100 MB)
- Rust (auto-installed, ~500 MB one-time)
- Final executable: ~5-10 MB

### Electron Version
- Node.js (~100 MB)
- Final executable: ~150-200 MB

## Space Requirements

### For Running (End Users)
| Version | Executable Size | Additional Requirements |
|---------|----------------|-------------------------|
| **Python** | ~10-20 MB | Python 3.x (usually pre-installed) |
| **Tauri** | **~5-10 MB** | None (standalone) |
| **Electron** | ~150-200 MB | None (standalone) |

### For Development (Building)
| Component | Size | When Needed |
|-----------|------|-------------|
| Python (if not installed) | ~50-100 MB | Only if Python missing |
| Node.js (if not installed) | ~100 MB | For Electron/Tauri dev |
| Rust (Tauri build tool) | ~500 MB | **One-time, only to build Tauri** |
| **Note:** Once built, executables are standalone - no build tools needed! |

### Recommendation
- **Just want to run it?** → Use **Python version** (if Python installed, 0 MB setup)
- **Want smallest executable?** → Build **Tauri version** (5-10 MB, but needs Rust to build)
- **Want easiest distribution?** → Use **Python version** (no build step needed)

## License

GNU General Public License v3.0 - See [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## Notes

- All versions support the same features
- Python version is the lightest if Python is already installed
- Tauri version is best for distribution (smallest executable)
- Electron version is most cross-platform compatible

