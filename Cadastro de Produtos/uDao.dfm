object frmDao: TfrmDao
  Left = 0
  Top = 0
  Caption = 'frmDao'
  ClientHeight = 201
  ClientWidth = 447
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ZConnection1: TZConnection
    ControlsCodePage = cCP_UTF16
    AutoEncodeStrings = True
    Catalog = ''
    HostName = 'localhost'
    Port = 5432
    Database = 'db_sgc'
    User = 'postgres'
    Password = 'eunice'
    Protocol = 'postgresql'
    Left = 88
    Top = 104
  end
  object ZQuery1: TZQuery
    Connection = ZConnection1
    Params = <>
    Left = 232
    Top = 112
  end
  object DataSource1: TDataSource
    DataSet = ZQuery1
    Left = 320
    Top = 88
  end
end
