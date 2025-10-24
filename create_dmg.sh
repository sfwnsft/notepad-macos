#!/bin/bash
set -euo pipefail

APP_NAME="Notepad.app"
DMG_NAME="Notepad.dmg"

if [ ! -d "$APP_NAME" ]; then
  echo "App bundle $APP_NAME not found. Run ./build.sh first." >&2
  exit 1
fi

rm -f "$DMG_NAME"

hdiutil create -volname "Notepad" -srcfolder "$APP_NAME" -ov -format UDZO "$DMG_NAME"

echo "Created $DMG_NAME"
