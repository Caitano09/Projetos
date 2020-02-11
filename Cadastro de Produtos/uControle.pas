unit uControle;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TfrmControle = class(TForm)
  private
    { Private declarations }

  public
    { Public declarations }
    iId: Integer;
    iGravarOuAlterar: boolean;
    iVoltarOuVisualizar: boolean;

    procedure CriacaoForm();
    procedure BotaoGravar (codigo, descricao: string);
    procedure BotaoVoltar1();
    procedure BotaoVoltar2();
    procedure BotaoPesquisar1();
    procedure BotaoPesquisar2(codigo, descricao: String);
    procedure BotaoVisualizar();
    procedure BotaoPrint();
    procedure BotaoImprimir();
    procedure BotaoExcluir();
  end;

var
  frmControle: TfrmControle;

implementation

{$R *.dfm}

uses uCadastro, uDao, uPesquisa, uRelatorio;

procedure TfrmControle.BotaoVoltar1;
begin
 frmCadastro.Close;
end;

procedure TfrmControle.BotaoVoltar2;
begin
 frmPesquisa.Close;
end;


procedure TfrmControle.BotaoGravar(codigo: string; descricao: string);
begin
    if trim (descricao) = '' then
  begin
    ShowMessage('A caixa de texto descri��o est� vazia');
  end

  else if trim (codigo) = '' then
  begin
    ShowMessage('A caixa de texto c�digo est� vazia');
  end

  else if iGravarOuAlterar = false then
  begin
    frmDao.sqlInsert(codigo, descricao);
    ShowMessage('Adicionado com sucesso');
  end

  else if iGravarOuAlterar = true then
  begin
    if Application.MessageBox('Deseja Alterar?', 'Stop', mb_yesno + mb_iconquestion) = id_yes then
     begin
        frmDao.sqlUpdate(iId ,codigo,descricao);
        ShowMessage('Alterado com sucesso');
     end;
  end;
end;

procedure TfrmControle.BotaoPesquisar1;
begin
  frmPesquisa := TfrmPesquisa.Create(Self);
  frmPesquisa.ShowModal;
end;

procedure TfrmControle.BotaoPesquisar2(codigo: string; descricao: string);

begin

  if (Trim(Descricao) <> '') and (Trim(Codigo) <> '') then
 begin
    frmDao.sqlSelect(1, descricao, codigo);
 end

  else if (Trim(Descricao) = '') and (Trim(Codigo) <> '') then
  begin
    frmDao.sqlSelect(2, descricao, codigo);
  end

  else if (Trim(Descricao) <> '') and (Trim(Codigo) = '') then
  begin
    frmDao.sqlSelect(3, descricao, codigo);
  end

  else
  begin
    ShowMessage('Campos vazios');
  end;

end;

procedure TfrmControle.CriacaoForm;
begin
  frmDao.SelectTudo;
end;

procedure TfrmControle.BotaoVisualizar;
begin
  iId :=  frmDao.ZQuery1.FieldByName('id').AsInteger;
  frmCadastro.edtCodigo.Text := frmDao.ZQuery1.FieldByName('codigo').AsString;
  frmCadastro.edtdescricao.Text := frmDao.ZQuery1.FieldByName('descricao').AsString;
  frmControle.BotaoVoltar2;
end;

procedure TfrmControle.BotaoPrint;
  var i, id: Integer;

  begin
    frmPesquisa.RDprint1.Abrir;
    if  frmPesquisa.RDprint1.Setup = true then
    begin
      frmPesquisa.RDprint1.Imp(1, 1, 'TIPOPRODUTO');
      frmPesquisa.RDprint1.Imp(3, 1, '-------------------------------------------------');
      frmPesquisa.RDprint1.Imp(4, 01, 'ID');
      frmPesquisa.RDprint1.Imp(4, 15, 'CODIGO');
      frmPesquisa.RDprint1.Imp(4, 30, 'DESCRIC�O');
      frmPesquisa.RDprint1.Imp(5, 1, '-------------------------------------------------');
      frmDao.ZQuery1.First;
      i := 6;
      repeat
      begin
        frmPesquisa.RDprint1.Imp(i, 01, frmDao.ZQuery1.FieldByName('id').AsString);
        frmPesquisa.RDprint1.Imp(i, 15, frmDao.ZQuery1.FieldByName('codigo').AsString);
        frmPesquisa.RDprint1.Imp(i, 30, frmDao.ZQuery1.FieldByName('descricao').AsString);
        id := frmDao.ZQuery1.FieldByName('id').AsInteger;
        frmDao.ZQuery1.Next;
        i := i +1;
      end;
      until (id = frmDao.ZQuery1.FieldByName('id').AsInteger);
    frmPesquisa.RDprint1.Imp(66, 60, FormatDateTime('dd/mm/yyyy HH: MM: SS', NOW));
    frmPesquisa.RDprint1.Fechar;
  end;
end;

procedure TfrmControle.BotaoImprimir;
begin
  frmRelatorio := TfrmRelatorio.Create(self);
  frmRelatorio.RLReport1.Preview;
end;

procedure TfrmControle.BotaoExcluir;
begin
  if Application.MessageBox('Deseja excluir?', 'Stop', mb_yesno + mb_iconquestion) = id_yes then
  begin
    frmDao.sqlDelete(iId);
   ShowMessage('Item exclu�do');
  end;

end;

end.


