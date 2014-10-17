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
{*                   EXSAPIA0.PAS 4.06                   *}
{*********************************************************}

{**********************Description************************}
{* Demonstrates how to use the AskFor methods in the     *}
{* TApdSapiPhone component.                              *}
{*********************************************************}
unit ExSapiA0;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, AdTapi, AdSapiPh, OoMisc, AdSapiEn, ExtCtrls;

type
  TListRequest = (lrPlanet, lrColor);
  
  TForm1 = class(TForm)
    ApdSapiEngine1: TApdSapiEngine;
    ApdSapiPhone1: TApdSapiPhone;
    Label1: TLabel;
    lblDate: TLabel;
    lblExtension: TLabel;
    btnDate: TButton;
    btnExtension: TButton;
    btnPlanet: TButton;
    btnColor: TButton;
    btnPhoneNumber: TButton;
    btnSpelling: TButton;
    btnTime: TButton;
    btnYesNo: TButton;
    lblPlanet: TLabel;
    lblColor: TLabel;
    lblPhoneNumber: TLabel;
    lblSpelling: TLabel;
    lblTime: TLabel;
    lblYesNo: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Memo1: TMemo;
    Label10: TLabel;
    Shape1: TShape;
    procedure btnDateClick(Sender: TObject);
    procedure btnExtensionClick(Sender: TObject);
    procedure btnPlanetClick(Sender: TObject);
    procedure btnColorClick(Sender: TObject);
    procedure btnPhoneNumberClick(Sender: TObject);
    procedure btnSpellingClick(Sender: TObject);
    procedure btnTimeClick(Sender: TObject);
    procedure btnYesNoClick(Sender: TObject);
    procedure ApdSapiPhone1AskForDateFinish(Sender: TObject;
      Reply: TApdSapiPhoneReply; Data: TDateTime; SpokenData: String);
    procedure ApdSapiPhone1AskForExtensionFinish(Sender: TObject;
      Reply: TApdSapiPhoneReply; Data, SpokenData: String);
    procedure ApdSapiPhone1AskForListFinish(Sender: TObject;
      Reply: TApdSapiPhoneReply; Data: Integer; SpokenData: String);
    procedure ApdSapiPhone1AskForPhoneNumberFinish(Sender: TObject;
      Reply: TApdSapiPhoneReply; Data, SpokenData: String);
    procedure ApdSapiPhone1AskForSpellingFinish(Sender: TObject;
      Reply: TApdSapiPhoneReply; Data, SpokenData: String);
    procedure ApdSapiPhone1AskForTimeFinish(Sender: TObject;
      Reply: TApdSapiPhoneReply; Data: TDateTime; SpokenData: String);
    procedure ApdSapiPhone1AskForYesNoFinish(Sender: TObject;
      Reply: TApdSapiPhoneReply; Data: Boolean; SpokenData: String);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ApdSapiEngine1SRError(Sender: TObject; Error: Integer;
      const Details, Message: String);
    procedure ApdSapiEngine1SRWarning(Sender: TObject; Error: Integer;
      const Details, Message: String);
    procedure ApdSapiEngine1SSError(Sender: TObject; Error: Integer;
      const Details, Message: String);
    procedure ApdSapiEngine1SSWarning(Sender: TObject; Error: Integer;
      const Details, Message: String);
    procedure ApdSapiEngine1Interference(Sender: TObject;
      InterferenceType: TApdSRInterferenceType);
    procedure ApdSapiEngine1PhraseFinish(Sender: TObject;
      const Phrase: String);
  private
    ListRequest : TListRequest;
    ColorList : TStringList;
    PlanetList : TStringList;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnDateClick(Sender: TObject);
begin
  ApdSapiPhone1.AskForDate ('Say a date');
end;

procedure TForm1.btnExtensionClick(Sender: TObject);
begin
  ApdSapiPhone1.NumDigits := 3;
  ApdSapiPhone1.AskForExtension ('Say an extension');
end;

procedure TForm1.btnPlanetClick(Sender: TObject);
begin
  ListRequest := lrPlanet;
  ApdSapiPhone1.AskForList (PlanetList, 'Say a planet');
end;

procedure TForm1.btnColorClick(Sender: TObject);
begin
  ListRequest := lrColor;
  ApdSapiPhone1.AskForList (ColorList, 'Say a color');
end;

procedure TForm1.btnPhoneNumberClick(Sender: TObject);
begin
  ApdSapiPhone1.AskForPhoneNumber ('Say a phone number');
end;

procedure TForm1.btnSpellingClick(Sender: TObject);
begin
  ApdSapiPhone1.AskForSpelling ('Spell something.  Say done when you are finished');
end;

procedure TForm1.btnTimeClick(Sender: TObject);
begin
  ApdSapiPhone1.AskForTime ('Say a time');
end;

procedure TForm1.btnYesNoClick(Sender: TObject);
begin
  ApdSapiPhone1.AskForYesNo ('Say yes or no');
end;

procedure TForm1.ApdSapiPhone1AskForDateFinish(Sender: TObject;
  Reply: TApdSapiPhoneReply; Data: TDateTime; SpokenData: String);
begin
  case Reply of
    prOk :
      begin
        Memo1.Lines.Add ('DATE --> ' + FormatDateTime ('dddddd', Data) +
                         ' (' + SpokenData + ')');
        lblDate.Caption := FormatDateTime ('dddddd', Data);
      end;
    prCheck :
      begin
        Memo1.Lines.Add ('DATE --> ' + FormatDateTime ('dddddd', Data) +
                         '? (' + SpokenData + ')');
        lblDate.Caption := FormatDateTime ('dddddd', Data);
      end;
    prOperator : Memo1.Lines.Add ('DATE --> [operator]');
    prHangup : Memo1.Lines.Add ('DATE --> [hangup]');
    prBack : Memo1.Lines.Add ('DATE --> [back]');
  end;
end;

procedure TForm1.ApdSapiPhone1AskForExtensionFinish(Sender: TObject;
  Reply: TApdSapiPhoneReply; Data, SpokenData: String);
begin
  case Reply of
    prOk :
      begin
        Memo1.Lines.Add ('EXT --> ' + Data);
        lblExtension.Caption := Data;
      end;
    prOperator : Memo1.Lines.Add ('EXT --> [operator]');
    prHangup : Memo1.Lines.Add ('EXT --> [hangup]');
    prBack : Memo1.Lines.Add ('EXT --> [back]');
  end;
end;

procedure TForm1.ApdSapiPhone1AskForListFinish(Sender: TObject;
  Reply: TApdSapiPhoneReply; Data: Integer; SpokenData: String);
begin
  case Reply of
    prOk :
      begin
        if Data >= 0 then
          case ListRequest of
            lrPlanet :
              if (Data <= 1) then
                lblPlanet.Caption := PlanetList[Data] +
                                     ' (not really a planet'
              else
                lblPlanet.Caption := PlanetList[Data];

            lrColor :
              begin
                lblColor.Caption := ColorList[Data];
                case Data of
                  0  : Shape1.Brush.Color := clRed;
                  1  : Shape1.Brush.Color := clBlue;
                  2  : Shape1.Brush.Color := clYellow;
                  3  : Shape1.Brush.Color := clGreen;
                  4  : Shape1.Brush.Color := $007FFF;
                  5  : Shape1.Brush.Color := clPurple;
                  6  : Shape1.Brush.Color := clPurple;
                  7  : Shape1.Brush.Color := $00003399;
                  8  : Shape1.Brush.Color := clBlack;
                  9  : Shape1.Brush.Color := $00FFFFFF;
                  10 : Shape1.Brush.Color := clGray;
                  11 : Shape1.Brush.Color := clMaroon;
                  12 : Shape1.Brush.Color := clOlive;
                  13 : Shape1.Brush.Color := clNavy;
                  14 : Shape1.Brush.Color := clTeal;
                  15 : Shape1.Brush.Color := clSilver;
                  16 : Shape1.Brush.Color := clLime;
                  17 : Shape1.Brush.Color := clFuchsia;
                  18 : Shape1.Brush.Color := clAqua;
                end;
              end;
          end;
        Memo1.Lines.Add ('LIST --> ' + IntToStr (Data) + ' (' +
                         SpokenData + ')');
      end;
    prOperator : Memo1.Lines.Add ('LIST --> [operator]');
    prHangup : Memo1.Lines.Add ('LIST --> [hangup]');
    prBack : Memo1.Lines.Add ('LIST --> [back]');
  end;
end;

procedure TForm1.ApdSapiPhone1AskForPhoneNumberFinish(Sender: TObject;
  Reply: TApdSapiPhoneReply; Data, SpokenData: String);
begin
  case Reply of
    prOk :
      begin
        Memo1.Lines.Add ('PHONE --> ' + Data + ' (' + SpokenData + ')');
        lblPhoneNumber.Caption := Data;
      end;
    prOperator : Memo1.Lines.Add ('PHONE --> [operator]');
    prHangup : Memo1.Lines.Add ('PHONE --> [hangup]');
    prBack : Memo1.Lines.Add ('PHONE --> [back]');
  end;
end;

procedure TForm1.ApdSapiPhone1AskForSpellingFinish(Sender: TObject;
  Reply: TApdSapiPhoneReply; Data, SpokenData: String);
begin
  case Reply of
    prOk :
      begin
        Memo1.Lines.Add ('SPELL --> ' + Data);
        lblSpelling.Caption := Data;
      end;
    prOperator : Memo1.Lines.Add ('SPELL --> [operator]');
    prHangup : Memo1.Lines.Add ('SPELL --> [hangup]');
    prBack : Memo1.Lines.Add ('SPELL --> [back]');
  end;
end;

procedure TForm1.ApdSapiPhone1AskForTimeFinish(Sender: TObject;
  Reply: TApdSapiPhoneReply; Data: TDateTime; SpokenData: String);
begin
  case Reply of
    prOk :
      begin
        Memo1.Lines.Add ('TIME --> ' + FormatDateTime ('tt', Data) +
                         '(' + SpokenData + ')');
        lblTime.Caption := FormatDateTime ('tt', Data);
      end;
    prOperator : Memo1.Lines.Add ('TIME -> [operator]');
    prHangup : Memo1.Lines.Add ('TIME --> [hangup]');
    prBack : Memo1.Lines.Add ('TIME --> [back]');
  end;
end;

procedure TForm1.ApdSapiPhone1AskForYesNoFinish(Sender: TObject;
  Reply: TApdSapiPhoneReply; Data: Boolean; SpokenData: String);
begin
  case Reply of
    prOk :
      if Data then begin
        Memo1.Lines.Add ('YES/NO ---> Yes');
        lblYesNo.Caption := 'Yes'
      end else begin
        Memo1.Lines.Add ('YES/NO ---> No');
        lblYesNo.Caption := 'No';
      end;
    prOperator : Memo1.Lines.Add ('YES/NO --> [operator]');
    prHangup : Memo1.Lines.Add ('YES/NO --> [hangup]');
    prBack : Memo1.Lines.Add ('YES/NO --> [back]');
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  if (not ApdSapiEngine1.IsSapi4Installed) then begin
    ShowMessage ('SAPI 4 is not installed.');
  end;
  ColorList := TStringList.Create;
  ColorList.Add ('red');
  ColorList.Add ('blue');
  ColorList.Add ('yellow');
  ColorList.Add ('green');
  ColorList.Add ('orange');
  ColorList.Add ('purple');
  ColorList.Add ('violet');
  ColorList.Add ('brown');
  ColorList.Add ('black');
  ColorList.Add ('white');
  ColorList.Add ('gray');
  ColorList.Add ('maroon');
  ColorList.Add ('olive');
  ColorList.Add ('navy');
  ColorList.Add ('teal');
  ColorList.Add ('silver');
  ColorList.Add ('lime');
  ColorList.Add ('fuchsia');
  ColorList.Add ('aqua');

  PlanetList := TStringList.Create;
  PlanetList.Add ('[opt] the sun');
  PlanetList.Add ('[opt] the moon');
  PlanetList.Add ('mercury');
  PlanetList.Add ('venus');
  PlanetList.Add ('[opt] the earth');
  PlanetList.Add ('mars');
  PlanetList.Add ('jupiter');
  PlanetList.Add ('saturn');
  PlanetList.Add ('neptune');
  PlanetList.Add ('uranus');
  PlanetList.Add ('pluto');
  PlanetList.Add ('rupert');
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  ColorList.Free;
  PlanetList.Free;
end;

procedure TForm1.ApdSapiEngine1SRError(Sender: TObject; Error: Integer;
  const Details, Message: String);
begin
  Memo1.Lines.Add ('SR Error: ' + Message);
end;

procedure TForm1.ApdSapiEngine1SRWarning(Sender: TObject; Error: Integer;
  const Details, Message: String);
begin
  Memo1.Lines.Add ('SR Warning: ' + Message);
end;

procedure TForm1.ApdSapiEngine1SSError(Sender: TObject; Error: Integer;
  const Details, Message: String);
begin
  Memo1.Lines.Add ('SS Error: ' + Message);
end;

procedure TForm1.ApdSapiEngine1SSWarning(Sender: TObject; Error: Integer;
  const Details, Message: String);
begin
  Memo1.Lines.Add ('SS Warning: ' + Message);
end;

procedure TForm1.ApdSapiEngine1Interference(Sender: TObject;
  InterferenceType: TApdSRInterferenceType);
begin
  case InterferenceType of
    itAudioStarted :
      Memo1.Lines.Add('*** Interference - Audio Started ***');
    itAudioStopped :
      Memo1.Lines.Add('*** Interference - Audio Stopped ***');
    itDeviceOpened :
      Memo1.Lines.Add('*** Interference - Device Opened ***');
    itDeviceClosed :
      Memo1.Lines.Add('*** Interference - Device Closed ***');
    itNoise :
      Memo1.Lines.Add('*** Interference - Noise ***');
    itTooLoud :
      Memo1.Lines.Add('*** Interference - Too Loud ***');
    itTooQuiet :
      Memo1.Lines.Add('*** Interference - Too Quiet ***');
    itUnknown :
      Memo1.Lines.Add('*** Interference - Unknown ***');
  end;
end;

procedure TForm1.ApdSapiEngine1PhraseFinish(Sender: TObject;
  const Phrase: String);
begin
  Memo1.Lines.Add ('REPLY --> ' + Phrase);
end;

end.
