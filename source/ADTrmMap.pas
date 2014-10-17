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
{*                   ADTRMMAP.PAS 4.06                   *}
{*********************************************************}
{* Terminal: keyboard and character set mapping classes  *}
{*********************************************************}

unit ADTrmMap;

interface

{ Notes: this hash table class has been designed for one narrow
         purpose: storing pairs of strings, the first string being the
         'key' and the second being the 'value' of that key. The
         strings are of type TAdKeyString (a 63 char string). The
         strings define keyboard mappings, either the name of a key
         on the DEC VT100 keyboard and its associated escape sequence,
         or a (shifted) virtual key code and its associated key name.

         Consequently there is no method to delete key/value pairs: it
         has been assumed that entries will be added en bloc, either
         from a resource or a specially formatted text file.

         To aid in the generation of a resource, the class has a
         special method for writing a binary file for inclusion in an
         RC file and subsequent compilation. The RC file should
         contain at least the following line for this to work:

           <ResourceName> RCDATA <BinaryFileName>

         where ResourceName is the unique name you want to call the
         resource, and BinaryFileName is the name of the binary file
         containing the 'compiled keyboard mapping created by the
         StoreToBinFile method. For example, if an RC file had the
         following line:

           APRO_VT100KeyMap RCDATA C:\APRO\VT100.MAP

         it will compile to a RES file with BRCC or BRCC32, and
         contain a single resource called APRO_VT100KeyMap, and the
         C:\APRO\VT100.MAP will be used in that compilation.
}

{$I AWDEFINE.INC}

{$IFOPT D+}
{$DEFINE CompileDebugCode}
{$ENDIF}

{$IFDEF Win32}
{$R ADTRMVT1.R32}
{$R ADCHSVT1.R32}
{$ELSE}
{$R ADTRMVT1.R16}
{$R ADCHSVT1.R16}
{$ENDIF}

uses
  SysUtils,
  Windows,
  Classes,
  OOMisc;

type
  PadKeyString = ^TAdKeyString;
  TAdKeyString = string[63];
  
const
  DefaultFontName : string[9] = '<Default>';

type
  TAdKeyboardMapping = class
    private
      FTable : TList;
      FCount : integer;
    protected
      function kbmFindPrim(const aKey  : TAdKeyString;
                             var aInx  : integer;
                             var aNode : pointer) : boolean;
    public
      constructor Create;
      destructor Destroy; override;

      function Add(const aKey   : TAdKeyString;
                   const aValue : TAdKeyString) : boolean;
      procedure Clear;
      function Get(const aKey : TAdKeyString) : TAdKeyString;

      procedure LoadFromFile(const aFileName : string);
      procedure LoadFromRes(aInstance : THandle;
                      const aResName  : string);
      procedure StoreToBinFile(const aFileName : string);

      {$IFDEF CompileDebugCode}
      procedure DebugPrint(const aFileName : string);
      {$ENDIF}

      property Count : integer read FCount;
  end;

type
  TAdCharSetMapping = class
    private
      FTable     : TList;
      FCharQueue : pointer;
      FCount     : integer;
      FScript    : pointer;
      FScriptEnd : pointer;
      FScriptFreeList : pointer;
    protected
      procedure csmAddScriptNode(aFont : PadKeyString);
      function csmFindPrim(const aCharSet : TAdKeyString;
                                 aChar    : AnsiChar;
                             var aInx     : integer;
                             var aNode    : pointer) : boolean;
      procedure csmFreeScript;

    public
      constructor Create;
      destructor Destroy; override;

      function Add(const aCharSet : TAdKeyString;
                         aFromCh  : AnsiChar;
                         aToCh    : AnsiChar;
                   const aFont    : TAdKeyString;
                         aGlyph   : AnsiChar) : boolean;
      procedure Clear;

      procedure GetFontNames(aList : TStrings);

      procedure GenerateDrawScript(const aCharSet : TAdKeyString;
                                         aText    : PAnsiChar);
      function GetNextDrawCommand(var aFont : TAdKeyString;
                                      aText : PAnsiChar) : boolean;

      procedure LoadFromFile(const aFileName : string);
      procedure LoadFromRes(aInstance : THandle;
                      const aResName  : string);
      procedure StoreToBinFile(const aFileName : string);

      {$IFDEF CompileDebugCode}
      procedure DebugPrint(const aFileName : string);
      {$ENDIF}

      property Count : integer read FCount;
  end;

implementation

const
  {The hash table sizes: these are prime numbers that suit these
   particular implementations}
  KBHashTableSize = 57;    {keyboard mapping hash table size}
  CSHashTableSize = 199;   {charset mapping hash table size}

  OurSignature : longint = $33544841;
    {Note: $33544841 = AHT3 = APRO Hash Table, version 3}


type
  PKBHashNode = ^TKBHashNode;   {hash table node for keyboard maps}
  TKBHashNode = packed record
    kbnNext  : PKBHashNode;
    kbnKey   : PadKeyString;
    kbnValue : PadKeyString;
  end;

type
  PCSHashNode = ^TCSHashNode;   {hash table node for charset maps}
  TCSHashNode = packed record
    csnNext    : PCSHashNode;
    csnCharSet : PadKeyString;
    csnFont    : PadKeyString;
    csnChar    : AnsiChar;
    csnGlyph   : AnsiChar;
  end;

  PScriptNode = ^TScriptNode;
  TScriptNode = packed record
    snNext : PScriptNode;
    snFont : PadKeyString;
    snText : PAnsiChar;
  end;


{===TCharQueue=======================================================}
const
  CharQueueDelta = 32;
type
  TCharQueue = class
    private
      FSize : longint;
      FLen  : longint;
      FText : PAnsiChar;
    protected
      function cqGetDupText : PAnsiChar;
    public
      constructor Create;
      destructor Destroy; override;

      procedure Add(aCh : AnsiChar);
      procedure Clear;

      property DupText : PAnsiChar read cqGetDupText;
  end;
{--------}
constructor TCharQueue.Create;
begin
  inherited Create;
  {allocate a starter character queue}
  GetMem(FText, CharQueueDelta);
  FSize := CharQueueDelta;
  FText[0] := #0;
end;
{--------}
destructor TCharQueue.Destroy;
begin
  if (FText <> nil) then
    FreeMem(FText, FSize);
  inherited Destroy;
end;
{--------}
procedure TCharQueue.Add(aCh : AnsiChar);
var
  NewQ : PAnsiChar;
begin
  if (FLen = FSize-1) then begin
    GetMem(NewQ, FSize + CharQueueDelta);
    StrCopy(NewQ, FText);
    FreeMem(FText, FSize);
    inc(FSize, CharQueueDelta);
    FText := NewQ;
  end;
  FText[FLen] := aCh;
  inc(FLen);
  FText[FLen] := #0;
end;
{--------}
procedure TCharQueue.Clear;
begin
  FLen := 0;
  FText[0] := #0;
end;
{--------}
function TCharQueue.cqGetDupText : PAnsiChar;
begin
  GetMem(Result, FLen+1);
  StrCopy(Result, FText);
end;
{====================================================================}

{===Helper routines==================================================}
{Note: The ELF hash functions are described in "Practical Algorithms
       For Programmers" by Andrew Binstock and John Rex, Addison
       Wesley, with modifications in Dr Dobbs Journal, April 1996.
       They're modified to suit this implementation.}
function HashELF(const S : TAdKeyString) : longint;
var
  G : longint;
  i : integer;
begin
  Result := 0;
  for i := 1 to length(S) do begin
    Result := (Result shl 4) + ord(S[i]);
    G := Result and longint($F0000000);
    if (G <> 0) then
      Result := Result xor (G shr 24);
    Result := Result and (not G);
  end;
end;
{--------}
function HashELFPlusChar(const S : TAdKeyString;
                               C : AnsiChar) : longint;
var
  G : longint;
  i : integer;
begin
  Result := ord(C);
  G := Result and longint($F0000000);
  if (G <> 0) then
    Result := Result xor (G shr 24);
  Result := Result and (not G);
  for i := 1 to length(S) do begin
    Result := (Result shl 4) + ord(S[i]);
    G := Result and longint($F0000000);
    if (G <> 0) then
      Result := Result xor (G shr 24);
    Result := Result and (not G);
  end;
end;
{--------}
function AllocKeyString(const aSt : TAdKeyString) : PadKeyString;
begin
  GetMem(Result, succ(length(aSt)));
  Result^ := aSt;
end;
{--------}
procedure FreeKeyString(aKS : PadKeyString);
begin
  if (aKS <> nil) then
    FreeMem(aKS, succ(length(aKS^)));
end;
{--------}
function ProcessCharSetLine(const aLine : ShortString;
                              var aCharSet : TAdKeyString;
                              var aFromCh  : AnsiChar;
                              var aToCh    : AnsiChar;
                              var aFontName: TAdKeyString;
                              var aGlyph   : AnsiChar) : boolean;
var
  InWord    : boolean;
  CharInx   : integer;
  StartCh   : integer;
  QuoteMark : AnsiChar;
  WordStart : array [0..4] of integer;
  WordEnd   : array [0..4] of integer;
  WordCount : integer;
  WordLen   : integer;
  Chars     : array [0..4] of AnsiChar;
  i         : integer;
  AsciiCh   : integer;
  ec        : integer;
  TestSt    : string[3];
begin
  {assumption: the line has had trailing spaces stripped, the line is
   not the empty string, the line starts with a ' ' character

  {assume we'll fail to parse the line properly}
  Result := false;

  {extract out the 5 words; if there are not at least 5 words, exit}
  QuoteMark := ' '; {needed to fool the compiler}
  StartCh := 0;     {needed to fool the compiler}
  InWord := false;
  WordCount := 0;
  CharInx := 1;
  while CharInx <= length(aLine) do begin
    if InWord then begin
      if (QuoteMark = ' ') then begin
        if (aLine[CharInx] = ' ') then begin
          InWord := false;
          WordStart[WordCount] := StartCh;
          WordEnd[WordCount] := pred(CharInx);
          inc(WordCount);
          if (WordCount = 5) then
            Break;
        end
      end
      else {the quotemark is active} begin
        if (aLine[CharInx] = QuoteMark) then
          QuoteMark := ' ';
      end;
    end
    else {not in a word} begin
      if (aLine[CharInx] <> ' ') then begin
        InWord := true;
        StartCh := CharInx;
        QuoteMark := aLine[CharInx];
        if (QuoteMark <> '''') and (QuoteMark <> '"') then
          QuoteMark := ' ';
      end;
    end;
    inc(CharInx);
  end;
  {when we reach this point we know where the last word ended}
  if InWord then begin
    if (QuoteMark <> ' ') then
      Exit; {the last word had no close quote}
    WordStart[WordCount] := StartCh;
    WordEnd[WordCount] := pred(CharInx);
    inc(WordCount);
  end;
  if (WordCount <> 5) then
    Exit;
  {fix the quoted strings}
  for i := 0 to 4 do begin
    if (aLine[WordStart[i]] = '''') or
       (aLine[WordStart[i]] = '"') then begin
      inc(WordStart[i]);
      dec(WordEnd[i]);
      if (WordEnd[i] < WordStart[i]) then
        Exit; {the word was either '' or ""}
    end;
  end;
  {we now know where each word can be found; the only special words
   are words 1, 2, and 4 which must be single characters, or ASCII
   values of the form \xnn}
  for i := 1 to 4 do
    if (i <> 3) then begin
      WordLen := succ(WordEnd[i] - WordStart[i]);
      if (WordLen = 1) then
        Chars[i] := aLine[WordStart[i]]
      else if (WordLen = 4) then begin
        CharInx := WordStart[i];
        if (aLine[CharInx] <> '\') or
           (aLine[CharInx+1] <> 'x') then
          Exit;
        TestSt := Copy(aLine, CharInx+1, 3);
        TestSt[1]:= '$';
        Val(TestSt, AsciiCh, ec);
        if (ec <> 0) then
          Exit;
        Chars[i] := AnsiChar(AsciiCh);
      end
      else
        Exit; {unknown format}
    end;
  {return values}
  aFromCh := Chars[1];
  aToCh := Chars[2];
  aGlyph := Chars[4];
  aCharSet := Copy(aLine, WordStart[0], succ(WordEnd[0] - WordStart[0]));
  aFontName := Copy(aLine, WordStart[3], succ(WordEnd[3] - WordStart[3]));
  Result := true;
end;
{====================================================================}


{===TAdKeyboardMapping==================================================}
constructor TAdKeyboardMapping.Create;
begin
  inherited Create;
  FTable := TList.Create;
  FTable.Count := KBHashTableSize;
end;
{--------}
destructor TAdKeyboardMapping.Destroy;
begin
  if (FTable <> nil) then begin
    Clear;
    FTable.Destroy;
  end;
  inherited Destroy;
end;
{--------}
function TAdKeyboardMapping.Add(const aKey   : TAdKeyString;
                             const aValue : TAdKeyString) : boolean;
var
  Inx  : integer;
  Node : PKBHashNode;
begin
  if kbmFindPrim(aKey, Inx, pointer(Node)) then
    Result := false
  else begin
    Result := true;
    New(Node);
    Node^.kbnNext := FTable[Inx];
    Node^.kbnKey := AllocKeyString(aKey);
    Node^.kbnValue := AllocKeyString(aValue);
    FTable[Inx] := Node;
    inc(FCount);
  end;
end;
{--------}
procedure TAdKeyboardMapping.Clear;
var
  i    : integer;
  Node : PKBHashNode;
  Temp : PKBHashNode;
begin
  for i := 0 to pred(KBHashTableSize) do begin
    Node := FTable[i];
    while (Node <> nil) do begin
      Temp := Node;
      Node := Node^.kbnNext;
      FreeKeyString(Temp^.kbnKey);
      FreeKeyString(Temp^.kbnValue);
      Dispose(Temp);
    end;
    FTable[i] := nil;
  end;
  FCount := 0;
end;
{--------}
{$IFDEF CompileDebugCode}
procedure TAdKeyboardMapping.DebugPrint(const aFileName : string);
var
  F    : text;
  i    : integer;
  Node : PKBHashNode;
begin
  System.Assign(F, aFileName);
  System.Rewrite(F);

  for i := 0 to pred(KBHashTableSize) do begin
    writeln(F, '---', i, '---');
    Node := FTable[i];
    while (Node <> nil) do begin
      writeln(F, Node^.kbnKey^:20, Node^.kbnValue^:20);
      Node := Node^.kbnNext;
    end;
  end;

  writeln(F);
  writeln(F, 'Count: ', Count, ' (mean: ', Count/CSHashTableSize:5:3, ')');

  System.Close(F);
end;
{$ENDIF}
{--------}
function TAdKeyboardMapping.Get(const aKey : TAdKeyString) : TAdKeyString;
var
  Inx  : integer;
  Node : PKBHashNode;
begin
  if kbmFindPrim(aKey, Inx, pointer(Node)) then
    Result := Node^.kbnValue^
  else
    Result := '';
end;
{--------}
function TAdKeyboardMapping.kbmFindPrim(const aKey  : TAdKeyString;
                                          var aInx  : integer;
                                          var aNode : pointer) : boolean;
var
  Node : PKBHashNode;
begin
  {assume we won't find aKey}
  Result := false;
  aNode := nil;
  {calculate the index, ie hash, of the key}
  aInx := HashELF(aKey) mod KBHashTableSize;
  {traverse the linked list at this entry, looking for the key in each
   node we encounter--a case-sensitive comparison}
  Node := FTable[aInx];
  while (Node <> nil) do begin
    if (aKey = Node^.kbnKey^) then begin
      Result := true;
      aNode := Node;
      Exit;
    end;
    Node := Node^.kbnNext;
  end;
end;
{--------}
procedure TAdKeyboardMapping.LoadFromFile(const aFileName : string);
var
  Lines     : TStringList;
  ActualLen : integer;
  i         : integer;
  LineInx   : integer;
  Word1Start: integer;
  Word1End  : integer;
  Word2Start: integer;
  Word2End  : integer;
  LookingForStart : boolean;
  Line      : string[255];
begin
  {clear the hash table, ready for loading}
  Clear;
  {create the stringlist to hold the keymap script}
  Lines := TStringList.Create;
  try
    {load the keymap script}
    Lines.LoadFromFile(aFileName);
    for LineInx := 0 to pred(Lines.Count) do begin
      {get this line}
      Line := Lines[LineInx];
      {remove trailing spaces}
      ActualLen := length(Line);
      for i := ActualLen downto 1 do
        if (Line[i] = ' ') then
          dec(ActualLen)
        else
          Break;
      Line[0] := AnsiChar(ActualLen);
      {only process detail lines}
      if (Line <> '') and (Line[1] <> '*') then begin
        {identify the first 'word'}
        Word1Start := 0;
        Word1End := 0;
        LookingForStart := true;
        for i := 1 to ActualLen do begin
          if LookingForStart then begin
            if (Line[i] <> ' ') then begin
              Word1Start := i;
              LookingForStart := false;
            end;
          end
          else {looking for end} begin
            if (Line[i] = ' ') then begin
              Word1End := i - 1;
              Break;
            end;
          end;
        end;
        {if we've set Word1End then there are at least two words in
         the line, otherwise there was only one word (which we shall
         ignore)}
        if (Word1End <> 0) then begin
          {identify the second 'word'}
          Word2Start := 0;
          Word2End := 0;
          LookingForStart := true;
          for i := succ(Word1End) to ActualLen do begin
            if LookingForStart then begin
              if (Line[i] <> ' ') then begin
                Word2Start := i;
                LookingForStart := false;
              end;
            end
            else {looking for end} begin
              if (Line[i] = ' ') then begin
                Word2End := i - 1;
                Break;
              end;
            end;
          end;
          if (Word2End = 0) then
            Word2End := ActualLen;
          {add the key and value to the hash table}
          Add(System.Copy(Line, Word1Start, succ(Word1End-Word1Start)),
              System.Copy(Line, Word2Start, succ(Word2End-Word2Start)));
        end;
      end;
    end;
  finally
    Lines.Free;
  end;
end;
{--------}
procedure TAdKeyboardMapping.LoadFromRes(aInstance : THandle;
                                const aResName  : string);
var
  MS        : TMemoryStream;
  ResInfo   : THandle;
  ResHandle : THandle;
  ResNameZ  : PChar;
  Res       : PByteArray;
  i         : integer;
  Sig       : longint;
  ResCount  : longint;
  BytesRead : longint;
  Key       : TAdKeyString;
  Value     : TAdKeyString;
begin
  {Note: this code has been written to work with all versions of
   Delphi, both 16-bit and 32-bit. Hence it does not make use of any
   of the features available in later compilers, ie, typecasting a
   string to a PAnsiChar, or TResourceStream)

  {clear the hash table, ready for loading}
  Clear;
  {get the resource info handle}
  GetMem(ResNameZ, succ(length(aResName)));
  try
    StrPCopy(ResNameZ, aResName);
    ResInfo := FindResource(aInstance, ResNameZ, RT_RCDATA);
  finally
    FreeMem(ResNameZ, succ(length(aResName)));
  end;
  if (ResInfo = 0) then
    Exit;
  {load and lock the resource}
  ResHandle := LoadResource(aInstance, ResInfo);
  if (ResHandle = 0) then
    Exit;
  Res := LockResource(ResHandle);
  if (Res = nil) then begin
    FreeResource(ResHandle);
    Exit;
  end;
  try
    {create a memory stream}
    MS := TMemoryStream.Create;
    try
      {copy the resource to our memory stream}
      MS.Write(Res^, SizeOfResource(aInstance, ResInfo));
      MS.Position := 0;
      {read the header signature, get out if it's not ours}
      BytesRead := MS.Read(Sig, sizeof(Sig));
      if (BytesRead <> sizeof(Sig)) or (Sig <> OurSignature) then
        Exit;
      {read the count of key/value string pairs in the resource}
      MS.Read(ResCount, sizeof(ResCount));
      {read that number of key/value string pairs and add them to the
       hash table}
      for i := 0 to pred(ResCount) do begin
        MS.Read(Key[0], 1);
        MS.Read(Key[1], ord(Key[0]));
        MS.Read(Value[0], 1);
        MS.Read(Value[1], ord(Value[0]));
        Add(Key, Value);
      end;
      {read the footer signature, clear and get out if it's not ours}
      BytesRead := MS.Read(Sig, sizeof(Sig));
      if (BytesRead <> sizeof(Sig)) or (Sig <> OurSignature) then begin
        Clear;
        Exit;
      end;
    finally
      MS.Free;
    end;
  finally
    UnlockResource(ResHandle);
    FreeResource(ResHandle);
  end;
end;
{--------}
procedure TAdKeyboardMapping.StoreToBinFile(const aFileName : string);
var
  aFS  : TFileStream;
  i    : integer;
  Node : PKBHashNode;
begin
  {create a file stream}
  aFS := TFileStream.Create(aFileName, fmCreate);
  try
    {write our signature as header}
    aFS.Write(OurSignature, sizeof(OurSignature));
    {write the number of key/value string pairs}
    aFS.Write(FCount, sizeof(FCount));
    {write all the key/value string pairs}
    for i := 0 to pred(KBHashTableSize) do begin
      Node := FTable[i];
      while (Node <> nil) do begin
        aFS.Write(Node^.kbnKey^, succ(length(Node^.kbnKey^)));
        aFS.Write(Node^.kbnValue^, succ(length(Node^.kbnValue^)));
        Node := Node^.kbnNext;
      end;
    end;
    {write our signature as footer as a check}
    aFS.Write(OurSignature, sizeof(OurSignature));
  finally
    aFS.Free;
  end;
end;
{====================================================================}


{===TAdCharSetMapping================================================}
constructor TAdCharSetMapping.Create;
begin
  inherited Create;
  FTable := TList.Create;
  FTable.Count := CSHashTableSize;
  FCharQueue := pointer(TCharQueue.Create);
end;
{--------}
destructor TAdCharSetMapping.Destroy;
var
  Temp, Walker : PScriptNode;
begin
  {free the hash table}
  if (FTable <> nil) then begin
    Clear;
    FTable.Destroy;
  end;
  {free the character queue}
  TCharQueue(FCharQueue).Free;
  {free the script node freelist}
  Walker := FScriptFreeList;
  while (Walker <> nil) do begin
    Temp := Walker;
    Walker := Walker^.snNext;
    Dispose(Temp);
  end;
  inherited Destroy;
end;
{--------}
function TAdCharSetMapping.Add(const aCharSet : TAdKeyString;
                                     aFromCh  : AnsiChar;
                                     aToCh    : AnsiChar;
                               const aFont    : TAdKeyString;
                                     aGlyph   : AnsiChar) : boolean;
var
  Inx  : integer;
  Node : PCSHashNode;
  Ch   : AnsiChar;
  Glyph: AnsiChar;
begin
  {we must do this in two stages: first, determine that we can add
   *all* the character mappings; second, do so}

  {stage one: check no mapping currently exists}
  Result := false;
  for Ch := aFromCh to aToCh do begin
    if csmFindPrim(aCharSet, Ch, Inx, pointer(Node)) then
      Exit;
  end;
  {stage two: add all charset/char mappings}
  Result := true;
  Glyph := aGlyph;
  for Ch := aFromCh to aToCh do begin
    Inx := HashELFPlusChar(aCharSet, Ch) mod CSHashTableSize;
    New(Node);
    Node^.csnNext := FTable[Inx];
    Node^.csnCharSet := AllocKeyString(aCharSet);
    Node^.csnFont := AllocKeyString(aFont);
    Node^.csnChar := Ch;
    Node^.csnGlyph := Glyph;
    FTable[Inx] := Node;
    inc(FCount);
    inc(Glyph);
  end;
end;
{--------}
procedure TAdCharSetMapping.Clear;
var
  i    : integer;
  Node : PCSHashNode;
  Temp : PCSHashNode;
begin
  {free the script: in a moment there's going to be no mapping}
  csmFreeScript;
  {clear out the hash table}
  for i := 0 to pred(CSHashTableSize) do begin
    Node := FTable[i];
    while (Node <> nil) do begin
      Temp := Node;
      Node := Node^.csnNext;
      FreeKeyString(Temp^.csnCharSet);
      FreeKeyString(Temp^.csnFont);
      Dispose(Temp);
    end;
    FTable[i] := nil;
  end;
  FCount := 0;
end;
{--------}
procedure TAdCharSetMapping.csmAddScriptNode(aFont : PadKeyString);
var
  Node : PScriptNode;
begin
  {allocate and set up the new node}
  if (FScriptFreeList = nil) then
    New(Node)
  else begin
    Node := FScriptFreeList;
    FScriptFreeList := Node^.snNext;
  end;
  Node^.snNext := nil;
  Node^.snFont := aFont;
  Node^.snText := TCharQueue(FCharQueue).DupText;
  {add the node to the script}
  if (FScript <> nil) then
    PScriptNode(FScriptEnd)^.snNext := Node
  else
    FScript := Node;
  {update the tail pointer}
  FScriptEnd := Node;
end;
{--------}
function TAdCharSetMapping.csmFindPrim(const aCharSet : TAdKeyString;
                                             aChar    : AnsiChar;
                                         var aInx     : integer;
                                         var aNode    : pointer) : boolean;
var
  Node : PCSHashNode;
begin
  {assume we won't find aCharSet/aChar}
  Result := false;
  aNode := nil;
  {calculate the index, ie hash, of the charset/char}
  aInx := HashELFPlusChar(aCharSet, aChar) mod CSHashTableSize;
  {traverse the linked list at this entry, looking for the character
   in each node we encounter--a case-sensitive comparison--if we get a
   match, compare the character set name as well, again case-
   insensitive}
  Node := FTable[aInx];
  while (Node <> nil) do begin
    if (aChar = Node^.csnChar) then begin
      if (aCharSet = Node^.csnCharSet^) then begin
        Result := true;
        aNode := Node;
        Exit;
      end;
    end;
    Node := Node^.csnNext;
  end;
end;
{--------}
procedure TAdCharSetMapping.csmFreeScript;
var
  Walker, Temp : PScriptNode;
begin
  Walker := FScript;
  FScript := nil;
  while (Walker <> nil) do begin
    Temp := Walker;
    Walker := Walker^.snNext;
    FreeMem(Temp^.snText, StrLen(Temp^.snText));
    {NOTE: we do NOT free the font name: it's a copy of an allocated
     string in the mapping hash table}
    Temp^.snNext := FScriptFreeList;
    FScriptFreeList := Temp;
  end;
end;
{--------}
{$IFDEF CompileDebugCode}
procedure TAdCharSetMapping.DebugPrint(const aFileName : string);
var
  F    : text;
  i    : integer;
  Node : PCSHashNode;
begin
  System.Assign(F, aFileName);
  System.Rewrite(F);

  for i := 0 to pred(CSHashTableSize) do begin
    writeln(F, '---', i, '---');
    Node := FTable[i];
    while (Node <> nil) do begin
      writeln(F, Node^.csnCharSet^:20,
                 ord(Node^.csnChar):4,
                 Node^.csnFont^:20,
                 ord(Node^.csnGlyph):4);
      Node := Node^.csnNext;
    end;
  end;

  writeln(F);
  writeln(F, 'Count: ', Count, ' (mean: ', Count/CSHashTableSize:5:3, ')');

  System.Close(F);
end;
{$ENDIF}
{--------}
procedure TAdCharSetMapping.GenerateDrawScript(const aCharSet : TAdKeyString;
                                                     aText    : PAnsiChar);
var
  i    : integer;
  Inx  : integer;
  TextLen  : integer;
  Node     : PCSHashNode;
  Ch       : AnsiChar;
  CurFont  : PadKeyString;
  ThisFont : PadKeyString;
  ThisChar : AnsiChar;
begin
  {nothing to do if the string is empty}
  TextLen := StrLen(aText);
  if (TextLen = 0) then
    Exit;
  {destroy any current script}
  csmFreeScript;
  TCharQueue(FCharQueue).Clear;
  {we don't yet have a font name}
  CurFont := nil;
  {read the text, char by char}
  for i := 0 to pred(TextLen) do begin
    {look up this charset/char in the hash table}
    Ch := aText[i];
    if csmFindPrim(aCharSet, Ch, Inx, pointer(Node)) then begin
      {found it, use the named font and glyph}
      ThisFont := Node^.csnFont;
      ThisChar := Node^.csnGlyph;
    end
    else begin
      {if not found, use the default font and glyph}
      ThisFont := @DefaultFontName;
      ThisChar := Ch;
    end;
    {if the font has changed, create a script node for the previous
     font}
    if (CurFont = nil) then
      CurFont := ThisFont;
    if (CurFont^ <> ThisFont^) then begin
      csmAddScriptNode(CurFont);
      CurFont := ThisFont;
      TCharQueue(FCharQueue).Clear;
    end;
    {add this character to the current string}
    TCharQueue(FCharQueue).Add(ThisChar);
  end;
  {add the final script node to finish off the string}
  csmAddScriptNode(CurFont);
  TCharQueue(FCharQueue).Clear;
end;
{--------}
procedure TAdCharSetMapping.GetFontNames(aList : TStrings);
var
  i    : integer;
  Node : PCSHashNode;
  PrevFont : string;
begin
  aList.Clear;
  PrevFont := '';
  for i := 0 to pred(CSHashTableSize) do begin
    Node := FTable[i];
    while (Node <> nil) do begin
      if (CompareText(Node^.csnFont^, PrevFont) <> 0) then begin
        PrevFont := Node^.csnFont^;
        if (aList.IndexOf(PrevFont) = -1) then
          aList.Add(PrevFont);
      end;
      Node := Node^.csnNext;
    end;
  end;
end;
{--------}
function TAdCharSetMapping.GetNextDrawCommand(var aFont : TAdKeyString;
                                                  aText : PAnsiChar) : boolean;
var
  Temp : PScriptNode;
begin
  {start off with the obvious case: there's no script}
  if (FScript = nil) then begin
    Result := false;
    Exit;
  end;
  {we'll definitely return something}
  Result := true;
  {return the data from the top node}
  aFont := PScriptNode(FScript)^.snFont^;
  StrCopy(aText, PScriptNode(FScript)^.snText);
  {unlink the top node}
  Temp := PScriptNode(FScript);
  FScript := Temp^.snNext;
  {free the unlinked top node}
  FreeMem(Temp^.snText, StrLen(Temp^.snText));
  {NOTE: we do NOT free the font name: it's a copy of an allocated
   string in the mapping hash table}
  Temp^.snNext := FScriptFreeList;
  FScriptFreeList := Temp;
end;
{--------}
procedure TAdCharSetMapping.LoadFromFile(const aFileName : string);
var
  Lines     : TStringList;
  ActualLen : integer;
  i         : integer;
  LineInx   : integer;
  Line      : string[255];
  CharSet   : TAdKeyString;
  FontName  : TAdKeyString;
  FromCh    : AnsiChar;
  ToCh      : AnsiChar;
  Glyph     : AnsiChar;
begin
  {clear the hash table, ready for loading}
  Clear;
  {create the stringlist to hold the mapping script}
  Lines := TStringList.Create;
  try
    {load the mapping script}
    Lines.LoadFromFile(aFileName);
    for LineInx := 0 to pred(Lines.Count) do begin
      {get this line}
      Line := Lines[LineInx];
      {remove trailing spaces}
      ActualLen := length(Line);
      for i := ActualLen downto 1 do
        if (Line[i] = ' ') then
          dec(ActualLen)
        else
          Break;
      Line[0] := AnsiChar(ActualLen);
      {only process detail lines}
      if (Line <> '') and (Line[1] = ' ') then begin
        if ProcessCharSetLine(Line, CharSet, FromCh, ToCh, FontName, Glyph) then
          Add(CharSet, FromCh, ToCh, FontName, Glyph);
      end;
    end;
  finally
    Lines.Free;
  end;
end;
{--------}
procedure TAdCharSetMapping.LoadFromRes(aInstance : THandle;
                                  const aResName  : string);
var
  MS        : TMemoryStream;
  ResInfo   : THandle;
  ResHandle : THandle;
  ResNameZ  : PChar;
  Res       : PByteArray;
  i         : integer;
  Sig       : longint;
  ResCount  : longint;
  BytesRead : longint;
  CharSet   : TAdKeyString;
  Font      : TAdKeyString;
  Ch        : AnsiChar;
  Glyph     : AnsiChar;
begin
  {Note: this code has been written to work with all versions of
   Delphi, both 16-bit and 32-bit. Hence it does not make use of any
   of the features available in later compilers, ie, typecasting a
   string to a PChar, or TResourceStream)

  {clear the hash table, ready for loading}
  Clear;
  {get the resource info handle}
  GetMem(ResNameZ, succ(length(aResName)));
  try
    StrPCopy(ResNameZ, aResName);
    ResInfo := FindResource(aInstance, ResNameZ, RT_RCDATA);
  finally
    FreeMem(ResNameZ, succ(length(aResName)));
  end;
  if (ResInfo = 0) then
    Exit;
  {load and lock the resource}
  ResHandle := LoadResource(aInstance, ResInfo);
  if (ResHandle = 0) then
    Exit;
  Res := LockResource(ResHandle);
  if (Res = nil) then begin
    FreeResource(ResHandle);
    Exit;
  end;
  try
    {create a memory stream}
    MS := TMemoryStream.Create;
    try
      {copy the resource to our memory stream}
      MS.Write(Res^, SizeOfResource(aInstance, ResInfo));
      MS.Position := 0;
      {read the header signature, get out if it's not ours}
      BytesRead := MS.Read(Sig, sizeof(Sig));
      if (BytesRead <> sizeof(Sig)) or (Sig <> OurSignature) then
        Exit;
      {read the count of mappings in the resource}
      MS.Read(ResCount, sizeof(ResCount));
      {read that number of mappings and add them to the hash table}
      for i := 0 to pred(ResCount) do begin
        MS.Read(CharSet[0], 1);
        MS.Read(CharSet[1], ord(CharSet[0]));
        MS.Read(Font[0], 1);
        MS.Read(Font[1], ord(Font[0]));
        MS.Read(Ch, 1);
        MS.Read(Glyph, 1);
        Add(CharSet, Ch, Ch, Font, Glyph);
      end;
      {read the footer signature, clear and get out if it's not ours}
      BytesRead := MS.Read(Sig, sizeof(Sig));
      if (BytesRead <> sizeof(Sig)) or (Sig <> OurSignature) then begin
        Clear;
        Exit;
      end;
    finally
      MS.Free;
    end;
  finally
    UnlockResource(ResHandle);
    FreeResource(ResHandle);
  end;
end;
{--------}
procedure TAdCharSetMapping.StoreToBinFile(const aFileName : string);
var
  aFS  : TFileStream;
  i    : integer;
  Node : PCSHashNode;
begin
  {create a file stream}
  aFS := TFileStream.Create(aFileName, fmCreate);
  try
    {write our signature as header}
    aFS.Write(OurSignature, sizeof(OurSignature));
    {write the number of mappings}
    aFS.Write(FCount, sizeof(FCount));
    {write all the mappings}
    for i := 0 to pred(CSHashTableSize) do begin
      Node := FTable[i];
      while (Node <> nil) do begin
        aFS.Write(Node^.csnCharSet^, succ(length(Node^.csnCharSet^)));
        aFS.Write(Node^.csnFont^, succ(length(Node^.csnFont^)));
        aFS.Write(Node^.csnChar, sizeof(AnsiChar));
        aFS.Write(Node^.csnGlyph, sizeof(AnsiChar));
        Node := Node^.csnNext;
      end;
    end;
    {write our signature as footer as a further check on reading}
    aFS.Write(OurSignature, sizeof(OurSignature));
  finally
    aFS.Free;
  end;
end;
{====================================================================}


{===Initialization/finalization======================================}
procedure ADTrmMapDone; far;
begin
  { }
end;
{--------}
initialization
  {$IFDEF Windows}
  AddExitProc(ADTrmMapDone);
  {$ENDIF}
{--------}
{$IFDEF Win32}
finalization
  ADTrmMapDone;
{$ENDIF}
{--------}
end.
