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
{*                    ADXUP.PAS 4.06                     *}
{*********************************************************}
{* Generic protocol upload dialog                        *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F+}

unit AdXUp;

interface

uses
  SysUtils,
  Windows,
  Messages,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  AdProtcl;

type
  TUploadDialog = class(TForm)
    Protocols: TRadioGroup;
    Panel1: TPanel;
    Label1: TLabel;
    FileMask: TEdit;
    OK: TButton;
    Cancel: TButton;
    procedure OKClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
  public
    function GetProtocol : TProtocolType;
    procedure SetProtocol(NewProt : TProtocolType);
    function GetMask : String;
    procedure SetMask(NewMask : String);

    property Protocol : TProtocolType
      read GetProtocol write SetProtocol;
    property Mask : String
      read GetMask write SetMask;

    { Public declarations }
  end;

var
  UploadDialog: TUploadDialog;

implementation

{$R *.DFM}

function TUploadDialog.GetProtocol : TProtocolType;
begin
  Result := TProtocolType(Protocols.ItemIndex+1);
end;

procedure TUploadDialog.SetProtocol(NewProt : TProtocolType);
begin
  Protocols.ItemIndex := Ord(NewProt)-1;
end;

function TUploadDialog.GetMask : String;
begin
  Result := FileMask.Text;
end;

procedure TUploadDialog.SetMask(NewMask : String);
begin
  FileMask.Text := NewMask;
end;

procedure TUploadDialog.OKClick(Sender: TObject);
begin
  ModalResult := idOK;
end;

procedure TUploadDialog.CancelClick(Sender: TObject);
begin
  ModalResult := idCancel;
end;

end.
