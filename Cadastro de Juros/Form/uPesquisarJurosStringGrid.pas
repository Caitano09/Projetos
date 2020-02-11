unit uPesquisarJurosStringGrid;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.ComCtrls,
  System.ImageList, Vcl.ImgList, PngImageList, Vcl.ToolWin, Vcl.ExtCtrls,
  Data.DB, ZAbstractRODataset, ZAbstractDataset, ZDataset, Juros, TipoJuros,
  JurosRN, Vcl.StdCtrls ;

type
  TfrmPesquisaJurosStringGrid = class(TForm)
    Panel1: TPanel;
    ToolBar1: TToolBar;
    PngImageList1: TPngImageList;
    btnVoltar: TToolButton;
    btnPesquisar: TToolButton;
    StringGrid1: TStringGrid;
    dsPesquisa: TDataSource;
    zqGet: TZQuery;
    lblEnter: TLabel;
    lblEsc: TLabel;
    panelRodape: TPanel;
    lblRegistros: TLabel;
    bevel: TBevel;
    lblNumRegistros: TLabel;
    lblSelecionado: TLabel;
    shapeBlack: TShape;
    shapeRed: TShape;
    shapeGray: TShape;
    lblAtivo: TLabel;
    lblInativo: TLabel;
    lblBloqueado: TLabel;
    procedure btnPesquisarClick(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnVoltarClick(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure pesquisar;
  public
    { Public declarations }

  end;

var
  frmPesquisaJurosStringGrid: TfrmPesquisaJurosStringGrid;
  JurosRn : TJurosRN;

implementation

{$R *.dfm}

{ TForm1 }

procedure TfrmPesquisaJurosStringGrid.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  try
    jurosRn.Free;
  finally
    Action := caFree;
    frmPesquisaJurosStringGrid := nil;
  end;
end;

procedure TfrmPesquisaJurosStringGrid.FormCreate(Sender: TObject);
begin
  jurosRn := TJurosRN.Create;
end;

procedure TfrmPesquisaJurosStringGrid.FormShow(Sender: TObject);
begin
  JurosRn.pesquisarStringGrid(zqGet);
end;

procedure TfrmPesquisaJurosStringGrid.pesquisar;
var
  iLinha : Integer;
begin
  with StringGrid1 do begin
    ColCount := zqGet.FieldCount;
    RowCount :=  zqGet.RecordCount + 1;

    cells[0, 0] := zqGet.Fields[0].FieldName;
    cells[1, 0] := zqGet.Fields[1].FieldName;
    cells[2, 0] := zqGet.Fields[2].FieldName;
    cells[3, 0] := zqGet.Fields[3].FieldName;
    cells[4, 0] := zqGet.Fields[4].FieldName;
    cells[5, 0] := zqGet.Fields[5].FieldName;
    cells[6, 0] := zqGet.Fields[6].FieldName;

    ColCount := 7;
    ColWidths[0] := 0;
    ColWidths[6] := 0;
    ColWidths[1] := 200;
    ColWidths[2] := 80;
    ColWidths[3] := 95;
    ColWidths[4] := 75;
    ColWidths[5] := 80;
    zqGet.First;

    for iLinha := 0 to RowCount do

      begin
        cells[0,  iLinha+1] := zqGet.FieldByName('codigo').AsString;
        cells[1,  iLinha+1] := zqGet.FieldByName('tipoJuros').AsString;
        cells[2,  iLinha+1] := zqGet.FieldByName('juros').AsString;
        cells[3,  iLinha+1] := zqGet.FieldByName('jurosmora').AsString;
        cells[4,  iLinha+1] := zqGet.FieldByName('acrescimo').AsString;
        cells[5,  iLinha+1] := zqGet.FieldByName('diaatraso').AsString;
        cells[6,  iLinha+1] := zqGet.FieldByName('descricao').AsString;
        zqGet.Next;//Proximo Registro
      end;
  end;

   lblNumRegistros.Caption := '0';
   if not zqGet.IsEmpty then
     lblNumRegistros.Caption := IntToStr(zqGet.RecordCount);

  StringGrid1.Row := 1;
  StringGrid1.Col := 1;
  StringGrid1.SetFocus;
end;

procedure TfrmPesquisaJurosStringGrid.StringGrid1DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  strTemp: string;
  Format: integer;
  sTexto: String;
begin
  if ARow mod 2 = 1 then
    StringGrid1.Canvas.Brush.Color := $00FFE2C6
  else
    StringGrid1.Canvas.Brush.Color := clWhite;

  Font.Style := [fsBold];

  if (gdSelected in State) or (gdFocused in State) then
    TStringGrid(Sender).Canvas.Brush.Color := $0082FFFF;

  StringGrid1.canvas.fillRect(Rect);
  StringGrid1.canvas.TextOut(Rect.Left,Rect.Top,StringGrid1.Cells[ACol,ARow]);
  strTemp := StringGrid1.Cells[ACol,ARow];
  StringGrid1.Canvas.FillRect(Rect);

  if StringGrid1.Cells[6, Arow] = 'Ativo' then
  begin
    StringGrid1.Canvas.Font.Color:= clBlack;
    Stringgrid1.Canvas.FillRect(Rect);
    //Stringgrid1.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, StringGrid1.Cells[ACol, Arow]);
  end
  else if StringGrid1.Cells[6, Arow] = 'Inativo' then
  begin
    StringGrid1.Canvas.Font.Color:= clRed;
    StringGrid1.canvas.FillRect(Rect);
    //Stringgrid1.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, StringGrid1.Cells[ACol, Arow]);
  end
  else
  begin
    StringGrid1.Canvas.Font.Color:= clGray;
    StringGrid1.Canvas.FillRect(Rect);
    //Stringgrid1.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, StringGrid1.Cells[ACol, Arow]);
  end;

  if (ACol = 1) then
    Format := DT_LEFT
  else
    Format := DT_RIGHT;

  if (ARow = 0) then
    StringGrid1.Canvas.Font.Style := [fsBold];

  DrawText(StringGrid1.Canvas.Handle,PChar(strTemp),-1,Rect,Format);

  sTexto := StringGrid1.Cells[Acol, Arow];

  if (aRow <> 0) and (StringGrid1.Cells[aCol ,aRow] <> '') then
  begin
    if (aCol = 2) or (aCol = 3) then
      sTexto := FormatFloat('###, ###, ##0.00%', StrToFloat(StringGrid1.Cells[Acol, Arow].Replace('%', '')));

    if (aCol = 4) then
      sTexto := FormatFloat('###, ###, ##0.00%', StrToFloat(StringGrid1.Cells[Acol, Arow].Replace('%', '')));
  end;

  StringGrid1.Canvas.FillRect(rect);
  StringGrid1.Canvas.TextOut(Rect.Left, Rect.Top, sTexto);
end;

procedure TfrmPesquisaJurosStringGrid.StringGrid1KeyPress(Sender: TObject;
  var Key: Char);
var
  Juros : TJuros;
  TipoJuros : TTipoJuros;
begin
  with StringGrid1 do
  begin
    if key = #13 then
    begin
      juros := TJuros.Create;
      tipoJuros := TTipoJuros.Create;
      case StringGrid1.Col of
        2: Juros.setJuros(StrToFloat(StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row]));
        3: Juros.setMora(StrToFloat(StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row]));
        4: juros.setAcrescimo(StrToFloat(StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row]));
      end;
      if Application.MessageBox(PChar('Deseja realmente Atualizar?'), 'Confirmação', MB_ICONQUESTION+MB_YESNO) = mrYes then
      begin
        juros.setCodigo(StrToInt(StringGrid1.Cells[0, StringGrid1.Row]));
        JurosRn.editarStringGrid(juros);
      end;
      JurosRn.pesquisarStringGrid(zqGet);
      pesquisar;
      juros.Free;
      TipoJuros.Free;
    end;

    if key = #27 then
    begin
      pesquisar;
    end;
  end;

end;

procedure TfrmPesquisaJurosStringGrid.StringGrid1SelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
begin
  lblSelecionado.Caption := '';
  if not zqGet.IsEmpty then
     lblSelecionado.Caption :=
     '['+StringGrid1.Cells[1, Arow]+'] | '+
     'Juros: '+StringGrid1.Cells[2, Arow]+' | '+
     'Mora: '+StringGrid1.Cells[3, Arow]+' | '+
     'Acres: '+StringGrid1.Cells[4, Arow]+' | '+
     'Atraso: '+StringGrid1.Cells[1, Arow];
  if (acol = 2) or (acol = 3) or (acol = 4) then
    StringGrid1.Options := [goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goRangeSelect,goEditing]
  else
    StringGrid1.Options := [goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goRangeSelect]

end;

procedure TfrmPesquisaJurosStringGrid.btnVoltarClick(Sender: TObject);
begin
  close;
end;

procedure TfrmPesquisaJurosStringGrid.btnPesquisarClick(Sender: TObject);
begin
  pesquisar;
end;

end.
