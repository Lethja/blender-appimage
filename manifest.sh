#!/bin/bash

# manifest[x]="checksum-url tarball-url"

manifest[0]="https://download.blender.org/release/Blender2.79/release279b.sha256 \
https://download.blender.org/release/Blender2.79/blender-2.79b-linux-glibc219-i686.tar.bz2"

manifest[1]="https://download.blender.org/release/Blender2.79/release279b.sha256 \
https://download.blender.org/release/Blender2.79/blender-2.79b-linux-glibc219-x86_64.tar.bz2"

manifest[2]="https://download.blender.org/release/Blender2.83/blender-2.83.20.sha256 \
https://download.blender.org/release/Blender2.83/blender-2.83.20-linux-x64.tar.xz"

manifest[3]="https://download.blender.org/release/Blender2.93/blender-2.93.18.sha256 \
https://download.blender.org/release/Blender2.93/blender-2.93.18-linux-x64.tar.xz"

manifest[4]="https://download.blender.org/release/Blender3.3/blender-3.3.21.sha256 \
https://download.blender.org/release/Blender3.3/blender-3.3.21-linux-x64.tar.xz"

manifest[5]="https://download.blender.org/release/Blender3.6/blender-3.6.23.sha256 \
https://download.blender.org/release/Blender3.6/blender-3.6.23-linux-x64.tar.xz"

manifest[6]="https://download.blender.org/release/Blender4.2/blender-4.2.18.sha256 \
https://download.blender.org/release/Blender4.2/blender-4.2.18-linux-x64.tar.xz"

manifest[7]="https://download.blender.org/release/Blender4.5/blender-4.5.7.sha256 \
https://download.blender.org/release/Blender4.5/blender-4.5.7-linux-x64.tar.xz"

manifest[8]="https://download.blender.org/release/Blender5.0/blender-5.0.1.sha256 \
https://download.blender.org/release/Blender5.0/blender-5.0.1-linux-x64.tar.xz"

print_options_dialog() {
	local choices text dialog_options=()

	for ((i = 0; i < ${#manifest[@]}; i++)); do
  		read -r -a urls <<< "${manifest[$i]}"
  		url="${urls[1]}"
  		filename="${url##*/}"
  		filename="${filename%.tar*}"
  		dialog_options+=("$i" "$filename" "off")
	done

	text="Use the up/down arrow keys to move through the menu and space to toggle the highlighted selection.
Use left/right arrow keys to select OK/Cancel and press Enter to continue."

	choices=$(dialog --checklist "$text" 0 0 0 "${dialog_options[@]}" 3>&1 1>&2 2>&3)
	dialog --clear

	eval "selections=($choices)"
}

print_options() {
	for ((i = 0; i < ${#manifest[@]}; i++)); do
		read -r -a urls <<< "${manifest[$i]}"
		url="${urls[1]}"
		filename="${url##*/}"
		filename="${filename%.tar*}"
		echo "$i: $filename"
	done

	echo "a: Run all"
	echo "q: Quit"

	read -rp "Select options by numbers separated by space or a letter: " -a selections
}

run_selection() {
	local selection=$1
	if [[ $selection == "a" ]]; then
		for ((i = 0; i < ${#manifest[@]}; i++)); do
		  read -r -a urls <<< "${manifest[$i]}"
			./mkAppImg.sh "${urls[0]}" "${urls[1]}"
		done
	elif [[ $selection == "q" ]]; then
		echo "Quitting."
		exit 0
	elif [[ $selection -ge 0 && $selection -lt ${#manifest[@]} ]]; then
    read -r -a urls <<< "${manifest[$selection]}"
    ./mkAppImg.sh "${urls[0]}" "${urls[1]}"
	else
		echo "Invalid selection: $selection"
	fi
}

if [ $# -gt 0 ]; then
	if [[ "$*" =~ " q " ]]; then
		exit 0
	fi

	if [[ "$*" =~ " a " ]]; then
		run_selection "a"
	else
		for selection in "$@"; do
			run_selection "$selection"
		done
	fi
else
	if command -v dialog &> /dev/null; then
		print_options_dialog
	else
		print_options
	fi

	if [[ ${#selections[@]} -eq 0 ]]; then
		echo "No selection made."
		exit 1
	fi

	for selection in "${selections[@]}"; do
		run_selection "$selection"
	done
fi
