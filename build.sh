#!/bin/bash
set -euo pipefail

APP_NAME="Notepad"
BUNDLE_NAME="$APP_NAME.app"
EXECUTABLE="$APP_NAME"
SRC="main.swift"
BUILD_DIR="build"

rm -rf "$BUILD_DIR" "$BUNDLE_NAME"
mkdir -p "$BUILD_DIR"

swiftc -o "$BUILD_DIR/$EXECUTABLE" "$SRC" -framework Cocoa

mkdir -p "$BUNDLE_NAME/Contents/MacOS"
mkdir -p "$BUNDLE_NAME/Contents/Resources"
cp "$BUILD_DIR/$EXECUTABLE" "$BUNDLE_NAME/Contents/MacOS/$EXECUTABLE"
cp Info.plist "$BUNDLE_NAME/Contents/Info.plist"

if [ -f Notepad.icns ]; then
	cp Notepad.icns "$BUNDLE_NAME/Contents/Resources/Notepad.icns"
else
	echo "Warning: Notepad.icns not found. App will use default icon." >&2
fi

echo "Built $BUNDLE_NAME"

echo "You can run it with: ./$BUNDLE_NAME/Contents/MacOS/$EXECUTABLE or open it via Finder." > /dev/stderr
chmod +x "$BUNDLE_NAME/Contents/MacOS/$EXECUTABLE"