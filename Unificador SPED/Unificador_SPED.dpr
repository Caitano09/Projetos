program Unificador_SPED;

uses
  Vcl.Forms,
  uFrmPrincipal in 'forms\uFrmPrincipal.pas' {frmPrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
