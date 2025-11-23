[![Blender LTS AppImage Builds](https://github.com/Lethja/blender-appimage/actions/workflows/manifest.yml/badge.svg)](https://github.com/Lethja/blender-appimage/actions/workflows/manifest.yml)

# Summary

If you need to run a version of Blender on Linux
that isn't in your Linux distribution repository,
it can be cumbersome to set up and run,
especially for rolling distributions
where the system version of Python can change.
While Blender's website offers downloads for portable versions of
Blender for Linux in a tarball,
extracting these tarballs somewhere and maintaining a path hierarchy
is also cumbersome and suboptimal.
This repository contains two small bash scripts that download these same
portable tarball releases of Blender LTS for Linux
and convert them into an AppImage.

Using these AppImages is as easy as extracting the zip somewhere
and double-clicking it.
There is no need to add a custom repository
or run a shell script with root privileges.
You can even download and run two different AppImage versions of Blender
at the same time.

For more information on how AppImages work, visit https://appimage.org/

# Download

## Latest LTS

The latest AppImage builds are available on the
[Releases](https://github.com/Lethja/blender-appimage/releases) page.
Download and extract the zip,
then double-click on the extracted AppImage to run.

Releases specify the date the AppImage is built
rather than the version of Blender.
If a new version of Blender comes out,
then a new release will be made with just that version.
If there's a change to the script,
then there will be a new release with the latest of each LTS version.
This means you may need to look through older releases
to find older versions of Blender
if `mkAppImg.sh` hasn't been updated in a while.

## End of Life LTS
These versions of Blender are no longer supported by the Blender Foundation.
They still work but are unlikely to get any further official updates
from the Blender Foundation.

| Download                                                                                                                           | SHA256                                                             |
|------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------|
| [Blender LTS 3.6.23](https://github.com/Lethja/blender-appimage/releases/download/2025-08-08/blender-3.6.23-x86_64.AppImage.zip)   | `d6af2f8cd01ac71684f50332bf31e2485141bbd65c03524a47145865591b8cdf` |
| [Blender LTS 3.3.21](https://github.com/Lethja/blender-appimage/releases/download/2025-08-08/blender-3.3.21-x86_64.AppImage.zip)   | `43d39c9fdbd965b2d3e83a889b0a2a0fbacdbefcda1be77be3257e669273d8d1` |
| [Blender LTS 2.93.18](https://github.com/Lethja/blender-appimage/releases/download/2025-08-08/blender-2.93.18-x86_64.AppImage.zip) | `c0219c0c6fda994a447b4a6259e799719c1d14829447e322f34342a996da78ed` |
| [Blender LTS 2.83.20](https://github.com/Lethja/blender-appimage/releases/download/2025-08-08/blender-2.83.20-x86_64.AppImage.zip) | `100be04e06447f61493b59d91e413d4333ec5264ce6c4cc61e13ded0ad3488be` |
| [Blender 2.79b](https://github.com/Lethja/blender-appimage/releases/download/2025-08-08/blender-2.79b-x86_64.AppImage.zip)         | `66d5daa899dcda892cdf3228257b1d57b9ff5ff3e85aa1a9e31201c9cd6dbe41` |
| [Blender 2.79b (i686)](https://github.com/Lethja/blender-appimage/releases/download/2025-08-08/blender-2.79b-i686.AppImage.zip)    | `ef947b25f307d61c64b8f77a7bbe06927edf983ebb4ad7fb32fec23dd9b177ca` |


## Troubleshooting
### Fuse
If you can't open the AppImage make sure `libfuse.so.2`
is installed in your system.
If you can't or won't install `libfuse.so.2` you can extract the AppImage
with the parameter `--appimage-extract`.
More information at
https://docs.appimage.org/user-guide/troubleshooting/fuse.html.

# Build yourself

## Dependencies

You will need a Linux machine to build an AppImage

On a terminal run the following to make sure scripts dependencies are installed

```shell
which cat echo gpg md5sum mksquashfs sed sha256sum tar wget zip > /dev/null
```

The command will exit without printing anything
if all dependencies are satisfied.
If this is not the case, refer to your distribution documentation
to determine what packages to install.

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

Type the number(s) of the Blender version(s) to make an AppImage of
and press enter.

For example, typing `0 6 5` to the list above will build an AppImage
of `blender-2.79b-linux-glibc219-i686`, `blender-4.2.2-linux-x64` 
and `blender-3.6.16-linux-x64` in that order. 

The AppImage will be created and stored in a zip automatically.
Storing an AppImage in a zip archive
will preserve the files executable permission.
This will make deployment more streamlined
and feel more familiar to macOS and Windows users.

## Build an unlisted version

Due to the sheer number of releases Blender has
`manifest.sh` will only list the latest version in each LTS release
as listing every build ever would be impractical.

To create an AppImage of a Blender version
not listed by `manifest.sh` (such as experimental or archived Blender releases),
provide the URL for the hash checksum and the source tarball
directly to `mkAppImg.sh`.

Example:

```shell
./mkAppImg.sh https://download.blender.org/release/Blender2.79/release279.md5 https://download.blender.org/release/Blender2.79/blender-2.79-linux-glibc219-x86_64.tar.bz2
```

You can also use this method to access an alternative mirror
if the default `download.blender.org` is not accessible or missing a file.

Example:
```shell
./mkAppImg.sh https://download.blender.org/release/Blender4.5/blender-4.5.5.sha256 https://ftp.halifax.rwth-aachen.de/blender/release/Blender4.2/blender-4.5.5-linux-x64.tar.xz
```