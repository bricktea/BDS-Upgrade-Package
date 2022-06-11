# Upgrade Packs for BDS
The BDS upgrade package is provided here, but Mojang does not currently provide it.

## Download
![GitHub Releases](https://shields.io/github/downloads/Redbeanw44602/BDS-Upgrade-Package/total?style=for-the-badge)<br>
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

## Histroy Versions

### 1.18
 - 1.18.0.02
 - 1.18.1.02
 - 1.18.2.03
 - 1.18.11.01
 - 1.18.12.01
 - 1.18.30.04
 - 1.18.31.04
 - 1.18.32.02
 - 1.18.33.02


### 1.17
 - 1.17.0.03
 - 1.17.1.01
 - 1.17.2.01
 - 1.17.10.04
 - 1.17.11.01
 - 1.17.30.04
 - 1.17.31.01
 - 1.17.32.02
 - 1.17.33.01
 - 1.17.34.02
 - 1.17.40.06
 - 1.17.41.01

### 1.16
 - 1.16.0.2
 - 1.16.1.02
 - 1.16.10.01
 - 1.16.20.01
 - 1.16.20.03
 - 1.16.40.02
 - 1.16.100.04
 - 1.16.101.01
 - 1.16.200.02
 - 1.16.201.02
 - 1.16.201.03
 - 1.16.210.05
 - 1.16.210.06

### 1.14
 - 1.14.0.9
 - 1.14.1.4
 - 1.14.20.1
 - 1.14.21.0
 - 1.14.30.2
 - 1.14.32.1
 - 1.14.60.5

### 1.13
 - 1.13.0.34
 - 1.13.1.5
 - 1.13.2.0
 - 1.13.3.0

### 1.12
 - 1.12.0.28
 - 1.12.1.1

### 1.11
 - 1.11.0.23
 - 1.11.1.2
 - 1.11.2.1
 - 1.11.4.2

### 1.10
 - 1.10.0.7

### 1.9
 - 1.9.0.15

### 1.8
 - 1.8.0.24
 - 1.8.1.2

### 1.7
 - 1.7.0.13

### 1.6
 - 1.6.0.15
 - 1.6.1.0
