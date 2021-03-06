unit uBuscar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, RDprint, Vcl.Grids,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, System.ImageList, Vcl.ImgList,
  PngImageList, Vcl.ComCtrls, Vcl.ToolWin;

type
  TfrmBuscar = class(TForm)
    StringGrid1: TStringGrid;
    edtDescricao: TEdit;
    lblDescricao: TLabel;
    lblCodigo: TLabel;
    ToolBar1: TToolBar;
    btnVoltar: TToolButton;
    btnVisualizar: TToolButton;
    btnPesquisar: TToolButton;
    btnImprimir: TToolButton;
    btnPrint: TToolButton;
    PngImageList1: TPngImageList;
    edtCodigo: TEdit;

    procedure FormShow(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure btnVisualizarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  frmBuscar: TfrmBuscar;

implementation

{$R *.dfm}

uses Controls, Dados, uDm;

//Bot�o Imprimir
procedure TfrmBuscar.btnImprimirClick(Sender: TObject);
begin
  Tcontrols.BotaoImprimir();
end;

//Bot�o Pequisar
procedure TfrmBuscar.btnPesquisarClick(Sender: TObject);
begin
  Tcontrols.BotaoPesquisar2(edtCodigo.Text, edtDescricao.Text);
  Tcontrols.CriacaoForm();

end;

//Bot�o Print
procedure TfrmBuscar.btnPrintClick(Sender: TObject);
begin
  Tcontrols.BotaoPrint();
end;

//Bot�o Visualizar
procedure TfrmBuscar.btnVisualizarClick(Sender: TObject);
begin
  Tcontrols.BotaoVisualizar();
  Tcontrols.SetVoltarOuVisualizar(true);
end;

//Bot�o Voltar
procedure TfrmBuscar.btnVoltarClick(Sender: TObject);
begin

    Tcontrols.SetVoltarOuVisualizar(false);
    Tcontrols.BotaoVoltar2;
end;

// Teclas de atalho
procedure TfrmBuscar.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Tcontrols.TeclasAtalhos2(key);
end;

//Exibindo Formul�rio
procedure TfrmBuscar.FormShow(Sender: TObject);
begin
  Tcontrols.CriacaoForm();
end;

//Selecionar Linha do stringGrid
procedure TfrmBuscar.StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  Tcontrols.BotaoPesquisar2(StringGrid1.Cells[1, ARow], StringGrid1.Cells[2, ARow]);
end;

end.
