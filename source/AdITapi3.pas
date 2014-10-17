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
{*                   ADITAPI3.PAS 4.06                   *}
{*********************************************************}
{* Delphi-generated type library for TAPI 3. Used only   *}
{* by the TApdVoIP component. All of the interfaces are  *}
{* present to implement traditional phone telephony      *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{$IFDEF AProBCB}
  {$Warnings Off}  
{$ENDIF}
unit AdITapi3;

interface

uses ActiveX, Classes, Graphics, StdVCL, {$IFDEF Delphi6}Variants,{$ENDIF}
  Windows, OOMisc;
  
// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:
//   Type Libraries     : LIBID_xxxx
//   CoClasses          : CLASS_xxxx
//   DISPInterfaces     : DIID_xxxx
//   Non-DISP interfaces: IID_xxxx
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  TAPI3LibMajorVersion = 4;
  TAPI3LibMinorVersion = 0;

  LIBID_TAPI3Lib: TGUID = '{21D6D480-A88B-11D0-83DD-00AA003CCABD}';

  IID_ITCollection: TGUID = '{5EC5ACF2-9C02-11D0-8362-00AA003CCABD}';
  IID_ITCallStateEvent: TGUID = '{62F47097-95C9-11D0-835D-00AA003CCABD}';
  IID_ITCallInfo: TGUID = '{350F85D1-1227-11D3-83D4-00C04FB6809F}';
  IID_ITAddress: TGUID = '{B1EFC386-9355-11D0-835C-00AA003CCABD}';
  IID_ITTAPI: TGUID = '{B1EFC382-9355-11D0-835C-00AA003CCABD}';
  IID_IEnumAddress: TGUID = '{1666FCA1-9363-11D0-835C-00AA003CCABD}';
  IID_IEnumCallHub: TGUID = '{A3C15450-5B92-11D1-8F4E-00C04FB6809F}';
  IID_ITCallHub: TGUID = '{A3C1544E-5B92-11D1-8F4E-00C04FB6809F}';
  IID_IEnumCall: TGUID = '{AE269CF6-935E-11D0-835C-00AA003CCABD}';
  IID_IEnumUnknown: TGUID = '{00000100-0000-0000-C000-000000000046}';
  IID_ITBasicCallControl: TGUID = '{B1EFC389-9355-11D0-835C-00AA003CCABD}';
  IID_ITForwardInformation: TGUID = '{449F659E-88A3-11D1-BB5D-00C04FB6809F}';
  IID_ITCallNotificationEvent: TGUID = '{895801DF-3DD6-11D1-8F30-00C04FB6809F}';
  IID_ITTAPIEventNotification: TGUID = '{EDDB9426-3B91-11D1-8F30-00C04FB6809F}';
  IID_ITBasicAudioTerminal: TGUID = '{B1EFC38D-9355-11D0-835C-00AA003CCABD}';
  IID_ITCallHubEvent: TGUID = '{A3C15451-5B92-11D1-8F4E-00C04FB6809F}';
  IID_ITAddressCapabilities: TGUID = '{8DF232F5-821B-11D1-BB5C-00C04FB6809F}';
  IID_IEnumBstr: TGUID = '{35372049-0BC6-11D2-A033-00C04FB6809F}';
  IID_ITQOSEvent: TGUID = '{CFA3357C-AD77-11D1-BB68-00C04FB6809F}';
  IID_ITAddressEvent: TGUID = '{831CE2D1-83B5-11D1-BB5C-00C04FB6809F}';
  IID_ITTerminal: TGUID = '{B1EFC38A-9355-11D0-835C-00AA003CCABD}';
  IID_ITCallMediaEvent: TGUID = '{FF36B87F-EC3A-11D0-8EE4-00C04FB6809F}';
  IID_ITStream: TGUID = '{EE3BD605-3868-11D2-A045-00C04FB6809F}';
  IID_IEnumTerminal: TGUID = '{AE269CF4-935E-11D0-835C-00AA003CCABD}';
  IID_ITTAPIObjectEvent: TGUID = '{F4854D48-937A-11D1-BB58-00C04FB6809F}';
  IID_ITAddressTranslation: TGUID = '{0C4D8F03-8DDB-11D1-A09E-00805FC147D3}';
  IID_ITAddressTranslationInfo: TGUID = '{AFC15945-8D40-11D1-A09E-00805FC147D3}';
  IID_IEnumLocation: TGUID = '{0C4D8F01-8DDB-11D1-A09E-00805FC147D3}';
  IID_ITLocationInfo: TGUID = '{0C4D8EFF-8DDB-11D1-A09E-00805FC147D3}';
  IID_IEnumCallingCard: TGUID = '{0C4D8F02-8DDB-11D1-A09E-00805FC147D3}';
  IID_ITCallingCard: TGUID = '{0C4D8F00-8DDB-11D1-A09E-00805FC147D3}';
  IID_ITAgent: TGUID = '{5770ECE5-4B27-11D1-BF80-00805FC147D3}';
  IID_IEnumAgentSession: TGUID = '{5AFC314E-4BCC-11D1-BF80-00805FC147D3}';
  IID_ITAgentSession: TGUID = '{5AFC3147-4BCC-11D1-BF80-00805FC147D3}';
  IID_ITACDGroup: TGUID = '{5AFC3148-4BCC-11D1-BF80-00805FC147D3}';
  IID_IEnumQueue: TGUID = '{5AFC3158-4BCC-11D1-BF80-00805FC147D3}';
  IID_ITQueue: TGUID = '{5AFC3149-4BCC-11D1-BF80-00805FC147D3}';
  IID_ITAgentEvent: TGUID = '{5AFC314A-4BCC-11D1-BF80-00805FC147D3}';
  IID_ITAgentSessionEvent: TGUID = '{5AFC314B-4BCC-11D1-BF80-00805FC147D3}';
  IID_ITACDGroupEvent: TGUID = '{297F3032-BD11-11D1-A0A7-00805FC147D3}';
  IID_ITQueueEvent: TGUID = '{297F3033-BD11-11D1-A0A7-00805FC147D3}';
  IID_ITTAPICallCenter: TGUID = '{5AFC3154-4BCC-11D1-BF80-00805FC147D3}';
  IID_IEnumAgentHandler: TGUID = '{587E8C28-9802-11D1-A0A4-00805FC147D3}';
  IID_ITAgentHandler: TGUID = '{587E8C22-9802-11D1-A0A4-00805FC147D3}';
  IID_IEnumACDGroup: TGUID = '{5AFC3157-4BCC-11D1-BF80-00805FC147D3}';
  IID_ITAgentHandlerEvent: TGUID = '{297F3034-BD11-11D1-A0A7-00805FC147D3}';
  IID_ITCallInfoChangeEvent: TGUID = '{5D4B65F9-E51C-11D1-A02F-00C04FB6809F}';
  IID_ITRequestEvent: TGUID = '{AC48FFDE-F8C4-11D1-A030-00C04FB6809F}';
  IID_ITMediaSupport: TGUID = '{B1EFC384-9355-11D0-835C-00AA003CCABD}';
  IID_ITTerminalSupport: TGUID = '{B1EFC385-9355-11D0-835C-00AA003CCABD}';
  IID_IEnumTerminalClass: TGUID = '{AE269CF5-935E-11D0-835C-00AA003CCABD}';
  IID_ITStreamControl: TGUID = '{EE3BD604-3868-11D2-A045-00C04FB6809F}';
  IID_IEnumStream: TGUID = '{EE3BD606-3868-11D2-A045-00C04FB6809F}';
  IID_ITSubStreamControl: TGUID = '{EE3BD607-3868-11D2-A045-00C04FB6809F}';
  IID_ITSubStream: TGUID = '{EE3BD608-3868-11D2-A045-00C04FB6809F}';
  IID_IEnumSubStream: TGUID = '{EE3BD609-3868-11D2-A045-00C04FB6809F}';
  IID_ITLegacyAddressMediaControl: TGUID = '{AB493640-4C0B-11D2-A046-00C04FB6809F}';
  IID_ITLegacyCallMediaControl: TGUID = '{D624582F-CC23-4436-B8A5-47C625C8045D}';
  IID_ITDigitDetectionEvent: TGUID = '{80D3BFAC-57D9-11D2-A04A-00C04FB6809F}';
  IID_ITDigitGenerationEvent: TGUID = '{80D3BFAD-57D9-11D2-A04A-00C04FB6809F}';
  IID_ITPrivateEvent: TGUID = '{0E269CD0-10D4-4121-9C22-9C85D625650D}';
  DIID_ITTAPIDispatchEventNotification: TGUID = '{9F34325B-7E62-11D2-9457-00C04F8EC888}';
  CLASS_TAPI: TGUID = '{21D6D48E-A88B-11D0-83DD-00AA003CCABD}';
  IID_ITDispatchMapper: TGUID = '{E9225295-C759-11D1-A02B-00C04FB6809F}';
  CLASS_DispatchMapper: TGUID = '{E9225296-C759-11D1-A02B-00C04FB6809F}';
  IID_ITRequest: TGUID = '{AC48FFDF-F8C4-11D1-A030-00C04FB6809F}';
  CLASS_RequestMakeCall: TGUID = '{AC48FFE0-F8C4-11D1-A030-00C04FB6809F}';

  {video render GUID's}
  CLSID_FilterGraph: TGUID = (D1:$E436EBB3;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  CLSID_CaptureGraphBuilder2: TGUID = (D1:$BF87B6E1;D2:$8C27;D3:$11d0;D4:($B3,$F0,$00,$AA,$00,$37,$61,$C5));
  IID_IVideoWindow: TGUID = (D1:$56A868B4;D2:$0AD4;D3:$11CE;D4:($B0,$3A,$00,$20,$AF,$0B,$A7,$70));
  IID_IMediaControl: TGUID = (D1:$56A868B1;D2:$0AD4;D3:$11CE;D4:($B0,$3A,$00,$20,$AF,$0B,$A7,$70));
  IID_IPin : TGUID = '{56A86891-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IEnumPins : TGUID = '{56A86892-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IEnumMediaTypes : TGUID = '{89C31040-846B-11CE-97D3-00AA0055595A}';
  IID_IFilterGraph : TGUID = '{56A8689F-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IEnumFilters : TGUID = '{56A86893-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IMediaFilter : TGUID = '{56A86899-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IBaseFilter : TGUID = '{56A86895-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IReferenceClock : TGUID = '{56A86897-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IReferenceClock2 : TGUID = '{36B73885-C2C8-11CF-8B46-00805F6CEF60}';
  IID_IMediaSample : TGUID = '{56A8689A-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IMediaSample2 : TGUID = '{36B73884-C2C8-11CF-8B46-00805F6CEF60}';
  IID_IMemAllocator : TGUID = '{56A8689C-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IMemInputPin : TGUID = '{56A8689D-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IAMovieSetup : TGUID = '{A3D8CEC0-7E5A-11CF-BBC5-00805F6CEF20}';
  IID_IMediaSeeking : TGUID = '{36B73880-C2C8-11CF-8B46-00805F6CEF60}';
  IID_IEnumRegFilters : TGUID = '{56A868A4-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IFilterMapper : TGUID = '{56A868A3-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IFilterMapper2 : TGUID = '{B79BB0B0-33C1-11D1-ABE1-00A0C905F375}';
  IID_IQualityControl : TGUID = '{56A868A5-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IOverlayNotify : TGUID = '{56A868A0-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IOverlay : TGUID = '{56A868A1-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IMediaEventSink : TGUID = '{56A868A2-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IFileSourceFilter : TGUID = '{56A868A6-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IFileSinkFilter : TGUID = '{A2104830-7C70-11CF-8BCE-00AA00A3F1A6}';
  IID_IFileSinkFilter2 : TGUID = '{00855B90-CE1B-11D0-BD4F-00A0C911CE86}';
  IID_IFileAsyncIO : TGUID = '{56A868A7-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IGraphBuilder : TGUID = '{56A868A9-0AD4-11CE-B03A-0020AF0BA770}';
  IID_ICaptureGraphBuilder : TGUID = '{BF87B6E0-8C27-11D0-B3F0-00AA003761C5}';
  IID_IAMCopyCaptureFileProgress : TGUID = '{670D1D20-A068-11D0-B3F0-00AA003761C5}';
  IID_IFilterGraph2 : TGUID = '{36B73882-C2C8-11CF-8B46-00805F6CEF60}';
  IID_IStreamBuilder : TGUID = '{56A868BF-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IAsyncReader : TGUID = '{56A868AA-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IGraphVersion : TGUID = '{56A868AB-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IResourceConsumer : TGUID = '{56A868AD-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IResourceManager : TGUID = '{56A868AC-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IDistributorNotify : TGUID = '{56A868AF-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IAMStreamControl : TGUID = '{36b73881-c2c8-11cf-8b46-00805f6cef60}';
  IID_ISeekingPassThru : TGUID = '{36B73883-C2C8-11CF-8B46-00805F6CEF60}';
  IID_IAMStreamConfig : TGUID = '{C6E13340-30AC-11d0-A18C-00A0C9118956}';
  IID_IConfigInterleaving : TGUID = '{BEE3D220-157B-11d0-BD23-00A0C911CE86}';
  IID_IConfigAviMux : TGUID = '{5ACD6AA0-F482-11ce-8B67-00AA00A3F1A6}';
  IID_IAMVideoCompression : TGUID = '{C6E13343-30AC-11d0-A18C-00A0C9118956}';
  IID_IAMVfwCaptureDialogs : TGUID = '{D8D715A0-6E5E-11D0-B3F0-00AA003761C5}';
  IID_IAMVfwCompressDialogs : TGUID = '{D8D715A3-6E5E-11D0-B3F0-00AA003761C5}';
  IID_IAMDroppedFrames : TGUID = '{C6E13344-30AC-11d0-A18C-00A0C9118956}';
  IID_IAMAudioInputMixer : TGUID = '{54C39221-8380-11d0-B3F0-00AA003761C5}';
  IID_IAMAnalogVideoDecoder : TGUID = '{C6E13350-30AC-11d0-A18C-00A0C9118956}';
  IID_IAMVideoProcAmp : TGUID = '{C6E13360-30AC-11d0-A18C-00A0C9118956}';
  IID_IAMCameraControl : TGUID = '{C6E13370-30AC-11d0-A18C-00A0C9118956}';
  IID_IAMCrossbar : TGUID = '{C6E13380-30AC-11d0-A18C-00A0C9118956}';
  IID_IAMTuner : TGUID = '{211A8761-03AC-11d1-8D13-00AA00BD8339}';
  IID_IAMTunerNotification : TGUID = '{211A8760-03AC-11d1-8D13-00AA00BD8339}';
  IID_IAMTVTuner : TGUID = '{211A8766-03AC-11d1-8D13-00AA00BD8339}';
  IID_IBPCSatelliteTuner : TGUID = '{211A8765-03AC-11d1-8D13-00AA00BD8339}';
  IID_IAMTVAudio : TGUID = '{83EC1C30-23D1-11d1-99E6-00A0C9560266}';
  IID_IAMTVAudioNotification : TGUID = '{83EC1C33-23D1-11D1-99E6-00A0C9560266}';
  IID_IAMAnalogVideoEncoder : TGUID = '{C6E133B0-30AC-11d0-A18C-00A0C9118956}';
  IID_IMediaPropertyBag : TGUID = '{6025A880-C0D5-11D0-BD4E-00A0C911CE86}';
  IID_IPersistMediaPropertyBag : TGUID = '{5738E040-B67F-11d0-BD4D-00A0C911CE86}';
  IID_IAMPhysicalPinInfo : TGUID = '{F938C991-3029-11CF-8C44-00AA006B6814}';
  IID_IAMExtDevice : TGUID = '{B5730A90-1A2C-11CF-8C23-00AA006B6814}';
  IID_IAMExtTransport : TGUID = '{A03CD5F0-3045-11CF-8C44-00AA006B6814}';
  IID_IAMTimecodeReader : TGUID = '{9B496CE1-811B-11CF-8C77-00AA006B6814}';
  IID_IAMTimecodeGenerator : TGUID = '{9B496CE0-811B-11CF-8C77-00AA006B6814}';
  IID_IAMTimecodeDisplay : TGUID = '{9B496CE2-811B-11CF-8C77-00AA006B6814}';
  IID_IAMDevMemoryAllocator : TGUID = '{C6545BF0-E76B-11D0-BD52-00A0C911CE86}';
  IID_IAMDevMemoryControl : TGUID = '{C6545BF1-E76B-11D0-BD52-00A0C911CE86}';
  IID_IAMStreamSelect : TGUID = '{C1960960-17F5-11D1-ABE1-00A0C905F375}';
  IID_IAMovie : TGUID = '{359ACE10-7688-11CF-8B23-00805F6CEF60}';
  IID_ICreateDevEnum : TGUID = '{29840822-5B84-11D0-BD3B-00A0C911CE86}';
  IID_IDvdControl : TGUID = '{A70EFE61-E2A3-11D0-A9BE-00AA0061BE93}';
  IID_IDvdControl2 : TGUID = '{33BC7430-EEC0-11D2-8201-00A0C9D74842}';
  IID_IDvdInfo : TGUID = '{A70EFE60-E2A3-11D0-A9BE-00AA0061BE93}';
  IID_IDvdInfo2 : TGUID = '{34151510-EEC0-11D2-8201-00A0C9D74842}';
  IID_IDvdGraphBuilder : TGUID = '{FCC152B6-F372-11d0-8E00-00C04FD7C08B}';
  IID_IDvdState : TGUID = '{86303d6d-1c4a-4087-ab42-f711167048ef}';
  IID_IDvdCmd : TGUID = '{5a4a97e4-94ee-4a55-9751-74b5643aa27d}';
  IID_IVideoFrameStep : TGUID = '{e46a9787-2b71-444d-a4b5-1fab7b708d6a}';
  IID_IFilterMapper3 : TGUID = '{b79bb0b1-33c1-11d1-abe1-00a0c905f375}';
  IID_IOverlayNotify2 : TGUID = '{680EFA10-D535-11D1-87C8-00A0C9223196}';
  IID_ICaptureGraphBuilder2 : TGUID = '{93E5A4E0-2D50-11d2-ABFA-00A0C9C6E38D}';
  IID_IMemAllocatorCallbackTemp : TGUID = '{379a0cf0-c1de-11d2-abf5-00a0c905f375}';
  IID_IMemAllocatorNotifyCallbackTemp : TGUID = '{92980b30-c1de-11d2-abf5-00a0c905f375}';
  IID_IAMVideoControl : TGUID = '{6a2e0670-28e4-11d0-a18c-00a0c9118956}';
  IID_IKsPropertySet : TGUID = '{31EFAC30-515C-11d0-A9AA-00AA0061BE93}';
  IID_IAMResourceControl : TGUID = '{8389d2d0-77d7-11d1-abe6-00a0c905f375}';
  IID_IAMClockAdjust : TGUID = '{4d5466b0-a49c-11d1-abe8-00a0c905f375}';
  IID_IAMFilterMiscFlags : TGUID = '{2dd74950-a890-11d1-abe8-00a0c905f375}';
  IID_IDrawVideoImage : TGUID = '{48efb120-ab49-11d2-aed2-00a0c995e8d5}';
  IID_IDecimateVideoImage : TGUID = '{2e5ea3e0-e924-11d2-b6da-00a0c995e8df}';
  IID_IAMVideoDecimationProperties : TGUID = '{60d32930-13da-11d3-9ec6-c4fcaef5c7be}';
  IID_IAMLatency : TGUID = '{62EA93BA-EC62-11d2-B770-00C04FB6BD3D}';
  IID_IAMPushSource : TGUID = '{F185FE76-E64E-11d2-B76E-00C04FB6BD3D}';
  IID_IAMDeviceRemoval : TGUID = '{f90a6130-b658-11d2-ae49-0000f8754b99}';
  IID_IDVEnc : TGUID = '{d18e17a0-aacb-11d0-afb0-00aa00b67a42}';
  IID_IIPDVDec : TGUID = '{b8e8bd60-0bfe-11d0-af91-00aa00b67a42}';
  IID_IDVSplitter : TGUID = '{92a3a302-da7c-4a1f-ba7e-1802bb5d2d02}';
  IID_IAMAudioRendererStats : TGUID = '{22320CB2-D41A-11d2-BF7C-D7CB9DF0BF93}';
  IID_IAMGraphStreams : TGUID = '{632105FA-072E-11d3-8AF9-00C04FB6BD3D}';
  IID_IAMOverlayFX : TGUID = '{62fae250-7e65-4460-bfc9-6398b322073c}';
  IID_IAMOpenProgress : TGUID = '{8E1C39A1-DE53-11cf-AA63-0080C744528D}';
  IID_IMpeg2Demultiplexer : TGUID = '{436eee9c-264f-4242-90e1-4e330c107512}';
  IID_IEnumStreamIdMap : TGUID = '{945C1566-6202-46fc-96C7-D87F289C6534}';
  IID_IMPEG2StreamIdMap : TGUID = '{D0E04C47-25B8-4369-925A-362A01D95444}';
  IID_IDDrawExclModeVideo : TGUID = '{153ACC21-D83B-11d1-82BF-00A0C9696C8F}';
  IID_IDDrawExclModeVideoCallback : TGUID = '{913c24a0-20ab-11d2-9038-00a0c9697298}';
  IID_IPinConnection : TGUID = '{4a9a62d3-27d4-403d-91e9-89f540e55534}';
  IID_IPinFlowControl : TGUID = '{c56e9858-dbf3-4f6b-8119-384af2060deb}';
  IID_IGraphConfig : TGUID = '{03A1EB8E-32BF-4245-8502-114D08A9CB88}';
  IID_IGraphConfigCallback : TGUID = '{ade0fd60-d19d-11d2-abf6-00a0c905f375}';
  IID_IFilterChain : TGUID = '{DCFBDCF6-0DC2-45f5-9AB2-7C330EA09C29}';

const
  {media type constants}
  TAPIMEDIATYPE_AUDIO     = $00000008;
  TAPIMEDIATYPE_VIDEO     = $00008000;
  TAPIMEDIATYPE_DATAMODEM = $00000010;
  TAPIMEDIATYPE_G3FAX     = $00000020;

  {Line address type constants}
  LINEADDRESSTYPE_PHONENUMBER = $00000001;
  LINEADDRESSTYPE_SDP         = $00000002;
  LINEADDRESSTYPE_EMAILNAME   = $00000004;
  LINEADDRESSTYPE_DOMAINNAME  = $00000008;
  LINEADDRESSTYPE_IPADDRESS   = $00000010;

  {Line origin constants }
  LINECALLORIGIN_OUTBOUND     = $00000001;
  LINECALLORIGIN_INTERNAL     = $00000002;
  LINECALLORIGIN_EXTERNAL     = $00000004;
  LINECALLORIGIN_UNKNOWN      = $00000010;
  LINECALLORIGIN_UNAVAIL      = $00000020;
  LINECALLORIGIN_CONFERENCE   = $00000040;
  LINECALLORIGIN_INBOUND      = $00000080;

  {Line reason constants }
  LINECALLREASON_DIRECT           = $00000001;
  LINECALLREASON_FWDBUSY          = $00000002;
  LINECALLREASON_FWDNOANSWER      = $00000004;
  LINECALLREASON_FWDUNCOND        = $00000008;
  LINECALLREASON_PICKUP           = $00000010;
  LINECALLREASON_UNPARK           = $00000020;
  LINECALLREASON_REDIRECT         = $00000040;
  LINECALLREASON_CALLCOMPLETION   = $00000080;
  LINECALLREASON_TRANSFER         = $00000100;
  LINECALLREASON_REMINDER         = $00000200;
  LINECALLREASON_UNKNOWN          = $00000400;
  LINECALLREASON_UNAVAIL          = $00000800;
  LINECALLREASON_INTRUDE          = $00001000;
  LINECALLREASON_PARKED           = $00002000;
  LINECALLREASON_CAMPEDON         = $00004000;
  LINECALLREASON_ROUTEREQUEST     = $00008000;


  IID_IConnectionPointContainer : TGUID = '{B196B284-BAB4-101A-B69C-00AA00341D07}';
  CLSID_IBasicVideo : TGUID = '{56a868b5-0ad4-11ce-b03a-0020af0ba770}';

  CLSID_HandsetTerminal : TGUID      = '{AAF578EB-DC70-11d0-8ED3-00C04FB6809F}';
  CLSID_HeadsetTerminal : TGUID      = '{AAF578ED-DC70-11d0-8ED3-00C04FB6809F}';
  CLSID_MediaStreamTerminal : TGUID  = '{E2F7AEF7-4971-11D1-A671-006097C9A2E8}';
  CLSID_MicrophoneTerminal : TGUID   = '{AAF578EF-DC70-11d0-8ED3-00C04FB6809F}';
  CLSID_SpeakerphoneTerminal : TGUID = '{AAF578EE-DC70-11d0-8ED3-00C04FB6809F}';
  CLSID_SpeakersTerminal : TGUID     = '{AAF578F0-DC70-11d0-8ED3-00C04FB6809F}';
  CLSID_VideoInputTerminal : TGUID   = '{AAF578EC-DC70-11d0-8ED3-00C04FB6809F}';
  CLSID_VideoWindowTerm : TGUID      = '{F7438990-D6EB-11d0-82A6-00AA00B5CA1B}';

  CLSID_String_HandsetTerminal      = '{AAF578EB-DC70-11d0-8ED3-00C04FB6809F}';
  CLSID_String_HeadsetTerminal      = '{AAF578ED-DC70-11d0-8ED3-00C04FB6809F}';
  CLSID_String_MediaStreamTerminal  = '{E2F7AEF7-4971-11D1-A671-006097C9A2E8}';
  CLSID_String_MicrophoneTerminal   = '{AAF578EF-DC70-11d0-8ED3-00C04FB6809F}';
  CLSID_String_SpeakerphoneTerminal = '{AAF578EE-DC70-11d0-8ED3-00C04FB6809F}';
  CLSID_String_SpeakersTerminal     = '{AAF578F0-DC70-11d0-8ED3-00C04FB6809F}';
  CLSID_String_VideoInputTerminal   = '{AAF578EC-DC70-11d0-8ED3-00C04FB6809F}';
  CLSID_String_VideoWindowTerm      = '{F7438990-D6EB-11d0-82A6-00AA00B5CA1B}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library
// *********************************************************************//
// Constants for enum ADDRESS_STATE
type
  ADDRESS_STATE = TOleEnum;
const
  AS_INSERVICE    = $00000000;
  AS_OUTOFSERVICE = $00000001;

// Constants for enum CALLHUB_STATE
type
  CALLHUB_STATE = TOleEnum;
const
  CHS_ACTIVE = $00000000;
  CHS_IDLE   = $00000001;

// Constants for enum DISCONNECT_CODE
type
  DISCONNECT_CODE = TOleEnum;
const
  DC_NORMAL   = $00000000;
  DC_NOANSWER = $00000001;
  DC_REJECTED = $00000002;

// Constants for enum QOS_SERVICE_LEVEL
type
  QOS_SERVICE_LEVEL = TOleEnum;
const
  QSL_NEEDED       = $00000001;
  QSL_IF_AVAILABLE = $00000002;
  QSL_BEST_EFFORT  = $00000003;

// Constants for enum FINISH_MODE
type
  FINISH_MODE = TOleEnum;
const
  FM_ASTRANSFER   = $00000000;
  FM_ASCONFERENCE = $00000001;

// Constants for enum CALL_STATE
type
  CALL_STATE = TOleEnum;
const
  CS_IDLE         = $00000000;
  CS_INPROGRESS   = $00000001;
  CS_CONNECTED    = $00000002;
  CS_DISCONNECTED = $00000003;
  CS_OFFERING     = $00000004;
  CS_HOLD         = $00000005;
  CS_QUEUED       = $00000006;

// Constants for enum CALL_PRIVILEGE
type
  CALL_PRIVILEGE = TOleEnum;
const
  CP_OWNER        = $00000000;
  CP_MONITOR      = $00000001;

// Constants for enum CALLINFO_LONG
type
  CALLINFO_LONG = TOleEnum;
const
  CIL_MEDIATYPESAVAILABLE      = $00000000;
  CIL_BEARERMODE               = $00000001;
  CIL_CALLERIDADDRESSTYPE      = $00000002;
  CIL_CALLEDIDADDRESSTYPE      = $00000003;
  CIL_CONNECTEDIDADDRESSTYPE   = $00000004;
  CIL_REDIRECTIONIDADDRESSTYPE = $00000005;
  CIL_REDIRECTINGIDADDRESSTYPE = $00000006;
  CIL_ORIGIN                   = $00000007;
  CIL_REASON                   = $00000008;
  CIL_APPSPECIFIC              = $00000009;
  CIL_CALLPARAMSFLAGS          = $0000000A;
  CIL_CALLTREATMENT            = $0000000B;
  CIL_MINRATE                  = $0000000C;
  CIL_MAXRATE                  = $0000000D;
  CIL_COUNTRYCODE              = $0000000E;
  CIL_CALLID                   = $0000000F;
  CIL_RELATEDCALLID            = $00000010;
  CIL_COMPLETIONID             = $00000011;
  CIL_NUMBEROFOWNERS           = $00000012;
  CIL_NUMBEROFMONITORS         = $00000013;
  CIL_TRUNK                    = $00000014;
  CIL_RATE                     = $00000015;

// Constants for enum CALLINFO_STRING
type
  CALLINFO_STRING = TOleEnum;
const
  CIS_CALLERIDNAME            = $00000000;
  CIS_CALLERIDNUMBER          = $00000001;
  CIS_CALLEDIDNAME            = $00000002;
  CIS_CALLEDIDNUMBER          = $00000003;
  CIS_CONNECTEDIDNAME         = $00000004;
  CIS_CONNECTEDIDNUMBER       = $00000005;
  CIS_REDIRECTIONIDNAME       = $00000006;
  CIS_REDIRECTIONIDNUMBER     = $00000007;
  CIS_REDIRECTINGIDNAME       = $00000008;
  CIS_REDIRECTINGIDNUMBER     = $00000009;
  CIS_CALLEDPARTYFRIENDLYNAME = $0000000A;
  CIS_COMMENT                 = $0000000B;
  CIS_DISPLAYABLEADDRESS      = $0000000C;
  CIS_CALLINGPARTYID          = $0000000D;

// Constants for enum CALLINFO_BUFFER
type
  CALLINFO_BUFFER = TOleEnum;
const
  CIB_USERUSERINFO                 = $00000000;
  CIB_DEVSPECIFICBUFFER            = $00000001;
  CIB_CALLDATABUFFER               = $00000002;
  CIB_CHARGINGINFOBUFFER           = $00000003;
  CIB_HIGHLEVELCOMPATIBILITYBUFFER = $00000004;
  CIB_LOWLEVELCOMPATIBILITYBUFFER  = $00000005;

// Constants for enum CALL_STATE_EVENT_CAUSE
type
  CALL_STATE_EVENT_CAUSE = TOleEnum;
const
  CEC_NONE                  = $00000000;
  CEC_DISCONNECT_NORMAL     = $00000001;
  CEC_DISCONNECT_BUSY       = $00000002;
  CEC_DISCONNECT_BADADDRESS = $00000003;
  CEC_DISCONNECT_NOANSWER   = $00000004;
  CEC_DISCONNECT_CANCELLED  = $00000005;
  CEC_DISCONNECT_REJECTED   = $00000006;
  CEC_DISCONNECT_FAILED     = $00000007;

// Constants for enum CALL_NOTIFICATION_EVENT
type
  CALL_NOTIFICATION_EVENT = TOleEnum;
const
  CNE_OWNER   = $00000000;
  CNE_MONITOR = $00000001;

// Constants for enum TAPI_EVENT
type
  TAPI_EVENT = TOleEnum;
const
  TE_TAPIOBJECT       = $00000001;
  TE_ADDRESS          = $00000002;
  TE_CALLNOTIFICATION = $00000004;
  TE_CALLSTATE        = $00000008;
  TE_CALLMEDIA        = $00000010;
  TE_CALLHUB          = $00000020;
  TE_CALLINFOCHANGE   = $00000040;
  TE_PRIVATE          = $00000080;
  TE_REQUEST          = $00000100;
  TE_AGENT            = $00000200;
  TE_AGENTSESSION     = $00000400;
  TE_QOSEVENT         = $00000800;
  TE_AGENTHANDLER     = $00001000;
  TE_ACDGROUP         = $00002000;
  TE_QUEUE            = $00004000;
  TE_DIGITEVENT       = $00008000;
  TE_GENERATEEVENT    = $00010000;

// Constants for enum CALLHUB_EVENT
type
  CALLHUB_EVENT = TOleEnum;
const
  CHE_CALLJOIN    = $00000000;
  CHE_CALLLEAVE   = $00000001;
  CHE_CALLHUBNEW  = $00000002;
  CHE_CALLHUBIDLE = $00000003;

// Constants for enum ADDRESS_CAPABILITY
type
  ADDRESS_CAPABILITY = TOleEnum;
const
  AC_ADDRESSTYPES                 = $00000000;
  AC_BEARERMODES                  = $00000001;
  AC_MAXACTIVECALLS               = $00000002;
  AC_MAXONHOLDCALLS               = $00000003;
  AC_MAXONHOLDPENDINGCALLS        = $00000004;
  AC_MAXNUMCONFERENCE             = $00000005;
  AC_MAXNUMTRANSCONF              = $00000006;
  AC_MONITORDIGITSUPPORT          = $00000007;
  AC_GENERATEDIGITSUPPORT         = $00000008;
  AC_GENERATETONEMODES            = $00000009;
  AC_GENERATETONEMAXNUMFREQ       = $0000000A;
  AC_MONITORTONEMAXNUMFREQ        = $0000000B;
  AC_MONITORTONEMAXNUMENTRIES     = $0000000C;
  AC_DEVCAPFLAGS                  = $0000000D;
  AC_ANSWERMODES                  = $0000000E;
  AC_LINEFEATURES                 = $0000000F;
  AC_SETTABLEDEVSTATUS            = $00000010;
  AC_PARKSUPPORT                  = $00000011;
  AC_CALLERIDSUPPORT              = $00000012;
  AC_CALLEDIDSUPPORT              = $00000013;
  AC_CONNECTEDIDSUPPORT           = $00000014;
  AC_REDIRECTIONIDSUPPORT         = $00000015;
  AC_REDIRECTINGIDSUPPORT         = $00000016;
  AC_ADDRESSCAPFLAGS              = $00000017;
  AC_CALLFEATURES1                = $00000018;
  AC_CALLFEATURES2                = $00000019;
  AC_REMOVEFROMCONFCAPS           = $0000001A;
  AC_REMOVEFROMCONFSTATE          = $0000001B;
  AC_TRANSFERMODES                = $0000001C;
  AC_ADDRESSFEATURES              = $0000001D;
  AC_PREDICTIVEAUTOTRANSFERSTATES = $0000001E;
  AC_MAXCALLDATASIZE              = $0000001F;
  AC_LINEID                       = $00000020;
  AC_ADDRESSID                    = $00000021;
  AC_FORWARDMODES                 = $00000022;
  AC_MAXFORWARDENTRIES            = $00000023;
  AC_MAXSPECIFICENTRIES           = $00000024;
  AC_MINFWDNUMRINGS               = $00000025;
  AC_MAXFWDNUMRINGS               = $00000026;
  AC_MAXCALLCOMPLETIONS           = $00000027;
  AC_CALLCOMPLETIONCONDITIONS     = $00000028;
  AC_CALLCOMPLETIONMODES          = $00000029;
  AC_PERMANENTDEVICEID            = $0000002A;

// Constants for enum ADDRESS_CAPABILITY_STRING
type
  ADDRESS_CAPABILITY_STRING = TOleEnum;
const
  ACS_PROTOCOL              = $00000000;
  ACS_ADDRESSDEVICESPECIFIC = $00000001;
  ACS_LINEDEVICESPECIFIC    = $00000002;
  ACS_PROVIDERSPECIFIC      = $00000003;
  ACS_SWITCHSPECIFIC        = $00000004;
  ACS_PERMANENTDEVICEGUID   = $00000005;

// Constants for enum QOS_EVENT
type
  QOS_EVENT = TOleEnum;
const
  QE_NOQOS            = $00000001;
  QE_ADMISSIONFAILURE = $00000002;
  QE_POLICYFAILURE    = $00000003;
  QE_GENERICERROR     = $00000004;

// Constants for enum ADDRESS_EVENT
type
  ADDRESS_EVENT = TOleEnum;
const
  AE_STATE          = $00000000;
  AE_CAPSCHANGE     = $00000001;
  AE_RINGING        = $00000002;
  AE_CONFIGCHANGE   = $00000003;
  AE_FORWARD        = $00000004;
  AE_NEWTERMINAL    = $00000005;
  AE_REMOVETERMINAL = $00000006;

// Constants for enum TERMINAL_STATE
type
  TERMINAL_STATE = TOleEnum;
const
  TS_INUSE    = $00000000;
  TS_NOTINUSE = $00000001;

// Constants for enum TERMINAL_TYPE
type
  TERMINAL_TYPE = TOleEnum;
const
  TT_STATIC  = $00000000;
  TT_DYNAMIC = $00000001;

// Constants for enum TERMINAL_DIRECTION
type
  TERMINAL_DIRECTION = TOleEnum;
const
  TD_CAPTURE       = $00000000;
  TD_RENDER        = $00000001;
  TD_BIDIRECTIONAL = $00000002;

// Constants for enum CALL_MEDIA_EVENT
type
  CALL_MEDIA_EVENT = TOleEnum;
const
  CME_NEW_STREAM      = $00000000;
  CME_STREAM_FAIL     = $00000001;
  CME_TERMINAL_FAIL   = $00000002;
  CME_STREAM_NOT_USED = $00000003;
  CME_STREAM_ACTIVE   = $00000004;
  CME_STREAM_INACTIVE = $00000005;

// Constants for enum CALL_MEDIA_EVENT_CAUSE
type
  CALL_MEDIA_EVENT_CAUSE = TOleEnum;
const
  CMC_UNKNOWN         = $00000000;
  CMC_BAD_DEVICE      = $00000001;
  CMC_CONNECT_FAIL    = $00000002;
  CMC_LOCAL_REQUEST   = $00000003;
  CMC_REMOTE_REQUEST  = $00000004;
  CMC_MEDIA_TIMEOUT   = $00000005;
  CMC_MEDIA_RECOVERED = $00000006;

// Constants for enum TAPIOBJECT_EVENT
type
  TAPIOBJECT_EVENT = TOleEnum;
const
  TE_ADDRESSCREATE   = $00000000;
  TE_ADDRESSREMOVE   = $00000001;
  TE_REINIT          = $00000002;
  TE_TRANSLATECHANGE = $00000003;
  TE_ADDRESSCLOSE    = $00000004;

// Constants for enum AGENT_SESSION_STATE
type
  AGENT_SESSION_STATE = TOleEnum;
const
  ASST_NOT_READY     = $00000000;
  ASST_READY         = $00000001;
  ASST_BUSY_ON_CALL  = $00000002;
  ASST_BUSY_WRAPUP   = $00000003;
  ASST_SESSION_ENDED = $00000004;

// Constants for enum AGENT_STATE
type
  AGENT_STATE = TOleEnum;
const
  AS_NOT_READY     = $00000000;
  AS_READY         = $00000001;
  AS_BUSY_ACD      = $00000002;
  AS_BUSY_INCOMING = $00000003;
  AS_BUSY_OUTGOING = $00000004;
  AS_UNKNOWN       = $00000005;

// Constants for enum AGENT_EVENT
type
  AGENT_EVENT = TOleEnum;
const
  AE_NOT_READY     = $00000000;
  AE_READY         = $00000001;
  AE_BUSY_ACD      = $00000002;
  AE_BUSY_INCOMING = $00000003;
  AE_BUSY_OUTGOING = $00000004;
  AE_UNKNOWN       = $00000005;

// Constants for enum AGENT_SESSION_EVENT
type
  AGENT_SESSION_EVENT = TOleEnum;
const
  ASE_NEW_SESSION = $00000000;
  ASE_NOT_READY   = $00000001;
  ASE_READY       = $00000002;
  ASE_BUSY        = $00000003;
  ASE_WRAPUP      = $00000004;
  ASE_END         = $00000005;

// Constants for enum ACDGROUP_EVENT
type
  ACDGROUP_EVENT = TOleEnum;
const
  ACDGE_NEW_GROUP     = $00000000;
  ACDGE_GROUP_REMOVED = $00000001;

// Constants for enum ACDQUEUE_EVENT
type
  ACDQUEUE_EVENT = TOleEnum;
const
  ACDQE_NEW_QUEUE     = $00000000;
  ACDQE_QUEUE_REMOVED = $00000001;

// Constants for enum AGENTHANDLER_EVENT
type
  AGENTHANDLER_EVENT = TOleEnum;
const
  AHE_NEW_AGENTHANDLER     = $00000000;
  AHE_AGENTHANDLER_REMOVED = $00000001;

// Constants for enum CALLINFOCHANGE_CAUSE
type
  CALLINFOCHANGE_CAUSE = TOleEnum;
const
  CIC_OTHER         = $00000000;
  CIC_DEVSPECIFIC   = $00000001;
  CIC_BEARERMODE    = $00000002;
  CIC_RATE          = $00000003;
  CIC_APPSPECIFIC   = $00000004;
  CIC_CALLID        = $00000005;
  CIC_RELATEDCALLID = $00000006;
  CIC_ORIGIN        = $00000007;
  CIC_REASON        = $00000008;
  CIC_COMPLETIONID  = $00000009;
  CIC_NUMOWNERINCR  = $0000000A;
  CIC_NUMOWNERDECR  = $0000000B;
  CIC_NUMMONITORS   = $0000000C;
  CIC_TRUNK         = $0000000D;
  CIC_CALLERID      = $0000000E;
  CIC_CALLEDID      = $0000000F;
  CIC_CONNECTEDID   = $00000010;
  CIC_REDIRECTIONID = $00000011;
  CIC_REDIRECTINGID = $00000012;
  CIC_USERUSERINFO  = $00000013;
  CIC_HIGHLEVELCOMP = $00000014;
  CIC_LOWLEVELCOMP  = $00000015;
  CIC_CHARGINGINFO  = $00000016;
  CIC_TREATMENT     = $00000017;
  CIC_CALLDATA      = $00000018;
  CIC_PRIVILEGE     = $00000019;
  CIC_MEDIATYPE     = $0000001A;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary
// *********************************************************************//
  ITCollection = interface;
  ITCollectionDisp = dispinterface;
  ITCallStateEvent = interface;
  ITCallStateEventDisp = dispinterface;
  ITCallInfo = interface;
  ITCallInfoDisp = dispinterface;
  ITAddress = interface;
  ITAddressDisp = dispinterface;
  ITTAPI = interface;
  ITTAPIDisp = dispinterface;
  IEnumAddress = interface;
  IEnumCallHub = interface;
  ITCallHub = interface;
  ITCallHubDisp = dispinterface;
  IEnumCall = interface;
  IEnumUnknown = interface;
  ITBasicCallControl = interface;
  ITBasicCallControlDisp = dispinterface;
  ITForwardInformation = interface;
  ITForwardInformationDisp = dispinterface;
  ITCallNotificationEvent = interface;
  ITCallNotificationEventDisp = dispinterface;
  ITTAPIEventNotification = interface;
  ITBasicAudioTerminal = interface;
  ITBasicAudioTerminalDisp = dispinterface;
  ITCallHubEvent = interface;
  ITAddressCapabilities = interface;
  ITAddressCapabilitiesDisp = dispinterface;
  IEnumBstr = interface;
  ITQOSEvent = interface;
  ITAddressEvent = interface;
  ITTerminal = interface;
  ITTerminalDisp = dispinterface;
  ITCallMediaEvent = interface;
  ITCallMediaEventDisp = dispinterface;
  ITStream = interface;
  ITStreamDisp = dispinterface;
  IEnumTerminal = interface;
  ITTAPIObjectEvent = interface;
  ITTAPIObjectEventDisp = dispinterface;
  ITAddressTranslation = interface;
  ITAddressTranslationDisp = dispinterface;
  ITAddressTranslationInfo = interface;
  ITAddressTranslationInfoDisp = dispinterface;
  IEnumLocation = interface;
  ITLocationInfo = interface;
  ITLocationInfoDisp = dispinterface;
  IEnumCallingCard = interface;
  ITCallingCard = interface;
  ITCallingCardDisp = dispinterface;
  ITAgent = interface;
  ITAgentDisp = dispinterface;
  IEnumAgentSession = interface;
  ITAgentSession = interface;
  ITAgentSessionDisp = dispinterface;
  ITACDGroup = interface;
  ITACDGroupDisp = dispinterface;
  IEnumQueue = interface;
  ITQueue = interface;
  ITQueueDisp = dispinterface;
  ITAgentEvent = interface;
  ITAgentEventDisp = dispinterface;
  ITAgentSessionEvent = interface;
  ITAgentSessionEventDisp = dispinterface;
  ITACDGroupEvent = interface;
  ITACDGroupEventDisp = dispinterface;
  ITQueueEvent = interface;
  ITQueueEventDisp = dispinterface;
  ITTAPICallCenter = interface;
  ITTAPICallCenterDisp = dispinterface;
  IEnumAgentHandler = interface;
  ITAgentHandler = interface;
  ITAgentHandlerDisp = dispinterface;
  IEnumACDGroup = interface;
  ITAgentHandlerEvent = interface;
  ITAgentHandlerEventDisp = dispinterface;
  ITCallInfoChangeEvent = interface;
  ITRequestEvent = interface;
  ITMediaSupport = interface;
  ITMediaSupportDisp = dispinterface;
  ITTerminalSupport = interface;
  ITTerminalSupportDisp = dispinterface;
  IEnumTerminalClass = interface;
  ITStreamControl = interface;
  ITStreamControlDisp = dispinterface;
  IEnumStream = interface;
  ITSubStreamControl = interface;
  ITSubStreamControlDisp = dispinterface;
  ITSubStream = interface;
  ITSubStreamDisp = dispinterface;
  IEnumSubStream = interface;
  ITLegacyAddressMediaControl = interface;
  ITLegacyCallMediaControl = interface;
  ITDigitDetectionEvent = interface;
  ITDigitGenerationEvent = interface;
  ITDigitGenerationEventDisp = dispinterface;
  ITPrivateEvent = interface;
  ITPrivateEventDisp = dispinterface;
  ITTAPIDispatchEventNotification = dispinterface;
  ITDispatchMapper = interface;
  ITRequest = interface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library
// (NOTE: Here we map each CoClass to its Default Interface)
// *********************************************************************//
  TAPI = ITTAPI;
  DispatchMapper = ITDispatchMapper;
  RequestMakeCall = ITRequest;

// *********************************************************************//
// Declaration of structures, unions and aliases.
// *********************************************************************//
  PByte1 = ^Byte; {*}

// *********************************************************************//
// Interface: ITCollection
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5EC5ACF2-9C02-11D0-8362-00AA003CCABD}
// *********************************************************************//
  ITCollection = interface(IDispatch)
    ['{5EC5ACF2-9C02-11D0-8362-00AA003CCABD}']
    function  Get_Count: Integer; safecall;
    function  Get_Item(Index: Integer): OleVariant; safecall;
    function  Get__NewEnum: IUnknown; safecall;
    property Count: Integer read Get_Count;
    property Item[Index: Integer]: OleVariant read Get_Item; default;
    property _NewEnum: IUnknown read Get__NewEnum;
  end;

// *********************************************************************//
// DispIntf:  ITCollectionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5EC5ACF2-9C02-11D0-8362-00AA003CCABD}
// *********************************************************************//
  ITCollectionDisp = dispinterface
    ['{5EC5ACF2-9C02-11D0-8362-00AA003CCABD}']
    property Count: Integer readonly dispid 1610743808;
    property Item[Index: Integer]: OleVariant readonly dispid 0; default;
    property _NewEnum: IUnknown readonly dispid -4;
  end;

// *********************************************************************//
// Interface: ITCallStateEvent
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {62F47097-95C9-11D0-835D-00AA003CCABD}
// *********************************************************************//
  ITCallStateEvent = interface(IDispatch)
    ['{62F47097-95C9-11D0-835D-00AA003CCABD}']
    function  Get_Call: ITCallInfo; safecall;
    function  Get_State: CALL_STATE; safecall;
    function  Get_Cause: CALL_STATE_EVENT_CAUSE; safecall;
    function  Get_CallbackInstance: Integer; safecall;
    property Call: ITCallInfo read Get_Call;
    property State: CALL_STATE read Get_State;
    property Cause: CALL_STATE_EVENT_CAUSE read Get_Cause;
    property CallbackInstance: Integer read Get_CallbackInstance;
  end;

// *********************************************************************//
// DispIntf:  ITCallStateEventDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {62F47097-95C9-11D0-835D-00AA003CCABD}
// *********************************************************************//
  ITCallStateEventDisp = dispinterface
    ['{62F47097-95C9-11D0-835D-00AA003CCABD}']
    property Call: ITCallInfo readonly dispid 1;
    property State: CALL_STATE readonly dispid 2;
    property Cause: CALL_STATE_EVENT_CAUSE readonly dispid 3;
    property CallbackInstance: Integer readonly dispid 4;
  end;

// *********************************************************************//
// Interface: ITCallInfo
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {350F85D1-1227-11D3-83D4-00C04FB6809F}
// *********************************************************************//
  ITCallInfo = interface(IDispatch)
    ['{350F85D1-1227-11D3-83D4-00C04FB6809F}']
    function  Get_Address: ITAddress; safecall;
    function  Get_CallState: CALL_STATE; safecall;
    function  Get_Privilege: CALL_PRIVILEGE; safecall;
    function  Get_CallHub: ITCallHub; safecall;
    function  Get_CallInfoLong(CallInfoLong: CALLINFO_LONG): Integer; safecall;
    procedure Set_CallInfoLong(CallInfoLong: CALLINFO_LONG; plCallInfoLongVal: Integer); safecall;
    function  Get_CallInfoString(CallInfoString: CALLINFO_STRING): WideString; safecall;
    procedure Set_CallInfoString(CallInfoString: CALLINFO_STRING; const ppCallInfoString: WideString); safecall;
    function  Get_CallInfoBuffer(CallInfoBuffer: CALLINFO_BUFFER): OleVariant; safecall;
    procedure Set_CallInfoBuffer(CallInfoBuffer: CALLINFO_BUFFER; ppCallInfoBuffer: OleVariant); safecall;
    procedure GetCallInfoBuffer(CallInfoBuffer: CALLINFO_BUFFER; out pdwSize: DWORD;
                                out ppCallInfoBuffer: PByte1); safecall;
    procedure SetCallInfoBuffer(CallInfoBuffer: CALLINFO_BUFFER; dwSize: DWORD;
                                var pCallInfoBuffer: Byte); safecall;
    procedure ReleaseUserUserInfo; safecall;
    property Address: ITAddress read Get_Address;
    property CallState: CALL_STATE read Get_CallState;
    property Privilege: CALL_PRIVILEGE read Get_Privilege;
    property CallHub: ITCallHub read Get_CallHub;
    property CallInfoLong[CallInfoLong: CALLINFO_LONG]: Integer read Get_CallInfoLong write Set_CallInfoLong;
    property CallInfoString[CallInfoString: CALLINFO_STRING]: WideString read Get_CallInfoString write Set_CallInfoString;
    property CallInfoBuffer[CallInfoBuffer: CALLINFO_BUFFER]: OleVariant read Get_CallInfoBuffer write Set_CallInfoBuffer;
  end;

// *********************************************************************//
// DispIntf:  ITCallInfoDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {350F85D1-1227-11D3-83D4-00C04FB6809F}
// *********************************************************************//
  ITCallInfoDisp = dispinterface
    ['{350F85D1-1227-11D3-83D4-00C04FB6809F}']
    property Address: ITAddress readonly dispid 65537;
    property CallState: CALL_STATE readonly dispid 65538;
    property Privilege: CALL_PRIVILEGE readonly dispid 65539;
    property CallHub: ITCallHub readonly dispid 65540;
    property CallInfoLong[CallInfoLong: CALLINFO_LONG]: Integer dispid 65541;
    property CallInfoString[CallInfoString: CALLINFO_STRING]: WideString dispid 65542;
    property CallInfoBuffer[CallInfoBuffer: CALLINFO_BUFFER]: OleVariant dispid 65543;
    procedure GetCallInfoBuffer(CallInfoBuffer: CALLINFO_BUFFER; out pdwSize: DWORD;
                                out ppCallInfoBuffer: {??PByte1}OleVariant); dispid 65544;
    procedure SetCallInfoBuffer(CallInfoBuffer: CALLINFO_BUFFER; dwSize: DWORD;
                                var pCallInfoBuffer: Byte); dispid 65545;
    procedure ReleaseUserUserInfo; dispid 65546;
  end;

// *********************************************************************//
// Interface: ITAddress
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B1EFC386-9355-11D0-835C-00AA003CCABD}
// *********************************************************************//
  ITAddress = interface(IDispatch)
    ['{B1EFC386-9355-11D0-835C-00AA003CCABD}']
    function  Get_State: ADDRESS_STATE; safecall;
    function  Get_AddressName: WideString; safecall;
    function  Get_ServiceProviderName: WideString; safecall;
    function  Get_TAPIObject: ITTAPI; safecall;
    function  CreateCall(const pDestAddress: WideString; lAddressType: Integer; lMediaTypes: Integer): ITBasicCallControl; safecall;
    function  Get_Calls: OleVariant; safecall;
    function  EnumerateCalls: IEnumCall; safecall;
    function  Get_DialableAddress: WideString; safecall;
    function  CreateForwardInfoObject: ITForwardInformation; safecall;
    procedure Forward(const pForwardInfo: ITForwardInformation; const pCall: ITBasicCallControl); safecall;
    function  Get_CurrentForwardInfo: ITForwardInformation; safecall;
    procedure Set_MessageWaiting(pfMessageWaiting: WordBool); safecall;
    function  Get_MessageWaiting: WordBool; safecall;
    procedure Set_DoNotDisturb(pfDoNotDisturb: WordBool); safecall;
    function  Get_DoNotDisturb: WordBool; safecall;
    property State: ADDRESS_STATE read Get_State;
    property AddressName: WideString read Get_AddressName;
    property ServiceProviderName: WideString read Get_ServiceProviderName;
    property TAPIObject: ITTAPI read Get_TAPIObject;
    property Calls: OleVariant read Get_Calls;
    property DialableAddress: WideString read Get_DialableAddress;
    property CurrentForwardInfo: ITForwardInformation read Get_CurrentForwardInfo;
    property MessageWaiting: WordBool read Get_MessageWaiting write Set_MessageWaiting;
    property DoNotDisturb: WordBool read Get_DoNotDisturb write Set_DoNotDisturb;
  end;

// *********************************************************************//
// DispIntf:  ITAddressDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B1EFC386-9355-11D0-835C-00AA003CCABD}
// *********************************************************************//
  ITAddressDisp = dispinterface
    ['{B1EFC386-9355-11D0-835C-00AA003CCABD}']
    property State: ADDRESS_STATE readonly dispid 65537;
    property AddressName: WideString readonly dispid 65538;
    property ServiceProviderName: WideString readonly dispid 65539;
    property TAPIObject: ITTAPI readonly dispid 65540;
    function  CreateCall(const pDestAddress: WideString; lAddressType: Integer; lMediaTypes: Integer): ITBasicCallControl; dispid 65541;
    property Calls: OleVariant readonly dispid 65542;
    function  EnumerateCalls: IEnumCall; dispid 65543;
    property DialableAddress: WideString readonly dispid 65544;
    function  CreateForwardInfoObject: ITForwardInformation; dispid 65546;
    procedure Forward(const pForwardInfo: ITForwardInformation; const pCall: ITBasicCallControl); dispid 65547;
    property CurrentForwardInfo: ITForwardInformation readonly dispid 65548;
    property MessageWaiting: WordBool dispid 65550;
    property DoNotDisturb: WordBool dispid 65551;
  end;

// *********************************************************************//
// Interface: ITTAPI
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B1EFC382-9355-11D0-835C-00AA003CCABD}
// *********************************************************************//
  ITTAPI = interface(IDispatch)
    ['{B1EFC382-9355-11D0-835C-00AA003CCABD}']
    procedure Initialize; safecall;
    procedure Shutdown; safecall;
    function  Get_Addresses: OleVariant; safecall;
    function  EnumerateAddresses: IEnumAddress; safecall;
    function  RegisterCallNotifications(const pAddress: ITAddress; fMonitor: WordBool;
                                        fOwner: WordBool; lMediaTypes: Integer;
                                        lCallbackInstance: Integer): Integer; safecall;
    procedure UnregisterNotifications(lRegister: Integer); safecall;
    function  Get_CallHubs: OleVariant; safecall;
    function  EnumerateCallHubs: IEnumCallHub; safecall;
    procedure SetCallHubTracking(pAddresses: OleVariant; bTracking: WordBool); safecall;
    procedure EnumeratePrivateTAPIObjects(out ppEnumUnknown: IEnumUnknown); safecall;
    function  Get_PrivateTAPIObjects: OleVariant; safecall;
    procedure RegisterRequestRecipient(lRegistrationInstance: Integer; lRequestMode: Integer;
                                       fEnable: WordBool); safecall;
    procedure SetAssistedTelephonyPriority(const pAppFilename: WideString; fPriority: WordBool); safecall;
    procedure SetApplicationPriority(const pAppFilename: WideString; lMediaType: Integer;
                                     fPriority: WordBool); safecall;
    procedure Set_EventFilter(plFilterMask: Integer); safecall;
    function  Get_EventFilter: Integer; safecall;
    property Addresses: OleVariant read Get_Addresses;
    property CallHubs: OleVariant read Get_CallHubs;
    property PrivateTAPIObjects: OleVariant read Get_PrivateTAPIObjects;
    property EventFilter: Integer read Get_EventFilter write Set_EventFilter;
  end;

// *********************************************************************//
// DispIntf:  ITTAPIDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B1EFC382-9355-11D0-835C-00AA003CCABD}
// *********************************************************************//
  ITTAPIDisp = dispinterface
    ['{B1EFC382-9355-11D0-835C-00AA003CCABD}']
    procedure Initialize; dispid 65549;
    procedure Shutdown; dispid 65550;
    property Addresses: OleVariant readonly dispid 65537;
    function  EnumerateAddresses: IEnumAddress; dispid 65538;
    function  RegisterCallNotifications(const pAddress: ITAddress; fMonitor: WordBool;
                                        fOwner: WordBool; lMediaTypes: Integer;
                                        lCallbackInstance: Integer): Integer; dispid 65539;
    procedure UnregisterNotifications(lRegister: Integer); dispid 65540;
    property CallHubs: OleVariant readonly dispid 65541;
    function  EnumerateCallHubs: IEnumCallHub; dispid 65542;
    procedure SetCallHubTracking(pAddresses: OleVariant; bTracking: WordBool); dispid 65543;
    procedure EnumeratePrivateTAPIObjects(out ppEnumUnknown: IEnumUnknown); dispid 65544;
    property PrivateTAPIObjects: OleVariant readonly dispid 65545;
    procedure RegisterRequestRecipient(lRegistrationInstance: Integer; lRequestMode: Integer;
                                       fEnable: WordBool); dispid 65546;
    procedure SetAssistedTelephonyPriority(const pAppFilename: WideString; fPriority: WordBool); dispid 65547;
    procedure SetApplicationPriority(const pAppFilename: WideString; lMediaType: Integer;
                                     fPriority: WordBool); dispid 65548;
    property EventFilter: Integer dispid 65551;
  end;

// *********************************************************************//
// Interface: IEnumAddress
// Flags:     (16) Hidden
// GUID:      {1666FCA1-9363-11D0-835C-00AA003CCABD}
// *********************************************************************//
  IEnumAddress = interface(IUnknown)
    ['{1666FCA1-9363-11D0-835C-00AA003CCABD}']
    function  Next(celt: DWORD; out ppElements: ITAddress; var pceltFetched: DWORD): HResult; stdcall;
    function  Reset: HResult; stdcall;
    function  Skip(celt: DWORD): HResult; stdcall;
    function  Clone(out ppEnum: IEnumAddress): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IEnumCallHub
// Flags:     (16) Hidden
// GUID:      {A3C15450-5B92-11D1-8F4E-00C04FB6809F}
// *********************************************************************//
  IEnumCallHub = interface(IUnknown)
    ['{A3C15450-5B92-11D1-8F4E-00C04FB6809F}']
    function  Next(celt: DWORD; out ppElements: ITCallHub; var pceltFetched: DWORD): HResult; stdcall;
    function  Reset: HResult; stdcall;
    function  Skip(celt: DWORD): HResult; stdcall;
    function  Clone(out ppEnum: IEnumCallHub): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ITCallHub
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A3C1544E-5B92-11D1-8F4E-00C04FB6809F}
// *********************************************************************//
  ITCallHub = interface(IDispatch)
    ['{A3C1544E-5B92-11D1-8F4E-00C04FB6809F}']
    procedure Clear; safecall;
    function  EnumerateCalls: IEnumCall; safecall;
    function  Get_Calls: OleVariant; safecall;
    function  Get_NumCalls: Integer; safecall;
    function  Get_State: CALLHUB_STATE; safecall;
    property Calls: OleVariant read Get_Calls;
    property NumCalls: Integer read Get_NumCalls;
    property State: CALLHUB_STATE read Get_State;
  end;

// *********************************************************************//
// DispIntf:  ITCallHubDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A3C1544E-5B92-11D1-8F4E-00C04FB6809F}
// *********************************************************************//
  ITCallHubDisp = dispinterface
    ['{A3C1544E-5B92-11D1-8F4E-00C04FB6809F}']
    procedure Clear; dispid 1;
    function  EnumerateCalls: IEnumCall; dispid 2;
    property Calls: OleVariant readonly dispid 3;
    property NumCalls: Integer readonly dispid 4;
    property State: CALLHUB_STATE readonly dispid 5;
  end;

// *********************************************************************//
// Interface: IEnumCall
// Flags:     (16) Hidden
// GUID:      {AE269CF6-935E-11D0-835C-00AA003CCABD}
// *********************************************************************//
  IEnumCall = interface(IUnknown)
    ['{AE269CF6-935E-11D0-835C-00AA003CCABD}']
    function  Next(celt: DWORD; out ppElements: ITCallInfo; var pceltFetched: DWORD): HResult; stdcall;
    function  Reset: HResult; stdcall;
    function  Skip(celt: DWORD): HResult; stdcall;
    function  Clone(out ppEnum: IEnumCall): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IEnumUnknown
// Flags:     (0)
// GUID:      {00000100-0000-0000-C000-000000000046}
// *********************************************************************//
  IEnumUnknown = interface(IUnknown)
    ['{00000100-0000-0000-C000-000000000046}']
    function  RemoteNext(celt: DWORD; out rgelt: IUnknown; out pceltFetched: DWORD): HResult; stdcall;
    function  Skip(celt: DWORD): HResult; stdcall;
    function  Reset: HResult; stdcall;
    function  Clone(out ppEnum: IEnumUnknown): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ITBasicCallControl
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B1EFC389-9355-11D0-835C-00AA003CCABD}
// *********************************************************************//
  ITBasicCallControl = interface(IDispatch)
    ['{B1EFC389-9355-11D0-835C-00AA003CCABD}']
    procedure Connect(fSync: WordBool); safecall;
    procedure Answer; safecall;
    procedure Disconnect(code: DISCONNECT_CODE); safecall;
    procedure Hold(fHold: WordBool); safecall;
    procedure HandoffDirect(const pApplicationName: WideString); safecall;
    procedure HandoffIndirect(lMediaType: Integer); safecall;
    procedure Conference(const pCall: ITBasicCallControl; fSync: WordBool); safecall;
    procedure Transfer(const pCall: ITBasicCallControl; fSync: WordBool); safecall;
    procedure BlindTransfer(const pDestAddress: WideString); safecall;
    procedure SwapHold(const pCall: ITBasicCallControl); safecall;
    procedure ParkDirect(const pParkAddress: WideString); safecall;
    function  ParkIndirect: WideString; safecall;
    procedure Unpark; safecall;
    procedure SetQOS(lMediaType: Integer; ServiceLevel: QOS_SERVICE_LEVEL); safecall;
    procedure Pickup(const pGroupID: WideString); safecall;
    procedure Dial(const pDestAddress: WideString); safecall;
    procedure Finish(finishMode: FINISH_MODE); safecall;
    procedure RemoveFromConference; safecall;
  end;

// *********************************************************************//
// DispIntf:  ITBasicCallControlDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B1EFC389-9355-11D0-835C-00AA003CCABD}
// *********************************************************************//
  ITBasicCallControlDisp = dispinterface
    ['{B1EFC389-9355-11D0-835C-00AA003CCABD}']
    procedure Connect(fSync: WordBool); dispid 131075;
    procedure Answer; dispid 131076;
    procedure Disconnect(code: DISCONNECT_CODE); dispid 131077;
    procedure Hold(fHold: WordBool); dispid 131078;
    procedure HandoffDirect(const pApplicationName: WideString); dispid 131079;
    procedure HandoffIndirect(lMediaType: Integer); dispid 131080;
    procedure Conference(const pCall: ITBasicCallControl; fSync: WordBool); dispid 131081;
    procedure Transfer(const pCall: ITBasicCallControl; fSync: WordBool); dispid 131082;
    procedure BlindTransfer(const pDestAddress: WideString); dispid 131083;
    procedure SwapHold(const pCall: ITBasicCallControl); dispid 131084;
    procedure ParkDirect(const pParkAddress: WideString); dispid 131085;
    function  ParkIndirect: WideString; dispid 131086;
    procedure Unpark; dispid 131087;
    procedure SetQOS(lMediaType: Integer; ServiceLevel: QOS_SERVICE_LEVEL); dispid 131088;
    procedure Pickup(const pGroupID: WideString); dispid 131091;
    procedure Dial(const pDestAddress: WideString); dispid 131092;
    procedure Finish(finishMode: FINISH_MODE); dispid 131093;
    procedure RemoveFromConference; dispid 131094;
  end;

// *********************************************************************//
// Interface: ITForwardInformation
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {449F659E-88A3-11D1-BB5D-00C04FB6809F}
// *********************************************************************//
  ITForwardInformation = interface(IDispatch)
    ['{449F659E-88A3-11D1-BB5D-00C04FB6809F}']
    procedure Set_NumRingsNoAnswer(plNumRings: Integer); safecall;
    function  Get_NumRingsNoAnswer: Integer; safecall;
    procedure SetForwardType(ForwardType: Integer; const pDestAddress: WideString;
                             const pCallerAddress: WideString); safecall;
    function  Get_ForwardTypeDestination(ForwardType: Integer): WideString; safecall;
    function  Get_ForwardTypeCaller(ForwardType: Integer): WideString; safecall;
    procedure GetForwardType(ForwardType: Integer; out ppDestinationAddress: WideString;
                             out ppCallerAddress: WideString); safecall;
    procedure Clear; safecall;
    property NumRingsNoAnswer: Integer read Get_NumRingsNoAnswer write Set_NumRingsNoAnswer;
    property ForwardTypeDestination[ForwardType: Integer]: WideString read Get_ForwardTypeDestination;
    property ForwardTypeCaller[ForwardType: Integer]: WideString read Get_ForwardTypeCaller;
  end;

// *********************************************************************//
// DispIntf:  ITForwardInformationDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {449F659E-88A3-11D1-BB5D-00C04FB6809F}
// *********************************************************************//
  ITForwardInformationDisp = dispinterface
    ['{449F659E-88A3-11D1-BB5D-00C04FB6809F}']
    property NumRingsNoAnswer: Integer dispid 1;
    procedure SetForwardType(ForwardType: Integer; const pDestAddress: WideString;
                             const pCallerAddress: WideString); dispid 2;
    property ForwardTypeDestination[ForwardType: Integer]: WideString readonly dispid 3;
    property ForwardTypeCaller[ForwardType: Integer]: WideString readonly dispid 4;
    procedure GetForwardType(ForwardType: Integer; out ppDestinationAddress: WideString;
                             out ppCallerAddress: WideString); dispid 5;
    procedure Clear; dispid 6;
  end;

// *********************************************************************//
// Interface: ITCallNotificationEvent
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {895801DF-3DD6-11D1-8F30-00C04FB6809F}
// *********************************************************************//
  ITCallNotificationEvent = interface(IDispatch)
    ['{895801DF-3DD6-11D1-8F30-00C04FB6809F}']
    function  Get_Call: ITCallInfo; safecall;
    function  Get_Event: CALL_NOTIFICATION_EVENT; safecall;
    function  Get_CallbackInstance: Integer; safecall;
    property Call: ITCallInfo read Get_Call;
    property Event: CALL_NOTIFICATION_EVENT read Get_Event;
    property CallbackInstance: Integer read Get_CallbackInstance;
  end;

// *********************************************************************//
// DispIntf:  ITCallNotificationEventDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {895801DF-3DD6-11D1-8F30-00C04FB6809F}
// *********************************************************************//
  ITCallNotificationEventDisp = dispinterface
    ['{895801DF-3DD6-11D1-8F30-00C04FB6809F}']
    property Call: ITCallInfo readonly dispid 1;
    property Event: CALL_NOTIFICATION_EVENT readonly dispid 2;
    property CallbackInstance: Integer readonly dispid 3;
  end;

// *********************************************************************//
// Interface: ITTAPIEventNotification
// Flags:     (256) OleAutomation
// GUID:      {EDDB9426-3B91-11D1-8F30-00C04FB6809F}
// *********************************************************************//
  ITTAPIEventNotification = interface(IUnknown)
    ['{EDDB9426-3B91-11D1-8F30-00C04FB6809F}']
    function  Event(TapiEvent: TAPI_EVENT; const pEvent: IDispatch): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ITBasicAudioTerminal
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B1EFC38D-9355-11D0-835C-00AA003CCABD}
// *********************************************************************//
  ITBasicAudioTerminal = interface(IDispatch)
    ['{B1EFC38D-9355-11D0-835C-00AA003CCABD}']
    procedure Set_Volume(plVolume: Integer); safecall;
    function  Get_Volume: Integer; safecall;
    procedure Set_Balance(plBalance: Integer); safecall;
    function  Get_Balance: Integer; safecall;
    property Volume: Integer read Get_Volume write Set_Volume;
    property Balance: Integer read Get_Balance write Set_Balance;
  end;

// *********************************************************************//
// DispIntf:  ITBasicAudioTerminalDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B1EFC38D-9355-11D0-835C-00AA003CCABD}
// *********************************************************************//
  ITBasicAudioTerminalDisp = dispinterface
    ['{B1EFC38D-9355-11D0-835C-00AA003CCABD}']
    property Volume: Integer dispid 1;
    property Balance: Integer dispid 2;
  end;

// *********************************************************************//
// Interface: ITCallHubEvent
// Flags:     (4352) OleAutomation Dispatchable
// GUID:      {A3C15451-5B92-11D1-8F4E-00C04FB6809F}
// *********************************************************************//
  ITCallHubEvent = interface(IDispatch)
    ['{A3C15451-5B92-11D1-8F4E-00C04FB6809F}']
    function  Get_Event(out pEvent: CALLHUB_EVENT): HResult; stdcall;
    function  Get_CallHub(out ppCallHub: ITCallHub): HResult; stdcall;
    function  Get_Call(out ppCall: ITCallInfo): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ITAddressCapabilities
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8DF232F5-821B-11D1-BB5C-00C04FB6809F}
// *********************************************************************//
  ITAddressCapabilities = interface(IDispatch)
    ['{8DF232F5-821B-11D1-BB5C-00C04FB6809F}']
    function  Get_AddressCapability(AddressCap: ADDRESS_CAPABILITY): Integer; safecall;
    function  Get_AddressCapabilityString(AddressCapString: ADDRESS_CAPABILITY_STRING): WideString; safecall;
    function  Get_CallTreatments: OleVariant; safecall;
    function  EnumerateCallTreatments: IEnumBstr; safecall;
    function  Get_CompletionMessages: OleVariant; safecall;
    function  EnumerateCompletionMessages: IEnumBstr; safecall;
    function  Get_DeviceClasses: OleVariant; safecall;
    function  EnumerateDeviceClasses: IEnumBstr; safecall;
    property AddressCapability[AddressCap: ADDRESS_CAPABILITY]: Integer read Get_AddressCapability;
    property AddressCapabilityString[AddressCapString: ADDRESS_CAPABILITY_STRING]: WideString read Get_AddressCapabilityString;
    property CallTreatments: OleVariant read Get_CallTreatments;
    property CompletionMessages: OleVariant read Get_CompletionMessages;
    property DeviceClasses: OleVariant read Get_DeviceClasses;
  end;

// *********************************************************************//
// DispIntf:  ITAddressCapabilitiesDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8DF232F5-821B-11D1-BB5C-00C04FB6809F}
// *********************************************************************//
  ITAddressCapabilitiesDisp = dispinterface
    ['{8DF232F5-821B-11D1-BB5C-00C04FB6809F}']
    property AddressCapability[AddressCap: ADDRESS_CAPABILITY]: Integer readonly dispid 131073;
    property AddressCapabilityString[AddressCapString: ADDRESS_CAPABILITY_STRING]: WideString readonly dispid 131074;
    property CallTreatments: OleVariant readonly dispid 131075;
    function  EnumerateCallTreatments: IEnumBstr; dispid 131076;
    property CompletionMessages: OleVariant readonly dispid 131077;
    function  EnumerateCompletionMessages: IEnumBstr; dispid 131078;
    property DeviceClasses: OleVariant readonly dispid 131079;
    function  EnumerateDeviceClasses: IEnumBstr; dispid 131080;
  end;

// *********************************************************************//
// Interface: IEnumBstr
// Flags:     (16) Hidden
// GUID:      {35372049-0BC6-11D2-A033-00C04FB6809F}
// *********************************************************************//
  IEnumBstr = interface(IUnknown)
    ['{35372049-0BC6-11D2-A033-00C04FB6809F}']
    function  Next(celt: DWORD; out ppStrings: WideString; var pceltFetched: DWORD): HResult; stdcall;
    function  Reset: HResult; stdcall;
    function  Skip(celt: DWORD): HResult; stdcall;
    function  Clone(out ppEnum: IEnumBstr): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ITQOSEvent
// Flags:     (4352) OleAutomation Dispatchable
// GUID:      {CFA3357C-AD77-11D1-BB68-00C04FB6809F}
// *********************************************************************//
  ITQOSEvent = interface(IDispatch)
    ['{CFA3357C-AD77-11D1-BB68-00C04FB6809F}']
    function  Get_Call(out ppCall: ITCallInfo): HResult; stdcall;
    function  Get_Event(out pQosEvent: QOS_EVENT): HResult; stdcall;
    function  Get_MediaType(out plMediaType: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ITAddressEvent
// Flags:     (4352) OleAutomation Dispatchable
// GUID:      {831CE2D1-83B5-11D1-BB5C-00C04FB6809F}
// *********************************************************************//
  ITAddressEvent = interface(IDispatch)
    ['{831CE2D1-83B5-11D1-BB5C-00C04FB6809F}']
    function  Get_Address(out ppAddress: ITAddress): HResult; stdcall;
    function  Get_Event(out pEvent: ADDRESS_EVENT): HResult; stdcall;
    function  Get_Terminal(out ppTerminal: ITTerminal): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ITTerminal
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B1EFC38A-9355-11D0-835C-00AA003CCABD}
// *********************************************************************//
  ITTerminal = interface(IDispatch)
    ['{B1EFC38A-9355-11D0-835C-00AA003CCABD}']
    function  Get_Name: WideString; safecall;
    function  Get_State: TERMINAL_STATE; safecall;
    function  Get_TerminalType: TERMINAL_TYPE; safecall;
    function  Get_TerminalClass: WideString; safecall;
    function  Get_MediaType: Integer; safecall;
    function  Get_Direction: TERMINAL_DIRECTION; safecall;
    property Name: WideString read Get_Name;
    property State: TERMINAL_STATE read Get_State;
    property TerminalType: TERMINAL_TYPE read Get_TerminalType;
    property TerminalClass: WideString read Get_TerminalClass;
    property MediaType: Integer read Get_MediaType;
    property Direction: TERMINAL_DIRECTION read Get_Direction;
  end;

// *********************************************************************//
// DispIntf:  ITTerminalDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B1EFC38A-9355-11D0-835C-00AA003CCABD}
// *********************************************************************//
  ITTerminalDisp = dispinterface
    ['{B1EFC38A-9355-11D0-835C-00AA003CCABD}']
    property Name: WideString readonly dispid 1;
    property State: TERMINAL_STATE readonly dispid 2;
    property TerminalType: TERMINAL_TYPE readonly dispid 3;
    property TerminalClass: WideString readonly dispid 4;
    property MediaType: Integer readonly dispid 5;
    property Direction: TERMINAL_DIRECTION readonly dispid 6;
  end;

// *********************************************************************//
// Interface: ITCallMediaEvent
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FF36B87F-EC3A-11D0-8EE4-00C04FB6809F}
// *********************************************************************//
  ITCallMediaEvent = interface(IDispatch)
    ['{FF36B87F-EC3A-11D0-8EE4-00C04FB6809F}']
    function  Get_Call: ITCallInfo; safecall;
    function  Get_Event: CALL_MEDIA_EVENT; safecall;
    function  Get_Error: HResult; safecall;
    function  Get_Terminal: ITTerminal; safecall;
    function  Get_Stream: ITStream; safecall;
    function  Get_Cause: CALL_MEDIA_EVENT_CAUSE; safecall;
    property Call: ITCallInfo read Get_Call;
    property Event: CALL_MEDIA_EVENT read Get_Event;
    property Error: HResult read Get_Error;
    property Terminal: ITTerminal read Get_Terminal;
    property Stream: ITStream read Get_Stream;
    property Cause: CALL_MEDIA_EVENT_CAUSE read Get_Cause;
  end;

// *********************************************************************//
// DispIntf:  ITCallMediaEventDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FF36B87F-EC3A-11D0-8EE4-00C04FB6809F}
// *********************************************************************//
  ITCallMediaEventDisp = dispinterface
    ['{FF36B87F-EC3A-11D0-8EE4-00C04FB6809F}']
    property Call: ITCallInfo readonly dispid 1;
    property Event: CALL_MEDIA_EVENT readonly dispid 2;
    property Error: HResult readonly dispid 3;
    property Terminal: ITTerminal readonly dispid 4;
    property Stream: ITStream readonly dispid 5;
    property Cause: CALL_MEDIA_EVENT_CAUSE readonly dispid 6;
  end;

// *********************************************************************//
// Interface: ITStream
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EE3BD605-3868-11D2-A045-00C04FB6809F}
// *********************************************************************//
  ITStream = interface(IDispatch)
    ['{EE3BD605-3868-11D2-A045-00C04FB6809F}']
    function  Get_MediaType: Integer; safecall;
    function  Get_Direction: TERMINAL_DIRECTION; safecall;
    function  Get_Name: WideString; safecall;
    procedure StartStream; safecall;
    procedure PauseStream; safecall;
    procedure StopStream; safecall;
    procedure SelectTerminal(const pTerminal: ITTerminal); safecall;
    procedure UnselectTerminal(const pTerminal: ITTerminal); safecall;
    procedure EnumerateTerminals(out ppEnumTerminal: IEnumTerminal); safecall;
    function  Get_Terminals: OleVariant; safecall;
    property MediaType: Integer read Get_MediaType;
    property Direction: TERMINAL_DIRECTION read Get_Direction;
    property Name: WideString read Get_Name;
    property Terminals: OleVariant read Get_Terminals;
  end;

// *********************************************************************//
// DispIntf:  ITStreamDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EE3BD605-3868-11D2-A045-00C04FB6809F}
// *********************************************************************//
  ITStreamDisp = dispinterface
    ['{EE3BD605-3868-11D2-A045-00C04FB6809F}']
    property MediaType: Integer readonly dispid 1;
    property Direction: TERMINAL_DIRECTION readonly dispid 2;
    property Name: WideString readonly dispid 3;
    procedure StartStream; dispid 4;
    procedure PauseStream; dispid 5;
    procedure StopStream; dispid 6;
    procedure SelectTerminal(const pTerminal: ITTerminal); dispid 7;
    procedure UnselectTerminal(const pTerminal: ITTerminal); dispid 8;
    procedure EnumerateTerminals(out ppEnumTerminal: IEnumTerminal); dispid 9;
    property Terminals: OleVariant readonly dispid 10;
  end;

// *********************************************************************//
// Interface: IEnumTerminal
// Flags:     (16) Hidden
// GUID:      {AE269CF4-935E-11D0-835C-00AA003CCABD}
// *********************************************************************//
  IEnumTerminal = interface(IUnknown)
    ['{AE269CF4-935E-11D0-835C-00AA003CCABD}']
    function  Next(celt: DWORD; out ppElements: ITTerminal; var pceltFetched: DWORD): HResult; stdcall;
    function  Reset: HResult; stdcall;
    function  Skip(celt: DWORD): HResult; stdcall;
    function  Clone(out ppEnum: IEnumTerminal): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ITTAPIObjectEvent
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F4854D48-937A-11D1-BB58-00C04FB6809F}
// *********************************************************************//
  ITTAPIObjectEvent = interface(IDispatch)
    ['{F4854D48-937A-11D1-BB58-00C04FB6809F}']
    function  Get_TAPIObject: ITTAPI; safecall;
    function  Get_Event: TAPIOBJECT_EVENT; safecall;
    function  Get_Address: ITAddress; safecall;
    function  Get_CallbackInstance: Integer; safecall;
    property TAPIObject: ITTAPI read Get_TAPIObject;
    property Event: TAPIOBJECT_EVENT read Get_Event;
    property Address: ITAddress read Get_Address;
    property CallbackInstance: Integer read Get_CallbackInstance;
  end;

// *********************************************************************//
// DispIntf:  ITTAPIObjectEventDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F4854D48-937A-11D1-BB58-00C04FB6809F}
// *********************************************************************//
  ITTAPIObjectEventDisp = dispinterface
    ['{F4854D48-937A-11D1-BB58-00C04FB6809F}']
    property TAPIObject: ITTAPI readonly dispid 1;
    property Event: TAPIOBJECT_EVENT readonly dispid 2;
    property Address: ITAddress readonly dispid 3;
    property CallbackInstance: Integer readonly dispid 4;
  end;

// *********************************************************************//
// Interface: ITAddressTranslation
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0C4D8F03-8DDB-11D1-A09E-00805FC147D3}
// *********************************************************************//
  ITAddressTranslation = interface(IDispatch)
    ['{0C4D8F03-8DDB-11D1-A09E-00805FC147D3}']
    function  TranslateAddress(const pAddressToTranslate: WideString; lCard: Integer;
                               lTranslateOptions: Integer): ITAddressTranslationInfo; safecall;
    procedure TranslateDialog(hwndOwner: Integer; const pAddressIn: WideString); safecall;
    function  EnumerateLocations: IEnumLocation; safecall;
    function  Get_Locations: OleVariant; safecall;
    function  EnumerateCallingCards: IEnumCallingCard; safecall;
    function  Get_CallingCards: OleVariant; safecall;
    property Locations: OleVariant read Get_Locations;
    property CallingCards: OleVariant read Get_CallingCards;
  end;

// *********************************************************************//
// DispIntf:  ITAddressTranslationDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0C4D8F03-8DDB-11D1-A09E-00805FC147D3}
// *********************************************************************//
  ITAddressTranslationDisp = dispinterface
    ['{0C4D8F03-8DDB-11D1-A09E-00805FC147D3}']
    function  TranslateAddress(const pAddressToTranslate: WideString; lCard: Integer;
                               lTranslateOptions: Integer): ITAddressTranslationInfo; dispid 262145;
    procedure TranslateDialog(hwndOwner: Integer; const pAddressIn: WideString); dispid 262146;
    function  EnumerateLocations: IEnumLocation; dispid 262147;
    property Locations: OleVariant readonly dispid 262148;
    function  EnumerateCallingCards: IEnumCallingCard; dispid 262149;
    property CallingCards: OleVariant readonly dispid 262150;
  end;

// *********************************************************************//
// Interface: ITAddressTranslationInfo
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AFC15945-8D40-11D1-A09E-00805FC147D3}
// *********************************************************************//
  ITAddressTranslationInfo = interface(IDispatch)
    ['{AFC15945-8D40-11D1-A09E-00805FC147D3}']
    function  Get_DialableString: WideString; safecall;
    function  Get_DisplayableString: WideString; safecall;
    function  Get_CurrentCountryCode: Integer; safecall;
    function  Get_DestinationCountryCode: Integer; safecall;
    function  Get_TranslationResults: Integer; safecall;
    property DialableString: WideString read Get_DialableString;
    property DisplayableString: WideString read Get_DisplayableString;
    property CurrentCountryCode: Integer read Get_CurrentCountryCode;
    property DestinationCountryCode: Integer read Get_DestinationCountryCode;
    property TranslationResults: Integer read Get_TranslationResults;
  end;

// *********************************************************************//
// DispIntf:  ITAddressTranslationInfoDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AFC15945-8D40-11D1-A09E-00805FC147D3}
// *********************************************************************//
  ITAddressTranslationInfoDisp = dispinterface
    ['{AFC15945-8D40-11D1-A09E-00805FC147D3}']
    property DialableString: WideString readonly dispid 1;
    property DisplayableString: WideString readonly dispid 2;
    property CurrentCountryCode: Integer readonly dispid 3;
    property DestinationCountryCode: Integer readonly dispid 4;
    property TranslationResults: Integer readonly dispid 5;
  end;

// *********************************************************************//
// Interface: IEnumLocation
// Flags:     (16) Hidden
// GUID:      {0C4D8F01-8DDB-11D1-A09E-00805FC147D3}
// *********************************************************************//
  IEnumLocation = interface(IUnknown)
    ['{0C4D8F01-8DDB-11D1-A09E-00805FC147D3}']
    function  Next(celt: DWORD; out ppElements: ITLocationInfo; var pceltFetched: DWORD): HResult; stdcall;
    function  Reset: HResult; stdcall;
    function  Skip(celt: DWORD): HResult; stdcall;
    function  Clone(out ppEnum: IEnumLocation): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ITLocationInfo
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0C4D8EFF-8DDB-11D1-A09E-00805FC147D3}
// *********************************************************************//
  ITLocationInfo = interface(IDispatch)
    ['{0C4D8EFF-8DDB-11D1-A09E-00805FC147D3}']
    function  Get_PermanentLocationID: Integer; safecall;
    function  Get_CountryCode: Integer; safecall;
    function  Get_CountryID: Integer; safecall;
    function  Get_Options: Integer; safecall;
    function  Get_PreferredCardID: Integer; safecall;
    function  Get_LocationName: WideString; safecall;
    function  Get_CityCode: WideString; safecall;
    function  Get_LocalAccessCode: WideString; safecall;
    function  Get_LongDistanceAccessCode: WideString; safecall;
    function  Get_TollPrefixList: WideString; safecall;
    function  Get_CancelCallWaitingCode: WideString; safecall;
    property PermanentLocationID: Integer read Get_PermanentLocationID;
    property CountryCode: Integer read Get_CountryCode;
    property CountryID: Integer read Get_CountryID;
    property Options: Integer read Get_Options;
    property PreferredCardID: Integer read Get_PreferredCardID;
    property LocationName: WideString read Get_LocationName;
    property CityCode: WideString read Get_CityCode;
    property LocalAccessCode: WideString read Get_LocalAccessCode;
    property LongDistanceAccessCode: WideString read Get_LongDistanceAccessCode;
    property TollPrefixList: WideString read Get_TollPrefixList;
    property CancelCallWaitingCode: WideString read Get_CancelCallWaitingCode;
  end;

// *********************************************************************//
// DispIntf:  ITLocationInfoDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0C4D8EFF-8DDB-11D1-A09E-00805FC147D3}
// *********************************************************************//
  ITLocationInfoDisp = dispinterface
    ['{0C4D8EFF-8DDB-11D1-A09E-00805FC147D3}']
    property PermanentLocationID: Integer readonly dispid 1;
    property CountryCode: Integer readonly dispid 2;
    property CountryID: Integer readonly dispid 3;
    property Options: Integer readonly dispid 4;
    property PreferredCardID: Integer readonly dispid 5;
    property LocationName: WideString readonly dispid 6;
    property CityCode: WideString readonly dispid 7;
    property LocalAccessCode: WideString readonly dispid 8;
    property LongDistanceAccessCode: WideString readonly dispid 9;
    property TollPrefixList: WideString readonly dispid 10;
    property CancelCallWaitingCode: WideString readonly dispid 11;
  end;

// *********************************************************************//
// Interface: IEnumCallingCard
// Flags:     (16) Hidden
// GUID:      {0C4D8F02-8DDB-11D1-A09E-00805FC147D3}
// *********************************************************************//
  IEnumCallingCard = interface(IUnknown)
    ['{0C4D8F02-8DDB-11D1-A09E-00805FC147D3}']
    function  Next(celt: DWORD; out ppElements: ITCallingCard; var pceltFetched: DWORD): HResult; stdcall;
    function  Reset: HResult; stdcall;
    function  Skip(celt: DWORD): HResult; stdcall;
    function  Clone(out ppEnum: IEnumCallingCard): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ITCallingCard
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0C4D8F00-8DDB-11D1-A09E-00805FC147D3}
// *********************************************************************//
  ITCallingCard = interface(IDispatch)
    ['{0C4D8F00-8DDB-11D1-A09E-00805FC147D3}']
    function  Get_PermanentCardID: Integer; safecall;
    function  Get_NumberOfDigits: Integer; safecall;
    function  Get_Options: Integer; safecall;
    function  Get_CardName: WideString; safecall;
    function  Get_SameAreaDialingRule: WideString; safecall;
    function  Get_LongDistanceDialingRule: WideString; safecall;
    function  Get_InternationalDialingRule: WideString; safecall;
    property PermanentCardID: Integer read Get_PermanentCardID;
    property NumberOfDigits: Integer read Get_NumberOfDigits;
    property Options: Integer read Get_Options;
    property CardName: WideString read Get_CardName;
    property SameAreaDialingRule: WideString read Get_SameAreaDialingRule;
    property LongDistanceDialingRule: WideString read Get_LongDistanceDialingRule;
    property InternationalDialingRule: WideString read Get_InternationalDialingRule;
  end;

// *********************************************************************//
// DispIntf:  ITCallingCardDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0C4D8F00-8DDB-11D1-A09E-00805FC147D3}
// *********************************************************************//
  ITCallingCardDisp = dispinterface
    ['{0C4D8F00-8DDB-11D1-A09E-00805FC147D3}']
    property PermanentCardID: Integer readonly dispid 1;
    property NumberOfDigits: Integer readonly dispid 2;
    property Options: Integer readonly dispid 3;
    property CardName: WideString readonly dispid 4;
    property SameAreaDialingRule: WideString readonly dispid 5;
    property LongDistanceDialingRule: WideString readonly dispid 6;
    property InternationalDialingRule: WideString readonly dispid 7;
  end;

// *********************************************************************//
// Interface: ITAgent
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5770ECE5-4B27-11D1-BF80-00805FC147D3}
// *********************************************************************//
  ITAgent = interface(IDispatch)
    ['{5770ECE5-4B27-11D1-BF80-00805FC147D3}']
    function  EnumerateAgentSessions: IEnumAgentSession; safecall;
    function  CreateSession(const pACDGroup: ITACDGroup; const pAddress: ITAddress): ITAgentSession; safecall;
    function  CreateSessionWithPIN(const pACDGroup: ITACDGroup; const pAddress: ITAddress;
                                   const pPIN: WideString): ITAgentSession; safecall;
    function  Get_ID: WideString; safecall;
    function  Get_User: WideString; safecall;
    procedure Set_State(pAgentState: AGENT_STATE); safecall;
    function  Get_State: AGENT_STATE; safecall;
    procedure Set_MeasurementPeriod(plPeriod: Integer); safecall;
    function  Get_MeasurementPeriod: Integer; safecall;
    function  Get_OverallCallRate: Currency; safecall;
    function  Get_NumberOfACDCalls: Integer; safecall;
    function  Get_NumberOfIncomingCalls: Integer; safecall;
    function  Get_NumberOfOutgoingCalls: Integer; safecall;
    function  Get_TotalACDTalkTime: Integer; safecall;
    function  Get_TotalACDCallTime: Integer; safecall;
    function  Get_TotalWrapUpTime: Integer; safecall;
    function  Get_AgentSessions: OleVariant; safecall;
    property ID: WideString read Get_ID;
    property User: WideString read Get_User;
    property State: AGENT_STATE read Get_State write Set_State;
    property MeasurementPeriod: Integer read Get_MeasurementPeriod write Set_MeasurementPeriod;
    property OverallCallRate: Currency read Get_OverallCallRate;
    property NumberOfACDCalls: Integer read Get_NumberOfACDCalls;
    property NumberOfIncomingCalls: Integer read Get_NumberOfIncomingCalls;
    property NumberOfOutgoingCalls: Integer read Get_NumberOfOutgoingCalls;
    property TotalACDTalkTime: Integer read Get_TotalACDTalkTime;
    property TotalACDCallTime: Integer read Get_TotalACDCallTime;
    property TotalWrapUpTime: Integer read Get_TotalWrapUpTime;
    property AgentSessions: OleVariant read Get_AgentSessions;
  end;

// *********************************************************************//
// DispIntf:  ITAgentDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5770ECE5-4B27-11D1-BF80-00805FC147D3}
// *********************************************************************//
  ITAgentDisp = dispinterface
    ['{5770ECE5-4B27-11D1-BF80-00805FC147D3}']
    function  EnumerateAgentSessions: IEnumAgentSession; dispid 1;
    function  CreateSession(const pACDGroup: ITACDGroup; const pAddress: ITAddress): ITAgentSession; dispid 2;
    function  CreateSessionWithPIN(const pACDGroup: ITACDGroup; const pAddress: ITAddress;
                                   const pPIN: WideString): ITAgentSession; dispid 3;
    property ID: WideString readonly dispid 4;
    property User: WideString readonly dispid 5;
    property State: AGENT_STATE dispid 6;
    property MeasurementPeriod: Integer dispid 7;
    property OverallCallRate: Currency readonly dispid 8;
    property NumberOfACDCalls: Integer readonly dispid 9;
    property NumberOfIncomingCalls: Integer readonly dispid 10;
    property NumberOfOutgoingCalls: Integer readonly dispid 11;
    property TotalACDTalkTime: Integer readonly dispid 12;
    property TotalACDCallTime: Integer readonly dispid 13;
    property TotalWrapUpTime: Integer readonly dispid 14;
    property AgentSessions: OleVariant readonly dispid 15;
  end;

// *********************************************************************//
// Interface: IEnumAgentSession
// Flags:     (16) Hidden
// GUID:      {5AFC314E-4BCC-11D1-BF80-00805FC147D3}
// *********************************************************************//
  IEnumAgentSession = interface(IUnknown)
    ['{5AFC314E-4BCC-11D1-BF80-00805FC147D3}']
    function  Next(celt: DWORD; out ppElements: ITAgentSession; out pceltFetched: DWORD): HResult; stdcall;
    function  Reset: HResult; stdcall;
    function  Skip(celt: DWORD): HResult; stdcall;
    function  Clone(out ppEnum: IEnumAgentSession): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ITAgentSession
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5AFC3147-4BCC-11D1-BF80-00805FC147D3}
// *********************************************************************//
  ITAgentSession = interface(IDispatch)
    ['{5AFC3147-4BCC-11D1-BF80-00805FC147D3}']
    function  Get_Agent: ITAgent; safecall;
    function  Get_Address: ITAddress; safecall;
    function  Get_ACDGroup: ITACDGroup; safecall;
    procedure Set_State(pSessionState: AGENT_SESSION_STATE); safecall;
    function  Get_State: AGENT_SESSION_STATE; safecall;
    function  Get_SessionStartTime: TDateTime; safecall;
    function  Get_SessionDuration: Integer; safecall;
    function  Get_NumberOfCalls: Integer; safecall;
    function  Get_TotalTalkTime: Integer; safecall;
    function  Get_AverageTalkTime: Integer; safecall;
    function  Get_TotalCallTime: Integer; safecall;
    function  Get_AverageCallTime: Integer; safecall;
    function  Get_TotalWrapUpTime: Integer; safecall;
    function  Get_AverageWrapUpTime: Integer; safecall;
    function  Get_ACDCallRate: Currency; safecall;
    function  Get_LongestTimeToAnswer: Integer; safecall;
    function  Get_AverageTimeToAnswer: Integer; safecall;
    property Agent: ITAgent read Get_Agent;
    property Address: ITAddress read Get_Address;
    property ACDGroup: ITACDGroup read Get_ACDGroup;
    property State: AGENT_SESSION_STATE read Get_State write Set_State;
    property SessionStartTime: TDateTime read Get_SessionStartTime;
    property SessionDuration: Integer read Get_SessionDuration;
    property NumberOfCalls: Integer read Get_NumberOfCalls;
    property TotalTalkTime: Integer read Get_TotalTalkTime;
    property AverageTalkTime: Integer read Get_AverageTalkTime;
    property TotalCallTime: Integer read Get_TotalCallTime;
    property AverageCallTime: Integer read Get_AverageCallTime;
    property TotalWrapUpTime: Integer read Get_TotalWrapUpTime;
    property AverageWrapUpTime: Integer read Get_AverageWrapUpTime;
    property ACDCallRate: Currency read Get_ACDCallRate;
    property LongestTimeToAnswer: Integer read Get_LongestTimeToAnswer;
    property AverageTimeToAnswer: Integer read Get_AverageTimeToAnswer;
  end;

// *********************************************************************//
// DispIntf:  ITAgentSessionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5AFC3147-4BCC-11D1-BF80-00805FC147D3}
// *********************************************************************//
  ITAgentSessionDisp = dispinterface
    ['{5AFC3147-4BCC-11D1-BF80-00805FC147D3}']
    property Agent: ITAgent readonly dispid 1;
    property Address: ITAddress readonly dispid 2;
    property ACDGroup: ITACDGroup readonly dispid 3;
    property State: AGENT_SESSION_STATE dispid 4;
    property SessionStartTime: TDateTime readonly dispid 5;
    property SessionDuration: Integer readonly dispid 6;
    property NumberOfCalls: Integer readonly dispid 7;
    property TotalTalkTime: Integer readonly dispid 8;
    property AverageTalkTime: Integer readonly dispid 9;
    property TotalCallTime: Integer readonly dispid 10;
    property AverageCallTime: Integer readonly dispid 11;
    property TotalWrapUpTime: Integer readonly dispid 12;
    property AverageWrapUpTime: Integer readonly dispid 13;
    property ACDCallRate: Currency readonly dispid 14;
    property LongestTimeToAnswer: Integer readonly dispid 15;
    property AverageTimeToAnswer: Integer readonly dispid 16;
  end;

// *********************************************************************//
// Interface: ITACDGroup
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5AFC3148-4BCC-11D1-BF80-00805FC147D3}
// *********************************************************************//
  ITACDGroup = interface(IDispatch)
    ['{5AFC3148-4BCC-11D1-BF80-00805FC147D3}']
    function  Get_Name: WideString; safecall;
    function  EnumerateQueues: IEnumQueue; safecall;
    function  Get_Queues: OleVariant; safecall;
    property Name: WideString read Get_Name;
    property Queues: OleVariant read Get_Queues;
  end;

// *********************************************************************//
// DispIntf:  ITACDGroupDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5AFC3148-4BCC-11D1-BF80-00805FC147D3}
// *********************************************************************//
  ITACDGroupDisp = dispinterface
    ['{5AFC3148-4BCC-11D1-BF80-00805FC147D3}']
    property Name: WideString readonly dispid 1;
    function  EnumerateQueues: IEnumQueue; dispid 2;
    property Queues: OleVariant readonly dispid 3;
  end;

// *********************************************************************//
// Interface: IEnumQueue
// Flags:     (16) Hidden
// GUID:      {5AFC3158-4BCC-11D1-BF80-00805FC147D3}
// *********************************************************************//
  IEnumQueue = interface(IUnknown)
    ['{5AFC3158-4BCC-11D1-BF80-00805FC147D3}']
    function  Next(celt: DWORD; out ppElements: ITQueue; out pceltFetched: DWORD): HResult; stdcall;
    function  Reset: HResult; stdcall;
    function  Skip(celt: DWORD): HResult; stdcall;
    function  Clone(out ppEnum: IEnumQueue): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ITQueue
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5AFC3149-4BCC-11D1-BF80-00805FC147D3}
// *********************************************************************//
  ITQueue = interface(IDispatch)
    ['{5AFC3149-4BCC-11D1-BF80-00805FC147D3}']
    procedure Set_MeasurementPeriod(plPeriod: Integer); safecall;
    function  Get_MeasurementPeriod: Integer; safecall;
    function  Get_TotalCallsQueued: Integer; safecall;
    function  Get_CurrentCallsQueued: Integer; safecall;
    function  Get_TotalCallsAbandoned: Integer; safecall;
    function  Get_TotalCallsFlowedIn: Integer; safecall;
    function  Get_TotalCallsFlowedOut: Integer; safecall;
    function  Get_LongestEverWaitTime: Integer; safecall;
    function  Get_CurrentLongestWaitTime: Integer; safecall;
    function  Get_AverageWaitTime: Integer; safecall;
    function  Get_FinalDisposition: Integer; safecall;
    function  Get_Name: WideString; safecall;
    property MeasurementPeriod: Integer read Get_MeasurementPeriod write Set_MeasurementPeriod;
    property TotalCallsQueued: Integer read Get_TotalCallsQueued;
    property CurrentCallsQueued: Integer read Get_CurrentCallsQueued;
    property TotalCallsAbandoned: Integer read Get_TotalCallsAbandoned;
    property TotalCallsFlowedIn: Integer read Get_TotalCallsFlowedIn;
    property TotalCallsFlowedOut: Integer read Get_TotalCallsFlowedOut;
    property LongestEverWaitTime: Integer read Get_LongestEverWaitTime;
    property CurrentLongestWaitTime: Integer read Get_CurrentLongestWaitTime;
    property AverageWaitTime: Integer read Get_AverageWaitTime;
    property FinalDisposition: Integer read Get_FinalDisposition;
    property Name: WideString read Get_Name;
  end;

// *********************************************************************//
// DispIntf:  ITQueueDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5AFC3149-4BCC-11D1-BF80-00805FC147D3}
// *********************************************************************//
  ITQueueDisp = dispinterface
    ['{5AFC3149-4BCC-11D1-BF80-00805FC147D3}']
    property MeasurementPeriod: Integer dispid 1;
    property TotalCallsQueued: Integer readonly dispid 2;
    property CurrentCallsQueued: Integer readonly dispid 3;
    property TotalCallsAbandoned: Integer readonly dispid 4;
    property TotalCallsFlowedIn: Integer readonly dispid 5;
    property TotalCallsFlowedOut: Integer readonly dispid 6;
    property LongestEverWaitTime: Integer readonly dispid 7;
    property CurrentLongestWaitTime: Integer readonly dispid 8;
    property AverageWaitTime: Integer readonly dispid 9;
    property FinalDisposition: Integer readonly dispid 10;
    property Name: WideString readonly dispid 11;
  end;

// *********************************************************************//
// Interface: ITAgentEvent
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5AFC314A-4BCC-11D1-BF80-00805FC147D3}
// *********************************************************************//
  ITAgentEvent = interface(IDispatch)
    ['{5AFC314A-4BCC-11D1-BF80-00805FC147D3}']
    function  Get_Agent: ITAgent; safecall;
    function  Get_Event: AGENT_EVENT; safecall;
    property Agent: ITAgent read Get_Agent;
    property Event: AGENT_EVENT read Get_Event;
  end;

// *********************************************************************//
// DispIntf:  ITAgentEventDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5AFC314A-4BCC-11D1-BF80-00805FC147D3}
// *********************************************************************//
  ITAgentEventDisp = dispinterface
    ['{5AFC314A-4BCC-11D1-BF80-00805FC147D3}']
    property Agent: ITAgent readonly dispid 1;
    property Event: AGENT_EVENT readonly dispid 2;
  end;

// *********************************************************************//
// Interface: ITAgentSessionEvent
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5AFC314B-4BCC-11D1-BF80-00805FC147D3}
// *********************************************************************//
  ITAgentSessionEvent = interface(IDispatch)
    ['{5AFC314B-4BCC-11D1-BF80-00805FC147D3}']
    function  Get_Session: ITAgentSession; safecall;
    function  Get_Event: AGENT_SESSION_EVENT; safecall;
    property Session: ITAgentSession read Get_Session;
    property Event: AGENT_SESSION_EVENT read Get_Event;
  end;

// *********************************************************************//
// DispIntf:  ITAgentSessionEventDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5AFC314B-4BCC-11D1-BF80-00805FC147D3}
// *********************************************************************//
  ITAgentSessionEventDisp = dispinterface
    ['{5AFC314B-4BCC-11D1-BF80-00805FC147D3}']
    property Session: ITAgentSession readonly dispid 1;
    property Event: AGENT_SESSION_EVENT readonly dispid 2;
  end;

// *********************************************************************//
// Interface: ITACDGroupEvent
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {297F3032-BD11-11D1-A0A7-00805FC147D3}
// *********************************************************************//
  ITACDGroupEvent = interface(IDispatch)
    ['{297F3032-BD11-11D1-A0A7-00805FC147D3}']
    function  Get_Group: ITACDGroup; safecall;
    function  Get_Event: ACDGROUP_EVENT; safecall;
    property Group: ITACDGroup read Get_Group;
    property Event: ACDGROUP_EVENT read Get_Event;
  end;

// *********************************************************************//
// DispIntf:  ITACDGroupEventDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {297F3032-BD11-11D1-A0A7-00805FC147D3}
// *********************************************************************//
  ITACDGroupEventDisp = dispinterface
    ['{297F3032-BD11-11D1-A0A7-00805FC147D3}']
    property Group: ITACDGroup readonly dispid 1;
    property Event: ACDGROUP_EVENT readonly dispid 2;
  end;

// *********************************************************************//
// Interface: ITQueueEvent
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {297F3033-BD11-11D1-A0A7-00805FC147D3}
// *********************************************************************//
  ITQueueEvent = interface(IDispatch)
    ['{297F3033-BD11-11D1-A0A7-00805FC147D3}']
    function  Get_Queue: ITQueue; safecall;
    function  Get_Event: ACDQUEUE_EVENT; safecall;
    property Queue: ITQueue read Get_Queue;
    property Event: ACDQUEUE_EVENT read Get_Event;
  end;

// *********************************************************************//
// DispIntf:  ITQueueEventDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {297F3033-BD11-11D1-A0A7-00805FC147D3}
// *********************************************************************//
  ITQueueEventDisp = dispinterface
    ['{297F3033-BD11-11D1-A0A7-00805FC147D3}']
    property Queue: ITQueue readonly dispid 1;
    property Event: ACDQUEUE_EVENT readonly dispid 2;
  end;

// *********************************************************************//
// Interface: ITTAPICallCenter
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5AFC3154-4BCC-11D1-BF80-00805FC147D3}
// *********************************************************************//
  ITTAPICallCenter = interface(IDispatch)
    ['{5AFC3154-4BCC-11D1-BF80-00805FC147D3}']
    function  EnumerateAgentHandlers: IEnumAgentHandler; safecall;
    function  Get_AgentHandlers: OleVariant; safecall;
    property AgentHandlers: OleVariant read Get_AgentHandlers;
  end;

// *********************************************************************//
// DispIntf:  ITTAPICallCenterDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5AFC3154-4BCC-11D1-BF80-00805FC147D3}
// *********************************************************************//
  ITTAPICallCenterDisp = dispinterface
    ['{5AFC3154-4BCC-11D1-BF80-00805FC147D3}']
    function  EnumerateAgentHandlers: IEnumAgentHandler; dispid 131073;
    property AgentHandlers: OleVariant readonly dispid 131074;
  end;

// *********************************************************************//
// Interface: IEnumAgentHandler
// Flags:     (16) Hidden
// GUID:      {587E8C28-9802-11D1-A0A4-00805FC147D3}
// *********************************************************************//
  IEnumAgentHandler = interface(IUnknown)
    ['{587E8C28-9802-11D1-A0A4-00805FC147D3}']
    function  Next(celt: DWORD; out ppElements: ITAgentHandler; out pceltFetched: DWORD): HResult; stdcall;
    function  Reset: HResult; stdcall;
    function  Skip(celt: DWORD): HResult; stdcall;
    function  Clone(out ppEnum: IEnumAgentHandler): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ITAgentHandler
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {587E8C22-9802-11D1-A0A4-00805FC147D3}
// *********************************************************************//
  ITAgentHandler = interface(IDispatch)
    ['{587E8C22-9802-11D1-A0A4-00805FC147D3}']
    function  Get_Name: WideString; safecall;
    function  CreateAgent: ITAgent; safecall;
    function  CreateAgentWithID(const pID: WideString; const pPIN: WideString): ITAgent; safecall;
    function  EnumerateACDGroups: IEnumACDGroup; safecall;
    function  EnumerateUsableAddresses: IEnumAddress; safecall;
    function  Get_ACDGroups: OleVariant; safecall;
    function  Get_UsableAddresses: OleVariant; safecall;
    property Name: WideString read Get_Name;
    property ACDGroups: OleVariant read Get_ACDGroups;
    property UsableAddresses: OleVariant read Get_UsableAddresses;
  end;

// *********************************************************************//
// DispIntf:  ITAgentHandlerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {587E8C22-9802-11D1-A0A4-00805FC147D3}
// *********************************************************************//
  ITAgentHandlerDisp = dispinterface
    ['{587E8C22-9802-11D1-A0A4-00805FC147D3}']
    property Name: WideString readonly dispid 1;
    function  CreateAgent: ITAgent; dispid 2;
    function  CreateAgentWithID(const pID: WideString; const pPIN: WideString): ITAgent; dispid 3;
    function  EnumerateACDGroups: IEnumACDGroup; dispid 4;
    function  EnumerateUsableAddresses: IEnumAddress; dispid 5;
    property ACDGroups: OleVariant readonly dispid 6;
    property UsableAddresses: OleVariant readonly dispid 7;
  end;

// *********************************************************************//
// Interface: IEnumACDGroup
// Flags:     (16) Hidden
// GUID:      {5AFC3157-4BCC-11D1-BF80-00805FC147D3}
// *********************************************************************//
  IEnumACDGroup = interface(IUnknown)
    ['{5AFC3157-4BCC-11D1-BF80-00805FC147D3}']
    function  Next(celt: DWORD; out ppElements: ITACDGroup; out pceltFetched: DWORD): HResult; stdcall;
    function  Reset: HResult; stdcall;
    function  Skip(celt: DWORD): HResult; stdcall;
    function  Clone(out ppEnum: IEnumACDGroup): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ITAgentHandlerEvent
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {297F3034-BD11-11D1-A0A7-00805FC147D3}
// *********************************************************************//
  ITAgentHandlerEvent = interface(IDispatch)
    ['{297F3034-BD11-11D1-A0A7-00805FC147D3}']
    function  Get_AgentHandler: ITAgentHandler; safecall;
    function  Get_Event: AGENTHANDLER_EVENT; safecall;
    property AgentHandler: ITAgentHandler read Get_AgentHandler;
    property Event: AGENTHANDLER_EVENT read Get_Event;
  end;

// *********************************************************************//
// DispIntf:  ITAgentHandlerEventDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {297F3034-BD11-11D1-A0A7-00805FC147D3}
// *********************************************************************//
  ITAgentHandlerEventDisp = dispinterface
    ['{297F3034-BD11-11D1-A0A7-00805FC147D3}']
    property AgentHandler: ITAgentHandler readonly dispid 1;
    property Event: AGENTHANDLER_EVENT readonly dispid 2;
  end;

// *********************************************************************//
// Interface: ITCallInfoChangeEvent
// Flags:     (4352) OleAutomation Dispatchable
// GUID:      {5D4B65F9-E51C-11D1-A02F-00C04FB6809F}
// *********************************************************************//
  ITCallInfoChangeEvent = interface(IDispatch)
    ['{5D4B65F9-E51C-11D1-A02F-00C04FB6809F}']
    function  Get_Call(out ppCall: ITCallInfo): HResult; stdcall;
    function  Get_Cause(out pCIC: CALLINFOCHANGE_CAUSE): HResult; stdcall;
    function  Get_CallbackInstance(out plCallbackInstance: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ITRequestEvent
// Flags:     (4352) OleAutomation Dispatchable
// GUID:      {AC48FFDE-F8C4-11D1-A030-00C04FB6809F}
// *********************************************************************//
  ITRequestEvent = interface(IDispatch)
    ['{AC48FFDE-F8C4-11D1-A030-00C04FB6809F}']
    function  Get_RegistrationInstance(out plRegistrationInstance: Integer): HResult; stdcall;
    function  Get_RequestMode(out plRequestMode: Integer): HResult; stdcall;
    function  Get_DestAddress(out ppDestAddress: WideString): HResult; stdcall;
    function  Get_AppName(out ppAppName: WideString): HResult; stdcall;
    function  Get_CalledParty(out ppCalledParty: WideString): HResult; stdcall;
    function  Get_Comment(out ppComment: WideString): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ITMediaSupport
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B1EFC384-9355-11D0-835C-00AA003CCABD}
// *********************************************************************//
  ITMediaSupport = interface(IDispatch)
    ['{B1EFC384-9355-11D0-835C-00AA003CCABD}']
    function  Get_MediaTypes: Integer; safecall;
    function  QueryMediaType(lMediaType: Integer): WordBool; safecall;
    property MediaTypes: Integer read Get_MediaTypes;
  end;

// *********************************************************************//
// DispIntf:  ITMediaSupportDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B1EFC384-9355-11D0-835C-00AA003CCABD}
// *********************************************************************//
  ITMediaSupportDisp = dispinterface
    ['{B1EFC384-9355-11D0-835C-00AA003CCABD}']
    property MediaTypes: Integer readonly dispid 196609;
    function  QueryMediaType(lMediaType: Integer): WordBool; dispid 196610;
  end;

// *********************************************************************//
// Interface: ITTerminalSupport
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B1EFC385-9355-11D0-835C-00AA003CCABD}
// *********************************************************************//
  ITTerminalSupport = interface(IDispatch)
    ['{B1EFC385-9355-11D0-835C-00AA003CCABD}']
    function  Get_StaticTerminals: OleVariant; safecall;
    function  EnumerateStaticTerminals: IEnumTerminal; safecall;
    function  Get_DynamicTerminalClasses: OleVariant; safecall;
    function  EnumerateDynamicTerminalClasses: IEnumTerminalClass; safecall;
    function  CreateTerminal(const pTerminalClass: WideString; lMediaType: Integer; 
                             Direction: TERMINAL_DIRECTION): ITTerminal; safecall;
    function  GetDefaultStaticTerminal(lMediaType: Integer; Direction: TERMINAL_DIRECTION): ITTerminal; safecall;
    property StaticTerminals: OleVariant read Get_StaticTerminals;
    property DynamicTerminalClasses: OleVariant read Get_DynamicTerminalClasses;
  end;

// *********************************************************************//
// DispIntf:  ITTerminalSupportDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B1EFC385-9355-11D0-835C-00AA003CCABD}
// *********************************************************************//
  ITTerminalSupportDisp = dispinterface
    ['{B1EFC385-9355-11D0-835C-00AA003CCABD}']
    property StaticTerminals: OleVariant readonly dispid 393217;
    function  EnumerateStaticTerminals: IEnumTerminal; dispid 393218;
    property DynamicTerminalClasses: OleVariant readonly dispid 393219;
    function  EnumerateDynamicTerminalClasses: IEnumTerminalClass; dispid 393220;
    function  CreateTerminal(const pTerminalClass: WideString; lMediaType: Integer; 
                             Direction: TERMINAL_DIRECTION): ITTerminal; dispid 393221;
    function  GetDefaultStaticTerminal(lMediaType: Integer; Direction: TERMINAL_DIRECTION): ITTerminal; dispid 393222;
  end;

// *********************************************************************//
// Interface: IEnumTerminalClass
// Flags:     (16) Hidden
// GUID:      {AE269CF5-935E-11D0-835C-00AA003CCABD}
// *********************************************************************//
  IEnumTerminalClass = interface(IUnknown)
    ['{AE269CF5-935E-11D0-835C-00AA003CCABD}']
    function  Next(celt: DWORD; out pElements: TGUID; var pceltFetched: DWORD): HResult; stdcall;
    function  Reset: HResult; stdcall;
    function  Skip(celt: DWORD): HResult; stdcall;
    function  Clone(out ppEnum: IEnumTerminalClass): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ITStreamControl
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EE3BD604-3868-11D2-A045-00C04FB6809F}
// *********************************************************************//
  ITStreamControl = interface(IDispatch)
    ['{EE3BD604-3868-11D2-A045-00C04FB6809F}']
    function  CreateStream(lMediaType: Integer; td: TERMINAL_DIRECTION): ITStream; safecall;
    procedure RemoveStream(const pStream: ITStream); safecall;
    procedure EnumerateStreams(out ppEnumStream: IEnumStream); safecall;
    function  Get_Streams: OleVariant; safecall;
    property Streams: OleVariant read Get_Streams;
  end;

// *********************************************************************//
// DispIntf:  ITStreamControlDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EE3BD604-3868-11D2-A045-00C04FB6809F}
// *********************************************************************//
  ITStreamControlDisp = dispinterface
    ['{EE3BD604-3868-11D2-A045-00C04FB6809F}']
    function  CreateStream(lMediaType: Integer; td: TERMINAL_DIRECTION): ITStream; dispid 262145;
    procedure RemoveStream(const pStream: ITStream); dispid 262146;
    procedure EnumerateStreams(out ppEnumStream: IEnumStream); dispid 262147;
    property Streams: OleVariant readonly dispid 262148;
  end;

// *********************************************************************//
// Interface: IEnumStream
// Flags:     (16) Hidden
// GUID:      {EE3BD606-3868-11D2-A045-00C04FB6809F}
// *********************************************************************//
  IEnumStream = interface(IUnknown)
    ['{EE3BD606-3868-11D2-A045-00C04FB6809F}']
    function  Next(celt: DWORD; out ppElements: ITStream; var pceltFetched: DWORD): HResult; stdcall;
    function  Reset: HResult; stdcall;
    function  Skip(celt: DWORD): HResult; stdcall;
    function  Clone(out ppEnum: IEnumStream): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ITSubStreamControl
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EE3BD607-3868-11D2-A045-00C04FB6809F}
// *********************************************************************//
  ITSubStreamControl = interface(IDispatch)
    ['{EE3BD607-3868-11D2-A045-00C04FB6809F}']
    function  CreateSubStream: ITSubStream; safecall;
    procedure RemoveSubStream(const pSubStream: ITSubStream); safecall;
    procedure EnumerateSubStreams(out ppEnumSubStream: IEnumSubStream); safecall;
    function  Get_SubStreams: OleVariant; safecall;
    property SubStreams: OleVariant read Get_SubStreams;
  end;

// *********************************************************************//
// DispIntf:  ITSubStreamControlDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EE3BD607-3868-11D2-A045-00C04FB6809F}
// *********************************************************************//
  ITSubStreamControlDisp = dispinterface
    ['{EE3BD607-3868-11D2-A045-00C04FB6809F}']
    function  CreateSubStream: ITSubStream; dispid 1;
    procedure RemoveSubStream(const pSubStream: ITSubStream); dispid 2;
    procedure EnumerateSubStreams(out ppEnumSubStream: IEnumSubStream); dispid 3;
    property SubStreams: OleVariant readonly dispid 4;
  end;

// *********************************************************************//
// Interface: ITSubStream
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EE3BD608-3868-11D2-A045-00C04FB6809F}
// *********************************************************************//
  ITSubStream = interface(IDispatch)
    ['{EE3BD608-3868-11D2-A045-00C04FB6809F}']
    procedure StartSubStream; safecall;
    procedure PauseSubStream; safecall;
    procedure StopSubStream; safecall;
    procedure SelectTerminal(const pTerminal: ITTerminal); safecall;
    procedure UnselectTerminal(const pTerminal: ITTerminal); safecall;
    procedure EnumerateTerminals(out ppEnumTerminal: IEnumTerminal); safecall;
    function  Get_Terminals: OleVariant; safecall;
    function  Get_Stream: ITStream; safecall;
    property Terminals: OleVariant read Get_Terminals;
    property Stream: ITStream read Get_Stream;
  end;

// *********************************************************************//
// DispIntf:  ITSubStreamDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EE3BD608-3868-11D2-A045-00C04FB6809F}
// *********************************************************************//
  ITSubStreamDisp = dispinterface
    ['{EE3BD608-3868-11D2-A045-00C04FB6809F}']
    procedure StartSubStream; dispid 1;
    procedure PauseSubStream; dispid 2;
    procedure StopSubStream; dispid 3;
    procedure SelectTerminal(const pTerminal: ITTerminal); dispid 4;
    procedure UnselectTerminal(const pTerminal: ITTerminal); dispid 5;
    procedure EnumerateTerminals(out ppEnumTerminal: IEnumTerminal); dispid 6;
    property Terminals: OleVariant readonly dispid 7;
    property Stream: ITStream readonly dispid 8;
  end;

// *********************************************************************//
// Interface: IEnumSubStream
// Flags:     (16) Hidden
// GUID:      {EE3BD609-3868-11D2-A045-00C04FB6809F}
// *********************************************************************//
  IEnumSubStream = interface(IUnknown)
    ['{EE3BD609-3868-11D2-A045-00C04FB6809F}']
    function  Next(celt: DWORD; out ppElements: ITSubStream; var pceltFetched: DWORD): HResult; stdcall;
    function  Reset: HResult; stdcall;
    function  Skip(celt: DWORD): HResult; stdcall;
    function  Clone(out ppEnum: IEnumSubStream): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ITLegacyAddressMediaControl
// Flags:     (16) Hidden
// GUID:      {AB493640-4C0B-11D2-A046-00C04FB6809F}
// *********************************************************************//
  ITLegacyAddressMediaControl = interface(IUnknown)
    ['{AB493640-4C0B-11D2-A046-00C04FB6809F}']
    function  GetID(const pDeviceClass: WideString; out pdwSize: DWORD; out ppDeviceID: PByte1): HResult; stdcall;
    function  GetDevConfig(const pDeviceClass: WideString; out pdwSize: DWORD; 
                           out ppDeviceConfig: PByte1): HResult; stdcall;
    function  SetDevConfig(const pDeviceClass: WideString; dwSize: DWORD; var pDeviceConfig: Byte): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ITLegacyCallMediaControl
// Flags:     (4096) Dispatchable
// GUID:      {D624582F-CC23-4436-B8A5-47C625C8045D}
// *********************************************************************//
  ITLegacyCallMediaControl = interface(IDispatch)
    ['{D624582F-CC23-4436-B8A5-47C625C8045D}']
    function  DetectDigits(DigitMode: Integer): HResult; stdcall;
    function  GenerateDigits(const pDigits: WideString; DigitMode: Integer): HResult; stdcall;
    function  GetID(const pDeviceClass: WideString; out pdwSize: DWORD; out ppDeviceID: PByte1): HResult; stdcall;
    function  SetMediaType(lMediaType: Integer): HResult; stdcall;
    function  MonitorMedia(lMediaType: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ITDigitDetectionEvent
// Flags:     (4352) OleAutomation Dispatchable
// GUID:      {80D3BFAC-57D9-11D2-A04A-00C04FB6809F}
// *********************************************************************//
  ITDigitDetectionEvent = interface(IDispatch)
    ['{80D3BFAC-57D9-11D2-A04A-00C04FB6809F}']
    function  Get_Call(out ppCallInfo: ITCallInfo): HResult; stdcall;
    function  Get_Digit(out pucDigit: Byte): HResult; stdcall;
    function  Get_DigitMode(out pDigitMode: Integer): HResult; stdcall;
    function  Get_TickCount(out plTickCount: Integer): HResult; stdcall;
    function  Get_CallbackInstance(out plCallbackInstance: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ITDigitGenerationEvent
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {80D3BFAD-57D9-11D2-A04A-00C04FB6809F}
// *********************************************************************//
  ITDigitGenerationEvent = interface(IDispatch)
    ['{80D3BFAD-57D9-11D2-A04A-00C04FB6809F}']
    function  Get_Call: ITCallInfo; safecall;
    function  Get_GenerationTermination: Integer; safecall;
    function  Get_TickCount: Integer; safecall;
    function  Get_CallbackInstance: Integer; safecall;
    property Call: ITCallInfo read Get_Call;
    property GenerationTermination: Integer read Get_GenerationTermination;
    property TickCount: Integer read Get_TickCount;
    property CallbackInstance: Integer read Get_CallbackInstance;
  end;

// *********************************************************************//
// DispIntf:  ITDigitGenerationEventDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {80D3BFAD-57D9-11D2-A04A-00C04FB6809F}
// *********************************************************************//
  ITDigitGenerationEventDisp = dispinterface
    ['{80D3BFAD-57D9-11D2-A04A-00C04FB6809F}']
    property Call: ITCallInfo readonly dispid 1;
    property GenerationTermination: Integer readonly dispid 2;
    property TickCount: Integer readonly dispid 3;
    property CallbackInstance: Integer readonly dispid 4;
  end;

// *********************************************************************//
// Interface: ITPrivateEvent
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0E269CD0-10D4-4121-9C22-9C85D625650D}
// *********************************************************************//
  ITPrivateEvent = interface(IDispatch)
    ['{0E269CD0-10D4-4121-9C22-9C85D625650D}']
    function  Get_Address: ITAddress; safecall;
    function  Get_Call: ITCallInfo; safecall;
    function  Get_CallHub: ITCallHub; safecall;
    function  Get_EventCode: Integer; safecall;
    function  Get_EventInterface: IDispatch; safecall;
    property Address: ITAddress read Get_Address;
    property Call: ITCallInfo read Get_Call;
    property CallHub: ITCallHub read Get_CallHub;
    property EventCode: Integer read Get_EventCode;
    property EventInterface: IDispatch read Get_EventInterface;
  end;

// *********************************************************************//
// DispIntf:  ITPrivateEventDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0E269CD0-10D4-4121-9C22-9C85D625650D}
// *********************************************************************//
  ITPrivateEventDisp = dispinterface
    ['{0E269CD0-10D4-4121-9C22-9C85D625650D}']
    property Address: ITAddress readonly dispid 1;
    property Call: ITCallInfo readonly dispid 2;
    property CallHub: ITCallHub readonly dispid 3;
    property EventCode: Integer readonly dispid 4;
    property EventInterface: IDispatch readonly dispid 5;
  end;

// *********************************************************************//
// DispIntf:  ITTAPIDispatchEventNotification
// Flags:     (4096) Dispatchable
// GUID:      {9F34325B-7E62-11D2-9457-00C04F8EC888}
// *********************************************************************//
  ITTAPIDispatchEventNotification = dispinterface
    ['{9F34325B-7E62-11D2-9457-00C04F8EC888}']
    procedure Event(TapiEvent: TAPI_EVENT; const pEvent: IDispatch); dispid 1;
  end;

// *********************************************************************//
// Interface: ITDispatchMapper
// Flags:     (4096) Dispatchable
// GUID:      {E9225295-C759-11D1-A02B-00C04FB6809F}
// *********************************************************************//
  ITDispatchMapper = interface(IDispatch)
    ['{E9225295-C759-11D1-A02B-00C04FB6809F}']
    function  QueryDispatchInterface(const pIID: WideString; const pInterfaceToMap: IDispatch; 
                                     out ppReturnedInterface: IDispatch): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ITRequest
// Flags:     (4352) OleAutomation Dispatchable
// GUID:      {AC48FFDF-F8C4-11D1-A030-00C04FB6809F}
// *********************************************************************//
  ITRequest = interface(IDispatch)
    ['{AC48FFDF-F8C4-11D1-A030-00C04FB6809F}']
    function  MakeCall(const pDestAddress: WideString; const pAppName: WideString;
                       const pCalledParty: WideString; const pComment: WideString): HResult; stdcall;
  end;

// *********************************************************************//

  HSEMAPHORE = Longint;
  TReference_Time = Comp;

// *********************************************************************//
  IReferenceClock = interface(IUnknown)
    ['{56A86897-0AD4-11CE-B03A-0020AF0BA770}']
    function GetTime(var pTime: TReference_Time): HRESULT; stdcall;
    function AdviseTime(baseTime, streamTime: TReference_Time;
        hEvent: THandle; var pdwAdviseCookie: DWORD): HRESULT; stdcall;
    function AdvisePeriodic(startTime, periodTime: TReference_Time;
        hSemaphore: HSEMAPHORE; var pdwAdviseCookie: DWORD): HRESULT; stdcall;
    function Unadvise(dwAdviseCookie: DWORD): HRESULT; stdcall;
  end;

// *********************************************************************//

  TFilter_State = (
    State_Stopped,
    State_Paused,
    State_Running
  );

// *********************************************************************//

  IMediaFilter = interface(IPersist)
    ['{56A86899-0AD4-11CE-B03A-0020AF0BA770}']
    function Stop: HRESULT; stdcall;
    function Pause: HRESULT; stdcall;
    function Run(tStart: TReference_Time): HRESULT; stdcall;
    function GetState(dwMilliSecsTimeout: DWORD; var State: TFilter_State): HRESULT; stdcall;
    function SetSyncSource(pClock: IReferenceClock): HRESULT; stdcall;
    function GetSyncSource(out pClock: IReferenceClock): HRESULT; stdcall;
  end;

// *********************************************************************//

  TAM_Media_Type = record
    majortype: TGUID;
    subtype: TGUID;
    bFixedSizeSamples: BOOL;
    bTemporalCompression: BOOL;
    lSampleSize: ULONG;
    formattype: TGUID;
    pUnk: IUnknown;
    cbFormat: ULONG;
    pbFormat: Pointer;
  end;
  PAM_Media_Type = ^TAM_Media_Type;

// *********************************************************************//

  IBaseFilter = interface;

// *********************************************************************//

  TPin_Direction = (
    PINDIR_INPUT,
    PINDIR_OUTPUT
  );

// *********************************************************************//

  TPin_Info = record
    pFilter: IBaseFilter;
    dir: TPin_Direction;
    achName: array[0..127] of WCHAR;
  end;

// *********************************************************************//

  IEnumMediaTypes = interface(IUnknown)
    ['{89C31040-846B-11CE-97D3-00AA0055595A}']
    function Next(cMediaTypes: ULONG; var ppMediaTypes: PAM_Media_Type;
        var pcFetched: ULONG): HRESULT; stdcall;
    function Skip(cMediaTypes: ULONG): HRESULT; stdcall;
    function Reset: HRESULT; stdcall;
    function Clone(out ppEnum: IEnumMediaTypes): HRESULT; stdcall;
  end;

// *********************************************************************//

  IPin = interface(IUnknown)
    ['{56A86891-0AD4-11CE-B03A-0020AF0BA770}']
    function Connect(pReceivePin: IPin; const pmt: TAM_Media_Type): HRESULT; stdcall;
    function ReceiveConnection(pConnector: IPin; const pmt: TAM_Media_Type): HRESULT; stdcall;
    function Disconnect: HRESULT; stdcall;
    function ConnectedTo(out pPin: IPin): HRESULT; stdcall;
    function ConnectionMediaType(var pmt: TAM_Media_Type): HRESULT; stdcall;
    function QueryPinInfo(var pInfo: TPin_Info): HRESULT; stdcall;
    function QueryDirection(var pPinDir: TPin_Direction): HRESULT; stdcall;
    function QueryId(var Id: LPWSTR): HRESULT; stdcall;
    function QueryAccept(const pmt: TAM_Media_Type): HRESULT; stdcall;
    function EnumMediaTypes(out ppEnum: IEnumMediaTypes): HRESULT; stdcall;
    function QueryInternalConnections(out apPin: IPin; var nPin: ULONG): HRESULT; stdcall;
    function EndOfStream: HRESULT; stdcall;
    function BeginFlush: HRESULT; stdcall;
    function EndFlush: HRESULT; stdcall;
    function NewSegment(tStart, tStop: TReference_Time; dRate: double): HRESULT; stdcall;
  end;

// *********************************************************************//

  IEnumPins = interface(IUnknown)
    ['{56A86892-0AD4-11CE-B03A-0020AF0BA770}']
    function Next(cPins: ULONG; out ppPins: IPin; var pcFetched: ULONG): HRESULT; stdcall;
    function Skip(cPins: ULONG): HRESULT; stdcall;
    function Reset: HRESULT; stdcall;
    function Clone(out ppEnum: IEnumPins): HRESULT; stdcall;
  end;

// *********************************************************************//

  IFilterGraph = interface;

  TFilterInfo = record
    achName: array[0..127] of WCHAR;
    pGraph: IFilterGraph;
  end;

// *********************************************************************//

  IBaseFilter = interface(IMediaFilter)
    ['{56A86895-0AD4-11CE-B03A-0020AF0BA770}']
    function EnumPins(out ppEnum: IEnumPins): HRESULT; stdcall;
    function FindPin(Id: LPCWSTR; out ppPin: IPin): HRESULT; stdcall;
    function QueryFilterInfo(var pInfo: TFilterInfo): HRESULT; stdcall;
    function JoinFilterGraph(pGraph: IFilterGraph; pName: LPCWSTR): HRESULT; stdcall;
    function QueryVendorInfo(var pVendorInfo: LPWSTR): HRESULT; stdcall;
  end;

// *********************************************************************//

  IEnumFilters = interface(IUnknown)
    ['{56A86893-0AD4-11CE-B03A-0020AF0BA770}']
    function Next(cFilters: ULONG; out ppFilter: IBaseFilter;
        var pcFetched: ULONG): HRESULT; stdcall;
    function Skip(cFilters: ULONG): HRESULT; stdcall;
    function Reset: HRESULT; stdcall;
    function Clone(out ppEnum: IEnumFilters): HRESULT; stdcall;
  end;

// *********************************************************************//

  IFilterGraph = interface(IUnknown)
    ['{56A8689F-0AD4-11CE-B03A-0020AF0BA770}']
    function AddFilter(pFilter: IBaseFilter; pName: LPCWSTR): HRESULT; stdcall;
    function RemoveFilter(pFilter: IBaseFilter): HRESULT; stdcall;
    function EnumFilters(out ppEnum: IEnumFilters): HRESULT; stdcall;
    function FindFilterByName(pName: LPCWSTR; out ppFilter: IBaseFilter): HRESULT; stdcall;
    function ConnectDirect(ppinOut, ppinIn: IPin; const pmt: TAM_Media_Type): HRESULT; stdcall;
    function Reconnect(ppin: IPin): HRESULT; stdcall;
    function Disconnect(ppin: IPin): HRESULT; stdcall;
    function SetDefaultSyncSource: HRESULT; stdcall;
  end;

// *********************************************************************//

  IGraphBuilder = interface(IFilterGraph)
    ['{56A868A9-0AD4-11CE-B03A-0020AF0BA770}']
    function Connect(ppinOut, ppinIn: IPin): HRESULT; stdcall;
    function Render(ppinOut: IPin): HRESULT; stdcall;
    function RenderFile(lpcwstrFile, lpcwstrPlayList: LPCWSTR): HRESULT; stdcall;
    function AddSourceFilter(lpcwstrFileName, lpcwstrFilterName: LPCWSTR;
        out ppFilter: IBaseFilter): HRESULT; stdcall;
    function SetLogFile(hFile: THandle): HRESULT; stdcall;
    function Abort: HRESULT; stdcall;
    function ShouldOperationContinue: HRESULT; stdcall;
  end;

// *********************************************************************//

  IFileSinkFilter = interface(IUnknown)
    ['{A2104830-7C70-11CF-8BCE-00AA00A3F1A6}']
    function SetFileName(pszFileName: POLESTR; const pmt: TAM_Media_Type): HRESULT; stdcall;
    function GetCurFile(var ppszFileName: POLESTR; var pmt: TAM_Media_Type): HRESULT; stdcall;
  end;

// *********************************************************************//

  IAMCopyCaptureFileProgress = interface(IUnknown)
    ['{670D1D20-A068-11D0-B3F0-00AA003761C5}']
    function Progress(iProgress: Integer): HRESULT; stdcall;
  end;

// *********************************************************************//

  ICaptureGraphBuilder2 = interface(IUnknown)
    ['{93E5A4E0-2D50-11d2-ABFA-00A0C9C6E38D}']
    function SetFiltergraph(pfg: IGraphBuilder): HRESULT; stdcall;
    function GetFiltergraph(out ppfg: IGraphBuilder): HRESULT; stdcall;
    function SetOutputFileName(pType: PGUID; lpstrFile: PWCHAR; out ppf: IBaseFilter; out ppSink: IFileSinkFilter): HRESULT; stdcall;
    function FindInterface(pCategory, pType: PGUID; pf: IBaseFilter; riid: PGUID; out ppint): HRESULT; stdcall;
    function RenderStream(pCategory, pType: PGUID; pSource: IUnknown; pfCompressor, pfRenderer: IBaseFilter): HRESULT; stdcall;
    function ControlStream(pCategory, pType: PGUID; pFilter: IBaseFilter; pstart, pstop: TREFERENCE_TIME; wStartCookie, wStopCookie: WORD ): HRESULT; stdcall;
    function AllocCapFile(lpstr: PWCHAR; dwlSize: Comp): HRESULT; stdcall;
    function CopyCaptureFile(lpwstrOld, lpwstrNew: PWCHAR; fAllowEscAbort: Integer; pCallback: IAMCopyCaptureFileProgress): HRESULT; stdcall;
    function FindPin(pSource: IUnknown; pindir: TPIN_DIRECTION; pCategory, pType: PGUID; fUnconnected: BOOL; num: integer; out ppPin: IPin): HRESULT; stdcall;
  end;

// *********************************************************************//

  OAHWND = Longint;

// *********************************************************************//

  IVideoWindow = interface(IDispatch)
    ['{56A868B4-0AD4-11CE-B03A-0020AF0BA770}']
    (* IVideoWindow methods *)
    function put_Caption(strCaption: TBSTR): HResult; stdcall;
    function get_Caption(var strCaption: TBSTR): HResult; stdcall;
    function put_WindowStyle(WindowStyle: Longint): HResult; stdcall;
    function get_WindowStyle(var WindowStyle: Longint): HResult; stdcall;
    function put_WindowStyleEx(WindowStyleEx: Longint): HResult; stdcall;
    function get_WindowStyleEx(var WindowStyleEx: Longint): HResult; stdcall;
    function put_AutoShow(AutoShow: LongBool): HResult; stdcall;
    function get_AutoShow(var AutoShow: LongBool): HResult; stdcall;
    function put_WindowState(WindowState: Longint): HResult; stdcall;
    function get_WindowState(var WindowState: Longint): HResult; stdcall;
    function put_BackgroundPalette(BackgroundPalette: Longint): HResult; stdcall;
    function get_BackgroundPalette(var pBackgroundPalette: Longint): HResult; stdcall;
    function put_Visible(Visible: LongBool): HResult; stdcall;
    function get_Visible(var pVisible: LongBool): HResult; stdcall;
    function put_Left(Left: Longint): HResult; stdcall;
    function get_Left(var pLeft: Longint): HResult; stdcall;
    function put_Width(Width: Longint): HResult; stdcall;
    function get_Width(var pWidth: Longint): HResult; stdcall;
    function put_Top(Top: Longint): HResult; stdcall;
    function get_Top(var pTop: Longint): HResult; stdcall;
    function put_Height(Height: Longint): HResult; stdcall;
    function get_Height(var pHeight: Longint): HResult; stdcall;
    function put_Owner(Owner: OAHWND): HResult; stdcall;
    function get_Owner(var Owner: OAHWND): HResult; stdcall;
    function put_MessageDrain(Drain: OAHWND): HResult; stdcall;
    function get_MessageDrain(var Drain: OAHWND): HResult; stdcall;
    function get_BorderColor(var Color: Longint): HResult; stdcall;
    function put_BorderColor(Color: Longint): HResult; stdcall;
    function get_FullScreenMode(var FullScreenMode: LongBool): HResult; stdcall;
    function put_FullScreenMode(FullScreenMode: LongBool): HResult; stdcall;
    function SetWindowForeground(Focus: Longint): HResult; stdcall;
    function NotifyOwnerMessage(hwnd: Longint; uMsg, wParam, lParam: Longint): HResult; stdcall;
    function SetWindowPosition(Left, Top, Width, Height: Longint): HResult; stdcall;
    function GetWindowPosition(var pLeft, pTop, pWidth, pHeight: Longint): HResult; stdcall;
    function GetMinIdealImageSize(var pWidth, pHeight: Longint): HResult; stdcall;
    function GetMaxIdealImageSize(var pWidth, pHeight: Longint): HResult; stdcall;
    function GetRestorePosition(var pLeft, pTop, pWidth, pHeight: Longint): HResult; stdcall;
    function HideCursor(HideCursor: LongBool): HResult; stdcall;
    function IsCursorHidden(var CursorHidden: LongBool): HResult; stdcall;
  end;

// *********************************************************************//

  OAFilterState = Longint;

// *********************************************************************//

  IMediaControl = interface(IDispatch)
    ['{56A868B1-0AD4-11CE-B03A-0020AF0BA770}']
    (* IMediaControl methods *)
    function Run: HResult; stdcall;
    function Pause: HResult; stdcall;
    function Stop: HResult; stdcall;
    function GetState(msTimeout: Longint; var pfs: OAFilterState): HResult; stdcall;
    function RenderFile(strFilename: TBSTR): HResult; stdcall;
    function AddSourceFilter(strFilename: TBSTR; ppUnk: IDispatch): HResult; stdcall;
    function get_FilterCollection(out ppUnk: IDispatch): HResult; stdcall;
    function get_RegFilterCollection(out ppUnk: IDispatch): HResult; stdcall;
    function StopWhenReady: HResult; stdcall;
  end;

// *********************************************************************//  

implementation

end.
