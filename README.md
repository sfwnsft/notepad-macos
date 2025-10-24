# Simple Notepad (C)

This is a small standalone console notepad written in C.

Build

```bash
gcc -std=c11 -Wall -Wextra -o notepad test.c
```

Run

```bash
./notepad
```

Usage

- Choose `New file` or `Open file` from the menu.
- In editor mode, type text lines. Commands start with `:` on a line by itself.
  - `:w [filename]`  — save (use current filename if omitted)
  - `:wq [filename]` — save and quit editor
  - `:q`             — quit editor (asks if unsaved)
  - `:p`             — print buffer
  - `:e filename`    — open another file
  - `:h` or `:help`  — show help

Notes

- This program stores the file content in a single dynamically grown buffer.
- It is intentionally simple; features like line numbers, random-access editing, or syntax highlighting are not provided.

License

This project is licensed under the MIT License — see the `LICENSE` file for details.

If you share prebuilt binaries (for convenience), note that unsigned macOS apps may trigger Gatekeeper warnings. To run an unsigned app, users can right-click the app and choose "Open" and then confirm in the dialog. For a smooth experience, sign and notarize the app (requires an Apple Developer account).
