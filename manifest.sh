#!/bin/bash

# manifest[x]="sha256-url blender-url"

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

manifest[6]="https://download.blender.org/release/Blender4.2/blender-4.2.13.sha256 \
https://download.blender.org/release/Blender4.2/blender-4.2.13-linux-x64.tar.xz"

manifest[7]="https://download.blender.org/release/Blender4.5/blender-4.5.2.sha256 \
https://download.blender.org/release/Blender4.5/blender-4.5.2-linux-x64.tar.xz"

MAX=8 # Total number of manifest entries

print_options() {
	for ((i = 0; i < MAX; i++)); do
		read -r -a urls <<< "${manifest[$i]}"
		url="${urls[1]}"
		filename="${url##*/}"
		filename="${filename%.tar*}"
		echo "$i: $filename"
	done

	echo "a: Run all"
	echo "q: Quit"
}

run_selection() {
	local selection=$1
	if [[ $selection == "a" ]]; then
		for ((i = 0; i < MAX; i++)); do
		  read -r -a urls <<< "${manifest[$i]}"
			./mkAppImg.sh "${urls[0]}" "${urls[1]}"
		done
	elif [[ $selection == "q" ]]; then
		echo "Quitting."
		exit 0
	elif [[ $selection -ge 0 && $selection -lt $MAX ]]; then
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
	print_options
	read -rp "Select options by numbers separated by space or a letter: " -a selections

	if [[ ${#selections[@]} -eq 0 ]]; then
		echo "No selection made."
		exit 1
	fi

	for selection in "${selections[@]}"; do
		run_selection "$selection"
	done
fi
