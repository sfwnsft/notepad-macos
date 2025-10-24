# Simple Notepad (C)
```markdown
# Simple Notepad — Console version (C)

A tiny, standalone console notepad written in C. This repository also contains a macOS GUI version (see `README_GUI.md`).

Quick build (console)

```bash
gcc -std=c11 -Wall -Wextra -o notepad test.c
```

Run

```bash
./notepad
```

Basic usage

- Start a new editing session or open an existing file.
- In the simple editor mode, commands begin with `:` on a line by itself. Useful commands:
  - `:w [filename]`  — save (uses current filename if omitted)
  - `:wq [filename]` — save and quit
  - `:q`             — quit (prompts if unsaved)
  - `:p`             — print buffer to stdout
  - `:e filename`    — open another file
  - `:h` or `:help`  — show help

Notes

- This is intentionally minimal: no line numbers, no syntax highlighting, and no random-access editing.
- The code demonstrates a simple buffer growth strategy and basic file operations in C.

Where to look

- `Notepad.c` — the console notepad implementation.
- `README_GUI.md` — macOS GUI version details and packaging instructions.

License

This project is licensed under the MIT License — see the `LICENSE` file for details.

Contact / Author

Safwan Safat — https://github.com/sfwnsft — safwansafatswe@gmail.com

```

Latest local build (artifact info)

- Version: 0.1.0 (CFBundleShortVersionString)
- Build: 1 (CFBundleVersion)
- Built: 2025-10-24T13:19:38Z (UTC)
- Artifacts produced by the local macOS build (see `README_GUI.md` for build steps):
  - `Notepad.app/` — app bundle (generated)
  - `Notepad.icns` — generated icon (~198 KB)
  - `Notepad.dmg` — packaged disk image (~209 KB)

Reproducibility

```bash
# Rebuild the app and create a new dmg (macOS):
chmod +x build.sh create_dmg.sh generate_icon.sh
./build.sh
./create_dmg.sh
```

Notes

- The created artifacts are ignored by `.gitignore` so the repo stays clean.
- Signing and notarization must be done with an Apple Developer ID before public distribution.
