unit TipoJurosDAO;

interface

uses
  TipoJuros, DB, ZAbstractRODataset, ZAbstractDataset,
  ZDataset, SysUtils, ZConnection, uDMPrincipal;

type
  TTipoJurosDao = class

  private
    zquery : TZQuery;
    dataSource: TDataSource;

  public
    procedure editar(tipoJuros : TTipoJuros);
    procedure excluir(tipoJuros: TTipoJuros);
    function incluir(tipoJuros: TTipoJuros): String;
    procedure pesquisar(zGet: TZquery; TipoJuros: TTipoJuros);
    function verificaExclusao(tipoJuros : TTipoJuros): boolean;
  end;

implementation

{ TTipoJurosDao }



{ TTipoJurosDao }

procedure TTipoJurosDao.editar(tipoJuros: TTipoJuros);
var
  zSet: TZQuery;
  sSQL: string;
begin
  try
    zSet := TZQuery.Create(ZQuery);
    zSet.Connection := dmPrincipal.ZConnection;

    sSQL :=  'update tipojuros set '+
    'descricao = '''+tipoJuros.getDescricao+''' '+
    'where id  = '''+IntToStr(tipoJuros.getCodigo)+''' ';

    zSet.Close;
    zSet.SQL.Text := sSQL;
    zSet.ExecSQL;
  finally
    zSet.Close;
    zSet.Free;
  end;
end;

procedure TTipoJurosDao.excluir(tipoJuros: TTipoJuros);
var
  zSet: TZQuery;
  sSQL: string;
begin
  try
    zSet := TZQuery.Create(ZQuery);
    zSet.Connection := dmPrincipal.ZConnection;

    sSQL := 'delete from tipojuros where id = '+IntToStr(tipoJuros.getCodigo);

    zSet.Close;
    zSet.SQL.Text := sSQL;
    zSet.ExecSQL;
  finally
    zSet.Close;
    zSet.Free;
  end;
end;

function TTipoJurosDao.incluir(tipoJuros: TTipoJuros): String;
var
  zSet: TZQuery;
  sSQL: string;
begin
  try
    zSet := TZQuery.Create(ZQuery);
    zSet.Connection := dmPrincipal.ZConnection;

    dmPrincipal.ZConnection.StartTransaction;
    try
      sSQL := 'insert into tipojuros (descricao, identifier) '+
      'values ('''+tipoJuros.getDescricao+''', 34107328000123) ';

      zSet.Close;
      zSet.SQL.Text := sSQL;
      zSet.ExecSQL;

      zSet.Close;
      zSet.SQL.Clear;
      zSet.SQL.Text := 'select currval(''tipojuros_id_seq'') as id';
      zSet.Open;

      if not zSet.IsEmpty then
        result := zSet.FieldByName('id').AsString;

      dmPrincipal.ZConnection.Commit;
    except
      dmPrincipal.ZConnection.Rollback;
    end;
  finally
    zSet.Close;
    zSet.Free;
  end;
end;

procedure TTipoJurosDao.pesquisar(zGet: TZquery; TipoJuros: TTipoJuros);
var
  sSQL: string;
begin
  zGet.Connection := dmPrincipal.ZConnection;

  sSQL := 'select id as codigo, cast(upper(descricao) as varchar(100)) as descricao from tipojuros where id is not null ';

  if tipoJuros.getDescricao <> '' then
     sSQL := sSQL + 'and descricao = '''+tipoJuros.getDescricao+''' ';

   if tipoJuros.getCodigo > 0 then
     sSQL := sSQL + 'and id = '''+InttoStr(tipoJuros.getCodigo)+''' ';

  zGet.Close;
  zGet.SQL.Clear;
  zGet.SQL.Text := sSQL;
  zGet.Open;
end;

function TTipoJurosDao.verificaExclusao(tipoJuros : TTipoJuros): boolean;
var
  zGet : TZquery;
  sSQL: string;
  bExiste: boolean;
begin
  try
  zGet := TZQuery.Create(ZQuery);
  zGet.Connection := dmPrincipal.ZConnection;

  sSQL := 'select id from juros where juros.tipojurosid = '''+Inttostr(tipoJuros.getCodigo)+''' limit 1 ';
    zGet.Close;
    zGet.SQL.Text := sSQL;
    zGet.Open;

    bExiste := false;
    if not zGet.IsEmpty then
       if not zGet.FieldByName('id').IsNull then
          bExiste := true;

  finally
    result := bExiste;
    zGet.Close;
    zGet.Free;
  end;
end;
end.
