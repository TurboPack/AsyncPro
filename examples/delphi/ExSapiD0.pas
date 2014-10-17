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
{*                   EXSAPID0.PAS 4.06                   *}
{*********************************************************}

{**********************Description************************}
{* Demonstrates how to access all the built in           *}
{* configuration dialogs in SAPI                         *}
{*********************************************************}

unit ExSapiD0;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OoMisc, AdSapiEn, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btnSSAbout: TButton;
    btnSSGeneral: TButton;
    btnSSLexicon: TButton;
    btnSSTranslate: TButton;
    btnSRAbout: TButton;
    btnSRGeneral: TButton;
    btnSRLexicon: TButton;
    btnSRTrainGeneral: TButton;
    btnSRTrainMic: TButton;
    ApdSapiEngine1: TApdSapiEngine;
    procedure btnSSAboutClick(Sender: TObject);
    procedure btnSSGeneralClick(Sender: TObject);
    procedure btnSSLexiconClick(Sender: TObject);
    procedure btnSSTranslateClick(Sender: TObject);
    procedure btnSRAboutClick(Sender: TObject);
    procedure btnSRGeneralClick(Sender: TObject);
    procedure btnSRTrainGeneralClick(Sender: TObject);
    procedure btnSRLexiconClick(Sender: TObject);
    procedure btnSRTrainMicClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnSSAboutClick(Sender: TObject);
begin
  ApdSapiEngine1.ShowSSAboutDlg ('SS About');
end;

procedure TForm1.btnSSGeneralClick(Sender: TObject);
begin
  ApdSapiEngine1.ShowSSGeneralDlg ('SS General');
end;

procedure TForm1.btnSSLexiconClick(Sender: TObject);
begin
  ApdSapiEngine1.ShowSSLexiconDlg ('SS Lexicon');
end;

procedure TForm1.btnSSTranslateClick(Sender: TObject);
begin
  ApdSapiEngine1.ShowTranslateDlg ('SS Translate');
end;

procedure TForm1.btnSRAboutClick(Sender: TObject);
begin
  ApdSapiEngine1.ShowSRAboutDlg ('SR About');
end;

procedure TForm1.btnSRGeneralClick(Sender: TObject);
begin
  ApdSapiEngine1.ShowSRGeneralDlg ('SR General');
end;

procedure TForm1.btnSRTrainGeneralClick(Sender: TObject);
begin
  ApdSapiEngine1.ShowTrainGeneralDlg ('SR General Training');
end;

procedure TForm1.btnSRLexiconClick(Sender: TObject);
begin
  ApdSapiEngine1.ShowSRLexiconDlg ('SR Lexicon');
end;

procedure TForm1.btnSRTrainMicClick(Sender: TObject);
begin
  ApdSapiEngine1.ShowTrainMicDlg ('SR Microphone Training');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  if (not ApdSapiEngine1.IsSapi4Installed) then begin
    ShowMessage ('SAPI 4 is not installed. AV will occur.');
  end;
end;

end.
