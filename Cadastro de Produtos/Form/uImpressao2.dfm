object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 472
  ClientWidth = 778
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object RLReport1: TRLReport
    Left = -8
    Top = 8
    Width = 794
    Height = 1123
    DataSource = DataModule1.DataSource3
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    object RLGroup1: TRLGroup
      Left = 38
      Top = 100
      Width = 718
      Height = 241
      DataFields = 'tituloid'
      Transparent = False
      object RLBand2: TRLBand
        Left = 0
        Top = 52
        Width = 718
        Height = 40
        Borders.Sides = sdCustom
        Borders.DrawLeft = False
        Borders.DrawTop = False
        Borders.DrawRight = False
        Borders.DrawBottom = False
        object RLDBText2: TRLDBText
          Left = 138
          Top = 6
          Width = 63
          Height = 14
          DataField = 'parcelavalor'
          DataSource = DataModule1.DataSource3
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          Text = ''
        end
        object RLDBText3: TRLDBText
          Left = 245
          Top = 6
          Width = 92
          Height = 14
          DataField = 'numerodocumento'
          DataSource = DataModule1.DataSource3
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          Text = ''
        end
        object RLDBText4: TRLDBText
          Left = 392
          Top = 6
          Width = 79
          Height = 14
          DataField = 'datavencimento'
          DataSource = DataModule1.DataSource3
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          Text = ''
        end
        object RLDBText5: TRLDBText
          Left = 536
          Top = 6
          Width = 33
          Height = 14
          DataField = 'status'
          DataSource = DataModule1.DataSource3
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          Text = ''
        end
        object RLDBText1: TRLDBText
          Left = 50
          Top = 6
          Width = 47
          Height = 14
          DataField = 'parcelaid'
          DataSource = DataModule1.DataSource3
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          Text = ''
        end
      end
      object RLBand3: TRLBand
        Left = 0
        Top = 0
        Width = 718
        Height = 20
        BandType = btColumnHeader
        Color = clSilver
        ParentColor = False
        Transparent = False
        object RLLabel6: TRLLabel
          Left = 3
          Top = 6
          Width = 45
          Height = 14
          Caption = 'TITULO:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = False
        end
        object RLLabel7: TRLLabel
          Left = 186
          Top = 6
          Width = 84
          Height = 14
          Caption = 'VALOR TOTAL:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = False
        end
        object RLDBText6: TRLDBText
          Left = 54
          Top = 6
          Width = 33
          Height = 14
          DataField = 'tituloid'
          DataSource = DataModule1.DataSource3
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          Text = ''
          Transparent = False
        end
        object RLDBText7: TRLDBText
          Left = 276
          Top = 6
          Width = 49
          Height = 14
          DataField = 'titulovalor'
          DataSource = DataModule1.DataSource3
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          Text = ''
          Transparent = False
        end
      end
      object RLBand1: TRLBand
        Left = 0
        Top = 20
        Width = 718
        Height = 32
        BandType = btColumnHeader
        Borders.Sides = sdCustom
        Borders.DrawLeft = False
        Borders.DrawTop = False
        Borders.DrawRight = False
        Borders.DrawBottom = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        object RLLabel1: TRLLabel
          Left = 50
          Top = 6
          Width = 43
          Height = 14
          Caption = 'Parcela'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RLLabel2: TRLLabel
          Left = 138
          Top = 6
          Width = 32
          Height = 14
          Caption = 'Valor'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RLLabel3: TRLLabel
          Left = 245
          Top = 6
          Width = 66
          Height = 14
          Caption = 'Documento'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RLLabel4: TRLLabel
          Left = 392
          Top = 6
          Width = 70
          Height = 14
          Caption = 'Vencimento'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RLLabel5: TRLLabel
          Left = 536
          Top = 6
          Width = 38
          Height = 14
          Caption = 'Status'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
      end
      object RLBand5: TRLBand
        Left = 0
        Top = 92
        Width = 718
        Height = 37
        BandType = btSummary
        Borders.Sides = sdCustom
        Borders.DrawLeft = False
        Borders.DrawTop = True
        Borders.DrawRight = False
        Borders.DrawBottom = False
        object RLDBResult1: TRLDBResult
          Left = 138
          Top = 4
          Width = 95
          Height = 14
          DataField = 'parcelavalor'
          DataSource = DataModule1.DataSource3
          DisplayMask = '###,##0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Info = riSum
          ParentFont = False
          Text = ''
          Transparent = False
        end
        object RLLabel9: TRLLabel
          Left = 50
          Top = 4
          Width = 65
          Height = 14
          Caption = 'Valor Pago:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = False
        end
      end
    end
    object RLBand4: TRLBand
      Left = 38
      Top = 38
      Width = 718
      Height = 62
      BandType = btHeader
      object RLLabel8: TRLLabel
        Left = 0
        Top = 19
        Width = 98
        Height = 19
        Caption = 'RELAT'#211'RIO'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object RLSystemInfo4: TRLSystemInfo
        Left = 593
        Top = 16
        Width = 72
        Height = 14
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Info = itPageNumber
        ParentFont = False
        Text = ''
      end
      object RLLabel13: TRLLabel
        Left = 555
        Top = 16
        Width = 31
        Height = 15
        Caption = 'P'#225'g.:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object RLLabel10: TRLLabel
        Left = 555
        Top = 35
        Width = 32
        Height = 15
        Caption = 'Data:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object RLSystemInfo2: TRLSystemInfo
        Left = 593
        Top = 36
        Width = 33
        Height = 14
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Text = ''
      end
      object RLSystemInfo3: TRLSystemInfo
        Left = 654
        Top = 36
        Width = 34
        Height = 14
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Info = itHour
        ParentFont = False
        Text = ''
      end
    end
    object RLBand6: TRLBand
      Left = 38
      Top = 341
      Width = 718
      Height = 24
      BandType = btFooter
    end
  end
end
