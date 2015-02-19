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
 *  Sebastian Zierer
 *
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{*                   ADXPARSR.PAS 4.06                   *}
{*********************************************************}
{*                    XML parser code                    *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

unit AdXParsr;

interface

uses
  Windows,
  Graphics,
  Controls,
  SysUtils,
  Classes,
  OOMisc,
  AdXBase,
  AdXChrFlt;

type
  StringIds = array[0..1] of DOMString;

{== Event types ======================================================}
  TApdDocTypeDeclEvent = procedure(oOwner : TObject;
                                  sDecl,
                                  sId0,
                                  sId1   : DOMString) of object;
  TApdValueEvent = procedure(oOwner : TObject;
                            sValue : DOMString) of object;
  TApdAttributeEvent = procedure(oOwner     : TObject;
                                sName,
                                sValue     : DOMString;
                                bSpecified : Boolean) of object;
  TApdProcessInstrEvent = procedure(oOwner : TObject;
                                   sName,
                                   sValue : DOMString) of object;
  TApdResolveEvent = procedure(oOwner     : TObject;
                        const sName,
                              sPublicId,
                              sSystemId  : DOMString;
                          var sValue     : DOMString) of object;
  TApdNonXMLEntityEvent = procedure(oOwner        : TObject;
                                   sEntityName,
                                   sPublicId,
                                   sSystemId,
                                   sNotationName : DOMString) of object;
  TApdPreserveSpaceEvent = procedure(oOwner       : TObject;
                                    sElementName : DOMString;
                                var bPreserve    : Boolean) of object;
{== Class types ======================================================}
  TApdParser = class(TApdBaseComponent)
  protected
    { Private declarations }
    FAttrEnum : TStringList;
    FAttributeType : TStringList;
    FBufferSize : Integer;
    FCDATA : Boolean;
    FContext : Integer;
    FCurrentElement : DOMString;
    FCurrentElementContent : Integer;
    FCurrentPath : string;
    FDataBuffer : DOMString;
    FDocStack : TList;
    FElementInfo : TStringList;
    FEntityInfo : TStringList;
    FErrors : TStringList;
    FFilter : TApdInCharFilter;
    FInCharSet : TApdCharEncoding;
    FNormalizeData : Boolean;
    FNotationInfo : TStringList;
    FOnAttribute : TApdAttributeEvent;
    FOnCDATASection : TApdValueEvent;
    FOnCharData : TApdValueEvent;
    FOnComment : TApdValueEvent;
    FOnDocTypeDecl : TApdDocTypeDeclEvent;
    FOnEndDocument : TNotifyEvent;
    FOnEndElement : TApdValueEvent;
    FOnIgnorableWhitespace : TApdValueEvent;
    FOnNonXMLEntity : TApdNonXMLEntityEvent;
    FOnPreserveSpace : TApdPreserveSpaceEvent;
    FOnProcessingInstruction : TApdProcessInstrEvent;
    FOnResolveEntity : TApdResolveEvent;
    FOnStartDocument : TNotifyEvent;
    FOnStartElement : TApdValueEvent;
    FOnBeginElement : TApdValueEvent;
    FPreserve : Boolean;
    FRaiseErrors : Boolean;
    FTagAttributes : TStringList;
    FTempFiles : TStringList;
    FUrl : DOMString;
    FIsStandAlone : Boolean;
    FHasExternals : Boolean;
    FXMLDecParsed : Boolean;

    procedure Cleanup;
    procedure CheckParamEntityNesting(const aString : DOMString);
    procedure DataBufferAppend(const sVal : DOMString);
    procedure DataBufferFlush;
    procedure DataBufferNormalize;
    function DataBufferToString : DOMString;
    function DeclaredAttributes(const sName : DOMString;
                                      aIdx  : Integer) : TStringList;
    function GetAttributeDefaultValueType(const sElemName,
                                                sAttrName : DOMString)
                                                          : Integer;
    function GetAttributeExpandedValue(const sElemName,
                                             sAttrName : DOMString;
                                             aIdx      : Integer)
                                                       : DOMString;
    function GetElementContentType(const sName : DOMString;
                                         aIdx  : Integer) : Integer;
    function GetElementIndexOf(const sElemName : DOMString) : Integer;
    function GetEntityIndexOf(const sEntityName : DOMString;
                                    aPEAllowed  : Boolean) : Integer;
    function GetEntityNotationName(const sEntityName : DOMString)
                                                     : DOMString;
    function GetEntityPublicId(const sEntityName : DOMString)
                                                 : DOMString;
    function GetEntitySystemId(const sEntityName : DOMString)
                                                 : DOMString;
    function GetEntityType(const sEntityName : DOMString;
                                 aPEAllowed   : Boolean) : Integer;
    function GetEntityValue(const sEntityName : DOMString;
                                  aPEAllowed  : Boolean) : DOMString;
    function GetErrorCount : Integer;
    function GetExternalTextEntityValue(const sName,
                                              sPublicId : DOMString;
                                              sSystemId : DOMString)
                                                        : DOMString;
    function GetInCharSet : TApdCharEncoding;
    procedure Initialize;
    function IsEndDocument : Boolean;
    function IsWhitespace(const cVal : DOMChar) : Boolean;
    function LoadDataSource(sSrcName   : string;
                            oErrors    : TStringList) : Boolean;
    function ParseAttribute(const sName : DOMString) : DOMString;
    function ParseEntityRef(bPEAllowed : Boolean) : DOMString;
    procedure ParseCDSect;
    function  ParseCharRef : DOMChar;
    procedure ParseComment;
    procedure ParseContent;
    procedure ParseDocTypeDecl;
    procedure ParseDocument;
    procedure ParseEndTag;
    procedure ParseEq;
    procedure ParseElement;
    procedure ParseMisc;
    function ParseParameterEntityRef(aPEAllowed : Boolean;
                                     bSkip      : Boolean) : DOMString;
    procedure ParsePCData(aInEntityRef : Boolean);
    procedure ParsePI;
    function ParsePIEx : Boolean;
      { Returns true if an XML declaration was found }
    procedure ParsePrim;
    procedure ParseProlog;
    procedure ParseUntil(const S : array of Integer);
    procedure ParseWhitespace;
    procedure ParseXMLDeclaration;
    procedure PopDocument;
    procedure PushDocument;
    procedure PushString(const sVal : DOMString);
    function ReadChar(const UpdatePos : Boolean) : DOMChar;
    procedure ReadExternalIds(bInNotation : Boolean;
                          var sIds        : StringIds);
    function ReadLiteral(wFlags    : Integer;
                     var HasEntRef : Boolean) : DOMString;
    function ReadNameToken(aValFirst : Boolean) : DOMString;
    procedure Require(const S : array of Integer);
    procedure RequireWhitespace;
    procedure SetAttribute(const sElemName,
                                 sName      : DOMString;
                                 wType      : Integer;
                           const sEnum,
                                 sValue     : DOMString;
                                 wValueType : Integer);
    procedure SetElement(const sName         : DOMString;
                               wType         : Integer;
                         const sContentModel : DOMString);
    procedure SetEntity(const sEntityName   : DOMString;
                              wClass        : Integer;
                        const sPublicId,
                              sSystemId,
                              sValue,
                              sNotationName : DOMString;
                              aIsPE         : Boolean);
    procedure SetInternalEntity(const sName, sValue : DOMString;
                                      aIsPE         : Boolean);
    procedure SetNotation(const sNotationName, sPublicId, sSystemId
                                                          : DOMString);
    procedure SkipChar;
    procedure SkipWhitespace(aNextDoc : Boolean);
    function TryRead(const S : array of Integer) : Boolean;
    procedure ValidateAttribute(const aValue    : DOMString;
                                      HasEntRef : Boolean);
    procedure ValidateCData(const CDATA : DOMString);
    procedure ValidateElementName(const aName : DOMString);
    procedure ValidateEncName(const aValue : string);
    procedure ValidateEntityValue(const aValue   : DOMString;
                                        aQuoteCh : DOMChar);
    function ValidateNameChar(const First : Boolean;
                              const Char  : DOMChar) : Boolean;
    procedure ValidatePCData(const aString      : DOMString;
                                   aInEntityRef : Boolean);
    procedure ValidatePublicID(const aString : DOMString);
    procedure ValidateVersNum(const aString : string);

  protected
    { Protected declarations }
    property OnIgnorableWhitespace : TApdValueEvent
      read FOnIgnorableWhitespace
      write FOnIgnorableWhitespace;

  public
    { Public declarations }
    constructor Create(oOwner : TComponent); override;
    destructor Destroy; override;

    function GetErrorMsg(wIdx : Integer) : DOMString;
    function ParseDataSource(const sSource : string) : Boolean;
    function ParseMemory(var aBuffer; aSize : Integer) : Boolean;
    function ParseStream(oStream : TStream) : Boolean;

    property ErrorCount : Integer
      read GetErrorCount;

    property Errors : TStringList
      read FErrors;

    property InCharSet : TApdCharEncoding
      read GetInCharSet;

    property IsStandAlone : Boolean
      read FIsStandAlone;

    property HasExternals : Boolean
      read FHasExternals;

    { Published declarations }
    property BufferSize : Integer
      read FBufferSize
      write FBufferSize
      default 8192;

    property NormalizeData : Boolean
      read FNormalizeData
      write FNormalizeData
      default True;

    property RaiseErrors : Boolean
      read FRaiseErrors
      write FRaiseErrors
      default False;

    property OnAttribute : TApdAttributeEvent
      read FOnAttribute
      write FOnAttribute;

    property OnCDATASection : TApdValueEvent
      read FOnCDATASection
      write FOnCDATASection;

    property OnCharData : TApdValueEvent
      read FOnCharData
      write FOnCharData;

    property OnComment : TApdValueEvent
      read FOnComment
      write FOnComment;

    property OnDocTypeDecl : TApdDocTypeDeclEvent
      read FOnDocTypeDecl
      write FOnDocTypeDecl;


    property OnEndDocument : TNotifyEvent
      read FOnEndDocument
      write FOnEndDocument;

    property OnEndElement : TApdValueEvent
      read FOnEndElement
      write FOnEndElement;

    property OnNonXMLEntity : TApdNonXMLEntityEvent
      read FOnNonXMLEntity
      write FOnNonXMLEntity;

    property OnPreserveSpace : TApdPreserveSpaceEvent
      read FOnPreserveSpace
      write FOnPreserveSpace;

    property OnProcessingInstruction : TApdProcessInstrEvent
      read FOnProcessingInstruction
      write FOnProcessingInstruction;

    property OnResolveEntity : TApdResolveEvent
      read FOnResolveEntity
      write FOnResolveEntity;

    property OnStartDocument : TNotifyEvent
      read FOnStartDocument
      write FOnStartDocument;

    property OnStartElement : TApdValueEvent
      read FOnStartElement
      write FOnStartElement;

    property OnBeginElement : TApdValueEvent
      read FOnBeginElement
      write FOnBeginElement;
  end;

implementation

{.$R *.RES}

uses
  AdExcept;


{== TApdEntityInfo ====================================================}
type
  TApdEntityInfo = class(TObject)
  private
    FEntityClass  : Integer;
    FIsPE         : Boolean;
    FPublicId     : DOMString;
    FSystemId     : DOMString;
    FValue        : DOMString;
    FNotationName : DOMString;
  public
    property EntityClass : Integer
      read FEntityClass
      write FEntityClass;

    property IsParameterEntity : Boolean
      read FIsPE
      write FIsPE;

    property NotationName : DOMString
      read FNotationName
      write FNotationName;

    property PublicId : DOMString
      read FPublicId
      write FPublicId;

    property SystemId : DOMString
      read FSystemId
      write FSystemId;

    property Value : DOMString
      read FValue
      write FValue;
  end;
{== TApdNotationInfo ==================================================}
  TApdNotationInfo = class(TObject)
  private
    FPublicId : DOMString;
    FSystemId : DOMString;
  public
    property PublicId : DOMString
      read FPublicId
      write FPublicId;

    property SystemId : DOMString
      read FSystemId
      write FSystemId;
  end;
{== TApdAttributeInfo =================================================}
  TApdAttributeInfo = class(TObject)
  private
    FType      : Integer;
    FValue     : DOMString;
    FValueType : Integer;
    FEnum      : DOMString;
    FLookup    : DOMString;
  public
    property AttrType : Integer
      read FType
      write FType;

    property Enum : DOMString
      read FEnum
      write FEnum;

    property Lookup : DOMString
      read FLookup
      write FLookup;

    property Value : DOMString
      read FValue
      write FValue;

    property ValueType : Integer
      read FValueType
      write FValueType;
  end;
{== TApdElementInfo ===================================================}
  TApdElementInfo = class(TObject)
  private
    FAttributeList : TStringList;
    FContentType   : Integer;
    FContentModel  : DOMString;
  public
    constructor Create;
    destructor Destroy; override;

    procedure SetAttribute(const sName     : DOMString;
                                 oAttrInfo : TApdAttributeInfo);

    property AttributeList : TStringList
      read FAttributeList;

    property ContentModel : DOMString
      read FContentModel
      write FContentModel;

    property ContentType : Integer
      read FContentType
      write FContentType;
  end;
{=== TApdElementInfo ==================================================}
constructor TApdElementInfo.Create;
begin
  inherited Create;
  FAttributeList := nil;
  FContentModel := '';
  FContentType := 0;
end;
{--------}
destructor TApdElementInfo.Destroy;
var
  i : Integer;
begin
  if FAttributeList <> nil then begin
    for i := 0 to FAttributeList.Count - 1 do
      TApdAttributeInfo(FAttributeList.Objects[i]).Free;
    FAttributeList.Free;
  end;
  inherited Destroy;
end;
{--------}
procedure TApdElementInfo.SetAttribute(const sName     : DOMString;
                                            oAttrInfo : TApdAttributeInfo);
var
  wIdx : Integer;
begin
  if FAttributeList = nil then begin
    FAttributeList := TStringList.Create;
    FAttributeList.Sorted := True;
    wIdx := -1
  end else
    wIdx := FAttributeList.IndexOf(sName);

  if wIdx < 0 then
    FAttributeList.AddObject(sName, oAttrInfo)
  else begin
    TApdAttributeInfo(FAttributeList.Objects[wIdx]).Free;
    FAttributeList.Objects[wIdx] := oAttrInfo;
  end;
end;

{=== TApdParser =======================================================}
constructor TApdParser.Create(oOwner : TComponent);
begin
  inherited Create(oOwner);

  FErrors := TStringList.Create;
  FAttributeType := TStringList.Create;
  FAttributeType.AddObject('CDATA', Pointer(ATTRIBUTE_CDATA));
  FAttributeType.AddObject('ID', Pointer(ATTRIBUTE_ID));
  FAttributeType.AddObject('IDREF', Pointer(ATTRIBUTE_IDREF));
  FAttributeType.AddObject('IDREFS', Pointer(ATTRIBUTE_IDREFS));
  FAttributeType.AddObject('ENTITY', Pointer(ATTRIBUTE_ENTITY));
  FAttributeType.AddObject('ENTITIES', Pointer(ATTRIBUTE_ENTITIES));
  FAttributeType.AddObject('NMTOKEN', Pointer(ATTRIBUTE_NMTOKEN));
  FAttributeType.AddObject('NMTOKENS', Pointer(ATTRIBUTE_NMTOKENS));
  FAttributeType.AddObject('NOTATION', Pointer(ATTRIBUTE_NOTATION));
  FElementInfo := TStringList.Create;
  FElementInfo.Sorted := True;
  FEntityInfo := TStringList.Create;
  FInCharSet := ceUnknown;
  FNotationInfo := TStringList.Create;
  FNotationInfo.Sorted := true;
  FNotationInfo.Duplicates := dupIgnore;
  FTagAttributes := TStringList.Create;
  FAttrEnum := TStringList.Create;
  FDocStack := TList.Create;
  FNormalizeData := True;
  FCDATA := False;
  FPreserve := False;
  FUrl := '';
  FRaiseErrors := False;
  FFilter := nil;
  FBufferSize := 8192;
  FCurrentPath := '';
  FTempFiles := TStringList.Create;
  FIsStandAlone := False;
  FHasExternals := False;
  FXMLDecParsed := False;
end;
{--------}
destructor TApdParser.Destroy;
var
  TempFilter : TApdInCharFilter;
  i          : Integer;
begin
  Cleanup;
  FTagAttributes.Free;
  FNotationInfo.Free;
  FEntityInfo.Free;
  FElementInfo.Free;
  FAttributeType.Free;
  FErrors.Free;
  if Assigned(FTempFiles) then begin
    for i := 0 to Pred(FTempFiles.Count) do
      DeleteFile(FTempFiles[i]);
    FTempFiles.Free;
  end;
  FAttrEnum.Free;
  if FDocStack.Count > 0 then begin
    for i := Pred(FDocStack.Count) to 0 do begin
      TempFilter := FDocStack[i];
      TempFilter.Free;
      FDocStack.Delete(i);
    end;
  end;
  FDocStack.Free;
  inherited Destroy;
end;
{--------}
procedure TApdParser.CheckParamEntityNesting(const aString : DOMString);
var
  OpenPos : Integer;
  ClosePos : Integer;
begin
  OpenPos := ApxPos('(', aString);
  ClosePos := ApxPos(')', aString);
  if (((OpenPos <> 0) and
       (ClosePos = 0)) or
      ((ClosePos <> 0) and
       (OpenPos = 0))) then
     raise EAdParserError.CreateError(FFilter.Line,
                                       FFilter.LinePos,
                                       sBadParamEntNesting +
                                       aString);
end;
{--------}
procedure TApdParser.Cleanup;
var
  i : Integer;
begin
  if FElementInfo <> nil then begin
    for i := 0 to FElementInfo.Count - 1 do
      TApdElementInfo(FElementInfo.Objects[i]).Free;
    FElementInfo.Clear;
  end;

  if FEntityInfo <> nil then begin
    for i := 0 to FEntityInfo.Count - 1 do
      TApdEntityInfo(FEntityInfo.Objects[i]).Free;
    FEntityInfo.Clear;
  end;

  if FNotationInfo <> nil then begin
    for i := 0 to FNotationInfo.Count - 1 do
      TApdNotationInfo(FNotationInfo.Objects[i]).Free;
    FNotationInfo.Clear;
  end;
end;
{--------}
procedure TApdParser.DataBufferAppend(const sVal : DOMString);
begin
  FDataBuffer := FDataBuffer + sVal;
end;
{--------}
procedure TApdParser.DataBufferFlush;
begin
  if FNormalizeData and
     not FCDATA and
     not FPreserve then
    DataBufferNormalize;
  if FDataBuffer <> '' then begin
    case FCurrentElementContent of
      CONTENT_MIXED, CONTENT_ANY :
        if FCDATA then begin
          ValidateCData(FDataBuffer);
          if Assigned(FOnCDATASection) then
            FOnCDATASection(self, FDataBuffer);
        end else begin
          if Assigned(FOnCharData) then
            FOnCharData(self, FDataBuffer);
        end;
      CONTENT_ELEMENTS :
        if Assigned(FOnIgnorableWhitespace) then
          FOnIgnorableWhitespace(self, FDataBuffer);
    end;
    FDataBuffer := '';
  end;
end;
{--------}
procedure TApdParser.DataBufferNormalize;
var
  BuffLen     : Integer;
  j           : Integer;
  CharDeleted : Boolean;
begin
  while (Length(FDataBuffer) > 0) and
        IsWhiteSpace(FDataBuffer[1]) do
    Delete(FDataBuffer, 1, 1);
  while (Length(FDataBuffer) > 0) and
        IsWhiteSpace(FDataBuffer[Length(FDataBuffer)]) do
    Delete(FDataBuffer, Length(FDataBuffer), 1);

  j := 1;
  BuffLen := Length(FDataBuffer);
  CharDeleted := False;
  while j < BuffLen do begin
    if IsWhiteSpace(FDataBuffer[j]) then begin
      { Force whitespace to a single space }
      FDataBuffer[j] := ' ';

      { Remove additional whitespace }
      j := j + 1;
      while (j <= Length(FDataBuffer)) and
            IsWhiteSpace(FDataBuffer[j]) do begin
        Delete(FDataBuffer, j, 1);
        CharDeleted := True;
      end;
      if (CharDeleted) then begin
        BuffLen := Length(FDataBuffer);
        CharDeleted := False;
      end;
    end;
    j := j + 1;
  end;
end;
{--------}
function TApdParser.DataBufferToString : DOMString;
begin
  Result := FDataBuffer;
  FDataBuffer := '';
end;
{--------}
function TApdParser.GetErrorCount : Integer;
begin
  Result := FErrors.Count;
end;
{--------}
function TApdParser.GetErrorMsg(wIdx : Integer) : DOMString;
begin
  Result := sIndexOutOfBounds;
  if (wIdx >= 0) and
     (wIdx < FErrors.Count) then
    Result := FErrors[wIdx];
end;
{--------}
function TApdParser.DeclaredAttributes(const sName : DOMString;
                                            aIdx  : Integer)
                                                  : TStringList;
begin
  if aIdx < 0 then
    Result := nil
  else
    Result := TApdElementInfo(FElementInfo.Objects[aIdx]).AttributeList;
end;
{--------}
function TApdParser.GetAttributeDefaultValueType(const sElemName,
                                                      sAttrName : DOMString)
                                                                : Integer;
var
  wIdx      : Integer;
  oAttrList : TStringList;
  oAttr     : TApdAttributeInfo;
begin
  Result := ATTRIBUTE_DEFAULT_UNDECLARED;
  wIdx := GetElementIndexOf(sElemName);
  if wIdx >= 0 then begin
    oAttrList := TApdElementInfo(FElementInfo.Objects[wIdx]).AttributeList;
    if oAttrList <> nil then begin
      wIdx := oAttrList.IndexOf(sAttrName);
      if wIdx >= 0 then begin
        oAttr := TApdAttributeInfo(oAttrList.Objects[wIdx]);
        Result := oAttr.AttrType;
      end;
    end;
  end;
end;
{--------}
function TApdParser.GetAttributeExpandedValue(const sElemName,
                                                   sAttrName : DOMString;
                                                   aIdx      : Integer)
                                                             : DOMString;
var
  wIdx      : Integer;
  oAttrList : TStringList;
  oAttr     : TApdAttributeInfo;
  HasEntRef : Boolean;
begin
  SetLength(Result, 0);
  HasEntRef := False;
  {wIdx := GetElementIndexOf(sElemName);}
  if aIdx >= 0 then begin
    oAttrList := TApdElementInfo(FElementInfo.Objects[aIdx]).AttributeList;
    if oAttrList <> nil then begin
      wIdx := oAttrList.IndexOf(sAttrName);
      if wIdx >= 0 then begin
        oAttr := TApdAttributeInfo(oAttrList.Objects[wIdx]);
        if (oAttr.Lookup = '') and
           (oAttr.Value <> '') then begin
          PushString('"' + oAttr.Value + '"');
          oAttr.Lookup := ReadLiteral(LIT_NORMALIZE or
                                      LIT_CHAR_REF or
                                      LIT_ENTITY_REF,
                                      HasEntRef);
          SkipWhitespace(True);
        end;
        Result := oAttr.Lookup;
      end;
    end;
  end;
end;
{--------}
function TApdParser.GetElementContentType(const sName : DOMString;
                                               aIdx  : Integer)
                                                     : Integer;
begin
  if aIdx < 0 then
    Result := CONTENT_UNDECLARED
  else
    Result := TApdElementInfo(FElementInfo.Objects[aIdx]).ContentType;
end;
{--------}
function TApdParser.GetElementIndexOf(const sElemName : DOMString)
                                                     : Integer;
begin
  Result := FElementInfo.IndexOf(sElemName);
end;
{--------}
function TApdParser.GetEntityIndexOf(const sEntityName : DOMString;
                                          aPEAllowed  : Boolean)
                                                      : Integer;
begin
  for Result := 0 to FEntityInfo.Count - 1 do
    if FEntityInfo[Result] = sEntityName then begin
      if (not aPEAllowed) then begin
        if (not TApdEntityInfo(FEntityInfo.Objects[Result]).IsParameterEntity) then
          Exit;
      end else
        Exit;
    end;
  Result := -1;
end;
{--------}
function TApdParser.GetEntityNotationName(const sEntityName : DOMString)
                                                           : DOMString;
var
  wIdx    : Integer;
  oEntity : TApdEntityInfo;
begin
  Result := '';
  wIdx := GetEntityIndexOf(sEntityName, False);
  if wIdx >= 0 then begin
    oEntity := TApdEntityInfo(FEntityInfo.Objects[wIdx]);
    Result := oEntity.NotationName;
  end;
end;
{--------}
function TApdParser.GetEntityPublicId(const sEntityName : DOMString)
                                                       : DOMString;
var
  wIdx    : Integer;
  oEntity : TApdEntityInfo;
begin
  Result := '';
  wIdx := GetEntityIndexOf(sEntityName, False);
  if wIdx >= 0 then begin
    oEntity := TApdEntityInfo(FEntityInfo.Objects[wIdx]);
    Result := oEntity.PublicId;
  end;
end;
{--------}
function TApdParser.GetEntitySystemId(const sEntityName : DOMString)
                                                       : DOMString;
var
  wIdx    : Integer;
  oEntity : TApdEntityInfo;
begin
  Result := '';
  wIdx := GetEntityIndexOf(sEntityName, False);
  if wIdx >= 0 then begin
    oEntity := TApdEntityInfo(FEntityInfo.Objects[wIdx]);
    Result := oEntity.SystemId;
  end;
end;
{--------}
function TApdParser.GetEntityType(const sEntityName : DOMString;
                                       aPEAllowed  : Boolean)
                                                   : Integer;
var
  wIdx    : Integer;
  oEntity : TApdEntityInfo;
begin
  Result := ENTITY_UNDECLARED;
  wIdx := GetEntityIndexOf(sEntityName, aPEAllowed);
  if wIdx >= 0 then begin
    oEntity := TApdEntityInfo(FEntityInfo.Objects[wIdx]);
    Result := oEntity.EntityClass;
  end;
end;
{--------}
function TApdParser.GetEntityValue(const sEntityName : DOMString;
                                        aPEAllowed  : Boolean)
                                                    : DOMString;
var
  wIdx    : Integer;
  oEntity : TApdEntityInfo;
begin
  Result := '';
  wIdx := GetEntityIndexOf(sEntityName, aPEAllowed);
  if wIdx >= 0 then begin
    oEntity := TApdEntityInfo(FEntityInfo.Objects[wIdx]);
    Result := oEntity.Value;
  end;
end;
{--------}
function TApdParser.GetExternalTextEntityValue(const sName,
                                                    sPublicId : DOMString;
                                                    sSystemId : DOMString)
                                                              : DOMString;
var
  CompletePath : string;
begin
  DataBufferFlush;
  Result := '';

  FHasExternals := True;

  if Assigned(FOnResolveEntity) then
    FOnResolveEntity(self, sName, sPublicId, sSystemId, sSystemId);

  if sSystemId = '' then
    exit;

  PushDocument;
  if (ApxPos('/', sSystemID) = 0) and
     (ApxPos('\', sSystemID) = 0) then
    CompletePath := FCurrentPath + sSystemID
  else
    CompletePath := sSystemID;
  {TODO:: Need to check return value of LoadDataSource? }
  try
    LoadDataSource(CompletePath, FErrors);
  except
    PopDocument;
    raise;
  end;
end;
{--------}
function TApdParser.GetInCharSet : TApdCharEncoding;
begin
  if FFilter <> nil then
    Result := ceUTF8
  else
    { If no current filter then return last known value. }
    Result := FInCharSet;
end;
{--------}
procedure TApdParser.Initialize;
begin
  FDataBuffer := '';

  SetInternalEntity('amp', '&#38;', False);
  SetInternalEntity('lt', '&#60;', False);
  SetInternalEntity('gt', '&#62;', False);
  SetInternalEntity('apos', '&#39;', False);
  SetInternalEntity('quot', '&#34;', False);
end;
{--------}
function TApdParser.IsEndDocument : Boolean;
var
  TheStream : TStream;
  DocCount  : Integer;
begin
  DocCount := FDocStack.Count;
  if (DocCount = 0) then
    Result := FFilter.Eof
  else begin
    Result := False;
    while FFilter.EOF do begin
      if (DocCount > 0) then begin
        TheStream := FFilter.Stream;
        FFilter.Free;
        TheStream.Free;
      end;
      PopDocument;
      DocCount := FDocStack.Count;
    end;
  end;
end;
{--------}
function TApdParser.IsWhitespace(const cVal : DOMChar) : Boolean;
begin
  Result := (cVal = #$20) or (cVal = #$09) or
            (cVal = #$0D) or (cVal = #$0A);
end;
{--------}
function TApdParser.LoadDataSource(sSrcName  : string;
                                  oErrors   : TStringList) : Boolean;
var
  aFileStream : TApdFileStream;
begin
  begin
    { Must be a local or network file. Eliminate file:// prefix. }
    if StrLIComp(PChar(sSrcName), 'file://', 7) = 0 then
      Delete(sSrcName, 1, 7);

    if FileExists(sSrcName) then begin
      FCurrentPath := ExtractFilePath(sSrcName);
      {the stream and filter are destroyed after the document is parsed}
      aFileStream := TApdFileStream.CreateEx(fmOpenRead, sSrcName);
      aFileStream.Position := 0;
      Result := True;
    end else begin
      oErrors.Add(format(sFileNotFound, [sSrcName]));
      raise EAdParserError.CreateError(0,
                                       0,
                                       format(sFileNotFound, [sSrcName]));
    end;
  end;

  if Result then
    try
      aFileStream.Position := 0;
      FFilter := TApdInCharFilter.Create(aFileStream, FBufferSize);
    except
      aFileStream.Free;
      raise;
    end;
end;
{--------}
function TApdParser.ParseAttribute(const sName : DOMString) : DOMString;
var
  sAttrName,
  sValue    : DOMString;
  wType     : Integer;
  HasEntRef : Boolean;
begin
  Result := '';
  HasEntRef := False;
  sAttrName := ReadNameToken(True);
  wType := GetAttributeDefaultValueType(sName, sAttrName);

  ParseEq;

  {we need to validate production 10 - 1st letter in quotes}

  if (wType = ATTRIBUTE_CDATA) or (wType = ATTRIBUTE_UNDECLARED) then
    sValue := ReadLiteral(LIT_CHAR_REF or LIT_ENTITY_REF, HasEntRef)
  else
    sValue := ReadLiteral(LIT_CHAR_REF or
                          LIT_ENTITY_REF or
                          LIT_NORMALIZE,
                          HasEntRef);
  if not HasEntRef then
    ValidateAttribute(sValue, HasEntRef);

  if Assigned(FOnAttribute) then
    FOnAttribute(self, sAttrName, sValue, True);
  FDataBuffer := '';

  FTagAttributes.Add(sAttrName);
  if sAttrName = 'xml:space' then
    Result := sValue;
end;
{--------}
procedure TApdParser.ParseCDSect;
{conditional section}
begin
  ParseUntil(Xpc_ConditionalEnd);
end;
{--------}
function TApdParser.ParseCharRef : DOMChar;
var
  TempChar  : DOMChar;
  Ucs4Chr   : TApdUcs4Char;
begin
  Ucs4Chr := 0;
  if TryRead(Xpc_CharacterRefHex) then begin
   Ucs4Chr := 0;
    while True do begin
      TempChar := ReadChar(True);
      if (TempChar = '0') or (TempChar = '1') or (TempChar = '2') or
         (TempChar = '3') or (TempChar = '4') or (TempChar = '5') or
         (TempChar = '6') or (TempChar = '7') or (TempChar = '8') or
         (TempChar = '9') or (TempChar = 'A') or (TempChar = 'B') or
         (TempChar = 'C') or (TempChar = 'D') or (TempChar = 'E') or
         (TempChar = 'F') or (TempChar = 'a') or (TempChar = 'b') or
         (TempChar = 'c') or (TempChar = 'd') or (TempChar = 'e') or
         (TempChar = 'f') then begin
        Ucs4Chr := Ucs4Chr shl 4;
        Ucs4Chr := Ucs4Chr + StrToIntDef(TempChar, 0);
      end else if (TempChar = ';') then
        Break
      else
        raise EAdParserError.CreateError(FFilter.Line,
                                         FFilter.LinePos,
                                         sIllCharInRef +
                                         QuotedStr(TempChar));
    end;
  end else begin
    while True do begin
      TempChar := ReadChar(True);
      if (TempChar = '0') or (TempChar = '1') or (TempChar = '2') or
         (TempChar = '3') or (TempChar = '4') or (TempChar = '5') or
         (TempChar = '6') or (TempChar = '7') or (TempChar = '8') or
         (TempChar = '9') then begin
        Ucs4Chr := Ucs4Chr * 10;
        Ucs4Chr := Ucs4Chr + StrToIntDef(TempChar, 0);
      end else if (TempChar = ';') then
        Break
      else
        raise EAdParserError.CreateError(FFilter.Line,
                                         FFilter.LinePos,
                                         sIllCharInRef +
                                         QuotedStr(TempChar));
    end;
  end;
  ApxUcs4ToWideChar(Ucs4Chr, Result);
  DataBufferAppend(Result);
end;
{--------}
procedure TApdParser.ParseComment;
var
  TempComment : DOMString;
begin
  ParseUntil(Xpc_CommentEnd);
  TempComment := DataBufferToString;
  { Did we find '--' within the comment? }
  if (TempComment <> '') and
     ((ApxPos('--', TempComment) <> 0) or
      (TempComment[Length(TempComment)] = '-')) then
    { Yes. Raise an error. }
    raise EAdParserError.CreateError(FFilter.Line,
                                     FFilter.LinePos,
                                     sInvalidCommentText);
  if Assigned(FOnComment) then
    FOnComment(self, TempComment);
end;
{--------}
procedure TApdParser.ParseContent;
var
  TempChar    : DOMChar;
  TempStr     : DOMString;
  EntRefs     : TStringList;
  OldLine     : Integer;
  OldPos      : Integer;
  TempInt     : Integer;
  StackLevel  : Integer;
  LastCharAmp : Boolean;
begin
  LastCharAmp := False;
  StackLevel := 0;
  TempChar := #0;
  EntRefs := nil;
  while True do begin
    OldLine := FFilter.Line;
    OldPos := FFilter.LinePos;
    case FCurrentElementContent of
      CONTENT_ANY, CONTENT_MIXED :
        begin
          if Assigned(EntRefs) then begin
            if (FDataBuffer <> '&') or
               (LastCharAmp) then begin
              ParsePCData(True);
              LastCharAmp := False;
            end;
            { Reset the last ent ref if we parsed something.}
            if (FFilter.Line <> OldLine) and
               (FFilter.LinePos <> OldPos) then begin
              EntRefs.Free;
              EntRefs := nil;
            end;
          end else
            ParsePCData(TempChar <> '');
        end;
      CONTENT_ELEMENTS           : ParseWhitespace;
    end;
    TempChar := ReadChar(False);
    if IsEndDocument then
      raise EAdParserError.CreateError(FFilter.Line,
                                       FFilter.LinePos,
                                       sUnexpectedEof);
    if (TempChar = '&') then begin
      SkipChar;
      TempChar := ReadChar(False);
      if TempChar = '#' then begin
        SkipChar;
        TempChar := ParseCharRef;
        if TempChar = '&' then
          LastCharAmp := True;
        if (FCurrentElementContent <> CONTENT_ANY) and
           (FCurrentElementContent <> CONTENT_MIXED) then
          PushString(TempChar);
      end else begin
        if (not Assigned(EntRefs)) then begin
          StackLevel := Succ(FDocStack.Count);
          EntRefs := TStringList.Create;
          TempStr := ParseEntityRef(False);
        end else begin
          {Check for circular references}
          TempStr := ParseEntityRef(False);
          StackLevel := FDocStack.Count;
          TempInt := EntRefs.IndexOf(TempStr);
          if TempInt <> -1 then
            raise EAdParserError.CreateError(FFilter.Line,
                                             FFilter.LinePos,
                                             sCircularEntRef +
                                             TempStr);
        end;
        EntRefs.Add(TempStr);
      end;
      if (FCurrentElementContent <> CONTENT_ANY) and
         (FCurrentElementContent <> CONTENT_MIXED) and
         (TempChar = '<') then begin
        DataBufferFlush;
        ParseElement;
      end else
        TempChar := ReadChar(False);
    end else if (TempChar = '<') then begin
      EntRefs.Free;
      EntRefs := nil;
      SkipChar;
      TempChar := ReadChar(False);
      if (TempChar = '!') then begin
        SkipChar;
        DataBufferFlush;
        TempChar := ReadChar(True);
        if (TempChar = '-') then begin
          Require(Xpc_Dash);
          ParseComment;
        end else if (TempChar = '[') then begin
          Require(Xpc_CDATAStart);
          FCDATA := True;
          ParseCDSect;
          ValidateCData(FDataBuffer);
          DataBufferFlush;
          FCDATA := False;
        end else
          raise EAdParserError.CreateError(FFilter.Line,
                                           FFilter.LinePos,
                                           sExpCommentOrCDATA +
                                           '(' + TempChar + ')');
      end else if (TempChar = '?') then begin
        EntRefs.Free;
        EntRefs := nil;
        SkipChar;
        DataBufferFlush;
        ParsePI;
      end else if (TempChar = '/') then begin
        SkipChar;
        DataBufferFlush;
        ParseEndTag;
        Exit;
      end else begin
        EntRefs.Free;
        EntRefs := nil;
        DataBufferFlush;
        ParseElement;
      end;
    end; {if..else}
    if (Assigned(EntRefs)) and
       (FDocStack.Count < StackLevel) then begin
      EntRefs.Clear;
      StackLevel := FDocStack.Count;
    end;
  end;
  EntRefs.Free;
end;
{--------}
function TApdParser.ParseDataSource(const sSource : string) : Boolean;
begin
  FErrors.Clear;
  FIsStandAlone := False;
  FHasExternals := False;
  FUrl := sSource;
  Result := LoadDataSource(sSource, FErrors);
  if Result then begin
    FFilter.FreeStream := True;
    ParsePrim;
  end
  else
    FErrors.Add(sSrcLoadFailed + sSource);
  FUrl := '';
  Result := FErrors.Count = 0;
end;
{--------}
procedure TApdParser.ParseDocTypeDecl;
var
  sDocTypeName : DOMString;
  sIds         : StringIds;
begin
  RequireWhitespace;
  sDocTypeName := ReadNameToken(True);
  SkipWhitespace(True);
  ReadExternalIds(False, sIds);
  SkipWhitespace(True);

  // Parse external DTD
  if sIds[1] <> '' then begin
  end;

  if sIds[1] <> '' then begin
    while True do begin
      FContext := CONTEXT_DTD;
      SkipWhitespace(True);
      FContext := CONTEXT_NONE;
      if TryRead(Xpc_BracketAngleRight) then
        Break
      else begin
        FContext := CONTEXT_DTD;
        FContext := CONTEXT_NONE;
      end;
    end;
  end else begin
    SkipWhitespace(True);
    Require(Xpc_BracketAngleRight);
  end;

  if Assigned(FOnDocTypeDecl) then
    FOnDocTypeDecl(self, sDocTypeName, sIds[0], sIds[1]);
end;
{--------}
procedure TApdParser.ParseDocument;
begin
  FXMLDecParsed := False;
  ParseProlog;
  Require(Xpc_BracketAngleLeft);
  ParseElement;
  try
    ParseMisc;
  except
  end;
  SkipWhiteSpace(True);
  if (not IsEndDocument) then
    raise EAdParserError.CreateError(FFilter.Line,
                                     FFilter.LinePos,
                                     sDataAfterValDoc);

  if Assigned(FOnEndDocument) then
    FOnEndDocument(self);
end;
{--------}
procedure TApdParser.ParseElement;
var
  wOldElementContent,
  i                  : Integer;
  sOldElement        : DOMString;
  sGi, sTmp, sTmp2   : DOMString;
  oTmpAttrs          : TStringList;
  bOldPreserve       : Boolean;
  TempChar           : DOMChar;
  aList              : TStringList;
  ElemIdx            : Integer;
begin
  wOldElementContent := FCurrentElementContent;
  sOldElement := FCurrentElement;
  bOldPreserve := FPreserve;

  FTagAttributes.Clear;
  sGi := ReadNameToken(True);

  ValidateElementName(sGi);

  if Assigned(FOnBeginElement) then
    FOnBeginElement(self, sGi);

  FCurrentElement := sGi;
  ElemIdx := GetElementIndexOf(sGi);
  FCurrentElementContent := GetElementContentType(sGi, ElemIdx);
  if FCurrentElementContent = CONTENT_UNDECLARED then
    FCurrentElementContent := CONTENT_ANY;

  SkipWhitespace(True);
  sTmp := '';
  TempChar := ReadChar(False);
  while (TempChar <> '/') and
        (TempChar <> '>') do begin
    sTmp2 := ParseAttribute(sGi);
    if sTmp2 <> '' then
      sTmp := sTmp2;
    SkipWhitespace(True);          
    TempChar := ReadChar(False);
    { check for duplicate attributes }
    if FTagAttributes.Count > 1 then begin
      aList := TStringList.Create;
      try
        aList.Sorted := True;
        aList.Duplicates := dupIgnore;
        aList.Assign(FTagAttributes);
        if (aList.Count <> FTagAttributes.Count) then
          raise EAdParserError.CreateError(FFilter.Line,
                                           FFilter.LinePos,
                                           sRedefinedAttr);
      finally
        aList.Free;
      end;
    end;
  end;

  oTmpAttrs := DeclaredAttributes(sGi, ElemIdx);
  if oTmpAttrs <> nil then begin
    for i := 0 to oTmpAttrs.Count - 1 do begin
      if FTagAttributes.IndexOf(oTmpAttrs[i]) <> - 1 then
        Continue;

      if Assigned(FOnAttribute) then begin
        sTmp2 := GetAttributeExpandedValue(sGi, oTmpAttrs[i], ElemIdx);
        if sTmp2 <> '' then
          FOnAttribute(self, oTmpAttrs[i], sTmp2, False);
      end;
    end;
  end;

  if sTmp = '' then
    sTmp := GetAttributeExpandedValue(sGi, 'xml:space', ElemIdx);
  if sTmp = 'preserve' then
    FPreserve := True
  else if sTmp = 'default' then
    FPreserve := not FNormalizeData;

  if Assigned(FOnPreserveSpace) then
    FOnPreserveSpace(self, sGi, FPreserve);

  TempChar := ReadChar(True);
  if (TempChar = '>') then begin
    if Assigned(FOnStartElement) then
      FOnStartElement(self, sGi);
    ParseContent;
  end else if (TempChar = '/') then begin
    Require(Xpc_BracketAngleRight);
    if Assigned(FOnStartElement) then
      FOnStartElement(self, sGi);
    if Assigned(FOnEndElement) then
      FOnEndElement(self, sGi);
  end;

  FPreserve := bOldPreserve;
  FCurrentElement := sOldElement;
  FCurrentElementContent := wOldElementContent;
end;
{--------}
procedure TApdParser.ParseEndTag;
var
  sName : DOMString;
begin
  sName := ReadNameToken(True);
  if sName <> FCurrentElement then
    raise EAdParserError.CreateError(FFilter.Line,
                                     FFilter.LinePos,
                                     sMismatchEndTag +
                                     'Start tag = "' + FCurrentElement +
                                     '" End tag = "' + sName + '"');
  SkipWhitespace(True);
  Require(Xpc_BracketAngleRight);
  if Assigned(FOnEndElement) then
    FOnEndElement(self, FCurrentElement);
end;
{--------}
function TApdParser.ParseEntityRef(bPEAllowed : Boolean) : DOMString;
begin
  Result := ReadNameToken(True);
  Require(Xpc_GenParsedEntityEnd);
  case GetEntityType(Result, bPEAllowed) of
    ENTITY_UNDECLARED :
      begin
        raise EAdParserError.CreateError(FFilter.Line,
                                         FFilter.LinePos,
                                         sUndeclaredEntity +
                                         QuotedStr(Result));
      end;
    ENTITY_INTERNAL :
      PushString(GetEntityValue(Result, False));
    ENTITY_TEXT :
      begin
        (GetExternalTextEntityValue(Result,
                                    GetEntityPublicId(Result),
                                    GetEntitySystemId(Result)));
      end;
    ENTITY_NDATA :
      begin
        FHasExternals := True;
        if Assigned(FOnNonXMLEntity) then
          FOnNonXMLEntity(self,
                          Result,
                          GetEntityPublicId(Result),
                          GetEntitySystemId(Result),
                          GetEntityNotationName(Result));
      end;
  end;
end;
{--------}
procedure TApdParser.ParseEq;
begin
  SkipWhitespace(True);
  Require(Xpc_Equation);
  SkipWhitespace(True);
end;
{--------}
function TApdParser.ParseMemory(var aBuffer; aSize : Integer) : Boolean;
var
  MemStream  : TApdMemoryStream;
begin
  Assert(not Assigned(FFilter));

  FErrors.Clear;
  FPreserve := False;
  FIsStandAlone := False;
  FHasExternals := False;

  MemStream := TApdMemoryStream.Create;
  try
    Memstream.SetPointer(@aBuffer, aSize);
    FFilter := TApdInCharFilter.Create(MemStream, BufferSize);
    ParsePrim;
  finally
    MemStream.Free;
  end;

  Result := FErrors.Count = 0;
end;
{--------}
procedure TApdParser.ParseMisc;
var
  ParsedComment : Boolean;
begin
  ParsedComment := False;
  while True do begin
    SkipWhitespace(True);
    if TryRead(Xpc_ProcessInstrStart) then begin
      if ParsePIEx and ParsedComment then
        raise EAdParserError.CreateError(FFilter.Line,
                                         FFilter.LinePos,
                                         sCommentBeforeXMLDecl)
      else
        FXMLDecParsed := True;
    end else if TryRead(Xpc_CommentStart) then begin
      FXMLDecParsed := True;
      ParsedComment := True;
      ParseComment;
    end else
      Exit;
  end;
end;
{--------}
function TApdParser.ParseParameterEntityRef(aPEAllowed : Boolean;
                                           bSkip      : Boolean)
                                                      : DOMString;
var
  sName,
  sValue : DOMString;
begin
  sName := ReadNameToken(True);
  Require(Xpc_GenParsedEntityEnd);
  case GetEntityType(sName, aPEAllowed) of
    ENTITY_UNDECLARED :
      raise EAdParserError.CreateError(FFilter.Line,
                                       FFilter.LinePos - 3,
                                       sUndeclaredEntity + sName);
    ENTITY_INTERNAL :
      begin
        sValue := GetEntityValue(sName, aPEAllowed);
        if bSkip then
          DataBufferAppend(sValue)
        else
          PushString(sValue);
        Result := sValue;
      end;
    ENTITY_TEXT :
      begin
        sValue := GetExternalTextEntityValue(sName,
                                             GetEntityPublicId(sName),
                                             GetEntitySystemId(sName));
        if bSkip then
          DataBufferAppend(sValue);
        Result := sValue;
      end;
    ENTITY_NDATA :
      begin
        FHasExternals := True;
        if Assigned(FOnNonXMLEntity) then
          FOnNonXMLEntity(self,
                          sName,
                          GetEntityPublicId(sName),
                          GetEntitySystemId(sName),
                          GetEntityNotationName(sName));
      end;
  end;
end;
{--------}
procedure TApdParser.ParsePCData(aInEntityRef : Boolean);
var
  TempBuff   : DOMString;
  TempChar   : DOMChar;
  CurrLength : Integer;
  BuffLength : Integer;
  Added      : Boolean;
begin
  Added := False;
  CurrLength := 0;
  BuffLength := 50;
  SetLength(TempBuff, BuffLength);
  while True do begin
    TempChar := ReadChar(False);
    if (TempChar = '<') or
       (TempChar = '&') or
       (FFilter.EOF) then
      Break
    else begin
      if ((CurrLength + 2) > BuffLength) then begin
        BuffLength := BuffLength * 2;
        SetLength(TempBuff, BuffLength);
      end;
      Move(TempChar,
           PByteArray(Pointer(TempBuff))[CurrLength],
           2);
      Inc(CurrLength, 2);
      SkipChar;
      Added := True;
    end;
  end;
  if Added then begin
    SetLength(TempBuff, CurrLength div 2);
    ValidatePCData(TempBuff, aInEntityRef);
    DataBufferAppend(TempBuff);
  end;
end;
{--------}
procedure TApdParser.ParsePI;
begin
  ParsePIEx;
end;
{--------}
function TApdParser.ParsePIEx : Boolean;
var
  sName : DOMString;
begin
  Result := False;
  sName := ReadNameToken(True);
  if sName <> 'xml' then begin
    FXMLDecParsed := True;
    if not TryRead(Xpc_ProcessInstrEnd) then begin
      RequireWhitespace;
      ParseUntil(Xpc_ProcessInstrEnd);
    end;
  end else begin
    Result := True;
    ParseXMLDeclaration;
  end;
  if Assigned(FOnProcessingInstruction) then
    FOnProcessingInstruction(self, sName, DataBufferToString)
  else
    DataBufferToString;
end;
{--------}
procedure TApdParser.ParsePrim;
begin
  try
    Initialize;

    if Assigned(FOnStartDocument) then
      FOnStartDocument(self);

    try
      ParseDocument;
    except
      on E: EAdFilterError do begin
        FErrors.Add(Format(sFmtErrorMsg,
                           [E.Line, E.LinePos, E.Message]));
        if FRaiseErrors then begin
          if Assigned(FOnEndDocument) then
            FOnEndDocument(self);
          Cleanup;
          raise;
        end;
      end;
    end;

    if Assigned(FOnEndDocument) then
      FOnEndDocument(self);

    Cleanup;
  finally
    FInCharSet := ceUTF8;
    FFilter.Free;
    FFilter := nil;
  end;
end;
{--------}
procedure TApdParser.ParseProlog;
begin
  ParseMisc;
  if TryRead(Xpc_DTDDocType) then begin
    FXMLDecParsed := True;
    ParseDocTypeDecl;
    ParseMisc;
  end;
end;
{--------}
function TApdParser.ParseStream(oStream : TStream) : Boolean;
begin
  Assert(not Assigned(FFilter));

  FErrors.Clear;
  FPreserve := False;
  FIsStandAlone := False;
  FHasExternals := False;

  oStream.Position := 0;
  FFilter := TApdInCharFilter.Create(oStream, oStream.Size);
  ParsePrim;
  Result := FErrors.Count = 0;
end;
{--------}
procedure TApdParser.ParseUntil(const S : array of Integer);
var
  TempStr  : AnsiString;
  TempChar : AnsiChar;
  i        : Integer;
  Found    : Boolean;
begin
  Found := TryRead(s);
  while (not Found) and
        (not FFilter.EOF) do begin
    DataBufferAppend(ReadChar(True));
    Found := TryRead(s);
  end;
  if (not Found) then begin
    SetLength(TempStr, Length(S));
    for i := 0 to High(S) do begin
      ApxUcs4ToIso88591(s[i], TempChar);
      TempStr[Succ(i)] := TempChar;
    end;
    raise EAdParserError.CreateError(FFilter.Line,
                                     FFilter.LinePos,
                                     sUnexpEndOfInput +
                                     QuotedStr(string(TempStr)));
  end;
end;
{--------}
procedure TApdParser.ParseWhitespace;
var
  TempChar : DOMChar;
begin
  TempChar := ReadChar(False);
  while IsWhitespace(TempChar) do begin
    SkipChar;
    DataBufferAppend(TempChar);
    TempChar := ReadChar(False);
  end;
end;
{--------}
procedure TApdParser.ParseXMLDeclaration;
var
  sValue    : DOMString;
  Buffer    : DOMString;
  HasEntRef : Boolean;
begin
  if FXMLDecParsed then
    raise EAdParserError.CreateError(FFilter.Line,
                                     FFilter.LinePos,
                                     sXMLDecNotAtBeg);
  HasEntRef := False;
  SkipWhitespace(True);
  Require(Xpc_Version);
  DatabufferAppend('version');
  ParseEq;
  DatabufferAppend('="');
  Buffer := DatabufferToString;
  sValue := ReadLiteral(0, HasEntRef);
  ValidateVersNum(sValue);
  Buffer := Buffer + sValue + '"';
  if (sValue <> ApdXMLSpecification) then
    raise EAdParserError.CreateError(FFilter.Line,
                                     FFilter.LinePos,
                                     Format(sInvalidXMLVersion,
                                            [ApdXMLSpecification]));
  SkipWhitespace(True);
    if TryRead(Xpc_Encoding) then begin
      DatabufferAppend('encoding');
      ParseEq;
      DataBufferAppend('="');
      Buffer := Buffer + ' ' + DataBufferToString;
      sValue := ReadLiteral(LIT_CHAR_REF or
                            LIT_ENTITY_REF,
                            HasEntRef);
      ValidateEncName(sValue);
      Buffer := Buffer + sValue + '"';
      if CompareText(sValue, 'ISO-8859-1') = 0 then
        FFilter.Format := sfISO88591;
      SkipWhitespace(True);
  end;

    if TryRead(Xpc_Standalone) then begin
      DatabufferAppend('standalone');
      ParseEq;
      DatabufferAppend('="');
      Buffer := Buffer + ' ' + DataBufferToString;
      sValue := ReadLiteral(LIT_CHAR_REF or
                            LIT_ENTITY_REF,
                            HasEntRef);
      if (not ((sValue = 'yes') or
               (sValue = 'no'))) then
        raise EAdParserError.CreateError(FFilter.Line,
                                         FFilter.LinePos,
                                         sInvStandAloneVal);
      Buffer := Buffer + sValue + '"';
      FIsStandalone := sValue = 'yes';
      SkipWhitespace(True)
  end;

  Require(Xpc_ProcessInstrEnd);
  DatabufferToString;
  DatabufferAppend(Buffer);
end;
{--------}
procedure TApdParser.PopDocument;
begin
  Assert(FDocStack.Count > 0);

  if FDocStack.Count > 0 then begin
    FFilter := FDocStack[Pred(FDocStack.Count)];
    FDocStack.Delete(Pred(FDocStack.Count));
  end;
end;
{--------}
procedure TApdParser.PushDocument;
begin
  Assert(Assigned(FFilter));

  FDocStack.Add(Pointer(FFilter));
  FFilter := nil;
end;
{--------}
procedure TApdParser.PushString(const sVal : DOMString);
var
  MemStream  : TApdMemoryStream;
  TempString : ansistring;
begin
  if Length(sVal) > 0 then begin
    PushDocument;
    MemStream := TApdMemoryStream.Create;
    TempString := AnsiString(WideCharLenToString(Pointer(sVal), Length(sVal)));
    MemStream.Write(TempString[1], Length(TempString));
    MemStream.Position := 0;
    FFilter := TApdInCharFilter.Create(MemStream, BufferSize);
  end;
end;
{--------}
function TApdParser.ReadChar(const UpdatePos : Boolean) : DOMChar;
begin
  Result := FFilter.ReadChar;
  if ((Result = ApxEndOfStream) and
      (not IsEndDocument)) then
    Result := FFilter.ReadChar;
  if (UpdatePos) then
    FFilter.SkipChar;
end;
{--------}
procedure TApdParser.ReadExternalIds(bInNotation : Boolean;
                                var sIds        : StringIds);
var
  HasEntRef : Boolean;
  TempChar  : DOMChar;
begin
  HasEntRef := False;
  if TryRead(Xpc_ExternalPublic) then begin
    RequireWhitespace;
    sIds[0] := ReadLiteral(LIT_NORMALIZE, HasEntRef);
    ValidatePublicID(sIds[0]);
    if bInNotation then begin
      SkipWhitespace(True);
      TempChar := ReadChar(False);
      if (TempChar = '''') or
         (TempChar = '"') then
        sIds[1] := ReadLiteral(0, HasEntRef);
    end else begin
      RequireWhitespace;
      sIds[1] := ReadLiteral(0, HasEntRef);
    end;
  end else if TryRead(Xpc_ExternalSystem) then begin
    RequireWhitespace;
    sIds[1] := ReadLiteral(0, HasEntRef);
  end;
end;
{--------}
function TApdParser.ReadLiteral(wFlags    : Integer;
                           var HasEntRef : Boolean) : DOMString;
var
  TempStr     : DOMString;
  cDelim,
  TempChar    : DOMChar;
  EntRefs     : TStringList;
  StackLevel  : Integer;
  CurrCharRef : Boolean;
begin
  StackLevel := 0;
  CurrCharRef := False;
  Result := '';
  EntRefs := nil;
  cDelim := ReadChar(True);
  if (cDelim <> '"') and
     (cDelim <> #39) and
     (cDelim <> #126) and
     (cDelim <> #0) then
    raise EAdParserError.CreateError(FFilter.Line,
                                     FFilter.LinePos,
                                     sQuoteExpected);
  TempChar := ReadChar(False);
  while (not IsEndDocument) and
        ((CurrCharRef) or
         (TempChar <> cDelim)) do begin
    if (TempChar = #$0A) then begin
      TempChar := ' ';
    end else if (TempChar = #$0D) then
      TempChar := ' '
    else if (TempChar = '&') then begin
      if wFlags and LIT_CHAR_REF <> 0 then begin
        if wFlags and LIT_ENTITY_REF <> 0 then
          CurrCharRef := True;
        HasEntRef := True;
        SkipChar;
        TempChar := ReadChar(False);
        if TempChar = '#' then begin
          SkipChar;
          ParseCharRef;
          TempChar := ReadChar(False);
          CurrCharRef := False;
          Continue;
        end else if wFlags and LIT_ENTITY_REF <> 0 then begin
          TempStr := ParseEntityRef(False);
          if (TempStr <> 'lt') and
             (TempStr <> 'gt') and
             (TempStr <> 'amp') and
             (TempStr <> 'apos') and
             (TempStr <> 'quot') then begin
            if (not Assigned(EntRefs)) then begin
              EntRefs := TStringList.Create;
              EntRefs.Sorted := True;
              EntRefs.Duplicates := dupError;
              StackLevel := FDocStack.Count;
            end else
              StackLevel := Succ(FDocStack.Count);
            try
              if FDocStack.Count = StackLevel then begin
                EntRefs.Clear;
                StackLevel := FDocStack.Count;
              end;
              EntRefs.Add(TempStr);
            except
              on E:EStringListError do begin
                EntRefs.Free;
                raise EAdParserError.CreateError(FFilter.Line,
                                                 FFilter.LinePos,
                                                 sCircularEntRef +
                                                 TempChar);
              end;
              on E:EAdParserError do
                raise;
            end;
          end else
            HasEntRef := False;
          TempChar := ReadChar(False);
          Continue;
        end else if wFlags and LIT_PE_REF <> 0 then begin
          ParseParameterEntityRef(False, True);
          Continue;
        end else
          DataBufferAppend('&');
          if (not Assigned(EntRefs)) then begin
            StackLevel := FDocStack.Count;
            EntRefs := TStringList.Create;
            EntRefs.Sorted := True;
            EntRefs.Duplicates := dupError;
          end;
          try
            if StackLevel = FDocStack.Count then begin
              EntRefs.Clear;
              StackLevel := FDocStack.Count;
            end;
            EntRefs.Add('&' + DOMString(TempChar));
          except
            on E:EStringListError do begin
              EntRefs.Free;
              raise EAdParserError.CreateError(FFilter.Line,
                                               FFilter.LinePos,
                                               sCircularEntRef +
                                               TempChar);
            end;
            on E:EAdParserError do
              raise;
          end;
      end;
    end;
    DataBufferAppend(TempChar);
    SkipChar;
    TempChar := ReadChar(False);
    CurrCharRef := False;
  end;
  if TempChar <> cDelim then
    raise EAdParserError.CreateError(FFilter.Line,
                                     FFilter.LinePos,
                                     'Expected: ' + cDelim);

  SkipChar;

  if wFlags and LIT_NORMALIZE <> 0 then
    DataBufferNormalize;

  Result := DataBufferToString;

  EntRefs.Free;
end;
{--------}
function TApdParser.ReadNameToken(aValFirst : Boolean) : DOMString;
var
  TempChar : DOMChar;
  First    : Boolean;
  ResultLen : Integer;
  CurrLen   : Integer;
begin
  if TryRead(Xpc_ParamEntity) then begin
    ParseParameterEntityRef(True, False);
    SkipWhiteSpace(True);
  end;
  First := aValFirst;
  Result := '';
  CurrLen := 0;
  ResultLen := 20;
  SetLength(Result, ResultLen);
  while True do begin
    TempChar := ReadChar(False);
    if (TempChar = '%') or (TempChar = '<') or (TempChar = '>') or
       (TempChar = '&') or (TempChar = ',') or (TempChar = '|') or
       (TempChar = '*') or (TempChar = '+') or (TempChar = '?') or
       (TempChar = ')') or (TempChar = '=') or (TempChar = #39) or
       (TempChar = '"') or (TempChar = '[') or (TempChar = ' ') or
       (TempChar = #9) or (TempChar = #$0A) or (TempChar = #$0D) or
       (TempChar = ';') or (TempChar = '/') or (TempChar = '') or
       (TempChar = #1) then
      Break
    else
      if ValidateNameChar(First, TempChar) then begin
        if (CurrLen + 2 > ResultLen) then begin
          ResultLen := ResultLen * 2;
          SetLength(Result, ResultLen);
        end;
        SkipChar;
        Move(TempChar,
             PByteArray(Pointer(Result))^[CurrLen],
             2);
        Inc(CurrLen, 2);
      end else
        raise EAdParserError.CreateError(FFilter.Line,
                                         FFilter.LinePos,
                                         sInvalidName +
                                         QuotedStr(TempChar));
    First := False;
  end;
  SetLength(Result, CurrLen div 2);
end;
{--------}
procedure TApdParser.Require(const S : array of Integer);
var
  TempStr  : AnsiString;
  TempChar : AnsiChar;
  i        : Integer;
begin
  if not TryRead(S) then begin
    SetLength(TempStr, High(S) + 1);
    for i := 0 to High(S) do begin
      ApxUcs4ToIso88591(s[i], TempChar);
      TempStr[i + 1] := TempChar;
    end;
    if ReadChar(False) = '&' then begin
      SkipChar;
      if ReadChar(False) = '#' then begin
        SkipChar;
        if ParseCharRef = string(TempStr) then
          Exit;
      end;
    end;
    raise EAdParserError.CreateError(FFilter.Line,
                                     FFilter.LinePos,
                                     sExpectedString +
                                     QuotedStr(string(TempStr)));
  end;
end;
{--------}
procedure TApdParser.RequireWhitespace;
begin
  if IsWhitespace(ReadChar(False)) then
    SkipWhitespace(True)
  else
    raise EAdParserError.CreateError(FFilter.Line,
                                     FFilter.LinePos,
                                     sSpaceExpectedAt +
                                       'Line: ' + IntToStr(FFilter.Line) +
                                       ' Position: ' + IntToStr(FFilter.LinePos));
end;
{--------}
procedure TApdParser.SetAttribute(const sElemName, sName : DOMString;
                                       wType            : Integer;
                                 const sEnum, sValue    : DOMString;
                                       wValueType       : Integer);
var
  wIdx      : Integer;
  oElemInfo : TApdElementInfo;
  oAttrInfo : TApdAttributeInfo;
begin
  wIdx := GetElementIndexOf(sElemName);
  if wIdx < 0 then begin
    SetElement(sElemName, CONTENT_UNDECLARED, '');
    wIdx := GetElementIndexOf(sElemName);
  end;

  oElemInfo := TApdElementInfo(FElementInfo.Objects[wIdx]);
  oAttrInfo := TApdAttributeInfo.Create;
  oAttrInfo.AttrType := wType;
  oAttrInfo.Value := sValue;
  oAttrInfo.ValueType := wValueType;
  oAttrInfo.Enum := sEnum;
  oElemInfo.SetAttribute(sName, oAttrInfo);
end;
{--------}
procedure TApdParser.SetElement(const sName         : DOMString;
                                     wType         : Integer;
                               const sContentModel : DOMString);
var
  oElem : TApdElementInfo;
  wIdx  : Integer;
begin
  wIdx := GetElementIndexOf(sName);
  if wIdx < 0 then begin
    oElem := TApdElementInfo.Create;
    FElementInfo.AddObject(sName, oElem);
  end else
    oElem := TApdElementInfo(FElementInfo.Objects[wIdx]);

  if wType <> CONTENT_UNDECLARED then
    oElem.ContentType := wType;

  if sContentModel <> '' then
    oElem.ContentModel := sContentModel;
end;
{--------}
procedure TApdParser.SetEntity(const sEntityName   : DOMString;
                                    wClass        : Integer;
                              const sPublicId,
                                    sSystemId,
                                    sValue,
                                    sNotationName : DOMString;
                                    aIsPE         : Boolean);
var
  wIdx    : Integer;
  oEntity : TApdEntityInfo;
begin
  wIdx := GetEntityIndexOf(sEntityName, aIsPE);
  if wIdx < 0 then begin
    oEntity := TApdEntityInfo.Create;
    oEntity.EntityClass := wClass;
    oEntity.PublicId := sPublicId;
    oEntity.SystemId := sSystemId;
    oEntity.Value := sValue;
    oEntity.NotationName := sNotationName;
    oEntity.IsParameterEntity := aIsPE;

    FEntityInfo.AddObject(sEntityName, oEntity);
  end;
end;
{--------}
procedure TApdParser.SetInternalEntity(const sName, sValue : DOMString;
                                            aIsPE         : Boolean);
begin
  SetEntity(sName, ENTITY_INTERNAL, '', '', sValue, '', aIsPE);
end;
{--------}
procedure TApdParser.SetNotation(const sNotationName,
                                      sPublicId,
                                      sSystemId     : DOMString);
var
  oNot : TApdNotationInfo;
  wIdx : Integer;
begin
  if not FNotationInfo.Find(sNotationName, wIdx) then begin
    oNot := TApdNotationInfo.Create;
    oNot.PublicId := sPublicId;
    oNot.SystemId := sSystemId;
    FNotationInfo.AddObject(sNotationName, oNot);
  end;
end;
{--------}
procedure TApdParser.SkipChar;
begin
  FFilter.SkipChar;
end;
{--------}
procedure TApdParser.SkipWhitespace(aNextDoc : Boolean);
begin
  while (not FFilter.Eof) and
        (IsWhitespace(ReadChar(False))) do
    SkipChar;
 if aNextDoc then begin
   IsEndDocument;
   while (not FFilter.Eof) and
         (IsWhitespace(ReadChar(False))) do
     SkipChar;
 end;
end;
{--------}
function TApdParser.TryRead(const S : array of Integer) : Boolean;
begin
  Result := False;
  if (not IsEndDocument) then begin
    Result := FFilter.TryRead(S);
    IsEndDocument;
  end;
end;
{--------}
procedure TApdParser.ValidateAttribute(const aValue    : DOMString;
                                            HasEntRef : Boolean);
begin

  if (not HasEntRef) then
    if (ApxPos('<', aValue) <> 0) then
      raise EAdParserError.CreateError(FFilter.Line,
                                       FFilter.LinePos,
                                       sInvAttrChar + '''<''')
    else if (ApxPos('&', aValue) <> 0) then
      raise EAdParserError.CreateError(FFilter.Line,
                                       FFilter.LinePos,
                                       sInvAttrChar + '''&''')
    else if (ApxPos('"', aValue) <> 0) then
      raise EAdParserError.CreateError(FFilter.Line,
                                       FFilter.LinePos,
                                       sInvAttrChar + '''"''');
end;
{--------}
procedure TApdParser.ValidateCData(const CDATA : DOMString);
begin
  if (ApxPos(']]>', CDATA) <> 0) then
    raise EAdParserError.CreateError(FFilter.Line,
                                     FFilter.LinePos,
                                     sInvalidCDataSection);
end;
{--------}
procedure TApdParser.ValidateElementName(const aName : DOMString);
begin
  if (aName = '') or
     (aName = ' ') then
    raise EAdParserError.CreateError(FFilter.Line,
                                     FFilter.LinePos,
                                     sInvalidElementName +
                                     QuotedStr(aName));
end;
{--------}
procedure TApdParser.ValidateEncName(const aValue : string);
var
  i : Integer;
  Good : Boolean;
begin
  { Production [81]}
  for i := 1 to Length(aValue) do begin
    Good := False;
    if ((aValue[i] >= 'A') and
        (aValue[i] <= 'z')) then
      Good := True
    else if i > 1 then
      if (aValue[i] >= '0') and
         (aValue[i] <= '9') then
        Good := True
      else if aValue[i] = '.' then
        Good := True
      else if aValue[i] = '_' then
        Good := True
      else if aValue[i] = '-' then
        Good := True
      else if aValue[i] = '=' then
        Good := True;
    if not Good then
      raise EAdParserError.CreateError(FFilter.Line,
                                       FFilter.LinePos,
                                       sInvEncName +
                                       QuotedStr(aValue));
  end;
end;
{--------}
procedure TApdParser.ValidateEntityValue(const aValue   : DOMString;
                                              aQuoteCh : DOMChar);
var
  TempChr : DOMChar;
  i       : Integer;
begin
  for i := 1 to Length(aValue) do begin
    TempChr := aValue[i];
    if (TempChr = '%') or
       (TempChr = '&') or
       (TempChr = aQuoteCh) then
      raise EAdParserError.CreateError(FFilter.Line,
                                       FFilter.LinePos,
                                       sInvEntityValue +
                                       QuotedStr(TempChr));
  end;
end;
{--------}
function TApdParser.ValidateNameChar(const First : Boolean;
                                    const Char  : DOMChar) : Boolean;
var
  BothUsed : Boolean;
  UCS4 : TApdUCS4Char;
begin
  { Naming rules -  from sect 2.3 of spec}
  { Names cannot be an empty string }
  { Names must begin with 1 letter or one of the following
    punctuation characters ['_',':']}
  { Names should not begin with 'XML' or any case derivitive}
  { Except for the first character, names can contain
    [letters, digits,'.', '-', '_', ':'}

  ApxUtf16ToUcs4(DOMChar(PByteArray(@Char)^[0]),
                DOMChar(PByteArray(@Char)^[1]),
                UCS4,
                BothUsed);
  if not First then
    Result := ApxIsNameChar(UCS4)
  else
    Result := ApxIsNameCharFirst(UCS4);
end;
{--------}
procedure TApdParser.ValidatePCData(const aString      : DOMString;
                                         aInEntityRef : Boolean);
begin
  if (not aInEntityRef) then
    if (ApxRPos('<', aString) <> 0) then
      raise EAdParserError.CreateError(FFilter.Line,
                                       FFilter.LinePos,
                                       sInvPCData + '''<''')
    else if (ApxRPos('&', aString) <> 0) and
            (ApxRPos(';', aString) = 0) then
      raise EAdParserError.CreateError(FFilter.Line,
                                       FFilter.LinePos,
                                       sInvPCData + '''&''')
    else if (ApxRPos(']]>', aString) <> 0) then
      raise EAdParserError.CreateError(FFilter.Line,
                                       FFilter.LinePos,
                                       sInvPCData + ''']]>''');
end;
{--------}
procedure TApdParser.ValidatePublicID(const aString : DOMString);
var
  Ucs4Char : TApdUcs4Char;
  i        : Integer;
begin
  for i := 1 to Length(aString) do begin
    ApxIso88591ToUcs4(AnsiChar(aString[i]), Ucs4Char);
    if (not ApxIsPubidChar(Ucs4Char)) then
      raise EAdParserError.CreateError(FFilter.Line,
                                       FFilter.LinePos,
                                       sInvPubIDChar +
                                       QuotedStr(aString[i]));
  end;
end;
{--------}
procedure TApdParser.ValidateVersNum(const aString : string);
var
  i       : Integer;
  TempChr : char;
  Good    : Boolean;
begin
  for i := 1 to Length(aString) do begin
    Good := False;
    TempChr := aString[i];
    if (TempChr >= 'A') and
       (TempChr <= 'z') then
      Good := True
    else if (TempChr >= '0') and
            (TempChr <= '9') then
      Good := True
    else if (TempChr = '.') then
      Good := True
    else if (TempChr = '_') then
      Good := True
    else if (TempChr = ':') then
      Good := True
    else if (TempChr = '-') then
      Good := True;
    if not Good then
      raise EAdParserError.CreateError(FFilter.Line,
                                       FFilter.LinePos,
                                       sInvVerNum +
                                       QuotedStr(aString));
  end;
end;

end.



