# Notepad macOS GUI

This folder contains a minimal native macOS Notepad implemented with Swift/AppKit.

Files:
- `main.swift` — AppKit-based app (single window with an NSTextView). Supports New/Open/Save/Save As.
- `Info.plist` — bundle information for the .app
- `build.sh` — compiles `main.swift`, creates a `.app` bundle
- `create_dmg.sh` — packages the `.app` into a compressed `.dmg` (uses `hdiutil`)

Build and run (on macOS):

```bash
cd "/Users/safwan/Documents/GitHub/New Project"
chmod +x build.sh create_dmg.sh
```markdown
# Notepad — macOS GUI

This repository contains a small native macOS Notepad implemented in Swift using AppKit. The app is a single-window text editor with standard File and Edit menus and an About panel that includes developer links.

Project status (finalized)

- GUI implemented in `main.swift` (AppDelegate + single `NSTextView`).
- Icon generation pipeline included (`make_notepad_icon.swift`, `generate_icon.sh`) to produce `Notepad.icns`.
- Build script (`build.sh`) compiles the app and assembles the `.app` bundle.
- Packaging script (`create_dmg.sh`) creates a compressed `Notepad.dmg` using `hdiutil`.
- Windows artifacts were intentionally removed; this repo is macOS-only.

Files of interest

- `main.swift` — the AppKit application source.
- `Info.plist` — bundle metadata (version, icon reference).
- `make_notepad_icon.swift`, `generate_icon.sh` — icon generation pipeline.
- `Notepad.icns` — generated application icon (not tracked in git; see `.gitignore`).
- `build.sh` — builds `Notepad.app`.
- `create_dmg.sh` — creates `Notepad.dmg`.
- `test.c` — original console notepad (kept for reference).

Build & run (macOS)

Make scripts executable and build the app:

```bash
cd "/Users/safwan/Documents/GitHub/New Project"
chmod +x build.sh create_dmg.sh generate_icon.sh
./build.sh

# Run the app (Finder or CLI):
open Notepad.app
# or for debugging:
./Notepad.app/Contents/MacOS/Notepad
```

Generate icon (optional)

If you want to regenerate the icon set and `Notepad.icns`:

```bash
chmod +x generate_icon.sh
./generate_icon.sh
```

Package a DMG

```bash
./create_dmg.sh
# this writes Notepad.dmg next to the repo root
```

Signing & notarization (notes)

- The DMG produced by `create_dmg.sh` is not signed. Codesigning and notarization require an Apple Developer ID certificate installed in the Keychain and an app-specific password for the notarization service.
- Local check performed on the build machine: no valid signing identities were available, so signing was not performed here.
- To sign locally (example):

```bash
# codesign the app (replace "Developer ID Application: Your Name (TEAMID)")
codesign --timestamp --options runtime --sign "Developer ID Application: Your Name (TEAMID)" Notepad.app

# staple and notarize the dmg (example with xcrun notarytool)
# xcrun notarytool submit Notepad.dmg --apple-id "you@domain" --team-id TEAMID --password @keychain:AC_PASSWORD
# xcrun stapler staple Notepad.dmg
```

Repository & release notes

- The repo has been cleaned of Windows artifacts and temporary build outputs. Generated files (app, dmg, icns) are ignored via `.gitignore`.
- A local build and DMG were produced to verify packaging; signing and notarization were intentionally left to the user (requires credentials).

Suggested next steps

1. If you want CI: add a GitHub Actions workflow that runs `./build.sh` on macOS runners.
2. Create a GitHub repository, add as a remote, and push the commits. Example commands to run locally:

```bash
git remote add origin git@github.com:yourname/notepad.git
git push -u origin main
```

3. If distributing broadly: sign and notarize the `.dmg` and add release notes attaching `Notepad.dmg` to a GitHub Release.

Author & license

Safwan Safat — https://github.com/sfwnsft — safwansafatswe@gmail.com

This project is licensed under the MIT License. See `LICENSE` for details.

```

Latest local build (artifact info)

- Version: 0.1.0 (CFBundleShortVersionString)
- Build: 1 (CFBundleVersion)
- Built: 2025-10-24T13:19:38Z (UTC)
- Artifacts produced by local build:
	- `Notepad.app/` — app bundle (generated)
	- `Notepad.icns` — generated icon (~198 KB)
	- `Notepad.dmg` — packaged disk image (~209 KB)

Notes:

- These artifacts are intentionally not tracked in git (see `.gitignore`). If you remove them locally, re-run `./build.sh` and `./create_dmg.sh` to reproduce.
- Signing and notarization are not performed by the scripts; they must be done with a Developer ID certificate prior to distribution.
