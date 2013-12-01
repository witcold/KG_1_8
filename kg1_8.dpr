program kg1_8;

uses
  Forms,
  UfmMain in 'UfmMain.pas' {fmMain},
  UStack in 'UStack.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
