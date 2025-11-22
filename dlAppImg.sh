#!/bin/bash

: "${MARCH:=$(uname -m)}" # This is the host machines architecture, not the appimage runtime
: "${NAME:=appimagetool-$MARCH.AppImage}"

if [ -f "$NAME" ]; then exit 0; fi

if [ -f latest ]; then rm latest; fi

echo "Downloading $NAME"

wget -q https://api.github.com/repos/appimage/appimagetool/releases/latest -O latest

if [ ! -f latest ]; then echo "Couldn't fetch GitHub release metadata for AppImagetool"; exit 1; fi

if ! jq -e --arg v "$NAME" '.assets[] | select(.name == $v)' latest >/dev/null; then
	echo "Couldn't find $NAME in metadata for AppImageTool Release"
	exit 1
fi

HASH=$(jq -r --arg v "$NAME" '.assets[] | select(.name == $v) | .digest' latest | grep -oE 'sha256:[0-9a-fA-F]+' | sed 's/^sha256://')
if [[ -z "$HASH" ]]; then echo "Couldn't extract sha256 checksum for $NAME"; exit 1; fi

URI=$(jq -r --arg v "$NAME" '.assets[] | select(.name == $v) | .browser_download_url' latest)
if [[ -z "$URI" ]]; then echo "Couldn't extract URL for $NAME"; exit 1; fi

# Remove metadata file now script is done with it
rm latest

# Create sha256 checksum file
echo "$HASH  $NAME" > "$NAME.sha256"

# Download appimage
if ! wget "$URI" -O "$NAME"; then exit 1; fi

# Check download against expected checksum
if ! sha256sum -c "$NAME.sha256"; then exit 1; fi

# Mark the appimage binary as an executable now that all tests have passed
chmod +x "$NAME"
exit 0
