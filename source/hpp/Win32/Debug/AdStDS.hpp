// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdStDS.pas' rev: 32.00 (Windows)

#ifndef AdstdsHPP
#define AdstdsHPP

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
#include <AdStMach.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adstds
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TApdStateGenericSource;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TApdOnDSOutputString)(System::TObject* Sender, System::UnicodeString AString);

typedef void __fastcall (__closure *TApdOnDSOutputBlock)(System::TObject* Sender, void * ABlock, int ASize);

typedef void __fastcall (__closure *TApdOnDSPauseDataSource)(System::TObject* Sender);

typedef void __fastcall (__closure *TApdOnDSResumeDataSource)(System::TObject* Sender);

typedef void __fastcall (__closure *TApdOnDSStateActivate)(System::TObject* Sender, Adstmach::TApdCustomState* AState);

typedef void __fastcall (__closure *TApdOnDSStateChange)(System::TObject* Sender, Adstmach::TApdCustomState* OldState, Adstmach::TApdCustomState* NewState);

typedef void __fastcall (__closure *TApdOnDSStateDeactivate)(System::TObject* Sender, Adstmach::TApdCustomState* AState);

typedef void __fastcall (__closure *TApdOnDSStateMachineActivate)(System::TObject* Sender, Adstmach::TApdCustomState* State, Adstmach::TApdStateCondition* Condition, int Index);

typedef void __fastcall (__closure *TApdOnDSStateMachineDeactivate)(System::TObject* Sender, Adstmach::TApdCustomState* AState);

typedef void __fastcall (__closure *TApdOnDSStateMachineStart)(System::TObject* Sender, Adstmach::TApdCustomStateMachine* AStateMachine);

typedef void __fastcall (__closure *TApdOnDSStateMachineStop)(System::TObject* Sender);

class PASCALIMPLEMENTATION TApdStateGenericSource : public Adstmach::TApdStateCustomDataSource
{
	typedef Adstmach::TApdStateCustomDataSource inherited;
	
private:
	TApdOnDSOutputBlock FOnOutputBlock;
	TApdOnDSOutputString FOnOutputString;
	TApdOnDSPauseDataSource FOnPause;
	TApdOnDSResumeDataSource FOnResume;
	TApdOnDSStateActivate FOnStateActivate;
	TApdOnDSStateChange FOnStateChange;
	TApdOnDSStateDeactivate FOnStateDeactivate;
	TApdOnDSStateMachineActivate FOnStateMachineActivate;
	TApdOnDSStateMachineDeactivate FOnStateMachineDeactivate;
	TApdOnDSStateMachineStart FOnStateMachineStart;
	TApdOnDSStateMachineStop FOnStateMachineStop;
	
public:
	__fastcall virtual TApdStateGenericSource(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdStateGenericSource(void);
	void __fastcall ChangeState(int ConditionIndex);
	virtual void __fastcall Output(System::UnicodeString AString);
	virtual void __fastcall OutputBlock(void * ABlock, int ASize);
	virtual void __fastcall Pause(void);
	virtual void __fastcall Resume(void);
	virtual void __fastcall StateActivate(Adstmach::TApdCustomState* State);
	virtual void __fastcall StateChange(Adstmach::TApdCustomState* OldState, Adstmach::TApdCustomState* NewState);
	virtual void __fastcall StateDeactivate(Adstmach::TApdCustomState* State);
	virtual void __fastcall StateMachineActivate(Adstmach::TApdCustomState* State, Adstmach::TApdStateCondition* Condition, int Index);
	virtual void __fastcall StateMachineDeactivate(Adstmach::TApdCustomState* State);
	virtual void __fastcall StateMachineStart(Adstmach::TApdCustomStateMachine* AOwner);
	virtual void __fastcall StateMachineStop(void);
	
__published:
	__property TApdOnDSOutputBlock OnOutputBlock = {read=FOnOutputBlock, write=FOnOutputBlock};
	__property TApdOnDSOutputString OnOutputString = {read=FOnOutputString, write=FOnOutputString};
	__property TApdOnDSPauseDataSource OnPause = {read=FOnPause, write=FOnPause};
	__property TApdOnDSResumeDataSource OnResume = {read=FOnResume, write=FOnResume};
	__property TApdOnDSStateActivate OnStateActivate = {read=FOnStateActivate, write=FOnStateActivate};
	__property TApdOnDSStateChange OnStateChange = {read=FOnStateChange, write=FOnStateChange};
	__property TApdOnDSStateDeactivate OnStateDeactivate = {read=FOnStateDeactivate, write=FOnStateDeactivate};
	__property TApdOnDSStateMachineActivate OnStateMachineActivate = {read=FOnStateMachineActivate, write=FOnStateMachineActivate};
	__property TApdOnDSStateMachineDeactivate OnStateMachineDeactivate = {read=FOnStateMachineDeactivate, write=FOnStateMachineDeactivate};
	__property TApdOnDSStateMachineStart OnStateMachineStart = {read=FOnStateMachineStart, write=FOnStateMachineStart};
	__property TApdOnDSStateMachineStop OnStateMachineStop = {read=FOnStateMachineStop, write=FOnStateMachineStop};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Adstds */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADSTDS)
using namespace Adstds;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdstdsHPP
