unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Menus,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinOffice2016Colorful,
  dxSkinOffice2016Dark, dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic,
  dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringTime, dxSkinStardust,
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, StdCtrls, cxButtons, ComCtrls
  ,ShellAPI
  ;

type
  TFrmMain = class(TForm)
    RichLog: TRichEdit;
    btnClose: TcxButton;
    btnUpdateWeb: TcxButton;
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
// перед закрытием обновим себя
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
  btnUpdateWeb.Caption := Format('Обновить %s.', [progName]);
  caption := Format('Обновление программного обеспечения. Версия: %s', [ver]);
  RichLog.Lines.Clear;
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
  UpdateWeb();  //обновляемся автоматически

end;

procedure TFrmMain.UpdateWeb;
var
  FileOnNet, LocalFileName, dfile, sfile: string;
  result: boolean;
  FileList: TStringList;
  i: Integer;
//  FileName : string ;
begin
  // обновить программное обеспечение
  try
    result := true;
    btnUpdateWeb.Enabled := false ;
    FileOnNet := ReadParam('infoweb', 'loadurl', EmptyStr);
    LocalFileName := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'upload\upload.txt';

    if FileExists(LocalFileName) then
      DeleteFile(LocalFileName);

    RichLog.Lines.Add('Обращение на сервер обновлений.');
    if GetInetFile(FileOnNet, LocalFileName) = true then
    begin
      RichLog.Lines.Add('Получаю информацию об обновлении.');
      FileList := TStringList.Create;
      FileList.LoadFromFile(LocalFileName);
      for i := 0 to FileList.Count - 1 do
      begin
        if FileList[i] = '/' then  // обновляем данные в основном каталоге
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
  //        sfile := sfile + ExtractUrlFileName(FileList[i]);

          if FileExists(sfile + '~') then deleteFile(sfile + '~');
          if FileExists(sfile) then
            if not RenameFile(sfile, sfile + '~') then
              RichLog.Lines.Add('Не удалось переименовать файл:' + sfile);
          result := GetInetFile(dfile, sfile + ExtractUrlFileName(FileList[i]));
        end;
      end;
    end
    else
      RichLog.Lines.Add('Не удалось получить информацию об обновлении.');

    FileList.Free;
    if result then
      RichLog.Lines.Add('Обновление завершено успешно.')
    else
      RichLog.Lines.Add('Обновление завершено c ошибками.');
  except on E:Exception do

  end;
end;

end.
