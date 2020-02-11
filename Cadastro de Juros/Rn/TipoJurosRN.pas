unit TipoJurosRN;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Mask, RxToolEdit, RxCurrEdit, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.ExtCtrls, System.ImageList,  Vcl.ImgList, PngImageList, RxLookup, DB,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, TipoJuros, TipoJurosDAO,
  JurosDAO;

type
  TTipoJurosRn = class

    private
      TipoJurosDAO: TTipoJurosDao;
      bNovo, bAtualizar, bVisualizar: boolean;

    public
      constructor Create;
      destructor Destroy; override;
      procedure Pesquisar(zGet: TZquery; TipoJuros: TTipoJuros);
      function verificaExclusao(TipoJuros: TTipoJuros): boolean;
      procedure excluir(TipoJuros: TTipoJuros);
      procedure editar(TipoJuros: TTipoJuros);
      procedure incluir(TipoJuros: TTipoJuros);

  end;

implementation

uses uCadastroTipoJuros, uPesquisaTipoJuros, uCadastroJuros;


constructor TTipoJurosRn.Create;
begin
  TipoJurosDAO := TTipoJurosDAO.Create;
end;

destructor TTipoJurosRn.Destroy;
begin
  TipoJurosDAO.Free;
  inherited;
end;

procedure TTipoJurosRn.editar(TipoJuros: TTipoJuros);
begin
  TipoJurosDAO.editar(TipoJuros);
end;

procedure TTipoJurosRn.excluir(TipoJuros: TTipoJuros);
begin
  TipoJurosDAO.excluir(TipoJuros);
end;

procedure TTipoJurosRN.Pesquisar(zGet: TZquery; TipoJuros: TTipoJuros);
begin
  TipoJurosDAO.pesquisar(zGet, TipoJuros);
end;

function TTipoJurosRn.verificaExclusao(TipoJuros: TTipoJuros): boolean;
begin
  result := TipoJurosDAO.verificaExclusao(Tipojuros);
end;

procedure TTipoJurosRn.incluir(TipoJuros: TTipoJuros);
begin
  TipoJurosDAO.incluir(TipoJuros);
end;

end.
