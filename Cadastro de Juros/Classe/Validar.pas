unit Validar;

interface

uses
  Windows, Classes, SysUtils, DateUtils, maskutils, {LbCipher, LbClass,
  LBUtils,} IniFiles, ShellApi, {DCPcrypt2, DCPsha1, DCPrc4,} StrUtils,
  Variants, Forms;

  const aVal: array [0..109] of string = (
  'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'L0', 'M1', 'N2', 'O1',
  'P4', 'Q5', 'R6', 'S7', 'T8', 'U9', 'V0', 'X1', 'Z2', 'A2', 'B2', 'C2',
  'D2', 'E2', 'F2', 'G2', 'H3', 'I3', 'J3', 'L3', 'M3', 'N3', 'O3', 'P3',
  'Q3', 'R3', 'S4', 'T4', 'U4', 'V4', 'X4', 'Z4', 'A4', 'B4', 'C4', 'D4',
  'E5', 'F5', 'G5', 'H5', 'I5', 'J5', 'L5', 'M5', 'N5', 'O5', 'P6', 'Q6',
  'R9', 'S6', 'T6', 'U6', 'V6', 'X6', 'Z6', 'A6', 'B7', 'C7', 'D7', 'E7',
  'F7', 'G7', 'H7', 'I7', 'J7', 'L7', 'M8', 'N8', 'O8', 'P8', 'Q8', 'R8',
  'S8', 'T9', 'U8', 'V8', 'X9', 'Z9', 'A9', 'B9', 'C9', 'D9', 'E9', 'F9',
  'G9', 'H9', 'ZZ', 'I0', 'CC', 'DD', 'EE', 'FF', 'GG', 'HH', 'II', 'JJ');

type
  TValidar = class
  private
    { Private Declarations }
   // DCP_rc4: TDCP_rc4;
   // DCP_sha11: TDCP_sha1;
    ThousandSeparator: Char;
    CurrencyString: Char;
  public
    function VirgulaPonto(str: string) : string;
    function removeBarras(str: string): string;
    function numeroFracionado(sValor: string): boolean;
    function gerarDigitoZero(valor : String; qtdeZero : Integer) : String;
    function DifDias(DataVenc : TDateTime; DataAtual: TDateTime) : Integer;
    function validaCpf(cpf : String) : boolean;
    function pegaUrl(url : String) : String;
    function descontoPercentual(valor : Real; desconto : Real) : Real;
    function descontoValor(valor : Real; desconto : Real) : Real;
    function extenso(valor: real): string;
	  function formataIdentificador(identificador: String): String;
    function isCpf(cpf : String) : boolean;
    function isCnpj(numCNPJ : String) : boolean;
    function isEmail(email: string): boolean;
    function VerificarInscEstadual(IE:String):Boolean;
    function formatarBanco(sValor: string): string; overload;
    function formatarBanco(sValor, sTipoValor: string): string; reintroduce; overload;
    function StrCurrToCurrDef(AString: string; Default: Currency): Currency;
    function MixCase(sInString: string): string;
    function removeVirgulaPonto(sValor: string): string;
    function removePonto(sValor: string): string;
    function StrToCurrPerc(sValor: string): currency;
    function Arredondar(eValor: extended; siQtdeDecimais : smallint): extended;
    function casasDecimais(sValor: string): integer;
    function dataPorExtenso(Data: TDateTime): string;

    function getUltimoDiaDoMes(Data: TDateTime): integer;
    function validaChaveSistema(sChave, sIdentificador: string): boolean;
    function getMesAnoChave(sChave: string): string;
    function getDiasChave(sChave: string): string;
    function getIdentificadorChave(sChave: string): string;
    function chaveEstaQueimada(sChave: string): boolean;
//    function geraMd5(sString: string): string;
    function removeNumero(sString: string): string;
    function firstName(sNome:string): string;
    function formatDir(sString: string): string;
    function sGCPath(sPath: string): string;
    function edizimaperiodica(sValor: string): boolean;
    function InverteString(sString: string): string;
    function geraChaveSistema(Identificador: string; iQtdeDias: integer): string;
    function PreencherString(sString:Variant; Caracter:Char; Tamanho:Integer; DireitaEsquerda:Char):string;
    function CentralizaString(sString: string; iTamanhoLinha: integer): string;
    function FormatString(sString: string; sMascara: string): string;
    function getENumero(sString: string): boolean;
    function getChaveConfiguracao(sSecao, sChave: string): string;
    function formataNome(sNome: string): string;
    function StrToCurrency(sValor: string): currency;
    function retiraAspa(sTexto: string): string;
    function PriMaiuscula(nome: string): string;
    function getSenhaAcessoUserG10(codigo: Integer): string;

    procedure reiniciarAplicacao;
    procedure creaProcesso(sProcesso: string; bMostrarJanela: boolean);
    procedure renomeaDiretorio(sDirDe, sDirPara: string);
    constructor Create;
  end;

implementation

//var
  //SHA1Digest: TSHA1Digest;
  
constructor TValidar.Create;
begin
  inherited Create;
end;

function TValidar.dataPorExtenso(Data: TDateTime): string;
const
   Meses: array [1..12] of String =('Janeiro', 'Fevereiro','Março','Abril','Maio','Junho',
   'Julho','Agosto','Setembro','Outubro','Novembro','Dezembro');
var
   Presente: TDateTime;
   Year, Month, Day: Word;
   Mes: Integer;
   Dia, Ano, Extenso: String;
begin
   Presente := Data;
   DecodeDate(Presente, Year, Month, Day);
   Dia := IntToStr(Day);
   Mes := (Month);
   Ano := IntToStr(Year);

   Extenso := Dia +' de '+ Meses[Mes] +' de '+ Ano;

   result := Extenso;
end;

function TValidar.descontoPercentual(valor, desconto: Real): Real;
var
  valorDescontado : Real;
begin
  valorDescontado := (valor * desconto)/100;

  Result := valorDescontado;
end;

function TValidar.descontoValor(valor, desconto: Real): Real;
begin
  Result := valor - desconto;
end;

Function TValidar.isCNPJ(numCNPJ: string): boolean;
var
  cnpj: string;
  dg1, dg2: integer;
  x, total: integer;
  ret: boolean;
begin
ret:=False;
cnpj:='';
//Analisa os formatos
if Length(numCNPJ) = 18 then
    if (Copy(numCNPJ,3,1) + Copy(numCNPJ,7,1) + Copy(numCNPJ,11,1) + Copy(numCNPJ,16,1) = '../-') then
        begin
        cnpj:=Copy(numCNPJ,1,2) + Copy(numCNPJ,4,3) + Copy(numCNPJ,8,3) + Copy(numCNPJ,12,4) + Copy(numCNPJ,17,2);
        ret:=True;
        end;
if Length(numCNPJ) = 14 then
    begin
    cnpj:=numCNPJ;
    ret:=True;
    end;
//Verifica
if ret then
    begin
    try
        //1° digito
        total:=0;
        for x:=1 to 12 do
            begin
            if x < 5 then
                Inc(total, StrToInt(Copy(cnpj, x, 1)) * (6 - x))
            else
                Inc(total, StrToInt(Copy(cnpj, x, 1)) * (14 - x));
            end;
        dg1:=11 - (total mod 11);
        if dg1 > 9 then
            dg1:=0;
        //2° digito
        total:=0;
        for x:=1 to 13 do
            begin
            if x < 6 then
                Inc(total, StrToInt(Copy(cnpj, x, 1)) * (7 - x))
            else
                Inc(total, StrToInt(Copy(cnpj, x, 1)) * (15 - x));
            end;
        dg2:=11 - (total mod 11);
        if dg2 > 9 then
            dg2:=0;
        //Validação final
        if (dg1 = StrToInt(Copy(cnpj, 13, 1))) and (dg2 = StrToInt(Copy(cnpj, 14, 1))) then
            ret:=True
        else
            ret:=False;
    except
        ret:=False;
        end;
    //Inválidos
    //case AnsiIndexStr(cnpj,['00000000000000','11111111111111','22222222222222','33333333333333','44444444444444',
    //                       '55555555555555','66666666666666','77777777777777','88888888888888','99999999999999']) of
    //    0..9:   ret:=False;
    //    end;
    end;
   Result := ret;
end;

function TValidar.isEmail(email: string): boolean;
const
  atom_chars = [#33..#255] - ['(', ')', '<', '>', '@', ',', ';', ':','\', '/', '"', '.', '[', ']', #127];
  quoted_string_chars = [#0..#255] - ['"', #13, '\'];
  letters = ['A'..'Z', 'a'..'z'];
  letters_digits = ['0'..'9', 'A'..'Z', 'a'..'z'];
  subdomain_chars = ['-', '0'..'9', 'A'..'Z', 'a'..'z'];
type
  States = (STATE_BEGIN, STATE_ATOM, STATE_QTEXT, STATE_QCHAR,
        STATE_QUOTE, STATE_LOCAL_PERIOD, STATE_EXPECTING_SUBDOMAIN,
        STATE_SUBDOMAIN, STATE_HYPHEN);
var
  State: States;
  i, n, subdomains: integer;
  c: char;
begin
  State := STATE_BEGIN;
  n := Length(email);
  i := 1;
  subdomains := 1;
  while (i <= n) do begin
        c := email[i];
        case State of
        STATE_BEGIN:
          if c in atom_chars then
                State := STATE_ATOM
          else if c = '"' then
                State := STATE_QTEXT
          else
                break;
        STATE_ATOM:
          if c = '@' then
                State := STATE_EXPECTING_SUBDOMAIN
          else if c = '.' then
                State := STATE_LOCAL_PERIOD
          else if not (c in atom_chars) then
                break;
        STATE_QTEXT:
          if c = '\' then
                State := STATE_QCHAR
          else if c = '"' then
                State := STATE_QUOTE
          else if not (c in quoted_string_chars) then
                break;
        STATE_QCHAR:
          State := STATE_QTEXT;
        STATE_QUOTE:
          if c = '@' then
                State := STATE_EXPECTING_SUBDOMAIN
          else if c = '.' then
                State := STATE_LOCAL_PERIOD
          else
                break;
        STATE_LOCAL_PERIOD:
          if c in atom_chars then
                State := STATE_ATOM
          else if c = '"' then
                State := STATE_QTEXT
          else
                break;
        STATE_EXPECTING_SUBDOMAIN:
          if c in letters then
                State := STATE_SUBDOMAIN
          else
                break;
        STATE_SUBDOMAIN:
          if c = '.' then begin
                inc(subdomains);
                State := STATE_EXPECTING_SUBDOMAIN
          end else if c = '-' then
                State := STATE_HYPHEN
          else if not (c in letters_digits) then
                break;
        STATE_HYPHEN:
          if c in letters_digits then
                State := STATE_SUBDOMAIN
          else if c <> '-' then
                break;
        end;
        inc(i);
  end;
  if i <= n then
        Result := False
  else
        Result := (State = STATE_SUBDOMAIN) and (subdomains >= 2);
end;

function TValidar.formataIdentificador(identificador: String): String;
Var
  cpfOrCnpj, cont: integer;
  retorno: string;
begin
  try
    cpfOrCnpj := Length(identificador);
    for cont := 1 To cpfOrCnpj Do
     if (Copy(identificador,cont,1) <> '.') And (Copy(identificador,cont,1) <> '-') And (Copy(identificador,cont,1) <> '/') Then
        retorno := retorno + Copy(identificador,cont,1);

      identificador := retorno;
      cpfOrCnpj := Length(identificador);
      retorno := '';
      //vDoc := '';

    for cont := 1 To cpfOrCnpj Do
    begin
     retorno := retorno + Copy(identificador,cont,1);
     if cpfOrCnpj = 11 Then
     begin
        If (cont in [3,6]) Then retorno := retorno + '.';
        If cont = 9 Then retorno := retorno + '-';
     end;

     if cpfOrCnpj = 14 Then
     begin
        If (cont in [2,5]) Then retorno := retorno + '.';
        If cont = 8 Then retorno := retorno + '/';
        If cont = 12 Then retorno := retorno + '-';
     end;
    end;
  finally
    if retorno = '' then
       retorno := '   .   .   -  ';

    result := retorno;
  end;
end;

function TValidar.formataNome(sNome: string): string;
var
  i: integer;
  esp: boolean;
begin
  sNome := LowerCase(Trim(sNome));

  for i := 1 to Length(sNome) do
  begin
    if i = 1 then
      sNome[i] := UpCase(sNome[i])
    else
      begin
        if i <> Length(sNome) then
        begin
          esp := (sNome[i] = ' ');
          if esp then
             sNome[i+1] := UpCase(sNome[i+1]);
        end;
      end;
  end;

  result := sNome;
end;

function TValidar.isCpf(cpf: String): boolean;
var
 i, numero, resto: integer;
 dv1, dv2: byte;
 total, soma: integer;
begin
 result := false;
 if length(cpf) = 11 then
 begin
  total := 0 ;
  soma := 0 ;
  for i := 1 to 9 do
  begin
   try
     numero := StrToInt(cpf[i]);
   except
     numero := 0;
   end;

   total := total + (numero * ( 11 - i));
   soma := soma + numero;
  end;
  resto := total mod 11 ;
  if resto > 1 then
   dv1 := 11 - resto
  else
   dv1 := 0 ;
  total := total + soma + 2 * dv1;
  resto := total mod 11 ;

  if resto > 1 then
   dv2 := 11 - resto
  else
   dv2 := 0 ;

  if (dv1 = StrToInt(cpf[ 10 ])) and
    (dv2 = StrToInt(cpf[ 11 ])) then
    result := true;
 end;
end;

function TValidar.DifDias(DataVenc, DataAtual: TDateTime) : Integer;
var
  contadorDias: Integer;
begin
  if DataAtual <= DataVenc then
  begin
    Result := 0;
  end
  else
  begin
    contadorDias :=  DaysBetween(DataVenc,DataAtual);
    Result := contadorDias;
  end;
end;

function TValidar.gerarDigitoZero(valor: String; qtdeZero: Integer): String;
var
  i : integer;
  valorAux : String;
begin
  valorAux := '';
  for I := length(valor) downto 1 do
  begin
    valorAux := valorAux + valor[i];
  end;
  for I := Length(valor)+1 to qtdeZero do
  begin
    valorAux := valorAux + '0';
  end;
  valor := '';
  for I := Length(valorAux) downto 1 do
  begin
    valor:= valor + valorAux[i];
  end;

  Result := valor;

end;

function TValidar.edizimaperiodica(sValor: string): boolean;
var
  iCount, iPos, iCasas: integer;
  beDizima: boolean;
begin
  iPos     := Pos(',', sValor);
  beDizima := false;

  if iPos = 0 then
     iCasas := 1
  else
  begin
    iCasas := 0;
    for iCount := iPos + 1 to length(sValor) do
        Inc(iCasas);
  end;

  if iCasas >= 3 then
     beDizima := true;

  result := beDizima;
end;

function TValidar.extenso (valor: real): string;
var

Centavos, Centena, Milhar, Texto, msg: string;
const
Unidades: array[1..9] of string = ('Um', 'Dois', 'Tres', 'Quatro', 'Cinco', 'Seis', 'Sete', 'Oito', 'Nove');
Dez: array[1..9] of string = ('Onze', 'Doze', 'Treze', 'Quatorze', 'Quinze', 'Dezesseis', 'Dezessete', 'Dezoito', 'Dezenove');
Dezenas: array[1..9] of string = ('Dez', 'Vinte', 'Trinta', 'Quarenta', 'Cinquenta', 'Sessenta', 'Setenta', 'Oitenta', 'Noventa');
Centenas: array[1..9] of string = ('Cento', 'Duzentos', 'Trezentos', 'Quatrocentos', 'Quinhentos', 'Seiscentos', 'Setecentos', 'Oitocentos', 'Novecentos');

function ifs(Expressao: Boolean; CasoVerdadeiro, CasoFalso: String): String;
begin
  if Expressao then
    Result := CasoVerdadeiro
  else
    Result := CasoFalso;
end;

function MiniExtenso (trio: string): string;
var
  Unidade, Dezena, Centena: string;
begin
  Unidade:='';
  Dezena:='';
  Centena:='';
  if (trio[2]='1') and (trio[3]<>'0') then
  begin
    Unidade:=Dez[strtoint(trio[3])];
    Dezena:='';
  end
  else
  begin
    if trio[2]<>'0' then Dezena:=Dezenas[strtoint(trio[2])];
    if trio[3]<>'0' then Unidade:=Unidades[strtoint(trio[3])];
  end;
  if (trio[1]='1') and (Unidade='') and (Dezena='') then
    Centena:='cem'
  else
  if trio[1]<>'0'then
    Centena:=Centenas[strtoint(trio[1])]
  else
    Centena:='';

  Result:= Centena + ifs((Centena<>'') and ((Dezena<>'') or (Unidade<>'')), ' e ', '')
+ Dezena + ifs((Dezena<>'') and (Unidade<>''),' e ', '') + Unidade;
end;
begin
  if (valor>999999.99) or (valor<0) then
  begin
    msg:='O valor está fora do intervalo permitido.';
    msg:=msg+'O número deve ser maior ou igual a zero e menor que 999.999,99.';
    msg:=msg+' Se não for corrigido o número não será escrito por extenso.';
    raise Exception.Create(msg);
    Result:='';
    exit;
  end;
  if valor=0 then
  begin
    Result:='';
    Exit;
  end;
  Texto:=formatfloat('000000.00',valor);
  Milhar:=MiniExtenso(Copy(Texto,1,3));
  Centena:=MiniExtenso(Copy(Texto,4,3));
  Centavos:=MiniExtenso('0'+Copy(Texto,8,2));
  Result:=Milhar;
  if Milhar<>'' then
    if copy(texto,4,3)='000' then
      Result:=Result+' Mil Reais'
    else
      Result:=Result+' Mil, ';
  if (((copy(texto,4,2)='00') and (Milhar<>'')
  and (copy(texto,6,1)<>'0')) or (centavos=''))
  and (Centena<>'') then Result:=Result+'';
    if (Milhar+Centena <>'') then Result:=Result+Centena;
     if (Milhar='') and (copy(texto,4,3)='001') then
       Result:=Result+' Real'
     else
       if (copy(texto,4,3)<>'000') then
         Result:=Result+' Reais';
  if Centavos='' then
  begin
    Result:=Result+'.';
    Exit;
  end
  else
  begin
  if Milhar+Centena='' then
    Result:=Centavos
  else
    Result:=Result+', e '+Centavos;
  if (copy(texto,8,2)='01') and (Centavos<>'') then
    Result:=Result+' Centavo.'
  else
    Result:=Result+' Centavos.';
end;
end;

function TValidar.pegaUrl(url: String): String;
var
  i : integer;
  aux : String;
begin
  for I := (Length(url) - 5) downto 1 do
    begin
      if url[i] <> '/' then
        aux := aux + url[i]
      else
        break;
    end;
   url := '';
   aux := aux + '/';
   for I := length(aux) downto 1 do
     url := url + aux[i];

  Result := LowerCase(url);
      
end;

function TValidar.PreencherString(sString: Variant; Caracter: Char;
  Tamanho: Integer; DireitaEsquerda: Char): string;
var
  ValorStr : String;
  Cont     : Byte;
begin
  if Trim(sString)<>'' then
     ValorStr := Copy(Trim(sString),1,Tamanho)
  else
     ValorStr := '';

  Cont := Tamanho - Length(ValorStr);
  While Cont > 0 do
    if UpperCase(DireitaEsquerda)='D' then
     begin
       ValorStr := ValorStr+Caracter;
       Cont     := Cont - 1;
     end
    else
       if UpperCase(DireitaEsquerda)='E' then
        begin
          ValorStr := Caracter+ValorStr;
          Cont     := Cont - 1;
        end;
  Result := ValorStr;
end;

function TValidar.PriMaiuscula(nome: string): string;
var
   i  : Integer;
   apelido : String;
   branco : Boolean;
begin
     apelido := '';
     branco := True;

     nome := LowerCase(nome);

     apelido := UpperCase(Copy(nome,1,1));

     for i := 1 to Length(nome) do
     begin
          if (Copy(nome,i,1) = ' ') then
             begin
                  branco := ((UpperCase(Copy(nome,i,4)) = ' DO ') or
                             (UpperCase(Copy(nome,i,3)) = ' E ') or
                             (UpperCase(Copy(nome,i,4)) = ' DE ') or
                             (UpperCase(Copy(nome,i,4)) = ' DA ') or
                             (UpperCase(Copy(nome,i,5)) = ' DOS ') or
                             (UpperCase(Copy(nome,i,5)) = ' DAS '))
             end;
          if not branco then apelido := apelido+UpperCase(Copy(nome,i+1,1)) else  apelido := apelido+Copy(nome,i+1,1);
          branco := True;
     end;
     Result := apelido;
end;

function TValidar.validaCpf(cpf: String): boolean;
var
 i, numero, resto: integer;
 dv1, dv2: byte;
 total, soma: integer;
begin
 result := false;
 if length(cpf) = 11 then
 begin
  total := 0 ;
  soma := 0 ;
  for i := 1 to 9 do
  begin
   try
     numero := StrToInt(cpf[i]);
   except
     numero := 0;
   end;

   total := total + (numero * ( 11 - i));
   soma := soma + numero;
  end;
  resto := total mod 11 ;
  if resto > 1 then
   dv1 := 11 - resto
  else
   dv1 := 0 ;
  total := total + soma + 2 * dv1;
  resto := total mod 11 ;

  if resto > 1 then
   dv2 := 11 - resto
  else
   dv2 := 0 ;

  if (dv1 = StrToInt(cpf[ 10 ])) and
    (dv2 = StrToInt(cpf[ 11 ])) then
    result := true;

 end;

end;

function TValidar.VerificarInscEstadual(IE: String): Boolean;
var nIE : String;
  I: Integer;
  soma,mult,resto : integer;
begin
  for I := 1 to Length(IE) - 1 do    // Iterate
  begin
    if ((IE[I] <> '.') and (IE[I] <> '-')) then
       nIE := nIE + IE[I];
  end;    // for

  soma := strtoint(nIE[1]) * 9;
  soma := soma + strtoint(nIE[2]) * 8;
  soma := soma + strtoint(nIE[3]) * 7;
  soma := soma + strtoint(nIE[4]) * 6;
  soma := soma + strtoint(nIE[5]) * 5;
  soma := soma + strtoint(nIE[6]) * 4;
  soma := soma + strtoint(nIE[7]) * 3;
  soma := soma + strtoint(nIE[8]) * 2;

  mult := soma * 10;

  resto := mult mod 11;

  //Label2.Caption := inttostr(soma) + ' ' + inttostr(mult) + ' ' + inttostr(resto);

  if resto = 1 then
    result := True
  else
    result := false;

end;

function TValidar.VirgulaPonto(str: String): String;
var
  i: integer;
begin
  for i := 1 to length(str) do
    if str[i] = ',' then
       str[i] := '.';

  result := str;
end;

function TValidar.StrCurrToCurrDef(AString: string;
  Default: Currency): Currency;
var
  iPosicao: integer;
  sValorRemove: string;
  cValor: currency;
begin
  iPosicao := Pos('%', AString);

  if iPosicao > 0 then
  begin
    sValorRemove := Trim(Copy(AString, 1 , (iPosicao - 1)));
    cValor       := StrToCurr(sValorRemove);
  end
  else
  begin
    AString := StringReplace(AString, ThousandSeparator, '', [rfReplaceAll]);
    AString := StringReplace(AString, CurrencyString, '', [rfReplaceAll]);
    cValor  := StrToCurrDef(AString, Default);
  end;

  result := cValor;
end;

function TValidar.MixCase(sInString: string): string;
var
 I: Integer;
begin
  Result := LowerCase(sInString);
  Result[1] := UpCase(Result[1]);
  for I := 1 To Length(sInString) - 1 Do
  begin
    if (Result[I] = ' ') Or (Result[I] = '''') Or (Result[I] = '"')
    or (Result[I] = '-') Or (Result[I] = '.')  Or (Result[I] = '(') then
      Result[I + 1] := UpCase(Result[I + 1]);
  end;
end;

function TValidar.numeroFracionado(sValor: string): boolean;
var
  iCount  : integer;
  bRetorno: boolean;
begin
  bRetorno := false;
  for iCount := 1 to length(sValor) do
  begin
    if (sValor[iCount] = ',') or (sValor[iCount] = '.') then
    begin
      bRetorno := true;
      break;
    end;
  end;

  result := bRetorno;
end;

function TValidar.removeVirgulaPonto(sValor: string): string;
var
  aNum: string;
  i, x: integer;
  sNum: string;
begin
  aNum := '0123456789';

  sNum := '';
  for i := 1 to Length(sValor) do
  begin
    for x := 1 to Length(aNum) do
    begin
      if (Trim(sValor[i]) = Trim(aNum[x])) then
          sNum := Trim(sNum) + Trim(sValor[i]);
    end;
  end;

  result := sNum;
end;

procedure TValidar.renomeaDiretorio(sDirDe, sDirPara: string);
var
  shellinfo: TSHFileOpStruct;
begin
  with shellinfo do
  begin
    Wnd    := 0;
    wFunc  := FO_RENAME;
    pFrom  := PChar(sDirDe);
    pTo    := PChar(sDirPara);
    fFlags := FOF_FILESONLY or FOF_ALLOWUNDO or

    FOF_SILENT or FOF_NOCONFIRMATION;
  end;

  SHFileOperation(shellinfo);
end;

function TValidar.retiraAspa(sTexto: string): string;
var
  i: integer;
  sNovoTexto: string;
begin
  sNovoTexto := '';
  for i := 1 to length(sTexto) do
  begin
    if copy(sTexto, I,1) <> Chr(39) then
      sNovoTexto := sNovoTexto + copy(sTexto, i,1)
    else
      sNovoTexto := sNovoTexto + ' ';
  end;

  result := sNovoTexto;
end;

function TValidar.formatarBanco(sValor: string): string;
var
  sValorFormatado, sValorLimpo: string;
begin
  sValorLimpo := removeVirgulaPonto(sValor);

  case Length(sValorLimpo) of
     0: sValorFormatado := '';
     1: sValorFormatado := '0,0'+sValorLimpo;
     2: sValorFormatado := '0,'+sValorLimpo;
     3: sValorFormatado := FormatMaskText('0,00;0', sValorLimpo);
     4: sValorFormatado := FormatMaskText('00,00;0', sValorLimpo);
     5: sValorFormatado := FormatMaskText('000,00;0', sValorLimpo);
     6: sValorFormatado := FormatMaskText('0.000,00;0', sValorLimpo);
     7: sValorFormatado := FormatMaskText('00.000,00;0', sValorLimpo);
     8: sValorFormatado := FormatMaskText('000.000,00;0', sValorLimpo);
  end;
  result := sValorFormatado;
end;

function TValidar.formatarBanco(sValor, sTipoValor: string): string;
var
  sValorFormatado, sValorLimpo: string;
begin
  sValorLimpo := removeVirgulaPonto(sValor);

  if sTipoValor = '%' then
  begin
    case Length(sValorLimpo) of
       0: sValorFormatado := '';
       1: sValorFormatado := '0,0'+sValorLimpo+' '+sTipoValor;
       2: sValorFormatado := '0,'+sValorLimpo+' '+sTipoValor;
       3: sValorFormatado := FormatMaskText('0,00;0'+' '+sTipoValor, sValorLimpo);
       4: sValorFormatado := FormatMaskText('00,00;0'+' '+sTipoValor, sValorLimpo);
       5: sValorFormatado := FormatMaskText('000,00;0'+' '+sTipoValor, sValorLimpo);
       6: sValorFormatado := FormatMaskText('0.000,00;0'+' '+sTipoValor, sValorLimpo);
       7: sValorFormatado := FormatMaskText('00.000,00;0'+' '+sTipoValor, sValorLimpo);
       8: sValorFormatado := FormatMaskText('000.000,00;0'+' '+sTipoValor, sValorLimpo);
    end;
  end;

  if sTipoValor = 'R$' then
  begin
    case Length(sValorLimpo) of
       0: sValorFormatado := '';
       1: sValorFormatado := sTipoValor+' 0,0'+sValorLimpo;
       2: sValorFormatado := sTipoValor+' 0,'+sValorLimpo;
       3: sValorFormatado := FormatMaskText(sTipoValor+' 0,00;0', sValorLimpo);
       4: sValorFormatado := FormatMaskText(sTipoValor+' 00,00;0', sValorLimpo);
       5: sValorFormatado := FormatMaskText(sTipoValor+' 000,00;0', sValorLimpo);
       6: sValorFormatado := FormatMaskText(sTipoValor+' 0.000,00;0', sValorLimpo);
       7: sValorFormatado := FormatMaskText(sTipoValor+' 00.000,00;0', sValorLimpo);
       8: sValorFormatado := FormatMaskText(sTipoValor+' 000.000,00;0', sValorLimpo);
    end;
  end;
  
  result := sValorFormatado;
end;

function TValidar.StrToCurrPerc(sValor: string): currency;
var
  iPosicao: integer;
  sValorRemove: string;
begin
  iPosicao := Pos(sValor, '%');

  sValorRemove := Trim(Copy(sValor, 1 , (iPosicao - 1)));

  result := StrToCurr(sValorRemove);
end;

function TValidar.Arredondar(eValor: extended; siQtdeDecimais: smallint): extended;
var
  iMultiplo10, iCount: integer;
  bMult: boolean;
begin
  iMultiplo10 := 1;

  bMult := false;
  for iCount := 1 to siQtdeDecimais  do
  begin
    iMultiplo10 := iMultiplo10 * 10;
    bMult       := true;
  end;

  if not bMult then
     result := Round(eValor)
  else
     result := Round(eValor * iMultiplo10 ) / iMultiplo10;
end;

function TValidar.getChaveConfiguracao(sSecao, sChave: string): string;
var
  ArquivoConfiguracao: TIniFile;
  sValorChave: string;
begin
  try
    sValorChave := '';
    if (sChave = 'TpImpressora') or (sChave = 'visualizar') then
    begin
      sSecao              := 'impfinanceiro';
      ArquivoConfiguracao := TIniFile.Create('c:\windows\system32\sgcpdv.ini');
    end
    else
      ArquivoConfiguracao := TIniFile.Create(ExtractFilePath(Application.ExeName)+'configuracoes.ini');


    sValorChave := ArquivoConfiguracao.ReadString(sSecao, sChave, '');
  finally
    result := sValorChave;
    ArquivoConfiguracao.Free;
  end;
end;

function TValidar.getDiasChave(sChave: string): string;
var
  sBlocoA, sBlocoB, sBlocoC, sBlocoD, sBlocoE: string;
  sBlocoA1, sBlocoB1, sBlocoC1, sBlocoD1, sBlocoE1: string;
  sDias: string;
  sPos1, sPos2: string;
  i, y: integer;
begin
  try
    sBlocoA := Copy(sChave, 1, 5);
    sBlocoB := Copy(sChave, 7, 4);
    sBlocoC := Copy(sChave, 12, 4);
    sBlocoD := Copy(sChave, 17, 4);
    sBlocoE := Copy(sChave, 22, 5);

    {Bloco A}
    sBlocoA1 := '';
    for y := 1 to Length(sBlocoA) do
    begin
      for i := 0 to Length(aVal) - 1 do
      begin
        if sBlocoA[y] = aVal[i] then
           sBlocoA1 := sBlocoA1 + IntToStr(i);

        if Length(sBlocoA1) = 5 then
           break;

      end;
    end;

    {Bloco E}
    sBlocoE1 := '';
    for y := 1 to Length(sBlocoE) do
    begin
      for i := 0 to Length(aVal) - 1 do
      begin
        if sBlocoE[y] = aVal[i] then
           sBlocoE1 := sBlocoE1 + IntToStr(i);

        if Length(sBlocoE1) = 5 then
           break;
      end;
    end;

    {Bloco B}
    sBlocoB1 := '';
    sPos1    := Copy(sBlocoB, 1, 2);
    sPos2    := Copy(sBlocoB, 3, 2);

    //if sPos1 = 'I0' then
    //   sBlocoB1 := sBlocoB1 + '01'
    //else
    //begin
    for i := 0 to Length(aVal) - 1 do
    begin
      if sPos1 = aVal[i] then
      begin
        if i >= 100 then
           sBlocoB1 := sBlocoB1 + Copy(IntToStr(i), 2, 2)
        else
           sBlocoB1 := sBlocoB1 + IntToStr(i);

        break;
      end;
    end;
    //end;

    for i := 0 to Length(aVal) - 1 do
    begin
      if sPos2 = aVal[i] then
      begin
        if i >= 100 then
           sBlocoB1 := sBlocoB1 + Copy(IntToStr(i), 2, 2)
        else
           sBlocoB1 := sBlocoB1 + IntToStr(i);

        break;
      end;
    end;

    {Bloco C}
    sBlocoC1 := '';
    sPos1    := Copy(sBlocoC, 1, 2);
    sPos2    := Copy(sBlocoC, 3, 2);

    for i := 0 to Length(aVal) - 1 do
    begin
      if sPos1 = aVal[i] then
      begin
        if i >= 100 then
           sBlocoC1 := sBlocoC1 + Copy(IntToStr(i), 2, 2)
        else
           sBlocoC1 := sBlocoC1 + IntToStr(i);

        break;
      end;
    end;

    for i := 0 to Length(aVal) - 1 do
    begin
      if sPos2 = aVal[i] then
      begin
        if i >= 100 then
           sBlocoC1 := sBlocoC1 + Copy(IntToStr(i), 2, 2)
        else
           sBlocoC1 := sBlocoC1 + IntToStr(i);

        break;
      end;
    end;

    {Bloco D}
    sBlocoD1 := '';
    sPos1    := Copy(sBlocoD, 1, 2);
    sPos2    := Copy(sBlocoD, 3, 2);

    for i := 0 to Length(aVal) - 1 do
    begin
      if sPos1 = aVal[i] then
      begin
        if i >= 100 then
           sBlocoD1 := sBlocoD1 + Copy(IntToStr(i), 2, 2)
        else
           sBlocoD1 := sBlocoD1 + IntToStr(i);

        break;
      end;
    end;

    for i := 0 to Length(aVal) - 1 do
    begin
      if sPos2 = aVal[i] then
      begin
        if i >= 100 then
           sBlocoD1 := sBlocoD1 + Copy(IntToStr(i), 2, 2)
        else
           sBlocoD1 := sBlocoD1 + IntToStr(i);
        break;
      end;
    end;

    sChave := sBlocoA1+sBlocoB1+sBlocoC1+sBlocoD1+sBlocoE1;

    sDias   := Copy(sChave, 5, 2);

    result := sDias;
  except
    result := '';
  end;
end;

function TValidar.getENumero(sString: string): boolean;
var
  aNum: string;
  i, x: integer;
  sNum: string;
  bSair: boolean;
begin
  bSair := false;
  if sString <> '' then
  begin
    bSair := true;
    for i:=1 to Length(sString) do
    begin
      if not (sString[i] in ['0','1','2','3','4','5','6','7','8','9']) then
      begin
        bSair := false;
        break;
      end;
    end;
  end;

  result := bSair;
end;

function TValidar.getIdentificadorChave(sChave: string): string;
var
  sBlocoA, sBlocoB, sBlocoC, sBlocoD, sBlocoE: string;
  sBlocoA1, sBlocoB1, sBlocoC1, sBlocoD1, sBlocoE1: string;
  sIdent, sDias, sMesAno: string;
  sPos1, sPos2: string;
  i, y: integer;
  dIdentificador: double;
begin
  try
    sBlocoA := Copy(sChave, 1, 5);
    sBlocoB := Copy(sChave, 7, 4);
    sBlocoC := Copy(sChave, 12, 4);
    sBlocoD := Copy(sChave, 17, 4);
    sBlocoE := Copy(sChave, 22, 5);

    {Bloco A}
    sBlocoA1 := '';
    for y := 1 to Length(sBlocoA) do
    begin
      for i := 0 to Length(aVal) - 1 do
      begin
        if sBlocoA[y] = aVal[i] then
           sBlocoA1 := sBlocoA1 + IntToStr(i);

        if Length(sBlocoA1) = 5 then
           break;

      end;
    end;

    {Bloco E}
    sBlocoE1 := '';
    for y := 1 to Length(sBlocoE) do
    begin
      for i := 0 to Length(aVal) - 1 do
      begin
        if sBlocoE[y] = aVal[i] then
           sBlocoE1 := sBlocoE1 + IntToStr(i);

        if Length(sBlocoE1) = 5 then
           break;
      end;
    end;

    {Bloco B}
    sBlocoB1 := '';
    sPos1    := Copy(sBlocoB, 1, 2);
    sPos2    := Copy(sBlocoB, 3, 2);

    for i := 0 to Length(aVal) - 1 do
    begin
      if sPos1 = aVal[i] then
      begin
        if i >= 100 then
           sBlocoB1 := sBlocoB1 + Copy(IntToStr(i), 2, 2)
        else
           sBlocoB1 := sBlocoB1 + IntToStr(i);

        break;
      end;
    end;

    for i := 0 to Length(aVal) - 1 do
    begin
      if sPos2 = aVal[i] then
      begin
        if i >= 100 then
           sBlocoB1 := sBlocoB1 + Copy(IntToStr(i), 2, 2)
        else
           sBlocoB1 := sBlocoB1 + IntToStr(i);

        break;
      end;
    end;

    {Bloco C}
    sBlocoC1 := '';
    sPos1    := Copy(sBlocoC, 1, 2);
    sPos2    := Copy(sBlocoC, 3, 2);

    for i := 0 to Length(aVal) - 1 do
    begin
      if sPos1 = aVal[i] then
      begin
        if i >= 100 then
           sBlocoC1 := sBlocoC1 + Copy(IntToStr(i), 2, 2)
        else
           sBlocoC1 := sBlocoC1 + IntToStr(i);

        break;
      end;
    end;

    for i := 0 to Length(aVal) - 1 do
    begin
      if sPos2 = aVal[i] then
      begin
        if i >= 100 then
           sBlocoC1 := sBlocoC1 + Copy(IntToStr(i), 2, 2)
        else
           sBlocoC1 := sBlocoC1 + IntToStr(i);

        break;
      end;
    end;

    {Bloco D}
    sBlocoD1 := '';
    sPos1    := Copy(sBlocoD, 1, 2);
    sPos2    := Copy(sBlocoD, 3, 2);

    for i := 0 to Length(aVal) - 1 do
    begin
      if sPos1 = aVal[i] then
      begin
        if i >= 100 then
           sBlocoD1 := sBlocoD1 + Copy(IntToStr(i), 2, 2)
        else
           sBlocoD1 := sBlocoD1 + IntToStr(i);
        break;
      end;
    end;

    for i := 0 to Length(aVal) - 1 do
    begin
      if sPos2 = aVal[i] then
      begin
        if i >= 100 then
           sBlocoD1 := sBlocoD1 + Copy(IntToStr(i), 2, 2)
        else
           sBlocoD1 := sBlocoD1 + IntToStr(i);
        break;
      end;
    end;

    sChave := sBlocoA1+sBlocoB1+sBlocoC1+sBlocoD1+sBlocoE1;

    sMesAno := Copy(sChave, 1, 4)+Copy(sChave, 7, 2);
    sDias   := Copy(sChave, 5, 2);
    sIdent  := Copy(sChave, 9, 14);

    dIdentificador := (StrToFloat(sIdent) - StrToInt(sMesAno));

    result := gerarDigitoZero(FloatToStr(dIdentificador), 14);
  except
    result := '';
  end;
end;

function TValidar.getMesAnoChave(sChave: string): string;
var
  sBlocoA, sBlocoB, sBlocoC, sBlocoD, sBlocoE: string;
  sBlocoA1, sBlocoB1, sBlocoC1, sBlocoD1, sBlocoE1: string;
  sIdent, sDias, sMesAno: string;
  sPos1, sPos2: string;
  i, y: integer;
begin
  try
    sBlocoA := Copy(sChave, 1, 5);
    sBlocoB := Copy(sChave, 7, 4);
    sBlocoC := Copy(sChave, 12, 4);
    sBlocoD := Copy(sChave, 17, 4);
    sBlocoE := Copy(sChave, 22, 5);

    {Bloco A}
    sBlocoA1 := '';
    for y := 1 to Length(sBlocoA) do
    begin
      for i := 0 to Length(aVal) - 1 do
      begin
        if sBlocoA[y] = aVal[i] then
           sBlocoA1 := sBlocoA1 + IntToStr(i);

        if Length(sBlocoA1) = 5 then
           break;
      end;
    end;

    {Bloco E}
    sBlocoE1 := '';
    for y := 1 to Length(sBlocoE) do
    begin
      for i := 0 to Length(aVal) - 1 do
      begin
        if sBlocoE[y] = aVal[i] then
           sBlocoE1 := sBlocoE1 + IntToStr(i);

        if Length(sBlocoE1) = 5 then
           break;
      end;
    end;

    {Bloco B}
    sBlocoB1 := '';
    sPos1    := Copy(sBlocoB, 1, 2);
    sPos2    := Copy(sBlocoB, 3, 2);

    for i := 0 to Length(aVal) - 1 do
    begin
      if sPos1 = aVal[i] then
      begin
        if i >= 100 then
           sBlocoB1 := sBlocoB1 + Copy(IntToStr(i), 2, 2)
        else
           sBlocoB1 := sBlocoB1 + IntToStr(i);
        break;
      end;
    end;

    for i := 0 to Length(aVal) - 1 do
    begin
      if sPos2 = aVal[i] then
      begin
        if i >= 100 then
           sBlocoB1 := sBlocoB1 + Copy(IntToStr(i), 2, 2)
        else
           sBlocoB1 := sBlocoB1 + IntToStr(i);
        break;
      end;
    end;

    {Bloco C}
    sBlocoC1 := '';
    sPos1    := Copy(sBlocoC, 1, 2);
    sPos2    := Copy(sBlocoC, 3, 2);

    for i := 0 to Length(aVal) - 1 do
    begin
      if sPos1 = aVal[i] then
      begin
        if i >= 100 then
           sBlocoC1 := sBlocoC1 + Copy(IntToStr(i), 2, 2)
        else
           sBlocoC1 := sBlocoC1 + IntToStr(i);
        break;
      end;
    end;

    for i := 0 to Length(aVal) - 1 do
    begin
      if sPos2 = aVal[i] then
      begin
        if i >= 100 then
           sBlocoC1 := sBlocoC1 + Copy(IntToStr(i), 2, 2)
        else
           sBlocoC1 := sBlocoC1 + IntToStr(i);
        break;
      end;
    end;

    {Bloco D}
    sBlocoD1 := '';
    sPos1    := Copy(sBlocoD, 1, 2);
    sPos2    := Copy(sBlocoD, 3, 2);

    for i := 0 to Length(aVal) - 1 do
    begin
      if sPos1 = aVal[i] then
      begin
        if i >= 100 then
           sBlocoD1 := sBlocoD1 + Copy(IntToStr(i), 2, 2)
        else
           sBlocoD1 := sBlocoD1 + IntToStr(i);
        break;
      end;
    end;

    for i := 0 to Length(aVal) - 1 do
    begin
      if sPos2 = aVal[i] then
      begin
        if i >= 100 then
           sBlocoD1 := sBlocoD1 + Copy(IntToStr(i), 2, 2)
        else
           sBlocoD1 := sBlocoD1 + IntToStr(i);
        break;
      end;
    end;

    sChave := sBlocoA1+sBlocoB1+sBlocoC1+sBlocoD1+sBlocoE1;

    sMesAno := Copy(sChave, 1, 4)+Copy(sChave, 7, 2);

    result := sMesAno;
  except
    result := '';
  end;
end;

function TValidar.getSenhaAcessoUserG10(codigo: Integer): string;
var
  padrao : Integer;
  I: Integer;
  aux : string;
begin
  padrao := DateTimeToUnix(Date);
  padrao := Round((padrao/codigo));
  aux := '';
  for I := 2 to Length(IntToStr(padrao)) do
    aux := aux + IntToStr(padrao)[i];

  result := aux;
end;

function TValidar.getUltimoDiaDoMes(Data: TDateTime): integer;
begin
  result := DaysInMonth(Data);
end;

function TValidar.InverteString(sString: string): string;
var
  sStr:string;
begin
  sStr := ReverseString(sString);

  result := sStr;
end;

function TValidar.validaChaveSistema(sChave,
  sIdentificador: string): boolean;
var
  sBlocoA, sBlocoB, sBlocoC, sBlocoD, sBlocoE: string;
  sBlocoA1, sBlocoB1, sBlocoC1, sBlocoD1, sBlocoE1: string;
  sIdent, sDias, sMesAno, sIdentCH, sMsg: string;
  sPos1, sPos2: string;
  i, y: integer;
  dIdentCH: double;
begin
  try
    sBlocoA := Copy(sChave, 1, 5);
    sBlocoB := Copy(sChave, 7, 4);
    sBlocoC := Copy(sChave, 12, 4);
    sBlocoD := Copy(sChave, 17, 4);
    sBlocoE := Copy(sChave, 22, 5);

    if Length(sChave) <> 26 then
       raise exception.Create('Chave Inválida');

    if (Length(sBlocoA) <> 5) or (Length(sBlocoE) <> 5)then
       raise exception.Create('Chave Inválida');

    if (Length(sBlocoB) <> 4) or (Length(sBlocoC) <> 4) or (Length(sBlocoD) <> 4) then
       raise exception.Create('Chave Inválida');

    {Bloco A}
    sBlocoA1 := '';
    for y := 1 to Length(sBlocoA) do
    begin
      for i := 0 to Length(aVal) - 1 do
      begin
        if sBlocoA[y] = aVal[i] then
           sBlocoA1 := sBlocoA1 + IntToStr(i);

        if Length(sBlocoA1) = 5 then
           break;
          
      end;
    end;

    {Bloco E}
    sBlocoE1 := '';
    for y := 1 to Length(sBlocoE) do
    begin
      for i := 0 to Length(aVal) - 1 do
      begin
        if sBlocoE[y] = aVal[i] then
           sBlocoE1 := sBlocoE1 + IntToStr(i);

        if Length(sBlocoE1) = 5 then
           break;
      end;
    end;

    {Bloco B}
    sBlocoB1 := '';
    sPos1    := Copy(sBlocoB, 1, 2);
    sPos2    := Copy(sBlocoB, 3, 2);

    for i := 0 to Length(aVal) - 1 do
    begin
      if sPos1 = aVal[i] then
      begin
        if i >= 100 then
           sBlocoB1 := sBlocoB1 + Copy(IntToStr(i), 2, 2)
        else
           sBlocoB1 := sBlocoB1 + IntToStr(i);
        break;
      end;
    end;

    for i := 0 to Length(aVal) - 1 do
    begin
      if sPos2 = aVal[i] then
      begin
        if i >= 100 then
           sBlocoB1 := sBlocoB1 + Copy(IntToStr(i), 2, 2)
        else
           sBlocoB1 := sBlocoB1 + IntToStr(i);
        break;
      end;
    end;

    {Bloco C}
    sBlocoC1 := '';
    sPos1    := Copy(sBlocoC, 1, 2);
    sPos2    := Copy(sBlocoC, 3, 2);

    for i := 0 to Length(aVal) - 1 do
    begin
      if sPos1 = aVal[i] then
      begin
        if i >= 100 then
           sBlocoC1 := sBlocoC1 + Copy(IntToStr(i), 2, 2)
        else
           sBlocoC1 := sBlocoC1 + IntToStr(i);
        break;
      end;
    end;

    for i := 0 to Length(aVal) - 1 do
    begin
      if sPos2 = aVal[i] then
      begin
        if i >= 100 then
           sBlocoC1 := sBlocoC1 + Copy(IntToStr(i), 2, 2)
        else
           sBlocoC1 := sBlocoC1 + IntToStr(i);
        break;
      end;
    end;

    {Bloco D}
    sBlocoD1 := '';
    sPos1    := Copy(sBlocoD, 1, 2);
    sPos2    := Copy(sBlocoD, 3, 2);

    for i := 0 to Length(aVal) - 1 do
    begin
      if sPos1 = aVal[i] then
      begin
        if i >= 100 then
           sBlocoD1 := sBlocoD1 + Copy(IntToStr(i), 2, 2)
        else
           sBlocoD1 := sBlocoD1 + IntToStr(i);
        break;
      end;
    end;

    for i := 0 to Length(aVal) - 1 do
    begin
      if sPos2 = aVal[i] then
      begin
        if i >= 100 then
           sBlocoD1 := sBlocoD1 + Copy(IntToStr(i), 2, 2)
        else
           sBlocoD1 := sBlocoD1 + IntToStr(i);
        break;
      end;
    end;

    sChave := sBlocoA1+sBlocoB1+sBlocoC1+sBlocoD1+sBlocoE1;

    sMesAno  := Copy(sChave, 1, 4)+Copy(sChave, 7, 2);
    sDias    := Copy(sChave, 5, 2);
    sIdentCH := Copy(sChave, 9, 14);

    dIdentCH :=  StrToFloat(sIdentCH) - StrToFloat(sMesAno);
    sIdent   := gerarDigitoZero(FloatToStr(dIdentCH), 14);

    result := true;
    if Trim(sIdentificador) <> Trim(sIdent) then
       result := false;
  except
    on E: Exception do
    begin
      result := false;
      sMsg   := E.Message;
    end;
  end;
end;

function TValidar.casasDecimais(sValor: string): integer;
var
  iCount, iPos, iCasas: integer;
begin
  iPos := Pos(',', sValor);

  if iPos = 0 then
     iCasas := 1
  else
  begin
    iCasas := 0;
    for iCount := iPos + 1 to length(sValor) do
        Inc(iCasas);
  end;

  result := iCasas;
end;


function TValidar.CentralizaString(sString: string; iTamanhoLinha: integer): string;
var
  iDif, iDist: integer;
  sStringCent: string;
begin
  try
    iDif  := iTamanhoLinha - Length(sString);
    iDist := Trunc(iDif / 2)+Length(sString);

    sStringCent := PreencherString(sString, ' ', iDist, 'E');
  finally
    result := sStringCent;
  end;
end;

function TValidar.chaveEstaQueimada(sChave: string): boolean;
var
  sBlocoA, sBlocoB, sBlocoC, sBlocoD, sBlocoE: string;
  sBlocoA1, sBlocoB1, sBlocoC1, sBlocoD1, sBlocoE1: string;
  sIdent, sDias, sMesAno: string;
  sPos1, sPos2: string;
  i, y: integer;
  bQueimada: boolean;
begin
  try
    sBlocoA := Copy(sChave, 1, 5);
    sBlocoB := Copy(sChave, 7, 4);
    sBlocoC := Copy(sChave, 12, 4);
    sBlocoD := Copy(sChave, 17, 4);
    sBlocoE := Copy(sChave, 22, 5);

    {Bloco A}
    sBlocoA1 := '';
    for y := 1 to Length(sBlocoA) do
    begin
      for i := 0 to Length(aVal) - 1 do
      begin
        if sBlocoA[y] = aVal[i] then
           sBlocoA1 := sBlocoA1 + IntToStr(i);

        if Length(sBlocoA1) = 5 then
           break;
      end;
    end;

    {Bloco E}
    sBlocoE1 := '';
    for y := 1 to Length(sBlocoE) do
    begin
      for i := 0 to Length(aVal) - 1 do
      begin
        if sBlocoE[y] = aVal[i] then
           sBlocoE1 := sBlocoE1 + IntToStr(i);

        if Length(sBlocoE1) = 5 then
           break;
      end;
    end;

    {Bloco B}
    sBlocoB1 := '';
    sPos1    := Copy(sBlocoB, 1, 2);
    sPos2    := Copy(sBlocoB, 3, 2);

    for i := 0 to Length(aVal) - 1 do
    begin
      if sPos1 = aVal[i] then
      begin
        if i >= 100 then
           sBlocoB1 := sBlocoB1 + Copy(IntToStr(i), 2, 2)
        else
           sBlocoB1 := sBlocoB1 + IntToStr(i);
        break;
      end;
    end;

    for i := 0 to Length(aVal) - 1 do
    begin
      if sPos2 = aVal[i] then
      begin
        if i >= 100 then
           sBlocoB1 := sBlocoB1 + Copy(IntToStr(i), 2, 2)
        else
           sBlocoB1 := sBlocoB1 + IntToStr(i);
        break;
      end;
    end;

    {Bloco C}
    sBlocoC1 := '';
    sPos1    := Copy(sBlocoC, 1, 2);
    sPos2    := Copy(sBlocoC, 3, 2);

    for i := 0 to Length(aVal) - 1 do
    begin
      if sPos1 = aVal[i] then
      begin
        if i >= 100 then
           sBlocoC1 := sBlocoC1 + Copy(IntToStr(i), 2, 2)
        else
           sBlocoC1 := sBlocoC1 + IntToStr(i);
        break;
      end;
    end;

    for i := 0 to Length(aVal) - 1 do
    begin
      if sPos2 = aVal[i] then
      begin
        if i >= 100 then
           sBlocoC1 := sBlocoC1 + Copy(IntToStr(i), 2, 2)
        else
           sBlocoC1 := sBlocoC1 + IntToStr(i);
        break;
      end;
    end;

    {Bloco D}
    sBlocoD1 := '';
    sPos1    := Copy(sBlocoD, 1, 2);
    sPos2    := Copy(sBlocoD, 3, 2);

    for i := 0 to Length(aVal) - 1 do
    begin
      if sPos1 = aVal[i] then
      begin
        if i >= 100 then
           sBlocoD1 := sBlocoD1 + Copy(IntToStr(i), 2, 2)
        else
           sBlocoD1 := sBlocoD1 + IntToStr(i);
        break;
      end;
    end;

    for i := 0 to Length(aVal) - 1 do
    begin
      if sPos2 = aVal[i] then
      begin
        if i >= 100 then
           sBlocoD1 := sBlocoD1 + Copy(IntToStr(i), 2, 2)
        else
           sBlocoD1 := sBlocoD1 + IntToStr(i);
        break;
      end;
    end;

    sChave := sBlocoA1+sBlocoB1+sBlocoC1+sBlocoD1+sBlocoE1;

    bQueimada := (Copy(sChave,3,1) = '3');

    result := bQueimada;
  except
    result := true;
  end;
end;

procedure TValidar.creaProcesso(sProcesso: string; bMostrarJanela: boolean);
var
  SUInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  bExecutou: boolean;
begin
  FillChar(SUInfo, SizeOf(SUInfo), #0);
  SUInfo.cb      := SizeOf(SUInfo);
  SUInfo.dwFlags := STARTF_USESHOWWINDOW;

  if not bMostrarJanela then
     SUInfo.wShowWindow := SW_HIDE
  else
     SUInfo.wShowWindow := SW_SHOWNORMAL;

  bExecutou := CreateProcess(nil,
                             PChar(sProcesso),
                             nil,
                             nil,
                             false,
                             CREATE_NEW_CONSOLE or
                             NORMAL_PRIORITY_CLASS,
                             nil,
                             nil,
                             SUInfo,
                             ProcInfo);
end;

{function TValidar.geraMd5(sString: string): string;
var
  sChave, sMd5: string;
  DCP_rc  : TDCP_rc4;
  DCP_sha1: TDCP_sha1;
begin
  DCP_rc   := TDCP_rc4.Create(DCP_rc4);
  DCP_sha1 := TDCP_sha1.Create(DCP_sha11);
  try
  sChave   := 'RAIANeEliane';


  DCP_sha1.Init;
  DCP_sha1.UpdateStr(sChave+sString);
  DCP_sha1.Final(SHA1Digest);

  sMd5 := LowerCase(BufferToHex(SHA1Digest, SizeOf(SHA1Digest)));

  result := sMd5;
  finally
   DCP_rc.Free;
   DCP_sha1.Free;
  end;
end;}

procedure TValidar.reiniciarAplicacao;
var
  Bat: TStringList;
  sAPP: string;
begin
  if FileExists(ExtractFilePath(Application.ExeName)+'raio.bat') then
     DeleteFile(ExtractFilePath(Application.ExeName)+'raio.bat');


  sAPP := ExtractFileName(Application.ExeName);
  Bat  := TStringList.Create;

  Bat.Add('@echo off');
  Bat.Add('taskkill /F /IM '+sAPP);
  Bat.Add('start '+ExtractFilePath(Application.ExeName)+sAPP);
  Bat.SaveToFile(ExtractFilePath(Application.ExeName)+'raio.bat');
  Bat.Free;

  while not FileExists(ExtractFilePath(Application.ExeName)+'raio.bat') do
  begin
  end;

  creaProcesso(ExtractFilePath(Application.ExeName)+'raio.bat', false);

  Sleep(5000);
end;

function TValidar.removeBarras(str: string): string;
var
  i: integer;
begin
  for i := 1 to length(str) do
    if str[i] = '/' then
       str[i] := '_';

  for i := 1 to length(str) do
    if str[i] = '\' then
       str[i] := '_';

  result := str;
end;

function TValidar.removeNumero(sString: string): string;
var
  aNum: string;
  i, x: integer;
  sNum: string;
begin
  aNum := '0123456789';

  sNum := '';
  for i := 1 to Length(sString) do
  begin
    for x := 1 to Length(aNum) do
    begin
      if (Trim(sString[i]) = Trim(aNum[x])) then
          sNum := Trim(sNum) + Trim(sString[i]);
    end;
  end;

  result := sNum;
end;

function TValidar.removePonto(sValor: string): string;
var
  aNum: string;
  i, x: integer;
  sNum: string;
begin
  aNum := '0123456789,';

  sNum := '';
  for i := 1 to Length(sValor) do
  begin
    for x := 1 to Length(aNum) do
    begin
      if (Trim(sValor[i]) = Trim(aNum[x])) then
          sNum := Trim(sNum) + Trim(sValor[i]);
    end;
  end;

  result := sNum;
end;

function TValidar.firstName(sNome: string): string;
var
  sName, sSpace: string;
  iPos, iNum : Integer;
begin
  sNome := Trim(sNome);
  sName := '';
  for iNum := 1 To Length(sNome)  do
  begin
    sSpace := copy(sNome, iNum, 1);
    if sSpace <> ' ' then
       sName := sName + sSpace
    else
       break;
  end;

  result := sName;
end;

function TValidar.formatDir(sString: string): string;
var
  aNum: string;
  i, x: integer;
  sNum: string;
begin
  aNum := '\/:*?"<>|º';

  sNum := '';
  for i := 1 to Length(sString) do
  begin
    for x := 1 to Length(aNum) do
    begin
      if (sString[i] = aNum[x]) then
          sString[i] := '.';
    end;
  end;

  result := sString;
end;

function TValidar.FormatString(sString, sMascara: string): string;
var
  sStr: string;
  i,iSt:Integer;
begin
  sStr := '';
  if Trim(sString) <> '' then
  begin
    iSt  := 1;
    for i := 1 to Length(sMascara) do
    begin
      if getENumero(sMascara[i]) then
      begin
        sStr := sStr + sString[iSt];
        Inc(iSt);
      end
      else
        sStr := sStr + sMascara[i];
    end;
  end;

  result := sStr;
end;

function TValidar.sGCPath(sPath: string): string;
var
  iIndex, iContBarra, iPosBarra: integer;
begin
  iContBarra := 0;
  iPosBarra  := 0;

  for iIndex := Length(sPath) downto 0 do
  begin
    if sPath[iIndex] = '\' then
       Inc(iContBarra);

    if iContBarra = 2 then
    begin
      iPosBarra := iIndex;
      break;
    end;
  end;
  sPath  := Copy(sPath, 1, iPosBarra);
  result := sPath;
end;

function TValidar.geraChaveSistema(Identificador: string;
  iQtdeDias: integer): string;
var
  sBlocoA, sBlocoB, sBlocoC, sBlocoD, sBlocoE: string;
  sChave, sCodigo, sIdent, sDias, sMesAno: string;
  wDia, wMes, wAno: word;
  iPos1, iPos2: integer;
  dIdentificador, dMesAno: double;
begin
  DecodeDate(Now, wAno, wMes, wDia);
  sMesAno := IntToStr(wMes)+IntToStr(wAno);

  dIdentificador := StrToFloat(Identificador);
  dMesAno        := StrToFloat(sMesAno);

  sIdent  := FloatToStr(dIdentificador + dMesAno);
  sDias   := gerarDigitoZero(IntToStr(iQtdeDias), 2);
  sCodigo := gerarDigitoZero(IntToStr(wMes), 2)+IntToStr(wAno);

  sChave  := Copy(sCodigo, 1, 2)+Copy(sCodigo, 3, 2)+sDias+Copy(sCodigo, 5, 2)+gerarDigitoZero(sIdent, 14);

  sBlocoA := Copy(sChave, 1, 5);
  sBlocoB := Copy(sChave, 6, 4);
  sBlocoC := Copy(sChave, 10, 4);
  sBlocoD := Copy(sChave, 14, 4);
  sBlocoE := Copy(sChave, 18, 5);

  sBlocoA :=
  aVal[StrToInt(sBlocoA[1])]+
  aVal[StrToInt(sBlocoA[2])]+
  aVal[StrToInt(sBlocoA[3])]+
  aVal[StrToInt(sBlocoA[4])]+
  aVal[StrToInt(sBlocoA[5])];

  {--------------------------------------}
  iPos1 := StrToInt(Copy(sBlocoB, 1, 2));
  iPos2 := StrToInt(Copy(sBlocoB, 3, 2));

  case iPos1 of
    0: iPos1 := 100;
    1: iPos1 := 101;
    2: iPos1 := 102;
    3: iPos1 := 103;
    4: iPos1 := 104;
    5: iPos1 := 105;
    6: iPos1 := 106;
    7: iPos1 := 107;
    8: iPos1 := 108;
    9: iPos1 := 109;
  end;

  case iPos2 of
    0: iPos2 := 100;
    1: iPos2 := 101;
    2: iPos2 := 102;
    3: iPos2 := 103;
    4: iPos2 := 104;
    5: iPos2 := 105;
    6: iPos2 := 106;
    7: iPos2 := 107;
    8: iPos2 := 108;
    9: iPos2 := 109;
  end;

  sBlocoB := aVal[iPos1]+aVal[iPos2];

  {--------------------------------------}
  iPos1 := StrToInt(Copy(sBlocoC, 1, 2));
  iPos2 := StrToInt(Copy(sBlocoC, 3, 2));

  case iPos1 of
    0: iPos1 := 100;
    1: iPos1 := 101;
    2: iPos1 := 102;
    3: iPos1 := 103;
    4: iPos1 := 104;
    5: iPos1 := 105;
    6: iPos1 := 106;
    7: iPos1 := 107;
    8: iPos1 := 108;
    9: iPos1 := 109;
  end;

  case iPos2 of
    0: iPos2 := 100;
    1: iPos2 := 101;
    2: iPos2 := 102;
    3: iPos2 := 103;
    4: iPos2 := 104;
    5: iPos2 := 105;
    6: iPos2 := 106;
    7: iPos2 := 107;
    8: iPos2 := 108;
    9: iPos2 := 109;
  end;

  sBlocoC := aVal[iPos1]+aVal[iPos2];

  {--------------------------------------}
  iPos1 := StrToInt(Copy(sBlocoD, 1, 2));
  iPos2 := StrToInt(Copy(sBlocoD, 3, 2));

  case iPos1 of
    0: iPos1 := 100;
    1: iPos1 := 101;
    2: iPos1 := 102;
    3: iPos1 := 103;
    4: iPos1 := 104;
    5: iPos1 := 105;
    6: iPos1 := 106;
    7: iPos1 := 107;
    8: iPos1 := 108;
    9: iPos1 := 109;
  end;

  case iPos2 of
    0: iPos2 := 100;
    1: iPos2 := 101;
    2: iPos2 := 102;
    3: iPos2 := 103;
    4: iPos2 := 104;
    5: iPos2 := 105;
    6: iPos2 := 106;
    7: iPos2 := 107;
    8: iPos2 := 108;
    9: iPos2 := 109;
  end;

  sBlocoD := aVal[iPos1]+aVal[iPos2];
  {--------------------------------------}

  sBlocoE :=
  aVal[StrToInt(sBlocoE[1])]+
  aVal[StrToInt(sBlocoE[2])]+
  aVal[StrToInt(sBlocoE[3])]+
  aVal[StrToInt(sBlocoE[4])]+
  aVal[StrToInt(sBlocoE[5])];

  sChave := sBlocoA+'-'+sBlocoB+'-'+sBlocoC+'-'+sBlocoD+'-'+sBlocoE;

  result := sChave;
end;

function TValidar.StrToCurrency(sValor: string): currency;
var
  aNum: string;
  i, x: integer;
  sNum: string;
  cValor: currency;
begin
  aNum := '-0123456789,';

  if sValor = '' then
     sValor := '0';

  sNum := '';
  for i := 1 to Length(sValor) do
  begin
    for x := 1 to Length(aNum) do
    begin
      if (Trim(sValor[i]) = Trim(aNum[x])) then
          sNum := Trim(sNum) + Trim(sValor[i]);
    end;
  end;

  result := StrToFloatDef(sNum, 0);
end;

end.
