program Project1;

uses
  Vcl.Forms,
  uCadastroJuros in 'Form\uCadastroJuros.pas' {frmCadastroJuros},
  JurosDAO in 'Dao\JurosDAO.pas',
  Juros in 'Classe\Juros.pas',
  TipoJuros in 'Classe\TipoJuros.pas',
  uDMPrincipal in 'Form\uDMPrincipal.pas' {dmPrincipal: TDataModule},
  JurosRN in 'Rn\JurosRN.pas',
  TipoJurosDAO in 'Dao\TipoJurosDAO.pas',
  uPesquisaJuros in 'Form\uPesquisaJuros.pas' {frmPesquisaJuros},
  uCadastroTipoJuros in 'Form\uCadastroTipoJuros.pas' {frmCadastroTipoJuros},
  uPesquisaTipoJuros in 'Form\uPesquisaTipoJuros.pas' {frmPesquisaTipoJuros},
  TipoJurosRN in 'Rn\TipoJurosRN.pas',
  Validar in 'Classe\Validar.pas',
  uPesquisarJurosStringGrid in 'Form\uPesquisarJurosStringGrid.pas' {frmPesquisaJurosStringGrid};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmCadastroJuros, frmCadastroJuros);
  Application.CreateForm(TdmPrincipal, dmPrincipal);
  Application.Run;
end.
