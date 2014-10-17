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
{*                   FAXSRVX1.PAS 4.06                   *}
{*********************************************************}

unit FaxSrvx1;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls;

type
  TfsFaxList = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    flFileName: TEdit;
    Label2: TLabel;
    flCover: TEdit;
    Label3: TLabel;
    flPhoneNumber: TEdit;
    flAction: TButton;
    flCancel: TButton;
    procedure flActionClick(Sender: TObject);
    procedure flCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    function GetFaxName : String;
    procedure SetFaxName(const NewName : String);
    function GetCoverName : String;
    procedure SetCoverName(const NewName : String);
    function GetPhoneNumber : String;
    procedure SetPhoneNumber(const NewNumber : String);

  public
    property FaxName : String
      read GetFaxName write SetFaxName;
    property CoverName : String
      read GetCoverName write SetCoverName;
    property PhoneNumber : String
      read GetPhoneNumber write SetPhoneNumber;

    { Public declarations }
  end;

var
  fsFaxList: TfsFaxList;

implementation

{$R *.DFM}

procedure TfsFaxList.flActionClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TfsFaxList.flCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

function TfsFaxList.GetFaxName : String;
begin
  Result := flFileName.Text;
end;

procedure TfsFaxList.SetFaxName(const NewName : String);
begin
  flFileName.Text := NewName;
end;

function TfsFaxList.GetCoverName : String;
begin
  Result := flCover.Text;
end;

procedure TfsFaxList.SetCoverName(const NewName : String);
begin
  flCover.Text := NewName;
end;

function TfsFaxList.GetPhoneNumber : String;
begin
  Result := flPhoneNumber.Text;
end;

procedure TfsFaxList.SetPhoneNumber(const NewNumber : String);
begin
  flPhoneNumber.Text := NewNumber;
end;

procedure TfsFaxList.FormActivate(Sender: TObject);
begin
  flPhoneNumber.SetFocus;
end;

end.
