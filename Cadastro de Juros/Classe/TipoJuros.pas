unit TipoJuros;

interface

type
  TTipoJuros = class

    private
      codigo : integer;
      descricao: string;

    public
      constructor Create();
      procedure setCodigo(cod: integer);
      procedure setDescricao (desc: String);
      function getCodigo(): Integer;
      function getDescricao(): String;

  end;

implementation

{ TTipoProduto }

constructor TTipoJuros.Create();
begin
   // inherited Create;
end;

function TTipoJuros.getCodigo: Integer;
begin
    result := codigo;
end;

function TTipoJuros.getDescricao: String;
begin
    result := descricao;
end;

procedure TTipoJuros.setCodigo(cod: integer);
begin
    codigo := cod;
end;

procedure TTipoJuros.setDescricao(desc: String);
begin
    descricao := desc;
end;

end.
