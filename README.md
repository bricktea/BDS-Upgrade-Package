# BDS-Upgrade-Package
The BDS upgrade package is provided here, but Mojang does not currently provide it.

## Download
This repo will save: the upgrade package of the last version of the previous major version and the minor upgrade pack of the current major version.

## Generator
 - modify generator.lua 3-4line at first, install Lua.
 - put bedrock-server-oldver/bedrock-server-newver(Unzipped) to root.
```
> lua generator.lua
checking path(1.18.1.02) ...
checking path(1.17.41.01) ...
creating file list ...
start to compare 4281 files ...
1.18.1.02 (File) -> 245++, 108--
1.18.1.02 (Cont) -> comparing 4173 files ...
1.18.1.02 (Cont) -> 44 files changed.
All works done.
```
 - Now the content files of the upgrade package have been generated under output\ (including scripts for changing files and deleting old files)

## Versions