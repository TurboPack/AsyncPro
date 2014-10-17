(***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is TurboPower Async Professional
 *
 * The Initial Developer of the Original Code is
 * TurboPower Software
 *
 * Portions created by the Initial Developer are Copyright (C) 1991-2002
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{*                    ExSlave.PAS                        *}
{*********************************************************}

{**********************Description************************}
{* This example DLL works in conjunction with            *}
{*      ExMaster.exe, using a handle to an already       *}
{*       opened port.                                    *}
{*********************************************************}

library ExSlave;

uses
  Windows,
  SysUtils,
  Classes,
  AwUser,
  AwWin32,
  ooMisc,
  Forms,
  ExSlave0 in 'ExSlave0.pas' {Form1};

var
  MasterComHandle : THandle;

{A custom dispatcher which overrides OpenCom and CloseCom to use an existing handle}
type
  TApdSlaveDispatcher = class(TApdWin32Dispatcher)
    public
      function CloseCom : Integer;                                                override;
      function OpenCom(ComName: PChar; InQueue, OutQueue : Cardinal) : Integer;   override;
  end;

  function TApdSlaveDispatcher.OpenCom(ComName: PChar; InQueue, OutQueue: Cardinal): Integer;
    {-"Open" the comport by returning the global handle and doing some housekeeping}
  begin
    Result := MasterComHandle;
    CidEx := Result;
    {Create port data structure}
    ReadOL.hEvent := CreateEvent(nil, True, False, nil);
    WriteOL.hEvent := CreateEvent(nil, True, False, nil);
    if (ReadOL.hEvent = 0) or (WriteOL.hEvent = 0) then begin
      {Failed to create events, get rid of everything}
      CloseHandle(ReadOL.hEvent);
      CloseHandle(WriteOL.hEvent);
      Result := ecOutOfMemory;
      Exit;
    end;
  end;

  function TApdSlaveDispatcher.CloseCom: Integer;
    {-"Close" the comport and clean up}
  begin
    {Release the events}
    if ReadOL.hEvent <> 0 then
      CloseHandle(ReadOL.hEvent);
    if WriteOL.hEvent <> 0 then
      CloseHandle(WriteOL.hEvent);

    KillThreads := True;

    {Force the comm thread to wake...}
    SetCommMask(CidEx, 0);
    SetEvent(ReadyEvent);
    {... and wait for it to die}
    ResetEvent(GeneralEvent);
    if WaitForSingleObject(GeneralEvent, 200) = WAIT_TIMEOUT then
      ComThread.Terminate;

    Result := 0
  end;

{Function to create our custom dispatcher. Assigned to ApdComport's
 CustomDispatcher property.}

function CreateCustomDispatcher(Owner : TObject) : TApdBaseDispatcher;
begin
  Result := TApdSlaveDispatcher.Create(Owner);
end;

procedure ShowTerminal(PortHandle : THandle);
begin
  with TForm1.Create(Application) do begin
    {Save handle in global variable so the dispatcher can get at it}
    MasterComHandle := PortHandle;
    {Tell the ApdComPort to use our custom dispatcher}
    ApdComPort1.CustomDispatcher := CreateCustomDispatcher;
    {Show terminal window}
    ShowModal;
    Free;
  end;
end;

exports
  ShowTerminal;

begin
end.
