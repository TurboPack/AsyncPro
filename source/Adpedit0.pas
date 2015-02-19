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
{*                   ADPEDIT0.PAS 4.06                   *}
{*********************************************************}
{* Baud rate property editor                             *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F+}

unit AdPEdit0;

interface

uses
  Windows,
  SysUtils,
  Messages,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  DesignIntf,
  DesignEditors,
  StdCtrls;

type
  TAdPEdit = class(TForm)
    BaudChoices : TComboBox;
    OK          : TButton;
    Cancel      : TButton;
    procedure OKClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
  end;

  {Baud rate property editor}
  TBaudRateProperty = class(TIntegerProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

var
  AdPEdit: TAdPEdit;

implementation

{$R *.DFM}

procedure TAdPEdit.OKClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TAdPEdit.CancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

{TBaudRateProperty (editor)}

  procedure TBaudRateProperty.Edit;
  var
    BRE : TAdPEdit;
  begin
    BRE := TAdPEdit.Create(Application);
    BRE.BaudChoices.Text := GetValue;
    try
      BRE.ShowModal;
      SetValue(BRE.BaudChoices.Text);
      Modified;
    finally
      BRE.Free;
    end;
  end;

  function TBaudRateProperty.GetAttributes: TPropertyAttributes;
  begin
    Result := [paDialog]
  end;

end.




