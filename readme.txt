TurboPower Async Professional


Table of contents

1.  Introduction
2.  Package names
3.  Installation
4.  Version history
4.1   Release 4.06
4.2   Release 4.07
4.3   Release 4.07 RC3

==============================================


1. Introduction

Async Professional is a comprehensive communications toolkit for
Borland Delphi, C++Builder, & ActiveX environments. It provides direct
access to serial ports, TAPI, and the Microsoft Speech API. It
supports faxing, terminal emulation, VOIP, & more.

This is a source-only release of TurboPower Async Professional (APRO).
It includes designtime and runtime packages for Delphi 3 through 7 and
C++Builder 3 through 6.

For help files and a PDF manual, please see the tpapro_docs package on
SourceForge (http://sourceforge.net/projects/tpapro).

==============================================

2. Package names


TurboPower APRO package names have the following form:

  ANNNMKVV.*
   |  |||
   |  ||+------ VV  VCL version (30=Delphi 3, 40=Delphi 4, 70=Delphi 7)
   |  |+------- K   Kind of package (R=runtime, D=designtime)
   |  +-------- M   Product-specific modifier (typically underscore, V = VCL, C = CLX)
   +----------- NNN Product version number (e.g., 406=version 4.06)


For example, the APRO designtime package files for Delphi 7 have the
filename A406_D70.*.

The runtime package contains the core functionality of the product and
is not installed into the IDE. The designtime package references the
runtime package, registers the components, and contains property
editors used in the IDE.

NOTE:  For the small number of changes made to create version 4.07
       it was too much trouble to make new package files for this 
	   version.  For version 4.07 installations use the 4.06
	   package files.  For example, to compile the 4.07 design time
	   pagkage for Delphi 5 the package file would be A406_D50.dpk.

==============================================

3. Installation


To install TurboPower APRO into your IDE, take the following steps:

  1. Unzip the release files into a directory (e.g., d:\apro).

  2. Start Delphi or C++Builder.

  3. Add the source subdirectory (e.g., d:\apro\source) to the IDE's
     library path.

  4. Open & compile the runtime package specific to the IDE being
     used.

  5. Open & install the designtime package specific to the IDE being
     used. The IDE should notify you the components have been
     installed.

==============================================

4. Version history


4.1 Release 4.06

  Please note that the following issue #s are from Bugzilla. These
  bugs were not exported to SourceForge.


 Enhancements
 ------------

 1880 - Multiple instances
 3580 - Error handling
 3623 - TAPI Hold and transfer capabilities
 3756 - enh: Add ability to force YModem to 128 byte blocks
 3981 - Add OnProcessChar commands for cursor on/off
 4064 - RAS - Add support for programatic phonebook additions
 4065 - RAS - Add support to retrieve connection statistics

 Bugs fixed
 ----------

 1350 - TInAddr conflicts with other components
 3217 - Once connected to an invalid ftp site, can't connect again.
 3373 - YModem locks files
 3515 - Need update the status when setting DTR and RTS.
 3548 - Cannot enter hex values in state conditions
 3646 - When switching modes, exception thrown in AdFax checkport procedure.
 3688 - TAdModem.BPSRate property not updated
 3702 - TApdSendFax, fpPageOK not used for class1
 3861 - Invalid modem attributes in XML files
 3866 - State machine - Mem leak upon deactivating
 3867 - States - StartString and EndString do not escape strings
 3879 - Fax - Class 1.0 implementation omission
 3887 - Data packet - AV on destroy
 3888 - Assign/AssignFile overloads causing problems
 3927 - TAdModem AV when destroyed
 3941 - State machine accesses port after closing
 3980 - OnProcessChar Command ecAnswerBack does not work.
 3982 - Support for Siemens S35i (PDU Mode?)
 4004 - Dialing using tone/pulse with TAdModem.
 4010 - AV even though ftp://ftp.turbopower.com/pub/apro/updates/APROFixes.htm#3887 was applied.
 4016 - FConnectFired may have broken DoDisconnect.
 4050 - Request for read only properties to indicate if scroll bars in use.
 4055 - TAdModem - incorrect exception if modemcap folder not found
 4056 - TApdModemStatusDialog - Cancel button doesn't work
 4057 - TAdModem - AV if port not opened
 4062 - Data packet - AV on destroy revisited
 4066 - Invalid Scroll Regions cause AV
 4067 - Provide manual adjustment of character cell sizes in terminal
 4068 - TAdTerminalEmulator.teProcessCommand can AV with no terminal
 4071 - RAS - Missing some consts
 4082 - AV On destroy when turning off mouseselect
 4096 - TAdModem - incompatible with user's OnTriggerXxx
 4121 - OnTapiFail getting called twice for one failure.
 4132 - Fonts changing works incorrectly with VT100
 4159 - AdModem - SetDevConfig not forcing initialization
 4177 - TApdFaxConverter - idShell conversion may leave reg/ini keys
 4186 - TApdSendFax - Class1 error handling
 4192 - TApdWinsockPort - DeviceName in log incorrect

4.2 Release 4.07

Enhancements
------------

The serial port dispatcher was completely rewritten to make it less
vulnerable to poorly behaved (blocking) event handlers.  The new
dispatcher will continue to buffer serial port input until it runs
out of memory for buffers if any of the user's event handlers block.
The output thread of the dispatcher is now double buffered to allow
output to be written to the serial port while the user's thread
continues to work.  This improves throughput for some file transfer
protocols like zmodem.

If you encounter problems when using the new serial port dispatcher,
define the conditional UseAwWin32 and rebuild your project and / or
packages.  This will disable the new dispatcher and use the 4.06
dispatcher in its place.  If your problem goes away after doing this
then you have probably discovered a bug in the new dispatcher and you
should report it via the support news groups.

A new logging/tracing option (tlAppendAndContinue) was added which
flushes the buffer to disk and retains the current logging option.  Use of 
this new option closes a timing window where logging entries could be 
lost between using the tlAppend option and resetting logging to tlOn.

A new property was added to TApdProtocol called ZmodemEscControl.  Setting
this property to True forces zmodem to escape all control characters.
This allows zmodem to work on less than completely transparent 
connections, like telnet.

A conditional (NoQueryPerformanceCounter) has been added to suppress the
use of the QueryPerformanceCounter function to get the millisecond time.
It has been reported that this function executes extremely slowly on certain
HP and Compaq machines.  Submitted by Mauro Mariuzzo.

A completely functional terminal emulator application is now included as
part of the standard release.  It provides VT100 terminal emulation over
direct serial connections, dialup serial connections and telnet.  It also
provides file transfer over serial connections using X/Y/Z modem, Kermit
and ASCII modes.  It also provides a simple FTP client.

Bugs Fixed
----------

675639  - TApdFaxUnpacker - UnpackXxxToTiff yields 96dpi
675640  - Dispatch log doesn't append properly
675642  - Fax converter - mysterious terminating lines
739306  - Stack Overflow / Access Violation when Initializing Modem
755691  - TAdCustomModem creates malformed initialisation modem string
781241  - exception when file has length 0
956084  - Format %s with integer
1030723 - Waits forever when closing port
1110454 - Stack overflow
1144056 - Stack overflow
1183814 - TApdFaxDriverInterface races during destruction
1481788 - Comport with Terminal stops receiving data
1489199 - DCB.Flag bits not initialized properly
1516681 - release code failed to parse modems' xml files
1578425 - Deadlock when checking modem status on shutdown
1648218 - TApdComPort dropping received characters
1656714 - TADModem: Invalid XML name

4.3 Release 4.07 RC3

Enhancements
------------

The way the terminal emulator's capture file was opened was changed to
allow it to be read by other processes.

Two new functions (WriteCharSource and WriteStringSource) were added
to the terminal component to allow the colour of text written to the
terminal window to be controlled.

Added an optional parameter to TApdTapiDevice.SendTone which allows you
to specify the tone duration in milliseconds.  If not specified the
default tone duration will be used.
	SendTone(Digits: String; Duration: Integer = 0);

Fixed a bug in TApdDataPacket that caused occasional access violations 
on application termination.

Portions of TApdDataPacket have been rewritten to make the actual
behaviour more closely match that described in the documentation.
While these changes have been extensively tested there is always the
possiblity that this change will break existing code that depends on
the old, arguably incorrect, behaviour.  With this in mind a conditional
has been provided to re-enable the old behaviour.  Define the 
conditional UseOldPacket if you want or need to use the old packet
behaviour.

Added {$I AWDEFINE.INC} to 4 source modules that lacked it thus preventing
range check errors in certain situations.  Problem and fix reported
by Dan Phillips.

Changed name of TQueue in OoMisc.pas to TApQueue to avoid naming conflict
with Delphi TQueue component.

Bugs Fixed
----------

675625  - Data packets miss multiple data packets in a single ReadCom
675638  - TApdDataPacket - incorrect end match
675643  - Data packet - - PacketSize = 1 problem
1748318 - ^Z's stripped out of file sends
1748332 - Access Violation in Terminal Emulator When Changing Emulation
1753812 - Access Violation When ApdWinSockPort Used as Standard Serial

4.4 Release 4.07 RC4

Bugs Fixed
----------

Apro was using QueryPerformanceCounter to calculated elapsed times
for timer triggers and the like.  This API call is problematic when
used on certain multi-processor systems and on systems which use
various cooling and power saving modes.  Under value returned by
QueryPerformanceCounter can be wildly inaccurate, causing timers to
fire early or late.  The avoid these problems, QueryPerformanceCounter
has been replaced with timeGetTime.  timeBeginPeriod is called during
initialization to set the minimum update period for timeGetTime to
1 millisecond.  NOTE: This means that Apro no longer has sub-millisecond
accuracy when computing elapsed times but this should be less of a
problem than that caused by QueryPerformanceCounter.

Fixed a memory leak in awuser.pas, caused by status packets being
popped of the queue but not freed.

Fixed end of line corruption in the fax log file.