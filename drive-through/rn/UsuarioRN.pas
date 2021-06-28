unit UsuarioRN;

interface

Uses
   Usuario, UsuarioDAO, Classes, SysUtils, DB, ZDataSet;

type
  TUsuarioRN = class
  private
    { Private Declarations }
    UsuarioDAO : TUsuarioDAO;
  public
    constructor Create;
    function LoginUsuario(Usuario: TUsuario): TUsuario;
    function validaVersao(sVersao: string): boolean;
    function getIdentifier: string;
    function getPercRemocaoJuros(iUsuario: integer): double;
    procedure insertBloquioSistemaSemNet;

    {Validação de acesso}
    function getVerificaBloqueadoLocal(sIdentificador: string): boolean;
    function getVerificaData: boolean;
    //function getSituacaoAcesso(sIdentifier, sVersao: string): string;
    function getVerificaSituacao(sIdentifier: string): boolean;
   procedure setChecagem;
    procedure setChecagemDiaAnterior;
    function jaGravouChave(sChave: string): boolean;
    procedure gravaChave(sChave: string);
    procedure setBloqueio(sIdenficador, sSituacao: string);
    function getPermissaoUsuario(Usuario: TUsuario; iFuncao: integer): boolean;

    {Controle de Usuário}
    function getUsuarios: TList;
    function getJaExisteLogin(Usuario: TUsuario): boolean;
    function getSenhaUsuario(Usuario: TUsuario): string;

    function getCaixa: TDataSource;
    function getUsuario: TDataSource;
    function getOperador: TDataSource;
    function getVendedor: TDataSource;
    function getFamiliaProduto: TDataSource;



    procedure gravaUsuario(Usuario: TUsuario; sAcao: string);
    procedure gravaUsuarioSuporte(Usuario: TUsuario);
    procedure setCopiarPerfil(UsuarioDe, UsuarioPara: TUsuario);
    procedure excluirUsuario(Usuario: TUsuario);

  end;

implementation

constructor TUsuarioRN.Create;
begin
  inherited Create;
  // TODO: Add any constructor code here
end;

procedure TUsuarioRN.excluirUsuario(Usuario: TUsuario);
begin
   try
    UsuarioDAO := TUsuarioDAO.Create;
    UsuarioDAO.excluirUsuario(Usuario);
  finally
    UsuarioDAO.Free;
  end;
end;

function TUsuarioRN.getCaixa: TDataSource;
begin
  try
    UsuarioDAO := TUsuarioDAO.Create;
    result     := UsuarioDAO.getCaixa;
  finally
    UsuarioDAO.Free;
  end;
end;

function TUsuarioRN.getFamiliaProduto: TDataSource;
begin
  try
    UsuarioDAO := TUsuarioDAO.Create;
    Result     := UsuarioDAO.getFamiliaProduto;
  finally
    UsuarioDAO.Free;
  end;
end;

function TUsuarioRN.getIdentifier: string;
begin
  try
    UsuarioDAO := TUsuarioDAO.Create;
    Result     := UsuarioDAO.getIdentifier;
  finally
    UsuarioDAO.Free;
  end;
end;

function TUsuarioRN.getJaExisteLogin(Usuario: TUsuario): boolean;
begin
  try
    UsuarioDAO := TUsuarioDAO.Create;
    result := UsuarioDAO.getJaExisteLogin(Usuario);
  finally
    UsuarioDAO.Free;
  end;
end;

function TUsuarioRN.getOperador: TDataSource;
begin
  try
    UsuarioDAO := TUsuarioDAO.Create;
    result     := UsuarioDAO.getOperador;
  finally
    UsuarioDAO.Free;
  end;
end;

function TUsuarioRN.getPercRemocaoJuros(iUsuario: integer): double;
begin
  try
    UsuarioDAO := TUsuarioDAO.Create;
    Result := UsuarioDAO.getPercRemocaoJuros(iUsuario);
  finally
    UsuarioDAO.Free;
  end;
end;

function TUsuarioRN.getPermissaoUsuario(Usuario: TUsuario;
  iFuncao: integer): boolean;
begin
  try
    UsuarioDAO := TUsuarioDAO.Create;
    result     := UsuarioDAO.getPermissaoUsuario(Usuario, iFuncao);
  finally
    UsuarioDAO.Free;
  end;
end;

function TUsuarioRN.getSenhaUsuario(Usuario: TUsuario): string;
begin
  try
    UsuarioDAO := TUsuarioDAO.Create;
    result := UsuarioDAO.getSenhaUsuario(Usuario);
  finally
    UsuarioDAO.Free;
  end;
end;

{
function TUsuarioRN.getSituacaoAcesso(sIdentifier, sVersao: string): string;
var
  dDia: double;
  sChave, sSituacao: string;
  Usuario: TUsuario;
  Data: TData;
  bVerificar: boolean;
begin
  try
    UsuarioDAO := TUsuarioDAO.Create;
    Usuario    := TUsuario.Create;
    Data       := TData.Create;
    bVerificar := true;
    sSituacao  := '1';

    bVerificar := getVerificaSituacao(sIdentifier);

    if bVerificar then
    begin
      Usuario.codigo := 1428;
      sSituacao      := UsuarioDAO.getSituacaoAcesso(sIdentifier);

      {
      Valores possíveis de sSituacao:
      -1- bloqueado pela G10
      0 - bloqueado
      1 - liberado no mês corrente
      2 - liberado até o prazo após o vencimento
      3 - liberado com chave provisória
      4 - liberado até o prazo após o vencimento com exibição de mensagem de cobrança


      if (sSituacao = '0') or (sSituacao = '2') or (sSituacao = '3') or (sSituacao = '4') then
      begin
        sChave := UsuarioDAO.getChave(sIdentifier, Usuario);
        if sChave <> '' then
           sSituacao := UsuarioDAO.getSituacaoAcesso(sIdentifier);
      end;

      {NÃO bloquear nos fins de semana
      if (sSituacao = '0') or (sSituacao = '-1') then
      begin
        if not UsuarioDAO.getJaEstaBloqueado(sIdentifier) then
           if Data.getEFimSemana then
              sSituacao := '4';
      end;

      UsuarioDAO.setBloqueio(sIdentifier, sSituacao, sVersao);
    end;
  finally
    result := sSituacao;

    Usuario.Free;
    Data.Free;
  end;
end;
}

function TUsuarioRN.getUsuario: TDataSource;
begin
  try
    UsuarioDAO := TUsuarioDAO.Create;
    result     := UsuarioDAO.getUsuario;
  finally
    UsuarioDAO.Free;
  end;
end;

function TUsuarioRN.getUsuarios: TList;
begin
  try
    UsuarioDAO := TUsuarioDAO.Create;
    result := UsuarioDAO.getUsuarios;
  finally
    UsuarioDAO.Free;
  end;
end;

function TUsuarioRN.getVendedor: TDataSource;
begin
  try
    UsuarioDAO := TUsuarioDAO.Create;
    result := UsuarioDAO.getVendedor;
  finally
    UsuarioDAO.Free;
  end;
end;

function TUsuarioRN.getVerificaBloqueadoLocal(sIdentificador: string): boolean;
begin

end;

function TUsuarioRN.getVerificaData: boolean;
begin

end;

function TUsuarioRN.getVerificaSituacao(sIdentifier: string): boolean;
var
  bVerificaSituacao, bEstaBloqueado, bVerificaPelaData: boolean;
  bVerificaPelaMedia: boolean;
  UserDAO: TUsuarioDAO;
begin
  try
    UserDAO := TUsuarioDAO.Create;

    {1º - Verifica se está bloqueado}
    bEstaBloqueado := UsuarioDAO.getVerificaBloqueadoLocal(sIdentifier);

    {2º - Já verificou hoje, caso não tenha verificado, então verificar.}
    bVerificaPelaData := UsuarioDAO.getVerificaData;

    {3º - Verifica quantas vezes já tentou...se tentativa for maior ou igual a media, então deve verificar;}
    bVerificaPelaMedia := false;//UsuarioDAO.getVerificaMedia;

    bVerificaSituacao := false;
    if bEstaBloqueado or bVerificaPelaData or bVerificaPelaMedia then
    begin
      bVerificaSituacao := true;
      UsuarioDAO.setChecagem;
    end;
  finally
    result := bVerificaSituacao;
    UserDAO.Free;
  end;
end;

procedure TUsuarioRN.gravaChave(sChave: string);
begin
  try
    UsuarioDAO := TUsuarioDAO.Create;
    UsuarioDAO.gravaChave(sChave);
  finally
    UsuarioDAO.Free;
  end;
end;

procedure TUsuarioRN.gravaUsuario(Usuario: TUsuario; sAcao: string);
begin
  try
    UsuarioDAO := TUsuarioDAO.Create;
    UsuarioDAO.gravaUsuario(Usuario, sAcao);
  finally
    UsuarioDAO.Free;
  end;
end;

procedure TUsuarioRN.gravaUsuarioSuporte(Usuario: TUsuario);
begin
  try
    UsuarioDAO := TUsuarioDAO.Create;
    UsuarioDAO.gravaUsuarioSuporte(Usuario);
  finally
    UsuarioDAO.Free;
  end;
end;

procedure TUsuarioRN.insertBloquioSistemaSemNet;
begin
  try
    UsuarioDAO := TUsuarioDAO.Create;
    UsuarioDAO.insertBloquioSistemaSemNet;
  finally
    UsuarioDAO.Free;
  end;
end;

function TUsuarioRN.jaGravouChave(sChave: string): boolean;
begin
  try
    UsuarioDAO := TUsuarioDAO.Create;
    result     := UsuarioDAO.jaGravouChave(sChave);
  finally
    UsuarioDAO.Free;
  end;
end;

function TUsuarioRN.LoginUsuario(Usuario: TUsuario): TUsuario;
begin
  try
    UsuarioDAO := TUsuarioDAO.Create;

    result := UsuarioDAO.LoginUsuario(Usuario);
  finally
    UsuarioDAO.Free;
  end;
end;

procedure TUsuarioRN.setBloqueio(sIdenficador, sSituacao: string);
begin

end;

procedure TUsuarioRN.setChecagem;
begin

end;

procedure TUsuarioRN.setChecagemDiaAnterior;
begin
   try
    UsuarioDAO := TUsuarioDAO.Create;

    UsuarioDAO.setChecagemDiaAnterior;
  finally
    UsuarioDAO.Free;
  end;
end;

procedure TUsuarioRN.setCopiarPerfil(UsuarioDe, UsuarioPara: TUsuario);
begin
   try
    UsuarioDAO := TUsuarioDAO.Create;

    UsuarioDAO.setCopiarPerfil(UsuarioDe, UsuarioPara);
  finally
    UsuarioDAO.Free;
  end;
end;



function TUsuarioRN.validaVersao(sVersao: string): boolean;
begin
  try
    UsuarioDAO := TUsuarioDAO.Create;
    Result     := UsuarioDAO.validaVersao(sVersao);
  finally
    UsuarioDAO.Free;
  end
end;

end.
