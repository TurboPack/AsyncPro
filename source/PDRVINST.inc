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
{*                   PDRVINST.INC 4.06                   *}
{*********************************************************}

{ This file is included by PDRVINST.PAS and by printer driver RC files }

const
  idDriverName      = 1;      {printer description - must be '1' for UniDrv}
  idPortName        = 15000;  {port name for printer driver}
  idComment         = 15001;  {brief description of print driver}
  idSepFile         = 15002;  {file used to create separator pages}
  idServerName      = 15003;  {'' = local printer}
  idPrintProcessor  = 15004;  {typically 'WinPrint'}
  idDataType        = 15005;  {typically 'RAW'}

