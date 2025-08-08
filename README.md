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
These versions of Blender are no longer supported.
They still work but will not get any further official updates.

| Download                                                                                                                         | MD5                                | SHA256                                                             |
|----------------------------------------------------------------------------------------------------------------------------------|------------------------------------|--------------------------------------------------------------------|
| [Blender LTS 3.6.23](https://github.com/Lethja/blender-appimage/releases/download/2025-06-19/blender-3.6.23-x86_64.AppImage.zip) | `9f6f389170820f31160a7d8afc3965c8` | `2080ec100f971f2effd6759d7210b0a8c5ab0a47f70dc95d96c264f5eca39749` |
| [Blender LTS 3.3.21](https://github.com/Lethja/blender-appimage/releases/download/2024-09-22/blender-3.3.21-x86_64.AppImage.zip) | `e81a7ef601cbfb43713ed703a4f392e9` | `72426847aaeeaaf541be838ae32e0031ef4c6ff76650ee99abf2231c6eaacbae` |
| [Blender 2.93.18](https://github.com/Lethja/blender-appimage/releases/download/2024-09-22/blender-2.93.18-x86_64.AppImage.zip)   | `3baece4e3180bf16523e79d335fa3ec7` | `9a1829d9e44575ead149cdeeea77c209a02deabafd97639c5fbef329cb587d55` |
| [Blender 2.83.20](https://github.com/Lethja/blender-appimage/releases/download/2024-09-22/blender-2.83.20-x86_64.AppImage.zip)   | `36efde5884f424dc25f098dc78aa43ed` | `3ebb49d63d5237bbbb4f7ad5da99fba70451c38deb44a137006f1a998c4e9520` |
| [Blender 2.79b](https://github.com/Lethja/blender-appimage/releases/download/2024-09-22/blender-2.79b-x86_64.AppImage.zip)       | `bac263c0731d0501fa85cb03e676ffc2` | `f7a0f978e688eeb7c9e9cc2057db3f2a841eb52780f8b350998863dc7a2bb100` |
| [Blender 2.79b (i686)](https://github.com/Lethja/blender-appimage/releases/download/2024-09-22/blender-2.79b-i686.AppImage.zip)  | `dd1a207ecd3bf15f38276cf78bb01267` | `49779cc2a12abdd1669a44340a8fd248e6341acbb9b250203efd260b87e230ae` |


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

The AppImage will be created and stored in a zip automatically.
Storing an AppImage in a zip archive
will preserve the files executable permission.
This will make deployment more streamlined
and feel more familiar to macOS and Windows users.

## Build an unlisted version

To create an AppImage of a Blender version
not included in the manifest script's predefined list
(such as experimental or archived Blender releases),
provide the URL for the hash checksum and the source tarball
directly to `mkAppImg.sh`.

Example:

```shell
./mkAppImg.sh https://download.blender.org/release/Blender2.79/release279.md5 https://download.blender.org/release/Blender2.79/blender-2.79-linux-glibc219-x86_64.tar.bz2
```
