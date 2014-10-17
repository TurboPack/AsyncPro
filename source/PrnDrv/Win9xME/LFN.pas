{
Notes:
  This unit provides Pascal routines that access most of the
  functions of the Win32 API for long file names. It can be used from
  real mode and protected mode DOS applications in a Win95 DOS box, or
  from 16-bit Windows applications running within Win95. Requires
  Borland Pascal 7.0 or Delphi to compile.

  Error codes are returned as the function result of each routine. You
  must ensure that the result is zero before proceeding in your
  application. If you're writing an application that runs under
  previous versions of DOS or Windows, you need to fall back to the
  older DOS services when the Win32 services fail. "Unsupported
  function" is indicated by an error code whose value is greater than
  255.

  LFN supports complete filenames up to 254 characters max (not
  counting length byte or null terminator, but counting drive letter
  and path). Win95 actually allows names up to 259 characters.

  LFNParamCount and LFNParamStr work like the standard runtime library
  functions ParamCount and ParamStr, except that they honor quotes (")
  to delimit parameters that contain spaces. They search only the 128
  bytes of command line data in the prefix segment, not the additional
  overflow information stored in the environment.

  The comment after each routine in the interface section below
  provides information about what it does. Many of the functions
  parallel those from the Turbo Pascal runtime library and work as
  much as possible like the short filename RTL versions.

  The example programs EXLFN.PAS, EXLFNP.PAS, and SDIR.PAS show how to
  use many of the functions.

  See a Win32 API manual for additional details about each function.

  Routines that look like they could be "assembler" cannot be because
  they need the compiler to make a copy of the strings passed to them,
  to ensure space for null-terminating the string.

  The "stc" before each int $21 is needed to ensure the operating
  system returns with carry set when an unsupported function call is
  made.

  Kim Kokkonen, TurboPower Software Co.
  CompuServe 76004,2611

  May be distributed freely, but not sold as a programmer's tool.

  Version 1.0, 10/3/95
}

{$R-,S-,I-,F-}

unit LFN;
  {-Access Long File Name functions of Win95}

interface

const
  {bit flags for the FileSysFlags parameter of LFNGetVolumeInfo}
  FsCaseSensitive            = $0001;
  FsCaseIsPreserved          = $0002;
  FsUnicodeOnDisk            = $0004;
  FsLfnApis                  = $4000;
  FsVolumeCompressed         = $8000;

const
  {bit flags for the ModeAndFlags parameter of LFNOpenFile}
  OpenAccessReadOnly         = $0000;
  OpenAccessWriteOnly        = $0001;
  OpenAccessReadWrite        = $0002;
  OpenAcessRoNoModLastAccess = $0004;

  OpenShareCompatible        = $0000;
  OpenShareDenyReadWrite     = $0010;
  OpenShareDenyWrite         = $0020;
  OpenShareDenyRead          = $0030;
  OpenShareDenyNone          = $0040;

  OpenFlagsNoInherit         = $0080;
  OpenFlagsNoBuffering       = $0100;
  OpenFlagsNoCompress        = $0200;
  OpenFlagsAliasHint         = $0400;
  OpenFlagsNoCritErr         = $2000;
  OpenFlagsCommit            = $4000;

  {bit flags for the Action parameter of LFNOpenFile}
  FileOpen                   = $0001;
  FileTruncate               = $0002;
  FileCreate                 = $0010;

type
  {record type returned by LFNFindFirst and LFNFindNext}
  TLFNSearchRec =
  record
    Attr : LongInt;          {file attribute}
    CreationTime : LongInt;  {DOS format creation time}
    HCreationTime : LongInt; {unused in DOS format}
    AccessTime : LongInt;    {DOS format access time}
    HAccessTime : LongInt;   {unused in DOS format}
    WriteTime : LongInt;     {DOS format write time}
    HWriteTime : LongInt;    {unused in DOS format}
    HSize : LongInt;         {high long of the size for >4GB files}
    Size : LongInt;          {low long of the size}
    Reserved0 : LongInt;     {unused at present}
    Reserved1 : LongInt;     {"}
    Name : string;           {the long file name}
    NameRem : array[0..3] of char; {possibly the last of a 260 char long path}
    AltName : string[13];    {the traditional short file name}
    ConversionCode : Word;   {Unicode to OEM conversion flags}
                             {0 = ok, 1 = Name bad, 2 = AltName bad}
    Handle : Word;           {search handle}
  end;

type
  {enumerated type used by LFNGenerateShortName}
  TCharType = (BcsWansi, BcsOem, BcsUnicode);


  function LFNOpenFile(FileName : string;
                       ModeAndFlags, Attr, Action : Word;
                       var ActionTaken : Word; var FHandle : Word) : Integer;
    {-Open or create a file, returning a handle}

  function LFNDeleteFile(Path : string;
                         WildCardsOk : Boolean;
                         ReqdAttr : Byte; Attr : Byte) : Integer;
    {-Delete a file or group of files}

  function LFNGenerateShortName(LongName : string; var ShortName : string;
                                LongCharSet, ShortCharSet : TCharType;
                                FileOrDir : Boolean) : Integer;
    {-Generate short alias from long file name. No path allowed in LongName.
      FileOrDir = True -> 8.3 format; FileOrDir = False -> 11 char format}

  function LFNGetAccessFTime(FHandle : Word; var Time : LongInt) : Integer;
    {-Get last access date of an open file}

  function LFNSetAccessFTime(FHandle : Word; Time : LongInt) : Integer;
    {-Set last access date of an open file}

  function LFNGetCreationFTime(FHandle : Word;
                               var Time : LongInt; var Ms10 : Word) : Integer;
    {-Get creation date and time of an open file}

  function LFNSetCreationFTime(FHandle : Word;
                               Time : LongInt; Ms10 : Word) : Integer;
    {-Set creation date and time of an open file}

  function LFNMkDir(DirName : string) : Integer;
    {-Make a new directory}

  function LFNRmDir(DirName : string) : Integer;
    {-Remove a directory}

  function LFNChDir(DirName : string) : Integer;
    {-Change to a different directory}

  function LFNGetDir(Drive : Byte; var DirName : string) : Integer;
    {-Get the current directory of a given drive. 0=default, 1=A, etc.}

  function LFNGetFAttr(FileName : string; var Attr : Word) : Integer;
    {-Get file attributes of a closed file}

  function LFNSetFAttr(FileName : string; Attr : Word) : Integer;
    {-Set file attributes of a closed file}

  function LFNFindFirst(Path : string;
                        ReqdAttr : Byte; Attr : Byte;
                        var SR : TLFNSearchRec) : Integer;
    {-Find first file matching given conditions}

  function LFNFindNext(var SR : TLFNSearchRec) : Integer;
    {-Find next file matching given conditions}

  procedure LFNFindClose(var SR : TLFNSearchRec);
    {-Free a search handle}

  function LFNRename(OldName, NewName : string) : Integer;
    {-Rename a closed file}

  function LFNGetFullPath(ExpandSubst : Boolean;
                          const SrcName : string;
                          var DestName : string) : Integer;
    {-Expand a pathname to a full path, using short names, uppercase}

  function LFNGetShortPath(ExpandSubst : Boolean;
                           const SrcName : string;
                           var DestName : string) : Integer;
    {-Expand a pathname to a full path, using short names, retained case}

  function LFNGetLongPath(ExpandSubst : Boolean;
                          const SrcName : string;
                          var DestName : string) : Integer;
    {-Expand a pathname to a full path, using long names, retained case}

  function LFNGetVolumeInfo(RootName : string;
                            var FileSysName : string;
                            var FileSysFlags : Word;
                            var MaxNameLen : Word;
                            var MaxPathLen : Word) : Integer;
    {-Get LFN information about a given drive}

  function LFNParamCount : Word;
    {-Return number of parameters on command line}

  function LFNParamStr(Index : Word) : string;
    {-Return parameter number Index from command line}

  {=========================================================================}

implementation

  function LFNOpenFile(FileName : string;
                       ModeAndFlags, Attr, Action : Word;
                       var ActionTaken : Word; var FHandle : Word) : Integer;
  begin
    asm
      push ds
      push ss
      pop ds
      lea si,FileName
      mov bl,[si]
      xor bh,bh              {bx = length}
      inc si                 {si points to first actual character}
      mov byte ptr [bx+si],0 {null-terminate}
      mov ax,$716C
      mov bx,ModeAndFlags
      mov cx,Attr
      mov dx,Action
      xor di,di
      stc
      int $21
      mov bx,ax              {save possible error code}
      jc @Error
      xor bx,bx
      lds si,ActionTaken
      mov [si],cx
      lds si,FHandle
      mov [si],ax
@Error:
      pop ds
      mov @Result,bx
    end;
  end;

  function LFNDeleteFile(Path : string; WildCardsOk : Boolean;
                         ReqdAttr : Byte; Attr : Byte) : Integer;
  begin
    asm
      push ds
      push ss
      pop ds
      lea si,Path
      mov bl,[si]
      xor bh,bh              {bx = length}
      inc si                 {si points to first actual character}
      mov byte ptr [bx+si],0 {null-terminate}
      mov dx,si
      mov ch,ReqdAttr
      mov cl,Attr
      mov al,WildCardsOk
      xor ah,ah
      mov si,ax
      mov ax,$7141
      stc
      int $21
      jc @Error
      xor ax,ax              {clear error code}
@Error:
      pop ds
      mov @Result,ax
    end;
  end;

  function LFNGenerateShortName(LongName : string; var ShortName : string;
                                LongCharSet, ShortCharSet : TCharType;
                                FileOrDir : Boolean) : Integer;
  begin
    asm
      push ds
      push ss
      pop ds
      lea si,LongName
      mov bl,[si]
      xor bh,bh              {bx = length}
      inc si                 {si points to first actual character}
      mov byte ptr [bx+si],0 {null-terminate}
      les di,ShortName
      inc di
      mov dh,FileOrDir
      mov dl,ShortCharSet
      shl dl,1
      shl dl,1
      shl dl,1
      shl dl,1
      or dl,LongCharSet
      mov ax,$71A8
      stc
      int $21
      jc @Error
      xor ax,ax
      les di,ShortName       {find and store length}
      mov si,di
      inc di
      cld
      mov cx,255
      repne scasb
      sub di,si
      mov bx,di
      dec bx
      dec bx
      mov es:[si],bl
@Error:
      pop ds
      mov @Result,ax
    end;
  end;

  function LFNGetAccessFTime(FHandle : Word; var Time : LongInt) : Integer;
  assembler;
  asm
    mov ax,$5704
    mov bx,FHandle
    stc
    int $21
    jc @Error
    xor ax,ax
    les di,Time
    mov es:[di],cx   {time always zero currently}
    mov es:[di+2],dx {date}
@Error:
  end;

  function LFNSetAccessFTime(FHandle : Word; Time : LongInt) : Integer;
  assembler;
  asm
    mov ax,$5705
    mov bx,FHandle
    mov cx,Word ptr Time   {time always zero currently}
    mov dx,Word ptr Time+2
    stc
    int $21
    jc @Error
    xor ax,ax
@Error:
  end;

  function LFNGetCreationFTime(FHandle : Word;
                               var Time : LongInt; var Ms10 : Word) : Integer;
  assembler;
  asm
    mov ax,$5706
    mov bx,FHandle
    stc
    int $21
    jc @Error
    xor ax,ax
    les di,Time
    mov es:[di],cx
    mov es:[di+2],dx {date}
    les di,Ms10
    mov es:[di],si
@Error:
  end;

  function LFNSetCreationFTime(FHandle : Word;
                               Time : LongInt; Ms10 : Word) : Integer;
  assembler;
  asm
    mov ax,$5707
    mov bx,FHandle
    mov si,Ms10
    mov cx,Word ptr Time
    mov dx,Word ptr Time+2
    stc
    int $21
    jc @Error
    xor ax,ax
@Error:
  end;

  function LFNMkDir(DirName : string) : Integer;
  begin
    asm
      push ds
      push ss
      pop ds
      lea si,DirName
      mov bl,[si]
      xor bh,bh              {bx = length}
      inc si                 {si points to first actual character}
      mov byte ptr [bx+si],0 {null-terminate}
      mov dx,si
      mov ax,$7139
      stc
      int $21
      jc @Error
      xor ax,ax
@Error:
      pop ds
      mov @Result,ax
    end;
  end;

  function LFNRmDir(DirName : string) : Integer;
  begin
    asm
      push ds
      push ss
      pop ds
      lea si,DirName
      mov bl,[si]
      xor bh,bh              {bx = length}
      inc si                 {si points to first actual character}
      mov byte ptr [bx+si],0 {null-terminate}
      mov dx,si
      mov ax,$713A
      stc
      int $21
      jc @Error
      xor ax,ax
@Error:
      pop ds
      mov @Result,ax
    end;
  end;

  function LFNChDir(DirName : string) : Integer;
  begin
    asm
      push ds
      push ss
      pop ds
      lea si,DirName
      mov bl,[si]
      xor bh,bh              {bx = length}
      inc si                 {si points to first actual character}
      mov byte ptr [bx+si],0 {null-terminate}
      mov dx,si
      mov ax,$713B
      stc
      int $21
      jc @Error
      xor ax,ax
@Error:
      pop ds
      mov @Result,ax
    end;
  end;

  function LFNGetFAttr(FileName : string; var Attr : Word) : Integer;
  begin
    asm
      push ds
      push ss
      pop ds
      lea si,FileName
      mov bl,[si]
      xor bh,bh              {bx = length}
      inc si                 {si points to first actual character}
      mov byte ptr [bx+si],0 {null-terminate}
      mov dx,si
      mov ax,$7143
      mov bl,0
      stc
      int $21
      jc @Error
      xor ax,ax
      les di,Attr
      mov es:[di],cx
@Error:
      pop ds
      mov @Result,ax
    end;
  end;

  function LFNSetFAttr(FileName : string; Attr : Word) : Integer;
  begin
    asm
      push ds
      push ss
      pop ds
      lea si,FileName
      mov bl,[si]
      xor bh,bh              {bx = length}
      inc si                 {si points to first actual character}
      mov byte ptr [bx+si],0 {null-terminate}
      mov dx,si
      mov ax,$7143
      mov bl,1
      mov cx,Attr
      stc
      int $21
      jc @Error
      xor ax,ax
@Error:
      pop ds
      mov @Result,ax
    end;
  end;

  function LFNGetDir(Drive : Byte; var DirName : string) : Integer;
  assembler;
  asm
    push ds
    mov dl,Drive
    lds si,DirName
    mov di,si               {save start of string}
    inc si                  {leave space for length byte}
    mov al,dl
    dec al                  {al=0 -> 'A', etc.}
    or  dl,dl
    jnz @DriveKnown
    mov ah,$19              {get default drive}
    int $21
@DriveKnown:
    add al,'A'
    cld
    mov [si],al             {store drive letter}
    inc si
    mov Word ptr [si],'\:'  {store root directory}
    inc si
    inc si
    mov byte ptr [si],0     {store null just in case}
    mov ax,$7147
    stc
    int $21                 {get current directory}
    jc @Error
    xor ax,ax
@Error:
    mov si,di               {save start of string again}
    push ds
    pop es
    inc di
    mov cx,255
    repne scasb             {look for null}
    sub di,si
    mov bx,di
    dec bx
    dec bx
    mov [si],bl             {store length}
    pop ds
  end;

  function AsciiLen(const S : string; MaxLen : Word) : Word;
  var
    I : Word;
  begin
    I := 1;
    while S[I] <> #0 do
      inc(I);
    dec(I);
    if I > MaxLen then
      I := MaxLen;
    AsciiLen := I;
  end;

  procedure LFNFixSearchRec(var SR : TLFNSearchRec);
  begin
    move(SR.Name[0], SR.Name[1], 255);
    Byte(SR.Name[0]) := AsciiLen(SR.Name, 255);
    move(SR.AltName[0], SR.AltName[1], 13);
    Byte(SR.AltName[0]) := AsciiLen(SR.AltName, 13);
  end;

  function LFNFindFirst(Path : string;
                        ReqdAttr : Byte; Attr : Byte;
                        var SR : TLFNSearchRec) : Integer;
  begin
    asm
      push ds
      push ss
      pop ds
      lea si,Path
      mov bl,[si]
      xor bh,bh              {bx = length}
      inc si                 {si points to first actual character}
      mov byte ptr [bx+si],0 {null-terminate}
      mov dx,si
      mov ch,ReqdAttr
      mov cl,Attr
      mov ax,$714E
      les di,SR
      mov si,1               {MS-DOS format for date and time}
      stc
      int $21
      mov bx,ax              {save error code}
      jc @Error
      xor bx,bx              {clear error code}
      mov TLFNSearchRec(es:[di]).ConversionCode,cx {Unicode conversion status}
      mov TLFNSearchRec(es:[di]).Handle,ax {search handle}
      pop ds
      push bx
      push es
      push di
      call LFNFixSearchRec
      pop bx
      push ds
@Error:
      pop ds
      mov @Result,bx
    end;
  end;

  function LFNFindNext(var SR : TLFNSearchRec) : Integer; assembler;
  asm
    les di,SR
    mov byte ptr TLFNSearchRec(es:[di]).AltName,0
    mov bx,TLFNSearchRec(es:[di]).Handle
    mov si,1              {MS-DOS format for date and time}
    mov ax,$714F
    stc
    int $21
    jc @Error
    xor ax,ax
    mov TLFNSearchRec(es:[di]).ConversionCode,cx {Unicode conversion status}
    push ax
    push es
    push di
    call LFNFixSearchRec
    pop ax
@Error:
  end;

  procedure LFNFindClose(var SR : TLFNSearchRec); assembler;
  asm
    les di,SR
    mov bx,TLFNSearchRec(es:[di]).Handle
    mov ax,$71A1
    stc
    int $21
    jc @Error
    xor ax,ax
@Error:
  end;

  function LFNRename(OldName, NewName : string) : Integer;
  begin
    asm
      push ds
      push ss
      pop ds
      lea si,OldName
      mov bl,[si]
      xor bh,bh              {bx = length}
      inc si                 {si points to first actual character}
      mov byte ptr [bx+si],0 {null-terminate}
      mov dx,si
      push ss
      pop es
      lea di,NewName
      mov bl,es:[di]         {bx = length}
      inc di                 {di points to first actual character}
      mov byte ptr es:[bx+di],0 {null-terminate}
      mov ax,$7156
      stc
      int $21
      jc @Error
      xor ax,ax
@Error:
      pop ds
      mov @Result,ax
    end;
  end;

  function LFNGetPath(ExpandSubst : Boolean; FullPathMode : Byte;
                      SrcName : string; var DestName : string) : Integer;
  begin
    asm
      push ds
      mov cl,FullPathMode
      mov ch,ExpandSubst
      or ch,ch
      jz @HaveSubst
      mov ch,$80
  @HaveSubst:
      push ss
      pop ds
      lea si,SrcName
      mov bl,[si]
      xor bh,bh              {bx = length}
      inc si                 {si points to first actual character}
      mov byte ptr [bx+si],0 {null-terminate}
      les di,DestName
      inc di                 {di points to first actual character}
      mov ax,$7160
      stc
      int $21
      jc @Error
      xor ax,ax
      les di,DestName        {find and store length}
      mov si,di
      inc di
      cld
      mov cx,255
      repne scasb
      sub di,si
      mov bx,di
      dec bx
      dec bx
      mov es:[si],bl
@Error:
      pop ds
      mov @Result,ax
    end;
  end;

  function LFNGetFullPath(ExpandSubst : Boolean;
                          const SrcName : string;
                          var DestName : string) : Integer;
  begin
    LFNGetFullPath := LFNGetPath(ExpandSubst, 0, SrcName, DestName);
  end;

  function LFNGetShortPath(ExpandSubst : Boolean;
                           const SrcName : string;
                           var DestName : string) : Integer;
  begin
    LFNGetShortPath := LFNGetPath(ExpandSubst, 1, SrcName, DestName);
  end;

  function LFNGetLongPath(ExpandSubst : Boolean;
                          const SrcName : string;
                          var DestName : string) : Integer;
  begin
    LFNGetLongPath := LFNGetPath(ExpandSubst, 2, SrcName, DestName);
  end;

  function LFNGetVolumeInfo(RootName : string;
                            var FileSysName : string;
                            var FileSysFlags : Word;
                            var MaxNameLen : Word;
                            var MaxPathLen : Word) : Integer;
  begin
    asm
      push ds
      push ss
      pop ds
      lea si,RootName
      mov bl,[si]
      xor bh,bh              {bx = length}
      inc si                 {si points to first actual character}
      mov byte ptr [bx+si],0 {null-terminate}
      mov dx,si
      les di,FileSysName
      inc di
      mov cx,256
      mov ax,$71A0
      stc
      int $21
      jc @Error
      xor ax,ax
      lds si,FileSysFlags
      mov [si],bx
      lds si,MaxNameLen
      mov [si],cx
      lds si,MaxPathLen
      mov [si],dx
      les di,FileSysName
      mov si,di
      inc di
      cld
      mov cx,255
      repne scasb
      sub di,si
      mov bx,di
      dec bx
      dec bx
      mov bx,di
      mov es:[si],bl
@Error:
      pop ds
      mov @Result,ax
    end;
  end;

  function LFNParamCount : Word;
  var
    PS : ^string;
    EPos : Word;
    SPos : Word;
    Index : Word;
    InQuote : Boolean;
  begin
    Index := 0;

    InQuote := False;
    PS := Ptr(PrefixSeg, $80);

    for EPos := 1 to Length(PS^)+1 do begin
      case PS^[EPos] of
        ' ', ^M :
          if InQuote then begin
            if EPos = SPos then
              inc(Index);
          end else
            SPos := EPos+1;
        '"' :
          begin
            if InQuote then begin
              InQuote := False;
              if EPos = SPos then
                inc(Index);
            end else
              InQuote := True;
            SPos := EPos+1;
          end;
      else
        if EPos = SPos then
          inc(Index);
      end;
    end;

    LFNParamCount := Index;
  end;

  function LFNParamStr(Index : Word) : string;
  label
    Found;
  var
    PS : ^string;
    EPos : Word;
    SPos : Word;
    InQuote : Boolean;
  begin
    if Index = 0 then begin
      LFNParamStr := ParamStr(0);
      Exit;
    end;

    LFNParamStr := '';
    InQuote := False;
    PS := Ptr(PrefixSeg, $80);

    for EPos := 1 to Length(PS^)+1 do begin
      case PS^[EPos] of
        ' ', ^M :
          if InQuote then begin
            if EPos = SPos then
              dec(Index);
          end else if Index = 0 then
            goto Found
          else
            SPos := EPos+1;
        '"' :
          begin
            if InQuote then begin
              InQuote := False;
              if EPos = SPos then
                dec(Index);
            end else
              InQuote := True;
            if Index = 0 then
              goto Found;
            SPos := EPos+1;
          end;
      else
        if EPos = SPos then
          dec(Index);
      end;
    end;

    if Index = 0 then
Found:
      LFNParamStr := copy(PS^, SPos, EPos-SPos);
  end;

end.
