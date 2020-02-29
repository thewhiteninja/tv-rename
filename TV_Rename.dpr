program TV_Rename;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1} ,
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Tablet Light');
  Application.Title := 'TV Rename';
  Application.CreateForm(TForm1, Form1);
  Application.Run;

end.
