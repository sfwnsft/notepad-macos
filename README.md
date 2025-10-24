# Notepad  
## A native macOS Notepad made with Swift and AppKit. 

**Installation**: Download Notepad.zip and decompress it. Then move Notepad.app to the "Applications" folder to use it.  

**Build the app locally**

```bash
cd notepad-macos
chmod +x build.sh create_dmg.sh
./build.sh

# Launch the app via Finder or:
open Notepad.app

# Or run the binary directly (useful for debugging):
./Notepad.app/Contents/MacOS/Notepad
```

**Create a Disk Image (.dmg)**

```bash
./create_dmg.sh
# This writes Notepad.dmg into the repository root (or overwrites if present).
```

Author: Safwan Safat  
This project is licensed under the MIT License. 
