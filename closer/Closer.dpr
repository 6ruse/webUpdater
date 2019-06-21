program Closer;

{$APPTYPE CONSOLE}

uses
  SysUtils;

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
    sleep(999);

    if FileExists('WebUpdater.exe_new') then
    begin
      DeleteFile('WebUpdater.exe');
      sleep(999);
      RenameFile('WebUpdater.exe_new', 'WebUpdater.exe');
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
