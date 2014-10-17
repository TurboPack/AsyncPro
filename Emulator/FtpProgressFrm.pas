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
 * The Original Code is LNS Software Systems
 *
 * The Initial Developer of the Original Code is LNS Software Systems
 *
 * Portions created by the Initial Developer are Copyright (C) 1998-2007
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK ***** *)
unit FtpProgressFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TFtpProgressForm = class(TForm)
    ProgressBar: TProgressBar;
    CancelBtn: TButton;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FCancelled   : Boolean;
    function  GetBarPosition : Integer;
    procedure SetBarPosition(pos : Integer);
  public
    procedure SetParams(title : String; min, max : Integer);
    property Cancelled : Boolean read FCancelled;
    property BarPosition : Integer read GetBarPosition
                                   write SetBarPosition;
  end;

var
  FtpProgressForm: TFtpProgressForm;

implementation

{$R *.DFM}

function  TFtpProgressForm.GetBarPosition : Integer;
begin
    Result := ProgressBar.Position;
end;

procedure TFtpProgressForm.SetBarPosition(pos : Integer);
begin
    ProgressBar.Position := pos;
    ProgressBar.Repaint;
end;

procedure TFtpProgressForm.SetParams(title : String; min, max : Integer);
begin
    Caption := title;
    ProgressBar.Min := min;
    ProgressBar.Max := max;
    ProgressBar.Position := min;
end;

procedure TFtpProgressForm.CancelBtnClick(Sender: TObject);
begin
    FCancelled := True;
end;

procedure TFtpProgressForm.FormShow(Sender: TObject);
begin
    FCancelled := False;
    ProgressBar.RePaint;
    CancelBtn.RePaint;
    Update;
end;

end.
