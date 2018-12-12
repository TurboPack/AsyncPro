// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdStMach.pas' rev: 32.00 (Windows)

#ifndef AdstmachHPP
#define AdstmachHPP

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
#include <Vcl.Controls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.StdCtrls.hpp>
#include <OoMisc.hpp>
#include <AdPacket.hpp>
#include <AdPort.hpp>
#include <AdExcept.hpp>
#include <AdStrMap.hpp>
#include <System.TypInfo.hpp>
#include <System.UITypes.hpp>
#include <Vcl.Menus.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adstmach
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TApdStateCustomDataSource;
class DELPHICLASS TApdStateComPortSource;
class DELPHICLASS TApdStateConnectoid;
class DELPHICLASS TApdStateCondition;
class DELPHICLASS TApdStateConditions;
class DELPHICLASS TApdCustomStateMachine;
class DELPHICLASS TApdCustomState;
class DELPHICLASS TApdStateMachine;
class DELPHICLASS TApdState;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TApdConnectAddType : unsigned char { atAdd, atSub, atNone };

enum DECLSPEC_DENUM TAdConnectoidClickStyle : unsigned char { ccsHighlight, ccsHint, ccsDashedLine };

typedef System::Set<TAdConnectoidClickStyle, TAdConnectoidClickStyle::ccsHighlight, TAdConnectoidClickStyle::ccsDashedLine> TAdConnectoidClickStyles;

typedef void __fastcall (__closure *TApdOnConnectoidClickEvent)(System::TObject* Sender, TApdStateConnectoid* Connectoid);

typedef void __fastcall (__closure *TApdOnDataSourceGetData)(System::TObject* Sender, void * Data, int DataSize);

typedef void __fastcall (__closure *TApdOnDataSourceGetDataString)(System::TObject* Sender, System::UnicodeString DataString);

typedef void __fastcall (__closure *TApdOnStateGetData)(System::TObject* Sender, void * Data, int DataSize);

typedef void __fastcall (__closure *TApdOnStateGetDataString)(System::TObject* Sender, System::UnicodeString DataString);

class PASCALIMPLEMENTATION TApdStateCustomDataSource : public Oomisc::TApdBaseComponent
{
	typedef Oomisc::TApdBaseComponent inherited;
	
private:
	TApdCustomStateMachine* FStateMachine;
	int FPauseDepth;
	TApdOnDataSourceGetData FOnGetData;
	TApdOnDataSourceGetDataString FOnGetDataString;
	
protected:
	bool __fastcall GetPaused(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	TApdCustomStateMachine* __fastcall SearchStateMachine(System::Classes::TComponent* const C);
	__property TApdCustomStateMachine* StateMachine = {read=FStateMachine};
	__property TApdOnDataSourceGetData OnGetData = {read=FOnGetData, write=FOnGetData};
	__property TApdOnDataSourceGetDataString OnGetDataString = {read=FOnGetDataString, write=FOnGetDataString};
	
public:
	__fastcall virtual TApdStateCustomDataSource(System::Classes::TComponent* AOwner);
	virtual void __fastcall Output(System::UnicodeString AString) = 0 ;
	virtual void __fastcall OutputBlock(void * ABlock, int ASize) = 0 ;
	virtual void __fastcall Pause(void);
	virtual void __fastcall Resume(void);
	virtual void __fastcall StateActivate(TApdCustomState* State) = 0 ;
	virtual void __fastcall StateChange(TApdCustomState* OldState, TApdCustomState* NewState) = 0 ;
	virtual void __fastcall StateDeactivate(TApdCustomState* State) = 0 ;
	virtual void __fastcall StateMachineActivate(TApdCustomState* State, TApdStateCondition* Condition, int Index) = 0 ;
	virtual void __fastcall StateMachineDeactivate(TApdCustomState* State) = 0 ;
	virtual void __fastcall StateMachineStart(TApdCustomStateMachine* AOwner);
	virtual void __fastcall StateMachineStop(void);
	__property bool Paused = {read=GetPaused, nodefault};
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TApdStateCustomDataSource(void) { }
	
};


class PASCALIMPLEMENTATION TApdStateComPortSource : public TApdStateCustomDataSource
{
	typedef TApdStateCustomDataSource inherited;
	
private:
	System::Classes::TList* PacketList;
	Adport::TApdCustomComPort* FComPort;
	void *FBuffer;
	int FBufferSize;
	
protected:
	void __fastcall SetComPort(Adport::TApdCustomComPort* const Value);
	void __fastcall PacketEvent(System::TObject* Sender, void * Data, int Size);
	void __fastcall PacketTimeout(System::TObject* Sender);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	void __fastcall TriggerHandler(unsigned Msg, unsigned wParam, int lParam);
	
public:
	__fastcall virtual TApdStateComPortSource(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdStateComPortSource(void);
	virtual void __fastcall Output(System::UnicodeString AString);
	virtual void __fastcall OutputBlock(void * ABlock, int ASize);
	virtual void __fastcall Pause(void);
	virtual void __fastcall Resume(void);
	virtual void __fastcall StateActivate(TApdCustomState* State);
	virtual void __fastcall StateDeactivate(TApdCustomState* State);
	virtual void __fastcall StateMachineActivate(TApdCustomState* State, TApdStateCondition* Condition, int Index);
	virtual void __fastcall StateMachineDeactivate(TApdCustomState* State);
	virtual void __fastcall StateChange(TApdCustomState* OldState, TApdCustomState* NewState);
	virtual void __fastcall StateMachineStart(TApdCustomStateMachine* AOwner);
	virtual void __fastcall StateMachineStop(void);
	
__published:
	__property Adport::TApdCustomComPort* ComPort = {read=FComPort, write=SetComPort};
	__property OnGetData;
	__property OnGetDataString;
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdStateConnectoid : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	int FWidth;
	Vcl::Controls::TCaption FCaption;
	System::Uitypes::TColor FColor;
	TApdStateCondition* FCondition;
	bool FSelected;
	Vcl::Graphics::TFont* FFont;
	void __fastcall SetCaption(const Vcl::Controls::TCaption Value);
	void __fastcall SetColor(const System::Uitypes::TColor Value);
	void __fastcall SetFont(Vcl::Graphics::TFont* const Value);
	void __fastcall SetWidth(const int Value);
	
protected:
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	bool __fastcall IsCaptionStored(void);
	void __fastcall ReadCaption(System::Classes::TReader* Reader);
	void __fastcall WriteCaption(System::Classes::TWriter* Writer);
	
public:
	__fastcall TApdStateConnectoid(TApdStateCondition* AOwner);
	__fastcall virtual ~TApdStateConnectoid(void);
	void __fastcall Changed(void);
	
__published:
	__property Vcl::Controls::TCaption Caption = {read=FCaption, write=SetCaption};
	__property System::Uitypes::TColor Color = {read=FColor, write=SetColor, nodefault};
	__property int Width = {read=FWidth, write=SetWidth, nodefault};
	__property Vcl::Graphics::TFont* Font = {read=FFont, write=SetFont};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdStateCondition : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
protected:
	virtual System::UnicodeString __fastcall GetDisplayName(void);
	
private:
	int FPacketSize;
	int FTimeout;
	int FErrorCode;
	TApdCustomState* FNextState;
	System::UnicodeString FEndString;
	System::UnicodeString FStartString;
	TApdStateConnectoid* FConnectoid;
	bool FIgnoreCase;
	bool FDefaultError;
	bool FDefaultNext;
	System::UnicodeString FOutputOnActivate;
	void __fastcall SetNextState(TApdCustomState* const Value);
	void __fastcall SetConnectoid(TApdStateConnectoid* const Value);
	
protected:
	Vcl::Controls::TCaption __fastcall GetCaption(void);
	System::Uitypes::TColor __fastcall GetColor(void);
	Vcl::Graphics::TFont* __fastcall GetFont(void);
	void __fastcall SetCaption(const Vcl::Controls::TCaption v);
	void __fastcall SetColor(const System::Uitypes::TColor v);
	void __fastcall SetDefaultError(const bool v);
	void __fastcall SetDefaultNext(const bool v);
	void __fastcall SetFont(Vcl::Graphics::TFont* const v);
	void __fastcall SetOutputOnActivate(const System::UnicodeString v);
	
public:
	__fastcall virtual TApdStateCondition(System::Classes::TCollection* Collection);
	__fastcall virtual ~TApdStateCondition(void);
	HIDESBASE void __fastcall Changed(void);
	
__published:
	__property bool DefaultError = {read=FDefaultError, write=SetDefaultError, nodefault};
	__property bool DefaultNext = {read=FDefaultNext, write=SetDefaultNext, nodefault};
	__property System::UnicodeString StartString = {read=FStartString, write=FStartString};
	__property System::UnicodeString EndString = {read=FEndString, write=FEndString};
	__property System::UnicodeString OutputOnActivate = {read=FOutputOnActivate, write=SetOutputOnActivate};
	__property int PacketSize = {read=FPacketSize, write=FPacketSize, nodefault};
	__property int Timeout = {read=FTimeout, write=FTimeout, nodefault};
	__property TApdCustomState* NextState = {read=FNextState, write=SetNextState};
	__property int ErrorCode = {read=FErrorCode, write=FErrorCode, nodefault};
	__property bool IgnoreCase = {read=FIgnoreCase, write=FIgnoreCase, nodefault};
	__property TApdStateConnectoid* Connectoid = {read=FConnectoid, write=SetConnectoid};
	__property Vcl::Controls::TCaption Caption = {read=GetCaption, write=SetCaption};
	__property System::Uitypes::TColor Color = {read=GetColor, write=SetColor, nodefault};
	__property Vcl::Graphics::TFont* Font = {read=GetFont, write=SetFont};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdStateConditions : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TApdStateCondition* operator[](int Index) { return this->Items[Index]; }
	
private:
	HIDESBASE TApdStateCondition* __fastcall GetItem(int Index);
	HIDESBASE void __fastcall SetItem(int Index, TApdStateCondition* const Value);
	
protected:
	TApdCustomState* FState;
	DYNAMIC System::Classes::TPersistent* __fastcall GetOwner(void);
	
public:
	__fastcall TApdStateConditions(TApdCustomState* State, System::Classes::TCollectionItemClass ItemClass);
	virtual void __fastcall Update(System::Classes::TCollectionItem* Item);
	HIDESBASE TApdStateCondition* __fastcall Add(void);
	__property TApdStateCondition* Items[int Index] = {read=GetItem, write=SetItem/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TApdStateConditions(void) { }
	
};

#pragma pack(pop)

typedef void __fastcall (__closure *TApdStateMachineStateChangeEvent)(TApdCustomStateMachine* StateMachine, TApdCustomState* FromState, TApdCustomState* ToState);

typedef void __fastcall (__closure *TApdStateMachineFinishEvent)(TApdCustomStateMachine* StateMachine, int ErrorCode);

typedef void __fastcall (__closure *TApdStateFinishEvent)(TApdCustomState* State, TApdStateCondition* Condition, TApdCustomState* &NextState);

typedef void __fastcall (__closure *TApdStateNotifyEvent)(TApdCustomState* State);

class PASCALIMPLEMENTATION TApdCustomStateMachine : public Oomisc::TApdBaseScrollingWinControl
{
	typedef Oomisc::TApdBaseScrollingWinControl inherited;
	
private:
	TApdCustomState* FStartState;
	TApdCustomState* FTerminalState;
	TApdCustomState* FCurrentState;
	Vcl::Graphics::TCanvas* FCanvas;
	TApdStateComPortSource* FDefaultDataSource;
	TApdStateMachineFinishEvent FOnStateMachineFinish;
	TApdStateMachineStateChangeEvent FOnStateChange;
	Vcl::Forms::TFormBorderStyle FBorderStyle;
	void *FData;
	int FDataSize;
	System::UnicodeString FDataString;
	int FLastErrorCode;
	Vcl::Controls::TCaption FCaption;
	bool FActive;
	TApdStateCustomDataSource* FDataSource;
	TApdOnConnectoidClickEvent FConnectoidClickEvent;
	bool FMovableStates;
	TAdConnectoidClickStyles FConnectoidClickStyle;
	Adport::TApdCustomComPort* __fastcall GetComPort(void);
	TApdStateCustomDataSource* __fastcall GetDataSource(void);
	TApdStateCustomDataSource* __fastcall GetLiveDataSource(void);
	void __fastcall SetStartState(TApdCustomState* const Value);
	void __fastcall SetTerminalState(TApdCustomState* const Value);
	void __fastcall SetComPort(Adport::TApdCustomComPort* const Value);
	void __fastcall SetBorderStyle(const Vcl::Forms::TBorderStyle Value);
	void __fastcall SetMovableStates(const bool v);
	HIDESBASE MESSAGE void __fastcall WMNCHitTest(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMCtl3DChanged(Winapi::Messages::TMessage &Message);
	void * __fastcall GetData(void);
	int __fastcall GetDataSize(void);
	System::UnicodeString __fastcall GetDataString(void);
	System::Classes::TStringList* __fastcall GetStateNames(void);
	void __fastcall SetCaption(const Vcl::Controls::TCaption Value);
	void __fastcall SetConnectoidClickStyle(const TAdConnectoidClickStyles v);
	
protected:
	HIDESBASE MESSAGE void __fastcall CMDesignHitTest(Winapi::Messages::TWMMouse &Msg);
	void __fastcall ConnectoidAtPoint(TApdConnectAddType AddType, const System::Types::TPoint &Point);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall PaintWindow(HDC DC);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	void __fastcall DoActivate(TApdCustomState* NewState);
	void __fastcall DoDeactivate(void);
	MESSAGE void __fastcall DoStateChange(Winapi::Messages::TMessage &M);
	bool __fastcall GetPaused(void);
	void __fastcall RenderConnectoid(TApdStateConnectoid* Connectoid, TApdCustomState* State, TApdCustomState* DestState);
	void __fastcall SetData(void * NewData, System::UnicodeString NewDataString, int NewDataSize);
	void __fastcall SetDataSource(TApdStateCustomDataSource* const v);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall WMEraseBackground(Winapi::Messages::TWMEraseBkgnd &Msg);
	__property TApdStateCustomDataSource* LiveDataSource = {read=GetLiveDataSource, write=SetDataSource};
	
public:
	__fastcall virtual TApdCustomStateMachine(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdCustomStateMachine(void);
	virtual void __fastcall Loaded(void);
	void __fastcall StateMachinePaint(void);
	void __fastcall ChangeState(int ConditionIndex);
	void __fastcall Pause(void);
	void __fastcall Resume(void);
	void __fastcall Start(void);
	void __fastcall Cancel(void);
	__property void * Data = {read=GetData};
	__property int DataSize = {read=GetDataSize, nodefault};
	__property System::UnicodeString DataString = {read=GetDataString};
	__property bool Active = {read=FActive, default=0};
	__property Vcl::Forms::TBorderStyle BorderStyle = {read=FBorderStyle, write=SetBorderStyle, default=1};
	__property Vcl::Graphics::TCanvas* Canvas = {read=FCanvas};
	__property Vcl::Controls::TCaption Caption = {read=FCaption, write=SetCaption};
	__property TAdConnectoidClickStyles ConnectoidClickStyle = {read=FConnectoidClickStyle, write=SetConnectoidClickStyle, default=0};
	__property Adport::TApdCustomComPort* ComPort = {read=GetComPort, write=SetComPort};
	__property TApdCustomState* CurrentState = {read=FCurrentState};
	__property TApdStateCustomDataSource* DataSource = {read=GetDataSource, write=SetDataSource};
	__property bool Paused = {read=GetPaused, nodefault};
	__property System::Classes::TStringList* StateNames = {read=GetStateNames};
	__property TApdCustomState* StartState = {read=FStartState, write=SetStartState};
	__property TApdCustomState* TerminalState = {read=FTerminalState, write=SetTerminalState};
	__property int LastErrorCode = {read=FLastErrorCode, nodefault};
	__property bool MovableStates = {read=FMovableStates, write=SetMovableStates, default=0};
	__property TApdStateMachineStateChangeEvent OnStateChange = {read=FOnStateChange, write=FOnStateChange};
	__property TApdStateMachineFinishEvent OnStateMachineFinish = {read=FOnStateMachineFinish, write=FOnStateMachineFinish};
	__property TApdOnConnectoidClickEvent OnConnectoidClick = {read=FConnectoidClickEvent, write=FConnectoidClickEvent};
public:
	/* TWinControl.CreateParented */ inline __fastcall TApdCustomStateMachine(HWND ParentWindow) : Oomisc::TApdBaseScrollingWinControl(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TApdCustomState : public Oomisc::TApdBaseGraphicControl
{
	typedef Oomisc::TApdBaseGraphicControl inherited;
	
private:
	bool FActive;
	bool FCompleted;
	Vcl::Graphics::TBitmap* FGlyph;
	System::UnicodeString FOutputOnActivate;
	TApdStateConditions* FConditions;
	int FGlyphCells;
	System::Uitypes::TColor FActiveColor;
	System::Uitypes::TColor FInactiveColor;
	TApdStateNotifyEvent FOnStateActivate;
	TApdStateFinishEvent FOnStateFinish;
	Vcl::Controls::TCaption FCaption;
	bool FMovable;
	int FOldX;
	int FOldY;
	bool FMoving;
	bool FActionState;
	TApdOnStateGetData FOnGetData;
	TApdOnStateGetDataString FOnGetDataString;
	void __fastcall SetActiveColor(const System::Uitypes::TColor NewColor);
	void __fastcall SetActionState(const bool v);
	void __fastcall SetInactiveColor(const System::Uitypes::TColor NewColor);
	void __fastcall SetConditions(TApdStateConditions* const Value);
	void __fastcall SetGlyph(Vcl::Graphics::TBitmap* const Value);
	void __fastcall SetGlyphCells(const int Value);
	void __fastcall SetCaption(const Vcl::Controls::TCaption Value);
	void __fastcall SetMovable(const bool v);
	
protected:
	bool HaveGlyph;
	TApdCustomStateMachine* FStateMachine;
	bool FUseLeftBorder;
	int FLeftBorderWidth;
	System::Uitypes::TColor FLeftBorderFill;
	virtual void __fastcall Activate(void);
	virtual void __fastcall Deactivate(void);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall SetParent(Vcl::Controls::TWinControl* AParent);
	TApdCustomStateMachine* __fastcall FindStateMachine(void);
	void __fastcall WMEraseBackground(Winapi::Messages::TWMEraseBkgnd &Msg);
	__property bool ActionState = {read=FActionState, write=SetActionState, nodefault};
	__property TApdOnStateGetData OnGetData = {read=FOnGetData, write=FOnGetData};
	__property TApdOnStateGetDataString OnGetDataString = {read=FOnGetDataString, write=FOnGetDataString};
	
public:
	__fastcall virtual TApdCustomState(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdCustomState(void);
	int __fastcall FindDefaultError(void);
	int __fastcall FindDefaultNext(void);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	virtual void __fastcall Paint(void);
	virtual void __fastcall Terminate(int ErrorCode);
	__property Vcl::Controls::TCaption Caption = {read=FCaption, write=SetCaption};
	__property bool Active = {read=FActive, nodefault};
	__property bool Completed = {read=FCompleted, nodefault};
	__property System::Uitypes::TColor ActiveColor = {read=FActiveColor, write=SetActiveColor, nodefault};
	__property System::Uitypes::TColor InactiveColor = {read=FInactiveColor, write=SetInactiveColor, nodefault};
	__property TApdStateConditions* Conditions = {read=FConditions, write=SetConditions};
	__property Vcl::Graphics::TBitmap* Glyph = {read=FGlyph, write=SetGlyph};
	__property int GlyphCells = {read=FGlyphCells, write=SetGlyphCells, nodefault};
	__property bool Movable = {read=FMovable, write=SetMovable, default=0};
	__property System::UnicodeString OutputOnActivate = {read=FOutputOnActivate, write=FOutputOnActivate};
	__property TApdStateNotifyEvent OnStateActivate = {read=FOnStateActivate, write=FOnStateActivate};
	__property TApdStateFinishEvent OnStateFinish = {read=FOnStateFinish, write=FOnStateFinish};
};


class PASCALIMPLEMENTATION TApdStateMachine : public TApdCustomStateMachine
{
	typedef TApdCustomStateMachine inherited;
	
__published:
	__property Caption;
	__property ConnectoidClickStyle = {default=0};
	__property DataSource;
	__property ComPort;
	__property MovableStates = {default=0};
	__property StartState;
	__property TerminalState;
	__property OnConnectoidClick;
	__property OnStateChange;
	__property OnStateMachineFinish;
	__property Align = {default=0};
	__property Anchors = {default=3};
	__property AutoSize = {default=0};
	__property BevelEdges = {default=15};
	__property BevelInner = {index=0, default=2};
	__property BevelOuter = {index=1, default=1};
	__property BevelKind = {default=0};
	__property BevelWidth = {default=1};
	__property BiDiMode;
	__property Constraints;
	__property ParentBiDiMode = {default=1};
	__property OnContextPopup;
	__property OnMouseWheel;
	__property OnMouseWheelDown;
	__property OnMouseWheelUp;
	__property OnResize;
	__property Color = {default=-16777211};
	__property AutoScroll = {default=0};
	__property Ctl3D;
	__property Font;
	__property PopupMenu;
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=0};
	__property OnClick;
	__property OnDblClick;
	__property OnEnter;
	__property OnExit;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
public:
	/* TApdCustomStateMachine.Create */ inline __fastcall virtual TApdStateMachine(System::Classes::TComponent* AOwner) : TApdCustomStateMachine(AOwner) { }
	/* TApdCustomStateMachine.Destroy */ inline __fastcall virtual ~TApdStateMachine(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TApdStateMachine(HWND ParentWindow) : TApdCustomStateMachine(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TApdState : public TApdCustomState
{
	typedef TApdCustomState inherited;
	
__published:
	__property ActiveColor;
	__property Caption;
	__property Conditions;
	__property Font;
	__property Glyph;
	__property GlyphCells;
	__property InactiveColor;
	__property Movable = {default=0};
	__property OutputOnActivate = {default=0};
	__property OnGetData;
	__property OnGetDataString;
	__property OnStateActivate;
	__property OnStateFinish;
public:
	/* TApdCustomState.Create */ inline __fastcall virtual TApdState(System::Classes::TComponent* AOwner) : TApdCustomState(AOwner) { }
	/* TApdCustomState.Destroy */ inline __fastcall virtual ~TApdState(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Adstmach */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADSTMACH)
using namespace Adstmach;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdstmachHPP
