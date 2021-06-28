unit uDMPrincipal;

interface

uses
  System.SysUtils, System.Classes, ZAbstractConnection, ZConnection, Data.DB,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, Validar, IniFiles;

type
  TDMPrincipal = class(TDataModule)
    ZConnection: TZConnection;
    dsPedido: TDataSource;
    zqPedido: TZQuery;
    dsHistorico: TDataSource;
    zqHistorico: TZQuery;
    zGetServer: TZQuery;
    ZConnection_Server: TZConnection;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ConnectDB(sIdentifier: string);
  end;

var
  DMPrincipal: TDMPrincipal;

implementation


{$R *.dfm}


{ TDMPrincipal }

procedure TDMPrincipal.ConnectDB(sIdentifier: string);
var
  sPath: string;
  Ini: TIniFile;
begin
  Ini := TIniFile.Create('C:\Windows\SysWOW64\sgcpdv.ini');

    {Endereco de teste}
//  Ini := TIniFile.Create('G:\sgcpdv.ini');

  if sIdentifier <> '' then
  begin
    zGetServer.Close;
    zGetServer.SQL.Clear;
    zGetServer.SQL.Text :=
    'select ip, identifier, razaosocial, nomebancodados from g10servidores '+
    'where identifier = '''+sIdentifier+'''                                ';
    zGetServer.Open;

    ZConnection.Disconnect;
    ZConnection.Database := zGetServer.FieldByName('nomebancodados').AsString;
    ZConnection.HostName := zGetServer.FieldByName('ip').AsString;

    ZConnection.Connect;
    zqHistorico.Active := true;
  end
  else
  begin
    ZConnection.Disconnect;
    ZConnection.HostName := Ini.ReadString('acesso', 'localserver', '');
    ZConnection.Database := Ini.ReadString('acesso', 'dbserver', '');
    ZConnection.Connect;
  end;
end;

end.
