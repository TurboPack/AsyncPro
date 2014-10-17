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

{******************************************************************}
{*                        AXDIRDG.PAS 1.13                        *}
{******************************************************************}
{* AxDirDg.PAS - Directory selection dialog                       *}
{******************************************************************}

{$I AXDEFINE.INC}

unit AxDirDg;

interface

uses
  Windows, ShellApi, ShlObj, Messages, ActiveX, ComObj, Forms,
  Graphics, SysUtils, Classes, Controls, StdCtrls;


type
  TAxDirectoryDlg = class(TComponent)
  protected {private}
    FAdditionalText      : string;
    FCaption             : string;
    FHandle              : Integer;
    FIDList              : PItemIDList;
    FSelectedFolder      : string;

    procedure SetSelectedFolder(const Value : string);
    procedure FreeIDList;

  public {properties}
    property AdditionalText : string
      read FAdditionalText
      write FAdditionalText;
    property Caption : string
      read FCaption
      write FCaption;
    property Handle : Integer
      read FHandle;
    property IDList : PItemIDList
      read FIDList;
    property SelectedFolder : string
      read FSelectedFolder
      write SetSelectedFolder;

  public {methods}
    destructor Destroy; override;
    function Execute : Boolean;
  end;


implementation

{== TAxDirectoryDlg ========================================================}
function AxDirDlgCallbackProc(hWnd : HWND; Msg : UINT; lParam : LPARAM;
                              Data : LPARAM): Integer; stdcall;
var
  X, Y : Integer;
  R    : TRect;
  Buf    : array[0..MAX_PATH-1] of Char;
begin
  Result := 0;
  with TAxDirectoryDlg(Data) do begin
    case Msg of
      BFFM_INITIALIZED :
        begin
          FHandle := hWnd;
          if (FCaption <> '') then
            SendMessage(hWnd, WM_SETTEXT, 0, Integer(PChar(FCaption)));
          SendMessage(hWnd, BFFM_SETSELECTION, 1, Integer(PChar(SelectedFolder)));
          GetWindowRect(hWnd, R);
          X := (Screen.Width div 2) - ((R.Right - R.Left) div 2);
          Y := (Screen.Height div 2) - ((R.Bottom - R.Top) div 2);
          SetWindowPos(hWnd, 0, X, Y, 0, 0, SWP_NOSIZE or SWP_NOZORDER);
        end;
      BFFM_SELCHANGED :
        if (FHandle <> 0) then begin
          FIDList := PItemIDList(lParam);
          SHGetPathFromIDList(IDList, Buf);
          SelectedFolder := Buf;
        end;
    end;
  end;
end;
{ -------------------------------------------------------------------------- }
destructor TAxDirectoryDlg.Destroy;
begin
  if FIDList <> nil then
    FreeIDList;
  inherited Destroy;
end;
{ -------------------------------------------------------------------------- }
function TAxDirectoryDlg.Execute : Boolean;
var
  Info   : TBrowseInfo;
  Buf    : array[0..MAX_PATH-1] of Char;
begin
  if (FIDList <> nil) then
    FreeIDList;

  if (Owner is TWinControl) then
    Info.hwndOwner := (Owner as TWinControl).Handle
  else if Owner is TApplication then
    Info.hwndOwner := (Owner as TApplication).Handle
  else
    Info.hwndOwner := 0;
  Info.pidlRoot := nil;
  Info.pszDisplayName := Buf;
  Info.lpszTitle := PChar(FAdditionalText);
  Info.ulFlags := BIF_RETURNONLYFSDIRS;
  Info.lpfn := @AxDirDlgCallbackProc;
  Info.lParam := Integer(Self);
  Info.iImage := 0;

  FIDList := SHBrowseForFolder(Info);
  FHandle := 0;
  Result := (FIDList <> nil);
end;
{ -------------------------------------------------------------------------- }
procedure TAxDirectoryDlg.FreeIDList;
var
  Malloc : IMalloc;
begin
  if coGetMalloc(MEMCTX_TASK, Malloc) = NOERROR then begin
    Malloc.Free(FIDList);
    FIDList := nil;
  end;
end;
{ -------------------------------------------------------------------------- }
procedure TAxDirectoryDlg.SetSelectedFolder(const Value : string);
begin
  FSelectedFolder := Value;
  if FSelectedFolder <> '' then
    if FSelectedFolder[Length(FSelectedFolder)] = '\' then
      Delete(FSelectedFolder, Length(FSelectedFolder), 1);
  if (Length(FSelectedFolder) = 2) then
    FSelectedFolder := FSelectedFolder + '\';
end;

end.
