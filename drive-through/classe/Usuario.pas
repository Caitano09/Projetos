unit Usuario;

interface

type
  TUsuario = class
  private
    { Private Declarations }
  public
    Codigo : integer;
    Login  : string;
    Senha  : string;
    SenhaG10 : string;
    Nome   : string;
    sMaster: string;
    DataValidaSenha: TDateTime;
    bNegado: boolean;
    bMaster: boolean;

    sLiberaVenda: string;
    sLiberaVendaProdutoSemSaldo: string;
    sPermitirLiberarOS: string;
    sIdentifier: string;
    dPReducaoAcrescimo: double;
    dPReducaoDesconto: double;
    constructor Create;
  end;

implementation

constructor TUsuario.Create;
begin
  inherited Create;
end;
end.
