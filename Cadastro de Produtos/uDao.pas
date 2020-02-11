unit uDao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ZAbstractConnection, ZConnection;

type
  TfrmDao = class(TForm)
    ZConnection1: TZConnection;
    ZQuery1: TZQuery;
    DataSource1: TDataSource;

  private
    { Private declarations }
  public
    { Public declarations }
  //Funções do Sql
  procedure SelectTudo();
  procedure sqlSelect(opcao: Integer; descricao, codigo: String);
  procedure sqlDelete(id: Integer);
  procedure sqlUpdate (id: Integer; codigo, descricao: String);
  procedure sqlInsert(codigo, descricao: String);
  end;

var
  frmDao: TfrmDao;

implementation

{$R *.dfm}

uses uControls;

procedure TfrmDao.sqlInsert(codigo: string; descricao: string);
begin
  ZQuery1.SQL.Text := 'insert into tipoproduto (descricao, codigo) values ('''+descricao+''' , '''+codigo+''')';
  ZQuery1.ExecSQL;
end;

procedure TfrmDao.sqlDelete(id: Integer);
begin
  ZQuery1.SQL.Text := 'delete from tipoproduto where tipoproduto.id = '''+IntToStr(id)+''' ';
  ZQuery1.ExecSQL;
end;

procedure  TfrmDao.sqlUpdate(id: Integer; codigo: string; descricao: string);
begin
  ZQuery1.SQL.Text := 'update tipoproduto set codigo = '''+codigo+''', descricao = '''+descricao+''' where id = '''+InttoStr(id)+''' ';
  ZQuery1.ExecSQL;
end;

procedure  TfrmDao.sqlSelect(opcao: Integer; descricao: string; codigo: string);
begin
  case opcao of
     1: ZQuery1.SQL.Text := 'select tipoproduto.id, tipoproduto.codigo, cast (tipoproduto.descricao as varchar (50)) as descricao from tipoproduto where descricao = '''+descricao+''' and codigo = '''+codigo+''' ';
     2: ZQuery1.SQL.Text := 'select tipoproduto.id, tipoproduto.codigo, cast (tipoproduto.descricao as varchar (50)) as descricao from tipoproduto where codigo = '''+codigo+''' ';
     3: ZQuery1.SQL.Text := 'select tipoproduto.id, tipoproduto.codigo, cast (tipoproduto.descricao as varchar (50)) as descricao from tipoproduto where descricao = '''+descricao+''' ';
  end;
  ZQuery1.Open;
end;

procedure TfrmDao.SelectTudo;
begin
  ZQuery1.SQL.Text := 'select tipoproduto.id, tipoproduto.codigo, cast (tipoproduto.descricao as varchar (50)) as descricao from tipoproduto where id is not null';
  ZQuery1.Open;

  ZQuery1.SQL.Text := 'select tipoproduto.id, tipoproduto.codigo, cast (tipoproduto.descricao as varchar (50)) as descricao from tipoproduto order by id asc';
  ZQuery1.Open;
end;

end.

