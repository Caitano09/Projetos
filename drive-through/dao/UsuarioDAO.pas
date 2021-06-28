unit UsuarioDAO;

interface

uses
  Usuario, Validar, DB, ZAbstractRODataset, ZAbstractDataset,
  ZDataset, SysUtils, ZConnection, udmPrincipal, Classes,
  DateUtils, ZSQLProcessor;

const
   Boleto = 7;
   NumFuncoes = 300;

type
  TUsuarioDAO = class
  private
    { Private Declarations }
    Usuario   : TUsuario;
    Validar   : TValidar;
    ZQuery    : TZQuery;
    sIdentifier: string;
    DataSource: TDataSource;
    FZConnection: TZConnection;
    ZSQLProcessor: TZSQLProcessor;
    procedure SetZConnection(const Value: TZConnection);
  public

    constructor Create;
    destructor Destroy; override;
    property ZConnection: TZConnection read FZConnection write SetZConnection;
    function LoginUsuario(Usuario: TUsuario): TUsuario;

    function validaVersao(sVersao: string): boolean;
    function getIdentifier: string;

    function getPercRemocaoJuros(iUsuario: integer): double;

    function getCaixa: TDataSource;
    function getUsuario: TDataSource;
    function getOperador: TDataSource;
    function getVendedor: TDataSource;
    function getFamiliaProduto: TDataSource;

    {Validação de acesso}
    function getVerificaBloqueadoLocal(sIdentificador: string): boolean;
    function getVerificaData: boolean;
    //function getSituacaoAcesso(sIdentifier: string): string;
    procedure setChecagem;
    procedure setChecagemDiaAnterior;
    function jaGravouChave(sChave: string): boolean;
    procedure gravaChave(sChave: string);
    procedure insertBloquioSistemaSemNet;

    {Controle de Usuário}
    function getUsuarios: TList;
    function getJaExisteLogin(Usuario: TUsuario): boolean;
    function getSenhaUsuario(Usuario: TUsuario): string;

    procedure gravaUsuario(Usuario: TUsuario; sAcao: string);
    procedure gravaUsuarioSuporte(Usuario: TUsuario);
    procedure setCopiarPerfil(UsuarioDe, UsuarioPara: TUsuario);
    procedure excluirUsuario(Usuario: TUsuario);
    function getPermissaoUsuario(Usuario: TUsuario; iFuncao: integer): boolean;

  end;

implementation

constructor TUsuarioDAO.Create;
begin
  inherited Create;
  sIdentifier := getIdentifier;
end;

destructor TUsuarioDAO.Destroy;
begin
  inherited;
end;

procedure TUsuarioDAO.excluirUsuario(Usuario: TUsuario);
var
  sSQL: string;
  zSet: TZquery;
begin
  try
    zSet            := TZQuery.Create(ZQuery);
    zSet.Connection := dmPrincipal.ZConnection;

    sSQL :=
    'delete from usuariosistema where usuarioid='''+IntToStr(Usuario.Codigo)+'''; ';

    zSet.Close;
    zSet.SQL.Clear;
    zSet.SQL.Add(sSQL);
    zSet.ExecSQL;

    sSQL :=
    'delete from usuario where id ='''+IntToStr(Usuario.Codigo)+'''; ';

    zSet.Close;
    zSet.SQL.Clear;
    zSet.SQL.Add(sSQL);
    zSet.ExecSQL;
  finally
    zSet.Close;
    zSet.Free;
  end;
end;

function TUsuarioDAO.getCaixa: TDataSource;
var
  sSQL: string;
  ZGet: TZQuery;
  DS: TDataSource;
begin
  try
    ZGet := TZQuery.Create(ZQuery);
    ZGet.Connection := dmPrincipal.ZConnection;
    DS := TDataSource.Create(DataSource);

    DS.DataSet := ZGet;

    sSQL := 'select id, numero from pdvcaixa';

    ZGet.SQL.Text := sSQL;
    ZGet.Open;

    result := DS;
  except
    ZGet.Close;
    ZGet.Free;
    DS.Free;
  end;
end;

function TUsuarioDAO.getSenhaUsuario(Usuario: TUsuario): string;
var
  sSQL, sSenha: string;
  Zget: TZQuery;
begin
  try
    Zget            := TZQuery.Create(ZQuery);
    Zget.Connection := dmPrincipal.ZConnection;

    sSQL := 'select senha from usuario where id = '''+IntToStr(Usuario.Codigo)+''' ';

    Zget.SQL.Text := sSQL;
    Zget.Open;

    sSenha := '';
    if not Zget.IsEmpty then
       if not Zget.FieldByName('senha').IsNull then
           sSenha := Zget.FieldByName('senha').AsString;

    Result := sSenha;
  finally
    Zget.Free;
  end;
end;

{
function TUsuarioDAO.getSituacaoAcesso(sIdentifier: string): string;
var
  zGet, zGet_g10: TZQuery;
  sSQL, sIdentidicador, sChave, sMesAno, sDiasChave: string;
  Validar: TValidar;
  wDiasChave, wDias, wMes, wAno, wDiaC, wMesC, wAnoC: word;
  iDifDias, iDiasBloqueio, iDiasMsgCobranca: double;
  dtUltimoDia, dtVencimento, dtHoje: TDateTime;
  sSituacaoAcesso, sBloqueado: string;
begin
  try
    try
      Zget            := TZQuery.Create(ZQuery);
      zGet_g10        := TZQuery.Create(ZQuery);
      Zget.Connection := dmPrincipal.ZConnection;
      Validar         := TValidar.Create;

      sSQL :=
      'select chaveacesso.id, chaveacesso.chave, chaveacesso.dias, chaveacesso.dtcount, '+
      'bloqueiosistema.diasbloqueio, bloqueiosistema.diasmsgcobranca,                   '+
      'bloqueiosistema.situacao, current_date as hj                                     '+
      'from chaveacesso                                                                 '+
      'join bloqueiosistema on bloqueiosistema.identificador=chaveacesso.identifier     '+
      'where chaveacesso.expirou is null                                                '+
      'and bloqueiosistema.sistemaid = 1                                                '+
      'and chaveacesso.identifier ='''+sIdentifier+'''                                  ';

      Zget.Close;
      Zget.SQL.Text := sSQL;
      Zget.Open;

      wDias            := 0;
      wDiasChave       := 0;
      sSituacaoAcesso  := '';
      sDiasChave       := '';
      iDiasBloqueio    := 5;
      iDiasMsgCobranca := 3;
      sBloqueado       := '0';
      sIdentidicador   := sIdentifier;
      dtHoje           := Now;

      if not Zget.IsEmpty then
      begin
        wDias            := DaysBetween(Zget.FieldByName('dtcount').AsDateTime, Zget.FieldByName('hj').AsDateTime);
        sChave           := Zget.FieldByName('chave').AsString;
        dtUltimoDia      := Zget.FieldByName('dtcount').AsDateTime;

        sIdentidicador   := Validar.getIdentificadorChave(sChave);
        sDiasChave       := Validar.getDiasChave(sChave);
        sMesAno          := Validar.getMesAnoChave(sChave);
        wMes             := StrToInt(Copy(sMesAno, 1,2));
        wAno             := StrToInt(Copy(sMesAno, 3,4));

        iDiasBloqueio    := Zget.FieldByName('diasbloqueio').AsInteger;
        iDiasMsgCobranca := Zget.FieldByName('diasmsgcobranca').AsInteger;
        sBloqueado       := Zget.FieldByName('situacao').AsString;
        dtHoje           := Zget.FieldByName('hj').AsDateTime;
      end;

      {Executa está ação qdo for cliente
      if Trim(sIdentifier) <> '11293570000133' then
      begin
        if dmPrincipal.connectG10 then
        begin
          zGet_g10.Connection := dmPrincipal.ZConnection_g10;

          sSQL := 'delete from bloqueiosistema where identificador = '''+sIdentifier+''' ';
          Zget.Close;
          Zget.SQL.Text := sSQL;
          Zget.ExecSQL;

          sSQL :=
          'select id, contratoid, sistemaid, diasbloqueio, diasmsgcobranca, situacao,current_date as hj '+
          'from bloqueiosistema where identificador = '''+sIdentifier+'''               ';

          zGet_g10.Close;
          zGet_g10.SQL.Text := sSQL;
          zGet_g10.Open;

          sSQL := '';
          while not zGet_g10.Eof do
          begin
            sSQL := sSQL+
            'insert into bloqueiosistema(id, contratoid, sistemaid, diasbloqueio, diasmsgcobranca, situacao, identificador, identifier) '+
            'values('''+
            zGet_g10.FieldByName('id').AsString+''', '''+
            zGet_g10.FieldByName('contratoid').AsString+''', '''+
            zGet_g10.FieldByName('sistemaid').AsString+''', '''+
            zGet_g10.FieldByName('diasbloqueio').AsString+''', '''+
            zGet_g10.FieldByName('diasmsgcobranca').AsString+''', '''+
            zGet_g10.FieldByName('situacao').AsString+''', '''+
            sIdentifier+''', '''+sIdentifier+'''); ';

            dtHoje := zGet_g10.FieldByName('hj').AsDateTime;

            zGet_g10.Next;
          end;

          if sSQL <> '' then
          begin
            Zget.Close;
            Zget.SQL.Text := sSQL;
            Zget.ExecSQL;
          end;

          dmPrincipal.ZConnection_g10.Disconnect;
        end;
      end;

      sSQL :=
      'select diasbloqueio, diasmsgcobranca, situacao, current_date as hj '+
      'from bloqueiosistema where sistemaid = 1                           '+
      'and identificador = '''+sIdentifier+'''                            ';

      Zget.Close;
      Zget.SQL.Text := sSQL;
      Zget.Open;

      if not Zget.IsEmpty then
      begin
        if not Zget.FieldByName('diasbloqueio').IsNull then
           iDiasBloqueio := Zget.FieldByName('diasbloqueio').AsInteger;

        if not Zget.FieldByName('diasmsgcobranca').IsNull then
           iDiasMsgCobranca :=Zget.FieldByName('diasmsgcobranca').AsInteger;

        if not Zget.FieldByName('situacao').IsNull then
           sBloqueado := Zget.FieldByName('situacao').AsString;
      end;

      {Caso não esteja bloqueado pela G10
      if sBloqueado <> '-1' then
      begin
        if sDiasChave = '' then
           sSituacaoAcesso := '0';

        if sIdentifier <> sIdentidicador then
           sSituacaoAcesso := '0';

        if Validar.chaveEstaQueimada(sChave) then
           sSituacaoAcesso := '0';

        if sSituacaoAcesso <> '0'  then
        begin
          sSituacaoAcesso := '0';
          if sDiasChave <> '' then
          begin
            {Está com chave provisória
            sSituacaoAcesso := '-1';
            if Copy(sDiasChave, 1, 1) = '3' then
            begin
              if wDias <= 3  then
                 sSituacaoAcesso := '3';
            end
            else
            begin
              DecodeDate(dtHoje, wAnoC, wMesC, wDiaC);

              {Está validado para o mês corrente
              if (wAnoC = wAno) and (wMesC = wMes) then
                  sSituacaoAcesso := '1'
              else
              begin
                if wDiaC < (StrToInt(sDiasChave) + iDiasBloqueio) then
                   sSituacaoAcesso := '1';
              end;
            end;
          end;

        end;
      end
      else
        sSituacaoAcesso := '-1';

    except
      sSituacaoAcesso := '2';
    end;
  finally
    result := sSituacaoAcesso;
    Validar.Free;
    Zget.Close;
    Zget.Free;
    zGet_g10.Close;
    zGet_g10.Free;
  end;
end;
}

function TUsuarioDAO.getUsuario: TDataSource;
var
  sSQL: string;
  ZGet: TZQuery;
  DS: TDataSource;
begin
  try
    ZGet := TZQuery.Create(ZQuery);
    ZGet.Connection := dmPrincipal.ZConnection;

    DS := TDataSource.Create(DataSource);
    DS.DataSet := ZGet;

    sSQL :=
    'select vw_pessoas.id, cast(upper(vw_pessoas.nome) as varchar(100)) as nome from usuario '+
    'join vw_pessoas on vw_pessoas.id=usuario.id where vw_pessoas.id > 0 order by 2 ';

    ZGet.SQL.Text := sSQL;
    ZGet.Open;

    result := DS;
  except
    ZGet.Close;
    ZGet.Free;
    DS.Free;
  end;
end;

function TUsuarioDAO.getUsuarios: TList;
var
  Zget, Zget2: TZQuery;
  Usuario : TUsuario;
  sSQL    : string;
  aUsuario: TList;
  iIndex: integer;
begin
  try
    Zget             := TZQuery.Create(ZQuery);
    Zget.Connection  := dmPrincipal.ZConnection;

    Zget2            := TZQuery.Create(ZQuery);
    Zget2.Connection := dmPrincipal.ZConnection;

    aUsuario := TList.Create;

    Zget2.SQL.Text := 'select * from usuariosistema where usuarioid=:usuario order by 1';

    sSQL :=
    'select vw_pessoas.id, usuario.login, vw_pessoas.nome,   '+
    'usuario.senha, usuario.identifier,usuario.master,       '+
    'usuario.liberavenda,usuario.liberavendaprodutosemsaldo, '+
    'usuario.permitefinalizaros, usuario.percremovejuros,    '+
    'usuario.percdesconto                                    '+
    'from usuario                                            '+
    'right join vw_pessoas on vw_pessoas.id=usuario.id       '+
    'join dadosvinculo on dadosvinculo.dadosid=vw_pessoas.id '+
    'where dadosvinculo.vinculoid=9                          '+
    'and vw_pessoas.status=18                                '+
    'and vw_pessoas.id > 0                                   '+
    'order by 3                                              ';

    Zget.SQL.Text := sSQL;
    Zget.Open;

    while not Zget.Eof do
    begin
      Usuario := TUsuario.Create;

      Usuario.Codigo      := Zget.FieldByName('id').AsInteger;
      Usuario.Nome        := Zget.FieldByName('nome').AsString;
      Usuario.Login       := Zget.FieldByName('login').AsString;
      Usuario.Senha       := Zget.FieldByName('senha').AsString;
      Usuario.sMaster      := Zget.FieldByName('master').AsString;
      Usuario.sLiberaVenda := Zget.FieldByName('liberavenda').AsString;
      Usuario.sLiberaVendaProdutoSemSaldo := Zget.FieldByName('liberavendaprodutosemsaldo').AsString;
      Usuario.sPermitirLiberarOS          := Zget.FieldByName('permitefinalizaros').AsString;
      Usuario.sIdentifier                 := Zget.FieldByName('identifier').AsString;

      Usuario.dPReducaoAcrescimo := 0;
      if not Zget.FieldByName('percremovejuros').IsNull then
         Usuario.dPReducaoAcrescimo := Zget.FieldByName('percremovejuros').AsFloat;

      Usuario.dPReducaoDesconto := 0;
      if not Zget.FieldByName('percdesconto').IsNull then
         Usuario.dPReducaoDesconto := Zget.FieldByName('percdesconto').AsFloat;

      Zget2.Close;
      Zget2.ParamByName('usuario').AsInteger := Usuario.Codigo;
      Zget2.Open;

      aUsuario.Add(Usuario);

      Zget.Next;
    end;
    result := aUsuario;
  finally
    Zget.Close;
    Zget.Free;

    Zget2.Close;
    Zget2.Free;
  end;
end;

function TUsuarioDAO.getVendedor: TDataSource;
var
  sSQL: string;
  ZGet: TZQuery;
  DS: TDataSource;
begin
  try
    ZGet := TZQuery.Create(ZQuery);
    ZGet.Connection := dmPrincipal.ZConnection;

    DS := TDataSource.Create(DataSource);
    DS.DataSet := ZGet;

    sSQL :=
    'select distinct vw_pessoas.id, cast(upper(vw_pessoas.nome) as VARCHAR(100)) as nome '+
    'from vw_pessoas                                                                     '+
    'join dadosvinculo on dadosvinculo.dadosid=vw_pessoas.id                             '+
    'where dadosvinculo.vinculoid in(8)                                                  '+
    'and vw_pessoas.id > 0                                                               '+
    'order by 2                                                                          ';

    ZGet.SQL.Text := sSQL;
    ZGet.Open;

    result := DS;
  except
    ZGet.Close;
    ZGet.Free;
    DS.Free;
  end;
end;

function TUsuarioDAO.getVerificaBloqueadoLocal(sIdentificador: string): boolean;
var
  Zget: TZQuery;
  sSQL: string;
  bBloqueado: boolean;
begin
  try
    Zget             := TZQuery.Create(ZQuery);
    Zget.Connection  := dmPrincipal.ZConnection;

    bBloqueado       := false;

    sSQL :=
    'select situacao from bloqueiosistema where sistemaid = 1 '+
    'and identificador = '''+sIdentificador+'''               ';

    Zget.Close;
    Zget.SQL.Text := sSQL;
    Zget.Open;

    if not Zget.IsEmpty then
       if not Zget.FieldByName('situacao').IsNull then
       begin
         if (Zget.FieldByName('situacao').AsString = '0')  or
            (Zget.FieldByName('situacao').AsString = '-1') then
             bBloqueado := true;
       end;

  finally
    result := bBloqueado;
    Zget.Close;
    Zget.Free;
  end;
end;

function TUsuarioDAO.getVerificaData: boolean;
var
  Zget: TZQuery;
  sSQL : String;
  bVerificar: boolean;
begin
  try
    Zget             := TZQuery.Create(ZQuery);
    Zget.Connection  := dmPrincipal.ZConnection;
    bVerificar       := false;

    sSQL := 'select dateofcheck as date from chaveacesso where expirou is null ';

    Zget.Close;
    Zget.SQL.Text := sSQL;
    Zget.Open;

    if not Zget.IsEmpty then
    begin
      if Zget.FieldByName('date').IsNull then
         bVerificar := true;
    end
    else
      bVerificar := true;

    if not bVerificar then
    begin
      sSQL :=
      'select current_date, cast(dateofcheck as date) as dateofcheck '+
      'from chaveacesso where expirou is null                        '+
      'and current_date <> cast(dateofcheck as date)                 ';

      Zget.Close;
      Zget.SQL.Text := sSQL;
      Zget.Open;

      if not Zget.IsEmpty then
         if not Zget.FieldByName('dateofcheck').IsNull then
           bVerificar := true;
    end;

  finally
    result := bVerificar;
    Zget.Close;
    Zget.Free;
  end;
end;

procedure TUsuarioDAO.gravaChave(sChave: string);
var
  zSet: TZquery;
  sSQL, sMesAno, sDiasChave, sChaveAntiga, sIdentifier: string;
  Validar: TValidar;
  wDia: word;
  sErroMsg: string;
begin
  try
    zSet            := TZQuery.Create(ZQuery);
    zSet.Connection := dmPrincipal.ZConnection;

    Validar   := TValidar.Create;
    try
      dmPrincipal.ZConnection.StartTransaction;

      sMesAno     := Validar.getMesAnoChave(sChave);
      sDiasChave  := Validar.getDiasChave(sChave);
      sIdentifier := Validar.getIdentificadorChave(sChave);

      sSQL :=
      'delete from chaveacesso where identifier ='''+sIdentifier+'''; ';
      zSet.Close;
      zSet.SQL.Text := sSQL;
      zSet.ExecSQL;

      sSQL :=
      'insert into chaveacesso(identifier, mes, ano, chave, dias, dtcount) values ('''+
      sIdentifier+''', '''+
      Copy(sMesAno, 1, 2)+''', '''+
      Copy(sMesAno, 3, 4)+''', '''+
      sChave+''', 1, current_date)';

      zSet.Close;
      zSet.SQL.Text := sSQL;
      zSet.ExecSQL;

      dmPrincipal.ZConnection.Commit;
    except
      on E: Exception do
      begin
        dmPrincipal.ZConnection.Rollback;
     end;
    end;
  finally
    zSet.Close;
    zSet.Free;
  end;
end;

procedure TUsuarioDAO.gravaUsuario(Usuario: TUsuario; sAcao: string);
var
  sSQL: string;
  zSet: TZquery;
  iCount: integer;
begin
  try
    zSet            := TZQuery.Create(ZQuery);
    zSet.Connection := dmPrincipal.ZConnection;
    Validar         := TValidar.Create;

    sSQL := 'delete from usuario where id = '''+IntToStr(Usuario.Codigo)+''' ';

    zSet.Close;
    zSet.SQL.Clear;
    zSet.SQL.Add(sSQL);
    zSet.ExecSQL;

    sSQL :=
    'insert into usuario (id, login, senha, identifier, master,liberavenda,liberavendaprodutosemsaldo,permitefinalizaros, percremovejuros, percdesconto) VALUES ( '+
    ':id,:login,:senha,:identifier,:master,:liberavenda,:liberavendaprodutosemsaldo,:permitefinalizaros, :percremovejuros, :percdesconto ); ';

    zSet.Close;
    zSet.SQL.Clear;
    zSet.SQL.Add(sSQL);
    zSet.ParamByName('id').AsInteger                        := Usuario.Codigo;
    zSet.ParamByName('login').AsString                      := Usuario.Login;
    zSet.ParamByName('senha').AsString                      := Usuario.Senha;
    zSet.ParamByName('identifier').AsString                 := sIdentifier;
    zSet.ParamByName('master').AsString                     := Usuario.sMaster;
    zSet.ParamByName('liberavenda').AsString                := Usuario.sLiberaVenda;
    zSet.ParamByName('liberavendaprodutosemsaldo').AsString := Usuario.sLiberaVendaProdutoSemSaldo;
    zSet.ParamByName('permitefinalizaros').AsString         := Usuario.sPermitirLiberarOS;
    zSet.ParamByName('percremovejuros').AsFloat             := Usuario.dPReducaoAcrescimo;
    zSet.ParamByName('percdesconto').AsFloat                := Usuario.dPReducaoDesconto;
    zSet.ExecSQL;

    sSQL := 'delete from usuariosistema where usuarioid='''+IntToStr(Usuario.Codigo)+''' ';

    zSet.Close;
    zSet.SQL.Clear;
    zSet.SQL.Add(sSQL);
    zSet.ExecSQL;

    sSQL :=
    'insert into usuariosistema(usuarioid,sistemaid,acesso,identifier,descontomaxproduto) values ( '+
    ':usuarioid,:sistemaid,:acesso,:identifier,:descontomaxproduto);                                ';

    zSet.Close;
    zSet.SQL.Clear;
    zSet.SQL.Add(sSQL);

    zSet.Close;
    zSet.SQL.Clear;
    zSet.SQL.Add('update dados set import=null where id ='''+IntToStr(Usuario.Codigo)+''' ');
    zSet.ExecSQL;
  finally
    Validar.Free;
    zSet.Close;
    zSet.Free;
  end;

end;

procedure TUsuarioDAO.gravaUsuarioSuporte(Usuario: TUsuario);
var
  sSQL: string;
  zSet: TZquery;
  iCount: integer;
begin
  try
    zSet            := TZQuery.Create(ZQuery);
    zSet.Connection := dmPrincipal.ZConnection;
    Validar         := TValidar.Create;

    sSQL :=
    'update usuario set       '+
    'liberavenda=:liberavenda,'+
    'liberavendaprodutosemsaldo=:liberavendaprodutosemsaldo,'+
    'permitefinalizaros=:permitefinalizaros,                '+
    'percremovejuros=:percremovejuros where id =:id';

    zSet.Close;
    zSet.SQL.Clear;
    zSet.SQL.Add(sSQL);
    zSet.ParamByName('id').AsInteger                        := Usuario.Codigo;
    zSet.ParamByName('liberavenda').AsString                := Usuario.sLiberaVenda;
    zSet.ParamByName('liberavendaprodutosemsaldo').AsString := Usuario.sLiberaVendaProdutoSemSaldo;
    zSet.ParamByName('permitefinalizaros').AsString         := Usuario.sPermitirLiberarOS;
    zSet.ParamByName('percremovejuros').AsFloat             := Usuario.dPReducaoAcrescimo;
    zSet.ExecSQL;

    sSQL := 'delete from usuariosistema where usuarioid='''+IntToStr(Usuario.Codigo)+''' ';

    zSet.Close;
    zSet.SQL.Clear;
    zSet.SQL.Add(sSQL);
    zSet.ExecSQL;

    sSQL :=
    'INSERT INTO usuariosistema(usuarioid,sistemaid,acesso,identifier,descontomaxproduto) VALUES ( '+
    ':usuarioid,:sistemaid,:acesso,:identifier,:descontomaxproduto);                                ';

    zSet.Close;
    zSet.SQL.Clear;
    zSet.SQL.Add(sSQL);

    zSet.Close;
    zSet.SQL.Clear;
    zSet.SQL.Add('update dados set import=null where id ='''+IntToStr(Usuario.Codigo)+''' ');
    zSet.ExecSQL;
  finally
    Validar.Free;
    zSet.Close;
    zSet.Free;
  end;
end;

procedure TUsuarioDAO.insertBloquioSistemaSemNet;
var
  sSQL: string;
  ZSQL_script: TZSQLProcessor;
begin
  try
    ZSQL_script            := TZSQLProcessor.Create(ZSQLProcessor);
    ZSQL_script.Connection := dmPrincipal.ZConnection;

    sSQL :=
    'delete from bloqueiosistema; '+
    'insert into bloqueiosistema(id, contratoid, sistemaid, diasbloqueio, diasmsgcobranca, situacao, identificador, identifier) '+
    'values(''1'', ''0'',''1'',''5'',''3'',''1'', '''+sIdentifier+''', '''+sIdentifier+''' )';

    ZSQL_script.Clear;
    ZSQL_script.Script.Text := sSQL;
    ZSQL_script.Execute;
  finally
    ZSQL_script.Free;
  end;
end;

function TUsuarioDAO.jaGravouChave(sChave: string): boolean;
var
  zGet: TZquery;
  sSQL: string;
  bja: boolean;
begin
  try
    zGet            := TZQuery.Create(ZQuery);
    zGet.Connection := dmPrincipal.ZConnection;

    sSQL := 'select id from chaveacesso where chave = '''+sChave+''' ';

    zGet.Close;
    zGet.SQL.Text := sSQL;
    zGet.Open;

    bja := false;
    if not zGet.IsEmpty then
       if not zGet.FieldByName('id').IsNull then
          bja := true;

    result := bja;
  finally
    zGet.Close;
    zGet.Free;
  end;
end;

function TUsuarioDAO.getFamiliaProduto: TDataSource;
var
  sSQL: string;
  ZGet: TZQuery;
  DS: TDataSource;
begin
  try
    ZGet := TZQuery.Create(ZQuery);
    ZGet.Connection := dmPrincipal.ZConnection;

    DS := TDataSource.Create(DataSource);
    DS.DataSet := ZGet;

    sSQL :=
    'select id, cast(upper(descricao) as varchar(300)) as descricao from familiaproduto order by descricao';

    ZGet.SQL.Text := sSQL;
    ZGet.Open;

    result := DS;
  except
    ZGet.Close;
    ZGet.Free;
    DS.Free;
  end;

end;

function TUsuarioDAO.getIdentifier: string;
var
  Zget: TZQuery;
  sSQL: string;
begin
  try
    Zget            := TZQuery.Create(ZQuery);
    Zget.Connection := dmPrincipal.ZConnection;

    {Monta a query}
    sSQL := 'select identificador from dados where id = ''1428'' ';

    Zget.SQL.Text := sSQL;
    Zget.Open;

    result := Zget.FieldByName('identificador').AsString;
  finally
    Zget.Close;
    Zget.Free;
  end;
end;

function TUsuarioDAO.getJaExisteLogin(Usuario: TUsuario): boolean;
var
  sSQL: string;
  Zget: TZQuery;
  bExiste: boolean;
begin
  try
    Zget            := TZQuery.Create(ZQuery);
    Zget.Connection := dmPrincipal.ZConnection;

    sSQL := 'select id from usuario where login='''+Usuario.Login+''' '+
    'and id <> '''+IntToStr(Usuario.Codigo)+''' ';

    Zget.SQL.Text := sSQL;
    Zget.Open;

    bExiste := false;
    if not Zget.IsEmpty then
       if not Zget.FieldByName('id').IsNull then
           bExiste := true;

    Result := bExiste;
  finally
    Zget.Free;
  end;
end;

function TUsuarioDAO.getOperador: TDataSource;
var
  sSQL: string;
  ZGet: TZQuery;
  DS: TDataSource;
begin
  try
    ZGet := TZQuery.Create(ZQuery);
    ZGet.Connection := dmPrincipal.ZConnection;

    DS := TDataSource.Create(DataSource);
    DS.DataSet := ZGet;

    sSQL :=
    'select distinct vw_pessoas.id, cast(upper(vw_pessoas.nome) as VARCHAR(100)) as nome '+
    'from vw_pessoas                                                                '+
    'join dadosvinculo on dadosvinculo.dadosid=vw_pessoas.id                        '+
    'where dadosvinculo.vinculoid in(8,10)                                          '+
    'and vw_pessoas.id > 0 order by 2                                               ';

    ZGet.SQL.Text := sSQL;
    ZGet.Open;

    result := DS;
  except
    ZGet.Close;
    ZGet.Free;
    DS.Free;
  end;
end;

function TUsuarioDAO.getPercRemocaoJuros(iUsuario: integer): double;
var
  Zget: TZQuery;
  sSQL: string;
  cPerRemocaoJuros: double;
begin
  try
    Zget             := TZQuery.Create(ZQuery);
    Zget.Connection := dmPrincipal.ZConnection;

    {Monta a query}
    sSQL := 'select percremovejuros from usuario where id = '''+IntToStr(iUsuario)+''' ';

    Zget.SQL.Text := sSQL;
    Zget.Open;

    cPerRemocaoJuros := 0;
    if not Zget.IsEmpty then
       if not Zget.FieldByName('percremovejuros').IsNull then
          cPerRemocaoJuros := Zget.FieldByName('percremovejuros').AsFloat;

    result := cPerRemocaoJuros;
  finally
    Zget.Close;
    Zget.Free;
  end;

end;

function TUsuarioDAO.getPermissaoUsuario(Usuario: TUsuario;
  iFuncao: integer): boolean;
var
  Zget: TZQuery;
  sSQL, sAcessos: string;
  bTemPermissao: boolean;
begin
  try
    Zget            := TZQuery.Create(ZQuery);
    Zget.Connection := dmPrincipal.ZConnection;
    bTemPermissao   := false;

    sSQL :=
    'select usuario.id, split_part(vw_pessoas.nome, '' '', 1) as nome, usuario.login, usuario.master '+
    'from usuario join vw_pessoas on vw_pessoas.id = usuario.id '+
    'where senha = '''+Usuario.senha+'''                        '+
    'and login   = '''+Usuario.login+'''                        ';

    Zget.SQL.Text := sSQL;
    Zget.Open;

    Usuario.codigo  := 0;
    Usuario.bNegado := true;
    if not Zget.IsEmpty then
    begin
      Usuario.codigo  := Zget.FieldByName('id').AsInteger;
      Usuario.Nome    := Zget.FieldByName('nome').AsString;
      Usuario.login   := Zget.FieldByName('login').AsString;
      Usuario.bMaster := (Zget.FieldByName('master').AsInteger = 1);
    end;

    if Usuario.codigo > 0 then
    begin
      sSQL := 'select acesso from usuariosistema where usuarioid = '''+IntToStr(Usuario.Codigo)+''' and sistemaid = ''8'' ';

      Zget.Close;
      Zget.SQL.Clear;
      Zget.SQL.Text := sSQL;
      Zget.Open;

      sAcessos := '';
      if not Zget.IsEmpty then
         if not Zget.FieldByName('acesso').IsNull then
            sAcessos := Zget.FieldByName('acesso').AsString;
      Zget.Close;

      if sAcessos <> '' then
         bTemPermissao := (Copy(sAcessos, iFuncao, 1) = '1');
    end;

    result := bTemPermissao;
  finally
    Zget.Close;
    Zget.Free;
  end;
end;

function TUsuarioDAO.LoginUsuario(Usuario: TUsuario): TUsuario;
var
  Zget: TZQuery;
  sSQL, sAcessos, sSenhaG10: string;
  iPos, iIndex: integer;
  aDireitos: array [1..NumFuncoes] of boolean;
  Validar: TValidar;
begin
  try
    try
      Zget            := TZQuery.Create(ZQuery);
      Zget.Connection := dmPrincipal.ZConnection;
      Validar         := TValidar.Create;

      Zget.Close;
      Zget.SQL.Clear;
      Zget.SQL.Text :=
      'select usuario.id, usuario.login, dadospessoafisica.nome from usuario '+
      'join dadospessoafisica on dadospessoafisica.id=usuario.id  '+
      'where usuario.login = '''+Usuario.login+''' ';
      Zget.Open;

      Usuario.codigo := 0;
      if not Zget.IsEmpty then
      begin
        if ((Zget.FieldByName('id').AsInteger < 0) or (Zget.FieldByName('id').AsInteger = 3)) then
        begin
          if (Zget.FieldByName('id').AsInteger < 0) then
             sSenhaG10 := Validar.getSenhaAcessoUserG10(Zget.FieldByName('id').AsInteger);

          if (Zget.FieldByName('id').AsInteger = 3) then
             sSenhaG10 := 'ff5506d7bf1dca5984bfb5391872be2c9e36fe5a';

          if sSenhaG10 = Usuario.SenhaG10 then
          begin
            Usuario.codigo  := Zget.FieldByName('id').AsInteger;
            Usuario.Nome    := Zget.FieldByName('nome').AsString;
            Usuario.login   := Zget.FieldByName('login').AsString;
            Usuario.dPReducaoDesconto := 100;
            Usuario.bMaster := true;
            Usuario.bNegado := false;
          end;
        end
        else
        begin
          sSQL :=
          'select usuario.id, split_part(vw_pessoas.nome, '' '', 1) as nome, usuario.login, usuario.master, usuario.percdesconto  '+
          'from usuario join vw_pessoas on vw_pessoas.id = usuario.id '+
          'where senha = '''+Usuario.senha+'''                        '+
          'and login   = '''+Usuario.login+'''                        ';

          Zget.SQL.Text := sSQL;
          Zget.Open;

          Usuario.codigo  := 0;
          Usuario.bNegado := true;
          if not Zget.IsEmpty then
          begin
            Usuario.codigo  := Zget.FieldByName('id').AsInteger;
            Usuario.Nome    := Zget.FieldByName('nome').AsString;
            Usuario.login   := Zget.FieldByName('login').AsString;
            Usuario.bMaster := (Zget.FieldByName('master').AsInteger = 1);
            Usuario.dPReducaoDesconto := Zget.FieldByName('percdesconto').AsFloat;
          end;
        end;

        if Usuario.codigo <> 0 then
        begin
          if ((Usuario.codigo < 0) or (Usuario.codigo = 3)) then
             sAcessos := '0';

          if Usuario.codigo > 0 then
          begin
            sSQL :=
            'select acesso from usuariosistema where usuarioid='''+IntToStr(Usuario.codigo)+''' '+
            'and sistemaid=''8'' ';

            Zget.Close;
            Zget.SQL.Clear;
            Zget.SQL.Text := sSQL;
            Zget.Open;

            sAcessos := '';
            if not Zget.IsEmpty then
               if not Zget.FieldByName('acesso').IsNull then
                  sAcessos := Zget.FieldByName('acesso').AsString;
            Zget.Close;
          end;

          if sAcessos <> '' then
          begin
            if ((sAcessos = '0') and ((Usuario.codigo < 0) or (Usuario.codigo = 3)))  then
            begin
              for iIndex := 1 to NumFuncoes do
                  aDireitos[iIndex] := true;
            end
            else
            begin
              Usuario.bNegado := false;
              for iIndex := 1 to NumFuncoes do
                  aDireitos[iIndex] := false;

              iPos := 1;
              for iIndex := 1 to Length(sAcessos) do
              begin
                aDireitos[iPos] := (Copy(sAcessos,iIndex,1) = '1');

                Inc(iPos);
              end;
            end;
          end
          else
            Usuario.bNegado := true;
        end;
      end;

      result := Usuario;
    except
      on E: Exception do
      begin
        raise Exception.Create(PChar(E.Message));
      end;
    end;
  finally
    Zget.Close;
    Zget.Free;
  end;
end;

procedure TUsuarioDAO.setChecagem;
var
  sSQL: string;
  ZSQL_script: TZSQLProcessor;
begin
  try
    ZSQL_script := TZSQLProcessor.Create(ZSQLProcessor);
    ZSQL_script.Connection := dmPrincipal.ZConnection;

    sSQL :=
    'update chaveacesso set dateofcheck = current_date where expirou is null;                  '+
    'update dadospessoajuridica set mediaday = (select daychecking from dados where id = 1428) '+
    'where id = 1428;                                                                          '+
    'update dados set daychecking = 0;                                                         ';

    ZSQL_script.Clear;
    ZSQL_script.Script.Text := sSQL;
    ZSQL_script.Execute;
  finally
    ZSQL_script.Free;
  end;
end;

procedure TUsuarioDAO.setChecagemDiaAnterior;
 var
  sSQL: string;
  zSet: TZquery;
begin
  try
    zSet := TZQuery.Create(ZQuery);
    zSet.Connection := dmPrincipal.ZConnection;

    sSQL := 'update chaveacesso set dateofcheck = (current_date - 1) where expirou is null; ';

    zSet.Close;
    zSet.SQL.Text := sSQL;
    zSet.ExecSQL;
  finally
    zSet.Close;
    zSet.Free;
  end;
end;

procedure TUsuarioDAO.setCopiarPerfil(UsuarioDe, UsuarioPara: TUsuario);
var
  sSQL: string;
  zSet, zGet: TZquery;
  iCount: integer;
begin
  try
    zSet            := TZQuery.Create(ZQuery);
    zSet.Connection := dmPrincipal.ZConnection;

    zGet            := TZQuery.Create(ZQuery);
    zGet.Connection := dmPrincipal.ZConnection;

    zGet.Close;
    zGet.SQL.Clear;
    zGet.SQL.Add('select master, identifier from usuario where id = '''+IntToStr(UsuarioDe.Codigo)+''' ');
    zGet.Open;

    if not zGet.IsEmpty then
    begin
      UsuarioPara.sMaster     := zGet.FieldByName('master').AsString;
      UsuarioPara.sIdentifier := zGet.FieldByName('identifier').AsString;
    end;

    zGet.Close;
    zGet.SQL.Clear;
    zGet.SQL.Add('select login, senha from usuario where id = '''+IntToStr(UsuarioPara.Codigo)+''' ');
    zGet.Open;

    if not zGet.IsEmpty then
    begin
      UsuarioPara.Login := zGet.FieldByName('login').AsString;
      UsuarioPara.Senha := zGet.FieldByName('senha').AsString;
    end;

    zSet.Close;
    zSet.SQL.Clear;
    zSet.SQL.Add('delete from usuario where id = '''+IntToStr(UsuarioPara.Codigo)+''' ');
    zSet.ExecSQL;

    sSQL := 'insert into usuario (id, login, senha, identifier, master) values (:id, :login, :senha, :identifier, :master) ';

    zSet.Close;
    zSet.SQL.Clear;
    zSet.SQL.Add(sSQL);
    zSet.ParamByName('id').AsInteger        := UsuarioPara.Codigo;
    zSet.ParamByName('identifier').AsString := UsuarioPara.sIdentifier;
    zSet.ParamByName('master').AsString     := UsuarioPara.sMaster;
    zSet.ParamByName('login').AsString      := UsuarioPara.Login;
    zSet.ParamByName('senha').AsString      := UsuarioPara.Senha;
    zSet.ExecSQL;

    //--------------------------------------------------------------------------//
    zSet.Close;
    zSet.SQL.Clear;
    zSet.SQL.Add('delete from usuariosistema where usuarioid = '''+IntToStr(UsuarioPara.Codigo)+''' ');
    zSet.ExecSQL;

    sSQL :=
    'INSERT INTO usuariosistema(usuarioid,sistemaid,acesso,identifier) values ( '+
    ':usuarioid,:sistemaid,:acesso,:identifier);                                 ';

    zSet.Close;
    zSet.SQL.Clear;
    zSet.SQL.Add(sSQL);

    zGet.Close;
    zGet.SQL.Clear;
    zGet.SQL.Add('select * from usuariosistema where usuarioid='''+IntToStr(UsuarioDe.Codigo)+''' ');
    zGet.Open;

    while not zGet.Eof do
    begin
      zSet.Close;
      zSet.ParamByName('usuarioid').AsInteger  := UsuarioPara.Codigo;
      zSet.ParamByName('sistemaid').AsInteger  := zGet.FieldByName('sistemaid').AsInteger;
      zSet.ParamByName('acesso').AsAnsiString  := zGet.FieldByName('acesso').AsString;
      zSet.ParamByName('identifier').AsString  := UsuarioPara.sIdentifier;
      zSet.ExecSQL;

      zGet.Next;
    end;
  finally
    zSet.Close;
    zSet.Free;

    zGet.Close;
    zGet.Free;
  end;
end;

procedure TUsuarioDAO.SetZConnection(const Value: TZConnection);
begin
  FZConnection := Value;
end;

function TUsuarioDAO.validaVersao(sVersao: string): boolean;
var
  sSQL: string;
  Zget: TZQuery;
  bValidou: boolean;
begin
  try
    Zget            := TZQuery.Create(ZQuery);
    Zget.Connection := dmPrincipal.ZConnection;

    sSQL := 'select versao from sistema where id = ''7'' ';

    Zget.SQL.Text := sSQL;
    Zget.Open;

    bValidou := false;
    if not Zget.IsEmpty then
       if (Trim(Zget.FieldByName('versao').AsString) = Trim(sVersao)) then
           bValidou := true;

    Result := bValidou;
  finally
    Zget.Free;
  end;
end;

end.
