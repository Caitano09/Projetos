unit uDMPrincipal;

interface

uses
  DB, System.SysUtils, System.Classes, ZAbstractConnection, ZConnection, ZDataset,
  ZAbstractRODataset, ZAbstractDataset;

type
  TdmPrincipal = class(TDataModule)
    ZConnection: TZConnection;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmPrincipal: TdmPrincipal;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
