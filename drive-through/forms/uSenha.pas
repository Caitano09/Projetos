unit uSenha;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, Buttons, ExtCtrls, DB, Menus, Variants, jpeg,
  Usuario, IniFiles, DCPcrypt2, DCPsha1, LbCipher, LbClass, LBUtils,
  DCPrc4, ShellAPI, Validar, ZAbstractRODataset, ZAbstractDataset,
  ZDataset, ACBrBase, ACBrValidador, UsuarioRN;

const
  VERSAO  = '19.1066.0233.0';
  SISTEMA = '1';

type
  TfrmSenha = class(TForm)
    Image: TImage;
    DCP_sha11: TDCP_sha1;
    edUsuario: TEdit;
    edSenha: TEdit;
    cbEmpresa: TComboBox;
    SpeedButton1: TSpeedButton;
    btnConfirmar: TSpeedButton;
    btnCancelar: TSpeedButton;
    lblVersao: TLabel;
    chkSalvarUserSenha: TCheckBox;
    lblOla: TLabel;
    lblUltAcesso: TLabel;
    lblNaoVc: TLabel;
    lblClickAqui: TLabel;
    zqGetEmp: TZQuery;
    ACBrValidador: TACBrValidador;
    procedure FormShow(Sender: TObject);
    procedure edUsuarioKeyPress(Sender: TObject; var Key: Char);
    procedure edSenhaKeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton1Click(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edUsuarioChange(Sender: TObject);
    procedure lblClickAquiClick(Sender: TObject);
  private
    UsuarioRn : TUsuarioRN;
    Usuario   : TUsuario;
    ConfigIni : TIniFile;
    Validar: TValidar;
    sEnderecoHost: string;
    User: TIniFile;
  public

    sVersaoSistema, sSistema: string;
    sEmpresa, sIdentificador: string;
    procedure ConectaServidor;
    procedure CriaForm(FormClasse: TFormClass; var NewForm: TObject);

  end;

var
  frmSenha: TfrmSenha;
  SHA1Digest: TSHA1Digest;
  ini: TInifile;
  bLoginYes: Boolean;
  UsuarioAcesso: TUsuario;

implementation

uses uPrincipal, udmPrincipal, uMsnLogin;

{$R *.dfm}


procedure TfrmSenha.CriaForm(FormClasse: TFormClass;
  var NewForm: TObject);
begin
  try
    if (TForm(NewForm) = nil) or (not TForm(NewForm).HandleAllocated) Then
       NewForm := FormClasse.Create(Self)
    else
    begin
      if (TForm(NewForm).WindowState = WsMinimized) Then
          TForm(NewForm).WindowState := wsNormal;
    end;
    TForm(NewForm).ShowModal;
  except
    on E: Exception do
    begin
      Application.MessageBox(PChar('Ocorreu o seguinte erro ao tentar carregar a tela solicitada:'+#13+E.Message+#13#13
                                  +'CONTATE O SUPORTE!'), 'Atenção', MB_ICONINFORMATION + MB_OK);
    end;
  end;
end;

function IsWindows64: Boolean;
type
  TIsWow64Process = function(AHandle:THandle; var AIsWow64: BOOL): BOOL; stdcall;
var
  vKernel32Handle: DWORD;
  vIsWow64Process: TIsWow64Process;
  vIsWow64: BOOL;
begin

  Result := False;

  vKernel32Handle := LoadLibrary('kernel32.dll');
  if (vKernel32Handle = 0) then Exit;

  try

    @vIsWow64Process := GetProcAddress(vKernel32Handle, 'IsWow64Process');
    if not Assigned(vIsWow64Process) then Exit;

    vIsWow64 := False;
    if (vIsWow64Process(GetCurrentProcess, vIsWow64)) then
      Result := vIsWow64;

  finally
    FreeLibrary(vKernel32Handle);
  end;
end;


Procedure EnDecryptFile(pathin, pathout : String; Chave : Word);

var

InMS, OutMS : TMemoryStream;

I : Integer;

C : byte;

begin

        InMS := TMemoryStream.Create;

        OutMS := TMemoryStream.Create;



        try

        InMS.LoadFromFile(pathin);

        InMS.Position := 0;



        for I := 0 to InMS.Size - 1 do

        begin

                InMS.Read(C, 1);

                C := (C xor not(ord(chave shr I)));

                OutMS.Write(C,1);

        end;



        OutMS.SaveToFile(pathout);



        finally



        InMS.Free;

        OutMS.Free;

end;

end;


procedure TfrmSenha.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
    Validar.Free;
    User.Free;
  finally
    Action := caFree;
    frmSenha:= nil;
  end;
end;

procedure TfrmSenha.FormShow(Sender: TObject);
begin
  ConectaServidor;

  Validar   := TValidar.Create;

  {if IsWindows64 then
     sEnderecoHost:='G:\Windows\SysWOW64\sgcpdv.ini'
  else
     sEnderecoHost:='G:\Windows\System32\sgcpdv.ini';
    }
    {Endereco de teste}
  sEnderecoHost:='G:\sgcpdv.ini';

  User := TIniFile.Create(sEnderecoHost);

  chkSalvarUserSenha.Visible := (Validar.getChaveConfiguracao('login', 'salvarUS') = '1');

  if chkSalvarUserSenha.Visible then
  begin
    if User.ReadString('user', 'user', '') <> '' then
    begin
      edUsuario.Text       := User.ReadString('user', 'user', '');
      edSenha.Text         := User.ReadString('user', 'password', '');
      lblOla.Caption       := 'Olá '+Validar.formataNome(User.ReadString('user', 'name',''))+',';
      lblUltAcesso.Caption := 'seu úlitmo acesso foi em '+User.ReadString('user', 'ultimoacesso', '')+'.';

      lblOla.Visible       := true;
      lblUltAcesso.Visible := true;
      lblClickAqui.Visible := true;
      lblNaoVc.Visible     := true;
      chkSalvarUserSenha.Checked := true;

      edUsuario.SetFocus;
    end
    else
    begin
      edUsuario.Text := '';
      edSenha.Text   := '';

      edUsuario.SetFocus;
    end;
  end;
end;

procedure TfrmSenha.lblClickAquiClick(Sender: TObject);
var
  User: TIniFile;
begin
  try
    User := TIniFile.Create(ExtractFilePath(Application.ExeName)+'configuracoes.ini');

    edUsuario.OnChange := nil;

    edUsuario.Clear;
    edSenha.Clear;

    chkSalvarUserSenha.Checked := False;
    lblOla.Visible             := False;
    lblUltAcesso.Visible       := False;
    lblClickAqui.Visible       := False;
    lblNaoVc.Visible           := False;

    User.WriteString('user', 'user', '');
    User.WriteString('user', 'password', '');
    User.WriteString('user', 'name','');
    User.WriteString('user', 'ultimoacesso', '');

    edUsuario.SetFocus;
  finally
    User.Free;

    edUsuario.OnChange := edUsuarioChange;
  end;
end;

procedure TfrmSenha.ConectaServidor;
begin
  zqGetEmp.Close;
  zqGetEmp.Open;

  cbEmpresa.Items.Clear;
  while not zqGetEmp.Eof do
  begin
    cbEmpresa.Items.Add(zqGetEmp.FieldByName('identifier').AsString+'|'+zqGetEmp.FieldByName('razaosocial').AsString);

    zqGetEmp.Next;
  end;
  cbEmpresa.ItemIndex := 0;
end;

procedure TfrmSenha.SpeedButton1Click(Sender: TObject);
var
  arq: TextFile;
begin
  //CriaForm(TfrmCadastroConexao, TObject(frmCadastroConexao));

  EnDecryptFile('c:\g10conexcao.txt'  ,  'c:\g10conexcao.txt' ,  77);

  AssignFile ( arq, 'c:\g10conexcao.txt' );
  Append ( arq );
  //WriteLn ( arq, Trim(ComboBox1.Text));
  CloseFile ( arq );

  EnDecryptFile('c:\g10conexcao.txt'  ,  'c:\g10conexcao.txt' ,  77);
end;

procedure TfrmSenha.btnConfirmarClick(Sender: TObject);
var
  wDia: double;
  sMsg, sMsgAux: string;
  iDia: integer;
  KeyStr, sSituacao: string;
begin
  try
    UsuarioRN := TUsuarioRN.Create;

    if cbEmpresa.Text = '' then
    begin
      Application.MessageBox(PChar('Selecione a empresa!'), 'Atenção', MB_ICONINFORMATION + MB_OK);
      Exit;
    end;

    sEmpresa       := cbEmpresa.Text;
    sIdentificador := Copy(sEmpresa, 1, 14);
    sEmpresa       := Copy(sEmpresa, 16, length(sEmpresa));
    
    if not FileExists(sEnderecoHost) then
    begin
      Application.MessageBox('Arquivo de configuração (sgcpdv.ini) não encontrado!'+#13
                            +'Entre em contato imediatamente com o suporte.', 'Atenção', MB_IconError + MB_OK);
      Application.Terminate;
    end
    else
    begin
      try
        if cbEmpresa.Text = '' then
        begin
          Application.MessageBox(PChar('Selecione a empresa!'), 'Atenção', MB_ICONINFORMATION + MB_OK);
          Exit;
        end;

        ACBrValidador.TipoDocto := docCNPJ;
        ACBrValidador.Documento := sIdentificador;
        if not ACBrValidador.Validar then
        begin
          Application.MessageBox(PChar('Cnpj/Identificador Inválido!'), 'Atenção', MB_ICONINFORMATION + MB_OK);
          Exit;
        end;

        dmPrincipal.ConnectDB(sIdentificador);
        sSituacao := '1';
      except
        on E: Exception do
        begin
          Application.MessageBox(PChar('Não foi possível estabelecer uma conexão com o banco de dados!'+#13+E.Message+#13#13
                                      +'O aplicativo será encerrado.'),
                                       'Atenção', MB_ICONINFORMATION + MB_OK);
          Application.Terminate;
       end;
      end;
    end;

    Usuario       := TUsuario.Create;
    UsuarioAcesso := TUsuario.Create;
    sVersaoSistema:= VERSAO;
    sSistema      := SISTEMA;

    if sSituacao = '1'  then
    begin
      if edUsuario.Text = '' then
      try
        raise Exception.Create('O campo Login é obrigatório!');
      except
        on E: Exception do
        begin
          Application.MessageBox(PChar(E.Message), 'Atenção', MB_IconError + MB_OK);
          Exit;
        end;
      end;

      if edSenha.Text = '' then
      try
        raise Exception.Create('O campo Senha é obrigatório!');
      except
        on E: Exception do
        begin
          Application.MessageBox(PChar(E.Message), 'Atenção', MB_IconError + MB_OK);
          Exit;
        end;
      end;

      Usuario.login    := edUsuario.Text;
      Usuario.SenhaG10 := edSenha.Text;

      if Length(edSenha.Text) < 20 then
      begin
        DCP_sha11.Init;
        DCP_sha11.UpdateStr(edSenha.Text);
        DCP_sha11.Final(SHA1Digest);
        edSenha.Text := LowerCase(BufferToHex(SHA1Digest, SizeOf(SHA1Digest)));
      end;

      Usuario.senha := edSenha.Text;

      if Usuario.login = 'suporte' then
         Usuario.SenhaG10 := edSenha.Text;

      UsuarioAcesso := UsuarioRN.LoginUsuario(Usuario);

      if UsuarioAcesso.codigo = 0 then
      begin
        if frmMsn_Login = nil then
        begin
          frmMsn_Login := TfrmMsn_Login.Create(Self);
          frmMsn_Login.ShowModal;
        end;

        edSenha.Clear;
        edSenha.SetFocus;
      end
      else
      begin
        if UsuarioAcesso.bNegado then
        begin
          edSenha.Clear;
          edSenha.SetFocus;
          ModalResult := mrCancel;
          raise Exception.Create('ACESSO NEGADO...Você não tem permissão para acessar este módulo!');
        end;

        if (chkSalvarUserSenha.Visible) and (chkSalvarUserSenha.Checked) then
        begin
          User.WriteString('user', 'user', edUsuario.Text);
          User.WriteString('user', 'password', edSenha.Text);
          User.WriteString('user', 'name', UsuarioAcesso.nome);
          User.WriteString('user', 'ultimoacesso', FormatDateTime('dd/MM/yyyy hh:mm', now));
        end
        else
        begin
          User.WriteString('user', 'user', '');
          User.WriteString('user', 'password', '');
          User.WriteString('user', 'name', '');
          User.WriteString('user', 'ultimoacesso', '');
        end;
        ModalResult := mrOk;
      end;
    end
  finally
    bLoginYes := (ModalResult = mrOk);
    Close;
  end;
end;

procedure TfrmSenha.btnCancelarClick(Sender: TObject);
begin
  bLoginYes   := false;
  ModalResult := mrCancel;
  Close;
end;

procedure TfrmSenha.edUsuarioChange(Sender: TObject);
begin
  if edUsuario.Text = '' then
     lblClickAquiClick(Sender);
end;

procedure TfrmSenha.edUsuarioKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
  begin
    if edSenha.Text = '' then
       edSenha.SetFocus
    else
       btnConfirmar.Click;
  end;
end;

procedure TfrmSenha.edSenhaKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
     btnConfirmar.Click;
end;

end.
