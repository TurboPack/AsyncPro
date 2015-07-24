TurboPack AsyncPro


Table of contents

1.  Introduction
2.  Package names
3.  Installation

==============================================


1. Introduction


Async Professional is a comprehensive communications toolkit for Embarcadero 
Delphi and C++Builder. It provides direct access to serial ports, TAPI, and the 
Microsoft Speech API. It supports faxing, terminal emulation, VOIP, & more.

This is a source-only release of TurboPack AsyncPro. It includes
designtime and runtime packages for Delphi and C++Builder and supports Win32.
Win64 support is experimental!

==============================================

2. Package names


TurboPack AsyncPro package names have the following form:

AsyncProDR.bpl (Delphi Runtime)
AsyncProDD.bpl (Delphi Designtime)

AsyncProCR.bpl (C++Builder Runtime)
AsyncProCD.bpl (C++Builder Designtime)

==============================================

3. Installation


To install TurboPack AsyncPro into your IDE, take the following
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
     
