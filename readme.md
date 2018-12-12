# TurboPack AsyncPro

Updated for 10.3 Rio / VER330 / PKG 260

You can still access [10.2 Tokyo](https://github.com/TurboPack/AsyncPro/releases/tag/102Tokyo) and [10.1 Berlin](https://github.com/TurboPack/AsyncPro/releases/tag/101Berlin) too.

## Table of contents

1.  Introduction
2.  Package names
3.  Installation

---------

## 1. Introduction

Async Professional is a comprehensive communications toolkit for Embarcadero 
Delphi and C++Builder. It provides direct access to serial ports, TAPI, and the 
Microsoft Speech API. It supports faxing, terminal emulation, VOIP, & more.

This is a source-only release of TurboPack AsyncPro. It includes
designtime and runtime packages for Delphi and C++Builder and supports Win32.
Win64 support is experimental!

---------

## Package names

TurboPack AsyncPro package names have the following form:

Delphi
* AsyncProDR.bpl (Delphi Runtime)
* AsyncProDD.bpl (Delphi Designtime)

C++Builder
* AsyncProCR.bpl (C++Builder Runtime)
* AsyncProCD.bpl (C++Builder Designtime)

---------

## Installation

AsyncPro is available via the [GetIt Package Manager](http://docwiki.embarcadero.com/RADStudio/en/Installing_a_Package_Using_GetIt_Package_Manager) where you can quickly and easily install and uninstall it.

To manually install TurboPack AsyncPro into your IDE, take the following
steps:

1. Unzip the release files into a directory (e.g., d:\AsyncPro).

2. Start RAD Studio.

3. Add the source subdirectory (e.g., d:\AsyncPro\source) to the
     IDE's library path. For CBuilder, add the hpp subdirectory
     (e.g., d:\AsyncPro\source\hpp\Win32\Debug) to the IDE's system include path.

3. Open & compile the runtime package specific to the IDE being
     used.
     
  4. Open & install the designtime package specific to the IDE being
     used. The IDE should notify you the components have been
     installed.
     
