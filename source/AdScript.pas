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
{*                   ADSCRIPT.PAS 4.06                   *}
{*********************************************************}
{* TApdScript component                                  *}
{*********************************************************}

{Conditional defines that may affect this unit}
{$I AWDEFINE.INC}

{Required options}
{$G+,X+,F+,I+}
{$C MOVEABLE,DEMANDLOAD,DISCARDABLE}

{.$DEFINE DebugScript}
{!!.02} { Remode references to Win16 }
unit AdScript;
  {-Script processor for Async Professional }

interface

uses
  {-----RTL}
  SysUtils,
  Windows,
  Messages,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ShellAPI,
  {-----APD}
  OoMisc,
  AdExcept,
  AdPort,
  AdWnPort,
  AdTrmEmu,
  AdProtcl;

const

  { Various limits }
  MaxDataTriggers = 20;
  MaxCommandLength = 128;  { Maximum length of a script command }
  MaxCommands = 300;       { Maximum number of commands in a script file }
  DefRetryCnt = 3;         { Default retry count }
  MaxBufSize = 32767;      { Old value of MaxInt }

  { Defaults }
  DefDisplayToTerminal = True;

  { Other constants }
  CmdSepChar = '|';

  { Error codes }
  ecNotACommand      = 9901;  { First token is not a valid command }
  ecBadFormat1       = 9902;  { Bad format for 1st argument }
  ecBadFormat2       = 9903;  { Bad format for 2nd argument }
  ecInvalidLabel     = 9904;  { Referenced label doesn't exist }
  ecBadOption        = 9905;  { Bad option in SET command }
  ecTooManyStr       = 9906;  { Too many substrings in WaitMulti }
  ecNoScriptCommands = 9907;  { No script commands }
  ecCommandTooLong   = 9908;  { Length exceeds MaxCommandLength }
  ecNotWinsockPort   = 9909;  { Winsock used without a WinsockPort }

  { Condition codes }
  ccNone          = 0;     { Not assigned }
  ccSuccess       = 1;     { Last operation succeeded or first match }
  ccIndexFirst    = 1;     { First possible index }
                           { ...WAITMULTI matches }
  ccIndexLast     = 128;   { Last possible index }
  ccTimeout       = 1001;  { Last operation timed out }
  ccFail          = 1002;  { Last operation failed or too many timeouts }
  ccBadExitCode   = 1003;  { Tried to exit script with bad exit code }

type
  { Exceptions }
  EApdScriptError = class(EApdException)
    constructor Create(Code: Cardinal; BadLineNum: Cardinal);
  end;

  { Types of script commands }
  TApdScriptCommand = (
    scNoCommand,         { Not a command }
    scComment,           { Comment }
    scLabel,             { A label that can be jumped to }
    scInitPort,          { Open a TApdCustomComPort in serial mode }
    scInitWnPort,        { Open a TApdWinsockPort in Winsock mode }
    scDonePort,          { Close a TApdCustomComPort }
    scSend,              { Send text }
    scWait,              { Wait timeout seconds for text }
    scWaitMulti,         { Wait for multiple strings }
    scIf,                { Check single condition and jump }
    scDisplay,           { Display string }
    scGoto,              { Unconditional jump }
    scSendBreak,         { Send break of N milliseconds }
    scDelay,             { Delay for N milliseconds }
    scSetOption,         { Set an option }
    scUpload,            { Transmit a file }
    scDownload,          { Receive a file }
    scChDir,             { Change drive/directory }
    scDelete,            { Delete file mask }
    scRun,               { Execute a command or application }
    scUserFunction,      { Execute a user function (via event) }
    scExit);             { Exit script with return value }

  { SET options }
  TOption = (
    oNone,
    oBaud,               { Set comport's Baud }
    oDataBits,           { Set comport's DataBits }
    oFlow,               { Set comport's flow control }
    oParity,             { Set comport's Parity }
    oStopBits,           { Set comport's StopBits }
    oWsTelnet,           { Set Winsock port's WsTelnet }
    oSetRetry,           { Set retry count }
    oSetDirectory,       { Set directory for uploads/downloads }
    oSetFilemask,        { Set filemask for uploads }
    oSetFilename,        { Set filename for receives }
    oSetWriteFail,       { Set WriteFail for protocol receives }
    oSetWriteRename,     { Set WriteRename for protocol receives }
    oSetWriteAnyway,     { Set WriteAnyway for protocol receives }
    oSetZWriteClobber,   { Set WriteClobber option for zmodem receives }
    oSetZWriteProtect,   { Set WriteProtect option for zmodem receives }
    oSetZWriteNewer,     { Set WriteNewer option for zmodem receives }
    oSetZSkipNoFile);    { Set SkipNoFile option true/false for zmodem receives }

  { Script node }
  TApdScriptNode = class(TObject)
    Command   : TApdScriptCommand;  { Command type }
    Data      : Ansistring;             { Data associated with command }
    DataEx    : Ansistring;             { Additional data associated with command }
    Option    : TOption;            { Option for SET commands }
    Timeout   : Cardinal;           { Timeout associated with command }
    Condition : Cardinal;           { Condition match }

    { Create a new node }
    constructor Create(ACommand: TApdScriptCommand; AnOption: TOption;
      const AData, ADataEx: AnsiString; ATimeout: Cardinal; ACondition: Cardinal);
  end;

  { Script execution states }
  TScriptState = (ssNone, ssReady, ssWait, ssFinished);

  { Script event types }
  TScriptFinishEvent = procedure(CP: TObject; Condition: Integer) of object;
  TScriptCommandEvent = procedure(CP: TObject; Node: TApdScriptNode;
                                  Condition: Integer) of object;
  TScriptDisplayEvent = procedure(CP: TObject; const Msg: AnsiString) of object;
  TScriptUserFunctionEvent = procedure (      CP        : TObject;
                                        const Command   : AnsiString;
                                        const Parameter : AnsiString) of object;
  TScriptParseVariableEvent = procedure (      CP       : TObject;
                                         const Variable : AnsiString;
                                         var   NewValue : AnsiString) of object;
  TScriptExceptionEvent = procedure (Sender   : TObject;
                                     E        : Exception;
                                     Command  : TApdScriptNode;
                                     var Continue : Boolean) of object;

  { Script processing object }
  TApdCustomScript = class(TApdBaseComponent)
  protected
    { Owned APRO components }
    FComPort        : TApdCustomComPort;
    FProtocol       : TApdCustomProtocol;
    FTerminal       : TApdBaseWinControl;

    { Loading fields }
    FScriptFile     : string;
    FScriptCommands : TStrings;
    CurrentLine     : Cardinal;
    Modified        : Boolean;
    CommandNodes    : TList;

    { Processing fields }
    NodeIndex          : Integer;
    NextIndex          : Integer;
    TimerTrigger       : Cardinal;
    DataTrigger        : array[1..MaxDataTriggers] of Cardinal;
    TriggerCount       : Cardinal;
    SaveOnTrigger      : TTriggerEvent;
    ScriptState        : TScriptState;
    CreatedPort        : Boolean;
    SaveOpen           : Boolean;
    OpenedPort         : Boolean;
    CreatedProtocol    : Boolean;
    LastCondition      : Cardinal;
    SaveProtocolFinish : TProtocolFinishEvent;
    OldActive          : Boolean;
    Continuing         : Boolean;
    Closing            : Boolean;
    Retry              : Byte;
    Attempts           : Byte;
    FInProgress        : Boolean;
    FDisplayToTerminal : Boolean;

    { Events }
    FOnScriptFinish        : TScriptFinishEvent;
    FOnScriptCommandStart  : TScriptCommandEvent;
    FOnScriptCommandFinish : TScriptCommandEvent;
    FOnScriptDisplay       : TScriptDisplayEvent;
    FOnScriptUserFunction  : TScriptUserFunctionEvent;
    FOnScriptParseVariable : TScriptParseVariableEvent;
    FOnScriptException     : TScriptExceptionEvent;

    { Loading methods }
    procedure SetScriptFile(const NewFile: string);
    procedure SetScriptCommands(Values: TStrings);
    procedure ValidateLabels;
    procedure CreateCommand(CmdType: TApdScriptCommand;
      const Data1, Data2: AnsiString); virtual;
    procedure AddToScript(const S: AnsiString); virtual;

    { Validation methods }
    function CheckProtocol: Boolean;
    function CheckWinsockPort: Boolean;
    function ValidateBaud(const Baud: AnsiString): AnsiString;
    function ValidateDataBits(const DataBits: AnsiString): AnsiString;
    function ValidateFlow(const Flow: AnsiString): AnsiString;
    function ValidateParity(const Parity: AnsiString): AnsiString;
    function ValidateStopBits(const StopBits: AnsiString): AnsiString;

    { Processing methods }
    procedure AllTriggers(CP: TObject; Msg, TriggerHandle, Data: Word);
    procedure ExecuteExternal(const S: string; Wait: Boolean); virtual;
    procedure GoContinue;
    procedure ParseURL(const URL: string; var Addr, Port: string);
    procedure LogCommand (      Index   : Cardinal;
                                Command : TApdScriptCommand;
                          const Node    : TApdScriptNode);
    procedure ProcessNextCommand;
    procedure ProcessTillWait;
    procedure ScriptProtocolFinish(CP: TObject; ErrorCode: Integer);
    procedure SetFlow(const FlowOpt: string);
    procedure SetParity(const ParityOpt: string);

    { Event methods }
    procedure ScriptFinish(Condition: Integer); virtual;
    procedure ScriptCommandStart(Node: TApdScriptNode; Condition: Integer);
    procedure ScriptCommandFinish(Node: TApdScriptNode; Condition: Integer);
    procedure ScriptDisplay(const Msg: AnsiString);
    function GenerateScriptException (E       : Exception;
                                      Command : TApdScriptNode) : Boolean;

    { Misc methods }
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure Loaded; override;
    procedure AddDispatchLogEntry (const Msg: AnsiString);

  public
    { Constructors/destructors }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    { Load script file }
    procedure PrepareScript;

    { Process script file }
    procedure StartScript;
    procedure StopScript(Condition: Integer);
    procedure CancelScript;

    { Processing }
    property InProgress: Boolean
      read FInProgress;

    property ComPort: TApdCustomComPort
      read FComPort write FComPort;
    property Protocol: TApdCustomProtocol
      read FProtocol write FProtocol;
    property Terminal: TApdBaseWinControl
      read FTerminal write FTerminal;
    property DisplayToTerminal: Boolean
      read FDisplayToTerminal write FDisplayToTerminal
      default DefDisplayToTerminal;
    property ScriptFile: string
      read FScriptFile write SetScriptFile;
    property ScriptCommands: TStrings
      read FScriptCommands write SetScriptCommands stored True;
    property OnScriptFinish: TScriptFinishEvent
      read FOnScriptFinish write FOnScriptFinish;
    property OnScriptCommandStart: TScriptCommandEvent
      read FOnScriptCommandStart write FOnScriptCommandStart;
    property OnScriptCommandFinish: TScriptCommandEvent
      read FOnScriptCommandFinish write FOnScriptCommandFinish;
    property OnScriptDisplay: TScriptDisplayEvent
      read FOnScriptDisplay write FOnScriptDisplay;
    property OnScriptParseVariable : TScriptParseVariableEvent
             read FOnScriptParseVariable write FOnScriptParseVariable;
    property OnScriptUserFunction : TScriptUserFunctionEvent
             read FOnScriptUserFunction write FOnScriptUserFunction;
    property OnScriptException : TScriptExceptionEvent
             read FOnScriptException write FOnScriptException;
  end;

  TApdScript = class(TApdCustomScript)
  published
    property ComPort;
    property Protocol;
    property Terminal;
    property DisplayToTerminal;
    property ScriptFile;
    property ScriptCommands;
    property OnScriptFinish;
    property OnScriptCommandStart;
    property OnScriptCommandFinish;
    property OnScriptDisplay;
    property OnScriptParseVariable;
    property OnScriptUserFunction;
  end;

{.$IFDEF DebugScript}
const
  { Types of script commands }
  ScriptStr: array[TApdScriptCommand] of string = (
    'scNoCommand',
    'scComment',
    'scLabel',
    'scInitPort',
    'scInitWnPort',
    'scDonePort',
    'scSend',
    'scWait',
    'scWaitMulti',
    'scIf',
    'scDisplay',
    'scGoto',
    'scSendBreak',
    'scDelay',
    'scSetOption',
    'scUpload',
    'scDownload',
    'scChDir',
    'scDelete',
    'scRun',
    'scUserFunction',
    'scExit');
{.$ENDIF}

{==========================================================================}

implementation

uses
  AnsiStrings;

type
  StringBuffer = array[0..MaxCommandLength - 1] of AnsiChar;

{$IFDEF DebugScript}
var
  Dbg: Text;
{$ENDIF}

{ General purpose routines }

{ Return protocol type based on S }
function ValidateProtocol(const S: string): TProtocolType;
var
  TempStr: string;
begin
  TempStr := UpperCase(S);
  if TempStr = 'XMODEM' then
    ValidateProtocol := ptXmodem
  else if TempStr = 'XMODEMCRC' then
    ValidateProtocol := ptXmodemCRC
  else if TempStr = 'XMODEM1K' then
    ValidateProtocol := ptXmodem1K
  else if TempStr = 'XMODEM1KG' then
    ValidateProtocol := ptXmodem1KG
  else if TempStr = 'YMODEM' then
    ValidateProtocol := ptYmodem
  else if TempStr = 'YMODEMG' then
    ValidateProtocol := ptYmodemG
  else if TempStr = 'ZMODEM' then
    ValidateProtocol := ptZmodem
  else if TempStr = 'KERMIT' then
    ValidateProtocol := ptKermit
  else if TempStr = 'ASCII' then
    ValidateProtocol := ptAscii
  else
    ValidateProtocol := ptNoProtocol;
end;

{ Return a comport number from S }
function CheckComport(const S: string): Byte;
var
  Code: Integer;
  ComPort: Byte;
  TempStr: string;
begin
  TempStr := UpperCase(S);
  CheckComPort := 0;
  if Copy(TempStr, 1, 3) = 'COM' then begin
    TempStr := Copy(TempStr, 4, 255);
    Val(TempStr, ComPort, Code);
    if Code = 0 then
      CheckComPort := ComPort;
  end;
end;

{ Convert a string to a cardinal }
function Str2Card(const S: string; var C: Cardinal): Boolean;
var
  Code: Integer;
begin
  Val(S, C, Code);
  Result := (Code = 0);
end;

{ Delete all files matching Mask }
procedure DeleteFiles(const Mask: string);
var
  SRec: TSearchRec;
begin
  if FindFirst(Mask, faAnyFile, SRec) = 0 then
    repeat
      SysUtils.DeleteFile(SRec.Name);
    until FindNext(SRec) <> 0;
  SysUtils.FindClose(SRec);
end;

{ Search for a terminal in the same form as TComponent }
function SearchTerminal(const C: TComponent): TApdBaseWinControl;

  function FindTerminal(const C: TComponent): TApdBaseWinControl;
  var
    I: Integer;
  begin
    Result := nil;
    if not Assigned(C) then
      Exit;

    { Look through all of the owned components }
    for I := 0 to C.ComponentCount-1 do begin
      if C.Components[I] is TApdBaseWinControl then begin

        { Look for new terminal }
        if C.Components[I] is TAdCustomTerminal then begin
          Result := TApdBaseWinControl(C.Components[I]);
          Exit;
        end;
      end;

      { If this isn't one, see if it owns other components }
      Result := FindTerminal(C.Components[I]);
    end;
  end;

begin
  { Search the entire form }
  Result := FindTerminal(C);
end;

{ Search for a protocol in the same form as TComponent }
function SearchProtocol(const C: TComponent): TApdCustomProtocol;

  function FindProtocol(const C: TComponent): TApdCustomProtocol;
  var
    I: Integer;
  begin
    Result := nil;
    if not Assigned(C) then
      Exit;

    { Look through all of the owned components }
    for I := 0 to C.ComponentCount-1 do begin
      if C.Components[I] is TApdCustomProtocol then begin
        Result := TApdCustomProtocol(C.Components[I]);
        Exit;
      end;

      { If this isn't one, see if it owns other components }
      Result := FindProtocol(C.Components[I]);
    end;
  end;

begin
  { Search the entire form }
  Result := FindProtocol(C);
end;

{ EApdScriptError }

constructor EApdScriptError.Create(Code: Cardinal; BadLineNum: Cardinal);
var
  Msg: string;
begin
  case Code of
    ecNotACommand:
      Msg := 'Not a valid script command';
    ecBadFormat1:
      Msg := 'Bad format for first parameter' + #13 + 'or first parameter missing';
    ecBadFormat2:
      Msg := 'Bad format for second parameter' + #13 + 'or second parameter missing';
    ecInvalidLabel:
      Msg := 'Label is referenced but never defined';
    ecBadOption:
      Msg := 'Bad option in SET command';
    ecTooManyStr:
      Msg := 'Too many strings in WaitMulti command';
    ecCommandTooLong:
      Msg := 'Command string too long';
    ecNotWinsockPort:
      Msg := 'ComPort must be a TApdWinsockPort';
    else
      Msg := 'DOS error ' + IntToStr(Code) + ' while processing script';
  end;
  CreateUnknown('Script Error : ' + Msg + '. Line : ' + IntToStr(BadLineNum), 0);
end;

{ TApdScriptNode }

{ Create a script node }
constructor TApdScriptNode.Create(ACommand: TApdScriptCommand; AnOption: TOption;
  const AData, ADataEx: AnsiString; ATimeout: Cardinal; ACondition: Cardinal);
begin
  inherited Create;
  Command := ACommand;
  Option := AnOption;
  Data := AData;
  DataEx := ADataEx;
  Timeout := ATimeout;
  Condition := ACondition;
end;

{ TApdScript }

{ Event handler method for OnScriptFinished }
procedure TApdCustomScript.ScriptFinish(Condition: Integer);
begin
  if Assigned(FOnScriptFinish) then
    FOnScriptFinish(Self, Condition);
end;

{ Event handler method for OnScriptPreStep }
procedure TApdCustomScript.ScriptCommandStart(Node: TApdScriptNode;
                                              Condition: Integer);
begin
  if Assigned(FOnScriptCommandStart) then
    FOnScriptCommandStart(Self, Node, Condition);
end;

{ Event handler method for OnScriptPostStep }
procedure TApdCustomScript.ScriptCommandFinish(Node: TApdScriptNode;
                                               Condition: Integer);
begin
  if Assigned(FOnScriptCommandFinish) then
    FOnScriptCommandFinish(Self, Node, Condition);
end;

{ Event handler method for OnScriptFinished }
procedure TApdCustomScript.ScriptDisplay(const Msg: AnsiString);
begin
  if DisplayToTerminal and Assigned(FTerminal) then begin

    { Handle new terminal }
    if FTerminal is TAdCustomTerminal then begin
      TAdCustomTerminal(Terminal).WriteString(Msg);
    end;

  end;

  if Assigned(FOnScriptDisplay) then
    FOnScriptDisplay(Self, Msg);
end;

{ Init Script object }
constructor TApdCustomScript.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  { Create command nodes }
  CommandNodes := TList.Create;
  CommandNodes.Capacity := MaxCommands;

  { Create string list }
  FScriptCommands := TStringList.Create;
  Modified := False;

  { Other inits }
  FInProgress := False;
  FDisplayToTerminal := DefDisplayToTerminal;
  Retry := DefRetryCnt;
  SaveOnTrigger := nil;
  SaveProtocolFinish := nil;
  CreatedPort := False;
  OpenedPort := False;
  CreatedProtocol := False;
  Continuing := False;
  Closing := False;

  { Search for components }
  FComPort := SearchComPort(Owner);
  FTerminal := SearchTerminal(Owner);
  FProtocol := SearchProtocol(Owner);
end;

{ Dispose of script object and associated data }
destructor TApdCustomScript.Destroy;
var
  I: Integer;
begin
  { Get rid of command nodes }
  if CommandNodes.Count > 0 then begin
    for I := 0 to CommandNodes.Count-1 do
      TApdScriptNode(CommandNodes[I]).Free;
  end;
  CommandNodes.Free;

  { Save script file if it changed }
  if Modified and (FScriptFile <> '') then
    FScriptCommands.SaveToFile(FScriptFile);

  { Get rid of script string list }
  FScriptCommands.Free;

  { Get rid of port if we created it }
  if CreatedPort then
    ComPort.Free;

  inherited Destroy;
end;

procedure TApdCustomScript.AddDispatchLogEntry (const Msg: AnsiString);
begin
  if not Assigned (FComPort) then
    exit;
  if not Assigned (FComPort.Dispatcher) then
    exit;
  FComPort.Dispatcher.AddDispatchEntry(dtScript,
                                       dstStatus, 0,
                                       @Msg[1],
                                       Length(Msg));
end;

procedure TApdCustomScript.SetScriptFile(const NewFile: string);
begin
  if CompareText(NewFile, FScriptFile) <> 0 then begin

    { Save current commands if they were modified and we have a filename }
    if Modified and
       (FScriptFile <> '') and
       (FScriptCommands.Count <> 0) then
      FScriptCommands.SaveToFile(FScriptFile);

    { Set new file name, load new commands if file exists }
    FScriptFile := NewFile;
    if FileExists(FScriptFile) then begin
      FScriptCommands.Clear;
      FScriptCommands.LoadFromFile(FScriptFile);
    end;
    Modified := False;
  end;
end;

procedure TApdCustomScript.SetScriptCommands(Values: TStrings);
begin
  FScriptCommands.Assign(Values);
  Modified := True;
end;

procedure TApdCustomScript.Notification(AComponent: TComponent;
                                        Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if Operation = opRemove then begin
    { Owned components going away }
    if AComponent = FComPort then
      FComPort := nil;
    if AComponent = FTerminal then

      FTerminal := nil;
    if AComponent = FProtocol then
      FProtocol := nil;
  end else if Operation = opInsert then begin
    { Check for new comport }
    if AComponent is TApdCustomComPort then
      if not Assigned(FComPort) then
        ComPort := TApdCustomComPort(AComponent);

    { Check for new terminal component }
    if AComponent is TAdCustomTerminal then begin
      if not Assigned(FTerminal) then
        FTerminal := TApdBaseWinControl(AComponent);
    end;

    { Check for new protocol component }
    if AComponent is TApdCustomProtocol then begin
      if not Assigned(FProtocol) then
        FProtocol := TApdCustomProtocol(AComponent);
    end;
  end;
end;

{ Load script file if ScriptCommands empty but ScriptFile not }
procedure TApdCustomScript.Loaded;
begin
  inherited Loaded;

  if ScriptCommands.Count = 0 then begin
    try
      PrepareScript;
    except
    end;
  end;
end;

{ Assure all referenced labels exist }
procedure TApdCustomScript.ValidateLabels;
var
  I: Integer;

  { Return true if a label named Name exists }
  function FoundLabel(const Name: string): Boolean;
  var
    I: Integer;
  begin
    Result := True;
    for I := 0 to CommandNodes.Count-1 do
      with TApdScriptNode(CommandNodes[I]) do
        if (Command = scLabel) and (string(Data) = Name) then
          Exit;
    Result := False;
  end;

begin
  if CommandNodes.Count > 0 then
    for I := 0 to CommandNodes.Count-1 do
      with TApdScriptNode(CommandNodes[I]) do
        case Command of
          scIf,
          scGoto:
            if not FoundLabel(string(Data)) then begin
              raise EApdScriptError.Create(ecInvalidLabel, 0);
            end;
        end;
end;

{ Load/error check script }
procedure TApdCustomScript.PrepareScript;
var
  I: Integer;
begin
  { If script file name is not empty, then load into ScriptCommands }
  if FScriptFile <> '' then begin
    FScriptCommands.Clear;
    FScriptCommands.LoadFromFile(FScriptFile);
  end;

  { Clear existing command nodes }
  if CommandNodes.Count > 0 then begin
    for I := 0 to CommandNodes.Count-1 do
      TApdScriptNode(CommandNodes[I]).Free;
    CommandNodes.Clear;
  end;

  { Convert script commands into nodes }
  CurrentLine := 0;
  for I := 0 to ScriptCommands.Count-1 do begin
    Inc(CurrentLine);
    AddToScript(AnsiString(FScriptCommands[I]));
  end;

  { Make sure all referenced labels really exist }
  ValidateLabels;

  {$IFDEF DebugScript}
  WriteLn(Dbg,'script file ', FScriptFile, ' loaded');
  {$ENDIF}
  AddDispatchLogEntry (AnsiString('Script file ' + FScriptFile + 'loaded '));
end;

{ Create command node }
procedure TApdCustomScript.CreateCommand(CmdType: TApdScriptCommand;
                                         const Data1, Data2: AnsiString);
var
  Node      : TApdScriptNode;
  Data      : AnsiString;
  DataEx    : AnsiString;
  Option    : TOption;
  Timeout   : Cardinal;
  Condition : Cardinal;
  StrBuffer : StringBuffer;

  { Return condition class }
  function ClassifyCondition(const S: string): Cardinal;
  var
    TempStr: string;
  begin
    TempStr := UpperCase(S);
    if TempStr = 'SUCCESS' then
      Result := ccSuccess
    else if TempStr = 'TIMEOUT' then
      Result := ccTimeout
    else if TempStr = 'FAIL' then
      Result := ccFail
    else if not Str2Card(S, Result) then
      Result := ccNone;
  end;

  procedure ConvertCtlChars(const S: AnsiString);
  var
    I, J: Integer;
  begin
    J := 0;
    I := 1;
    while (I <= Length(S)) do begin
      if S[I] <> '^' then
        StrBuffer[J] := S[I]
      else begin
        if S[I+1] = '^' then
          StrBuffer[J] := '^'
        else
          StrBuffer[J] := AnsiChar(Byte(Upcase(S[I+1]))-Ord('@'));
        Inc(I);
      end;
      Inc(J);
      Inc(I);
      if (J > MaxCommandLength) then
        raise EApdScriptError.Create(ecCommandTooLong, CurrentLine);
    end;
    {$IFOPT H+}
    SetLength(Data, J);
    {$ELSE}
    Data[0] := Char(J);
    {$ENDIF}
    Move (StrBuffer, Data[1], J);
  end;

  { Typecast timeout to boolean }
  procedure SetTrueFalse;
  var
    TempStr: string;
  begin
    TempStr := UpperCase(string(Data2));
    if (TempStr = 'TRUE') or (TempStr = 'ON') then
      Timeout := Cardinal(True)
    else if (TempStr = 'FALSE') or (TempStr = 'OFF') then
      Timeout := Cardinal(False)
    else
       raise EApdScriptError.Create(ecBadFormat2, CurrentLine);
  end;

  { Verify Data1 is a valid option and save data }
  procedure SetOption;
  var
    TempStr: string;
  begin
    TempStr := UpperCase(string(Data1));
    if TempStr = 'BAUD' then begin
      Option := oBaud;
      Data := ValidateBaud(Data2);
    end else if TempStr = 'DATABITS' then begin
      Option := oDataBits;
      Data := ValidateDataBits(Data2);
    end else if TempStr = 'FLOW' then begin
      Option := oFlow;
      Data := ValidateFlow(Data2);
    end else if TempStr = 'PARITY' then begin
      Option := oParity;
      Data := ValidateParity(Data2);
    end else if TempStr = 'STOPBITS' then begin
      Option := oStopBits;
      Data := ValidateStopBits(Data2);
    end else if TempStr = 'WSTELNET' then begin
      Option := oWsTelnet;
      SetTrueFalse;
    end else if TempStr = 'RETRY' then begin
      Option := oSetRetry;
      if not Str2Card(string(Data2), Timeout) then
        raise EApdScriptError.Create(ecBadFormat2, CurrentLine);
    end else if TempStr = 'DIRECTORY' then begin
      Option := oSetDirectory;
      Data := UpperCase(Data2);
    end else if TempStr = 'FILEMASK' then begin
      Option := oSetFilemask;
      Data := UpperCase(Data2);
    end else if TempStr = 'FILENAME' then begin
      Option := oSetFilename;
      Data := UpperCase(Data2);
    end else if TempStr = 'WRITEFAIL' then
      Option := oSetWriteFail
    else if TempStr = 'WRITERENAME' then
      Option := oSetWriteRename
    else if TempStr = 'WRITEANYWAY' then
      Option := oSetWriteAnyway
    else if TempStr = 'ZWRITECLOBBER' then
      Option := oSetZWriteClobber
    else if TempStr = 'ZWRITEPROTECT' then
      Option := oSetZWriteProtect
    else if TempStr = 'ZWRITENEWER' then
      Option := oSetZWriteNewer
    else if TempStr = 'ZSKIPNOFILE' then begin
      Option := oSetZSkipNoFile;
      SetTrueFalse;
    end else begin
      raise EApdScriptError.Create(ecBadOption, CurrentLine);
      Exit;
    end;
  end;

  { Count the number of separator chars }
  function ValidateWaitMulti(const S: string): Boolean;
  var
    I: Integer;
    Count: Cardinal;
  begin
    Count := 0;
    for I := 1 to Length(S) do
      if S[I] = CmdSepChar then
        Inc(Count);
    ValidateWaitMulti := Count <= MaxDataTriggers;
  end;

begin
  { Convert data accordingly }
  Data := '';
  Condition := ccNone;
  Timeout := 0;
  Option := oNone;

  case CmdType of
    scLabel:
      begin
        {$IFOPT H+}
        SetLength(Data, Length(Data1));
        {$ELSE}
        Data[0] := Data1[0];
        {$ENDIF}
        Data := Copy(Data1, 2, 255);
      end;

    scSend:
      ConvertCtlChars(Data1);

    scInitPort:
      begin
        Data := Data1;
        if CheckComPort(string(Data1)) = 0 then
          raise EApdScriptError.Create(ecBadFormat1, CurrentLine);
      end;

    scInitWnPort:
      begin
        Data := Data1;
        DataEx := Data2;
        CheckWinsockPort;
      end;

    scDonePort:
      ;

    scWait:
      begin
        ConvertCtlChars(Data1);
        if not Str2Card(string(Data2), Timeout) then
          raise EApdScriptError.Create(ecBadFormat2, CurrentLine);
      end;

    scIf:
      begin
        Condition := ClassifyCondition(string(Data1));
        if Condition = ccNone then
          raise EApdScriptError.Create(ecBadFormat1, CurrentLine);
        Data := UpperCase(Data2);
      end;

    scDisplay:
      ConvertCtlChars(Data1);

    scGoto:
      Data := UpperCase(Data1);

    scSendBreak:
      if not Str2Card(string(Data1), Timeout) then
        raise EApdScriptError.Create(ecBadFormat2, CurrentLine);

    scDelay:
      if not Str2Card(string(Data1), Timeout) then
        raise EApdScriptError.Create(ecBadFormat2, CurrentLine);

    scSetOption:
      SetOption;

    scUpload,
    scDownload:
      if ValidateProtocol(string(Data1)) = ptNoProtocol then
        raise EApdScriptError.Create(ecBadFormat2, CurrentLine)
      else
        Data := UpperCase(Data1);
    scChDir:
      Data := UpperCase(Data1);

    scDelete:
      Data := UpperCase(Data1);

    scWaitMulti:
      begin
        Data := UpperCase(Data1);
        if not Str2Card(string(Data2), TimeOut) then
          raise EApdScriptError.Create(ecBadFormat2, CurrentLine);
        if not ValidateWaitMulti(string(Data1)) then
          raise EApdScriptError.Create(ecTooManyStr, CurrentLine);
      end;

    scRun:
      begin
        Data := Data1;
        SetTrueFalse;
      end;

    scUserFunction:
      begin
        Data := Data1;
        DataEx := Data2;
      end;

    scExit:
      begin
        Data := UpperCase(Data1);
      end;

  end;

  { Add it... }
  Node := TApdScriptNode.Create(CmdType, Option, Data, DataEx, Timeout, Condition);
  CommandNodes.Add(Node);
end;

{ Parse command, add to list, return False if error }
procedure TApdCustomScript.AddToScript(const S: AnsiString);
var
  CmdType: TApdScriptCommand;
  Index  : Byte;
  Cmd    : AnsiString;
  Data1  : AnsiString;
  Data2  : AnsiString;

  { Skip data until non-white }
  procedure SkipWhite;
  begin
    if (Index < Length(S)) then
      while ((S[Index] <= ' ') or (S[Index] > #127) or (S[Index] = ',')) and
            (Index < Length(S)) do
        Inc(Index);
  end;

  { Return the next token }
  function GetToken(IsCmd: Boolean): AnsiString;
  var
    I     : Byte;
    Delim1: AnsiChar;
    Delim2: AnsiChar;
    Token : AnsiString;
    StrBuffer: StringBuffer;

  begin
    I := 0;

    { if comment, get out quickly }
    if (S[Index] = ';') and IsCmd then begin
      CmdType := scComment;
      Exit;
    end;

    { Handle quotes if present }
    if S[Index] = '''' then begin
      Inc(Index);
      Delim1 := '''';
      Delim2 := '''';
    end else begin
      Delim1 := ' ';
      Delim2 := ',';
    end;

    { Search for ending quote or blank }
    while (S[Index] <> Delim1) and
          (S[Index] <> Delim2) and
          (Index <= Length(S)) do begin
      StrBuffer[I] := S[Index];
      Inc(I);
      Inc(Index);
      if (I > MaxCommandLength) then
        raise EApdScriptError.Create(ecCommandTooLong, CurrentLine);
    end;

    { Skip past ending quote if necessary }
    if Delim1 = '''' then
      Inc(Index);

    {$IFOPT H+}
    SetLength(Token, I);
    {$ELSE}
    Token[0] := Char(I);
    {$ENDIF}

    Move(StrBuffer, Token[1], I);
    GetToken := Token;
  end;

  { Return command class }
  function ClassifyToken(S: string): TApdScriptCommand;
  begin
    if Length(S) = 0 then
      ClassifyToken := scComment
    else if S[1] = ':' then
      ClassifyToken := scLabel
    else if S = 'INITPORT' then
      ClassifyToken := scInitPort
    else if S = 'INITWNPORT' then
      ClassifyToken := scInitWnPort
    else if S = 'DONEPORT' then
      ClassifyToken := scDonePort
    else if S = 'SEND' then
      ClassifyToken := scSend
    else if S = 'WAIT' then
      ClassifyToken := scWait
    else if S = 'IF' then
      ClassifyToken := scIf
    else if S = 'DISPLAY' then
      ClassifyToken := scDisplay
    else if S = 'GOTO' then
      ClassifyToken := scGoto
    else if S = 'SENDBREAK' then
      ClassifyToken := scSendBreak
    else if S = 'DELAY' then
      ClassifyToken := scDelay
    else if S = 'SET' then
      ClassifyToken := scSetOption
    else if S = 'UPLOAD' then
      ClassifyToken := scUpload
    else if S = 'DOWNLOAD' then
      ClassifyToken := scDownload
    else if S = 'CHDIR' then
      ClassifyToken := scChDir
    else if S = 'DELETE' then
      ClassifyToken := scDelete
    else if S = 'WAITMULTI' then
      ClassifyToken := scWaitMulti
    else if S = 'RUN' then
      ClassifyToken := scRun
    else if S[1] = '&' then
      ClassifyToken := scUserFunction
    else if S = 'EXIT' then
      ClassifyToken := scExit
    else
      ClassifyToken := scNoCommand;
  end;

begin
  { Get up to three tokens }
  if (S = '') then
    CmdType := scComment
  else begin
    CmdType := scNoCommand;
    Index := 1;
    SkipWhite;
    Cmd := UpperCase(GetToken(True));
    if (CmdType <> scComment) then begin
      SkipWhite;
      Data1 := GetToken(False);
      SkipWhite;
      Data2 := GetToken(False);
    end;
  end;

  { Process tokens }
  if CmdType <> scComment then
    CmdType := ClassifyToken(string(Cmd));
  case CmdType of
    scComment: { Comment, ignore line }
      ;
    scNoCommand   : { Error, bad command }
      raise EApdScriptError.Create(ecNotACommand, CurrentLine);
    scUserFunction:
      CreateCommand(CmdType, Cmd, Data1);
    scLabel  : { Label, create node }
      CreateCommand(CmdType, Cmd, '');
    else        { Command, create node }
      CreateCommand(CmdType, Data1, Data2);
  end;
end;

{ Assure protocol exists, create if not, return True if okay }
function TApdCustomScript.CheckProtocol: Boolean;
begin
  if not Assigned(FProtocol) then begin
    FProtocol := TApdProtocol.Create(Self);
    CreatedProtocol := True;
  end;
  Result := Assigned(FProtocol);
end;

{ Assure WinsockPort exists, create or raise exception if not }
function TApdCustomScript.CheckWinsockPort: Boolean;
begin
  if Assigned(FComport) then begin
    if not (FComport is TApdWinsockPort) then
      raise EApdScriptError.Create(ecNotWinsockPort, CurrentLine);
  end else begin
    FComport := TApdWinsockPort.Create(Self);
    CreatedPort := True;
  end;
  Result := Assigned(FComport);
end;

{ Validate and format baud }
function TApdCustomScript.ValidateBaud(const Baud: AnsiString): AnsiString;
var
  I: Integer;
begin
  Result := UpperCase(Baud);
  for I := 1 to Length(Result) do begin
    if Pos(Result[I], AnsiString('1234567890')) <> 0 then Continue;
    raise EApdScriptError.Create(ecBadOption, CurrentLine);
  end;
end;

{ Validate and format databits }
function TApdCustomScript.ValidateDataBits(const DataBits: AnsiString): AnsiString;
begin
  Result := UpperCase(DataBits);
  if Result = '5' then Exit;
  if Result = '6' then Exit;
  if Result = '7' then Exit;
  if Result = '8' then Exit;
  raise EApdScriptError.Create(ecBadOption, CurrentLine);
end;

{ Validate and format flow }
function TApdCustomScript.ValidateFlow(const Flow: AnsiString): AnsiString;
begin
  Result := UpperCase(Flow);
  if Result = 'RTS/CTS' then Exit;
  if Result = 'XON/XOFF' then Exit;
  if Result = 'NONE' then Exit;
  raise EApdScriptError.Create(ecBadOption, CurrentLine);
end;

{ Validate and format parity }
function TApdCustomScript.ValidateParity(const Parity: AnsiString): AnsiString;
begin
  Result := UpperCase(Parity);
  if Result = 'NONE' then Exit;
  if Result = 'ODD' then Exit;
  if Result = 'EVEN' then Exit;
  if Result = 'MARK' then Exit;
  if Result = 'SPACE' then Exit;
  raise EApdScriptError.Create(ecBadOption, CurrentLine);
end;

{ Validate and format stopbits }
function TApdCustomScript.ValidateStopBits(const StopBits: AnsiString): AnsiString;
begin
  Result := UpperCase(StopBits);
  if Result = '1' then Exit;
  if Result = '2' then Exit;
  raise EApdScriptError.Create(ecBadOption, CurrentLine);
end;


{ Process all script triggers }
procedure TApdCustomScript.AllTriggers(CP: TObject; Msg, TriggerHandle, Data: Word);
var
  I: Integer;
  {.$IFDEF DebugScript}
  S: AnsiString;
  {.$ENDIF}

  { Remove data and timer triggers }
  procedure RemoveTriggers;
  var
    I: Integer;
  begin
    for I := 1 to MaxDataTriggers do
      if DataTrigger[I] <> 0 then
        ComPort.RemoveTrigger(DataTrigger[I]);
    TriggerCount := 0;
    if TimerTrigger <> 0 then
      ComPort.RemoveTrigger(TimerTrigger);
    FillChar(DataTrigger, SizeOf(DataTrigger), 0);
    TimerTrigger := 0;
  end;

begin

  {.$IFDEF DebugScript}
  case Msg of
    APW_TRIGGERAVAIL : S := 'APW_TRIGGERAVAIL';
    APW_TRIGGERDATA  : S := 'APW_TRIGGERDATA';
    APW_TRIGGERTIMER : S := 'APW_TRIGGERTIMER';
    APW_TRIGGERSTATUS: S := 'APW_TRIGGERSTATUS';
    else                S := AnsiString(IntToStr(Msg));
  end;

  AddDispatchLogEntry (AnsiString('Entering AllTrigers' + string(S) + ' ' +
                       IntToStr (TriggerHandle) + ' ' +
                       IntToStr (Data)));

  {$IFDEF DebugScript}
  WriteLn(Dbg,'entering AllTriggers: ', S, ' ',
           TriggerHandle, ' ', Data);
  {$ENDIF}

  { Call the old OnTrigger }
  if Assigned(SaveOnTrigger) then
    SaveOnTrigger(CP, Msg, TriggerHandle, Data);

  { Check for timeouts }
  if (Msg = APW_TRIGGERTIMER) and (TriggerHandle = TimerTrigger) then begin
    {$IFDEF DebugScript}
    WriteLn(Dbg,'got timeout trigger');
    {$ENDIF}
    AddDispatchLogEntry ('Got timeout trigger');


    { Got a timeout, remove triggers and continue processing script }
    RemoveTriggers;
    if not Continuing then begin
      { A real timeout, check for retries }
      Inc(Attempts);
      if Attempts >= Retry then
        LastCondition := ccFail
      else
        LastCondition := ccTimeout;
    end else
      { Just using a timer to regain control, don't change condition }
      Continuing := False;

    { Continue processing }
    ScriptState := ssReady;
    ProcessTillWait;
  end else if (Msg = APW_TRIGGERDATA) then begin
    for I := 1 to TriggerCount do begin
      if TriggerHandle = DataTrigger[I] then begin
        {$IFDEF DebugScript}
        WriteLn(Dbg,'got data trigger');
        {$ENDIF}

        AddDispatchLogEntry ('Got data trigger');

        { Got a data trigger match, remove triggers and go process }
        RemoveTriggers;
        LastCondition := I;
        ScriptState := ssReady;
        ProcessTillWait;

        { Reset attempt count for next go'round }
        Attempts := 0;
      end;
    end;
  end;

  {$IFDEF DebugScript}
  WriteLn(Dbg,'leaving AllTriggers');
  {$ENDIF}
  AddDispatchLogEntry ('Leaving AllTriggers');
end;

{ Execute command }
procedure TApdCustomScript.ExecuteExternal(const S: string; Wait: Boolean);
var
  Str : PChar;
begin
  Str := StrAlloc(Length(S)+1);
  StrPCopy(Str, S);
  try
    if Wait then
      ApWinExecAndWait32(Str, nil, SW_SHOWNORMAL)
    else
      ShellExecute(0, nil, Str, nil, nil, SW_SHOWNORMAL);
  finally
    StrDispose(Str);
  end;
end;

{ Separate URL into address and port elements }
procedure TApdCustomScript.ParseURL(const URL: string; var Addr, Port: string);
var
  TempStr: string;
  Psn: Integer;
begin
  if URL = '' then Exit;

  { Strip protocol if it exists }
  Psn := Pos('//', URL);
  if Psn = 0 then begin
    TempStr := URL;
  end else begin
    TempStr := Copy(URL, Psn+2, (Length(URL) - Psn+2));
  end;

  { Separate Address and Port }
  Psn := Pos(':', TempStr);
  if Psn = 0 then begin
    Addr := TempStr;
    Port := 'telnet';
  end else begin
    Addr := Copy(TempStr, 1, Psn-1);
    Port := Copy(TempStr, Psn+1, (Length(TempStr) - Psn+1));
  end;
end;

{$IFDEF DebugScript}

{ Write the current command to debug }
procedure WriteCommand(Index: Cardinal; const Node: TApdScriptNode);
begin
  with Node do
    WriteLn(Dbg,'index: ', Index, '  command: ',
          ScriptStr[Command], ' ',
          Data, ' ',
          Timeout, ' ',
          Condition);
end;
{$ENDIF}

procedure TApdCustomScript.LogCommand (      Index   : Cardinal;
                                             Command : TApdScriptCommand;
                                       const Node    : TApdScriptNode);
begin
  AddDispatchLogEntry (AnsiString('Index: ' + IntToStr(Index) +
      '  Command: ' +
      ScriptStr[TApdScriptNode(CommandNodes[Index]).Command] +
      ' ' + string(TApdScriptNode(CommandNodes[Index]).Data) +
      ' ' + IntToStr(TApdScriptNode(CommandNodes[Index]).TimeOut) +
      ' ' + IntToStr(TApdScriptNode(CommandNodes[Index]).Condition)));
end;

{ Process a script command }
procedure TApdCustomScript.ProcessNextCommand;
var
  I: Integer;
  Addr, Port: string;
  tData, tDataEx: AnsiString;


  { Return the index of the label named Name }
  function FindLabel(const Name: string): Integer;
  var
    I: Integer;
  begin
    for I := 0 to CommandNodes.Count-1 do
      with TApdScriptNode(CommandNodes[I]) do begin
        if (Command = scLabel) and (string(Data) = Name) then begin
          Result := I;
          Exit;
        end;
      end;

    { Can't ever get here....but if we do force the script to exit }
    Result := CommandNodes.Count;
  end;

  { Add all substring triggers }
  procedure AddMultiTriggers(S: AnsiString);
  var
    Len    : Byte;
    SepPos : Byte;
    Sub    : AnsiString;
  begin
    FillChar(DataTrigger, SizeOf(DataTrigger), 0);
    TriggerCount := 0;
    repeat
      SepPos := Pos(CmdSepChar, string(S));
      if SepPos = 0 then
        Len := 255
      else
        Len:= SepPos-1;
      Sub := Copy(S, 1, Len);
      Inc(TriggerCount);
      DataTrigger[TriggerCount] := ComPort.AddDataTrigger(Sub, True);
      Delete(S, 1, SepPos);
    until SepPos = 0;
  end;

  function ParseUserVariables (const S : AnsiString) : AnsiString;
  begin
    result := S;
    if Length(S) > 0 then
      if S[1] = '$' then
        if assigned (FOnScriptParseVariable) then begin
          FOnScriptParseVariable (Self, S, Result);
        end;
  end;

begin
  with TApdScriptNode(CommandNodes[NodeIndex]) do begin
    {$IFDEF DebugScript}

    WriteCommand(NodeIndex, TApdScriptNode(CommandNodes[NodeIndex]));
    {$ENDIF}
    LogCommand (NodeIndex, Command, TApdScriptNode(CommandNodes[NodeIndex]));

    { Generate OnScriptCommandStart event }
    ScriptCommandStart(TApdScriptNode(CommandNodes[NodeIndex]),
                       LastCondition);

    { Process it... }
    NextIndex := NodeIndex + 1;
    ScriptState := ssReady;

    tData := ParseUserVariables (Data);
    tDataEx := ParseUserVariables (DataEx);

    case Command of
      scLabel: { Advance to next command } ;

      scInitPort:
        begin
          OpenedPort := True;
          SaveOpen := ComPort.Open;
          ComPort.DeviceLayer := dlWin32;
          ComPort.ComNumber := CheckComPort(string(tData));
          ComPort.Open := True;
        end;

      scInitWnPort:
        begin
          OpenedPort := True;
          SaveOpen := ComPort.Open;
          if CheckWinsockPort then begin
            ParseURL(string(tData), Addr, Port);
            TApdCustomWinsockPort(ComPort).DeviceLayer := dlWinsock;
            TApdCustomWinsockPort(ComPort).WsAddress := Addr;
            TApdCustomWinsockPort(ComPort).WsPort := Port;
            ComPort.Open := True;
          end;
        end;

      scDonePort:
        begin
          OpenedPort := False;
          ComPort.Open := False;
        end;

      scSend :
        { Send the data }
        ComPort.Output := tData;

      scWait :
        { Set up triggers to do the waiting }
        try
          { Add/set the triggers }
          DataTrigger[1] := 0;
          TimerTrigger := 0;
          TriggerCount := 1;
          DataTrigger[1] := ComPort.AddDataTrigger(tData, True);
          TimerTrigger := ComPort.AddTimerTrigger;
          ComPort.SetTimerTrigger(TimerTrigger, MSecs2Ticks(Timeout), True);
          ScriptState := ssWait;
        except
          { Cleanup triggers and reraise exception }
          if DataTrigger[1] <> 0 then
            ComPort.RemoveTrigger(DataTrigger[1]);
          FillChar(DataTrigger, SizeOf(DataTrigger), 0);
          if TimerTrigger <> 0 then
          ComPort.RemoveTrigger(TimerTrigger);
          TriggerCount := 0;
          TimerTrigger := 0;
          raise;
        end;

      scWaitMulti:
        try
          { Add/set triggers }
          FillChar(DataTrigger, SizeOf(DataTrigger), 0);
          AddMultiTriggers(tData);
          TimerTrigger := ComPort.AddTimerTrigger;
          ComPort.SetTimerTrigger(TimerTrigger, MSecs2Ticks(Timeout), True);
          ScriptState := ssWait;
        except
          for I := 1 to MaxDataTriggers do
            if DataTrigger[I] <> 0 then
              ComPort.RemoveTrigger(DataTrigger[I]);
          FillChar(DataTrigger, SizeOf(DataTrigger), 0);
          TriggerCount := 0;
          if TimerTrigger <> 0 then
            ComPort.RemoveTrigger(TimerTrigger);
          TimerTrigger := 0;
          raise;
        end;

      scIf  :
        { If processing }
        if Condition = LastCondition then begin
          { Matches last condition, jump to specified label }
          NextIndex := FindLabel(string(tData));
          {$IFDEF DebugScript}
          WriteLn(Dbg,'  matched  ');
          {$ENDIF}
          AddDispatchLogEntry ('  Matched ');
        end else begin
          {$IFDEF DebugScript}
          WriteLn(Dbg,'  not matched  ');
          {$ENDIF}
          AddDispatchLogEntry ('  not matched ');
        end;

      scSetOption:
        case Option of
          oBaud:
            TApdCustomComPort(Comport).Baud := StrToInt(string(tData));

          oDataBits:
            TApdCustomComPort(Comport).DataBits := StrToInt(string(tData));

          oFlow:
            SetFlow(string(tData));

          oParity:
            SetParity(string(tData));

          oStopBits:
            TApdCustomComPort(Comport).StopBits := StrToInt(string(tData));

          oWsTelnet:
            if CheckWinsockPort then
              TApdCustomWinsockPort(ComPort).WsTelnet := Boolean(Timeout);

          oSetRetry:
            Retry := Timeout;

          oSetFilename:
            if CheckProtocol then
              Protocol.FileName := tData;

          oSetFileMask:
            if CheckProtocol then
              Protocol.FileMask := string(tData);

          oSetDirectory:
            if CheckProtocol then
              Protocol.DestinationDirectory := tData;

          oSetWriteRename:
            if CheckProtocol then
              Protocol.WriteFailAction := wfWriteRename;

          oSetWriteFail:
            if CheckProtocol then
              Protocol.WriteFailAction := wfWriteFail;

          oSetWriteAnyway:
            if CheckProtocol then
              Protocol.WriteFailAction := wfWriteAnyway;

          oSetZWriteProtect:
            if CheckProtocol then
              Protocol.ZmodemFileOption := zfoWriteProtect;

          oSetZWriteClobber:
            if CheckProtocol then
              Protocol.ZmodemFileOption  := zfoWriteClobber;

          oSetZWriteNewer:
            if CheckProtocol then
              Protocol.ZmodemFileOption := zfoWriteNewer;

          oSetZSkipNoFile:
            if CheckProtocol then
              Protocol.ZmodemSkipNoFile := Boolean(Timeout);
        end;

      scUpload,
      scDownload:
        if CheckProtocol then begin
          { Set a finish hook }
          SaveProtocolFinish := Protocol.OnProtocolFinish;
          Protocol.OnProtocolFinish := ScriptProtocolFinish;
          Protocol.ProtocolType := ValidateProtocol(string(tData));
          { Deactivate terminal }
          if Assigned(FTerminal) then begin
            if FTerminal is TAdCustomTerminal then begin
              OldActive := TAdCustomTerminal(Terminal).Active;
              TAdCustomTerminal(Terminal).Active := False;
            end;
          end;

          { Start the transfer }
          if Command = scUpload then
            Protocol.StartTransmit
          else
            Protocol.StartReceive;
          ScriptState := ssWait;
        end else
          LastCondition := ccFail;

      scSendBreak:
        ComPort.SendBreak(Timeout, False);

      scChDir:
        ChDir(string(tData));

      scDelete:
        DeleteFiles(string(tData));

      scGoto:
        { Goto label }
        NextIndex := FindLabel(string(tData));

      scDisplay:
        ScriptDisplay(tData);

      scDelay:
        begin
          TimerTrigger := ComPort.AddTimerTrigger;
          ComPort.SetTimerTrigger(TimerTrigger, MSecs2Ticks(Timeout), True);
          Continuing := True;
          ScriptState := ssWait;
        end;

      scRun:
        ExecuteExternal(string(tData), Boolean(Timeout));

      scUserFunction:
        begin
          if assigned (FOnScriptUserFunction) then
            FOnScriptUserFunction (Self, tData, tDataEx);
        end;

      scExit:
        begin
          ScriptState := ssFinished;
          if (tData = 'SUCCESS') or (tData = 'OK') or (tData = '') then
            StopScript (ccSuccess)
          else if tData = 'TIMEOUT' then
            StopScript (ccTimeout)
          else if tData = 'FAIL' then
            StopScript (ccFail)
          else begin
            try
              StopScript (StrToInt (string(tData)));
            except
              on EConvertError do
                StopScript (ccBadExitCode);
            end;
          end;
        end;

    end;

    { Generate OnScriptPostStep event }
    ScriptCommandFinish(TApdScriptNode(CommandNodes[NodeIndex]),
                        LastCondition);
  end;

end;

{ Generate the OnScriptException event }
function TApdCustomScript.GenerateScriptException (E       : Exception;
                                                   Command : TApdScriptNode) : Boolean;
begin
  Result := False;
  if assigned (FOnScriptException) then
    FOnScriptException (Self, E, Command, Result);
end;

{ Process commands until we get to a wait state }
procedure TApdCustomScript.ProcessTillWait;
begin
  {$IFDEF DebugScript}
  WriteLn(Dbg,'entering ProcessTillWait');
  {$ENDIF}
  AddDispatchLogEntry ('Entering ProcessTillWait');

  repeat
    { Process the current command }
    try
      { Process the next command }
      if ScriptState = ssReady then
          ProcessNextCommand;

      { Set next command }
      NodeIndex := NextIndex;
      if NodeIndex = CommandNodes.Count then begin
        LastCondition := ccSuccess;
        ScriptState := ssFinished;
      end;
    except
      on E:Exception do begin
        if not GenerateScriptException (E,
               TApdScriptNode(CommandNodes[NodeIndex])) then begin
          ScriptState := ssFinished;
          LastCondition := ccFail;
        end else begin
          NodeIndex := NodeIndex + 1;
          if NodeIndex = CommandNodes.Count then begin
            LastCondition := ccSuccess;
            ScriptState := ssFinished;
          end;
        end;
      end;
    end;
  until (ScriptState > ssReady);

  { Waiting or finished? }
  if ScriptState = ssFinished then begin

    {$IFDEF DebugScript}
    ScriptState := ssWait;
    WriteLn(Dbg,'script is finished');
    {$ENDIF}

    AddDispatchLogEntry ('Script is finished');

    StopScript(LastCondition);

  end;

  {$IFDEF DebugScript}
  WriteLn(Dbg,'leaving ProcessTillWait: ' + IntToStr(Ord(ScriptState)));
  {$ENDIF}
  AddDispatchLogEntry (AnsiString('Leaving ProcessTillWait ' +
                       IntToStr(Ord(ScriptState))));
end;

{ Start processing the script in the background }
procedure TApdCustomScript.StartScript;
begin
  if FInProgress then Exit;

  {$IFDEF DebugScript}
  WriteLn(Dbg,'entering StartScript');
  {$ENDIF}
  AddDispatchLogEntry ('Entering StartScript');

  { Error if no script... }
  if CommandNodes.Count = 0 then
    { ...but try to load first }
    PrepareScript;

  { Check for no commands }
  if CommandNodes.Count = 0 then
    exit;

  { Inits }
  FInProgress := True;
  Attempts := 0;
  NodeIndex := 0;
  FillChar(DataTrigger, SizeOf(DataTrigger), 0);
  TimerTrigger := 0;
  ScriptState := ssReady;

  { Create a comport if none assigned }
  if not Assigned(FComPort) then begin
    FComPort := TApdComPort.Create(Self);
    CreatedPort := True;

    { If we have a terminal then add it as a port user }
    if Assigned(FTerminal) then begin

      { New terminal }
      if FTerminal is TAdCustomTerminal then begin
        TAdCustomTerminal(Terminal).ComPort := ComPort;
        ComPort.RegisterUser(Terminal.Handle);
      end;

    end;
  end else
    CreatedPort := False;

  { Process until we come till the first wait }
  ProcessTillWait;

  { Take over the comport's OnTrigger handler }
  SaveOnTrigger := ComPort.OnTrigger;
  ComPort.OnTrigger := AllTriggers;

  {$IFDEF DebugScript}
  WriteLn(Dbg,'leaving StartScript');
  {$ENDIF}
  AddDispatchLogEntry ('Leaving StartScript');

end;

{ Stop the script and cleanup everything }
procedure TApdCustomScript.StopScript(Condition: Integer);
var
  I: Integer;
begin
  if InProgress then begin

    { Clear all triggers }
    for I := 1 to TriggerCount do
      if DataTrigger[I] <> 0 then
        ComPort.RemoveTrigger(DataTrigger[I]);
    TriggerCount := 0;
    if TimerTrigger <> 0 then
      ComPort.RemoveTrigger(TimerTrigger);
    FillChar(DataTrigger, SizeOf(DataTrigger), 0);
    TimerTrigger := 0;

    { Port cleanups }
    if not CreatedPort then begin
      if OpenedPort then begin
        ComPort.Open := SaveOpen;
      end;
      ComPort.OnTrigger := SaveOnTrigger;
    end else
      { If we created the port, it will get disposed in Destroy }
      if Assigned(FTerminal) then
        ComPort.DeregisterUser(Terminal.Handle);

    if Assigned(FProtocol) then begin
    { Protocol cleanups }
      if CreatedProtocol then
        Protocol.Free
      else
        Protocol.OnProtocolFinish := SaveProtocolFinish;
    end;

    { Signal that script is finished }
    ScriptFinish(Condition);

    FInProgress := False;
  end;
end;

{ Cancel a script in progress }
procedure TApdCustomScript.CancelScript;
begin
  StopScript(ccFail);
end;

{ Fake a timeout so we can exit and re-enter via dispatcher }
procedure TApdCustomScript.GoContinue;
begin
  try
    TimerTrigger := ComPort.AddTimerTrigger;
    ComPort.SetTimerTrigger(TimerTrigger, 1, True);
    Continuing := True;
  except
    CancelScript;
  end;
end;

{ Called when protocol finishes, continues script processing }
procedure TApdCustomScript.ScriptProtocolFinish(CP: TObject; ErrorCode: Integer);
begin
  { Call previous... }
  if Assigned(SaveProtocolFinish) then
    SaveProtocolFinish(CP, ErrorCode);

  { Reactivate terminal }
  if Assigned(FTerminal) then begin

    if FTerminal is TAdTerminal then
      TAdTerminal(Terminal).Active := OldActive;

  end;

  { Set the protocol finish condition }
  if ErrorCode = ecOK then
    LastCondition := ccSuccess
  else
    LastCondition := ccFail;
  ScriptState := ssReady;

  { Don't need this anymore }
  Protocol.OnProtocolFinish := SaveProtocolFinish;

  { Continue with script }
  GoContinue;
end;

procedure TApdCustomScript.SetFlow(const FlowOpt: string);
begin
  if FlowOpt = 'RTS/CTS' then begin
    TApdCustomComport(ComPort).HWFlowOptions := [hwfUseRTS, hwfRequireCTS];
    TApdCustomComport(ComPort).SWFlowOptions := swfNone;
  end else if FlowOpt = 'XON/XOFF' then begin
    TApdCustomComport(ComPort).HWFlowOptions := [];
    TApdCustomComport(ComPort).SWFlowOptions := swfBoth;
  end else if FlowOpt = 'NONE' then begin
    TApdCustomComport(ComPort).HWFlowOptions := [];
    TApdCustomComport(ComPort).SWFlowOptions := swfNone;
  end;
end;

procedure TApdCustomScript.SetParity(const ParityOpt: string);
begin
  if ParityOpt = 'NONE' then
    TApdCustomComport(ComPort).Parity := pNone
  else if ParityOpt = 'ODD' then
    TApdCustomComport(ComPort).Parity := pOdd
  else if ParityOpt = 'EVEN' then
    TApdCustomComport(ComPort).Parity := pEven
  else if ParityOpt = 'MARK' then
    TApdCustomComport(ComPort).Parity := pMark
  else if ParityOpt = 'SPACE' then
    TApdCustomComport(ComPort).Parity := pSpace;
end;

{$IFDEF DebugScript}
initialization
  AssignFile(Dbg, 'debug.txt');
  Rewrite(Dbg);

finalization
  CloseFile(Dbg);
{$ENDIF}
end.

