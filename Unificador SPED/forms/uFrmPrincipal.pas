unit uFrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtDlgs;

type
  TfrmPrincipal = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    edtArquivo: TEdit;
    btn_GerarArquivo: TSpeedButton;
    btn_Matriz: TSpeedButton;
    memoFiliais: TMemo;
    btn_Filiais: TSpeedButton;
    OpenTextFileDialog1: TOpenTextFileDialog;
    SaveTextFileDialog1: TSaveTextFileDialog;

    procedure btn_MatrizClick(Sender: TObject);
    procedure btn_FiliaisClick(Sender: TObject);
    procedure btn_GerarArquivoClick(Sender: TObject);
    procedure IdentificacaoDaEmpresa(arquivo: TStringList; var final: TStringList);

    procedure LinhasBloco0(arquivo: TStringList; var final: TStringList);
    procedure LinhasBloco0OutrosRegistros(arquivo: TStringList; var final: TStringList);
    procedure LinhasBloco(bloco: String; arquivo: TStringList; var final: TStringList);

    procedure MontaBloco(bloco: String; var ArqFinal: TStringList);
    procedure MontaBlocoZeroOutReg(ArqBloco: TStringList; var ArqFinal: TStringList);
    procedure MontaBloco0(ArqBloco0: TStringList; var ArqFinal: TStringList);
    procedure MontarBlocoM(var ArqFinal: TStringList);
    procedure MontarBlocoPaiFilho(campoPai, campoFilho: String;arqMatriz: TStringList; arqFilial: TStringList; var final: TStringList);

    procedure TotalizaLinhas(var ArqFinal: TStringList);

    function RetornarValor (linha: String; posicao: integer): string;
    function GetLinha (campo: String; arquivo: TStringList): string;
    function GetTamanhoCampo (campo: String): integer;
    function VerififRegIdentEmp(valor: String): Boolean;
    function VerififRegOutReg(valor: String): Boolean;
    function somarCamposLinha (bloco: string; posicoes: array of integer; var ArqFinal: TStringList): string;
    function numeroNoArray(const ANumber: integer; const AArray: array of integer):Boolean;
  private
  public
  end;

var
  frmPrincipal: TfrmPrincipal;

  BlocoZeroIdentEmpresa: Array [0 .. 5] of String = (
    '0000',
    '0001',
    '0035',
    '0100',
    '0110',
    '0120'
  );

  BlocoZeroOutReg: Array [0 .. 1] of String = (
    '0500',
    '0600'
  );

implementation

{$R *.dfm}


procedure TfrmPrincipal.btn_FiliaisClick(Sender: TObject);
begin
  if OpenTextFileDialog1.Execute then
    memoFiliais.Lines.Add(OpenTextFileDialog1.FileName);
end;

procedure TfrmPrincipal.btn_GerarArquivoClick(Sender: TObject);
var
  ArqFinal, ArqTemp, ArqBlocoZeroOutReg: TStringList;
  i: Integer;
begin
  if edtArquivo.Text = '' then
    Exit;

  if memoFiliais.Lines.Count = 0 then
    Exit;

  ArqFinal := TStringList.Create;
  ArqTemp := TStringList.Create;
  ArqBlocoZeroOutReg := TStringList.Create;
  try
    btn_GerarArquivo.Enabled := False;

    ArqTemp.LoadFromFile(edtArquivo.Text);
    IdentificacaoDaEmpresa(ArqTemp, ArqFinal);
    LinhasBloco0OutrosRegistros(ArqTemp, ArqBlocoZeroOutReg);
    LinhasBloco0(ArqTemp, ArqFinal);

    ArqTemp.LoadFromFile(edtArquivo.Text);

    for i := 0 to memoFiliais.Lines.Count - 1 do
    begin
      ArqTemp.LoadFromFile(memoFiliais.Lines[i]);
      LinhasBloco0(ArqTemp, ArqFinal);
      LinhasBloco0OutrosRegistros(ArqTemp, ArqBlocoZeroOutReg);
    end;

    MontaBlocoZeroOutReg(ArqBlocoZeroOutReg, ArqFinal);
    ArqFinal.Add('|0990|' + IntToStr(ArqFinal.Count + 1) + '|');

    MontaBloco('A', ArqFinal);
    MontaBloco('C', ArqFinal);
    MontaBloco('D', ArqFinal);
    MontaBloco('F', ArqFinal);
    MontarBlocoM(ArqFinal);
    MontaBloco('1', ArqFinal);

    TotalizaLinhas(ArqFinal);

    SaveTextFileDialog1.Title := 'Salvar arquivo Unificado';

    if SaveTextFileDialog1.Execute then
      ArqFinal.SaveToFile(SaveTextFileDialog1.FileName);

    Application.MessageBox('Arquivo gerado com sucesso!', 'Informação', MB_ICONINFORMATION + MB_OK);
  finally
    btn_GerarArquivo.Enabled := True;
    ArqTemp.Free;
    ArqFinal.Free;
  end;

end;

procedure TfrmPrincipal.btn_MatrizClick(Sender: TObject);
begin
  if OpenTextFileDialog1.Execute then
    edtArquivo.Text := OpenTextFileDialog1.FileName;
end;

function TfrmPrincipal.GetLinha(campo: String; arquivo: TStringList): string;
var
  i: Integer;
  temp: String;
begin
  for i := 1 to arquivo.Count - 1 do
  begin
    temp := copy(arquivo[i], 2, 4);
    if AnsiCompareStr(temp, campo) = 0 then
    begin
      Result := arquivo[i];
      exit;
    end;
  end;
end;


function TfrmPrincipal.GetTamanhoCampo(campo: String): integer;
var
  i, cont, posLinha, posFinal: Integer;
begin
  cont := 0;
  posLinha := 0;
  posFinal := 0;

  for i := 1 to campo.Length do
    if AnsiCompareStr(campo[i], '|') = 0 then
      inc(cont);

  result := cont - 1;
end;

function TfrmPrincipal.VerififRegIdentEmp(valor: String): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := Low(BlocoZeroIdentEmpresa) to High(BlocoZeroIdentEmpresa) do
  begin
    if BlocoZeroIdentEmpresa[i] = valor then
    begin
      Result := True;
      Break;
    end;
  end;
end;

function TfrmPrincipal.VerififRegOutReg(valor: String): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := Low(BlocoZeroOutReg) to High(BlocoZeroOutReg) do
  begin
    if BlocoZeroOutReg[i] = valor then
    begin
      Result := True;
      Break;
    end;
  end;
end;

procedure TfrmPrincipal.IdentificacaoDaEmpresa(arquivo: TStringList; var final: TStringList);
var
  i: Integer;
  linha: String;
begin
  for i := 0 to arquivo.Count - 1 do
  begin
    linha := copy(arquivo[i], 2, 4);
    if VerififRegIdentEmp(linha) then
      final.Add(arquivo[i]);
  end;

end;

procedure TfrmPrincipal.LinhasBloco(bloco: String; arquivo: TStringList; var final: TStringList);
var
  i: Integer;
  linha, linhaBloco, Str1, Str2: String;
begin
  Str1 := bloco + '001';
  Str2 := bloco + '990';

  for i := 0 to arquivo.Count - 1 do
  begin
    linha := copy(arquivo[i], 2, 4);
    linhaBloco := copy(arquivo[i], 2, 1);

    if (((linha <> Str1) and (linha <> Str2)) and (linhaBloco = bloco)) then
      final.Add(arquivo[i]);
  end;
end;

procedure TfrmPrincipal.LinhasBloco0(arquivo: TStringList; var final: TStringList);
var
  i: Integer;
  linha: String;
begin
  for i := 0 to arquivo.Count - 1 do
  begin
    linha := copy(arquivo[i], 2, 4);
    if not VerififRegIdentEmp(linha) and not VerififRegOutReg(linha) and (linha <> '0990') and (copy(linha, 1, 1) = '0') then
      final.Add(arquivo[i]);
  end;
end;

procedure TfrmPrincipal.LinhasBloco0OutrosRegistros(arquivo: TStringList; var final: TStringList);
var
  i: Integer;
  linha: String;
begin
  for i := 0 to arquivo.Count - 1 do
  begin
    linha := copy(arquivo[i], 2, 4);
    if VerififRegOutReg(linha) then
      final.Add(arquivo[i]);
  end;
end;

procedure TfrmPrincipal.MontaBlocoZeroOutReg(ArqBloco: TStringList; var ArqFinal: TStringList);
var
  i: Integer;
begin
  for i := 0 to ArqBloco.Count - 1 do
    ArqFinal.Add(ArqBloco[i]);
end;

procedure TfrmPrincipal.MontarBlocoM(var ArqFinal: TStringList);
var
  arquivo, ArqTemp: TStringList;
  matriz, filial: TStringList;
  i, j: Integer;
  linha: String;

  temp: Array [1..50] of real;
begin
  try
    arquivo := TStringList.Create;
    ArqTemp := TStringList.Create;

    matriz := TStringList.Create;
    filial := TStringList.Create;

    matriz.LoadFromFile(edtArquivo.Text);
    filial.LoadFromFile(memoFiliais.Lines[0]);

    ArqTemp.Add(somarCamposLinha('M200', [9, 12, 13], ArqFinal));
    ArqTemp.Add(somarCamposLinha('M205', [4], ArqFinal));
    ArqTemp.Add(somarCamposLinha('M210', [3, 4, 7, 11, 16], ArqFinal));
    MontarBlocoPaiFilho('M400', 'M410', matriz, filial, ArqTemp);
    ArqTemp.Add(somarCamposLinha('M600', [9, 12, 13], ArqFinal));
    ArqTemp.Add(somarCamposLinha('M605', [4], ArqFinal));
    ArqTemp.Add(somarCamposLinha('M610', [3, 4, 7, 11, 16], ArqFinal));
    MontarBlocoPaiFilho('M800', 'M810', matriz, filial, ArqTemp);

    if ArqTemp.Count > 0 then
    begin
      ArqFinal.Add('|M001|0|');
      for i := 0 to ArqTemp.Count - 1 do
        ArqFinal.Add(ArqTemp[i]);
      ArqFinal.Add('|M990|' + IntToStr(ArqTemp.Count + 2) + '|');
    end
    else
    begin
      ArqFinal.Add('|M001|1|');
      ArqFinal.Add('|M990|2|');
    end;
  finally
    ArqTemp.Free;
  end;
end;

function TfrmPrincipal.RetornarValor(linha: String; posicao: integer): String;
var
  i, cont, posicaoInicial, deslocamento: Integer;
begin
  cont := 0;
  posicaoInicial := 0;
  deslocamento := 0;

  for i := 1 to linha.Length do
  begin
    if AnsiCompareStr(linha[i], '|') = 0 then
    begin
      inc(cont);
      deslocamento := i - posicaoInicial;

      if cont = posicao + 1 then
        break;

      posicaoInicial := i + 1;
    end;
  end;

  if deslocamento = 0 then
    result := '-1'
  else
    result := copy(linha, posicaoInicial, deslocamento);
end;

function TfrmPrincipal.somarCamposLinha(bloco: string; posicoes: array of integer;
  var ArqFinal: TStringList): string;
var
  arquivo, ArqTemp: TStringList;
  i, j: Integer;
  linha: String;

  linhaFinal: string;

  temp: Array [1..50] of real;
begin
  try
    arquivo := TStringList.Create;
    ArqTemp := TStringList.Create;

    arquivo.LoadFromFile(edtArquivo.Text);
    linha := GetLinha(bloco, arquivo);

    for i := 2 to GetTamanhoCampo(linha) do
      temp[i] := StrToFloat(RetornarValor(linha, i));

    for i := 0 to memoFiliais.Lines.Count - 1  do
    begin
      arquivo.LoadFromFile(memoFiliais.Lines[i]);
      linha := GetLinha(bloco , arquivo);

      for j := 2 to GetTamanhoCampo(linha) do
      begin
        if numeroNoArray(j, posicoes) then
          temp[j] := temp[j] + StrToFloat(RetornarValor(linha, j))
        else
          temp[j] := StrToFloat(RetornarValor(linha, j));
      end;
      arquivo.Clear;
    end;

    linhaFinal := '|' + bloco + '|';

    for i := 2 to GetTamanhoCampo(linha) do
    begin
      if temp[i] = -1 then
        linhaFinal := linhaFinal + '|'
      else
        linhaFinal := linhaFinal + FloatToStr(temp[i]) + '|';
    end;

    result := linhaFinal;
  finally
    ArqTemp.Free;
  end;
end;


procedure TfrmPrincipal.MontaBloco(bloco: String; var ArqFinal: TStringList);
var
  arquivo, ArqTemp: TStringList;
  i: Integer;
begin
  try
    arquivo := TStringList.Create;
    ArqTemp := TStringList.Create;

    { Matriz }
    arquivo.LoadFromFile(edtArquivo.Text);
    LinhasBloco(bloco, arquivo, ArqTemp);

    { Filiais }
    for i := 0 to memoFiliais.Lines.Count - 1 do
    begin
      arquivo.LoadFromFile(memoFiliais.Lines[i]);
      LinhasBloco(bloco, arquivo, ArqTemp);
      arquivo.Clear;
    end;

    if ArqTemp.Count > 0 then
    begin
      ArqFinal.Add('|' + bloco + '001|0|');
      for i := 0 to ArqTemp.Count - 1 do
        ArqFinal.Add(ArqTemp[i]);
      ArqFinal.Add('|' + bloco + '990|' + IntToStr(ArqTemp.Count + 2) + '|');
    end
    else
    begin
      ArqFinal.Add('|' + bloco + '001|1|');
      ArqFinal.Add('|' + bloco + '990|2|');
    end;
  finally
    ArqTemp.Free;
  end;
end;

procedure TfrmPrincipal.MontaBloco0(ArqBloco0: TStringList; var ArqFinal: TStringList);
var
  i, J: Integer;
  linha: String;
const
  BlocoZero: Array [1 .. 14] of String = ('0111', '0120', '0140', '0145', '0150', '0190', '0200', '0205', '0206', '0208', '0400', '0450', '0500', '0600');
begin
  for i := 0 to High(BlocoZero) - 1 do
  begin
    for J := 0 to ArqBloco0.Count - 1 do
    begin
      linha := copy(ArqBloco0[J], 2, 4);
      if linha = BlocoZero[i] then
        ArqFinal.Add(ArqBloco0[J]);
    end;
  end;
end;

procedure TfrmPrincipal.TotalizaLinhas(var ArqFinal: TStringList);
var
  linha: String;
  i, J, cont: Integer;
  ArqTemp: TStringList;

const
  bloco: Array [1 .. 113] of String = ('9001', '0000', '0001', '0100', '0110', '0111', '0120', '0140', '0145', '0150', '0190', '0200', '0205', '0206', '0208', '0400', '0450', '0500', '0600', '0990', 'A001', 'A010', 'A100', 'A110', 'A111', 'A120', 'A170',
    'A990', 'C001', 'C010', 'C100', 'C110', 'C111', 'C120', 'C170', 'C175', 'C180', 'C181', 'C185', 'C188', 'C190', 'C191', 'C195', 'C198', 'C199', 'C380', 'C381', 'C385', 'C395', 'C396', 'C400', 'C405', 'C481', 'C485', 'C489', 'C490', 'C491', 'C495', 'C499',
    'C500', 'C501', 'C505', 'C509', 'C600', 'C601', 'C605', 'C609', 'C990', 'D001', 'D010', 'D100', 'D101', 'D105', 'D111', 'D200', 'D201', 'D205', 'D209', 'D300', 'D309', 'D350', 'D359', 'D500', 'D501', 'D505', 'D509', 'D600', 'D601', 'D605', 'D609',
    'D990', 'F001', 'F010', 'F550', 'F990', 'M001', 'M200', 'M205', 'M210', 'M400', 'M410', 'M600', 'M605', 'M610', 'M800', 'M810', 'M990', '1001', '1900', '1990', '1100', '1500', '9900');
begin

  ArqTemp := TStringList.Create;

  ArqFinal.Add('|9001|0|');

  for J := Low(bloco) to High(bloco) do
  begin
    cont := 0;
    for i := 0 to ArqFinal.Count - 1 do
    begin
      linha := copy(ArqFinal[i], 2, 4);
      if linha = bloco[J] then
        inc(cont);
    end;

    if cont > 0 then
      ArqTemp.Add('|9900|' + bloco[J] + '|' + IntToStr(cont) + '|');
  end;

  ArqTemp.Add('|9900|9900|' + IntToStr(ArqTemp.Count) + '|');
  ArqTemp.Add('|9900|9990|1|');
  ArqTemp.Add('|9900|9999|1|');
  ArqTemp.Add('|9990|' + IntToStr(ArqTemp.Count + 3) + '|');

  for i := 0 to ArqTemp.Count - 1 do
    ArqFinal.Add(ArqTemp[i]);

  ArqFinal.Add('|9999|' + IntToStr(ArqFinal.Count + 1) + '|');
end;

function TfrmPrincipal.numeroNoArray(const ANumber: integer;
  const AArray: array of integer): boolean;
var
  i: integer;
begin
  for i := Low(AArray) to High(AArray) do
    if ANumber = AArray[i] then
      Exit(true);
  result := false;
end;

procedure TfrmPrincipal.MontarBlocoPaiFilho(campoPai, campoFilho: String; arqMatriz,
  arqFilial: TStringList; var final: TStringList);
var
  i: Integer;
  linha, linhaBloco, Str1, Str2: String;
begin

  Str1 := 'M001';
  Str2 := 'M990';

  for i := 0 to arqMatriz.Count - 1 do
  begin
    linha := copy(arqMatriz[i], 2, 4);
    linhaBloco := copy(arqMatriz[i], 2, 1);

    if ((((linha <> Str1) and (linha <> Str2)) and (linha = campoPai)) or (linha = campoFilho)) then
    begin
      final.Add(arqMatriz[i]);
    end;
  end;

  for i := 0 to arqFilial.Count - 1 do
  begin
    linha := copy(arqFilial[i], 2, 4);
    linhaBloco := copy(arqFilial[i], 2, 1);

    if ((((linha <> Str1) and (linha <> Str2)) and (linha = campoPai)) or (linha = campoFilho)) then
    begin
      final.Add(arqFilial[i]);
    end;
  end;
end;
end.
