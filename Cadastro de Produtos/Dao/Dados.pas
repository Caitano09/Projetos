unit Dados;

interface
uses
Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, uDm;
type
  Tdados = class
  private

  public
  class procedure sqlImpressao( dataInicio, dataFim: TDate);
  class procedure verificaExclusão(id: Integer);
  class procedure selectTudo();
  class procedure sqlSelect(opcao: Integer; descricao, codigo: String);
  class procedure sqlDelete(id: Integer);
  class procedure sqlUpdate (id: Integer; codigo, descricao: String);
  class procedure sqlInsert(codigo, descricao: String);

end;

implementation

uses Controls;


//Insert
class procedure TDados.sqlInsert(codigo: string; descricao: string);
begin

    DataModule1.ZQuery1.SQL.Text := 'insert into tipoproduto (descricao, codigo) values ('''+descricao+''' , '''+codigo+''')';
    DataModule1.ZQuery1.ExecSQL;
end;

//Delete
class procedure TDados.sqlDelete(id: Integer);
begin
    DataModule1.ZQuery1.SQL.Text := 'delete from tipoproduto where tipoproduto.id = '''+IntToStr(id)+''' ';
    DataModule1.ZQuery1.ExecSQL;
end;

//Update
class procedure  TDados.sqlUpdate(id: Integer; codigo: string; descricao: string);
begin
    DataModule1.ZQuery1.SQL.Text := 'update tipoproduto set codigo = '''+codigo+''', descricao = '''+descricao+''' where id = '''+InttoStr(id)+''' ';
    DataModule1.ZQuery1.ExecSQL;
end;

class procedure Tdados.verificaExclusão(id: Integer);
begin
  DataModule1.ZQuery1.SQL.Text := 'select * from produto where produto.tipoprodutoid = '''+Inttostr(id)+''' limit 1 ';
  DataModule1.ZQuery1.Open;
  end;


//Select
class procedure  TDados.sqlSelect(opcao: Integer; descricao: string; codigo: string);
begin
  case opcao of
     1:   DataModule1.ZQuery1.SQL.Text := 'select tipoproduto.id, tipoproduto.codigo, cast (tipoproduto.descricao as varchar (50)) as descricao from tipoproduto where descricao ilike ''%'+descricao+'%'' and codigo = '''+codigo+''' ';
     2:   DataModule1.ZQuery1.SQL.Text := 'select tipoproduto.id, tipoproduto.codigo, cast (tipoproduto.descricao as varchar (50)) as descricao from tipoproduto where codigo = '''+codigo+''' ';
     3:   DataModule1.ZQuery1.SQL.Text := 'select tipoproduto.id, tipoproduto.codigo, cast (tipoproduto.descricao as varchar (50)) as descricao from tipoproduto where descricao ilike ''%'+descricao+'%'' ';
  end;
    DataModule1.ZQuery1.Open;
end;

//Select Tudo
class procedure TDados.selectTudo();
begin
    DataModule1.ZQuery1.SQL.Text := 'select tipoproduto.id, tipoproduto.codigo, cast (tipoproduto.descricao as varchar (50)) as descricao from tipoproduto where id is not null';
    DataModule1.ZQuery1.Open;

    DataModule1.ZQuery1.SQL.Text := 'select tipoproduto.id, tipoproduto.codigo, cast (tipoproduto.descricao as varchar (50)) as descricao from tipoproduto order by id asc';
    DataModule1.ZQuery1.Open;
end;

class procedure Tdados.sqlImpressao(dataInicio: TDate; dataFim: TDate);
begin
  DataModule1.ZQuery3.SQL.Text := 'select parcela.id as parcelaid, parcela.numerodocumento, parcela.valor as parcelavalor,'
  + ' statusgrupo.descricao as status,	parcela.datavencimento, titulo.valor as titulovalor, titulo.id as tituloid'
  + ' from parcela'
  + ' join titulo on parcela.tituloid = titulo.id'
  + ' join statusgrupo on statusgrupo.id = parcela.statusgrupoid'
  + ' where parcela.datavencimento >= '''+DateToStr(dataInicio)+''' and parcela.datavencimento <= '''+DateToStr(dataFim)+''' ';
  DataModule1.ZQuery3.Open;
end;
end.
