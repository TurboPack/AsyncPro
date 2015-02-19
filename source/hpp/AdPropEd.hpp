// CodeGear C++Builder
// Copyright (c) 1995, 2014 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Adproped.pas' rev: 28.00 (Windows)

#ifndef AdpropedHPP
#define AdpropedHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <Vcl.Controls.hpp>	// Pascal unit
#include <DesignIntf.hpp>	// Pascal unit
#include <DesignEditors.hpp>	// Pascal unit
#include <Vcl.Forms.hpp>	// Pascal unit
#include <OoMisc.hpp>	// Pascal unit
#include <AdAbout.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Adproped
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TApdPacketStringProperty;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdPacketStringProperty : public Designeditors::TStringProperty
{
	typedef Designeditors::TStringProperty inherited;
	
public:
	virtual System::UnicodeString __fastcall GetValue(void);
	virtual void __fastcall SetValue(const System::UnicodeString Value)/* overload */;
public:
	/* TPropertyEditor.Create */ inline __fastcall virtual TApdPacketStringProperty(const Designintf::_di_IDesigner ADesigner, int APropCount) : Designeditors::TStringProperty(ADesigner, APropCount) { }
	/* TPropertyEditor.Destroy */ inline __fastcall virtual ~TApdPacketStringProperty(void) { }
	
	/* Hoisted overloads: */
	
public:
	inline void __fastcall  SetValue(const System::WideString Value){ Designeditors::TPropertyEditor::SetValue(Value); }
	
};

#pragma pack(pop)

class DELPHICLASS TApdPacketEditor;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdPacketEditor : public Designeditors::TDefaultEditor
{
	typedef Designeditors::TDefaultEditor inherited;
	
public:
	virtual void __fastcall ExecuteVerb(int Index);
	virtual System::UnicodeString __fastcall GetVerb(int Index);
	virtual int __fastcall GetVerbCount(void);
public:
	/* TComponentEditor.Create */ inline __fastcall virtual TApdPacketEditor(System::Classes::TComponent* AComponent, Designintf::_di_IDesigner ADesigner) : Designeditors::TDefaultEditor(AComponent, ADesigner) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TApdPacketEditor(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TApdVoipAudioVideoEditor;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdVoipAudioVideoEditor : public Designeditors::TDefaultEditor
{
	typedef Designeditors::TDefaultEditor inherited;
	
public:
	virtual void __fastcall ExecuteVerb(int Index);
	virtual System::UnicodeString __fastcall GetVerb(int Index);
	virtual int __fastcall GetVerbCount(void);
public:
	/* TComponentEditor.Create */ inline __fastcall virtual TApdVoipAudioVideoEditor(System::Classes::TComponent* AComponent, Designintf::_di_IDesigner ADesigner) : Designeditors::TDefaultEditor(AComponent, ADesigner) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TApdVoipAudioVideoEditor(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TApdVersionProperty;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdVersionProperty : public Designeditors::TStringProperty
{
	typedef Designeditors::TStringProperty inherited;
	
public:
	virtual Designintf::TPropertyAttributes __fastcall GetAttributes(void);
	virtual void __fastcall Edit(void);
public:
	/* TPropertyEditor.Create */ inline __fastcall virtual TApdVersionProperty(const Designintf::_di_IDesigner ADesigner, int APropCount) : Designeditors::TStringProperty(ADesigner, APropCount) { }
	/* TPropertyEditor.Destroy */ inline __fastcall virtual ~TApdVersionProperty(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TApdValidEnumProperty;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdValidEnumProperty : public Designeditors::TEnumProperty
{
	typedef Designeditors::TEnumProperty inherited;
	
public:
	virtual Designintf::TPropertyAttributes __fastcall GetAttributes(void);
	virtual void __fastcall GetValues(System::Classes::TGetStrProc Proc);
public:
	/* TPropertyEditor.Create */ inline __fastcall virtual TApdValidEnumProperty(const Designintf::_di_IDesigner ADesigner, int APropCount) : Designeditors::TEnumProperty(ADesigner, APropCount) { }
	/* TPropertyEditor.Destroy */ inline __fastcall virtual ~TApdValidEnumProperty(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TApdStateEditor;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdStateEditor : public Designeditors::TDefaultEditor
{
	typedef Designeditors::TDefaultEditor inherited;
	
public:
	virtual void __fastcall ExecuteVerb(int Index);
	virtual System::UnicodeString __fastcall GetVerb(int Index);
	virtual int __fastcall GetVerbCount(void);
public:
	/* TComponentEditor.Create */ inline __fastcall virtual TApdStateEditor(System::Classes::TComponent* AComponent, Designintf::_di_IDesigner ADesigner) : Designeditors::TDefaultEditor(AComponent, ADesigner) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TApdStateEditor(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TApdGenericFileNameProperty;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdGenericFileNameProperty : public Designeditors::TStringProperty
{
	typedef Designeditors::TStringProperty inherited;
	
public:
	virtual Designintf::TPropertyAttributes __fastcall GetAttributes(void);
	virtual void __fastcall Edit(void);
public:
	/* TPropertyEditor.Create */ inline __fastcall virtual TApdGenericFileNameProperty(const Designintf::_di_IDesigner ADesigner, int APropCount) : Designeditors::TStringProperty(ADesigner, APropCount) { }
	/* TPropertyEditor.Destroy */ inline __fastcall virtual ~TApdGenericFileNameProperty(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TApdAPFFileNameProperty;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdAPFFileNameProperty : public TApdGenericFileNameProperty
{
	typedef TApdGenericFileNameProperty inherited;
	
public:
	/* TPropertyEditor.Create */ inline __fastcall virtual TApdAPFFileNameProperty(const Designintf::_di_IDesigner ADesigner, int APropCount) : TApdGenericFileNameProperty(ADesigner, APropCount) { }
	/* TPropertyEditor.Destroy */ inline __fastcall virtual ~TApdAPFFileNameProperty(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TApdConverterNameProperty;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdConverterNameProperty : public TApdGenericFileNameProperty
{
	typedef TApdGenericFileNameProperty inherited;
	
public:
	/* TPropertyEditor.Create */ inline __fastcall virtual TApdConverterNameProperty(const Designintf::_di_IDesigner ADesigner, int APropCount) : TApdGenericFileNameProperty(ADesigner, APropCount) { }
	/* TPropertyEditor.Destroy */ inline __fastcall virtual ~TApdConverterNameProperty(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TApdLogNameProperty;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdLogNameProperty : public TApdGenericFileNameProperty
{
	typedef TApdGenericFileNameProperty inherited;
	
public:
	/* TPropertyEditor.Create */ inline __fastcall virtual TApdLogNameProperty(const Designintf::_di_IDesigner ADesigner, int APropCount) : TApdGenericFileNameProperty(ADesigner, APropCount) { }
	/* TPropertyEditor.Destroy */ inline __fastcall virtual ~TApdLogNameProperty(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TApdTraceNameProperty;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdTraceNameProperty : public TApdGenericFileNameProperty
{
	typedef TApdGenericFileNameProperty inherited;
	
public:
	/* TPropertyEditor.Create */ inline __fastcall virtual TApdTraceNameProperty(const Designintf::_di_IDesigner ADesigner, int APropCount) : TApdGenericFileNameProperty(ADesigner, APropCount) { }
	/* TPropertyEditor.Destroy */ inline __fastcall virtual ~TApdTraceNameProperty(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TApdHistoryNameProperty;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdHistoryNameProperty : public TApdGenericFileNameProperty
{
	typedef TApdGenericFileNameProperty inherited;
	
public:
	/* TPropertyEditor.Create */ inline __fastcall virtual TApdHistoryNameProperty(const Designintf::_di_IDesigner ADesigner, int APropCount) : TApdGenericFileNameProperty(ADesigner, APropCount) { }
	/* TPropertyEditor.Destroy */ inline __fastcall virtual ~TApdHistoryNameProperty(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TApdCaptureNameProperty;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdCaptureNameProperty : public TApdGenericFileNameProperty
{
	typedef TApdGenericFileNameProperty inherited;
	
public:
	/* TPropertyEditor.Create */ inline __fastcall virtual TApdCaptureNameProperty(const Designintf::_di_IDesigner ADesigner, int APropCount) : TApdGenericFileNameProperty(ADesigner, APropCount) { }
	/* TPropertyEditor.Destroy */ inline __fastcall virtual ~TApdCaptureNameProperty(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TApdAPJNameProperty;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdAPJNameProperty : public TApdGenericFileNameProperty
{
	typedef TApdGenericFileNameProperty inherited;
	
public:
	/* TPropertyEditor.Create */ inline __fastcall virtual TApdAPJNameProperty(const Designintf::_di_IDesigner ADesigner, int APropCount) : TApdGenericFileNameProperty(ADesigner, APropCount) { }
	/* TPropertyEditor.Destroy */ inline __fastcall virtual ~TApdAPJNameProperty(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TApdFaxCoverNameProperty;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdFaxCoverNameProperty : public TApdGenericFileNameProperty
{
	typedef TApdGenericFileNameProperty inherited;
	
public:
	/* TPropertyEditor.Create */ inline __fastcall virtual TApdFaxCoverNameProperty(const Designintf::_di_IDesigner ADesigner, int APropCount) : TApdGenericFileNameProperty(ADesigner, APropCount) { }
	/* TPropertyEditor.Destroy */ inline __fastcall virtual ~TApdFaxCoverNameProperty(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TApdDirectoryProperty;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdDirectoryProperty : public Designeditors::TStringProperty
{
	typedef Designeditors::TStringProperty inherited;
	
public:
	virtual Designintf::TPropertyAttributes __fastcall GetAttributes(void);
	virtual void __fastcall Edit(void);
public:
	/* TPropertyEditor.Create */ inline __fastcall virtual TApdDirectoryProperty(const Designintf::_di_IDesigner ADesigner, int APropCount) : Designeditors::TStringProperty(ADesigner, APropCount) { }
	/* TPropertyEditor.Destroy */ inline __fastcall virtual ~TApdDirectoryProperty(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TApdVoipAudioVideoProperty;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdVoipAudioVideoProperty : public Designeditors::TStringProperty
{
	typedef Designeditors::TStringProperty inherited;
	
public:
	virtual Designintf::TPropertyAttributes __fastcall GetAttributes(void);
	virtual void __fastcall Edit(void);
public:
	/* TPropertyEditor.Create */ inline __fastcall virtual TApdVoipAudioVideoProperty(const Designintf::_di_IDesigner ADesigner, int APropCount) : Designeditors::TStringProperty(ADesigner, APropCount) { }
	/* TPropertyEditor.Destroy */ inline __fastcall virtual ~TApdVoipAudioVideoProperty(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall Register(void);
}	/* namespace Adproped */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADPROPED)
using namespace Adproped;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdpropedHPP
