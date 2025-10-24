#!/bin/bash
set -euo pipefail

# Generates Notepad.icns from an embedded tiny PNG (base64) using sips and iconutil.
# This is a minimal placeholder icon. Replace icon.png with a better PNG if you want.

OUT_ICNS="Notepad.icns"
ICON_PNG="icon.png"
ICONSET_DIR="icon.iconset"

# If the user placed a custom icon.png in the repo, use it. Otherwise decode embedded fallback.
CREATED_FALLBACK=0
if [ -f "$ICON_PNG" ] && [ -s "$ICON_PNG" ]; then
    echo "Using existing $ICON_PNG"
else
    echo "$ICON_PNG not found — decoding builtin placeholder into $ICON_PNG"
    CREATED_FALLBACK=1
    cat > icon.b64 << 'PNGBASE64'
iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR4nGNgYAAAAAMAASsJTYQAAAAASUVORK5CYII=
PNGBASE64

    # decode base64 into PNG (macOS: base64 -D). Fallback to --decode if available.
    if base64 -D -i icon.b64 -o "$ICON_PNG" 2>/dev/null; then
        :
    elif base64 --decode icon.b64 > "$ICON_PNG" 2>/dev/null; then
        :
    else
        # try openssl as last resort
        openssl base64 -d -in icon.b64 -out "$ICON_PNG"
    fi
    rm -f icon.b64
fi

# Create iconset directory
rm -rf "$ICONSET_DIR"
mkdir -p "$ICONSET_DIR"

# Create the various icon sizes using sips (will upscale the tiny PNG; replace with a real image for better results)
sips -z 16 16     "$ICON_PNG" --out "$ICONSET_DIR/icon_16x16.png"
sips -z 32 32     "$ICON_PNG" --out "$ICONSET_DIR/icon_16x16@2x.png"
sips -z 32 32     "$ICON_PNG" --out "$ICONSET_DIR/icon_32x32.png"
sips -z 64 64     "$ICON_PNG" --out "$ICONSET_DIR/icon_32x32@2x.png"
sips -z 128 128   "$ICON_PNG" --out "$ICONSET_DIR/icon_128x128.png"
sips -z 256 256   "$ICON_PNG" --out "$ICONSET_DIR/icon_128x128@2x.png"
sips -z 256 256   "$ICON_PNG" --out "$ICONSET_DIR/icon_256x256.png"
sips -z 512 512   "$ICON_PNG" --out "$ICONSET_DIR/icon_256x256@2x.png"
sips -z 512 512   "$ICON_PNG" --out "$ICONSET_DIR/icon_512x512.png"
sips -z 1024 1024 "$ICON_PNG" --out "$ICONSET_DIR/icon_512x512@2x.png"

# Create .icns
if command -v iconutil >/dev/null 2>&1; then
    iconutil -c icns "$ICONSET_DIR" -o "$OUT_ICNS"
    echo "Created $OUT_ICNS"
else
    echo "iconutil is not available. Please run this on macOS with Xcode command-line tools installed." >&2
    exit 1
fi

# Cleanup: remove the iconset and remove the fallback icon.png only if we created it
if [ -d "$ICONSET_DIR" ]; then
    rm -rf "$ICONSET_DIR"
fi
if [ "$CREATED_FALLBACK" -eq 1 ]; then
    rm -f "$ICON_PNG"
fi

exit 0
