unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls
  ,ShellAPI, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent
  ;

type
  TFrmMain = class(TForm)
    RichLog: TRichEdit;
    btnUpdateWeb: TButton;
    btnClose: TButton;
    NetHTTPClient1: TNetHTTPClient;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnUpdateWebClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateWeb();
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

uses utils;
{$R *.dfm}

procedure TFrmMain.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TFrmMain.btnUpdateWebClick(Sender: TObject);
begin
  UpdateWeb();
end;

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
  var
    myPath : string ;
    result : boolean ;
    LocalFile : string ;
    download : string ;
begin
// ����� ��������� ������� ����
  download := ReadParam('webupdate', 'download', EmptyStr);
  if download = '0' then exit ;
  
  myPath := ReadParam('webupdate', 'update_file', EmptyStr);
  LocalFile := ChangeFileExt(Application.ExeName,'.exe_new');
  result := GetInetFile(myPath, LocalFile) ;
  if result then
    ShellExecute(0, 'open', 'Closer.exe', nil, nil, SW_SHOWNORMAL);
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
  progName: string;
  ver : string ;
begin
  ver := GetSelfVersion ;
  progName := ReadParam('infosoft', 'firstname', EmptyStr);
  btnUpdateWeb.Caption := Format('�������� %s.', [progName]);
  caption := Format('���������� ������������ �����������. ������: %s', [ver]);
  RichLog.Lines.Clear;
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
  Application.ProcessMessages ;
  UpdateWeb();  //����������� �������������
  Application.ProcessMessages ;
end;

procedure TFrmMain.UpdateWeb;
  var
    FileOnNet, LocalFileName, dfile, sfile: string;
    result: boolean;
    FileList: TStringList;
    i: Integer;
begin
  try
    RichLog.Lines.Add('��������� �� ������ ����������.');
    Application.ProcessMessages ;
    FileOnNet := ReadParam('infoweb', 'loadurl', EmptyStr);
    LocalFileName := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'upload\upload.txt';

  if GetInetFile(FileOnNet, LocalFileName) = true then
    begin
      Application.ProcessMessages ;
      RichLog.Lines.Add('������� ���������� �� ����������.');
      Application.ProcessMessages ;
      FileList := TStringList.Create;
      FileList.LoadFromFile(LocalFileName);
      for i := 0 to FileList.Count - 1 do
      begin
        if FileList[i] = '/' then  // ��������� ������ � �������� ��������
        begin
          sfile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) ;
        end
        else if FileList[i] = '/update' then
        begin
          sfile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'update\' ;
        end
        else if FileList[i] = '/report' then
        begin
          sfile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'report\' ;
        end
        else
        begin
          dfile := FileList[i];
          if FileExists(sfile + '~') then deleteFile(sfile + '~');
          if FileExists(sfile) then
            if not RenameFile(sfile, sfile + '~') then
            begin
              RichLog.Lines.Add('�� ������� ������������� ����:' + sfile);
              Application.ProcessMessages ;
            end;
          result := GetInetFile(dfile, sfile + ExtractUrlFileName(FileList[i]));
          if result then
            RichLog.Lines.Add('������ � ������� ����: ' + ExtractUrlFileName(FileList[i]))
          else RichLog.Lines.Add('�� ������� ������� ��� �������� ���� : ' + ExtractUrlFileName(FileList[i])) ;
          Application.ProcessMessages ;
        end;
      end;
    end
    else
    begin
      RichLog.Lines.Add('�� ������� �������� ���������� �� ����������.');
      Application.ProcessMessages ;
    end;

    FileList.Free;
    if result then
      RichLog.Lines.Add('���������� ��������� �������.')
    else
      RichLog.Lines.Add('���������� ��������� c ��������.');
    Application.ProcessMessages ;
  except on E:Exception do

  end;
end;

end.
