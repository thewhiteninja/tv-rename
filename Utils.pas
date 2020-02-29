unit Utils;

interface

uses Windows, Messages, Classes, Forms, Dialogs, SysUtils, StrUtils, ShlObj, ShellApi, System.UITypes;

procedure ConvertFileToOEM(const FileName: string);
function isDigit(c: char): Boolean;
function isNumber(s: string): Boolean;
procedure log(s : string);
function leadingZero(n : string):string;
function filterName(name : string):string;
procedure about;
function GetTempDir: string;
function SpecialFolder(Folder: Integer): String;
function ChooseFolder:string;

implementation

uses Unit1;

function SpecialFolder(Folder: Integer): String;
var
  SFolder : pItemIDList;
  SpecialPath : Array[0..MAX_PATH] Of Char;
begin
  SHGetSpecialFolderLocation(Form1.Handle, Folder, SFolder);
  SHGetPathFromIDList(SFolder, SpecialPath);
  Result := StrPas(SpecialPath);
end;

function BrowseDialogCallBack(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): integer stdcall;
var R: TRect;
    tp: TPoint;
begin
  if uMsg = BFFM_INITIALIZED then
  begin
        GetWindowRect(Wnd,R);
        tp.x:=(screen.Width div 2)-(R.Right-R.Left) div 2;
        tp.y:=(screen.Height div 2)-(R.Bottom-R.Top) div 2;
        SetWindowPos(Wnd,HWND_TOP,tp.x,tp.y,R.Right-R.Left,R.Bottom-R.Top,SWP_SHOWWINDOW);
  end;

  Result := 0;
end;

function ChooseFolder:string;
var
  BI: TBrowseInfo;
  PIL: PItemIDList;
  PathSelection : array[0..MAX_PATH] of Char;
begin
    Result := '';
    FillChar(BI,SizeOf(BrowseInfo),#0);
    BI.hwndOwner      := Form1.Handle;
    BI.pszDisplayName := @PathSelection[0];
    BI.lpszTitle      := 'Choose a directory:';
    BI.ulFlags        := BIF_RETURNONLYFSDIRS or BIF_EDITBOX or $40;//BIF_BROWSEINCLUDEFILES;// ce dernier inclue dossiers et fichiers
    BI.lpfn := BrowseDialogCallBack;
    PIL := SHBrowseForFolder(BI);
    if Assigned(PIL) then
      if SHGetPathFromIDList(PIL, PathSelection) then
        Result := string(PathSelection);
end;


function filterName(name : string):string;
begin
    name := trim(name);
    name := ReplaceText(name, '&#039;', '''');
    name := ReplaceText(name, '&amp;#039;', '''');
    name := ReplaceText(name, '/', '-');
    name := ReplaceText(name, '\\', '-');
    name := ReplaceText(name, '&amp;', '&');
    name := ReplaceText(name, ':', '-');
    name := ReplaceText(name, '?', '');
    name := ReplaceText(name, '(1/2)', '- 1st part');
    name := ReplaceText(name, '(2/2)', '- 2nd part');
    name := ReplaceText(name, '(3/2)', '- 3rd part');
    name := ReplaceText(name, ' (2005)', '');
    Result := name;
end;

function GetTempDir: string;
var
  Buffer: array[0..MAX_PATH] of Char;
begin
  GetTempPath(SizeOf(Buffer) - 1, Buffer);
  Result := IncludeTrailingPathDelimiter(StrPas(Buffer));
end;

function leadingZero(n : string):string;
begin
    if ((isNumber(n)) and (Length(n)=1)) then Result := '0' + n
    else Result := n;
end;

procedure log(s : string);
var t : string;
begin
    DateTimeToString(t, 'hh:nn:ss.zzz', now);
    Form1.Memo1.Lines.Add('[' + t + '] - ' + s);
end;

procedure ConvertFileToOEM(const FileName: string);
var
  ms: TMemoryStream;
begin
  ms := TMemoryStream.Create;
  try
    ms.LoadFromFile(FileName);
    ms.Position := 0;
    CharToOemBuffA(ms.Memory, ms.Memory, ms.Size);
    ms.Position := 0;
    ms.SaveToFile(FileName);
  finally
    ms.Free;
  end;
end;

function isDigit(c: char): Boolean;
begin
    result := ((ord(c) >= 48) and (ord(c) <= 57));
end;

function isNumber(s: string): Boolean;
var
    i: Integer;
begin
    i := 1;
    while ((i <= Length(s)) and isDigit(s[i])) do
        i := i + 1;
    Result := (i > Length(s));
end;

procedure about;
begin
    MessageDlg('TV Rename'+#13#10+'Coded By JcConvenant', mtInformation, [mbOK], 0);
end;


end.
