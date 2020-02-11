unit Juros;

interface

uses TipoJuros;

type
  TJuros = class

    private
      codigo: integer;
      juros: double;
      mora: double;
      acrescimo: double;
      diaAtraso: integer;
      statusGrupo: integer;
      TipoJuros: TTipoJuros;

    public
      constructor Create();
      destructor Destroy(); override;

      function getCodigo(): Integer;
      function getJuros(): double;
      function getMora(): double;
      function getAcrescimo(): double;
      function getDiaAtraso(): Integer;
      function getStatusGrupo(): Integer;
      function getTipoJuros(): TTipoJuros;

      procedure setCodigo(cod: Integer);
      procedure setJuros(juro: double);
      procedure setMora(mor: double);
      procedure setAcrescimo(acres: double);
      procedure setDiaAtraso(dia: integer);
      procedure setStatusGrupo(status: Integer);
      procedure setTipoJuros(tjuro: TTipoJuros);

  end;

implementation

constructor TJuros.Create();
begin
  codigo := -1;
  juros := -1;
  mora := -1;
  acrescimo := -1;
  diaAtraso := -1;
  tipoJuros := TtipoJuros.Create();
  inherited Create;
end;

destructor TJuros.Destroy;
begin
    tipoJuros.Free;
    inherited;
end;

function TJuros.getAcrescimo: double;
begin
    result := acrescimo
end;

function TJuros.getCodigo: Integer;
begin
    result := codigo;
end;

function TJuros.getDiaAtraso: Integer;
begin
    result := diaAtraso;
end;

function TJuros.getJuros: double;
begin
    result := juros;
end;

function TJuros.getMora: double;
begin
    result := mora;
end;

function TJuros.getStatusGrupo: Integer;
begin
  Result := statusGrupo;
end;

function TJuros.getTipoJuros: TTipoJuros;
begin
    result := tipoJuros;
end;

procedure TJuros.setAcrescimo(acres: double);
begin
    acrescimo := acres;
end;

procedure TJuros.setCodigo(cod: Integer);
begin
    codigo := cod;
end;

procedure TJuros.setDiaAtraso(dia: integer);
begin
    diaAtraso := dia;
end;

procedure TJuros.setJuros(juro: double);
begin
    juros := juro;
end;

procedure TJuros.setMora(mor: double);
begin
    mora := mor;
end;

procedure TJuros.setStatusGrupo(status: Integer);
begin
  statusGrupo := status;
end;

procedure TJuros.setTipoJuros(tJuro: TTipoJuros);
begin
    tipoJuros := tJuro;
end;

end.
