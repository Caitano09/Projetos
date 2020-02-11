program Project3;













uses
  Vcl.Forms,
  TipoProduto in 'Classe\TipoProduto.pas',
  Dados in 'Dao\Dados.pas',
  Controls in 'Rn\Controls.pas',
  uCadastro in 'Form\uCadastro.pas' {frmCadastro},
  uDm in 'Form\uDm.pas' {DataModule1: TDataModule},
  uPesquisa in 'Form\uPesquisa.pas' {frmPesquisa},
  uRelatorio in 'Form\uRelatorio.pas' {frmRelatorio},
  uBuscar in 'Form\uBuscar.pas' {frmBuscar},
  uImpressao in 'Form\uImpressao.pas' {Form1},
  uImpressao2 in 'Form\uImpressao2.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmCadastro, frmCadastro);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TfrmPesquisa, frmPesquisa);
  Application.CreateForm(TfrmRelatorio, frmRelatorio);
  Application.CreateForm(TfrmBuscar, frmBuscar);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
