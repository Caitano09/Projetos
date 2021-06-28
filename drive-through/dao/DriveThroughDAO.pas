unit DriveThroughDAO;

interface

uses
  udmPrincipal, DB, ZAbstractRODataset, System.Classes, ZAbstractDataset,
  ZDataset, SysUtils, ZConnection, Usuario, Vcl.ExtCtrls;

type
  TDriveThroughDAO = class
    private
      ZQuery: TZQuery;
    public
      procedure getMostrarPedido(sNumeroPedido: string);
      procedure getHistoricoDePedidos;

      function getNumeroUltimoPedido: string;
      function confirmarDespachoPedido(sNumeroPedido: string; usuario: TUsuario): boolean;
      function getCidade: string;

      function temImagem(var imagem: TImage): boolean;
  end;

implementation

{ TDao }

function TDriveThroughDAO.confirmarDespachoPedido(sNumeroPedido: String; usuario: TUsuario): Boolean;
var
  sSQL: String;
begin
  try
    sSQL :=
    ' update vendacliente set drivethroughdespachado = ''1'',  '+
    ' drivethroughdata = LOCALTIMESTAMP,                       '+
    ' drivethroughusuarioid = '+ IntToStr(usuario.Codigo) +'   '+
    ' where numeropedido = '''+sNumeroPedido+'''               ';

    dmPrincipal.zqPedido.Close;
    dmPrincipal.zqPedido.SQL.Clear;
    dmPrincipal.zqPedido.SQL.Text := sSQL;
    dmPrincipal.zqPedido.ExecSQL;

    Result := true;
  except
    Result := false;
  end;
end;

function TDriveThroughDAO.getCidade: String;
var
  sSQL: String;
  zGet: TZQuery;
begin
  zGet := TZQuery.Create(ZQuery);
  zGet.Connection := dmPrincipal.ZConnection;

  sSQL :=
  ' select cidade.descricao as cidade, cidade.estadoid as estado              '+
  ' from endereco join cidade on cidade.id = cast(endereco.cidade as INTEGER) '+
  ' where dadosid = 1428                                                      ';

  zGet.Close;
  zGet.SQL.Clear;
  zGet.SQL.Text := sSQL;
  zGet.Open;

  result := zGet.FieldByName('cidade').AsString + ', ' + zGet.FieldByName('estado').AsString;
end;

procedure TDriveThroughDAO.getHistoricoDePedidos;
var
  sSQL: String;
  iLast: integer;
begin
  sSQL :=
  ' select vendacliente.numeropedido, vendacliente.totalvenda, vendacliente.drivethroughdespachado'+
  ' from vendacliente                                                         '+
  ' where vendacliente.datavenda = CURRENT_DATE and statusid = ''10''         '+
  ' and vendacliente.registro = ''R1''                                        '+
  ' order by numeropedido desc                                                ';

  dmPrincipal.zqHistorico.Close;
  dmPrincipal.zqHistorico.SQL.Clear;
  dmPrincipal.zqHistorico.SQL.Text := sSQL;
  dmPrincipal.zqHistorico.Open;
end;

procedure TDriveThroughDAO.getMostrarPedido(sNumeroPedido: String);
var
  sSQL: String;
begin
  sSQL :=
  ' select cast(vw_pessoas.nome as varchar(50)) as nome, cast(produto.descricao as varchar(50)) as pedido, vendacliente.numeropedido,  '+
  ' vendacliente.numerodocumento, pdvregistroitemvenda.numerocupom, pdvregistroitemvenda.qtde,                                         '+
  ' produto.valor as valorUnitario, pdvregistroitemvenda.total, produto.id as produtoid,                                               '+
  ' produto.codigo as produtoCodigo, vendacliente.totalvenda as valortotal,                                                            '+
  ' vendacliente.drivethroughdespachado                                                                                                '+
  ' from vendacliente                                                                                                                  '+
  ' join pdvregistroitemvenda on pdvregistroitemvenda.numeropedido = vendacliente.numeropedido                                         '+
  ' join produto on produto.id = pdvregistroitemvenda.produtoid                                                                        '+
  ' join vw_pessoas on vw_pessoas.id = vendacliente.clienteid                                                                          '+
  ' where vendacliente.numeropedido = '''+sNumeroPedido+'''                                                                            ';

  dmPrincipal.zqPedido.Close;
  dmPrincipal.zqPedido.SQL.Clear;
  dmPrincipal.zqPedido.SQL.Text := sSQL;
  dmPrincipal.zqPedido.Open;
end;

function TDriveThroughDAO.getNumeroUltimoPedido: string;
var
  zGet: TZQuery;
  sSQL: String;
begin
  zGet := TZQuery.Create(ZQuery);
  try
    zGet.Connection := dmPrincipal.ZConnection;

    sSQL :=
    ' select vendacliente.numeropedido                           '+
    ' from vendacliente                                          '+
    ' where statusid = ''10'' and drivethroughdespachado is null '+
    ' and registro = ''R1''                                      '+
    ' order by id asc limit 1                                    ';

    zGet.Close;
    zGet.SQL.Clear;
    zGet.SQL.Text := sSQL;
    zGet.Open;

    result := zGet.FieldByName('numeropedido').AsString;
  finally
    zGet.Close;
    zGet.Free;
  end;
end;

function TDriveThroughDAO.temImagem(var imagem: TImage): boolean;
var
  zGet: TZQuery;
  sSQL: String;
begin
  try
    zGet := TZQuery.Create(ZQuery);
    try
      zGet.Connection := dmPrincipal.ZConnection;

      sSQL := 'select dadospessoajuridica.pathlogo from dadospessoajuridica '+
      ' where id = 1428';

      zGet.Close;
      zGet.SQL.Clear;
      zGet.SQL.Text := sSQL;
      zGet.Open;

      if (zGet.IsEmpty) or (zGet.Fields[0].AsString = '') then
        Result := false
      else
      begin
        imagem.Picture.LoadFromFile(zGet.Fields[0].AsString);
        Result := true;
      end;
    finally
      zGet.Close;
      zGet.Free;
    end;
  except
    Result := false;
  end;
end;

end.

