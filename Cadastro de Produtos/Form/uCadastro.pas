unit uCadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, ZAbstractConnection,
  ZConnection, RLReport, Vcl.Imaging.pngimage, Vcl.ExtCtrls, System.ImageList,
  Vcl.ImgList, PngImageList, Vcl.ComCtrls, Vcl.ToolWin, TipoProduto;

type
  TfrmCadastro = class(TForm)
    edtCodigo: TEdit;
    edtDescricao: TEdit;
    lblCodigo: TLabel;
    lblDescricao: TLabel;

    ToolBar1: TToolBar;
    btnVoltar: TToolButton;
    btnNovo: TToolButton;
    btnAlterar: TToolButton;
    btnExcluir: TToolButton;
    btnGravar: TToolButton;
    btnCancelar: TToolButton;
    btnPesquisar: TToolButton;
    PngImageList1: TPngImageList;
    Button1: TButton;

    procedure btnGravarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure botoesAtivados();
  public
    { Public declarations }

  end;

var
  frmCadastro: TfrmCadastro;
  objTipoProduto : TtipoProduto;

implementation

{$R *.dfm}

uses uPesquisa, uRelatorio, Controls;

//Botões Ativados
procedure TfrmCadastro.botoesAtivados;
begin
  edtDescricao.Enabled := false;
  edtCodigo.Enabled := false;

  btnVoltar.Enabled := true;

  btnNovo.Enabled := true;
  btnPesquisar.Enabled := true;
  btnCancelar.Enabled := false;
  btnGravar.Enabled := false;
  btnExcluir.Enabled := false;
  btnAlterar.Enabled := false;

  edtCodigo.Clear;
  edtDescricao.Clear;

end;

//Botão Alterar
procedure TfrmCadastro.btnAlterarClick(Sender: TObject);
begin

  Tcontrols.SetGravarOuAlterar(true);
  edtDescricao.Enabled := true;
  edtCodigo.Enabled := true;

  btnCancelar.Enabled := true;
  btnGravar.Enabled := true;
  btnExcluir.Enabled := false;
  btnAlterar.Enabled := false;
  btnNovo.Enabled := false;
  btnVoltar.Enabled := false;
  btnPesquisar.Enabled := false;

  edtCodigo.Clear;
  edtDescricao.Clear;
  edtCodigo.SetFocus;


end;

//Botão Cancelar
procedure TfrmCadastro.btnCancelarClick(Sender: TObject);
begin
  botoesAtivados;
end;

//Botão Excluir
procedure TfrmCadastro.btnExcluirClick(Sender: TObject);
begin
  Tcontrols.BotaoExcluir;
  botoesAtivados;

end;

// Botão Gravar
procedure TfrmCadastro.btnGravarClick(Sender: TObject);
begin
  Tcontrols.BotaoGravar(edtcodigo.Text, edtDescricao.Text);
  botoesAtivados();

end;

// Botão Novo
procedure TfrmCadastro.btnNovoClick(Sender: TObject);
begin

  Tcontrols.SetGravarOuAlterar(false);
  edtDescricao.Enabled := true;
  edtCodigo.Enabled := true;

  btnCancelar.Enabled := true;
  btnGravar.Enabled := true;
  btnVoltar.Enabled := false;
  btnPesquisar.Enabled := false;
  btnNovo.Enabled := false;
  btnAlterar.Enabled := false;
  btnExcluir.Enabled := false;

  edtCodigo.SetFocus;

end;

//Botão Pesquisar
procedure TfrmCadastro.btnPesquisarClick(Sender: TObject);
begin
    Tcontrols.BotaoPesquisar1;

    edtCodigo.Text := objTipoProduto.codigo;
    edtDescricao.Text := objTipoProduto.descricao;

  if Tcontrols.GetVoltarOuVisualizar() = true then
  begin
    btnCancelar.Enabled := true;
    btnAlterar.Enabled := true;
    btnExcluir.Enabled := true;
    btnNovo.Enabled := false;
    btnPesquisar.Enabled := false;
    btnVoltar.Enabled := false;
    btnGravar.Enabled := false;

    edtDescricao.Enabled := false;
    edtCodigo.Enabled := false;
  end
  else
  begin
    botoesAtivados;
  end;
end;

// Botão Voltar
procedure TfrmCadastro.btnVoltarClick(Sender: TObject);

begin
  Tcontrols.BotaoVoltar1;
end;


procedure TfrmCadastro.Button1Click(Sender: TObject);
begin
  Tcontrols.criacaoFormImpressao();
end;

procedure TfrmCadastro.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Tcontrols.TeclasAtalhos(key);
end;

// Abertura do Formulário
procedure TfrmCadastro.FormShow(Sender: TObject);
begin
  botoesAtivados;
  objTipoProduto := TtipoProduto.Create;
end;

end.
