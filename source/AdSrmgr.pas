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
 *   Sebastian Zierer
 *
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{*                   ADSRMGR.PAS 4.06                    *}
{*********************************************************}
{*  Async Professional string resource runtime manager   *}
{*              adapted from SRMGR.PAS 1.03              *}
{*********************************************************}
{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}


{
  Replaced by ResourceStrings, only used by D3
}

{ --------------------------------------------------------------------
Notes:
  Loads string resources created by SRMC.EXE and BRCC[32]. See the
  comments in SRMC.PAS for additional information.

  Both Create() and ChangeResource take an instance (module) handle
  and a resource name. The resource from the module is then loaded. If
  the resource is not found an ETpsStringResourceError is raised.

  If you wish to alter our products' string resources to translate the
  strings into a different language then you have two choices. In an
  application written in Delphi 1 or Delphi 2 or Delphi 3 without
  packages then you can alter the .TXT files containing the strings,
  recompile them with our 32-bit SRMC utility to create an STR file,
  and then recompile the RC resource files (which 'include' the STR
  file) with Delphi's BRCC[32] program. Relink your application and it
  will then have strings in your language of preference. For an
  application created with Delphi 3 using packages, then the product
  packages cannot be recompiled and hence the string resources in
  those packages cannot be changed. This is where the ChangeResource
  method comes in. Create a whole new resource (it must have a
  different name than the one we use) in the manner described above.
  It will be linked into your application. Now in your application,
  say before the Application.Run call in your project, call
  ChangeResource for the string resource object you want to change and
  pass it the HInstance value of the application and the name of your
  new resource. From now on that string resource object will use your
  string resource instead of the original.

  GetWideChar(), available in 32-bit applications only, returns a
  UNICODE string directly from the resource.

  GetAsciiZ() converts the UNICODE (32-bit) or DBCS (16-bit) string
  from the resource into a DBCS null-terminated string using the
  default code page.

  GetString(), or the default Strings[] array property, also converts
  the string to a DBCS or SBCS string using the default code page.

  When the ReportError property is true, requesting a string whose
  identifier is not found causes an ETpsStringResourceError exception.
  When ReportError is false, no exception is generated but an empty
  string is returned.

  Based on TPSRES.PAS by Lee Inman.
  Written by Kim Kokkonen.
  --------------------------------------------------------------------
}

{$IFDEF Win32}
  {include the resource compiled using BRCC32.EXE and SRMC.EXE}
  {$R ADSRMGR.R32}
{$ELSE}
  {include the resource compiled using BRCC.EXE and SRMC.EXE}
  {$R ADSRMGR.R16}
{$ENDIF}

{$R-,S-,I-}

{$IFDEF Win32}
  {$H+} {Long strings}                                                 
{$ENDIF}

{For BCB 3.0 package support.}
{$IFDEF VER110}
  {$ObjExportAll On}
{$ENDIF}

{$IFNDEF VER80}   {Delphi 1}
 {$IFNDEF VER90}  {Delphi 2}
  {$IFNDEF VER93} {BCB 1}
    {$DEFINE VERSION3} { Delphi 3.0 or BCB 3.0 or higher }
  {$ENDIF}
 {$ENDIF}
{$ENDIF}

unit AdSrMgr;

interface

uses
  Windows, Classes, SysUtils;

const
  DefReportError = False;

  {id at start of binary resource; must match SRMC}
  ResID : array[0..3] of AnsiChar = 'STR0';

type
  ETpsStringResourceError = class(Exception);

{$IFDEF Win32}
  TInt32 = Integer;
{$ELSE}
  TInt32 = LongInt;
{$ENDIF}

  PIndexRec = ^TIndexRec;
  TIndexRec = record
    id : TInt32;
    ofs: TInt32;
    len: TInt32;
  end;
  TIndexArray = array[0..(MaxInt div SizeOf(TIndexRec))-2] of TIndexRec;

  PResourceRec = ^TResourceRec;
  TResourceRec = record
    id : array[0..3] of Ansichar;
    count : LongInt;
    index : TIndexArray;
  end;

  TAdStringResource = class
  private
    {property variables}
    FReportError  : Boolean;             {true to raise exception if string not found}

    {internal variables}
    srHandle      : THandle;             {handle for TPStrings resource}
    srP           : PResourceRec;        {pointer to start of resource}

    {internal methods}
    procedure srCloseResource;
    function srFindIdent(Ident : TInt32) : PIndexRec;
    procedure srLock;
    procedure srLoadResource(Instance : THandle; const ResourceName : string);
    procedure srOpenResource(Instance : THandle; const ResourceName : string);
    procedure srUnLock;

  public
    constructor Create(Instance : THandle; const ResourceName : string); virtual;
    destructor Destroy; override;
    procedure ChangeResource(Instance : THandle; const ResourceName : string);

    function GetAsciiZ(Ident : TInt32; Buffer : PAnsiChar; BufChars : Integer) : PAnsiChar;

    function GetString(Ident : TInt32) : string;
    property Strings[Ident : TInt32] : string
      read GetString; default;
{$IFDEF Win32}
    function GetWideChar(Ident : TInt32; Buffer : PWideChar; BufChars : Integer) : PWideChar;
{$ENDIF}

    property ReportError : Boolean
      read FReportError
      write FReportError;
  end;

var
  TpsResStrings : TAdStringResource; {error strings for this unit}

{====================================================================}

implementation

{*** TAdStringResource ***}

procedure TAdStringResource.ChangeResource(Instance : THandle; const ResourceName : string);
begin
  srCloseResource;
  if ResourceName <> '' then
    srOpenResource(Instance, ResourceName);
end;

constructor TAdStringResource.Create(Instance : THandle; const ResourceName : string);
begin
  inherited Create;
  FReportError := DefReportError;
  ChangeResource(Instance, ResourceName);
end;

destructor TAdStringResource.Destroy;
begin
  srCloseResource;
  inherited Destroy;
end;

{$IFDEF Win32}
procedure WideCopy(Dest, Src : PWideChar; Len : Integer);
begin
  while Len > 0 do begin
    Dest^ := Src^;
    inc(Dest);
    inc(Src);
    dec(Len);
  end;
  Dest^ := #0;
end;

function TAdStringResource.GetWideChar(Ident : TInt32;
  Buffer : PWideChar; BufChars : Integer) : PWideChar;
var
  OLen : Integer;
  P : PIndexRec;
begin
  srLock;
  try
    P := srFindIdent(Ident);
    if P = nil then
      Buffer[0] := #0

    else begin
      OLen := P^.len;
      if OLen >= BufChars then
        OLen := BufChars-1;
      WideCopy(Buffer, PWideChar(PByte(srP)+P^.ofs), OLen);
    end;
  finally
    srUnLock;
  end;

  Result := Buffer;
end;

function TAdStringResource.GetAsciiZ(Ident : TInt32;
  Buffer : PAnsiChar; BufChars : Integer) : PAnsiChar;
var
  P : PIndexRec;
  Src : PWideChar;
  Len, OLen : Integer;
begin
  srLock;
  try
    P := srFindIdent(Ident);
    if P = nil then
      OLen := 0

    else begin
      Src := PWideChar(PByte(srP)+P^.ofs);
      Len := P^.len;

      {see if entire string fits in Buffer}
      OLen :=  WideCharToMultiByte(CP_ACP, 0, Src, Len, nil, 0, nil, nil);

      while OLen >= BufChars do begin
        {reduce length to get what will fit}
        dec(Len);
        OLen :=  WideCharToMultiByte(CP_ACP, 0, Src, Len, nil, 0, nil, nil);
      end;

      {copy to buffer}
      OLen := WideCharToMultiByte(CP_ACP, 0, Src, Len, Buffer, BufChars, nil, nil)
    end;
  finally
    srUnLock;
  end;

  {null terminate the result}
  Buffer[OLen] := #0;
  Result := Buffer;
end;

function TAdStringResource.GetString(Ident : TInt32) : string;
var
  P : PIndexRec;
  Src : PWideChar;
//  Len, OLen : Integer;
begin
  srLock;
  try
    P := srFindIdent(Ident);
    if P = nil then
      Result := ''

    else begin
      Src := PWideChar(PByte(srP)+P^.ofs);
//      Len := P^.len;
      Result := Src;
//      OLen :=  WideCharToMultiByte(CP_ACP, 0, Src, Len, nil, 0, nil, nil);
//      SetLength(Result, OLen);
//      WideCharToMultiByte(CP_ACP, 0, Src, Len, PChar(Result), OLen, nil, nil);
    end;
  finally
    srUnLock;
  end;
end;

{$ELSE}

function TAdStringResource.GetAsciiZ(Ident : TInt32;
  Buffer : PChar; BufChars : Integer) : PChar;
var
  OLen : Integer;
  P : PIndexRec;
begin
  srLock;
  try
    P := srFindIdent(Ident);
    if P = nil then
      Buffer[0] := #0
    else begin
      OLen := P^.len;
      if OLen >= BufChars then
        OLen := BufChars-1;
      StrLCopy(Buffer, PChar(srP)+P^.ofs, OLen);
      Buffer[OLen] := #0;
    end;
  finally
    srUnLock;
  end;

  Result := Buffer;
end;

function TAdStringResource.GetString(Ident : TInt32) : string;
var
  OLen : Integer;
  Src : PChar;
  P : PIndexRec;
begin
  srLock;
  try
    P := srFindIdent(Ident);
    if P = nil then
      Result := ''
    else begin
      OLen := P^.len;
      if OLen > 255 then
        OLen := 255;
      Result[0] := Char(OLen);
      Src := PChar(srP)+P^.ofs;
      move(Src^, Result[1], OLen);
    end;
  finally
    srUnLock;
  end;
end;

{$ENDIF}

procedure TAdStringResource.srCloseResource;
begin
  while Assigned(srP) do
    srUnLock;

  if srHandle <> 0 then begin
    FreeResource(srHandle);
    srHandle := 0;
  end;
end;

function TAdStringResource.srFindIdent(Ident : TInt32) : PIndexRec;
var
  L, R, M : TInt32;
begin
  {binary search to find matching index record}
  L := 0;
  R := srP^.count-1;
  while L <= R do begin
    M := (L+R) shr 1;
    Result := @srP^.index[M];
    if Ident = Result^.id then
      exit;
    if Ident > Result^.id then
      L := M+1
    else
      R := M-1;
  end;

  {not found}
  Result := nil;
  if FReportError then
    raise ETpsStringResourceError.CreateFmt(TpsResStrings[1], [Ident]);
end;

procedure TAdStringResource.srLock;
begin
  srP := LockResource(srHandle);
  if not Assigned(srP) then
    raise ETpsStringResourceError.Create(TpsResStrings[2]);
end;

procedure TAdStringResource.srLoadResource(Instance : THandle; const ResourceName : string);
var
  H : THandle;
  Buf : array[0..255] of Char;
begin
  StrPLCopy(Buf, ResourceName, SizeOf(Buf)-1);
  {$IFDEF VERSION3}  {resource DLL mechanism started in D3}
  Instance := FindResourceHInstance(Instance);  {get loaded Resource DLL if any}
  {$ENDIF}
  H := FindResource(Instance, Buf, RT_RCDATA);  {attempt to load resource}
  if H = 0 then begin  {not found}
    {$IFDEF VERSION3}
    Instance := HInstance;
    H := FindResource(Instance, Buf, RT_RCDATA);{try to find it in the main binary}
    if H = 0 then      {still not found?}
    {$ENDIF}
      raise ETpsStringResourceError.CreateFmt(TpsResStrings[3], [ResourceName]);  {complain}
  end;
  srHandle := LoadResource(Instance, H);
  if srHandle = 0 then
    raise ETpsStringResourceError.CreateFmt(TpsResStrings[4], [ResourceName]);
end;

procedure TAdStringResource.srOpenResource(Instance : THandle; const ResourceName : string);
begin
  {find and load the resource}
  srLoadResource(Instance, ResourceName);

  {confirm it's in the correct format}
  srLock;
  try
    if srP^.id <> ResId then
      raise ETpsStringResourceError.Create(TpsResStrings[5]);
  finally
    srUnLock;
  end;
end;

procedure TAdStringResource.srUnLock;
begin
  if not UnLockResource(srHandle) then
    srP := nil;
end;

procedure FreeTpsResStrings; far;
begin
  TpsResStrings.Free;
end;


initialization
  TpsResStrings := TAdStringResource.Create(HInstance, 'ADSRMGR_STRINGS');

{$IFDEF Win32}
finalization
  FreeTpsResStrings;
{$ELSE}
  AddExitProc(FreeTpsResStrings);
{$ENDIF}

end.
