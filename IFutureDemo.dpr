program IFutureDemo;

{$R *.dres}

uses
  Vcl.Forms,
  Main.View in 'Main.View.pas' {MainView},
  API.Future in 'API\API.Future.pas',
  API.ResData in 'API\Res\API.ResData.pas',
  API.Utils in 'API\API.Utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainView, MainView);
  Application.Run;
end.
