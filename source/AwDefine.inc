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
{*                   AWDEFINE.INC 4.06                   *}
{*********************************************************}
{* Compiler defines affecting all APRO units             *}
{*********************************************************}

{Because AWDEFINE.INC is included in all APRO units, you can specify global
compiler options here. AWDEFINE is included *before* each units' required
compiler options, so options specified here might be overridden by hardcode
options in the source file.}

{$S- No stack overflow checking}
{$R- No range checking}
{$B- Incomplete boolean evaluation}
{$P- No open string parameters}
{$Q- No arithmetic overflow checking}
{$T- No type-checked pointers}
{$V- No var string checking}
{$X+ Extended syntax}
{$Z- Enumeration size is 256}

  {$H+ Long string support}
  {$J+ Writeable typed constants}

{.$DEFINE TapiDebug}                      { creates detailed TAPI debug log }
{.$DEFINE AdModemDebug}                   { adds debug info to dispatcher log }

{$WARN SYMBOL_PLATFORM OFF}               {APRO only works under Windows}
{$WARN UNIT_PLATFORM OFF}                 {APRO only works under Windows}
