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
./build.sh
# Launch the app:
open Notepad.app
# Or run the binary directly (for debugging):
./Notepad.app/Contents/MacOS/Notepad
```

Create a dmg:

```bash
./create_dmg.sh
```

Notes & requirements
- Requires macOS with the Swift toolchain and Cocoa/AppKit available (Xcode command-line tools).
- The produced `.dmg` is not code-signed. If you intend to distribute it, you'll likely want to sign it and notarize it with Apple.
- This is intentionally small and portable; for a production app, create an Xcode project and add proper icons/entitlements and signing.

If you want, I can:
- Add an app icon and include it in the bundle.
- Create a simple Xcode project instead (easier to iterate with Interface Builder).
- Add code signing and notarization instructions (you'll need an Apple Developer account).
