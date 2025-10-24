# Notepad — macOS GUI

This repository contains a native macOS Notepad implemented with Swift and AppKit. The project has been simplified to focus on the GUI application and macOS distribution. The previous console C program and the icon-generation pipeline have been removed to reduce repository clutter.

Contents

- `main.swift` — AppKit application source (single-window text editor with File/Edit menus and About panel).
- `Info.plist` — bundle metadata (CFBundle identifier, version, icon reference).
- `build.sh` — builds `Notepad.app` from the Swift source.
- `create_dmg.sh` — packages `Notepad.dmg` using `hdiutil`.
- `Notepad.app` / `Notepad.dmg` — build artifacts (not tracked by git by default).
- `Notepad.icns` — last generated icon (artifact; not tracked).
- `LICENSE`, `.gitignore`, `README.md` — documentation and repo config.

Build & run (macOS)

Make the scripts executable and build the app locally:

```bash
cd "/Users/safwan/Documents/GitHub/New Project"
chmod +x build.sh create_dmg.sh
./build.sh

# Launch the app via Finder or:
open Notepad.app
# Or run the binary directly (useful for debugging):
./Notepad.app/Contents/MacOS/Notepad
```

Create a DMG

```bash
./create_dmg.sh
# This writes Notepad.dmg into the repository root (or overwrites if present).
```

Notes about removed files

- The old console program (`Notepad.c`) has been removed and is no longer part of the project. If you need it later, it can be restored from the git history.
- The icon-generation pipeline (`generate_icon.sh`, `make_notepad_icon.swift`, `icon.png`) has been removed. The repository keeps the last generated `Notepad.icns` as a local artifact; if you want the pipeline back I can reintroduce it or provide a simpler script.

Code signing & notarization

- The provided scripts do not perform code signing or notarization. To distribute the app without Gatekeeper warnings, sign the app with a Developer ID certificate and notarize the DMG. Example commands (replace placeholders):

```bash
codesign --timestamp --options runtime --sign "Developer ID Application: Your Name (TEAMID)" Notepad.app
xcrun notarytool submit Notepad.dmg --apple-id "you@domain" --team-id TEAMID --password @keychain:NOTARY_PASSWORD
xcrun stapler staple Notepad.dmg
```

Latest local build

- Version: 0.1.0
- Build: 1
- Built: 2025-10-24T13:19:38Z (UTC)

If you'd like

1. I can remove `Notepad.icns` from the working tree (keep it ignored), or keep it for convenience.
2. I can add a GitHub Actions macOS workflow to build the app automatically on pushes/PRs.
3. I can re-add the icon-generation pipeline or provide a small utility to produce an `.icns` from a PNG.

Author & license

Safwan Safat — https://github.com/sfwnsft — safwansafatswe@gmail.com

This project is licensed under the MIT License — see `LICENSE` for details.
