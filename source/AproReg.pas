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
{*                   APROREG.PAS 4.06                    *}
{*********************************************************}
{* APRO component registration                           *}
{*********************************************************}


{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F+}

unit APROReg;

interface

uses
{$IFDEF Delphi6}
  DesignIntf,
  DesignEditors;
{$ELSE}
  DsgnIntf;
{$ENDIF}

{ Constant declarations for IDE palette tab names }

const
  APROTabName     = 'APRO';
  APROFaxTabName  = 'APRO Fax';
  APROTelephonyTabName = 'APRO Telephony';
  APROStateTabName     = 'APRO State Machine';                           {!!.04}

procedure Register;

implementation

{$R APROREG.DCR}

uses
  { RTL/VCL Units }
  Classes, SysUtils, Windows,

  { Standard Units }
  AdPort,      {TApdComPort}
  AdProtcl,    {TApdProtocol}
  AdPStat,     {TApdProtocolStatus}
  AdStatLt,    {TApdSLController, TApdStatusLight}
  AdWnPort,    {TApdWinsockPort}
  AdSelCom,    {port selection dialog}
  AdPacket,    {TApdDataPacket}
  AdPropEd,    {design-time property editors}
  AdPager,     {TApdTapPager, TApdSNPPPager, TApdSMSPager}
  AdPgr,       {TApdPager (replaces TApdTAPPager and TApdSNPPPager)}     {!!.04}
  AdGSM,       {TApdGSMPhone}
  AdFtp,       {TApdFTPClient}
  AdScript,    {TApdScript}
  AdTrmEmu,    {TAdVT100Emulator, TAdTTYEmulator}
  AdRas,       {TApdRasDialer}
  AdRStat,     {TApdRasStatus}
  AdMdm,       {TAdModem}

  {State Machine Units}
  AdStMach,    {TApdStateMachine, TApdState}
  AdStDS,      {Additional data sources}                                 {!!.04}
  AdStSt,      {Additional States}                                       {!!.04}
  AdStProt,    {Protocol States}                                         {!!.04}
  AdStFax,     {Fax States}                                              {!!.04}
  AdStSapi,    {SAPI States}                                             {!!.04}

  { Fax Units }
  AdFaxCvt,    {TApdFaxConverter, TApdFaxUnpacker}
  AdFView,     {TApdFaxViewer}
  AdFax,       {TApdSendFax, TApdReceiveFax}
  AdFStat,     {TApdFaxStatus}
  AdFaxPrn,    {TApdFaxPrinter}
  AdFPStat,    {TApdFaxPrinterStatus}
  AdFaxCtl,    {TApdFaxDriverInterface}
  AdFaxSrv,    {TApdFaxServer, TApdFaxServerManager, TApdFaxClient}

  { Telephony Units }
  AdTapi,      {TApdTapiDevice}
  AdTStat,     {TApdTapiStatus}
  AdPEditT,    {select device dialog}
  AdSapiEn,    {TApdSapiEngine}
  AdSapiPh,    {TApdSapiPhone}
  AdVoIP;      {IP Telephony components}


procedure Register;
begin
  { Register standard components }
  RegisterComponents(APROTabName,
                     [TApdComPort,
                      TApdWinsockPort,
                      TApdRasDialer,
                      TApdRasStatus,
                      TApdFtpClient,
                      TApdFtpLog,
                      TApdDataPacket,
                      TApdScript,
                      {TApdStateMachine,} { installed to APRO State Machine tab below }
                      {TApdState,}
                      TAdModem,
                      TAdModemStatus,
                      TApdSLController,
                      TApdStatusLight,
                      TApdProtocol,
                      TApdProtocolLog,
                      TApdProtocolStatus,
                      TApdPager,
                      TApdTAPPager,
                      TApdSNPPPager,
                      TApdGSMPhone,
                      TApdPagerLog,
                      TAdTerminal,
                      TAdTTYEmulator,
                      TAdVT100Emulator]);

  { Register Telephony components }
  RegisterComponents(APROTelephonyTabName,
                     [TApdTapiDevice,
                      TApdTapiStatus,
                      TApdTapiLog,
                      TApdSapiEngine,
                      TApdSapiPhone,
                      TApdVoIP]);

  { Register Fax Components }
  RegisterComponents(APROFaxTabName,
                     [TApdFaxConverter,
                      TApdFaxUnpacker,
                      TApdFaxViewer,
                      TApdReceiveFax,
                      TApdSendFax,
                      TApdFaxStatus,
                      TApdFaxLog,
                      TApdFaxPrinter,
                      TApdFaxPrinterStatus,
                      TApdFaxPrinterLog,
                      TApdFaxDriverInterface,
                      TApdFaxServer,
                      TApdFaxServerManager,
                      TApdFaxClient]);

  { Register State Machine Components }                                  {!!.04}
  RegisterComponents (APROStateTabName,                                  {!!.04}
                      [TApdStateMachine,                                 {!!.04}
                       TApdStateComPortSource,                           {!!.04}
                       TApdStateGenericSource,                           {!!.04}
                       TApdState,                                        {!!.04}
                       TApdActionState,                                  {!!.04}
                       TApdSendFileState,                                {!!.04}
                       TApdReceiveFileState,                             {!!.04}
                       TApdSendFaxState,                                 {!!.04}
                       TApdReceiveFaxState,                              {!!.04}
                       TApdSapiSpeakState]);                             {!!.04}

end;

end.
