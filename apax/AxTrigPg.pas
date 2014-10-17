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
{*                       AXTRIGPG.PAS 1.13                        *}
{******************************************************************}
{* AxTrigPg.PAS - Data trigger property page editor               *}
{******************************************************************}

{$I AXDEFINE.INC}

unit AxTrigPg;

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls, StdCtrls,
  ExtCtrls, Forms, ComServ, ComObj, StdVcl, AxCtrls, Grids;

type
  TApxTriggerPage = class(TPropertyPage)
    sgTriggers: TStringGrid;
    procedure sgTriggersSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
  public
    { Public declarations }
    procedure UpdatePropertyPage; override;
    procedure UpdateObject; override;
  end;

const
  Class_ApxTriggerPage: TGUID = '{5D6FD082-BFCC-4C67-9B5A-F8D1C38E8CDF}';

implementation

uses
  AxTerm;

{$R *.DFM}


{== TApxPacketPage =======================================================}
procedure TApxTriggerPage.UpdatePropertyPage;
var
  TriggerStrings : TStringList;
  i : Integer;
  S : WideString;
begin
  with sgTriggers do begin
    Cells[1, 0] := 'Trigger String';
    ColWidths[0] := 20;
    ColWidths[1] := 400;
  end;
  S := OleObject.DataTriggerString;
  TriggerStrings := TStringList.Create;
  try
    ParseDataTriggerString(S, TriggerStrings);
    if (TriggerStrings.Count > 0) then
      for i := 0 to Pred(TriggerStrings.Count) do begin
        sgTriggers.Cells[0, i+1] := IntToStr(i);
        sgTriggers.Cells[1, i+1] := TriggerStrings[i];
      end;
  finally
    TriggerStrings.Free;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTriggerPage.UpdateObject;
var
  i : Integer;
  S : WideString;
begin
  S := '';
  for i := 1 to Pred(sgTriggers.RowCount) do
    if (sgTriggers.Cells[1, i] <> '') then begin
      if (S <> '') then
        S := S + '|';
      S := S + sgTriggers.Cells[1, i];
    end;
  OleObject.DataTriggerString := S;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTriggerPage.sgTriggersSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  Modified;
end;
{ ----------------------------------------------------------------------- }

initialization
  TActiveXPropertyPageFactory.Create(
    ComServer,
    TApxTriggerPage,
    Class_ApxTriggerPage);
end.
