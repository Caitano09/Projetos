object DMPrincipal: TDMPrincipal
  OldCreateOrder = False
  Height = 150
  Width = 546
  object ZConnection: TZConnection
    ControlsCodePage = cCP_UTF16
    AutoEncodeStrings = True
    Catalog = ''
    HostName = '192.168.1.240'
    Port = 5432
    Database = 'db_sgc'
    User = 'estudo'
    Password = 'estudo'
    Protocol = 'postgresql'
    Left = 56
    Top = 8
  end
  object dsPedido: TDataSource
    DataSet = zqPedido
    Left = 136
    Top = 88
  end
  object zqPedido: TZQuery
    Connection = ZConnection
    SQL.Strings = (
      
        'select vw_pessoas.nome, produto.descricao as pedido, vendaclient' +
        'e.numeropedido,            vendacliente.numerodocumento, pdvregi' +
        'stroitemvenda.numerocupom, pdvregistroitemvenda.qtde, produto.va' +
        'lor as valorUnitario, pdvregistroitemvenda.total, produto.id as ' +
        'produtoid,       produto.codigo as produtoCodigo, vendacliente.t' +
        'otalvenda as valortotal                     from vendacliente   ' +
        '                                                                ' +
        '       join pdvregistroitemvenda on pdvregistroitemvenda.numerop' +
        'edido = vendacliente.numeropedido join produto on produto.id = p' +
        'dvregistroitemvenda.produtoid                                joi' +
        'n vw_pessoas on vw_pessoas.id = vendacliente.clienteid          ' +
        '                        where vendacliente.numeropedido = '#39'00000' +
        '05700'#39'                                 ')
    Params = <>
    Left = 136
    Top = 40
  end
  object dsHistorico: TDataSource
    DataSet = zqHistorico
    Left = 200
    Top = 88
  end
  object zqHistorico: TZQuery
    Connection = ZConnection
    SQL.Strings = (
      
        'select numeropedido, totalvenda, drivethroughdespachado from ven' +
        'dacliente where datavenda = CURRENT_DATE order by id desc')
    Params = <>
    Left = 200
    Top = 40
  end
  object zGetServer: TZQuery
    Connection = ZConnection_Server
    Params = <>
    Left = 408
    Top = 96
  end
  object ZConnection_Server: TZConnection
    ControlsCodePage = cCP_UTF16
    AutoEncodeStrings = True
    ClientCodepage = 'latin1'
    Catalog = ''
    Properties.Strings = (
      'codepage=latin1'
      'client_encoding=latin1'
      'AutoEncodeStrings=ON'
      'controls_cp=CP_UTF16')
    TransactIsolationLevel = tiReadCommitted
    HostName = '192.168.1.240'
    Port = 5432
    Database = 'postgres'
    User = 'admin'
    Password = 'info$g10112'
    Protocol = 'postgresql'
    Left = 415
    Top = 45
  end
end
