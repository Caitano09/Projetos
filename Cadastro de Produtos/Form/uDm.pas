unit uDm;

interface

uses
  System.SysUtils, System.Classes, Data.DB, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ZAbstractConnection, ZConnection, RDprint;

type
  TDataModule1 = class(TDataModule)
    ZConnection1: TZConnection;
    ZQuery1: TZQuery;
    DataSource1: TDataSource;
    ZQuery2: TZQuery;
    DataSource2: TDataSource;
    RDprint1: TRDprint;
    ZQuery3: TZQuery;
    DataSource3: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }

  end;



var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}


{$R *.dfm}



end.
