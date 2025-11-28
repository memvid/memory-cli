# Windows Installer for Memvid

This directory contains the NSIS installer script for creating a Windows installer for Memvid.

## Requirements

- [NSIS](https://nsis.sourceforge.io/Download) (Nullsoft Scriptable Install System) installed on **Windows**
- The Windows executable (`memorycli.exe`) from GitHub releases

**Note:** NSIS (`makensis`) is a Windows-only tool. You need to build the installer on a Windows machine or use the automated GitHub Actions workflow (see below).

## Building the Installer on Windows

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

## Automated Build via GitHub Actions

The installer is automatically built during releases via GitHub Actions. When you create a release tag (e.g., `v0.1.6`), the workflow will:
1. Build the Windows executable
2. Create the NSIS installer using the `windows/installer.nsi` script
3. Upload `memvid-installer.exe` as a release asset alongside the other binaries

No manual steps required! The installer will be available in the GitHub releases page.

## Alternative: Building from Source

If you prefer to build the executable yourself:

```bash
# Install Windows target (if not already installed)
rustup target add x86_64-pc-windows-msvc

# Build the project
cargo build --release --target x86_64-pc-windows-msvc

# Copy the executable to windows folder
cp target/x86_64-pc-windows-msvc/release/memorycli.exe windows/
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
- `memorycli.exe` - Windows executable (download from GitHub releases)

