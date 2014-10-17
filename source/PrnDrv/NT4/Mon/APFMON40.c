// ***** BEGIN LICENSE BLOCK *****
// * Version: MPL 1.1
// *
// * The contents of this file are subject to the Mozilla Public License Version
// * 1.1 (the "License"); you may not use this file except in compliance with
// * the License. You may obtain a copy of the License at
// * http://www.mozilla.org/MPL/
// *
// * Software distributed under the License is distributed on an "AS IS" basis,
// * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
// * for the specific language governing rights and limitations under the
// * License.
// *
// * The Original Code is TurboPower Async Professional
// *
// * The Initial Developer of the Original Code is
// * TurboPower Software
// *
// * Portions created by the Initial Developer are Copyright (C) 1991-2002
// * the Initial Developer. All Rights Reserved.
// *
// * Contributor(s):
// *
// * ***** END LICENSE BLOCK *****
/*++
Module Name:

    apfmon40.c

Abstract:


Environment:

    User Mode -Win32

Revision History:

--*/

#include <windows.h>
#include <winspool.h>
#include <winsplp.h>
#include <wchar.h>
#include <stddef.h>
#include "spltypes.h"
#include "apfmon40.h"
#include "local.h"

void (_cdecl *FaxConvInit)(void) = NULL;
HANDLE (_cdecl *FaxConvStartDoc)(LPWSTR DocName) = NULL;
void (_cdecl *FaxConvEndDoc)(HANDLE File) = NULL;
void (_cdecl *FaxConvConvert)(
  HANDLE File,
  LPBYTE  pInBuffer,
  DWORD   cbInBufSize) = NULL;

//
// Common string definitions
//

#ifdef INTERNAL
MODULE_DEBUG_INIT(DBG_ERROR | DBG_WARN, DBG_ERROR);
#endif

HANDLE hInst;
PINIPORT pIniFirstPort;
CRITICAL_SECTION SpoolerSection;
DWORD LocalMonDebug;

DWORD PortInfo1Strings[]={offsetof(PORT_INFO_1, pName),
                          (DWORD)-1};

DWORD PortInfo2Strings[]={offsetof(PORT_INFO_2, pPortName),
                          offsetof(PORT_INFO_2, pMonitorName),
                          offsetof(PORT_INFO_2, pDescription),
                          (DWORD)-1};

HINSTANCE hFaxConv = 0;

extern WCHAR szWindows[];
extern WCHAR szINIKey_TransmissionRetryTimeout[];

VOID UnloadFaxConv(VOID)
{
  if (hFaxConv) {
    FreeLibrary(hFaxConv);
    hFaxConv = 0;
  }
}

VOID LoadFaxConv(VOID)
{
  DWORD E;
  if (!hFaxConv) {
    hFaxConv = LoadLibraryW(ApwDLLName);
    if (hFaxConv)
      {
        FaxConvInit = (void(_cdecl *)(void))GetProcAddress(hFaxConv, "FaxConvInit");
        FaxConvStartDoc = (HANDLE(_cdecl *)(LPWSTR DocName))GetProcAddress(hFaxConv, "FaxConvStartDoc");
        FaxConvEndDoc = (void(_cdecl *)(HANDLE File))GetProcAddress(hFaxConv, "FaxConvEndDoc");
        FaxConvConvert = (void(_cdecl *)(HANDLE File,
                                            LPBYTE  pInBuffer,
                                            DWORD   cbInBufSize))
                                            GetProcAddress(hFaxConv, "FaxConvConvert");
        }
    else
      E = GetLastError();
  }
}

BOOL
DllEntryPoint(
    HANDLE hModule,
    DWORD dwReason,
    LPVOID lpRes)
{
    switch (dwReason) {

    case DLL_PROCESS_ATTACH:
        hInst = hModule;

        InitializeCriticalSection(&SpoolerSection);
        DisableThreadLibraryCalls(hModule);

        return TRUE;

    case DLL_PROCESS_DETACH:
        return TRUE;
    }

    UNREFERENCED_PARAMETER( lpRes );
}
