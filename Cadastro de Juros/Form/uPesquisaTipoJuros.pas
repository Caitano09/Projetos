unit uPesquisaTipoJuros;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, System.ImageList,
  Vcl.ImgList, PngImageList, Vcl.ToolWin, Vcl.ExtCtrls, Vcl.StdCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, ZAbstractRODataset, ZAbstractDataset, ZDataset,
  TipoJuros, TipoJurosRN, Validar, Vcl.Menus, RDprint;

type
  TfrmPesquisaTipoJuros = class(TForm)
    Panel1: TPanel;
    ToolBar1: TToolBar;
    PngImageList1: TPngImageList;
    btnVoltar: TToolButton;
    btnVisualizar: TToolButton;
    btnPesquisar: TToolButton;
    btnImprimir: TToolButton;
    lblDescricao: TLabel;
    edtDescricao: TEdit;
    DBGrid1: TDBGrid;
    Panel2: TPanel;
    lblRegistro: TLabel;
    lblNumRegistros: TLabel;
    Bevel1: TBevel;
    zqGet: TZQuery;
    dsPesquisa: TDataSource;
    lblSelecionado: TLabel;
    RDprint: TRDprint;
    ppmImprimir: TPopupMenu;
    ipodeProdutos1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure btnVisualizarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure RDprintAfterPrint(Sender: TObject);
    procedure RDprintBeforeNewPage(Sender: TObject; Pagina: Integer);
    procedure RDprintNewPage(Sender: TObject; Pagina: Integer);
    procedure ipodeProdutos1Click(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1TitleClick(Column: TColumn);

  private
    { Private declarations }
    bAscendente: boolean;
    iLinha, iLinhaContinua: integer;
    procedure AfterScroll(DataSet: TDataSet);
    procedure imprimir();
    procedure newLinePage();
  public
    { Public declarations }
      procedure pesquisar;
  end;
var
  frmPesquisaTipoJuros: TfrmPesquisaTipoJuros;
  TipoJurosRn : TtipoJurosRN;
  TipoJuros : TTipoJuros;
  ValidarPesquisa: TValidar;
implementation

{$R *.dfm}

uses uCadastroTipoJuros;

procedure TfrmPesquisaTipoJuros.btnPesquisarClick(Sender: TObject);
begin
  pesquisar;
end;

procedure TfrmPesquisaTipoJuros.btnVisualizarClick(Sender: TObject);
var
  TipoJuros: TTipoJuros;
begin
  if Assigned(frmCadastroTipoJuros) then
  begin
    if not frmPesquisaTipoJuros.zqGet.IsEmpty then
    begin
      TipoJuros := TTipoJuros.Create;

      TipoJuros.setDescricao(zqGet.FieldByName('descricao').AsString);
      TipoJuros.setCodigo(zqGet.FieldByName('Codigo').AsInteger);

      frmCadastroTipoJuros.setTipoJuros(TipoJuros);
      close;
    end;
  end;
end;

procedure TfrmPesquisaTipoJuros.btnVoltarClick(Sender: TObject);
begin
  close;
end;

procedure TfrmPesquisaTipoJuros.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  sTexto: string;
begin
  with (Sender as TDBGrid).Canvas do
  begin
    sTexto := DBGrid1.DataSource.DataSet.FieldByName(Column.Field.FieldName).AsString;

    {Z�bra o GRID}
    if State = [] then
    begin
      if DBGrid1.DataSource.DataSet.RecNo mod 2 = 1 then
         DBGrid1.Canvas.Brush.Color := $00FFE2C6
      else
         DBGrid1.Canvas.Brush.Color := clWhite;
    end;
    DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);

    Font.Color := clBlack;

    if (gdSelected in State) or (gdFocused in State) then
       TDBGrid(Sender).Canvas.Brush.Color := $0082FFFF;

    DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);

    FillRect(Rect);
    if not (State=[]) then
       DrawFocusRect(Rect);

     if (Column.Field.FieldName = 'codigo') then
        TextOut(Rect.Right - (TextWidth(sTexto)+4), Rect.Top+1, sTexto)
     else
        TextOut(Rect.Left+2, Rect.Top+1, sTexto);
  end;
end;

procedure TfrmPesquisaTipoJuros.DBGrid1TitleClick(Column: TColumn);
begin
  if bAscendente then
  begin
    zqGet.IndexFieldNames := Column.FieldName + ' ASC';
    bAscendente := false;
  end
  else
  begin
    zqGet.IndexFieldNames := Column.FieldName + ' DESC';
    bAscendente := true;
  end;
end;

procedure TfrmPesquisaTipoJuros.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  try
    TipoJurosRn.Free;
    TipoJuros.Free;
    ValidarPesquisa.Free;
  finally
    Action := caFree;
    frmPesquisaTipoJuros := nil;
  end;
end;
procedure TfrmPesquisaTipoJuros.FormCreate(Sender: TObject);
begin
  TipojurosRn := TTipoJurosRn.Create;
  tipoJuros := TTipoJuros.Create;
  ValidarPesquisa := TValidar.Create;

  DBGrid1.Columns[0].Width := 45;
  DBGrid1.Columns[1].Width := 280;

  zqGet.AfterScroll := AfterScroll;
end;

procedure TfrmPesquisaTipoJuros.FormShow(Sender: TObject);
begin
  lblSelecionado.Caption := '';
end;

procedure TfrmPesquisaTipoJuros.AfterScroll(DataSet: TDataSet);
begin
  lblSelecionado.Caption := '';
  if not zqGet.IsEmpty then
     lblSelecionado.Caption :=
     'desc: '+zqGet.FieldByName('descricao').AsString;
end;

procedure TfrmPesquisaTipoJuros.imprimir;
var
  sSQL: string;
  iCount: integer;
begin
  sSQL := '';

  if zqGet.RecordCount > 0 then
  begin
    RDprint.OpcoesPreview.Preview := true;
    RDprint.MostrarProgresso      := true;

    RDprint.abrir;

    iLinha := 7;
    iCount := 0;

    zqGet.First;
    while not zqGet.eof do
    begin
      newLinePage;

      RDprint.Impc(iLinha, 01,
      ValidarPesquisa.PreencherString(zqGet.FieldByName('descricao').AsString, ' ', 32, 'D'), [comp20], 0);

      inc(iCount);

      zqGet.next;
    end;

    newLinePage;
    RDprint.imp(iLinha,01,'--------------------------------------------------------------------------------',0);
    newLinePage;
    RDprint.Impc(iLinha,01,
    ValidarPesquisa.PreencherString('REGISTRO('+IntToStr(iCount)+')', ' ', 23, 'D'), [comp20, negrito], 0);
    newLinePage;
    RDprint.imp(iLinha,01,'--------------------------------------------------------------------------------',0);

    RDprint.fechar;
  end;
end;

procedure TfrmPesquisaTipoJuros.ipodeProdutos1Click(Sender: TObject);
begin
  imprimir;
end;

procedure TfrmPesquisaTipoJuros.newLinePage;
begin
  Inc(iLinha);
  if iLinha > 63 then
     RDprint.NovaPagina;
end;

procedure TfrmPesquisaTipoJuros.pesquisar;
begin
  try
    TipoJuros.setDescricao(edtDescricao.Text);
    TipoJurosRn.pesquisar(zqGet, tipojuros);

    lblNumRegistros.Caption := '0';

   if not zqGet.IsEmpty then
     lblNumRegistros.Caption := IntToStr(zqGet.RecordCount);

  except
    on E: Exception do
    begin
      Application.MessageBox(PChar(E.Message), 'Aten��o', MB_ICONINFORMATION + MB_OK);
    end;
  end;
end;

procedure TfrmPesquisaTipoJuros.RDprintAfterPrint(Sender: TObject);
begin
  Keybd_Event(VK_Escape, 0, 0, 0);
end;

procedure TfrmPesquisaTipoJuros.RDprintBeforeNewPage(Sender: TObject;
  Pagina: Integer);
begin
  RDprint.imp (64,01,'--------------------------------------------------------------------------------');
  RDprint.impf(65,01,'G10 Sistemas ', [NEGRITO]);
  RDprint.impf(65,65,'Telefone (75) 3631-4327', [comp17]);
end;

procedure TfrmPesquisaTipoJuros.RDprintNewPage(Sender: TObject;
  Pagina: Integer);
begin
  RDprint.imp (01,01,'--------------------------------------------------------------------------------',0);
  RDprint.impc(02,01,'RELA��O DE TIPOS DE JUROS', [NEGRITO],  0);
  RDprint.impf(02,64,'Data:'+DateToStr(Date())+'',[normal], 0);
  RDprint.impf(03,01,'P�gina: ' + formatfloat('##',pagina) + ' de &page&',[normal], 0);
  RDprint.imp(04,01,'--------------------------------------------------------------------------------',0);
  RDprint.impc(05, 01,
  ValidarPesquisa.PreencherString('DESCRI��O', ' ', 25, 'D'), [comp20], 0);
  RDprint.imp(06,01,'--------------------------------------------------------------------------------', 0);

  iLinha         := 7;
  iLinhaContinua := 7;
end;

end.
