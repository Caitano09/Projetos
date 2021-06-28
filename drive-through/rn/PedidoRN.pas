unit PedidoRN;

interface

uses DriveThroughDAO, udmPrincipal, System.SysUtils, Usuario, Vcl.ExtCtrls;

type
  TPedidoRN = class
    private
      PedidoDAO: TDriveThroughDAO;

      sNumeroPedido: string;
      iClienteID: integer;
      iUsuarioID: integer;
    public
      constructor create;
      destructor destroy;

      procedure getItensUltimoPedido;
      procedure confirmarDespachoPedido(usuario: TUsuario);
      procedure getHistoricoDePedidos;
      procedure setPedido(sNumeroPedido: String);

      function getNumeroUltimoPedido: string;
      function getCidade: String;
      function temImagem(var imagem: TImage): boolean;
  end;
implementation

{ TPedidoRN }

uses uPrincipal, uSenha;

constructor TPedidoRN.create;
begin
  PedidoDAO := TDriveThroughDAO.Create;
end;

destructor TPedidoRN.destroy;
begin
  PedidoDAO.Free;
  inherited;
end;

procedure TPedidoRN.getItensUltimoPedido;
begin
  sNumeroPedido := getNumeroUltimoPedido;

  PedidoDAO.getMostrarPedido(sNumeroPedido);

  frmPrincipal.lblValor.Caption  := FormatFloat('###,##0.00' ,dmPrincipal.zqPedido.FieldByName('valortotal').AsFloat);
  frmPrincipal.lblPedido.Caption := 'PEDIDO ' + dmPrincipal.zqPedido.FieldByName('numeropedido').AsString;
end;

function TPedidoRN.getNumeroUltimoPedido: string;
begin
  result := PedidoDAO.getNumeroUltimoPedido;
end;

procedure TPedidoRN.setPedido(sNumeroPedido: String);
begin
  PedidoDAO.getMostrarPedido(sNumeroPedido);
end;

function TPedidoRN.temImagem(var imagem: TImage): boolean;
begin
  result := PedidoDAO.temImagem(imagem);
end;

function TPedidoRN.getCidade: String;
begin
  result := PedidoDAO.getCidade;
end;

procedure TPedidoRN.getHistoricoDePedidos;
begin
  PedidoDAO.getHistoricoDePedidos;
end;

procedure TPedidoRN.confirmarDespachoPedido(usuario: TUsuario);
begin
  if PedidoDAO.confirmarDespachoPedido(sNumeroPedido, usuario) then
     getItensUltimoPedido;
end;

end.
