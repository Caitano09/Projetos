program DriveThrought;

uses
  Vcl.Forms,
  uPrincipal in 'forms\uPrincipal.pas' {frmPrincipal},
  DriveThroughDAO in 'dao\DriveThroughDAO.pas',
  Usuario in 'classe\Usuario.pas',
  UsuarioDAO in 'dao\UsuarioDAO.pas',
  uSenha in 'forms\uSenha.pas' {frmSenha},
  UsuarioRN in 'rn\UsuarioRN.pas',
  uMsnLogin in 'forms\uMsnLogin.pas' {frmMsn_Login},
  Data in 'classe\Data.pas',
  PedidoRN in 'rn\PedidoRN.pas',
  uDMPrincipal in 'forms\uDMPrincipal.pas' {DMPrincipal: TDataModule},
  Validar in 'classe\Validar.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDMPrincipal, DMPrincipal);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
