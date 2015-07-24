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
{*                   ADPEDITT.PAS 4.06                   *}
{*********************************************************}
{* TAPI SelectedDevice property editor, actual editor in *}
{* AdTSel.pas                                            *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F+}

unit AdPEditT;

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

procedure Register;

type
  {TAPI devices property editor}
  TSelectedDeviceProperty = class(TStringProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

implementation

uses
  AdTapi,
  AdTSel;

procedure Register;
begin
  {Register property editors}
  RegisterPropertyEditor(TypeInfo(String), TApdCustomTapiDevice,
                         'SelectedDevice', TSelectedDeviceProperty);
end;

{TSelectedDeviceProperty (editor)}
  procedure TSelectedDeviceProperty.Edit;
  begin
    with (GetComponent(0) as TApdCustomTapiDevice) do
      SelectDevice;
    Modified;
  end;

  function TSelectedDeviceProperty.GetAttributes: TPropertyAttributes;
  begin
    Result := [paDialog]
  end;

end.
