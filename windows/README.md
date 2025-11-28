# Windows Installer for Memvid

This directory contains the NSIS installer script for creating a Windows installer for Memvid.

## Requirements

- [NSIS](https://nsis.sourceforge.io/Download) (Nullsoft Scriptable Install System) installed on Windows
- The Windows executable (`memorycli.exe`) - either from GitHub releases or built locally

## Building the Installer

### Option 1: Using Pre-built Executable from GitHub Releases

1. Download the Windows build from GitHub releases:
   - Go to the [releases page](https://github.com/memvid/memory-cli/releases)
   - Download `memorycli-x86_64-pc-windows-msvc.zip`
   - Extract `memorycli.exe` from the zip file
   - Place `memorycli.exe` in the `windows` directory

2. Navigate to the `windows` directory:
   ```cmd
   cd windows
   ```

3. Compile the installer using NSIS:
   ```cmd
   makensis installer.nsi
   ```

   This will create `memvid-installer.exe` in the `windows` directory.

### Option 2: Building from Source

1. Build the Windows executable:
   ```cmd
   # Install Windows target (if not already installed)
   rustup target add x86_64-pc-windows-msvc

   # Build the project
   cargo build --release --target x86_64-pc-windows-msvc

   # Copy the executable to windows folder
   copy target\x86_64-pc-windows-msvc\release\memorycli.exe windows\memorycli.exe
   ```

2. Navigate to the `windows` directory and build the installer:
   ```cmd
   cd windows
   makensis installer.nsi
   ```

## What the Installer Does

1. **Welcome Page**: Shows a welcome message with description and logo
2. **License Agreement**: Displays the MIT license from `../LICENSE` file
3. **Installation**: 
   - Copies `memorycli.exe` to `C:\Program Files\Memvid\` and renames it to `memvid.exe`
   - Adds `C:\Program Files\Memvid\` to the system PATH
   - Creates an uninstaller
   - Registers the application in Windows Add/Remove Programs

## Uninstallation

Users can uninstall Memvid through:
- Windows Settings > Apps > Memvid > Uninstall
- Or by running `Uninstall.exe` from the installation directory

The uninstaller will:
- Remove `memvid.exe` from the system
- Remove the installation directory from PATH
- Clean up registry entries

## Files

- `installer.nsi` - NSIS installer script
- `logo.bmp` - Logo image displayed on welcome and finish pages
- `memorycli.exe` - Windows executable (place this file here before building)

## Notes

- The installer requires `memorycli.exe` to be present in the `windows` directory before building
- The installer reads the license from `../LICENSE` (project root)
- The installer will be named `memvid-installer.exe` when built

