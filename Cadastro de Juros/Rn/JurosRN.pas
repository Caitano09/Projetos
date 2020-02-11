unit JurosRN;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Mask, RxToolEdit, RxCurrEdit, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.ExtCtrls, System.ImageList,  Vcl.ImgList, PngImageList, RxLookup, DB,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, JurosDAO, Juros, TipoJuros;

type
  TJurosRN = class

    private
      JurosDAO: TJurosDao;
      bNovo, bAtualizar, bVisualizar: boolean;

    public
      constructor Create;
      destructor Destroy; override;

      procedure editarStringGrid(juros: Tjuros);
      procedure excluir(Juros: TJuros);
      procedure editar(Juros: TJuros);
      procedure incluir(Juros: TJuros);
      procedure abreFormTipoJuros();
      procedure Pesquisar(zGet: TZquery; edtDe, edtAte: double; TipoJuros: TTipoJuros);
      procedure pesquisarStringGrid(zGet: TZQuery);
      function existeCadastroTipoJuros(TipoJuros: TTipoJuros): boolean;
      function getTipoJuros(): TDataSource;
      function getStatusTipoJuros(): TDataSource;
      function verificaExclusao(Juros: TJuros): boolean;
  end;

implementation

uses uCadastroJuros, uPesquisaJuros, uCadastroTipoJuros;

constructor TJurosRN.Create;
begin
  JurosDao := TJurosDao.Create;
end;

destructor TJurosRN.Destroy;
begin
  inherited;
end;

procedure TJurosRN.editar(Juros: TJuros);
begin
  JurosDao.editar(juros);
end;

procedure TJurosRN.editarStringGrid(juros: Tjuros);
begin
  JurosDAO.editarStringGrid(juros);
end;

procedure TJurosRN.excluir(Juros: TJuros);
begin
  JurosDao.excluir(juros);
end;

function TJurosRN.existeCadastroTipoJuros(TipoJuros: TTipoJuros): boolean;
begin
  result := JurosDAO.existeCadastroTipoJuros(TipoJuros);
end;

function TJurosRN.getStatusTipoJuros: TDataSource;
begin
  Result := JurosDAO.getStatusTipoJuros;
end;

function TJurosRN.getTipoJuros: TDataSource;
begin
  result := JurosDAO.getTipoJuros();
end;

procedure TJurosRN.incluir(Juros: TJuros);
begin
  JurosDao.incluir(juros);
end;

function TJurosRN.verificaExclusao(Juros: TJuros): boolean;
begin
  result := JurosDAO.verificaExclusao(Juros);
end;

procedure TJurosRN.abreFormTipoJuros;
begin
  if frmCadastroTipoJuros = nil then
  begin
    frmCadastroTipoJuros := TfrmCadastroTipoJuros.Create(frmCadastroTipoJuros);
    frmCadastroTipoJuros.ShowModal;
  end;
end;

procedure TJurosRN.Pesquisar(zGet: TZquery; edtDe, edtAte: double; TipoJuros: TTipoJuros);
begin
  JurosDAO.pesquisar(zGet, edtde, edtate, tipojuros);
end;

procedure TJurosRN.pesquisarStringGrid(zGet: TZQuery);
begin
  JurosDAO.pesquisarStringGrid(zGet);
end;

end.
