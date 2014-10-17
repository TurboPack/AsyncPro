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
{*                   EXFAXL0.PAS 4.06                    *}
{*********************************************************}

{**********************Description************************}
{*Shows how to use the OnFaxNext event to send multiple  *}
{*      faxes.                                           *} 
{*********************************************************}

unit Exfaxl0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, AdFax, AdFStat, AdPort, OoMisc;

type
  TForm1 = class(TForm)
    ApdComPort1: TApdComPort;
    ApdSendFax1: TApdSendFax;
    ApdFaxStatus1: TApdFaxStatus;
    ApdFaxLog1: TApdFaxLog;
    AddFiles: TButton;
    SendFax: TButton;
    procedure AddFilesClick(Sender: TObject);
    procedure ApdSendFax1FaxNext(CP: TObject;
              var APhoneNumber, AFaxFile, ACoverFile: TPassString);
    procedure SendFaxClick(Sender: TObject);
  private
    { Private declarations }
    FaxList  : TStringList;
    FaxIndex : Word;
  public
    { Public declarations }
    constructor Create(AComponent : TComponent); override;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

constructor TForm1.Create(AComponent : TComponent);
begin
  inherited Create(AComponent);
  FaxList := TStringList.Create;
end;

procedure TForm1.AddFilesClick(Sender: TObject);
begin
  FaxList.Add('260-7151^..\APROLOGO.APF');
  FaxList.Add('260-7151^..\APROLOGO.APF');
  FaxIndex := 0;
  ShowMessage('Fax files added!');
end;

procedure TForm1.ApdSendFax1FaxNext(CP: TObject;
          var APhoneNumber, AFaxFile, ACoverFile: TPassString);
var
  S : String;
  CaretPos : Byte;
begin
  try
    S := FaxList[FaxIndex];
    CaretPos := Pos('^', S);
    APhoneNumber := Copy(S, 1, CaretPos-1);
    AFaxFile := Copy(S, CaretPos+1, 255);
    ACoverFile := '';
    Inc(FaxIndex);
  except
    APhoneNumber := '';
    AFaxFile := '';
    ACoverFile := '';
  end;
end;

procedure TForm1.SendFaxClick(Sender: TObject);
begin
  ApdSendFax1.StartTransmit;
end;

end.
