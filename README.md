# Summary

If you need to run a version of Blender on Linux that isn't in your Linux distribution repository,  
it can be cumbersome to set up and run,
especially for rolling distributions where the system version of Python can change.
While Blender's website offers downloads for portable versions of Blender for Linux in a tarball,
extracting these tarballs somewhere and maintaining a path hierarchy is also cumbersome and suboptimal.
This repository contains two small bash scripts that download these same
portable tarball releases of Blender LTS for Linux and convert them into an AppImage.

Using these AppImages is as easy as extracting the zip somewhere and double-clicking it.
There is no need to add a custom repository or run a shell script with root privileges.
You can even download and run two different AppImage versions of Blender at the same time.

For more information on how AppImages work, visit https://appimage.org/

# Download

AppImage builds are available on the [Releases](https://github.com/Lethja/blender-appimage/releases) page.
Download and extract the zip, then double-click on the extracted AppImage to run.

Releases specify the date the AppImage is built rather than the version of Blender.
If a new version of Blender comes out, then a new release will be made with just that version.
If there's a change to the script, then there will be a new release with the latest of each LTS version.
This means you may need to look through older releases to find older versions of Blender
if `mkAppImg.sh` hasn't been updated in a while.

# Build yourself

## Dependencies

You will need a Linux x86_64 machine to build an AppImage

On a terminal run the following to make sure scripts dependencies are installed

```shell
which md5sum sed sha256sum tar wget zip > /dev/null
```

The command will exit without printing anything if all dependencies are satisfied.
If this is not the case, refer to your distribution documentation to determine what packages to install.

## Build a LTS version

Run the manifest script in a terminal

```shell
./manifest.sh
```

A selection list similar to this will appear:

```
0: blender-2.79b-linux-glibc219-i686
1: blender-2.79b-linux-glibc219-x86_64
2: blender-2.83.20-linux-x64
3: blender-2.93.18-linux-x64
4: blender-3.3.21-linux-x64
5: blender-3.6.16-linux-x64
6: blender-4.2.2-linux-x64
Select options by numbers separated by space or a letter:
```

Type the number(s) of the Blender version(s) to make an AppImage of and press enter.

The AppImage will be created and stored in a zip automatically.
Storing an AppImage in a zip archive will preserve the files executable permission.  
This will make deployment more streamlined and feel more familiar to macOS and Windows users.

## Build an unlisted version

To create an AppImage of a Blender version not included in the manifest script's predefined list
(such as experimental or archived Blender releases), 
provide the URL for the hash checksum and the source tarball directly to `mkAppImg.sh`.

Example:

```shell
./mkAppImg.sh https://download.blender.org/release/Blender2.79/release279.md5 https://download.blender.org/release/Blender2.79/blender-2.79-linux-glibc219-x86_64.tar.bz2
```
