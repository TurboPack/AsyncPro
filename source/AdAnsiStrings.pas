unit AdAnsiStrings;

interface

function Copy(const AStr: AnsiString; AIndex, ACount: Integer): AnsiString;
function Pos(const ASubStr, AStr: Ansistring): Integer;
function StrToInt(const S: AnsiString): Integer;

implementation

uses
  SysUtils,  AnsiStrings;

function Copy(const AStr: AnsiString; AIndex, ACount: Integer): AnsiString;
begin
  Result := AnsiString(System.Copy(string(AStr), AIndex, ACount));
end;

function Pos(const ASubStr, AStr: Ansistring): Integer;
begin
  Result := AnsiStrings.AnsiPos(ASubStr, AStr);
end;

function StrToInt(const S: AnsiString): Integer;
begin
  Result := SysUtils.StrToInt(string(S));
end;             system

end.
