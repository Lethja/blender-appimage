#!/bin/bash

# AI = AppImage
AppImageUri="https://github.com/AppImage/AppImageKit/releases/download/13/appimagetool-x86_64.AppImage"
AppImageHash="df3baf5ca5facbecfc2f3fa6713c29ab9cefa8fd8c1eac5d283b79cab33e4acb"

download_and_verify() {
	local fileUri="$1"
	local hashUri="$2"

  if [ -n "$hashUri" ]; then
    if [ ! -f "${hashUri##*/}" ]; then
      echo "Downloading $hashUri..."
      wget -O "${hashUri##*/}" "$hashUri"
    fi
	fi

	if [ ! -f "${fileUri##*/}" ]; then
		echo "Downloading $fileUri..."
		wget -O "${fileUri##*/}" "$fileUri"
	fi

  if [ -n "$hashUri" ]; then
    grep " ${fileUri##*/}$" "${hashUri##*/}" | sha256sum -c -
  fi
}

create_apprun_script() {
	cat << EOF > "$1"
#!/bin/bash
APPDIR="\$(dirname "\$(readlink -f "\$0")")"
exec "\$APPDIR/$2" "\$@"
EOF

	chmod +x "$1"
}

echo "Downloading and verifying content"

download_and_verify "$AppImageUri"
echo "$AppImageHash  ${AppImageUri##*/}" | sha256sum -c -
chmod +x "${AppImageUri##*/}"

download_and_verify "$2" "$1"

TAR_NAME="${2##*/}"

echo "Extracting $TAR_NAME"

# Always work on a fresh extraction
if [ -e "AppDir" ]; then
	rm -R "AppDir"
fi

mkdir -p AppDir
tar -xf "$TAR_NAME" -C AppDir --strip-components=1

echo "Reconfiguring files in preparation for AppImage..."

if [[ -f "AppDir/blender-launcher" ]]; then
  create_apprun_script "AppDir/AppRun" "blender-launcher"
else
  create_apprun_script "AppDir/AppRun" "blender"
fi

if [[ $TAR_NAME =~ (x64|x86_64) ]]; then
  ARCH=x86_64
  OUTPUT="${TAR_NAME%-linux*}-x86_64.AppImage"
elif [[ $TAR_NAME =~ (i686) ]]; then
  ARCH=i686
  OUTPUT="${TAR_NAME%-linux*}-i686.AppImage"
fi

# Add X- in front of desktop entries to make appimage happy
sed -i 's/PrefersNonDefaultGPU/X-PrefersNonDefaultGPU/' "AppDir/blender.desktop"

echo "Creating AppImage $OUTPUT..."

"./${AppImageUri##*/}" -n AppDir "$OUTPUT"

if [[ ! -f "$OUTPUT" ]]; then
  exit 1
fi

echo "Zipping $OUTPUT into ${OUTPUT}.zip..."

zip -0 "${OUTPUT}.zip" "$OUTPUT"

echo "Cleaning up..."

rm -R AppDir "$OUTPUT"

echo "$OUTPUT successfully made and stored in ${OUTPUT}.zip"