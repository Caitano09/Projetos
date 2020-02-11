unit uModelo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TForm1 = class(TForm)
    strict private
    // Campos
    //fCodigo: String;
   // fDescricao: String;

    //getters
    //function getCodigo: String;
    //function getDescricao: String;

    //setters
  //  procedure setCodigo(const Value: string);
   // procedure setDescricao(const Value: String);

    public
    //propriedades
   // property codigo: string read getCodigo write setCodigo;
  //  property descricao: string read getDescricao write setDescricao;

  private
    { Private declarations }
  end;

var
  Form1: TForm1;

implementation

{{$R *.dfm}

uses uCadastro;

function Tform1.getCodigo: string;
begin

end;

function Tform1.getDescricao: string;
begin

end;

procedure Tform1.setCodigo (const Value: string);
begin

end;

procedure Tform1.setDescricao (const Value: string);
begin

end;

end.
