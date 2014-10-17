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
{*                   ADTUTIL.PAS 4.06                    *}
{*********************************************************}
{* TAPI DLL interface and utility methods                *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F+}
{$C MOVEABLE,DEMANDLOAD,DISCARDABLE}

unit AdTUtil;
  {-Basic TAPI interface unit}

interface

uses
  Windows,
  SysUtils,
  Classes,
  OoMisc;

const

  {Limits}
  MaxCountries = 1000;
  TapiLowVer   = $00010004;                                         
  TapiHighVer  = $00010004;

  {Wave out defines}
  Wom_Open     = $3BB;
  Wom_Close    = $3BC;
  Wom_Done     = $3BD;

  {Line Callback Messages}
  Line_AddressState        = 0;
  Line_CallInfo            = 1;
  Line_CallState           = 2;
  Line_Close               = 3;
  Line_DevSpecific         = 4;
  Line_DevSpecificFeature  = 5;
  Line_GatherDigits        = 6;
  Line_Generate            = 7;
  Line_LineDevState        = 8;
  Line_MonitorDigits       = 9;
  Line_MonitorMedia        = 10;
  Line_MonitorTone         = 11;
  Line_Reply               = 12;
  Line_Request             = 13;
  Phone_Button             = 14;
  Phone_Close              = 15;
  Phone_DevSpecific        = 16;
  Phone_Reply              = 17;
  Phone_State              = 18;
  Line_Create              = 19;  {1.4}
  Phone_Create             = 20;  {1.4}
  Line_AgentSpecific       = 21;  {2.0}
  Line_AgentStatus         = 22;  {2.0}
  Line_AppNewCall          = 23;  {2.0}
  Line_ProxyRequest        = 24;  {2.0}
  Line_Remove              = 25;  {2.0}
  Phone_Remove             = 26;  {2.0}

  {Psuedo-callback message, used for Apro-specific messages}
  Line_APDSpecific         = 32;                           

const

  LineAddrCapFlags_FwdNumRings              = $00000001;
  LineAddrCapFlags_PickupGroupID            = $00000002;
  LineAddrCapFlags_Secure                   = $00000004;
  LineAddrCapFlags_BlockIDDefault           = $00000008;
  LineAddrCapFlags_BlockIDOverride          = $00000010;
  LineAddrCapFlags_Dialed                   = $00000020;
  LineAddrCapFlags_OrigOffHook              = $00000040;
  LineAddrCapFlags_DestOffHook              = $00000080;
  LineAddrCapFlags_FwdConsult               = $00000100;
  LineAddrCapFlags_SetupConfNull            = $00000200;
  LineAddrCapFlags_AutoReconnect            = $00000400;
  LineAddrCapFlags_CompletionID             = $00000800;
  LineAddrCapFlags_TransferHeld             = $00001000;
  LineAddrCapFlags_TransferMake             = $00002000;
  LineAddrCapFlags_ConferenceHeld           = $00004000;
  LineAddrCapFlags_ConferenceMake           = $00008000;
  LineAddrCapFlags_PartialDial              = $00010000;
  LineAddrCapFlags_FwdStatusValid           = $00020000;
  LineAddrCapFlags_FwdIntextAddr            = $00040000;
  LineAddrCapFlags_FwdBusyNaAddr            = $00080000;
  LineAddrCapFlags_AcceptToAlert            = $00100000;
  LineAddrCapFlags_ConfDrop                 = $00200000;
  LineAddrCapFlags_PickupCallWait           = $00400000;
  LineAddrCapFlags_PredictiveDialer         = $00800000;  {2.0}
  LineAddrCapFlags_Queue                    = $01000000;  {2.0}
  LineAddrCapFlags_RoutePoint               = $02000000;  {2.0}
  LineAddrCapFlags_HoldMakesNew             = $04000000;  {2.0}
  LineAddrCapFlags_NoInternalCalls          = $08000000;  {2.0}
  LineAddrCapFlags_NoExternalCalls          = $10000000;  {2.0}
  LineAddrCapFlags_SetCallingID             = $20000000;  {2.0}

const

  LineAddressMode_AddressID                 = $00000001;
  LineAddressMode_DialableAddr              = $00000002;

const

  LineAddressSharing_Private                = $00000001;
  LineAddressSharing_BridgedExcl            = $00000002;
  LineAddressSharing_BridgedNew             = $00000004;
  LineAddressSharing_BridgedShared          = $00000008;
  LineAddressSharing_Monitored              = $00000010;

const

  LineAddressState_Other                    = $00000001;
  LineAddressState_DevSpecific              = $00000002;
  LineAddressState_InUseZero                = $00000004;
  LineAddressState_InUseOne                 = $00000008;
  LineAddressState_InUseMany                = $00000010;
  LineAddressState_NumCalls                 = $00000020;
  LineAddressState_Forward                  = $00000040;
  LineAddressState_Terminals                = $00000080;
  LineAddressState_CapsChange               = $00000100;  {1.4}

  AllAddressStates =
    LineAddressState_Other         or
    LineAddressState_DevSpecific   or
    LineAddressState_InUseZero     or
    LineAddressState_InUseOne      or
    LineAddressState_InUseMany     or
    LineAddressState_NumCalls      or
    LineAddressState_Forward       or
    LineAddressState_Terminals     or
    LineAddressState_CapsChange;

const

  LineAddrFeature_Forward                   = $00000001;
  LineAddrFeature_MakeCall                  = $00000002;
  LineAddrFeature_Pickup                    = $00000004;
  LineAddrFeature_SetMediaControl           = $00000008;
  LineAddrFeature_SetTerminal               = $00000010;
  LineAddrFeature_SetupConf                 = $00000020;
  LineAddrFeature_UncompleteCall            = $00000040;
  LineAddrFeature_Unpark                    = $00000080;
  LineAddrFeature_PickupHeld                = $00000100;  {2.0}
  LineAddrFeature_PickupGroup               = $00000200;  {2.0}
  LineAddrFeature_PickupDirect              = $00000400;  {2.0}
  LineAddrFeature_PickupWaiting             = $00000800;  {2.0}
  LineAddrFeature_ForwardFwd                = $00001000;  {2.0}
  LineAddrFeature_ForwardDnd                = $00002000;  {2.0}

const

  LineAgentFeature_SetAgentGroup            = $00000001;  {2.0}
  LineAgentFeature_SetAgentState            = $00000002;  {2.0}
  LineAgentFeature_SetAgentActivity         = $00000004;  {2.0}
  LineAgentFeature_AgentSpecific            = $00000008;  {2.0}
  LineAgentFeature_GetAgentActivityList     = $00000010;  {2.0}
  LineAgentFeature_GetAgentGroup            = $00000020;  {2.0}

const

  LineAgentState_LoggedOff                  = $00000001;  {2.0}
  LineAgentState_NotReady                   = $00000002;  {2.0}
  LineAgentState_Ready                      = $00000004;  {2.0}
  LineAgentState_BusyAcd                    = $00000008;  {2.0}
  LineAgentState_BusyIncoming               = $00000010;  {2.0}
  LineAgentState_BusyOutbound               = $00000020;  {2.0}
  LineAgentState_BusyOther                  = $00000040;  {2.0}
  LineAgentState_WorkingAfterCall           = $00000080;  {2.0}
  LineAgentState_Unknown                    = $00000100;  {2.0}
  LineAgentState_Unavail                    = $00000200;  {2.0}

const

  LineAgentStatus_Group                     = $00000001;  {2.0}
  LineAgentStatus_State                     = $00000002;  {2.0}
  LineAgentStatus_NextState                 = $00000004;  {2.0}
  LineAgentStatus_Activity                  = $00000008;  {2.0}
  LineAgentStatus_ActivityList              = $00000010;  {2.0}
  LineAgentStatus_GroupList                 = $00000020;  {2.0}
  LineAgentStatus_CapsChange                = $00000040;  {2.0}
  LineAgentStatus_ValidStates               = $00000080;  {2.0}
  LineAgentStatus_ValidNextStates           = $00000100;  {2.0}

const

  LineAnswerMode_None                       = $00000001;
  LineAnswerMode_Drop                       = $00000002;
  LineAnswerMode_Hold                       = $00000004;

const

  LineBearerMode_Voice                      = $00000001;
  LineBearerMode_Speech                     = $00000002;
  LineBearerMode_MultiUse                   = $00000004;
  LineBearerMode_Data                       = $00000008;
  LineBearerMode_AltSpeechData              = $00000010;
  LineBearerMode_NonCallSignaling           = $00000020;
  LineBearerMode_PassThrough                = $00000040;  {1.4}
  LineBearerMode_RestrictedData             = $00000080;  {2.0}

const

  LineBusyMode_Station                      = $00000001;
  LineBusyMode_Trunk                        = $00000002;
  LineBusyMode_Unknown                      = $00000004;
  LineBusyMode_Unavail                      = $00000008;

const

  LineCallComplCond_Busy                    = $00000001;
  LineCallComplCond_NoAnswer                = $00000002;

const

  LineCallComplMode_CampOn                  = $00000001;
  LineCallComplMode_CallBack                = $00000002;
  LineCallComplMode_Intrude                 = $00000004;
  LineCallComplMode_Message                 = $00000008;

const

  LineCallFeature_Accept                    = $00000001;   
  LineCallFeature_AddToConf                 = $00000002;   
  LineCallFeature_Answer                    = $00000004;   
  LineCallFeature_BlindTransfer             = $00000008;   
  LineCallFeature_CompleteCall              = $00000010;   
  LineCallFeature_CompleteTransf            = $00000020;   
  LineCallFeature_Dial                      = $00000040;   
  LineCallFeature_Drop                      = $00000080;   
  LineCallFeature_GatherDigits              = $00000100;   
  LineCallFeature_GenerateDigits            = $00000200;   
  LineCallFeature_GenerateTone              = $00000400;   
  LineCallFeature_Hold                      = $00000800;   
  LineCallFeature_MonitorDigits             = $00001000;   
  LineCallFeature_MonitorMedia              = $00002000;
  LineCallFeature_MonitorTones              = $00004000;   
  LineCallFeature_Park                      = $00008000;   
  LineCallFeature_PrepareAddConf            = $00010000;   
  LineCallFeature_ReDirect                  = $00020000;   
  LineCallFeature_RemoveFromConf            = $00040000;   
  LineCallFeature_SecureCall                = $00080000;   
  LineCallFeature_SendUserUser              = $00100000;   
  LineCallFeature_SetCallparams             = $00200000;   
  LineCallFeature_SetMediaControl           = $00400000;   
  LineCallFeature_SetTerminal               = $00800000;   
  LineCallFeature_SetupConf                 = $01000000;   
  LineCallFeature_SetupTransfer             = $02000000;   
  LineCallFeature_SwapHold                  = $04000000;   
  LineCallFeature_UnHold                    = $08000000;   
  LineCallFeature_ReleaseUserUserInfo       = $10000000;  {1.4} 
  LineCallFeature_SetTreatment              = $20000000;  {2.0}
  LineCallFeature_SetQos                    = $40000000;  {2.0}
  LineCallFeature_SetCallData               = $80000000;  {2.0}

const

  LineCallFeature2_NoHoldConference         = $00000001;  {2.0}
  LineCallFeature2_OneStepTransfer          = $00000002;  {2.0}
  LineCallFeature2_ComplCampOn              = $00000004;  {2.0}
  LineCallFeature2_ComplCallback            = $00000008;  {2.0}
  LineCallFeature2_ComplIntrude             = $00000010;  {2.0}
  LineCallFeature2_ComplMessage             = $00000020;  {2.0}
  LineCallFeature2_TransferNorm             = $00000040;  {2.0}
  LineCallFeature2_TransferConf             = $00000080;  {2.0}
  LineCallFeature2_ParkDirect               = $00000100;  {2.0}
  LineCallFeature2_ParkNonDirect            = $00000200;  {2.0}

const

  LineCallInfoState_Other                   = $00000001;
  LineCallInfoState_DevSpecific             = $00000002;
  LineCallInfoState_BearerMode              = $00000004;
  LineCallInfoState_Rate                    = $00000008;
  LineCallInfoState_MediaMode               = $00000010;
  LineCallInfoState_AppSpecific             = $00000020;
  LineCallInfoState_CallID                  = $00000040;
  LineCallInfoState_RelatedCallID           = $00000080;
  LineCallInfoState_Origin                  = $00000100;
  LineCallInfoState_Reason                  = $00000200;
  LineCallInfoState_CompletionID            = $00000400;
  LineCallInfoState_NumOwnerIncr            = $00000800;
  LineCallInfoState_NumOwnerDecr            = $00001000;
  LineCallInfoState_NumMonitors             = $00002000;
  LineCallInfoState_Trunk                   = $00004000;
  LineCallInfoState_CallerID                = $00008000; 
  LineCallInfoState_CalledID                = $00010000;
  LineCallInfoState_ConnectedID             = $00020000;
  LineCallInfoState_RedirectionID           = $00040000;
  LineCallInfoState_RedirectingID           = $00080000;
  LineCallInfoState_Display                 = $00100000;
  LineCallInfoState_UserUserInfo            = $00200000;
  LineCallInfoState_HighLevelComp           = $00400000;
  LineCallInfoState_LowLevelComp            = $00800000;
  LineCallInfoState_ChargingInfo            = $01000000;
  LineCallInfoState_Terminal                = $02000000;
  LineCallInfoState_DialParams              = $04000000;
  LineCallInfoState_MonitorModes            = $08000000;
  LineCallInfoState_Treatment               = $10000000;  {2.0}
  LineCallInfoState_Qos                     = $20000000;  {2.0}
  LineCallInfoState_CallData                = $40000000;  {2.0}

const

  LineCallOrigin_Outbound                   = $00000001;
  LineCallOrigin_Internal                   = $00000002;
  LineCallOrigin_External                   = $00000004;
  LineCallOrigin_Unknown                    = $00000010;
  LineCallOrigin_Unavail                    = $00000020;
  LineCallOrigin_Conference                 = $00000040;
  LineCallOrigin_Inbound                    = $00000080;  {1.4}

const

  LineCallParamFlags_Secure                 = $00000001; 
  LineCallParamFlags_Idle                   = $00000002; 
  LineCallParamFlags_BlockID                = $00000004; 
  LineCallParamFlags_OrigOffHook            = $00000008; 
  LineCallParamFlags_DestOffHook            = $00000010; 
  LineCallParamFlags_NoHoldConference       = $00000020;  {2.0}
  LineCallParamFlags_PredictiveDial         = $00000040;  {2.0}
  LineCallParamFlags_OneStepTransfer        = $00000080;  {2.0}

const

  LineCallPartyID_Blocked                   = $00000001;
  LineCallPartyID_OutOfArea                 = $00000002;
  LineCallPartyID_Name                      = $00000004;
  LineCallPartyID_Address                   = $00000008;
  LineCallPartyID_Partial                   = $00000010;
  LineCallPartyID_Unknown                   = $00000020;
  LineCallPartyID_Unavail                   = $00000040;

const

  LineCallPrivilege_None                    = $00000001;
  LineCallPrivilege_Monitor                 = $00000002;
  LineCallPrivilege_Owner                   = $00000004;

const

  LineCallReason_Direct                     = $00000001;
  LineCallReason_FwdBusy                    = $00000002;
  LineCallReason_FwdNoAnswer                = $00000004;
  LineCallReason_FwdUnCond                  = $00000008;
  LineCallReason_Pickup                     = $00000010;
  LineCallReason_Unpark                     = $00000020;
  LineCallReason_Redirect                   = $00000040;
  LineCallReason_CallCompletion             = $00000080;
  LineCallReason_Transfer                   = $00000100;
  LineCallReason_Reminder                   = $00000200;
  LineCallReason_Unknown                    = $00000400;
  LineCallReason_Unavail                    = $00000800;
  LineCallReason_Intrude                    = $00001000;  {1.4}
  LineCallReason_Parked                     = $00002000;  {1.4}
  LineCallReason_CampedOn                   = $00004000;  {2.0}
  LineCallReason_RouteRequest               = $00008000;  {2.0}

const

  LineCallSelect_Line                       = $00000001;
  LineCallSelect_Address                    = $00000002;
  LineCallSelect_Call                       = $00000004;

const

  { These values are directly used to get status strings from the resource }
  { Refer to the lcsBase constant in ADTAPI.PAS and the strings in APW.STR }
  LineCallState_Idle                        = $00000001;
  LineCallState_Offering                    = $00000002;
  LineCallState_Accepted                    = $00000004;
  LineCallState_Dialtone                    = $00000008;
  LineCallState_Dialing                     = $00000010;
  LineCallState_Ringback                    = $00000020;
  LineCallState_Busy                        = $00000040;
  LineCallState_SpecialInfo                 = $00000080;
  LineCallState_Connected                   = $00000100;
  LineCallState_Proceeding                  = $00000200;
  LineCallState_OnHold                      = $00000400;
  LineCallState_Conferenced                 = $00000800;
  LineCallState_OnHoldPendConf              = $00001000;
  LineCallState_OnHoldPendTransfer          = $00002000;
  LineCallState_Disconnected                = $00004000;
  LineCallState_Unknown                     = $00008000;

const

  LineCallTreatment_Silence                 = $00000001;  {2.0}
  LineCallTreatment_Ringback                = $00000002;  {2.0}
  LineCallTreatment_Busy                    = $00000003;  {2.0}
  LineCallTreatment_Music                   = $00000004;  {2.0}

const

  LineCardOption_Predefined                 = $00000001;  {1.4}
  LineCardOption_Hidden                     = $00000002;  {1.4}

const

  LineConnectedMode_Active                  = $00000001;  {1.4}
  LineConnectedMode_Inactive                = $00000002;  {1.4}
  LineConnectedMode_ActiveHeld              = $00000004;  {2.0}
  LineConnectedMode_InactiveHeld            = $00000008;  {2.0}
  LineConnectedMode_Confirmed               = $00000010;  {2.0}

const

  LineDevCapFlags_CrossAddrConf             = $00000001;
  LineDevCapFlags_HighLevComp               = $00000002;
  LineDevCapFlags_LowLevComp                = $00000004;
  LineDevCapFlags_MediaControl              = $00000008;
  LineDevCapFlags_MultipleAddr              = $00000010;
  LineDevCapFlags_CloseDrop                 = $00000020;
  LineDevCapFlags_DialBilling               = $00000040;
  LineDevCapFlags_DialQuiet                 = $00000080;
  LineDevCapFlags_DialDialtone              = $00000100;

const

  { These values are directly used to get status strings from the resource }
  { Refer to the ldsBase constant in ADTAPI.PAS and the strings in APW.STR }
  LineDevState_Other                        = $00000001;
  LineDevState_Ringing                      = $00000002;
  LineDevState_Connected                    = $00000004;
  LineDevState_Disconnected                 = $00000008;
  LineDevState_MsgWaitOn                    = $00000010;
  LineDevState_MsgWaitOff                   = $00000020;
  LineDevState_InService                    = $00000040;
  LineDevState_OutOfService                 = $00000080;
  LineDevState_Maintenance                  = $00000100;
  LineDevState_Open                         = $00000200;
  LineDevState_Close                        = $00000400;
  LineDevState_NumCalls                     = $00000800;
  LineDevState_NumCompletions               = $00001000;
  LineDevState_Terminals                    = $00002000;
  LineDevState_RoamMode                     = $00004000;
  LineDevState_Battery                      = $00008000;
  LineDevState_Signal                       = $00010000;
  LineDevState_DevSpecific                  = $00020000;
  LineDevState_ReInit                       = $00040000;
  LineDevState_Lock                         = $00080000;
  LineDevState_CapsChange                   = $00100000;  {1.4}
  LineDevState_ConfigChange                 = $00200000;  {1.4}
  LineDevState_TranslateChange              = $00400000;  {1.4}
  LineDevState_ComplCancel                  = $00800000;  {1.4}
  LineDevState_Removed                      = $01000000;  {1.4}

  AllLineDeviceStates =
    LineDevState_Other           or
    LineDevState_Ringing         or
    LineDevState_Connected       or
    LineDevState_Disconnected    or
    LineDevState_MsgWaitOn       or
    LineDevState_MsgWaitOff      or
    LineDevState_InService       or
    LineDevState_OutOfService    or
    LineDevState_Maintenance     or
    LineDevState_Open            or
    LineDevState_Close           or
    LineDevState_NumCalls        or
    LineDevState_NumCompletions  or
    LineDevState_Terminals       or
    LineDevState_RoamMode        or
    LineDevState_Battery         or
    LineDevState_Signal          or
    LineDevState_DevSpecific     or
    LineDevState_ReInit          or
    LineDevState_Lock            or
    LineDevState_CapsChange      or
    LineDevState_ConfigChange    or
    LineDevState_TranslateChange or
    LineDevState_ComplCancel     or
    LineDevState_Removed;

const

  LineDevStatusFlags_Connected              = $00000001;
  LineDevStatusFlags_MsgWait                = $00000002;
  LineDevStatusFlags_InService              = $00000004;
  LineDevStatusFlags_Locked                 = $00000008;

const

  LineDialToneMode_Normal                   = $00000001;
  LineDialToneMode_Special                  = $00000002;
  LineDialToneMode_Internal                 = $00000004;
  LineDialToneMode_External                 = $00000008;
  LineDialToneMode_Unknown                  = $00000010;
  LineDialToneMode_Unavail                  = $00000020;

const

  LineDigitMode_Pulse                       = $00000001;
  LineDigitMode_DTMF                        = $00000002;
  LineDigitMode_DTMFEnd                     = $00000004;

const

  LineDisconnectMode_Normal                 = $00000001;
  LineDisconnectMode_Unknown                = $00000002;
  LineDisconnectMode_Reject                 = $00000004;
  LineDisconnectMode_PickUp                 = $00000008;
  LineDisconnectMode_Forwarded              = $00000010;
  LineDisconnectMode_Busy                   = $00000020;
  LineDisconnectMode_NoAnswer               = $00000040;
  LineDisconnectMode_BadAddress             = $00000080;
  LineDisconnectMode_Unreachable            = $00000100;
  LineDisconnectMode_Congestion             = $00000200;
  LineDisconnectMode_Incompatible           = $00000400;
  LineDisconnectMode_Unavail                = $00000800;
  LineDisconnectMode_NoDialtone             = $00001000;  {1.4}
  LineDisconnectMode_NumberChanged          = $00002000;  {2.0}
  LineDisconnectMode_OutOfOrder             = $00004000;  {2.0}
  LineDisconnectMode_TempFailure            = $00008000;  {2.0}
  LineDisconnectMode_QOSUnavail             = $00010000;  {2.0}
  LineDisconnectMode_Blocked                = $00020000;  {2.0}
  LineDisconnectMode_DoNotDisturb           = $00040000;  {2.0}
  LineDisconnectMode_Cancelled              = $00080000;  {2.0}

const

  { These values are directly used to get error strings from the resource  }
  { Refer to the TapiErrorBase constant in ADTAPI.PAS and the strings in APW.STR }
  LineErr_Allocated                   = LongInt($80000001);
  LineErr_BadDeviceID                 = LongInt($80000002);
  LineErr_BearerModeUnavail           = LongInt($80000003);
  LineErr_CallUnavail                 = LongInt($80000005);
  LineErr_CompletionOverRun           = LongInt($80000006);
  LineErr_ConferenceFull              = LongInt($80000007);
  LineErr_DialBilling                 = LongInt($80000008);
  LineErr_DialDialtone                = LongInt($80000009);
  LineErr_DialPrompt                  = LongInt($8000000A);
  LineErr_DialQuiet                   = LongInt($8000000B);
  LineErr_IncompatibleApiVersion      = LongInt($8000000C);
  LineErr_IncompatibleExtVersion      = LongInt($8000000D);
  LineErr_IniFileCorrupt              = LongInt($8000000E);
  LineErr_InUse                       = LongInt($8000000F);
  LineErr_InvalAddress                = LongInt($80000010);
  LineErr_InvalAddressID              = LongInt($80000011);
  LineErr_InvalAddressMode            = LongInt($80000012);
  LineErr_InvalAddressState           = LongInt($80000013);
  LineErr_InvalAppHandle              = LongInt($80000014);
  LineErr_InvalAppName                = LongInt($80000015);
  LineErr_InvalBearerMode             = LongInt($80000016);
  LineErr_InvalCallComplMode          = LongInt($80000017);
  LineErr_InvalCallHandle             = LongInt($80000018);
  LineErr_InvalCallParams             = LongInt($80000019);
  LineErr_InvalCallPrivilege          = LongInt($8000001A);
  LineErr_InvalCallSelect             = LongInt($8000001B);
  LineErr_InvalCallState              = LongInt($8000001C);
  LineErr_InvalCallStateList          = LongInt($8000001D);
  LineErr_InvalCard                   = LongInt($8000001E);
  LineErr_InvalCompletionID           = LongInt($8000001F);
  LineErr_InvalConfCallHandle         = LongInt($80000020);
  LineErr_InvalConsultCallHandle      = LongInt($80000021);
  LineErr_InvalCountryCode            = LongInt($80000022);
  LineErr_InvalDeviceClass            = LongInt($80000023);
  LineErr_InvalDeviceHandle           = LongInt($80000024);
  LineErr_InvalDialParams             = LongInt($80000025);            
  LineErr_InvalDigitList              = LongInt($80000026);            
  LineErr_InvalDigitMode              = LongInt($80000027);            
  LineErr_InvalDigits                 = LongInt($80000028);            
  LineErr_InvalExtVersion             = LongInt($80000029);            
  LineErr_InvalGroupID                = LongInt($8000002A);            
  LineErr_InvalLineHandle             = LongInt($8000002B);            
  LineErr_InvalLineState              = LongInt($8000002C);            
  LineErr_InvalLocation               = LongInt($8000002D);            
  LineErr_InvalMediaList              = LongInt($8000002E);            
  LineErr_InvalMediaMode              = LongInt($8000002F);            
  LineErr_InvalMessageID              = LongInt($80000030);            
  LineErr_InvalParam                  = LongInt($80000032);            
  LineErr_InvalParkID                 = LongInt($80000033);            
  LineErr_InvalParkMode               = LongInt($80000034);            
  LineErr_InvalPointer                = LongInt($80000035);            
  LineErr_InvalPrivSelect             = LongInt($80000036);            
  LineErr_InvalRate                   = LongInt($80000037);            
  LineErr_InvalRequestMode            = LongInt($80000038);            
  LineErr_InvalTerminalID             = LongInt($80000039);            
  LineErr_InvalTerminalMode           = LongInt($8000003A);            
  LineErr_InvalTimeout                = LongInt($8000003B);            
  LineErr_InvalTone                   = LongInt($8000003C);            
  LineErr_InvalToneList               = LongInt($8000003D);            
  LineErr_InvalToneMode               = LongInt($8000003E);            
  LineErr_InvalTransferMode           = LongInt($8000003F);            
  LineErr_LineMapperFailed            = LongInt($80000040);            
  LineErr_NoConference                = LongInt($80000041);            
  LineErr_NoDevice                    = LongInt($80000042);            
  LineErr_NoDriver                    = LongInt($80000043);            
  LineErr_NoMem                       = LongInt($80000044);            
  LineErr_NoRequest                   = LongInt($80000045);            
  LineErr_NotOwner                    = LongInt($80000046);            
  LineErr_NotRegistered               = LongInt($80000047);            
  LineErr_OperationFailed             = LongInt($80000048);            
  LineErr_OperationUnavail            = LongInt($80000049);            
  LineErr_RateUnavail                 = LongInt($8000004A);            
  LineErr_ResourceUnavail             = LongInt($8000004B);            
  LineErr_RequestOverRun              = LongInt($8000004C);            
  LineErr_StructureTooSmall           = LongInt($8000004D);
  LineErr_TargetNotFound              = LongInt($8000004E);            
  LineErr_TargetSelf                  = LongInt($8000004F);            
  LineErr_Uninitialized               = LongInt($80000050);            
  LineErr_UserUserInfoTooBig          = LongInt($80000051);            
  LineErr_ReInit                      = LongInt($80000052);            
  LineErr_AddressBlocked              = LongInt($80000053);            
  LineErr_BillingRejected             = LongInt($80000054);            
  LineErr_InvalFeature                = LongInt($80000055);            
  LineErr_NoMultipleInstance          = LongInt($80000056);            
  LineErr_InvalAgentID                = LongInt($80000057);  {2.0}     
  LineErr_InvalAgentGroup             = LongInt($80000058);  {2.0}     
  LineErr_InvalPassword               = LongInt($80000059);  {2.0}     
  LineErr_InvalAgentState             = LongInt($8000005A);  {2.0}     
  LineErr_InvalAgentActivity          = LongInt($8000005B);  {2.0}     
  LineErr_DialVoiceDetect             = LongInt($8000005C);  {2.0}     

const

  LineFeature_DevSpecific                   = $00000001;
  LineFeature_DevSpecificFeat               = $00000002;
  LineFeature_Forward                       = $00000004;
  LineFeature_MakeCall                      = $00000008;
  LineFeature_SetMediaControl               = $00000010;
  LineFeature_SetTerminal                   = $00000020;
  LineFeature_SetDevStatus                  = $00000040;  {2.0}
  LineFeature_ForwardFwd                    = $00000080;  {2.0}
  LineFeature_ForwardDnd                    = $00000100;  {2.0}

const

  LineForwardMode_Uncond                    = $00000001;
  LineForwardMode_UncondInternal            = $00000002;
  LineForwardMode_UncondExternal            = $00000004;
  LineForwardMode_UncondSpecific            = $00000008;
  LineForwardMode_Busy                      = $00000010;
  LineForwardMode_BusyInternal              = $00000020;
  LineForwardMode_BusyExternal              = $00000040;
  LineForwardMode_BusySpecific              = $00000080;
  LineForwardMode_NoAnsw                    = $00000100;
  LineForwardMode_NoAnswInternal            = $00000200;
  LineForwardMode_NoAnswExternal            = $00000400;
  LineForwardMode_NoAnswSpecific            = $00000800;
  LineForwardMode_BusyNA                    = $00001000;
  LineForwardMode_BusyNAInternal            = $00002000;
  LineForwardMode_BusyNAExternal            = $00004000;
  LineForwardMode_BusyNASpecific            = $00008000;
  LineForwardMode_Unknown                   = $00010000;  {1.4}
  LineForwardMode_Unavail                   = $00020000;  {1.4}

const

  LineGatherTerm_BufferFull                 = $00000001;
  LineGatherTerm_TermDigit                  = $00000002;
  LineGatherTerm_FirstTimeout               = $00000004;
  LineGatherTerm_InterTimeout               = $00000008;
  LineGatherTerm_Cancel                     = $00000010;

const

  LineGenerateTerm_Done                     = $00000001;
  LineGenerateTerm_Cancel                   = $00000002;


const

{ These constants are mutually exclusive - there's no way to specify more }
{ than one at a time (and it doesn't make sense, either) so they're }
{ ordinal rather than bits. }

  LineInitializeExOption_UseHiddenWindow    = $00000001;  {2.0}
  LineInitializeExOption_UseEvent           = $00000002;  {2.0}
  LineInitializeExOption_UseCompletionPort  = $00000003;  {2.0}

const

  LineLocationOption_PulseDial              = $00000001;  {1.4}

const

  LineMapper                                = $FFFFFFFF;

const

  LineMediaControl_None                     = $00000001;
  LineMediaControl_Start                    = $00000002;
  LineMediaControl_Reset                    = $00000004;
  LineMediaControl_Pause                    = $00000008;
  LineMediaControl_Resume                   = $00000010;
  LineMediaControl_RateUp                   = $00000020;
  LineMediaControl_RateDown                 = $00000040;
  LineMediaControl_RateNormal               = $00000080;
  LineMediaControl_VolumeUp                 = $00000100;
  LineMediaControl_VolumeDown               = $00000200;
  LineMediaControl_VolumeNormal             = $00000400;

const

  LineMediaMode_Unknown                     = $00000002;
  LineMediaMode_InteractiveVoice            = $00000004;
  LineMediaMode_AutomatedVoice              = $00000008;
  LineMediaMode_DataModem                   = $00000010;
  LineMediaMode_G3Fax                       = $00000020;
  LineMediaMode_TDD                         = $00000040;
  LineMediaMode_G4Fax                       = $00000080;
  LineMediaMode_DigitalData                 = $00000100;
  LineMediaMode_Teletex                     = $00000200;
  LineMediaMode_Videotex                    = $00000400;
  LineMediaMode_Telex                       = $00000800;
  LineMediaMode_Mixed                       = $00001000;
  LineMediaMode_ADSI                        = $00002000;
  LineMediaMode_VoiceView                   = $00004000;  {1.4}
  Last_LineMediaMode                        = $00004000;

const

  LineOfferingMode_Active                   = $00000001;  {1.4}
  LineOfferingMode_Inactive                 = $00000002;  {1.4}

const

  LineOpenOption_SingleAddress              = $80000000;  {2.0}
  LineOpenOption_Proxy                      = $40000000;  {2.0}

const

  LineParkMode_Directed                     = $00000001;
  LineParkMode_NonDirected                  = $00000002;

const

  LineProxyRequest_SetAgentGroup            = $00000001;  {2.0}
  LineProxyRequest_SetAgentState            = $00000002;  {2.0}
  LineProxyRequest_SetAgentActivity         = $00000003;  {2.0}
  LineProxyRequest_GetAgentCaps             = $00000004;  {2.0}
  LineProxyRequest_GetAgentStatus           = $00000005;  {2.0}
  LineProxyRequest_AgentSpecific            = $00000006;  {2.0}
  LineProxyRequest_GetAgentActivityList     = $00000007;  {2.0}
  LineProxyRequest_GetAgentGroupList        = $00000008;  {2.0}

const

  LineRemoveFromConf_None                   = $00000001;
  LineRemoveFromConf_Last                   = $00000002;
  LineRemoveFromConf_Any                    = $00000003;

const

  LineRequestMode_MakeCall                  = $00000001;
  LineRequestMode_MediaCall                 = $00000002;
  LineRequestMode_Drop                      = $00000004;
  Last_LineRequestMode                      = LineRequestMode_MediaCall; 

const

  LineRoamMode_Unknown                      = $00000001;
  LineRoamMode_Unavail                      = $00000002;
  LineRoamMode_Home                         = $00000004;
  LineRoamMode_RoamA                        = $00000008;
  LineRoamMode_RoamB                        = $00000010;

const

  LineSpecialInfo_NoCircuit                 = $00000001;
  LineSpecialInfo_CustIrreg                 = $00000002;
  LineSpecialInfo_Reorder                   = $00000004;
  LineSpecialInfo_Unknown                   = $00000008;
  LineSpecialInfo_Unavail                   = $00000010;

const

  LineTermDev_Phone                         = $00000001;
  LineTermDev_Headset                       = $00000002;
  LineTermDev_Speaker                       = $00000004;

const

  LineTermMode_Buttons                      = $00000001;
  LineTermMode_Lamps                        = $00000002;
  LineTermMode_Display                      = $00000004;
  LineTermMode_Ringer                       = $00000008;
  LineTermMode_HookSwitch                   = $00000010;
  LineTermMode_MediaToLine                  = $00000020;
  LineTermMode_MediaFromLine                = $00000040;
  LineTermMode_MediaBiDirect                = $00000080;

const

  LineTermSharing_Private                   = $00000001;
  LineTermSharing_SharedExcl                = $00000002;
  LineTermSharing_SharedConf                = $00000004;

const

  LineTollListOption_Add                    = $00000001;
  LineTollListOption_Remove                 = $00000002;

const

  LineToneMode_Custom                       = $00000001;
  LineToneMode_Ringback                     = $00000002;
  LineToneMode_Busy                         = $00000004;
  LineToneMode_Beep                         = $00000008;
  LineToneMode_Billing                      = $00000010;

const

  LineTransferMode_Transfer                 = $00000001;
  LineTransferMode_Conference               = $00000002;

const

  LineTranslateOption_CareOverride          = $00000001;       
  LineTranslateOption_CancelCallWaiting     = $00000002;  {1.4}
  LineTranslateOption_ForceLocal            = $00000004;  {1.4}
  LineTranslateOption_ForceLD               = $00000008;  {1.4}

const

  LineTranslateResult_Canonical             = $00000001;
  LineTranslateResult_International         = $00000002;
  LineTranslateResult_LongDistance          = $00000004;
  LineTranslateResult_Local                 = $00000008;
  LineTranslateResult_InTollList            = $00000010;
  LineTranslateResult_NotInTollList         = $00000020;
  LineTranslateResult_DialBilling           = $00000040;
  LineTranslateResult_DialQuiet             = $00000080;
  LineTranslateResult_DialDialTone          = $00000100;
  LineTranslateResult_DialPrompt            = $00000200;
  LineTranslateResult_VoiceDetect           = $00000400;  {2.0}

const

  APDSPECIFIC_TAPIChange                    = $0001;
  APDSPECIFIC_BUSY                          = $0002;
  APDSPECIFIC_DIALFAIL                      = $0004;
  APDSPECIFIC_RETRYWAIT                     = $0008;
  APDSPECIFIC_DEVICEInUse                   = $0010; 

type
  {For returning TAPI VARSTRING data}
  PVarString = ^TVarString;
  TVarString = record
    case integer of
      1: (TotalSize     : DWORD;
          NeededSize    : DWORD;
          UsedSize      : DWORD;
          StringFormat  : DWORD;
          StringSize    : DWORD;
          StringOffset  : DWORD);
      2: (StringData    : array[0..1024] of AnsiChar);  //SZ type depends on StringFormat type (using AnsiChar because StringOffset is in bytes from beginning of structure)
  end;

  {Line extensions}
  PLineExtensionID = ^TLineExtensionId;
  TLineExtensionID = record
    ExtensionID0 : DWORD;
    ExtensionID1 : DWORD;
    ExtensionID2 : DWORD;
    ExtensionID3 : DWORD;
  end;

  {Data for a single country}
  TLineCountryEntry = record
    CountryID               : LongInt;
    CountryCode             : LongInt;
    NextCountryID           : LongInt;
    CountryNameSize         : LongInt;
    CountryNameOffset       : LongInt;
    SameAreaRuleSize        : LongInt;
    SameAreaRuleOffset      : LongInt;
    LongDistanceRuleSize    : LongInt;
    LongDistanceRuleOffset  : LongInt;
    InternationalRuleSize   : LongInt;
    InternationalRuleOffset : LongInt;
  end;

  {List of countries}
  PLineCountryList = ^TLineCountryList;
  TLineCountryList = record
    TotalSize         : LongInt;
    NeededSize        : Longint;
    UsedSize          : Longint;
    NumCountries      : Longint;
    CountryListSize   : Longint;
    CountryListOffset : Longint;
    case Integer of
      0: (Buffer  :
            array[0..MaxCountries] of TLineCountryEntry);
      1: (BufferBytes :
            array[0..MaxCountries*SizeOf(TLineCountryEntry)] of Byte);
  end;

  {Line dial parameters}
  PLineDialParams = ^TLineDialParams;
  TLineDialParams = record
    DialPause       : DWORD;
    DialSpeed       : DWORD;
    DigitDuration   : DWORD;
    WaitForDialtone : DWORD;
  end;

  {Line device capabilities}
  PLineDevCaps = ^TLineDevCaps;
  TLineDevCaps = record
    case Integer of
      0: (TotalSize                  : DWORD;
          NeededSize                 : DWORD;
          UsedSize                   : DWORD;
          ProviderInfoSize           : DWORD;
          ProviderInfoOffset         : DWORD;
          SwitchInfoSize             : DWORD;
          SwitchInfoOffset           : DWORD;
          PermanentLineID            : DWORD;
          LineNameSize               : DWORD;
          LineNameOffset             : DWORD;
          StringFormat               : DWORD;
          AddressModes               : DWORD;
          NumAddresses               : DWORD;
          BearerModes                : DWORD;
          MaxRate                    : DWORD;
          MediaModes                 : DWORD;
          GenerateToneModes          : DWORD;
          GenerateToneMaxNumFreq     : DWORD;
          GenerateDigitModes         : DWORD;
          MonitorToneMaxNumFreq      : DWORD;
          MonitorToneMaxNumEntries   : DWORD;
          MonitorDigitModes          : DWORD;
          GatherDigitsMinTimeout     : DWORD;
          GatherDigitsMaxTimeout     : DWORD;
          MedCtlDigitMaxListSize     : DWORD;
          MedCtlMediaMaxListSize     : DWORD;
          MedCtlToneMaxListSize      : DWORD;
          MedCtlCallStateMaxListSize : DWORD;
          DevCapFlags                : DWORD;
          MaxNumActiveCalls          : DWORD;
          AnswerMode                 : DWORD;
          RingModes                  : DWORD;
          LineStates                 : DWORD;
          UUIAcceptSize              : DWORD;
          UUIAnswerSize              : DWORD;
          UUIMakeCallSize            : DWORD;
          UUIdropSize                : DWORD;
          UUISendUserUserInfoSize    : DWORD;
          UUICallInfoSize            : DWORD;
          MinDialParams              : TLineDialParams;
          MaxDialParams              : TLineDialParams;
          DefaultDialParams          : TLineDialParams;
          NumTerminals               : DWORD;
          TerminalCapsSize           : DWORD;
          TerminalCapsOffset         : DWORD;
          TerminalTextEntrySize      : DWORD;
          TerminalTextSize           : DWORD;
          TerminalTextOffset         : DWORD;
          DevSpecificSize            : DWORD;
          DevSpecificOffset          : DWORD;
          LineFeatures               : DWORD;
          EndMark                    : Integer);
      1: (Data                       : array[0..65520] of AnsiChar);
  end;

  {Line Address Capabilities}                                        {added .06}
  PLineAddressCaps = ^TLineAddressCaps;                                  {!!.06}
  TLineAddressCaps = record
   case Integer of
     0:  (TotalSize                   : DWORD;
         NeededSize                   : DWORD;
         UsedSize                     : DWORD;
         LineDeviceID                 : DWORD;
         AddressSize                  : DWORD;
         AddressOffset                : DWORD;
         DevSpecificSize              : DWORD;
         DevSpecificOffset            : DWORD;
         AddressSharing               : DWORD;
         AddressStates                : DWORD;
         CallInfoStates               : DWORD;
         CallerIDFlags                : DWORD;
         CalledIDFlags                : DWORD;
         ConnectedIDFlags             : DWORD;
         RedirectionIDFlags           : DWORD;
         RedirectingIDFlags           : DWORD;
         CallStates                   : DWORD;
         DialToneModes                : DWORD;
         BusyModes                    : DWORD;
         SpecialInfo                  : DWORD;
         DisconnectModes              : DWORD;
         MaxNumActiveCalls            : DWORD;
         MaxNumOnHoldCalls            : DWORD;
         MaxNumOnHoldPendingCalls     : DWORD;
         MaxNumConference             : DWORD;
         MaxNumTransConf              : DWORD;
         AddrCapFlags                 : DWORD;
         CallFeatures                 : DWORD;
         RemoveFromConfCaps           : DWORD;
         RemoveFromConfState          : DWORD;
         TransferModes                : DWORD;
         ParkModes                    : DWORD;
         ForwardModes                 : DWORD;
         MaxForwardEntries            : DWORD;
         MaxSpecificEntries           : DWORD;
         MinFwdNumRings               : DWORD;
         MaxFwdNumRings               : DWORD;
         MaxCallCompletions           : DWORD;
         CallCompletionConds          : DWORD;
         CallCompletionModes          : DWORD;
         NumCompletionMessages        : DWORD;
         CompletionMsgTextEntrySize   : DWORD;
         CompletionMsgTextSize        : DWORD;
         CompletionMsgTextOffset      : DWORD;
         AddressFeatures              : DWORD;
         PredictiveAutoTransferStates : DWORD;
         NumCallTreatments            : DWORD;
         CallTreatmentListSize        : DWORD;
         CallTreatmentListOffset      : DWORD;
         DeviceClassesSize            : DWORD;
         DeviceClassesOffset          : DWORD;
         MaxCallDataSize              : DWORD;
         CallFeatures2                : DWORD;
         MaxNoAnswerTimeout           : DWORD;
         ConnectedModes               : DWORD;
         OfferingModes                : DWORD;
         AvailableMediaModes          : DWORD;
         EndMark                      : Integer);
     1: (Data : array[0..65520] of AnsiChar);
   end;

  {Line call parameters}
  PLineCallParams = ^TLineCallParams;
  TLineCallParams = record
    TotalSize                : DWORD;
    BearerMode               : DWORD;
    MinRate                  : DWORD;
    MaxRate                  : DWORD;
    MediaMode                : DWORD;
    CallParamFlags           : DWORD;
    AddressMode              : DWORD;
    AddressID                : DWORD;
    DialParams               : TLineDialParams;
    OrigAddressSize          : DWORD;
    OrigAddressOffset        : DWORD;
    DisplayableAddressSize   : DWORD;
    DisplayableAddressOffset : DWORD;
    CalledPartySize          : DWORD;
    CalledPartyOffset        : DWORD;
    CommentSize              : DWORD;
    CommentOffset            : DWORD;
    UserUserInfoSize         : DWORD;
    UserUserInfoOffset       : DWORD;
    HighLevelCompSize        : DWORD;
    HighLevelCompOffset      : DWORD;
    LowLevelCompSize         : DWORD;
    LowLevelCompOffset       : DWORD;
    DevSpecificSize          : DWORD;
    DevSpecificOffset        : DWORD;
  end;

  {Line address status info}
  PLineAddressStatus = ^TLineAddressStatus;
  TLineAddressStatus = record
    TotalSize           : DWORD;
    NeededSize          : DWORD;
    UsedSize            : DWORD;
    NumInUse            : DWORD;
    NumActiveCalls      : DWORD;
    NumOnHoldCalls      : DWORD;
    NumOnHoldPendCalls  : DWORD;
    AddressFeatures     : DWORD;
    NumRingsNoAnswer    : DWORD;
    ForwardNumEntries   : DWORD;
    ForwardSize         : DWORD;
    ForwardOffset       : DWORD;
    TerminalModesSize   : DWORD;
    TerminalModesOffset : DWORD;
    DevSpecificSize     : DWORD;
    DevSpecificOffset   : DWORD;
  end;

  PLineDevStatus = ^TLineDevStatus;                                      {!!.02}
  TLineDevStatus = record
    case Integer of
      0 : (TotalSize             : DWORD;
           NeededSize            : DWORD;
           UsedSize              : DWORD;
           NumOpens              : DWORD;
           OpenMediaModes        : DWORD;
           NumActiveCalls        : DWORD;
           NumOnHoldCalls        : DWORD;
           NumOnHoldPendCalls    : DWORD;
           LineFeatures          : DWORD;
           NumCallCompletions    : DWORD;
           RingMode              : DWORD;
           SignalLevel           : DWORD;
           BatteryLevel          : DWORD;
           RoamMode              : DWORD;
           DevStatusFlags        : DWORD;
           TerminalModesSize     : DWORD;
           TerminalModesOffset   : DWORD;
           DevSpecificSize       : DWORD;
           DevSpecificOffset     : DWORD;
           AvailableMediaModes   : DWORD;
           AppInfoSize           : DWORD;
           AppInfoOffset         : DWORD;
           EndMark               : DWORD);
    1 : (Data                    : array[0..65520] of Byte);
  end;

  {Other types}
  TLineApp  = LongInt;
  PLineApp  = ^TLineApp;
  TLine     =  LongInt;
  PLine     = ^TLine;
  TCall     = LongInt;
  PCall     = ^TCall;

  {Line call information}
  PCallInfo = ^TCallInfo;
  TCallInfo = record
    case Integer of
    0 : (TotalSize               : DWORD;
         NeededSize              : DWORD;
         UsedSize                : DWORD;
         Line                    : TLine;
         LineDeviceID            : DWORD;
         AddressID               : DWORD;
         BearerMode              : DWORD;
         Rate                    : DWORD;
         MediaMode               : DWORD;
         AppSpecific             : DWORD;
         CallID                  : DWORD;
         RelatedCallID           : DWORD;
         CallParamFlags          : DWORD;
         CallStates              : DWORD;
         MonitorDigitModes       : DWORD;
         MonitorMediaModes       : DWORD;
         DialParams              : TLineDialParams;
         Origin                  : DWORD;
         Reason                  : DWORD;
         CompletionID            : DWORD;
         NumOwners               : DWORD;
         NumMonitors             : DWORD;
         CountryCode             : DWORD;
         Trunk                   : DWORD;
         CallerIDFlags           : DWORD;
         CallerIDSize            : DWORD;
         CallerIDOffset          : DWORD;
         CallerIDNameSize        : DWORD;
         CallerIDNameOffset      : DWORD;
         CalledIDFlags           : DWORD;
         CalledIDSize            : DWORD;
         CalledIDOffset          : DWORD;
         CalledIDNameSize        : DWORD;
         CalledIDNameOffset      : DWORD;
         ConnectedIDdFlags       : DWORD;
         ConnectedIDSize         : DWORD;
         ConnectedIDOffset       : DWORD;
         ConnectedIDNameSize     : DWORD;
         ConnectedIDNameOffset   : DWORD;
         RedirectionIDFlags      : DWORD;
         RedirectionIDSize       : DWORD;
         RedirectionIDOffset     : DWORD;
         RedirectionIDNameSize   : DWORD;
         RedirectionIDNameOffset : DWORD;
         RedirectingIDFlags      : DWORD;
         RedirectingIDSize       : DWORD;
         RedirectingIDOffset     : DWORD;
         RedirectingIDNameSize   : DWORD;
         RedirectingIDNameOffset : DWORD;
         AppNameSize             : DWORD;
         AppNameOffset           : DWORD;
         DisplayableAddressSize  : DWORD;
         DisplayableAddressOffset: DWORD;
         CalledPartySize         : DWORD;
         CalledPartyOffset       : DWORD;
         CommentSize             : DWORD;
         CommentOffset           : DWORD;
         DisplaySize             : DWORD;
         DisplayOffset           : DWORD;
         UserUserInfoSize        : DWORD;
         UserUserInfoOffset      : DWORD;
         HighLevelCompSize       : DWORD;
         HighLevelCompOffset     : DWORD;
         LowLevelCompSize        : DWORD;
         LowLevelCompOffset      : DWORD;
         ChargingInfoSize        : DWORD;
         ChargingInfoOffset      : DWORD;
         TerminalModesSize       : DWORD;
         TerminalModesOffset     : DWORD;
         DevSpecificSize         : DWORD;
         DevSpecificOffset       : DWORD;
         EndMark                 : Integer);
    1 : (Data                    : array[0..65520] of Byte);
  end;

  {More line call information}
  PCallStatus = ^TCallStatus;
  TCallStatus = record
    case Integer of
      0 : (TotalSize          : DWORD;
           NeededSize         : DWORD;
           UsedSize           : DWORD;
           CallState          : DWORD;
           CallStateMode      : DWORD;
           CallPrivilege      : DWORD;
           CallFeatures       : DWORD;
           DevSpecificSize    : DWORD;
           DevSpecificOffset  : DWORD;
           EndMark            : DWORD);
      1 : (Data               : array[0..65520] of Byte);
  end;

  {Structure for LineTranslateAddress results}
  PLineTranslateOutput = ^TLineTranslateOutput;
  TLineTranslateOutput = record
    case Integer of
      0 : (TotalSize                : DWORD;
           NeededSize               : DWORD;
           UsedSize                 : DWORD;
           DialableStringSize       : DWORD;
           DialableStringOffset     : DWORD;
           DisplayableStringSize    : DWORD;
           DisplayableStringOffset  : DWORD;
           CurrentCountry           : DWORD;
           DestCountry              : DWORD;
           TranslateResults         : DWORD;
           EndMark                  : DWORD);
      1 : (Data                     : array[0..65520] of Byte);
  end;

  {Structure for LineTranslateCaps }
  PLineTranslateCaps = ^TLineTranslateCaps;
  TLineTranslateCaps = record
    case Integer of
      0 : (TotalSize              : DWORD;
          NeededSize              : DWORD;
          UsedSize                : DWORD;
          NumLocations            : DWORD;
          LocationListSize        : DWORD;
          LocationListOffset      : DWORD;
          CurrentLocationID       : DWORD;
          NumCards                : DWORD;
          CardListSize            : DWORD;
          CardListOffset          : DWORD;
          CurrentPreferredCardID  : DWORD;
          EndMark                 : DWORD);
      1 : (Data                     : array[0..65520] of Byte);
  end;

  PLineMonitorTone = ^TLineMonitorTone;
  TLineMonitorTone = record
    AppSpecific  : DWORD;
    Duration     : DWORD;
    Frequency1   : DWORD;
    Frequency2   : DWORD;
    Frequency3   : DWORD;
  end;

  PLineGenerateTone = ^TLineGenerateTone;
  TLineGenerateTone = record
    Frequency   : DWORD;
    CadenceOn   : DWORD;
    CadenceOff  : DWORD;
    Volume      : DWORD;
  end;

  {Callback procedure type}
  TLineCallback = procedure(Device   : LongInt;
                            Message  : LongInt;
                            Instance : LongInt;
                            Param1   : LongInt;
                            Param2   : LongInt;
                            Param3   : LongInt)
                            stdcall;

  {Tapi function types}
  TLineInitialize = function(var LineApp : TLineApp;
                             Instance : THandle;
                             Callback : TLineCallback;
                             AppName : PAnsiChar; // --SZ OK (must be ANSI for now unless we import the wide functions)
                             var NumDevs : DWORD) : LongInt
                             stdcall;

  TLineShutdown = function(LineApp : TLineApp) : LongInt stdcall;

  TLineNegotiateApiVersion = function (LineApp : TLineApp;
                                      DeviceID : LongInt;
                                      APILowVersion : LongInt;
                                      APIHighVersion : LongInt;
                                      var ApiVersion : LongInt;
                                      var LE : TLineExtensionID) : LongInt
                                      stdcall;

  TLineGetDevCaps = function(LineApp : TLineApp;
                             DeviceID : DWORD;
                             ApiVersion : DWORD;
                             ExtVersion : DWORD;
                             LineDevCaps : PLineDevCaps) : LongInt
                             stdcall;

  TLineOpen = function(LineApp : TLineApp;
                       DeviceID : DWORD;
                       var Line : TLine;
                       ApiVersion : DWORD;
                       ExtVersion : DWORD;
                       CallbackInstance : DWORD;
                       Privleges : DWORD;
                       MediaModes : DWORD;
                       CallParams : DWORD) : LongInt
                       stdcall;

  TLineMakeCall = function(Line : TLine;
                           var Call : TCall;
                           DestAddress : PAnsiChar; // --SZ OK
                           CountryCode : DWORD;
                           const CallParams : PLineCallParams) : LongInt
                           stdcall;

  TLineAccept = function(Call : TCall;
                         UserUserInfo : PAnsiChar; // --SZ OK
                         Size : DWORD) : LongInt
                         stdcall;

  TLineAnswer = function(Call : TCall;
                         UserUserInfo : PAnsiChar;
                         Size : DWORD) : LongInt
                         stdcall;

  TLineDeallocateCall = function(Call : TCall) : LongInt
                                stdcall;

  TLineDrop = function(Call : TCall; UserInfo : PAnsiChar; Size : DWORD) : LongInt
                       stdcall;

  TLineClose = function(Line : TLine) : LongInt
                        stdcall;

  TLineGetCountry = function(CountryID : LongInt;
                            ApiVersion : LongInt;
                            LineCountryList : PLineCountryList) : LongInt
                            stdcall;

  TLineConfigDialog = function(DeviceID : DWORD;
                               Owner : HWND;
                               DeviceClass : PAnsiChar) : LongInt  // --SZ OK
                               stdcall;

  TLineConfigDialogEdit = function(DeviceID : DWORD;
                                   Owner : HWND;
                                   DeviceClass : PAnsiChar;
                                   const inDevConfig;
                                   Size : DWORD;
                                   var DevConfig : TVarString) : LongInt
                                   stdcall;

  TLineGetID = function(Line : TLine;
                        AddressID : DWORD;
                        Call : TCall;
                        Select : DWORD;
                        var DeviceID : TVarString;
                        DeviceClass : PAnsiChar) : LongInt
                        stdcall;

  TLineSetStatusMessages = function(Line : TLine;
                                    LineStates : DWORD;
                                    AddressStates : DWORD) : LongInt
                                    stdcall;

  TLineGetStatusMessages = function(Line : TLine;
                                    var LineStates : DWORD;
                                    var AddressStates : DWORD) : LongInt
                                    stdcall;

  TLineGetAddressCaps = function(LineApp : TLineApp;                     {!!.06}
                             DeviceID    : DWORD;
                             AddressId   : DWORD;
                             ApiVersion  : DWORD;
                             ExtVersion  : DWORD;
                             LineAddressCaps : PLineAddressCaps) : LongInt
                             stdcall;

  TLineGetAddressStatus = function(Line : TLine;
                                   AddressID : DWORD;
                                   var AddressStatus : TLineAddressStatus)
                                   : LongInt
                                   stdcall;

  TLineGetLineDevStatus = function(Line : TLine;                         {!!.02}
                                   var DevStatus : TLineDevStatus)
                                   : LongInt stdcall;

  TLineGetDevConfig = function (DeviceID : DWORD;
                                var DeviceConfig : TVarString;
                                DeviceClass : PAnsiChar) : LongInt
                                stdcall;

  TLineSetDevConfig = function (DeviceID : DWORD;
                                const DeviceConfig;
                                Size : DWORD;
                                DeviceClass : PAnsiChar) : LongInt
                                stdcall;

  TLineGetCallInfo = function(Call : TCall;
                              CallInfo : PCallInfo) : LongInt
                              stdcall;


  TLineGetCallStatus = function(Call : TCall;
                                CallStatus : PCallStatus) : LongInt
                                stdcall;

  TLineSetMediaMode = function(Call : TCall; MediaModes : DWORD) : LongInt
                                stdcall;

  TLineMonitorDigits = function(Call : TCall; DigitModes : DWORD): LongInt
                                 stdcall;

  TLineGenerateDigits = function(Call : TCall; DigitModes : DWORD;
                                 Digits : PAnsiChar; Duration : DWORD): LongInt
                                 stdcall;

  TLineMonitorMedia = function(Call : TCall; MediaModes : DWORD) : LongInt
                                stdcall;

  TLineHandoff = function(Call : TCall; FileName: PAnsiChar;
                          MediaMode : DWORD) : LongInt
                          stdcall;

  TLineSetCallParams = function(Call : TCall; BearerMode, MinRate,
                                MaxRate : DWORD;
                                DialParams : PLineDialParams) : LongInt
                                stdcall;

  TLineTranslateAddress = function(Line : TLine; DeviceID : DWORD;
                                   APIVersion : DWORD;
                                   AddressIn : PAnsiChar; Card : DWORD;
                                   TranslateOptions : DWORD;
                                   TranslateOutput : PLineTranslateOutput)
                                   : LongInt
                                   stdcall;

  TLineTranslateDialog = function(Line : TLine; DeviceID : DWORD;
                                  APIVersion : DWORD; HwndOwner : HWND;
                                  AddressIn : PAnsiChar) : LongInt
                                  stdcall;

  TLineSetCurrentLocation = function(Line : TLine;
                                     Location : DWORD) : LongInt
                                    stdcall;

  TLineSetTollList = function (Line : TLine; DeviceID : DWORD;
                               AddressIn : PAnsiChar;
                               TollListOption : DWORD) : LongInt
                               stdcall;

  TLineGetTranslateCaps = function(Line : TLine; APIVersion : DWORD;
                                   TranslateCaps : PLineTranslateCaps)
                                   : LongInt
                                   stdcall;

  TLineMonitorTones = function(Call : TCall; const LINEMONITORTONE;
                               NumEntries : DWORD): LongInt
                               stdcall;

  TLineGenerateTones = function(Call : TCall; ToneMode, Duration,
                                NumTones : DWORD; const LINEGENERATETONE): LongInt
                                stdcall;

  TLineHold = function(Call:TCall) : LongInt                             {!!.06}
                           stdcall;

  TLineUnhold = function(Call:TCall) : LongInt                           {!!.06}
                           stdcall;

  TLineTransfer = function(Call:TCall; DestAddress:PAnsiChar;                {!!.06}
                           CountryCode:DWord) : LongInt                  {!!.06}
                           stdcall;                                      {!!.06}


 {TAPI functions exported by this unit}
  function tuLineGenerateTones(Call : TCall; ToneMode, Duration,
                               NumTones : DWORD; const LINEGENERATETONE): LongInt;

  function tuLineMonitorTones(Call : TCall; const LINEMONITORTONE;
                              NumEntries : DWORD): LongInt;

  function tuLineSetCallParams(Call : TCall; BearerMode, MinRate,
                               MaxRate : DWORD;
                               DialParams : PLineDialParams) : LongInt;

  function tuLineHandoff(Call : TCall; FileName: PAnsiChar;
                          MediaMode : DWORD) : LongInt;

  function tuLineMonitorMedia(Call : TCall; MediaModes : DWORD) : LongInt;

  function tuLineGenerateDigits(Call : TCall; DigitModes : DWORD;
                                Digits : PAnsiChar; Duration : DWORD): LongInt;

  function tuLineMonitorDigits(Call : TCall;
                               DigitModes : DWORD): LongInt;

  function tuLineInitialize(var LineApp : TLineApp;
                            Instance : THandle;
                            Callback : TLineCallback;
                            AppName : PAnsiChar;
                            var NumDevs : DWORD) : LongInt;
    {-Initialize a line device}

  function tuLineShutdown(LineApp : TLineApp) : LongInt;
    {-Shutdown a line device}

  function tuLineNegotiateApiVersion(LineApp : TLineApp;
                                     DeviceID : LongInt;
                                     APILowVersion : LongInt;
                                     APIHighVersion : LongInt;
                                     var ApiVersion : LongInt;
                                     var LE : TLineExtensionID) : LongInt;
    {-Negotiate and return the API level to use}

  function tuLineGetDevCaps(LineApp : TLineApp;
                            DeviceID : DWORD;
                            ApiVersion : DWORD;
                            ExtVersion : DWORD;
                            LineDevCaps : PLineDevCaps) : LongInt;
    {-Return the capabilities of a line device}

  function tuLineOpen(LineApp : TLineApp;
                      DeviceID : DWORD;
                      var Line : TLine;
                      ApiVersion : DWORD;
                      ExtVersion : DWORD;
                      CallbackInstance : DWORD;
                      Privleges : DWORD;
                      MediaModes : DWORD;
                      CallParams : DWORD) : LongInt;
    {-Open a line device}

  function tuLineMakeCall(Line : TLine;
                          var Call : TCall;
                          DestAddress : PAnsiChar;
                          CountryCode : DWORD;
                          const CallParams : PLineCallParams) : LongInt;
    {-Make an outgoing call on a line device}

  function tuLineAccept(Call : TCall;
                        UserUserInfo : PAnsiChar;
                        Size : DWORD) : LongInt;
    {-Accept an incoming call}

  function tuLineAnswer(Call : TCall;
                        UserUserInfo : PAnsiChar;
                        Size : DWORD) : LongInt;
    {-Answer an incoming call}

  function tuLineDeallocateCall(Call : TCall) : LongInt;
    {-Deallocate a call}

  function tuLineDrop(Call : TCall; UserInfo : PAnsiChar; Size : DWORD) : LongInt;
    {-Drop (abort) the call in progress}

  function tuLineClose(Line : TLine) : LongInt;
    {-Close a call}

  function tuLineGetCountry(CountryID : LongInt;
                            ApiVersion : LongInt;
                            LineCountryList : PLineCountryList) : LongInt;
    {-Return country information}

  function tuLineConfigDialog(DeviceID : DWORD;
                              Owner : HWND;
                              DeviceClass : PAnsiChar) : LongInt;
    {-Display the line configuration dialog}

  function tuLineConfigDialogEdit(DeviceID : DWORD;
                                  Owner : HWND;
                                  DeviceClass : PAnsiChar;
                                  const inDevConfig;
                                  Size : DWORD;
                                  var DevConfig : TVarString) : LongInt;
    {-Display the line configuration dialog to get config struct}

  function tuLineGetID(Line : TLine;
                       AddressID : DWORD;
                       Call : TCall;
                       Select : DWORD;
                       var DeviceID : TVarString;
                       DeviceClass : PAnsiChar) : LongInt;
    {-Return the line ID}

  function tuLineSetStatusMessages(Line : TLine;
                                   LineStates : DWORD;
                                   AddressStates : DWORD) : LongInt;
    {-Specify which status messages to generate}

  function tuLineGetStatusMessages(Line : TLine;
                                   var LineStates : DWORD;
                                   var AddressStates : DWORD) : LongInt;
    {-Get which status messages are generated}

  function tuLineGetAddressCaps(LineApp : TLineApp;                      {!!.06}
                                DeviceID : DWORD;
                                AddressId : DWORD;
                                ApiVersion : DWORD;
                                ExtVersion : DWORD;
                                LineAddressCaps : PLineAddressCaps) : LongInt;
    {-Get the address capabilities}


  function tuLineGetAddressStatus(Line : TLine;
                                  AddressID : DWORD;
                                  var AddressStatus : TLineAddressStatus)
                                  : LongInt;
    {-Return the line address status}

  function tuLineGetLineDevStatus(Line : TLine;                          {!!.02}
                                  var DevStatus : PLineDevStatus) : LongInt;
    {-Return the line device status }

  function tuLineGetDevConfig(DeviceID : DWORD;
                              var DeviceConfig : TVarString;
                              DeviceClass : PAnsiChar) : LongInt;
    {-Return the device configuration}

  function tuLineSetDevConfig(DeviceID : DWORD;
                              const DeviceConfig;
                              Size : DWORD;
                              DeviceClass : PAnsiChar) : LongInt;
    {-Set the device configuration}

  function tuLineGetCallInfo(Call : TCall; CallInfo : PCallInfo) : LongInt;
    {-Get information about the current call}

  function tuLineGetCallStatus(Call : TCall;
                               CallStatus : PCallStatus) : LongInt;
    {-Get information about the current call}

  function tuLineSetMediaMode(Call : TCall; MediaModes : DWORD) : LongInt;
    {-Set the new media mode to use}

  function tuLineSetCurrentLocation(Line : TLine;
                                    Location : DWORD) : LongInt;

  function tuLineSetTollList (Line : TLine; DeviceID : DWORD;
                              AddressIn : PAnsiChar;
                              TollListOption : DWORD) : LongInt;

{Memory handling wrappers}

  function tuLineGetDevCapsDyn(LineApp : TLineApp;
                               DeviceID : DWORD;
                               ApiVersion : DWORD;
                               ExtVersion : DWORD;
                               var LineDevCaps : PLineDevCaps) : LongInt;
    {-Return the capabilities of a line device, with reallocating}

  function tuLineGetLineDevStatusDyn(Line : TLine;                       {!!.02}
                                     var DevStatus : PLineDevStatus)
                                     : LongInt;
    {-Return the status of a device, with reallocating }


  function tuLineGetCallInfoDyn(Call : TCall;
                                var CallInfo : PCallInfo) : LongInt;
    {-Get information about the current call}

  function tuLineGetCallStatusDyn(Call : TCall;
                                  var CallStatus : PCallStatus) : LongInt;
    {-Get information about the current call}

  function tuLineTranslateAddressDyn(Line : TLine;
                                     DeviceID : DWORD;
                                     APIVersion : DWORD;
                                     AddressIn : String; Card : DWORD;
                                     TranslateOptions : DWORD;
                                     var TranslateOutput : PLineTranslateOutput)
                                     : LongInt;

  function tuLineTranslateDialog(Line : TLine; DeviceID : DWORD;
                                 APIVersion : DWORD; HwndOwner : HWND;
                                 AddressIn : string) : LongInt;


  function tuLineHold(var Call : TCall) : LongInt;                       {!!.06}
    {-Place the call on hold}

  function tuLineUnhold(var Call : TCall) : LongInt;                     {!!.06}
    {-Remove the call from hold}

  function tuLineTransfer(var Call:TCall;                                {!!.06}
                          DestAddress:PAnsiChar;                             {!!.06}
                          CountryCode:DWord) : LongInt;                  {!!.06}
    {-Transfer the call to another line}

{$IFDEF TapiDebug}
var
  Dbg : Text;
{$ENDIF}

procedure UnloadTapiDLL;

implementation

const
  TapiDLL = 'TAPI32';

var
  {Pointers and constants used to get/hold the fixed record sizes}
  DevCapsFixed       : Integer;
  CallInfoFixed      : Integer;
  CallStatusFixed    : Integer;
  LineTranslateFixed : Integer;
  TranslateCapsFixed : Integer;
  DevStatusFixed     : Integer;                                          {!!.02}

  {Global vars holding entry points to TAPI}
  tapiLineGenerateTones       : TLineGenerateTones;
  tapiLineMonitorTones        : TLineMonitorTones;
  tapiLineSetCallParams       : TLineSetCallParams;
  tapiLineHandoff             : TLineHandoff;
  tapiLineMonitorMedia        : TLineMonitorMedia;
  tapiLineGenerateDigits      : TLineGenerateDigits;
  tapiLineMonitorDigits       : TLineMonitorDigits;
  tapiLineInitialize          : TLineInitialize;
  tapiLineShutdown            : TLineShutdown;
  tapiLineNegotiateApiVersion : TLineNegotiateApiVersion;
  tapiLineGetDevCaps          : TLineGetDevCaps;
  tapiLineOpen                : TLineOpen;
  tapiLineMakeCall            : TLineMakeCall;
  tapiLineAccept              : TLineAccept;
  tapiLineAnswer              : TLineAnswer;
  tapiLineDeallocateCall      : TLineDeallocateCall;
  tapiLineDrop                : TLineDrop;
  tapiLineClose               : TLineClose;
  tapiLineGetCountry          : TLineGetCountry;
  tapiLineConfigDialog        : TLineConfigDialog;
  tapiLineConfigDialogEdit    : TLineConfigDialogEdit;
  tapiLineGetID               : TLineGetID;
  tapiLineSetStatusMessages   : TLineSetStatusMessages;
  tapiLineGetStatusMessages   : TLineGetStatusMessages;
  tapiLineGetAddressStatus    : TLineGetAddressStatus;
  tapiLineGetLineDevStatus    : TLineGetLineDevStatus;
  tapiLineGetDevConfig        : TLineGetDevConfig;
  tapiLineSetDevConfig        : TLineSetDevConfig;
  tapiLineGetCallInfo         : TLineGetCallInfo;
  tapiLineGetCallStatus       : TLineGetCallStatus;
  tapiLineSetMediaMode        : TLineSetMediaMode;
  tapiLineTranslateAddress    : TLineTranslateAddress;
  tapiLineTranslateDialog     : TLineTranslateDialog;
  tapiLineSetCurrentLocation  : TLineSetCurrentLocation;
  tapiLineSetTollList         : TLineSetTollList;
  tapiLineGetTranslateCaps    : TLineGetTranslateCaps;
  tapiLineGetAddressCaps      : TLineGetAddressCaps;                     {!!.06}
  tapiLineHold                : TLineHold;                               {!!.06}
  tapiLineUnHold              : TLineUnhold;                             {!!.06}
  tapiLineTransfer            : TLineTransfer;                           {!!.06}

  {Misc}
  TapiModule    : THandle;

  function TapiLoaded : Boolean;
    {-Assure that TAPI is loaded and globals are set}
  begin
    if TapiModule <> 0 then begin
      Result := True;
      Exit;
    end;

    {Load TAPI}
    TapiModule := LoadLibrary(TapiDLL);

    if TapiModule <> 0 then begin
      {Say it's loaded...}
      Result := True;

      {...and load all globals}
      @tapiLineGenerateTones     :=
        GetProcAddress(TapiModule, 'lineGenerateTone');
      @tapiLineMonitorTones      :=
        GetProcAddress(TapiModule, 'lineMonitorTones');
      @tapiLineSetCallParams     :=
        GetProcAddress(TapiModule, 'lineSetCallParams');
      @tapiLineHandoff           :=
        GetProcAddress(TapiModule, 'lineHandoff');
      @tapiLineMonitorMedia      :=
        GetProcAddress(TapiModule, 'lineMonitorMedia');
      @tapiLineGenerateDigits    :=
        GetProcAddress(TapiModule, 'lineGenerateDigits');
      @tapiLineMonitorDigits     :=
        GetProcAddress(TapiModule, 'lineMonitorDigits');
      @tapiLineInitialize        :=
        GetProcAddress(TapiModule, 'lineInitialize');
      @tapiLineShutdown          :=
        GetProcAddress(TapiModule, 'lineShutdown');
      @tapiLineNegotiateApiVersion :=
        GetProcAddress(TapiModule, 'lineNegotiateAPIVersion');
      @tapiLineGetDevCaps        :=
        GetProcAddress(TapiModule, 'lineGetDevCaps');
      @tapiLineOpen              :=
        GetProcAddress(TapiModule, 'lineOpen');
      @tapiLineMakeCall          :=
        GetProcAddress(TapiModule, 'lineMakeCall');
      @tapiLineAccept            :=
        GetProcAddress(TapiModule, 'lineAccept');
      @tapiLineAnswer            :=
        GetProcAddress(TapiModule, 'lineAnswer');
      @tapiLineDeallocateCall    :=
        GetProcAddress(TapiModule, 'lineDeallocateCall');
      @tapiLineDrop              :=
        GetProcAddress(TapiModule, 'lineDrop');
      @tapiLineClose             :=
        GetProcAddress(TapiModule, 'lineClose');
      @tapiLineGetCountry        :=
        GetProcAddress(TapiModule, 'lineGetCountry');
      @tapiLineConfigDialog      :=
        GetProcAddress(TapiModule, 'lineConfigDialog');
      @tapiLineConfigDialogEdit  :=
        GetProcAddress(TapiModule, 'lineConfigDialogEdit');
      @tapiLineGetID             :=
        GetProcAddress(TapiModule, 'lineGetID');
      @tapiLineSetStatusMessages :=
        GetProcAddress(TapiModule, 'lineSetStatusMessages');
      @tapiLineGetStatusMessages :=
        GetProcAddress(TapiModule, 'lineGetStatusMessages');
      @tapiLineGetAddressCaps    :=                                      {!!.06}
        GetProcAddress(TapiModule, 'lineGetAddressCaps');                {!!.06}
      @tapiLineGetAddressStatus  :=
        GetProcAddress(TapiModule, 'lineGetAddressStatus');
      @tapiLineGetLineDevStatus  :=                                      {!!.02}
        GetProcAddress(TapiModule, 'lineGetLineDevStatus');              {!!.02}
      @tapiLineGetDevConfig      :=
        GetProcAddress(TapiModule, 'lineGetDevConfig');
      @tapiLineSetDevConfig      :=
        GetProcAddress(TapiModule, 'lineSetDevConfig');
      @tapiLineGetCallInfo       :=
        GetProcAddress(TapiModule, 'lineGetCallInfo');
      @tapiLineGetCallStatus     :=
        GetProcAddress(TapiModule, 'lineGetCallStatus');
      @tapiLineSetMediaMode      :=
        GetProcAddress(TapiModule, 'lineSetMediaMode');
      @tapiLineTranslateAddress  :=
        GetProcAddress(TapiModule, 'lineTranslateAddress');
      @tapiLineTranslateDialog :=
        GetProcAddress(TapiModule, 'lineTranslateDialog');
      @tapiLineSetCurrentLocation:=
        GetProcAddress(TapiModule, 'lineSetCurrentLocation');
      @tapiLineSetTollList       :=
        GetProcAddress(TapiModule, 'lineSetTollList');
      @tapiLineGetTranslateCaps  :=
        GetProcAddress(TapiModule, 'lineGetTranslateCaps');

    end else
      Result := False;
  end;

{$IFDEF TapiDebug}
procedure WriteResult(Res : LongInt);

  function ResFunc : string;
  begin
    if Res = 0 then
      Result := 'OK'
    else if Res < 0 then begin
    case Res of
    LineErr_Allocated                : Result := 'LineErr_Allocated';
    LineErr_BadDeviceID              : Result := 'LineErr_BadDeviceID';
    LineErr_BearerModeUnavail        : Result := 'LineErr_BearerModeUnavail';
    LineErr_CallUnavail              : Result := 'LineErr_CallUnavail';
    LineErr_CompletionOverRun        : Result := 'LineErr_CompletionOverRun';
    LineErr_ConferenceFull           : Result := 'LineErr_ConferenceFull';
    LineErr_DialBilling              : Result := 'LineErr_DialBilling';
    LineErr_DialDialtone             : Result := 'LineErr_DialDialtone';
    LineErr_DialPrompt               : Result := 'LineErr_DialPrompt';
    LineErr_DialQuiet                : Result := 'LineErr_DialQuiet';
    LineErr_IncompatibleApiVersion   : Result := 'LineErr_IncompatibleApiVersion';
    LineErr_IncompatibleExtVersion   : Result := 'LineErr_IncompatibleExtVersion';
    LineErr_IniFileCorrupt           : Result := 'LineErr_IniFileCorrupt';
    LineErr_InUse                    : Result := 'LineErr_InUse';
    LineErr_InvalAddress             : Result := 'LineErr_InvalAddress';
    LineErr_InvalAddressID           : Result := 'LineErr_InvalAddressID';
    LineErr_InvalAddressMode         : Result := 'LineErr_InvalAddressMode';
    LineErr_InvalAddressState        : Result := 'LineErr_InvalAddressState';
    LineErr_InvalAppHandle           : Result := 'LineErr_InvalAppHandle';
    LineErr_InvalAppName             : Result := 'LineErr_InvalAppName';
    LineErr_InvalBearerMode          : Result := 'LineErr_InvalBearerMode';
    LineErr_InvalCallComplMode       : Result := 'LineErr_InvalCallComplMode';
    LineErr_InvalCallHandle          : Result := 'LineErr_InvalCallHandle';
    LineErr_InvalCallParams          : Result := 'LineErr_InvalCallParams';
    LineErr_InvalCallPrivilege       : Result := 'LineErr_InvalCallPrivilege';
    LineErr_InvalCallSelect          : Result := 'LineErr_InvalCallSelect';
    LineErr_InvalCallState           : Result := 'LineErr_InvalCallState';
    LineErr_InvalCallStateList       : Result := 'LineErr_InvalCallStateList';
    LineErr_InvalCard                : Result := 'LineErr_InvalCard';
    LineErr_InvalCompletionID        : Result := 'LineErr_InvalCompletionID';
    LineErr_InvalConfCallHandle      : Result := 'LineErr_InvalConfCallHandle';
    LineErr_InvalConsultCallHandle   : Result := 'LineErr_InvalConsultCallHandle';
    LineErr_InvalCountryCode         : Result := 'LineErr_InvalCountryCode';
    LineErr_InvalDeviceClass         : Result := 'LineErr_InvalDeviceClass';
    LineErr_InvalDeviceHandle        : Result := 'LineErr_InvalDeviceHandle';
    LineErr_InvalDialParams          : Result := 'LineErr_InvalDialParams';
    LineErr_InvalDigitList           : Result := 'LineErr_InvalDigitList';
    LineErr_InvalDigitMode           : Result := 'LineErr_InvalDigitMode';
    LineErr_InvalDigitS              : Result := 'LineErr_InvalDigitS';
    LineErr_InvalExtVersion          : Result := 'LineErr_InvalExtVersion';
    LineErr_InvalGroupID             : Result := 'LineErr_InvalGroupID';
    LineErr_InvalLineHandle          : Result := 'LineErr_InvalLineHandle';
    LineErr_InvalLineState           : Result := 'LineErr_InvalLineState';
    LineErr_InvalLocation            : Result := 'LineErr_InvalLocation';
    LineErr_InvalMediaList           : Result := 'LineErr_InvalMediaList';
    LineErr_InvalMediaMode           : Result := 'LineErr_InvalMediaMode';
    LineErr_InvalMessageID           : Result := 'LineErr_InvalMessageID';
    LineErr_InvalParam               : Result := 'LineErr_InvalParam';
    LineErr_InvalParkID              : Result := 'LineErr_InvalParkID';
    LineErr_InvalParkMode            : Result := 'LineErr_InvalParkMode';
    LineErr_InvalPointer             : Result := 'LineErr_InvalPointer';
    LineErr_InvalPrivSelect          : Result := 'LineErr_InvalPrivSelect';
    LineErr_InvalRate                : Result := 'LineErr_InvalRate';
    LineErr_InvalRequestMode         : Result := 'LineErr_InvalRequestMode';
    LineErr_InvalTerminalID          : Result := 'LineErr_InvalTerminalID';
    LineErr_InvalTerminalMode        : Result := 'LineErr_InvalTerminalMode';
    LineErr_InvalTimeout             : Result := 'LineErr_InvalTimeout';
    LineErr_InvalTOne                : Result := 'LineErr_InvalTOne';
    LineErr_InvalTOneList            : Result := 'LineErr_InvalTOneList';
    LineErr_InvalTOneMode            : Result := 'LineErr_InvalTOneMode';
    LineErr_InvalTransferMode        : Result := 'LineErr_InvalTransferMode';
    LineErr_LineMapperFailed         : Result := 'LineErr_LineMapperFailed';
    LineErr_NoConference             : Result := 'LineErr_NoConference';
    LineErr_NoDevice                 : Result := 'LineErr_NoDevice';
    LineErr_NoDriver                 : Result := 'LineErr_NoDriver';
    LineErr_NoMem                    : Result := 'LineErr_NoMem';
    LineErr_NoRequest                : Result := 'LineErr_NoRequest';
    LineErr_NoTOwner                 : Result := 'LineErr_NoTOwner';
    LineErr_NoTRegistered            : Result := 'LineErr_NoTRegistered';
    LineErr_OperationFailed          : Result := 'LineErr_OperationFailed';
    LineErr_OperationUnavail         : Result := 'LineErr_OperationUnavail';
    LineErr_RateUnavail              : Result := 'LineErr_RateUnavail';
    LineErr_ResourceUnavail          : Result := 'LineErr_ResourceUnavail';
    LineErr_RequestOverRun           : Result := 'LineErr_RequestOverRun';
    LineErr_StructureTooSmall        : Result := 'LineErr_StructureTooSmall';
    LineErr_TargetNotFound           : Result := 'LineErr_TargetNotFound';
    LineErr_TargetSelf               : Result := 'LineErr_TargetSelf';
    LineErr_Uninitialized            : Result := 'LineErr_Uninitialized';
    LineErr_UserUserInfoTooBig       : Result := 'LineErr_UserUserInfoTooBig';
    LineErr_ReInit                   : Result := 'LineErr_ReInit';
    LineErr_AddressBlocked           : Result := 'LineErr_AddressBlocked';
    LineErr_BillingRejected          : Result := 'LineErr_BillingRejected';
    LineErr_InvalFeature             : Result := 'LineErr_InvalFeature';
    LineErr_NoMultipleInstance       : Result := 'LineErr_NoMultipleInstance';
    LineErr_InvalAgentID             : Result := 'LineErr_InvalAgentID';
    LineErr_InvalAgentGroup          : Result := 'LineErr_InvalAgentGroup';
    LineErr_InvalPassword            : Result := 'LineErr_InvalPassword';
    LineErr_InvalAgentState          : Result := 'LineErr_InvalAgentState';
    LineErr_InvalAgentActivity       : Result := 'LineErr_InvalAgentActivity';
    LineErr_DialVoiceDetect          : Result := 'LineErr_DialVoiceDetect';
    end;
    end else
      Result := 'Pending async. completion';
  end;

begin
  writeln(Dbg,format('  Result: %08.8x (%s)',[Res,trim(ResFunc)]));
end;
{$ENDIF}

{TAPI routines}
  function tuLineGenerateTones(Call : TCall; ToneMode, Duration,
                               NumTones : DWORD;
                               const LINEGENERATETONE): LongInt;
  begin
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;

    if @tapiLineGenerateTones <> nil then begin
      Result := tapiLineGenerateTones(Call, ToneMode, Duration,
                                      NumTones, LINEGENERATETONE);
      {$IFDEF TapiDebug}
      writeln(Dbg, 'lineGenerateTones');
      writeln(Dbg,format('  In: Call: %08.8x ToneMode %08.8x Duration %08.8x NumTones %08.8x',
        [Call,ToneMode,Duration,NumTones]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineMonitorTones(Call : TCall; const LINEMONITORTONE;
                              NumEntries : DWORD): LongInt;
  begin
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;

    if @tapiLineMonitorTones <> nil then begin
      Result := tapiLineMonitorTones(Call, LINEMONITORTONE,
                                      NumEntries);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineMonitorTones');
      writeln(Dbg, format('  In: Call: %08.8x NumEntries %08.8x',
        [Call,NumEntries]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineSetCallParams(Call : TCall; BearerMode, MinRate,
                               MaxRate : DWORD;
                               DialParams : PLineDialParams) : LongInt;
  begin
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;

    if @tapiLineSetCallParams <> nil then begin
      Result := tapiLineSetCallParams(Call, BearerMode, MinRate,
                                      MaxRate, DialParams);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineSetCallParams');
      writeln(Dbg, format('  In: Call:%08.8x BearerMode:%08.8x MinRate:%08.8x MaxRate:%08.8x',
        [Call,BearerMode,MinRate,MaxRate]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineHandoff(Call : TCall; FileName: PAnsiChar;
                          MediaMode : DWORD) : LongInt;
  begin
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;

    if @tapiLineHandoff <> nil then begin
      Result := tapiLineHandoff(Call, FileName, MediaMode);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineHandoff');
      if FileName = nil then
        writeln(Dbg, format('  In: Call:%08.8x FileName:nil MediaMode:%08.8x',
          [Call,MediaMode]))
      else
      writeln(Dbg, format('  In: Call:%08.8x FileName:%s MediaMode:%08.8x',
        [Call,FileName,MediaMode]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineMonitorMedia(Call : TCall;
                              MediaModes : DWORD) : LongInt;
  begin
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;

    if @tapiLineMonitorMedia <> nil then begin
      Result := tapiLineMonitorMedia(Call, MediaModes);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineMonitorMedia');
      writeln(Dbg, format('  In: Call:%08.8x MediaModes:%08.8x',
        [Call,MediaModes]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineGenerateDigits(Call : TCall; DigitModes : DWORD;
                                Digits : PAnsiChar; Duration : DWORD): LongInt;
  begin
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;

    if @tapiLineGenerateDigits <> nil then begin
      Result := tapiLineGenerateDigits(Call, DigitModes,
                                       Digits, Duration);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineGenerateDigits');
      if Digits = nil then
        writeln(Dbg, format('  In: Call:%08.8x DigitModes:%08.8x Digits:nil Duration:%08.8x',
          [Call,DigitModes,Duration]))
      else
        writeln(Dbg, format('  In: Call:%08.8x DigitModes:%08.8x Digits:%s Duration:%08.8x',
          [Call,DigitModes,Digits,Duration]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineMonitorDigits(Call : TCall;
                               DigitModes : DWORD): LongInt;
  begin
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;

    if @tapiLineMonitorDigits <> nil then begin
      Result := tapiLineMonitorDigits(Call, DigitModes);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineMonitorDigits');
      writeln(Dbg, format('  In: Call:%08.8x DigitModes:%08.8x',
        [Call,DigitModes]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineInitialize(var LineApp : TLineApp;
                            Instance : THandle;
                            Callback : TLineCallback;
                            AppName : PAnsiChar;
                            var NumDevs : DWORD) : LongInt;
    {-Initialize a line device}
  begin
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;

    if @tapiLineInitialize <> nil then begin
      Result := tapiLineInitialize(LineApp, Instance, Callback,
                                   AppName, NumDevs);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineInitialize');
      if AppName = nil then
        writeln(Dbg, format('  In : Instance:%08.8x AppName:nil',[Instance]))
      else
        writeln(Dbg, format('  In : Instance:%08.8x AppName:%s',[Instance,AppName]));
      writeln(Dbg, format('  Out: LineApp:%08.8x NumDevs:%08.8x',[LineApp,NumDevs]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineShutdown(LineApp : TLineApp) : LongInt;
    {-Shutdown a line device}
  begin
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;

    if @tapiLineShutdown <> nil then begin
      Result := tapiLineShutdown(LineApp);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineShutdown');
      writeln(Dbg, format('  In: LineApp:%08.8x',
        [LineApp]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineNegotiateApiVersion(LineApp : TLineApp;
                                     DeviceID : LongInt;
                                     APILowVersion : LongInt;
                                     APIHighVersion : LongInt;
                                     var ApiVersion : LongInt;
                                     var LE : TLineExtensionID) : LongInt;
    {-Negotiate and return the API level to use}
  begin
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;

    if @tapiLineNegotiateApiVersion <> nil then begin
      Result := tapiLineNegotiateApiVersion(LineApp, DeviceID, APILowVersion,
                                            APIHighVersion, ApiVersion, LE);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineNegotiateApiVersion');
      writeln(Dbg, format('  In : LineApp:%08.8x DeviceID:%08.8x APILowVersion:%08.8x APIHighVersion:%08.8x',
        [LineApp,DeviceID,APILowVersion,APIHighVersion]));
      writeln(Dbg, format('  Out: ApiVersion:%08.8x',
        [APIVersion]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineGetDevCaps(LineApp : TLineApp;
                            DeviceID : DWORD;
                            ApiVersion : DWORD;
                            ExtVersion : DWORD;
                            LineDevCaps : PLineDevCaps) : LongInt;
    {-Return the capabilities of a line device}
  begin
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;

    if @tapiLineGetDevCaps <> nil then begin
      Result := tapiLineGetDevCaps(LineApp, DeviceID, APIVersion,
                                   ExtVersion, LineDevCaps);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineGetDevCaps');
      writeln(Dbg, format('  In: LineApp:%08.8x DeviceID:%08.8x ApiVersion:%08.8x ExtVersion:%08.8x',
        [LineApp,DeviceID,APIVersion,ExtVersion]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineOpen(LineApp : TLineApp;
                      DeviceID : DWORD;
                      var Line : TLine;
                      ApiVersion : DWORD;
                      ExtVersion : DWORD;
                      CallbackInstance : DWORD;
                      Privleges : DWORD;
                      MediaModes : DWORD;
                      CallParams : DWORD) : LongInt;
    {-Open a line device}
    begin
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;

    if @tapiLineOpen <> nil then begin
      Result := tapiLineOpen(LineApp, DeviceID, Line, ApiVersion, ExtVersion,
                             CallbackInstance, Privleges, MediaModes,
                             CallParams);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineOpen');
      writeln(Dbg,format('  In : LineApp:%08.8x DeviceID:%08.8x ApiVersion:%08.8x ExtVersion:%08.8x Callback:%8.8x',
        [LineApp,DeviceID,APIVersion,ExtVersion,CallbackInstance]));
      writeln(Dbg,format('  In : Privileges:%08.8x MediaModes:%08.8x',
        [Privleges,MediaModes]));
      writeln(Dbg, format('  Out: Line:%08.8x',[Line]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineMakeCall(Line : TLine;
                          var Call : TCall;
                          DestAddress : PAnsiChar;
                          CountryCode : DWORD;
                          const CallParams : PLineCallParams) : LongInt;
    {-Make an outgoing call on a line device}
  begin
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;

    if @tapiLineMakeCall <> nil then begin
      Result := tapiLineMakeCall(Line, Call, DestAddress,
                                 CountryCode, CallParams);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineMakeCall');
      if DestAddress = nil then
        writeln(Dbg, format('  In : Line:%08.8x DestAddress:nil CountryCode:%08.8x',
          [Line,CountryCode]))
      else
        writeln(Dbg, format('  In : Line:%08.8x DestAddress:%s CountryCode:%08.8x',
          [Line,DestAddress,CountryCode]));
      writeln(Dbg, format('  Out: Call:%08.8x',
        [Call]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineAccept(Call : TCall;
                        UserUserInfo : PAnsiChar;
                        Size : DWORD) : LongInt;
    {-Accept an incoming call}
  begin
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;

    if @tapiLineAccept <> nil then begin
      Result := tapiLineAccept(Call, UserUserInfo, Size);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineAccept');
      if UserUserInfo = nil then
        writeln(Dbg, format('  In: Call:%08.8x UserUserInfo:nil Size:%08.8x',
          [Call,Size]))
      else
        writeln(Dbg, format('  In: Call:%08.8x UserUserInfo:%s Size:%08.8x',
          [Call,UserUserInfo,Size]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineAnswer(Call : TCall;
                        UserUserInfo : PAnsiChar;
                        Size : DWORD) : LongInt;
    {-Answer an incoming call}
  begin
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;

    if @tapiLineAnswer <> nil then begin
      Result := tapiLineAnswer(Call, UserUserInfo, Size);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineAnswer');
      if UserUserInfo = nil then
        writeln(Dbg, format('  In: Call:%08.8x UserUserInfo:nil Size:%08.8x',
          [Call,Size]))
      else
        writeln(Dbg, format('  In: Call:%08.8x UserUserInfo:%s Size:%08.8x',
          [Call,UserUserInfo,Size]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineDeallocateCall(Call : TCall) : LongInt;
    {-Deallocate a call}
  begin
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;

    if @tapiLineDeallocateCall <> nil then begin
      Result := tapiLineDeallocateCall(Call);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineDeallocateCall');
      writeln(Dbg, format('  In: Call:%08.8x',
        [Call]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineDrop(Call : TCall; UserInfo : PAnsiChar; Size : DWORD) : LongInt;
    {-Drop (abort) the call in progress}
  begin
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;

    if @tapiLineDrop <> nil then begin
      Result := tapiLineDrop(Call, UserInfo, Size);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineDrop');
      writeln(Dbg, format('  In: Call:%08.8x Size:%08.8x',
        [Call,Size]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineClose(Line : TLine) : LongInt;
    {-Close a call}
  begin
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;

    if @tapiLineClose <> nil then begin
      Result := tapiLineClose(Line);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineClose');
      writeln(Dbg, format('  In: Line:%08.8x',
        [Line]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineGetCountry(CountryID : LongInt;
                            ApiVersion : LongInt;
                            LineCountryList : PLineCountryList) : LongInt;
    {-Return country information}
  begin
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;

    if @tapiLineGetCountry <> nil then begin
      Result := tapiLineGetCountry(CountryID, ApiVersion, LineCountryList);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineGetCountry');
      writeln(Dbg, format('  In: CountryID:%08.8x APIVersion:%08.8x',
        [CountryID,ApiVersion]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineConfigDialog(DeviceID : DWORD;
                              Owner : HWND;
                              DeviceClass : PAnsiChar) : LongInt;
    {-Display the line configuration dialog}
  begin
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;

    if @tapiLineConfigDialog <> nil then begin
      Result := tapiLineConfigDialog(DeviceID, Owner, DeviceClass);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineConfigDialog');
      if DeviceClass = nil then
        writeln(Dbg, format('  In: DeviceID:%08.8x Owner:%08.8x DeviceClass:nil',
          [DeviceID,Owner]))
      else
        writeln(Dbg, format('  In: DeviceID:%08.8x Owner:%08.8x DeviceClass:%s',
          [DeviceID,Owner,DeviceClass]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineConfigDialogEdit(DeviceID : DWORD;
                                  Owner : HWND;
                                  DeviceClass : PAnsiChar;
                                  const inDevConfig;
                                  Size : DWORD;
                                  var DevConfig : TVarString) : LongInt;
    {-Display the line configuration dialog to get config struct}
  begin
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;

    if @tapiLineConfigDialogEdit <> nil then begin
      Result := tapiLineConfigDialogEdit(DeviceID, Owner, DeviceClass,
        inDevConfig, Size, DevConfig);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineConfigDialogEdit');
      if DeviceClass = nil then
        writeln(Dbg, format('  In: DeviceID:%08.8x Owner:%08.8x DeviceClass:nil',
          [DeviceID,Owner]))
      else
        writeln(Dbg, format('  In: DeviceID:%08.8x Owner:%08.8x DeviceClass:%s',
          [DeviceID,Owner,DeviceClass]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineGetID(Line : TLine;
                       AddressID : DWORD;
                       Call : TCall;
                       Select : DWORD;
                       var DeviceID : TVarString;
                       DeviceClass : PAnsiChar) : LongInt;
    {-Return the line ID}
  begin
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;

    if @tapiLineGetID <> nil then begin
      Result := tapiLineGetID(Line, AddressID, Call, Select,
                              DeviceID, DeviceClass);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineGetID');
      if DeviceClass = nil then
        writeln(Dbg, format('  In: AddressID:%08.8x Call:%08.8x Select:%08.8x DeviceClass:nil',
          [AddressID,Call,Select]))
      else
        writeln(Dbg, format('  In: AddressID:%08.8x Call:%08.8x Select:%08.8x DeviceClass:%s',
          [AddressID,Call,Select,DeviceClass]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineSetStatusMessages(Line : TLine;
                                   LineStates : DWORD;
                                   AddressStates : DWORD) : LongInt;
    {-Specify which status messages to generate}
  begin
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;

    if @tapiLineSetStatusMessages <> nil then begin
      Result := tapiLineSetStatusMessages(Line, LineStates, AddressStates);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineSetStatusMessages');
      writeln(Dbg, format('  In: Line:%08.8x LineStates:%08.8x AddressStates:%08.8x',
        [Line,LineStates,AddressStates]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineGetStatusMessages(Line : TLine;
                                   var LineStates : DWORD;
                                   var AddressStates : DWORD) : LongInt;
    {-Get which status messages are generated}
  begin
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;

    if @tapiLineGetStatusMessages <> nil then begin
      Result := tapiLineGetStatusMessages(Line, LineStates, AddressStates);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineGetStatusMessages');
      writeln(Dbg, format('  In : Line:%08.8x',
        [Line]));
      writeln(Dbg, format('  Out: LineStates:%08.8x AddressStates:%08.8x',
        [LineStates,AddressStates]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  {begin .06 addition}                                                   {!!.06}
  function tuLineGetAddressCaps(LineApp : TLineApp;
                             DeviceID    : DWORD;
                             AddressId   : DWORD;
                             ApiVersion  : DWORD;
                             ExtVersion  : DWORD;
                             LineAddressCaps : PLineAddressCaps) : LongInt;
  begin
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;

    if @tapiLineGetAddressCaps <> nil then begin
      Result := tapiLineGetAddressCaps(LineApp, DeviceID,AddressId,APIVersion,
                                   ExtVersion, LineAddressCaps);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineGetAddressCaps');
      writeln(Dbg, format('  In: LineApp:%08.8x DeviceID:%08.8x AddressID:%08.8x ApiVersion:%08.8x ExtVersion:%08.8x',
        [LineApp,DeviceID,AddressId,APIVersion,ExtVersion]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;
  {end .06 addition}                                                     {!!.06}

  function tuLineGetAddressStatus(Line : TLine;
                                  AddressID : DWORD;
                                  var AddressStatus : TLineAddressStatus)
                                  : LongInt;
    {-Return the line address status}
  begin
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;

    if @tapiLineGetAddressStatus<> nil then begin
      Result := tapiLineGetAddressStatus(Line, AddressID, AddressStatus);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineGetAddressStatus');
      writeln(Dbg, format('  In: Line:%08.8x AddressID:%08.8x',
        [Line,AddressID]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineGetLineDevStatus(Line : TLine;                          {!!.02}
                                  var DevStatus : PLineDevStatus) : LongInt;
    {-Return the line device status }
  begin
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;

    if @tapiLineGetLineDevStatus <> nil then begin
      Result := tapiLineGetLineDevStatus(Line, DevStatus^);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineGetLineDevStatus');
      writeln(Dbg, format('  In: Line:%08.8x',
        [Line]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineGetDevConfig(DeviceID : DWORD;
                              var DeviceConfig : TVarString;
                              DeviceClass : PAnsiChar) : LongInt;
    {-Return the device configuration}
  begin
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;

    if @tapiLineGetDevConfig <> nil then begin
      Result := tapiLineGetDevConfig(DeviceID, DeviceConfig, DeviceClass);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineGetDevConfig');
      if DeviceClass = nil then
        writeln(Dbg, format('  In: DeviceID:%08.8x DeviceClass:nil',
          [DeviceID]))
      else
        writeln(Dbg, format('  In: DeviceID:%08.8x DeviceClass:%s',
          [DeviceID,DeviceClass]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineSetDevConfig(DeviceID : DWORD;
                              const DeviceConfig;
                              Size : DWORD;
                              DeviceClass : PAnsiChar) : LongInt;
    {-Set the device configuration}
  begin
   if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;

    if @tapiLineSetDevConfig <> nil then begin
      Result := tapiLineSetDevConfig(DeviceID, DeviceConfig, Size, DeviceClass);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineSetDevConfig');
      if DeviceClass = nil then
        writeln(Dbg, format('  In: DeviceID:%08.8x Size:%08.8x DeviceClass:nil',
          [DeviceID,Size]))
      else
        writeln(Dbg, format('  In: DeviceID:%08.8x Size:%08.8x DeviceClass:%s',
          [DeviceID,Size,DeviceClass]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineGetCallInfo(Call : TCall; CallInfo : PCallInfo) : LongInt;
    {-Get information about the current call}
  begin
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;

    if @tapiLineGetCallInfo <> nil then begin
      Result := tapiLineGetCallInfo(Call, CallInfo);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineGetCallInfo');
      writeln(Dbg, format('  In: Call:%08.8x CallInfo:%08.8x',
        [Call,CallInfo]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineGetCallStatus(Call : TCall;
                               CallStatus : PCallStatus) : LongInt;
    {-Return information about the current call}
  begin
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;

    if @tapiLineGetCallStatus <> nil then begin
      Result := tapiLineGetCallStatus(Call, CallStatus);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineGetCallStatus');
      writeln(Dbg, format('  In: Call:%08.8x CallStatus:%08.8x',
        [Call,CallStatus]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineSetMediaMode(Call : TCall;
                              MediaModes : DWORD) : LongInt;
    {-Set new media modes}
  begin
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;

    if @tapiLineSetMediaMode <> nil then begin
      Result := tapiLineSetMediaMode(Call, MediaModes);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineSetMediaMode');
      writeln(Dbg, format('  In: Call:%08.8x MediaModes:%08.8x',
        [Call,MediaModes]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineSetCurrentLocation(Line : TLine;
                                    Location : DWORD) : LongInt;
  begin
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;
    if @tapiLineSetCurrentLocation <> nil then begin
      Result := tapiLineSetCurrentLocation(Line, Location);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineSetCurrentLocation');
      writeln(Dbg, format('  In: Line:%08.8x Location:%08.8x',
        [Line,Location]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineSetTollList(Line : TLine; DeviceID : DWORD;
                             AddressIn : PAnsiChar;
                             TollListOption : DWORD) : LongInt;
  begin
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;
    if @tapiLineSetTollList <> nil then begin
      Result := tapiLineSetTollList(Line, DeviceID,
                  AddressIn, TollListOption);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineSetTollList');
      writeln(Dbg, format('  In: Line:%08.8x DeviceID:%08.8x AddressIn:%s TollListOption:%08.8x',
        [Line,DeviceID,AddressIn,TollListOption]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

{Memory handling wrapper routines}

  function tuLineGetDevCapsDyn(LineApp : TLineApp;
                               DeviceID : DWORD;
                               ApiVersion : DWORD;
                               ExtVersion : DWORD;
                               var LineDevCaps : PLineDevCaps) : LongInt;
    {-Return the capabilities of a line device, with reallocating}
  var
    Size : DWORD;
  begin
    {Init}
    LineDevCaps := nil;

    {Allocate a buffer that's probably too small}
    LineDevCaps := AllocMem(DevCapsFixed);
    LineDevCaps^.TotalSize := DevCapsFixed;
    Result := tapiLineGetDevCaps(LineApp, DeviceID, ApiVersion,
                              ExtVersion, LineDevCaps);
    if Result = LineErr_StructureTooSmall then begin
      {Fixed buffer too small, reallocate to an arbitrary large size}
      FreeMem(LineDevCaps, DevCapsFixed);
      LineDevCaps := AllocMem(1024);
      LineDevCaps^.TotalSize := 1024;

      {And do it again}
      Result := tapiLineGetDevCaps(LineApp, DeviceID, ApiVersion,
                                   ExtVersion, LineDevCaps);

      {If we still failed, just bail}
      if Result <> 0 then begin
        FreeMem(LineDevCaps, LineDevCaps^.TotalSize);
        LineDevCaps := nil;                                         
        Exit;
      end;
    end;

    {Was there enough room for the variable part?}
    Size := LineDevCaps^.NeededSize;
    if Size > LineDevCaps^.TotalSize then begin
      {No it's not, reallocate}
      FreeMem(LineDevCaps, LineDevCaps^.TotalSize);
      LineDevCaps := AllocMem(Size);

      {And call TAPI one more time}
      LineDevCaps^.TotalSize := Size;
      Result := tapiLineGetDevCaps(LineApp, DeviceID, ApiVersion,
                                   ExtVersion, LineDevCaps);

      {If we still failed, just bail}
      if Result <> 0 then begin
        FreeMem(LineDevCaps, Size);
        LineDevCaps := nil;
        Exit;
      end;
    end;
    {$IFDEF TapiDebug}
    writeln(Dbg,'lineGetDevCapsDyn');
    writeln(Dbg, format('  In: LineApp:%08.8x DeviceID:%08.8x ApiVersion:%08.8x ExtVersion:%08.8x',
      [LineApp,DeviceID,ApiVersion,ExtVersion]));
      WriteResult(Result);
    {$ENDIF}
  end;

  function tuLineGetLineDevStatusDyn(Line : TLine;                         {!!.02}
                                     var DevStatus : PLineDevStatus) : LongInt;
  var
    Size : DWORD;
  begin
    {Init}
    DevStatus := nil;
    {Allocate a buffer that's probably too small}
    DevStatus := AllocMem(DevStatusFixed);
    DevStatus^.TotalSize := DevStatusFixed;
    Result := tapiLineGetLineDevStatus(Line, DevStatus^);
    if Result = LineErr_StructureTooSmall then begin
      {Fixed buffer too small, reallocate to an arbitrary large size}
      FreeMem(DevStatus, DevStatusFixed);
      DevStatus := AllocMem(1024);
      DevStatus^.TotalSize := 1024;
      {And do it again}
      Result := tapiLineGetLineDevStatus(Line, DevStatus^);
      {If we still failed, just bail}
      if Result <> 0 then begin
        FreeMem(DevStatus, DevStatus^.TotalSize);
        DevStatus := nil;
        Exit;
      end;
    end;

    {Was there enough room for the variable part?}
    Size := DevStatus^.NeededSize;
    if Size > DevStatus^.TotalSize then begin
      {No it's not, reallocate}
      FreeMem(DevStatus, DevStatus^.TotalSize);
      DevStatus := AllocMem(Size);

      {And call TAPI one more time}
      FillChar(DevStatus^, Size, 0);
      DevStatus^.TotalSize := Size;
      Result := tapiLineGetLineDevStatus(Line, DevStatus^);

      {If we still failed, just bail}
      if Result <> 0 then begin
        FreeMem(DevStatus, Size);
        DevStatus := nil;
        Exit;
      end;
    end;
    {$IFDEF TapiDebug}
    writeln(Dbg,'lineGetLineDevStatusDyn');
    writeln(Dbg, format('  In: Line:%08.8x',
      [Line]));
      WriteResult(Result);
    {$ENDIF}
  end;

  function tuLineGetCallInfoDyn(Call : TCall;
                                var CallInfo : PCallInfo) : LongInt;
    {-Get information about the current call}
  var
    Size : DWORD;
  begin
    {Init}
    CallInfo := nil;

    {Allocate a buffer that's probably too small}
    CallInfo := AllocMem(CallInfoFixed);

    CallInfo^.TotalSize := CallInfoFixed;
    Result := tapiLineGetCallInfo(Call, CallInfo);
    if Result = LineErr_StructureTooSmall then begin
      {Fixed buffer too small, reallocate to an arbitrary large size}
      FreeMem(CallInfo, CallInfoFixed);
      CallInfo := AllocMem(1024);
      CallInfo^.TotalSize := 1024;

      {And do it again}
      Result := tapiLineGetCallInfo(Call, CallInfo);

      {If we still failed, just bail}
      if Result <> 0 then begin
        FreeMem(CallInfo, CallInfo^.TotalSize);
        CallInfo := nil;                                            
        Exit;
      end;
    end;

    {Was there enough room for the variable part?}
    Size := CallInfo^.NeededSize;
    if Size > CallInfo^.TotalSize then begin
      {No it's not, reallocate}
      FreeMem(CallInfo, CallInfo^.TotalSize);
      CallInfo := AllocMem(Size);

      {And call TAPI one more time}
      FillChar(CallInfo^, Size, 0);
      CallInfo^.TotalSize := Size;
      Result := tapiLineGetCallInfo(Call, CallInfo);

      {If we still failed, just bail}
      if Result <> 0 then begin
        FreeMem(CallInfo, Size);
        CallInfo := nil;
        Exit;
      end;
    end;
    {$IFDEF TapiDebug}
    writeln(Dbg,'lineGetCallInfoDyn');
    writeln(Dbg, format('  In: Call:%08.8x',
      [Call]));
      WriteResult(Result);
    {$ENDIF}
  end;

  function tuLineGetCallStatusDyn(Call : TCall;
                                  var CallStatus : PCallStatus) : LongInt;
    {-Get information about the current call}
  var
    Size : DWORD;
  begin
    {Init}
    CallStatus := nil;

    {Allocate a buffer that's probably too small}
    CallStatus := AllocMem(CallStatusFixed);

    CallStatus^.TotalSize := CallStatusFixed;
    Result := tapiLineGetCallStatus(Call, CallStatus);
    if Result = LineErr_StructureTooSmall then begin
      {Fixed buffer too small, reallocate to an arbitrary large size}
      FreeMem(CallStatus, CallStatusFixed);
      CallStatus := AllocMem(1024);
      CallStatus^.TotalSize := 1024;

      {And do it again}
      Result := tapiLineGetCallStatus(Call, CallStatus);

      {If we still failed, just bail}
      if Result <> 0 then begin
        FreeMem(CallStatus, CallStatus^.TotalSize);
        CallStatus := nil;                                          
        Exit;
      end;
    end;

    {Was there enough room for the variable part?}
    Size := CallStatus^.NeededSize;
    if Size > CallStatus^.TotalSize then begin
      {No it's not, reallocate}
      FreeMem(CallStatus, CallStatus^.TotalSize);
      CallStatus := AllocMem(Size);

      {And call TAPI one more time}
      CallStatus^.TotalSize := Size;
      Result := tapiLineGetCallStatus(Call, CallStatus);

      {If we still failed, just bail}
      if Result <> 0 then begin
        FreeMem(CallStatus, Size);
        CallStatus := nil;                                           
        Exit;
      end;
    end;
    {$IFDEF TapiDebug}
    writeln(Dbg,'lineGetCallStatusDyn');
    writeln(Dbg, format('  In: Call:%08.8x',
      [Call]));
      WriteResult(Result);
    {$ENDIF}
  end;

  function tuLineTranslateAddressDyn(Line : TLine; DeviceID : DWORD;   
                                     APIVersion : DWORD;
                                     AddressIn : String; Card : DWORD;
                                     TranslateOptions : DWORD;
                                     var TranslateOutput : PLineTranslateOutput)
                                     : LongInt;
  var
    Temp    : array[0..100] of AnsiChar;
    NewSize : Integer;
  begin

    TranslateOutput := nil;

    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;

    {Allocate a buffer that's probably too small}
    TranslateOutput := AllocMem(LineTranslateFixed);

    if @tapiLineTranslateAddress <> nil then begin
      FillChar(TranslateOutput^, LineTranslateFixed, 0);
      TranslateOutput^.TotalSize := LineTranslateFixed;
      Result := tapiLineTranslateAddress(Line, DeviceID, APIVersion,
                                         StrPCopy(Temp, AddressIn), Card,
                                         TranslateOptions, TranslateOutput);

      if TranslateOutput^.NeededSize > TranslateOutput^.TotalSize then begin
        NewSize := TranslateOutput^.NeededSize;
        FreeMem(TranslateOutput, LineTranslateFixed);

        TranslateOutput := AllocMem(NewSize);
        TranslateOutput^.TotalSize := NewSize;
        Result := tapiLineTranslateAddress(Line, DeviceID, APIVersion,
                                           StrPCopy(Temp, AddressIn), Card,
                                           TranslateOptions, TranslateOutput);
        if Result <> 0 then begin
          FreeMem(TranslateOutput, NewSize);
          TranslateOutput := nil;
          Exit;
        end;
      end;
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineTranslateAddressDyn');
      writeln(Dbg, format('  In: Line:%08.8x DeviceID:%08.8x AddressIn:%s',
        [Line,DeviceID,AddressIn]));
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineTranslateDialog(Line : TLine; DeviceID : DWORD;
                                 APIVersion : DWORD; HwndOwner : HWND;
                                 AddressIn : string) : LongInt;
  var
    Temp : array[0..100] of AnsiChar;
  begin
    Result := -1;
    if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;
    if @tapiLineTranslateDialog <> nil then
      Result := tapiLineTranslateDialog(Line, DeviceID, APIVersion,
                                        HwndOwner, StrPCopy(Temp, AddressIn));
  end;

  {begin .06 addition}                                                   {!!.06}
  function tuLineHold(var Call : TCall):LongInt;
  begin
   if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;
    if @tapiLineHold <> nil then begin
      Result := tapiLineHold(Call);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineHold');
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineUnhold(var Call : TCall):LongInt;
  begin
   if not TapiLoaded then begin
      Result := ecTapiLoadFail;
      Exit;
    end;
    if @tapiLineUnhold <> nil then begin
      Result := tapiLineUnhold(Call);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineUnHold');
      WriteResult(Result);
      {$ENDIF}
    end else
      Result := ecTapiGetAddrFail;
  end;

  function tuLineTransfer(var Call:TCall;
                          DestAddress:PAnsiChar;
                          CountryCode:DWord) : LongInt;
    {-Transfer the call to another line}
   begin
    if not TapiLoaded then
    begin
      Result := ecTapiLoadFail;
      Exit;
    end;
    if @tapiLineTransfer <> nil then
     begin
      Result := tapiLineTransfer(Call, DestAddress, CountryCode);
      {$IFDEF TapiDebug}
      writeln(Dbg,'lineTransfer');
      WriteResult(Result);
      {$ENDIF}
     end
    else
      Result := ecTapiGetAddrFail;
  end;
  {end .06 addition}                                                     {!!.06}
procedure CalculateRecords;
var
  LDC             : PLineDevCaps;
  CI              : PCallInfo;
  CS              : PCallStatus;
  LTO             : PLineTranslateOutput;
  TC              : PLineTranslateCaps;
  DS              : PLineDevStatus;{!!.02}
begin
  {Calculate the size of the fixed parts of the various TAPI records}
  LDC := nil;
  CI  := nil;
  CS  := nil;
  LTO := nil;
  TC  := nil;
  DS  := nil;
  DevCapsFixed       := LongInt(@LDC^.EndMark) - LongInt(@LDC^.TotalSize);
  CallInfoFixed      := LongInt(@CI^.EndMark) - LongInt(@CI^.TotalSize);
  CallStatusFixed    := LongInt(@CS^.EndMark) - LongInt(@CS^.TotalSize);
  LineTranslateFixed := LongInt(@LTO^.EndMark) - LongInt(@LTO^.TotalSize);
  TranslateCapsFixed := LongInt(@TC^.EndMark) - LongInt(@TC^.TotalSize);
  DevStatusFixed     := LongInt(@DS^.EndMark) - LongInt(@DS^.TotalSize);
end;

procedure UnloadTapiDLL;
//SZ - introduced - call to unload the Tapi dll from memory
//   call this to avoid handle leak if used in a dll
//   do not call this in finalization of a dll
begin
  if TapiModule <> 0 then begin
    FreeLibrary(TapiModule);
    TapiModule := 0;
  end;
end;

initialization

  {Initialize the global TAPI pointers}
  tapiLineGenerateTones := nil;
  tapiLineMonitorTones := nil;
  tapiLineSetCallParams := nil;
  tapiLineHandoff := nil;
  tapiLineMonitorMedia := nil;
  tapiLineGenerateDigits := nil;
  tapiLineMonitorDigits := nil;
  tapiLineInitialize := nil;
  tapiLineShutdown := nil;
  tapiLineNegotiateApiVersion := nil;
  tapiLineGetDevCaps := nil;
  tapiLineOpen := nil;
  tapiLineMakeCall := nil;
  tapiLineAccept := nil;
  tapiLineAnswer := nil;
  tapiLineDeallocateCall := nil;
  tapiLineDrop := nil;
  tapiLineClose := nil;
  tapiLineGetCountry := nil;
  tapiLineConfigDialog := nil;
  tapiLineConfigDialogEdit := nil;
  tapiLineGetID := nil;
  tapiLineSetStatusMessages := nil;
  tapiLineGetStatusMessages := nil;
  tapiLineGetAddressStatus := nil;
  tapiLineGetDevConfig := nil;
  tapiLineSetDevConfig := nil;
  tapiLineGetCallInfo := nil;
  tapiLineGetCallStatus := nil;
  tapiLineSetMediaMode := nil;
  tapiLineTranslateAddress := nil;
  tapiLineTranslateDialog := nil;
  tapiLineSetCurrentLocation := nil;
  tapiLineSetTollList := nil;
  tapiLineGetTranslateCaps := nil;

  TapiModule := 0;

  CalculateRecords;

{$IFDEF TapiDebug}
  Assign(Dbg, 'TAPIDBG.TXT');
  Rewrite(Dbg);
{$ENDIF}

finalization                      //SZ: bugfix Loader Lock Problem!!
  {Free TAPI if we loaded it}
  if not IsLibrary then
    UnloadTapiDLL;
{$IFDEF TapiDebug}
  CloseFile(Dbg);
{$ENDIF}
end.

