object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Unificador de SPED Contribui'#231#245'es'
  ClientHeight = 301
  ClientWidth = 434
  Color = clBtnFace
  Constraints.MaxHeight = 340
  Constraints.MaxWidth = 450
  Constraints.MinHeight = 340
  Constraints.MinWidth = 450
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btn_GerarArquivo: TSpeedButton
    Left = 306
    Top = 263
    Width = 120
    Height = 30
    Hint = 'Gerar e Salvar Arquivo'
    Caption = 'Gerar e Salvar Arquivo'
    ParentShowHint = False
    ShowHint = True
    OnClick = btn_GerarArquivoClick
  end
  object GroupBox1: TGroupBox
    Left = 7
    Top = 8
    Width = 419
    Height = 65
    Caption = 'Matriz'
    TabOrder = 0
    object btn_Matriz: TSpeedButton
      Left = 385
      Top = 25
      Width = 23
      Height = 22
      Hint = 'Selecionar arquivo da Matriz'
      Caption = '...'
      ParentShowHint = False
      ShowHint = True
      OnClick = btn_MatrizClick
    end
    object edtArquivo: TEdit
      Left = 16
      Top = 25
      Width = 363
      Height = 21
      Enabled = False
      TabOrder = 0
    end
  end
  object GroupBox2: TGroupBox
    Left = 7
    Top = 87
    Width = 419
    Height = 177
    Caption = 'Filiais'
    TabOrder = 1
    object btn_Filiais: TSpeedButton
      Left = 385
      Top = 25
      Width = 23
      Height = 22
      Hint = 'Selecionar arquivo das filiais'
      Caption = '...'
      ParentShowHint = False
      ShowHint = True
      OnClick = btn_FiliaisClick
    end
    object memoFiliais: TMemo
      Left = 16
      Top = 25
      Width = 363
      Height = 137
      Enabled = False
      TabOrder = 0
      WordWrap = False
    end
  end
  object OpenTextFileDialog1: TOpenTextFileDialog
    DefaultExt = '*.txt'
    Filter = 'Texto|*.txt'
    Left = 64
    Top = 256
  end
  object SaveTextFileDialog1: TSaveTextFileDialog
    DefaultExt = '*.txt'
    Filter = 'Texto|*.txt'
    Left = 152
    Top = 256
  end
end
