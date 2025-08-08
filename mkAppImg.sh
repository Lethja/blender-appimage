#!/bin/bash

download_runtime() {
  local pubUri="https://github.com/AppImage/type2-runtime/releases/download/continuous/signing-pubkey.asc"
  local runUri="https://github.com/AppImage/type2-runtime/releases/download/continuous/runtime-$1"
  local sigUri="$runUri.sig"
  local gpgDir="gpg"

  if [ -n "$pubUri" ]; then
    if [ ! -f "${pubUri##*/}" ]; then
      echo "Downloading $pubUri..."
      wget -O "${pubUri##*/}" "$pubUri" || exit 1
    fi
  fi
  if [ ! -d "$gpgDir" ]; then
    mkdir -p $gpgDir
    chmod 700 $gpgDir
    GNUPGHOME="$gpgDir" gpg --quiet --import "${pubUri##*/}"
  fi
  if [ -n "$sigUri" ]; then
    if [ ! -f "${sigUri##*/}" ]; then
      echo "Downloading $sigUri..."
      wget -O "${sigUri##*/}" "$sigUri" || exit 1
    fi
  fi
  if [ -n "$runUri" ]; then
    if [ ! -f "${runUri##*/}" ]; then
      echo "Downloading $sigUri..."
      wget -O "${runUri##*/}" "$runUri" || exit 1
    fi
  fi
  GNUPGHOME="$gpgDir" gpg --verify "${sigUri##*/}" "${runUri##*/}" || exit 1
}

download_and_verify() {
	local fileUri="$1"
	local hashUri="$2"

	if [ -n "$hashUri" ]; then
		if [ ! -f "${hashUri##*/}" ]; then
			echo "Downloading $hashUri..."
			wget -O "${hashUri##*/}" "$hashUri" || exit 1
		fi
	fi

	if [ ! -f "${fileUri##*/}" ]; then
		echo "Downloading $fileUri..."
		wget -O "${fileUri##*/}" "$fileUri" || exit 1
	fi

	if [ -n "$hashUri" ]; then
	  local hashName="${hashUri##*/}"
	  local hashExt="${hashName##*.}"
		grep " ${fileUri##*/}$" "$hashName" | "${hashExt}sum" -c - || exit 1
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

if [[ $TAR_NAME =~ (x64|x86_64) ]]; then
	ARCH=x86_64
	OUTPUT="${TAR_NAME%-linux*}-x86_64.AppImage"
elif [[ $TAR_NAME =~ (i686) ]]; then
	ARCH=i686
	OUTPUT="${TAR_NAME%-linux*}-i686.AppImage"
fi

download_runtime "$ARCH"

download_and_verify "$2" "$1"

echo "Extracting $TAR_NAME"

# Always work on a fresh extraction
if [ -e "AppDir" ]; then
	rm -R "AppDir"
fi

mkdir -p AppDir
tar -xf "$TAR_NAME" -C AppDir --strip-components=1 || exit 1

echo "Reconfiguring files in preparation for AppImage..."

if [[ -f "AppDir/blender-launcher" ]]; then
	create_apprun_script "AppDir/AppRun" "blender-launcher"
else
	create_apprun_script "AppDir/AppRun" "blender"
fi

# Add X- in front of desktop entries to make appimage happy
sed -i 's/PrefersNonDefaultGPU/X-PrefersNonDefaultGPU/' "AppDir/blender.desktop"

echo "Creating AppImage $OUTPUT..."

mksquashfs AppDir squashfs -noappend -comp gzip || exit 1
cat "runtime-$ARCH" squashfs > "$OUTPUT" || exit 1

if [[ ! -f "$OUTPUT" ]]; then exit 1; fi

chmod +x "$OUTPUT"

echo "Zipping $OUTPUT into ${OUTPUT}.zip..."

zip -0 "${OUTPUT}.zip" "$OUTPUT"

echo "Cleaning up..."

rm -R AppDir squashfs "$OUTPUT"

echo "$OUTPUT successfully made and stored in ${OUTPUT}.zip"
