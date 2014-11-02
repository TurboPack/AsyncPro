unit AdAnsiStrings;

interface

function Copy(const AStr: AnsiString; AIndex, ACount: Integer): AnsiString;
function IntToStr(Value: Integer): AnsiString; overload;
function Pos(const ASubStr, AStr: AnsiString): Integer;
function StrToInt(const S: AnsiString): Integer;

implementation

uses
  SysUtils,  AnsiStrings;

function Copy(const AStr: AnsiString; AIndex, ACount: Integer): AnsiString;
begin
  Result := AnsiString(System.Copy(string(AStr), AIndex, ACount));
end;

function IntToStr(Value: Integer): AnsiString;
begin
  Result := AnsiString(SysUtils.IntToStr(Value));
end;

function Pos(const ASubStr, AStr: AnsiString): Integer;
begin
  Result := AnsiStrings.AnsiPos(ASubStr, AStr);
end;

function StrToInt(const S: AnsiString): Integer;
begin
  Result := SysUtils.StrToInt(string(S));
end;

end.
