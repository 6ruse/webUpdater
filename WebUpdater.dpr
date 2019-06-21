program WebUpdater;

uses
  Forms,
  uMain in 'uMain.pas' {FrmMain},
  utils in 'utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'WebUpdater';
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
