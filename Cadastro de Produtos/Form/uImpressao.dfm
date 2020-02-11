object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 214
  ClientWidth = 530
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lblDataInicial: TLabel
    Left = 8
    Top = 13
    Width = 64
    Height = 13
    Caption = 'Data Inicial'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblDataFinal: TLabel
    Left = 8
    Top = 69
    Width = 56
    Height = 13
    Caption = 'Data Final'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object btnPesquisar: TButton
    Left = 8
    Top = 131
    Width = 75
    Height = 25
    Caption = 'Pesquisar'
    TabOrder = 0
    OnClick = btnPesquisarClick
  end
  object dataInicio: TDateTimePicker
    Left = 8
    Top = 42
    Width = 81
    Height = 21
    Date = 43755.000000000000000000
    Time = 0.429803495368105400
    TabOrder = 1
  end
  object dataFim: TDateTimePicker
    Left = 8
    Top = 88
    Width = 81
    Height = 21
    Date = 43755.000000000000000000
    Time = 0.430134039350377900
    TabOrder = 2
  end
  object DBGrid1: TDBGrid
    Left = 202
    Top = 13
    Width = 320
    Height = 120
    DataSource = DataModule1.DataSource3
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Panel1: TPanel
    Left = 202
    Top = 136
    Width = 320
    Height = 41
    TabOrder = 4
    object lblTotal: TLabel
      Left = 264
      Top = 0
      Width = 24
      Height = 13
      Caption = 'Total'
    end
    object lblAbertos: TLabel
      Left = 64
      Top = 0
      Width = 38
      Height = 13
      Caption = 'Abertos'
    end
    object lblVencidos: TLabel
      Left = 128
      Top = 0
      Width = 42
      Height = 13
      Caption = 'Vencidos'
    end
    object lblBaixado: TLabel
      Left = 192
      Top = 0
      Width = 43
      Height = 13
      Caption = 'Baixados'
    end
    object lblFuturos: TLabel
      Left = 12
      Top = 0
      Width = 37
      Height = 13
      Caption = 'Futuros'
    end
    object Bevel1: TBevel
      Left = 55
      Top = -9
      Width = 3
      Height = 50
    end
    object Bevel2: TBevel
      Left = 119
      Top = -1
      Width = 3
      Height = 50
    end
    object Bevel3: TBevel
      Left = 183
      Top = -1
      Width = 3
      Height = 50
    end
    object Bevel4: TBevel
      Left = 236
      Top = -9
      Width = 3
      Height = 50
    end
    object lblNumFuturos: TLabel
      Left = 28
      Top = 19
      Width = 6
      Height = 13
      Caption = '0'
    end
    object lblNumAbertos: TLabel
      Left = 84
      Top = 19
      Width = 6
      Height = 13
      Caption = '0'
    end
    object lblNumVencidos: TLabel
      Left = 146
      Top = 19
      Width = 6
      Height = 13
      Caption = '0'
    end
    object lblNumBaixado: TLabel
      Left = 204
      Top = 19
      Width = 6
      Height = 13
      Caption = '0'
    end
    object lblNumTotal: TLabel
      Left = 276
      Top = 19
      Width = 6
      Height = 13
      Caption = '0'
    end
  end
  object boxAbertos: TCheckBox
    Left = 99
    Top = 30
    Width = 97
    Height = 17
    Caption = 'Abertos'
    TabOrder = 5
  end
  object boxVencidos: TCheckBox
    Left = 99
    Top = 53
    Width = 97
    Height = 17
    Caption = 'Vencidos'
    TabOrder = 6
  end
  object boxBaixados: TCheckBox
    Left = 99
    Top = 76
    Width = 97
    Height = 17
    Caption = 'Baixados'
    TabOrder = 7
  end
  object boxFuturos: TCheckBox
    Left = 99
    Top = 99
    Width = 97
    Height = 17
    Caption = 'Futuros'
    TabOrder = 8
  end
end
