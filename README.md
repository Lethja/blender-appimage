# Summary
If you need to run a version of Blender on Linux that isn't in your distributions repositoryDownload and extract the zip then double-click on the extracted AppImage to run 
it can be cumbersome to run, especially for rolling distributions where the system version of Python can change. 
While Blenders website offers portable versions for Linux in a tarball, 
extracting these tarballs somewhere and maintaing a path hierarchy is also less than ideal.

This repository contains two small bash scripts that download official Linux tarball releases of Blender LTS 
and converts it into an easy to use AppImage. 

Using an AppImage is as easy as extracting the zip somewhere and double-clicking it.
For more information on how AppImages work visit https://appimage.org/

# Download
Appimage builds are available on the [Releases](https://github.com/Lethja/blender-appimage/releases) page.
Download and extract the zip then double-click on the extracted AppImage to run.

Releases specify the date the AppImage is built rather than the version of Blender.
If a new version of Blender comes out then a new release will be made with just that version.
If there's a change to the script than there will be a new release with the latest of each LTS version.

# Build yourself
## Dependencies
You will need a Linux x86_64 machine to build an appimage

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
You should see options like this appear:
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
Type the number(s) of the Blender version you wish to make an appimage of and press enter.

The appimage will be created and stored in a zip automatically. 
Storing an appimage in a zip preserved the executable permission 
which will make deployment feel more streamlined to macOS and Windows users 

## Build an unlisted version
Run the mkAppImg script with the URL to the hash checksum and source code. 
Example: 
```shell
./mkAppImg.sh https://download.blender.org/release/Blender2.79/release279.md5 https://download.blender.org/release/Blender2.79/blender-2.79-linux-glibc219-x86_64.tar.bz2
```
