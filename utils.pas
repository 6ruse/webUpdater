unit utils;

interface
uses Classes, SysUtils, Forms, Windows, IniFiles, Variants, Graphics, Shlobj, Wininet
  ,System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent
;

function ReadParam(const Section: string; const Ident: string; Default: string = ''): string;
function GetInetFile(const fileURL, FileName: string): boolean;
function ExtractUrlFileName(const AUrl: string): string;
function GetSelfVersion: String;//получить версию

implementation

function ReadParam(const Section: string; const Ident: string; Default: string = ''): string;
var Ini: TIniFile;
begin
  Ini := TIniFile.Create(ChangeFileExt(Application.ExeName,'.cfg'));
  Result := Ini.ReadString(Section, Ident, Default);
  Ini.Free;
end;

function GetInetFile(const fileURL, FileName: string): boolean;
var
  LResponse: IHTTPResponse;
  LStream: TFileStream;
  LHttpClient: THTTPClient;
begin
  Result := False;
  LHttpClient := THTTPClient.Create;
  try
    LStream := TFileStream.Create(FileName, fmOpenReadWrite or fmCreate);
    try
      LResponse := LHttpClient.Get(fileURL, LStream);
    finally
      LStream.Free;
    end;
  finally
    LHttpClient.Free;
  end;
  Result := true ;
end;

function ExtractUrlFileName(const AUrl: string): string;
  var
    i: Integer;
begin
  i := LastDelimiter('/', AUrl);
  Result := Copy(AUrl, i + 1, Length(AUrl) - (i));
end;

function GetSelfVersion: String;
var pVer: ^VS_FIXEDFILEINFO;
    Buff: Pointer;
    iVer:  DWORD;
    i: Integer;
    VerStr: String;
begin
 iVer:=FindResource(0,'#1',RT_VERSION);
 if iVer=0 then
   begin
     //ShowMessage ('SYSTEM FALURE : Version info not found !');
     Result:='<Unknown>';
     Exit;
   end;

 Buff:=Pointer(LoadResource(0,iVer));
 pVer:=nil;
 for i:=0 to (WORD(Buff^) div 4)-1 do
   begin
     if DWORD(Buff^)=$FEEF04BD then
       begin
         pVer:=Buff;
         Break;
       end;
     Buff:=Ptr(DWORD(Buff)+4);
   end;
 if pVer^.dwSignature<>$FEEF04BD then
   begin
     //ShowMessage ('Version info not found.')
     Result:='<Unknown>';
   end
 else
   begin
     VerStr:=IntToStr((pVer^.dwProductVersionMS shr $10) and $FFFF);
     VerStr:=VerStr+'.'+IntToStr(pVer^.dwProductVersionMS and $FFFF);
     VerStr:=VerStr+'.'+IntToStr((pVer^.dwProductVersionLS shr $10) and $FFFF);
     VerStr:=VerStr+'.'+IntToStr(pVer^.dwProductVersionLS and $FFFF);
     Result:=VerStr;
   end;
end;

end.
