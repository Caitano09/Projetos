unit uMsnLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, rxAnimate, rxGIFCtrl, ExtCtrls;

type
  TfrmMsn_Login = class(TForm)
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMsn_Login: TfrmMsn_Login;

implementation

{$R *.dfm}

procedure TfrmMsn_Login.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmMsn_Login := nil;
end;

procedure TfrmMsn_Login.FormCreate(Sender: TObject);
begin
  SetWindowLong(Handle, GWL_STYLE, GetWindowLong(Handle, GWL_STYLE ) and not WS_CAPTION);
end;

procedure TfrmMsn_Login.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key =VK_ESCAPE then
     Close;
end;

procedure TfrmMsn_Login.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if Key = #13 then
    Close;
end;

procedure TfrmMsn_Login.FormShow(Sender: TObject);
begin
  Application.ProcessMessages;
end;

end.
