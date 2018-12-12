// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdXParsr.pas' rev: 32.00 (Windows)

#ifndef AdxparsrHPP
#define AdxparsrHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <OoMisc.hpp>
#include <AdXBase.hpp>
#include <AdXChrFlt.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adxparsr
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TApdParser;
//-- type declarations -------------------------------------------------------
typedef System::StaticArray<System::WideString, 2> StringIds;

typedef void __fastcall (__closure *TApdDocTypeDeclEvent)(System::TObject* oOwner, System::WideString sDecl, System::WideString sId0, System::WideString sId1);

typedef void __fastcall (__closure *TApdValueEvent)(System::TObject* oOwner, System::WideString sValue);

typedef void __fastcall (__closure *TApdAttributeEvent)(System::TObject* oOwner, System::WideString sName, System::WideString sValue, bool bSpecified);

typedef void __fastcall (__closure *TApdProcessInstrEvent)(System::TObject* oOwner, System::WideString sName, System::WideString sValue);

typedef void __fastcall (__closure *TApdResolveEvent)(System::TObject* oOwner, const System::WideString sName, const System::WideString sPublicId, const System::WideString sSystemId, System::WideString &sValue);

typedef void __fastcall (__closure *TApdNonXMLEntityEvent)(System::TObject* oOwner, System::WideString sEntityName, System::WideString sPublicId, System::WideString sSystemId, System::WideString sNotationName);

typedef void __fastcall (__closure *TApdPreserveSpaceEvent)(System::TObject* oOwner, System::WideString sElementName, bool &bPreserve);

class PASCALIMPLEMENTATION TApdParser : public Oomisc::TApdBaseComponent
{
	typedef Oomisc::TApdBaseComponent inherited;
	
protected:
	System::Classes::TStringList* FAttrEnum;
	System::Classes::TStringList* FAttributeType;
	int FBufferSize;
	bool FCDATA;
	int FContext;
	System::WideString FCurrentElement;
	int FCurrentElementContent;
	System::UnicodeString FCurrentPath;
	System::WideString FDataBuffer;
	System::Classes::TList* FDocStack;
	System::Classes::TStringList* FElementInfo;
	System::Classes::TStringList* FEntityInfo;
	System::Classes::TStringList* FErrors;
	Adxchrflt::TApdInCharFilter* FFilter;
	Adxbase::TApdCharEncoding FInCharSet;
	bool FNormalizeData;
	System::Classes::TStringList* FNotationInfo;
	TApdAttributeEvent FOnAttribute;
	TApdValueEvent FOnCDATASection;
	TApdValueEvent FOnCharData;
	TApdValueEvent FOnComment;
	TApdDocTypeDeclEvent FOnDocTypeDecl;
	System::Classes::TNotifyEvent FOnEndDocument;
	TApdValueEvent FOnEndElement;
	TApdValueEvent FOnIgnorableWhitespace;
	TApdNonXMLEntityEvent FOnNonXMLEntity;
	TApdPreserveSpaceEvent FOnPreserveSpace;
	TApdProcessInstrEvent FOnProcessingInstruction;
	TApdResolveEvent FOnResolveEntity;
	System::Classes::TNotifyEvent FOnStartDocument;
	TApdValueEvent FOnStartElement;
	TApdValueEvent FOnBeginElement;
	bool FPreserve;
	bool FRaiseErrors;
	System::Classes::TStringList* FTagAttributes;
	System::Classes::TStringList* FTempFiles;
	System::WideString FUrl;
	bool FIsStandAlone;
	bool FHasExternals;
	bool FXMLDecParsed;
	void __fastcall Cleanup(void);
	void __fastcall CheckParamEntityNesting(const System::WideString aString);
	void __fastcall DataBufferAppend(const System::WideString sVal);
	void __fastcall DataBufferFlush(void);
	void __fastcall DataBufferNormalize(void);
	System::WideString __fastcall DataBufferToString(void);
	System::Classes::TStringList* __fastcall DeclaredAttributes(const System::WideString sName, int aIdx);
	int __fastcall GetAttributeDefaultValueType(const System::WideString sElemName, const System::WideString sAttrName);
	System::WideString __fastcall GetAttributeExpandedValue(const System::WideString sElemName, const System::WideString sAttrName, int aIdx);
	int __fastcall GetElementContentType(const System::WideString sName, int aIdx);
	int __fastcall GetElementIndexOf(const System::WideString sElemName);
	int __fastcall GetEntityIndexOf(const System::WideString sEntityName, bool aPEAllowed);
	System::WideString __fastcall GetEntityNotationName(const System::WideString sEntityName);
	System::WideString __fastcall GetEntityPublicId(const System::WideString sEntityName);
	System::WideString __fastcall GetEntitySystemId(const System::WideString sEntityName);
	int __fastcall GetEntityType(const System::WideString sEntityName, bool aPEAllowed);
	System::WideString __fastcall GetEntityValue(const System::WideString sEntityName, bool aPEAllowed);
	int __fastcall GetErrorCount(void);
	System::WideString __fastcall GetExternalTextEntityValue(const System::WideString sName, const System::WideString sPublicId, System::WideString sSystemId);
	Adxbase::TApdCharEncoding __fastcall GetInCharSet(void);
	void __fastcall Initialize(void);
	bool __fastcall IsEndDocument(void);
	bool __fastcall IsWhitespace(const System::WideChar cVal);
	bool __fastcall LoadDataSource(System::UnicodeString sSrcName, System::Classes::TStringList* oErrors);
	System::WideString __fastcall ParseAttribute(const System::WideString sName);
	System::WideString __fastcall ParseEntityRef(bool bPEAllowed);
	void __fastcall ParseCDSect(void);
	System::WideChar __fastcall ParseCharRef(void);
	void __fastcall ParseComment(void);
	void __fastcall ParseContent(void);
	void __fastcall ParseDocTypeDecl(void);
	void __fastcall ParseDocument(void);
	void __fastcall ParseEndTag(void);
	void __fastcall ParseEq(void);
	void __fastcall ParseElement(void);
	void __fastcall ParseMisc(void);
	System::WideString __fastcall ParseParameterEntityRef(bool aPEAllowed, bool bSkip);
	void __fastcall ParsePCData(bool aInEntityRef);
	void __fastcall ParsePI(void);
	bool __fastcall ParsePIEx(void);
	void __fastcall ParsePrim(void);
	void __fastcall ParseProlog(void);
	void __fastcall ParseUntil(const int *S, const int S_High);
	void __fastcall ParseWhitespace(void);
	void __fastcall ParseXMLDeclaration(void);
	void __fastcall PopDocument(void);
	void __fastcall PushDocument(void);
	void __fastcall PushString(const System::WideString sVal);
	System::WideChar __fastcall ReadChar(const bool UpdatePos);
	void __fastcall ReadExternalIds(bool bInNotation, StringIds &sIds);
	System::WideString __fastcall ReadLiteral(int wFlags, bool &HasEntRef);
	System::WideString __fastcall ReadNameToken(bool aValFirst);
	void __fastcall Require(const int *S, const int S_High);
	void __fastcall RequireWhitespace(void);
	void __fastcall SetAttribute(const System::WideString sElemName, const System::WideString sName, int wType, const System::WideString sEnum, const System::WideString sValue, int wValueType);
	void __fastcall SetElement(const System::WideString sName, int wType, const System::WideString sContentModel);
	void __fastcall SetEntity(const System::WideString sEntityName, int wClass, const System::WideString sPublicId, const System::WideString sSystemId, const System::WideString sValue, const System::WideString sNotationName, bool aIsPE);
	void __fastcall SetInternalEntity(const System::WideString sName, const System::WideString sValue, bool aIsPE);
	void __fastcall SetNotation(const System::WideString sNotationName, const System::WideString sPublicId, const System::WideString sSystemId);
	void __fastcall SkipChar(void);
	void __fastcall SkipWhitespace(bool aNextDoc);
	bool __fastcall TryRead(const int *S, const int S_High);
	void __fastcall ValidateAttribute(const System::WideString aValue, bool HasEntRef);
	void __fastcall ValidateCData(const System::WideString CDATA);
	void __fastcall ValidateElementName(const System::WideString aName);
	void __fastcall ValidateEncName(const System::UnicodeString aValue);
	void __fastcall ValidateEntityValue(const System::WideString aValue, System::WideChar aQuoteCh);
	bool __fastcall ValidateNameChar(const bool First, const System::WideChar Char);
	void __fastcall ValidatePCData(const System::WideString aString, bool aInEntityRef);
	void __fastcall ValidatePublicID(const System::WideString aString);
	void __fastcall ValidateVersNum(const System::UnicodeString aString);
	__property TApdValueEvent OnIgnorableWhitespace = {read=FOnIgnorableWhitespace, write=FOnIgnorableWhitespace};
	
public:
	__fastcall virtual TApdParser(System::Classes::TComponent* oOwner);
	__fastcall virtual ~TApdParser(void);
	System::WideString __fastcall GetErrorMsg(int wIdx);
	bool __fastcall ParseDataSource(const System::UnicodeString sSource);
	bool __fastcall ParseMemory(void *aBuffer, int aSize);
	bool __fastcall ParseStream(System::Classes::TStream* oStream);
	__property int ErrorCount = {read=GetErrorCount, nodefault};
	__property System::Classes::TStringList* Errors = {read=FErrors};
	__property Adxbase::TApdCharEncoding InCharSet = {read=GetInCharSet, nodefault};
	__property bool IsStandAlone = {read=FIsStandAlone, nodefault};
	__property bool HasExternals = {read=FHasExternals, nodefault};
	__property int BufferSize = {read=FBufferSize, write=FBufferSize, default=8192};
	__property bool NormalizeData = {read=FNormalizeData, write=FNormalizeData, default=1};
	__property bool RaiseErrors = {read=FRaiseErrors, write=FRaiseErrors, default=0};
	__property TApdAttributeEvent OnAttribute = {read=FOnAttribute, write=FOnAttribute};
	__property TApdValueEvent OnCDATASection = {read=FOnCDATASection, write=FOnCDATASection};
	__property TApdValueEvent OnCharData = {read=FOnCharData, write=FOnCharData};
	__property TApdValueEvent OnComment = {read=FOnComment, write=FOnComment};
	__property TApdDocTypeDeclEvent OnDocTypeDecl = {read=FOnDocTypeDecl, write=FOnDocTypeDecl};
	__property System::Classes::TNotifyEvent OnEndDocument = {read=FOnEndDocument, write=FOnEndDocument};
	__property TApdValueEvent OnEndElement = {read=FOnEndElement, write=FOnEndElement};
	__property TApdNonXMLEntityEvent OnNonXMLEntity = {read=FOnNonXMLEntity, write=FOnNonXMLEntity};
	__property TApdPreserveSpaceEvent OnPreserveSpace = {read=FOnPreserveSpace, write=FOnPreserveSpace};
	__property TApdProcessInstrEvent OnProcessingInstruction = {read=FOnProcessingInstruction, write=FOnProcessingInstruction};
	__property TApdResolveEvent OnResolveEntity = {read=FOnResolveEntity, write=FOnResolveEntity};
	__property System::Classes::TNotifyEvent OnStartDocument = {read=FOnStartDocument, write=FOnStartDocument};
	__property TApdValueEvent OnStartElement = {read=FOnStartElement, write=FOnStartElement};
	__property TApdValueEvent OnBeginElement = {read=FOnBeginElement, write=FOnBeginElement};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Adxparsr */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADXPARSR)
using namespace Adxparsr;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdxparsrHPP
