#!/bin/bash

download_and_verify() {
	local fileUri="$1"
	local hashUri="$2"

	if [ -n "$hashUri" ]; then
		if [ ! -f "data/${hashUri##*/}" ]; then
			echo "Downloading $hashUri..."
			wget -O "data/${hashUri##*/}" "$hashUri" || exit 1
		fi
	fi

	if [ ! -f "data/${fileUri##*/}" ]; then
		echo "Downloading $fileUri..."
		wget -O "data/${fileUri##*/}" "$fileUri" || exit 1
	fi

	if [ -n "$hashUri" ]; then
		local hashName="${hashUri##*/}"
		local hashExt="${hashName##*.}"
		grep " ${fileUri##*/}$" "data/$hashName" | sed 's|  |  data/|' | "${hashExt}sum" -c - || exit 1
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

TAR_NAME="${2##*/}"
: "${MARCH:=$(uname -m)}"

if [[ $TAR_NAME =~ (x64|x86_64) ]]; then
	ARCH=x86_64
	OUTPUT="${TAR_NAME%-linux*}-x86_64.AppImage"
elif [[ $TAR_NAME =~ (i686) ]]; then
	ARCH=i686
	OUTPUT="${TAR_NAME%-linux*}-i686.AppImage"
fi

if ! mkdir -p data zip; then echo "Couldn't create folders"; exit 1; fi

MARCH="$MARCH" ./dlAppImg.sh
download_and_verify "$2" "$1"

echo "Extracting $TAR_NAME"

# Always work on a fresh extraction
if [ -e "AppDir" ]; then rm -R "AppDir"; fi

mkdir -p AppDir
tar -xf "data/$TAR_NAME" -C AppDir --strip-components=1 || exit 1

echo "Reconfiguring files in preparation for AppImage..."

if [[ -f "AppDir/blender-launcher" ]]; then
	create_apprun_script "AppDir/AppRun" "blender-launcher"
else
	create_apprun_script "AppDir/AppRun" "blender"
fi

# Add X- in front of desktop entries to make appimage happy
sed -i 's/PrefersNonDefaultGPU/X-PrefersNonDefaultGPU/' "AppDir/blender.desktop"

echo "Creating AppImage $OUTPUT..."

ARCH="$ARCH" "./appimagetool-$MARCH.AppImage" -n AppDir "$OUTPUT"

if [[ ! -f "$OUTPUT" ]]; then exit 1; fi

chmod +x "$OUTPUT"

echo "Zipping $OUTPUT into zip/${OUTPUT}.zip..."

zip -0 "zip/${OUTPUT}.zip" "$OUTPUT"

echo "Cleaning up..."

rm -R AppDir "$OUTPUT"

echo "$OUTPUT successfully made and stored in zip/${OUTPUT}.zip"
