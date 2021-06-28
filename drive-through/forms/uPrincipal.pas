unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Buttons, Vcl.WinXCtrls, Vcl.ExtCtrls, Vcl.StdCtrls, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.Imaging.pngimage, PngSpeedButton, PedidoRN, uSenha, Data,
  RxClock, uDMPrincipal;

type
  TfrmPrincipal = class(TForm)
    pnTop: TPanel;
    pnCentral: TPanel;
    splitView: TSplitView;
    dbgPedido: TDBGrid;
    imgLogoG10: TImage;
    btnHistorico: TPngSpeedButton;
    btnConfirmar: TPngSpeedButton;
    lblData: TLabel;
    lblCidade: TLabel;
    pnInformacoesCompra: TPanel;
    timer: TTimer;
    Label1: TLabel;
    lblValor: TLabel;
    Image3: TImage;
    dbgHistorico: TDBGrid;
    btnUltimoPedido: TSpeedButton;
    lblCifrao: TLabel;
    lblPedido: TLabel;
    rxClock: TRxClock;
    lblUsuario: TLabel;
    Image1: TImage;
    Panel1: TPanel;
    btnSair: TPngSpeedButton;
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnHistoricoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure timerTimer(Sender: TObject);
    procedure btnUltimoPedidoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dbgHistoricoCellClick(Column: TColumn);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure dbgPedidoDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dbgHistoricoDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dbgHistoricoEnter(Sender: TObject);
    procedure dbgHistoricoExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSairClick(Sender: TObject);
  private
    pedidoRN: TPedidoRN;
    Data: TData;
    Hoje: TDateTime;
    procedure controleHISTORICO;
    procedure controleDESPACHO;
    procedure conecta;
  public

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

procedure TfrmPrincipal.btnCancelarClick(Sender: TObject);
begin
  ShowMessage('Pedido Cancelado!');
end;

procedure TfrmPrincipal.btnConfirmarClick(Sender: TObject);
begin
  pedidoRN.confirmarDespachoPedido(UsuarioAcesso);
end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Data.Free;
  pedidoRN.Free;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  conecta;

  BorderStyle := bsNone;
  WindowState := wsMaximized;

  pedidoRN := TPedidoRN.create;
  Data     := TData.Create;

  Hoje     := Data.DateServer;
end;

procedure TfrmPrincipal.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if Key = VK_RETURN then
     btnConfirmarClick(self);

  if key = VK_ESCAPE then
     Application.Terminate;

  if key = 72 then
     btnHistoricoClick(Self);
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  pedidoRN.temImagem(imgLogoG10);

  lblUsuario.Caption := UsuarioAcesso.Nome;

  pedidoRN.getItensUltimoPedido;
  pedidoRN.getHistoricoDePedidos;

  lblCidade.Caption := Data.DataExtenso(Hoje)+', '+pedidoRN.getCidade;
  lblData.Caption   := FormatDateTime('dd/mm/yyyy', Hoje);

  dbgHistorico.DataSource := DMPrincipal.dsHistorico;
end;

procedure TfrmPrincipal.btnHistoricoClick(Sender: TObject);
begin
  splitView.Opened := not splitView.Opened;
end;

procedure TfrmPrincipal.btnSairClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmPrincipal.btnUltimoPedidoClick(Sender: TObject);
begin
  pedidoRN.getItensUltimoPedido;

  controleDESPACHO;
end;

procedure TfrmPrincipal.conecta;
begin
  timer.Enabled := false;
  if frmSenha = nil then
     frmSenha := TfrmSenha.Create(self);
   frmSenha.ShowModal;

   if not bLoginYes then
      Application.Terminate
   else
      timer.Enabled := true;
end;

procedure TfrmPrincipal.controleDESPACHO;
begin
  btnUltimoPedido.Enabled := false;
  btnConfirmar.Enabled    := true;
end;

procedure TfrmPrincipal.controleHISTORICO;
begin
  btnUltimoPedido.Enabled := true;
  btnConfirmar.Enabled    := false;
end;

procedure TfrmPrincipal.dbgHistoricoCellClick(Column: TColumn);
begin
  pedidoRN.setPedido(dbgHistorico.Fields[0].AsString);
  lblValor.Caption  := FormatFloat('###,##0.00' ,dmPrincipal.zqPedido.FieldByName('valortotal').AsFloat);
  lblPedido.Caption := 'PEDIDO ' + dmPrincipal.zqHistorico.FieldByName('numeropedido').AsString;

  controleHISTORICO;
end;

procedure TfrmPrincipal.dbgHistoricoDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if dbgHistorico.Fields[2].AsString = '1' then
    begin
      dbgHistorico.Canvas.Font.Color := clRed;
      dbgHistorico.Canvas.FillRect(Rect);
      dbgHistorico.DefaultDrawColumnCell(Rect, DataCol, Column, State);
    end
    else
    begin
      dbgHistorico.Canvas.Font.Color := clGreen;
      dbgHistorico.Canvas.FillRect(Rect);
      dbgHistorico.DefaultDrawColumnCell(Rect, DataCol, Column, State);
    end;

end;

procedure TfrmPrincipal.dbgHistoricoEnter(Sender: TObject);
begin
  controleHISTORICO;
end;

procedure TfrmPrincipal.dbgHistoricoExit(Sender: TObject);
begin
  controleDESPACHO;
end;

procedure TfrmPrincipal.dbgPedidoDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  sTexto: string;  cValor: Currency;begin  with (Sender as TDBGrid).Canvas do  begin    sTexto := dbgPedido.DataSource.DataSet.FieldByName(Column.Field.FieldName).AsString;    if (Column.Field.FieldName = 'valorunitario') or (Column.Field.FieldName = 'total') then    begin      cValor := dbgPedido.DataSource.DataSet.FieldByName(Column.Field.FieldName).AsCurrency;      sTexto := FormatFloat('###,###,##0.00', cValor);    end;    {Zébra o GRID}    if State = [] then    begin      if dbgPedido.DataSource.DataSet.RecNo mod 2 = 1 then         dbgPedido.Canvas.Brush.Color := $00FFE2C6      else         dbgPedido.Canvas.Brush.Color := clWhite;    end;    dbgPedido.DefaultDrawColumnCell(Rect, DataCol, Column, State);    if (gdSelected in State) or (gdFocused in State) or (dbgPedido.SelectedRows.CurrentRowSelected) then       TDBGrid(Sender).Canvas.Brush.Color := $0082FFFF;    dbgPedido.DefaultDrawColumnCell(Rect, DataCol, Column, State);    FillRect(Rect);    if not (State=[]) then       DrawFocusRect(Rect);    if dbgPedido.DataSource.DataSet.FieldByName('drivethroughdespachado').AsString = '1' then      dbgPedido.Font.Color := clRed
    else
      dbgPedido.Font.Color := clGreen;    TextOut(Rect.Right - (TextWidth(sTexto)+4), Rect.Top+1, sTexto);
  end;
end;

procedure TfrmPrincipal.timerTimer(Sender: TObject);
begin
  try
    if not dmPrincipal.zqHistorico.IsEmpty then
      dmPrincipal.zqHistorico.Refresh;

    if dbgPedido.DataSource.DataSet.IsEmpty then
      pedidoRN.getItensUltimoPedido;
  except

  end;
end;

end.
