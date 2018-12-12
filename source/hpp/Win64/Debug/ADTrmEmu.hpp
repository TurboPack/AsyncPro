// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ADTrmEmu.pas' rev: 32.00 (Windows)

#ifndef AdtrmemuHPP
#define AdtrmemuHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.Clipbrd.hpp>
#include <Vcl.Menus.hpp>
#include <OoMisc.hpp>
#include <AdPort.hpp>
#include <AdExcept.hpp>
#include <ADTrmPsr.hpp>
#include <ADTrmMap.hpp>
#include <ADTrmBuf.hpp>
#include <System.UITypes.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adtrmemu
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TAdEmuCommandParamsItem;
class DELPHICLASS TAdEmuCommandParams;
class DELPHICLASS TAdEmuCommandListItem;
class DELPHICLASS TAdEmuCommandList;
class DELPHICLASS TAdCustomTerminal;
class DELPHICLASS TAdTerminalEmulator;
class DELPHICLASS TAdTerminal;
class DELPHICLASS TAdTTYEmulator;
class DELPHICLASS TAdVT100Emulator;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TAdCharSource : unsigned char { csUnknown, csKeyboard, csPort, csWriteChar };

enum DECLSPEC_DENUM TAdEmuCommand : unsigned char { ecNone, ecBell, ecBackspace, ecTabHorz, ecLF, ecCR, ecBackTabHorz, ecCursorDown, ecCursorLeft, ecCursorRight, ecCursorUp, ecCursorPos, ecDeleteChars, ecDeleteLines, ecInsertChars, ecInsertLines, ecEraseAll, ecEraseChars, ecEraseFromBOW, ecEraseFromBOL, ecEraseLine, ecEraseScreen, ecEraseToEOL, ecEraseToEOW, ecSetHorzTabStop, ecClearHorzTabStop, ecClearVertTabStop, ecClearAllHorzTabStops, ecSetVertTabStop, ecClearAllVertTabStops, ecSetScrollRegion, ecTabVert, ecBackTabVert, ecBackColor, ecForeColor, ecAbsAddress, ecNoAbsAddress, ecAutoWrap, ecNoAutoWrap, ecAutoWrapDelay, ecNoAutoWrapDelay, ecInsertMode, ecNoInsertMode, ecNewLineMode, ecNoNewLineMode, ecScrollRegion, ecNoScrollRegion, ecSetCharAttr, ecAddBold, 
	ecBoldOnly, ecRemoveBold, ecInvertBold, ecAddUnderLine, ecUnderlineOnly, ecRemoveUnderline, ecInvertUnderline, ecAddStrikethrough, ecStrikethroughOnly, ecRemoveStrikethrough, ecInvertStrikethrough, ecAddBlink, ecBlinkOnly, ecRemoveBlink, ecInvertBlink, ecAddReverse, ecReverseOnly, ecRemoveReverse, ecInvertReverse, ecAddInvisible, ecInvisibleOnly, ecRemoveInvisible, ecInvertInvisible, ecAddSelected, ecRemoveSelected, ecSelectedOnly, ecInvertSelected, ecRemoveAllAttr, ecRemoveAllAttrIgnoreSelect, ecClearAndHome, ecHome, ecCursorEOL, ecCursorBOL, ecCursorTop, ecCursorBottom, ecWriteString, ecColor, ecSaveCursorPos, ecRestoreCursorPos, ecDeviceAttributesReport, ecNEL, ecReset, ecAnswerback, ecDECALN, ecDeviceStatusReport, ecCursorOff, ecCursorUnderline, 
	ecCursorBlock };

enum DECLSPEC_DENUM TAdCaptureMode : unsigned char { cmOff, cmOn, cmAppend };

typedef void __fastcall (__closure *TAdTerminalCursorMovedEvent)(System::TObject* aSender, int aRow, int aCol);

enum DECLSPEC_DENUM TAdCursorType : unsigned char { ctNone, ctUnderline, ctBlock };

enum DECLSPEC_DENUM TAdVT100LineAttr : unsigned char { ltNormal, ltDblHeightTop, ltDblHeightBottom, ltDblWidth };

typedef void __fastcall (__closure *TAdOnProcessChar)(System::TObject* Sender, char Character, System::AnsiString &ReplaceWith, TAdEmuCommandList* Commands, TAdCharSource CharSource);

class PASCALIMPLEMENTATION TAdEmuCommandParamsItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
private:
	TAdEmuCommandParams* FCollection;
	System::UnicodeString FName;
	System::UnicodeString FValue;
	
public:
	__fastcall virtual TAdEmuCommandParamsItem(System::Classes::TCollection* Collection);
	__fastcall virtual ~TAdEmuCommandParamsItem(void);
	
__published:
	__property TAdEmuCommandParams* Collection = {read=FCollection, write=FCollection};
	__property System::UnicodeString Name = {read=FName, write=FName};
	__property System::UnicodeString Value = {read=FValue, write=FValue};
};


class PASCALIMPLEMENTATION TAdEmuCommandParams : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
private:
	System::Classes::TPersistent* FOwner;
	
protected:
	HIDESBASE TAdEmuCommandParamsItem* __fastcall GetItem(int Index);
	DYNAMIC System::Classes::TPersistent* __fastcall GetOwner(void);
	HIDESBASE void __fastcall SetItem(int Index, TAdEmuCommandParamsItem* Value);
	
public:
	__fastcall TAdEmuCommandParams(System::Classes::TPersistent* AOwner);
	int __fastcall FindName(System::UnicodeString AName);
	bool __fastcall GetBooleanValue(System::UnicodeString AName, int APosition, bool ADefault);
	int __fastcall GetIntegerValue(System::UnicodeString AName, int APosition, int ADefault);
	System::UnicodeString __fastcall GetStringValue(System::UnicodeString AName, int APosition, System::UnicodeString ADefault);
	System::Uitypes::TColor __fastcall GetTColorValue(System::UnicodeString AName, int APosition, System::Uitypes::TColor ADefault);
	__property TAdEmuCommandParamsItem* Items[int Index] = {read=GetItem, write=SetItem};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TAdEmuCommandParams(void) { }
	
};


class PASCALIMPLEMENTATION TAdEmuCommandListItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
private:
	TAdEmuCommandList* FCollection;
	TAdEmuCommand FCommand;
	TAdEmuCommandParams* FParams;
	
public:
	__fastcall virtual TAdEmuCommandListItem(System::Classes::TCollection* Collection);
	__fastcall virtual ~TAdEmuCommandListItem(void);
	void __fastcall AddBooleanArg(bool v);
	void __fastcall AddIntegerArg(int v);
	void __fastcall AddNamedBooleanArg(System::UnicodeString AName, bool v);
	void __fastcall AddNamedIntegerArg(System::UnicodeString AName, int v);
	void __fastcall AddNamedStringArg(System::UnicodeString AName, System::UnicodeString v);
	void __fastcall AddNamedTColorArg(System::UnicodeString AName, System::Uitypes::TColor v);
	void __fastcall AddStringArg(System::UnicodeString v);
	void __fastcall AddTColorArg(System::Uitypes::TColor v);
	
__published:
	__property TAdEmuCommandList* Collection = {read=FCollection, write=FCollection};
	__property TAdEmuCommand Command = {read=FCommand, write=FCommand, nodefault};
	__property TAdEmuCommandParams* Params = {read=FParams, write=FParams};
};


class PASCALIMPLEMENTATION TAdEmuCommandList : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
private:
	System::Classes::TPersistent* FOwner;
	
protected:
	HIDESBASE TAdEmuCommandListItem* __fastcall GetItem(int Index);
	DYNAMIC System::Classes::TPersistent* __fastcall GetOwner(void);
	HIDESBASE void __fastcall SetItem(int Index, TAdEmuCommandListItem* Value);
	
public:
	__fastcall TAdEmuCommandList(System::Classes::TPersistent* AOwner);
	TAdEmuCommandListItem* __fastcall AddCommand(TAdEmuCommand ACommand);
	__property TAdEmuCommandListItem* Items[int Index] = {read=GetItem, write=SetItem};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TAdEmuCommandList(void) { }
	
};


class PASCALIMPLEMENTATION TAdCustomTerminal : public Oomisc::TApdBaseWinControl
{
	typedef Oomisc::TApdBaseWinControl inherited;
	
private:
	bool FActive;
	int FBlinkTime;
	int FBlinkTimeCount;
	bool FBlinkTextVisible;
	Vcl::Forms::TFormBorderStyle FBorderStyle;
	void *FByteQueue;
	TAdCaptureMode FCapture;
	System::UnicodeString FCaptureFile;
	System::Classes::TFileStream* FCaptureStream;
	Vcl::Graphics::TCanvas* FCanvas;
	int FCharHeight;
	int FCharWidth;
	int FClientCols;
	int FClientFullCols;
	int FClientRows;
	int FClientFullRows;
	Adport::TApdCustomComPort* FComPort;
	bool FCreatedCaret;
	TAdCursorType FCursorType;
	TAdTerminalEmulator* FDefEmulator;
	TAdTerminalEmulator* FEmulator;
	bool FHalfDuplex;
	bool FHaveSelection;
	Vcl::Extctrls::TTimer* FHeartbeat;
	int FLazyByteCount;
	int FLazyTimeCount;
	int FLazyByteDelay;
	int FLazyTimeDelay;
	System::Types::TPoint FLButtonAnchor;
	bool FLButtonDown;
	System::Types::TRect FLButtonRect;
	TAdTerminalCursorMovedEvent FOnCursorMoved;
	int FOriginCol;
	int FOriginRow;
	bool FScrollback;
	bool FFreezeScrollBack;
	tagSCROLLINFO FScrollHorzInfo;
	tagSCROLLINFO FScrollVertInfo;
	bool FShowingCaret;
	bool FTriggerHandlerOn;
	System::Types::TRect FUsedRect;
	bool FUseLazyDisplay;
	System::Types::TRect FUnusedRightRect;
	System::Types::TRect FUnusedBottomRect;
	bool FUseHScrollBar;
	bool FUseVScrollBar;
	bool FWantAllKeys;
	bool FWaitingForComPortOpen;
	bool FWaitingForPort;
	bool FMouseSelect;
	bool FAutoCopy;
	bool FAutoScrollback;
	bool FHideScrollbars;
	bool FHideScrollbarHActive;
	bool FHideScrollBarVActive;
	bool FFollowCursor;
	bool FPasteToPort;
	bool FPasteToScreen;
	int FCharHPadding;
	int FCharVPadding;
	
protected:
	virtual void __fastcall Loaded(void);
	void __fastcall tmFollowCursor(void);
	Adtrmbuf::TAdTerminalCharAttrs __fastcall tmGetAttributes(int aRow, int aCol);
	System::Uitypes::TColor __fastcall tmGetBackColor(int aRow, int aCol);
	System::Byte __fastcall tmGetCharSet(int aRow, int aCol);
	int __fastcall tmGetColumns(void);
	TAdTerminalEmulator* __fastcall tmGetEmulator(void);
	System::Uitypes::TColor __fastcall tmGetForeColor(int aRow, int aCol);
	System::AnsiString __fastcall tmGetLine(int aRow);
	int __fastcall tmGetRows(void);
	int __fastcall tmGetScrollbackRows(void);
	void __fastcall tmSetActive(bool aValue);
	void __fastcall tmSetAttributes(int aRow, int aCol, const Adtrmbuf::TAdTerminalCharAttrs aAttr);
	void __fastcall tmSetAutoCopy(const bool v);
	void __fastcall tmSetAutoScrollback(const bool v);
	void __fastcall tmSetBackColor(int aRow, int aCol, System::Uitypes::TColor aValue);
	void __fastcall tmSetBlinkTime(int aValue);
	void __fastcall tmSetBorderStyle(Vcl::Forms::TBorderStyle aBS);
	void __fastcall tmSetCapture(TAdCaptureMode aValue);
	void __fastcall tmSetCaptureFile(const System::UnicodeString aValue);
	void __fastcall tmSetCharHPadding(const int v);
	void __fastcall tmSetCharSet(int aRow, int aCol, System::Byte aValue);
	void __fastcall tmSetCharVPadding(const int v);
	void __fastcall tmSetComPort(Adport::TApdCustomComPort* aValue);
	void __fastcall tmSetColumns(int aValue);
	void __fastcall tmSetCursorType(TAdCursorType aValue);
	void __fastcall tmSetFollowCursor(const bool v);
	void __fastcall tmSetForeColor(int aRow, int aCol, System::Uitypes::TColor aValue);
	void __fastcall tmSetEmulator(TAdTerminalEmulator* aValue);
	void __fastcall tmSetHideScrollbars(const bool v);
	void __fastcall tmSetLazyByteDelay(int aValue);
	void __fastcall tmSetLazyTimeDelay(int aValue);
	void __fastcall tmSetLine(int aRow, const System::AnsiString aValue);
	void __fastcall tmSetMouseSelect(const bool v);
	void __fastcall tmSetOriginCol(int aValue);
	void __fastcall tmSetOriginRow(int aValue);
	void __fastcall tmSetPasteToPort(const bool v);
	void __fastcall tmSetPasteToScreen(const bool v);
	void __fastcall tmSetRows(int aValue);
	void __fastcall tmSetScrollback(bool aValue);
	void __fastcall tmSetScrollbackRows(int aValue);
	void __fastcall tmSetUseLazyDisplay(bool aValue);
	void __fastcall tmSetWantAllKeys(bool aValue);
	void __fastcall tmSetFreezeScrollBack(bool v);
	void __fastcall tmDrawDefaultText(void);
	void __fastcall tmAttachToComPort(void);
	void __fastcall tmCalcExtent(void);
	void __fastcall tmDetachFromComPort(void);
	void __fastcall tmGetFontInfo(void);
	void __fastcall tmInvalidateRow(int aRow);
	void __fastcall tmFreeCaret(void);
	void __fastcall tmHideCaret(void);
	void __fastcall tmMakeCaret(void);
	void __fastcall tmPositionCaret(void);
	void __fastcall tmShowCaret(void);
	void __fastcall tmInitHScrollBar(void);
	void __fastcall tmInitVScrollBar(void);
	bool __fastcall tmNeedHScrollbar(void);
	bool __fastcall tmNeedVScrollbar(void);
	void __fastcall tmRemoveHScrollBar(void);
	void __fastcall tmRemoveVScrollBar(void);
	void __fastcall tmScrollHorz(int aDist);
	void __fastcall tmScrollVert(int aDist);
	void __fastcall tmGrowSelect(int X, int Y);
	void __fastcall tmMarkDeselected(int aRow, int aFromCol, int aToCol);
	void __fastcall tmMarkSelected(int aRow, int aFromCol, int aToCol);
	bool __fastcall tmProcessClipboardCopy(Winapi::Messages::TWMKey &Msg);
	void __fastcall tmStartSelect(int X, int Y);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	virtual void __fastcall PaintWindow(HDC DC);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	MESSAGE void __fastcall ApwPortOpen(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall ApwPortClose(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall ApwPortClosing(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall ApwTermForceSize(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall ApwTermNeedsUpdate(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall ApwTermStuff(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall AwpWaitForPort(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMCtl3DChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CNKeyDown(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall CNSysKeyDown(Winapi::Messages::TWMKey &Msg);
	void __fastcall tmBeat(System::TObject* Sender);
	void __fastcall tmTriggerHandler(unsigned Msg, unsigned wParam, int lParam);
	HIDESBASE MESSAGE void __fastcall WMCancelMode(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall WMCopy(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall WMGetDlgCode(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMHScroll(Winapi::Messages::TWMScroll &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMSetFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMPaint(Winapi::Messages::TWMPaint &Msg);
	MESSAGE void __fastcall WMPaste(Winapi::Messages::TWMNoParams &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMSize(Winapi::Messages::TWMSize &Msg);
	HIDESBASE MESSAGE void __fastcall WMVScroll(Winapi::Messages::TWMScroll &Msg);
	void __fastcall Paint(void);
	
public:
	__fastcall virtual TAdCustomTerminal(System::Classes::TComponent* aOwner);
	__fastcall virtual ~TAdCustomTerminal(void);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall DestroyWnd(void);
	void __fastcall Clear(void);
	void __fastcall ClearAll(void);
	void __fastcall CopyToClipboard(void);
	int __fastcall GetTotalCharWidth(void);
	int __fastcall GetTotalCharHeight(void);
	void __fastcall HideSelection(void);
	void __fastcall WriteChar(char aCh);
	void __fastcall WriteString(const System::UnicodeString aSt)/* overload */;
	void __fastcall WriteString(const System::AnsiString aSt)/* overload */;
	void __fastcall WriteCharSource(char aCh, TAdCharSource Source);
	void __fastcall WriteStringSource(const System::AnsiString aSt, TAdCharSource Source);
	bool __fastcall HasFocus(void);
	void __fastcall PasteFromClipboard(void);
	__property Adtrmbuf::TAdTerminalCharAttrs Attributes[int aRow][int aCol] = {read=tmGetAttributes, write=tmSetAttributes};
	__property System::Uitypes::TColor BackColor[int aRow][int aCol] = {read=tmGetBackColor, write=tmSetBackColor};
	__property Color = {default=-16777211};
	__property Vcl::Graphics::TCanvas* Canvas = {read=FCanvas};
	__property int CharHeight = {read=FCharHeight, nodefault};
	__property int CharHPadding = {read=FCharHPadding, write=tmSetCharHPadding, default=0};
	__property System::Byte CharSet[int aRow][int aCol] = {read=tmGetCharSet, write=tmSetCharSet};
	__property int CharVPadding = {read=FCharVPadding, write=tmSetCharVPadding, default=0};
	__property int CharWidth = {read=FCharWidth, nodefault};
	__property int ClientCols = {read=FClientCols, nodefault};
	__property int ClientRows = {read=FClientRows, nodefault};
	__property int ClientOriginCol = {read=FOriginCol, write=tmSetOriginCol, nodefault};
	__property int ClientOriginRow = {read=FOriginRow, write=tmSetOriginRow, nodefault};
	__property System::Uitypes::TColor ForeColor[int aRow][int aCol] = {read=tmGetForeColor, write=tmSetForeColor};
	__property bool HaveSelection = {read=FHaveSelection, nodefault};
	__property System::AnsiString Line[int aRow] = {read=tmGetLine, write=tmSetLine};
	__property TAdTerminalEmulator* Emulator = {read=tmGetEmulator, write=tmSetEmulator};
	__property bool Active = {read=FActive, write=tmSetActive, default=1};
	__property bool AutoCopy = {read=FAutoCopy, write=tmSetAutoCopy, default=1};
	__property bool AutoScrollback = {read=FAutoScrollback, write=tmSetAutoScrollback, default=1};
	__property int BlinkTime = {read=FBlinkTime, write=tmSetBlinkTime, default=500};
	__property Vcl::Forms::TBorderStyle BorderStyle = {read=FBorderStyle, write=tmSetBorderStyle, default=1};
	__property TAdCaptureMode Capture = {read=FCapture, write=tmSetCapture, default=0};
	__property System::UnicodeString CaptureFile = {read=FCaptureFile, write=tmSetCaptureFile};
	__property int Columns = {read=tmGetColumns, write=tmSetColumns, default=80};
	__property Adport::TApdCustomComPort* ComPort = {read=FComPort, write=tmSetComPort};
	__property TAdCursorType CursorType = {read=FCursorType, write=tmSetCursorType, default=2};
	__property bool FollowCursor = {read=FFollowCursor, write=tmSetFollowCursor, default=1};
	__property bool HalfDuplex = {read=FHalfDuplex, write=FHalfDuplex, default=0};
	__property bool HideScrollbars = {read=FHideScrollbars, write=tmSetHideScrollbars, default=0};
	__property int LazyByteDelay = {read=FLazyByteDelay, write=tmSetLazyByteDelay, default=200};
	__property int LazyTimeDelay = {read=FLazyTimeDelay, write=tmSetLazyTimeDelay, default=100};
	__property bool MouseSelect = {read=FMouseSelect, write=tmSetMouseSelect, default=1};
	__property bool PasteToPort = {read=FPasteToPort, write=tmSetPasteToPort, default=0};
	__property bool PasteToScreen = {read=FPasteToScreen, write=tmSetPasteToScreen, default=0};
	__property int Rows = {read=tmGetRows, write=tmSetRows, default=24};
	__property int ScrollbackRows = {read=tmGetScrollbackRows, write=tmSetScrollbackRows, default=200};
	__property bool Scrollback = {read=FScrollback, write=tmSetScrollback, nodefault};
	__property bool UseLazyDisplay = {read=FUseLazyDisplay, write=tmSetUseLazyDisplay, default=1};
	__property bool UsingHScrollBar = {read=FUseHScrollBar, nodefault};
	__property bool UsingVScrollBar = {read=FUseVScrollBar, nodefault};
	__property bool WantAllKeys = {read=FWantAllKeys, write=tmSetWantAllKeys, default=1};
	__property bool FreezeScrollBack = {read=FFreezeScrollBack, write=tmSetFreezeScrollBack, default=1};
	__property TAdTerminalCursorMovedEvent OnCursorMoved = {read=FOnCursorMoved, write=FOnCursorMoved};
public:
	/* TWinControl.CreateParented */ inline __fastcall TAdCustomTerminal(HWND ParentWindow) : Oomisc::TApdBaseWinControl(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TAdTerminalEmulator : public Oomisc::TApdBaseComponent
{
	typedef Oomisc::TApdBaseComponent inherited;
	
private:
	System::UnicodeString FAnswerback;
	Adtrmbuf::TAdTerminalBuffer* FTerminalBuffer;
	Adtrmmap::TAdCharSetMapping* FCharSetMapping;
	bool FIsDefault;
	Adtrmmap::TAdKeyboardMapping* FKeyboardMapping;
	Adtrmpsr::TAdTerminalParser* FParser;
	TAdCustomTerminal* FTerminal;
	Adtrmbuf::TAdTerminalCharAttrs FSavedAttrs;
	System::Uitypes::TColor FSavedBackColor;
	System::Byte FSavedCharSet;
	int FSavedCol;
	System::Uitypes::TColor FSavedForeColor;
	int FSavedRow;
	TAdOnProcessChar FOnProcessChar;
	TAdEmuCommandList* FCommandList;
	
protected:
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	bool __fastcall IsAnswerbackStored(void);
	void __fastcall ReadAnswerback(System::Classes::TReader* Reader);
	void __fastcall WriteAnswerback(System::Classes::TWriter* Writer);
	virtual bool __fastcall teGetNeedsUpdate(void);
	virtual void __fastcall teSetTerminal(TAdCustomTerminal* aValue);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall teClear(void);
	virtual void __fastcall teClearAll(void);
	virtual void __fastcall teSendChar(char aCh, bool aCanEcho, TAdCharSource CharSource);
	void __fastcall teHandleCursorMovement(System::TObject* Sender, int Row, int Col);
	void __fastcall teClearCommandList(void);
	void __fastcall teProcessCommand(TAdEmuCommand Command, TAdEmuCommandParams* Params);
	void __fastcall teProcessCommandList(TAdEmuCommandList* CommandList);
	__property Adtrmbuf::TAdTerminalBuffer* TerminalBuffer = {read=FTerminalBuffer, write=FTerminalBuffer};
	
public:
	__fastcall virtual TAdTerminalEmulator(System::Classes::TComponent* aOwner);
	__fastcall virtual ~TAdTerminalEmulator(void);
	virtual void __fastcall BlinkPaint(bool aVisible);
	void __fastcall ExecuteTerminalCommands(TAdEmuCommandList* CommandList);
	virtual bool __fastcall HasBlinkingText(void);
	virtual void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	virtual void __fastcall KeyPress(System::WideChar &Key);
	virtual void __fastcall LazyPaint(void);
	virtual void __fastcall Paint(void);
	virtual void __fastcall ProcessBlock(void * aData, int aDataLen, TAdCharSource CharSource);
	virtual void __fastcall GetCursorPos(int &aRow, int &aCol);
	__property System::UnicodeString Answerback = {read=FAnswerback, write=FAnswerback};
	__property Adtrmbuf::TAdTerminalBuffer* Buffer = {read=FTerminalBuffer};
	__property Adtrmmap::TAdCharSetMapping* CharSetMapping = {read=FCharSetMapping};
	__property Adtrmmap::TAdKeyboardMapping* KeyboardMapping = {read=FKeyboardMapping};
	__property Adtrmpsr::TAdTerminalParser* Parser = {read=FParser};
	__property bool NeedsUpdate = {read=teGetNeedsUpdate, nodefault};
	__property TAdOnProcessChar OnProcessChar = {read=FOnProcessChar, write=FOnProcessChar};
	
__published:
	__property TAdCustomTerminal* Terminal = {read=FTerminal, write=teSetTerminal};
};


class PASCALIMPLEMENTATION TAdTerminal : public TAdCustomTerminal
{
	typedef TAdCustomTerminal inherited;
	
__published:
	__property Active = {default=1};
	__property AutoCopy = {default=1};
	__property AutoScrollback = {default=1};
	__property BlinkTime = {default=500};
	__property BorderStyle = {default=1};
	__property Capture = {default=0};
	__property CaptureFile = {default=0};
	__property Columns = {default=80};
	__property ComPort;
	__property CursorType = {default=2};
	__property FollowCursor = {default=1};
	__property HalfDuplex = {default=0};
	__property HideScrollbars = {default=0};
	__property LazyByteDelay = {default=200};
	__property LazyTimeDelay = {default=100};
	__property MouseSelect = {default=1};
	__property PasteToPort = {default=0};
	__property PasteToScreen = {default=0};
	__property Rows = {default=24};
	__property ScrollbackRows = {default=200};
	__property Scrollback;
	__property UseLazyDisplay = {default=1};
	__property WantAllKeys = {default=1};
	__property FreezeScrollBack = {default=1};
	__property OnCursorMoved;
	__property Align = {default=0};
	__property Color = {default=-16777211};
	__property Ctl3D;
	__property Emulator;
	__property Enabled = {default=1};
	__property Font;
	__property Height;
	__property ParentColor = {default=1};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property TabOrder = {default=-1};
	__property TabStop = {default=0};
	__property Visible = {default=1};
	__property Width;
	__property PopupMenu;
	__property OnClick;
	__property OnDblClick;
	__property OnExit;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
public:
	/* TAdCustomTerminal.Create */ inline __fastcall virtual TAdTerminal(System::Classes::TComponent* aOwner) : TAdCustomTerminal(aOwner) { }
	/* TAdCustomTerminal.Destroy */ inline __fastcall virtual ~TAdTerminal(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TAdTerminal(HWND ParentWindow) : TAdCustomTerminal(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TAdTTYEmulator : public TAdTerminalEmulator
{
	typedef TAdTerminalEmulator inherited;
	
private:
	Adtrmpsr::TAdIntegerArray *FCellWidths;
	char *FDisplayStr;
	int FDisplayStrSize;
	void *FPaintFreeList;
	bool FRefresh;
	
protected:
	virtual bool __fastcall teGetNeedsUpdate(void);
	virtual void __fastcall teClear(void);
	virtual void __fastcall teClearAll(void);
	virtual void __fastcall teSetTerminal(TAdCustomTerminal* aValue);
	TAdEmuCommand __fastcall ttyCharToCommand(char aCh);
	void __fastcall ttyDrawChars(int aRow, int aStartCol, int aEndCol, bool aVisible);
	void __fastcall ttyExecutePaintScript(int aRow, void * aScript);
	void __fastcall ttyFreeAllPaintNodes(void);
	void __fastcall ttyFreePaintNode(void * aNode);
	void * __fastcall ttyNewPaintNode(void);
	
public:
	__fastcall virtual TAdTTYEmulator(System::Classes::TComponent* aOwner);
	__fastcall virtual ~TAdTTYEmulator(void);
	virtual void __fastcall KeyPress(System::WideChar &Key);
	virtual void __fastcall LazyPaint(void);
	virtual void __fastcall Paint(void);
	virtual void __fastcall ProcessBlock(void * aData, int aDataLen, TAdCharSource CharSource);
	
__published:
	__property OnProcessChar;
};


class PASCALIMPLEMENTATION TAdVT100Emulator : public TAdTerminalEmulator
{
	typedef TAdTerminalEmulator inherited;
	
private:
	void *FBlinkers;
	void *FBlinkFreeList;
	Adtrmpsr::TAdIntegerArray *FCellWidths;
	char *FDisplayStr;
	int FDisplayStrSize;
	bool FDispUpperASCII;
	int FLEDs;
	System::TObject* FLineAttrArray;
	void *FPaintFreeList;
	bool FRefresh;
	Vcl::Graphics::TFont* FSecondaryFont;
	bool FANSIMode;
	bool FAppKeyMode;
	bool FAppKeypadMode;
	bool FAutoRepeat;
	bool FCol132Mode;
	bool FGPOMode;
	bool FInsertMode;
	bool FInterlace;
	bool FNewLineMode;
	bool FRelOriginMode;
	bool FRevScreenMode;
	bool FSmoothScrollMode;
	bool FWrapAround;
	bool FUsingG1;
	int FG0CharSet;
	int FG1CharSet;
	
protected:
	virtual bool __fastcall teGetNeedsUpdate(void);
	void __fastcall vttSetCol132Mode(bool aValue);
	void __fastcall vttSetRelOriginMode(bool aValue);
	void __fastcall vttSetRevScreenMode(bool aValue);
	virtual void __fastcall teClear(void);
	virtual void __fastcall teClearAll(void);
	virtual void __fastcall teSetTerminal(TAdCustomTerminal* aValue);
	void __fastcall vttDrawChars(int aRow, int aStartVal, int aEndVal, bool aVisible, bool aCharValues);
	void __fastcall vttProcessCommand(void);
	System::UnicodeString __fastcall vttGenerateDECREPTPARM(int aArg);
	void __fastcall vttInvalidateRow(int aRow);
	void __fastcall vttProcess8bitChar(char aCh);
	void __fastcall vttScrollRowsHandler(System::TObject* aSender, int aCount, int aTop, int aBottom);
	void __fastcall vttToggleNumLock(void);
	void __fastcall vttCalcBlinkScript(void);
	void __fastcall vttClearBlinkScript(void);
	void __fastcall vttDrawBlinkOffCycle(int aRow, int aStartCh, int aEndCh);
	void __fastcall vttFreeAllBlinkNodes(void);
	void __fastcall vttFreeBlinkNode(void * aNode);
	void * __fastcall vttNewBlinkNode(void);
	void __fastcall vttExecutePaintScript(int aRow, void * aScript);
	void __fastcall vttFreeAllPaintNodes(void);
	void __fastcall vttFreePaintNode(void * aNode);
	void * __fastcall vttNewPaintNode(void);
	
public:
	__fastcall virtual TAdVT100Emulator(System::Classes::TComponent* aOwner);
	__fastcall virtual ~TAdVT100Emulator(void);
	virtual void __fastcall BlinkPaint(bool aVisible);
	virtual bool __fastcall HasBlinkingText(void);
	virtual void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	virtual void __fastcall KeyPress(System::WideChar &Key);
	virtual void __fastcall LazyPaint(void);
	virtual void __fastcall Paint(void);
	virtual void __fastcall ProcessBlock(void * aData, int aDataLen, TAdCharSource CharSource);
	__property bool ANSIMode = {read=FANSIMode, write=FANSIMode, nodefault};
	__property bool AppKeyMode = {read=FAppKeyMode, write=FAppKeyMode, nodefault};
	__property bool AppKeypadMode = {read=FAppKeypadMode, write=FAppKeypadMode, nodefault};
	__property bool AutoRepeat = {read=FAutoRepeat, write=FAutoRepeat, nodefault};
	__property bool Col132Mode = {read=FCol132Mode, write=vttSetCol132Mode, nodefault};
	__property bool GPOMode = {read=FGPOMode, write=FGPOMode, nodefault};
	__property bool InsertMode = {read=FInsertMode, write=FInsertMode, nodefault};
	__property bool Interlace = {read=FInterlace, write=FInterlace, nodefault};
	__property bool NewLineMode = {read=FNewLineMode, write=FNewLineMode, nodefault};
	__property bool RelOriginMode = {read=FRelOriginMode, write=vttSetRelOriginMode, nodefault};
	__property bool RevScreenMode = {read=FRevScreenMode, write=vttSetRevScreenMode, nodefault};
	__property bool SmoothScrollMode = {read=FSmoothScrollMode, write=FSmoothScrollMode, nodefault};
	__property bool WrapAround = {read=FWrapAround, write=FWrapAround, nodefault};
	__property int LEDs = {read=FLEDs, write=FLEDs, nodefault};
	
__published:
	__property Answerback = {default=0};
	__property bool DisplayUpperASCII = {read=FDispUpperASCII, write=FDispUpperASCII, nodefault};
	__property OnProcessChar;
};


//-- var, const, procedure ---------------------------------------------------
static const bool adc_TermActive = true;
static const int adc_TermBackColor = int(0);
static const System::Word adc_TermBlinkTime = System::Word(0x1f4);
static const Vcl::Forms::TFormBorderStyle adc_TermBorderStyle = (Vcl::Forms::TFormBorderStyle)(1);
static const TAdCaptureMode adc_TermCapture = (TAdCaptureMode)(0);
#define adc_TermCaptureFile L"APROTERM.CAP"
static const System::Int8 adc_TermColumnCount = System::Int8(0x50);
static const TAdCursorType adc_TermCursorType = (TAdCursorType)(2);
#define adc_TermFontName L"Terminal"
static const int adc_TermForeColor = int(12632256);
static const bool adc_TermHalfDuplex = false;
static const System::Byte adc_TermHeight = System::Byte(0xc8);
static const System::Byte adc_TermLazyByteDelay = System::Byte(0xc8);
static const System::Int8 adc_TermLazyTimeDelay = System::Int8(0x64);
static const System::Int8 adc_TermRowCount = System::Int8(0x18);
static const bool adc_TermScrollback = false;
static const System::Byte adc_TermScrollRowCount = System::Byte(0xc8);
static const bool adc_TermUseLazyDisplay = true;
static const bool adc_TermWantAllKeys = true;
static const System::Word adc_TermWidth = System::Word(0x12c);
static const bool adc_FreezeScrollback = true;
static const bool adc_TermMouseSelect = true;
static const bool adc_TermAutoCopy = true;
static const bool adc_TermAutoScrollback = true;
static const bool adc_TermHideScrollbars = false;
static const bool adc_TermFollowsCursor = true;
static const bool adc_TermPasteToPort = false;
static const bool adc_TermPasteToScreen = false;
static const bool adc_VT100ANSIMode = true;
#define adc_VT100Answerback L"APROterm"
static const bool adc_VT100AppKeyMode = false;
static const bool adc_VT100AppKeypadMode = false;
static const bool adc_VT100AutoRepeat = true;
static const bool adc_VT100Col132Mode = false;
static const System::Int8 adc_VT100G0CharSet = System::Int8(0x0);
static const System::Int8 adc_VT100G1CharSet = System::Int8(0x0);
static const bool adc_VT100GPOMode = false;
static const bool adc_VT100InsertMode = false;
static const bool adc_VT100Interlace = false;
static const bool adc_VT100NewLineMode = false;
static const bool adc_VT100RelOriginMode = false;
static const bool adc_VT100RevScreenMode = false;
static const bool adc_VT100SmoothScrollMode = false;
static const bool adc_VT100WrapAround = true;
}	/* namespace Adtrmemu */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADTRMEMU)
using namespace Adtrmemu;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdtrmemuHPP
