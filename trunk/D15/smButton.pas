{*******************************************************}
{                                                       }
{                 Sum182 Component Library              }
{                                                       }
{  Copyright (c) 2001-2007 Sum182 Software Corporation  }
{                                                       }
{                 Tel.:  55 11 8214-7819                }
{                                                       }
{                 Email: sum182@gmail.com               }
{*******************************************************}


unit smButton;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, Buttons, Windows, Forms, Messages, Graphics, ExtCtrls, CommCtrl;

type
  TTipo = (btNovo, btExcluir, btAlterar, btSalvar, btCancelar, btCloseForm, btAtualizar, btSair,
    btAbrir, btLocalizar, btImprimir, btHelp, btOK, btExecutar, btLogin);

  TsmButton = class(TBitBtn)
  private
    FTipo: TTipo;
    procedure SetTipo(const Value: TTipo);
    procedure LoadGlyphBtn(pcaption: string; pimage: pWideChar);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure Click; override;
  published
    property Tipo: TTipo read FTipo write SetTipo;
  end;

procedure Register;

implementation

//referenciando o arquivo resorurce que armazena as imagens
{$R imBotoes.res}

procedure Register;
begin
  RegisterComponents('Sum182', [TsmButton]);
end;

{ TsmButton }

procedure TsmButton.Click;
var
  Form: TCustomForm;
begin
  inherited;

  case Tipo of
    btNovo: ;
    btExcluir: ;
    btAlterar: ;
    btSalvar: ;
    btCancelar: ;
    btCloseForm:
      begin
        Form := GetParentForm(Self);
        if Form <> nil then
          Form.Close
        else
          inherited Click;
      end;

    btAtualizar: ;
    btSair: ;
    btAbrir: ;
    btLocalizar: ;
    btImprimir: ;
    btHelp: ;
    btOK: ;
    btExecutar: ;
    btLogin: ;
  end;
end;

constructor TsmButton.Create(AOwner: TComponent);
begin
  inherited;
  //tipo padrao
  Tipo := btOK;
  //num de glyfs do botao
  NumGlyphs := 2;
end;

procedure TsmButton.LoadGlyphBtn(pcaption: string; pimage: PWideChar);
begin
  //BUSCANDO A IMAGEM
  Glyph.Handle := LoadBitmap(HInstance, pimage);

  //CAPTION DO BUTON
  caption := pcaption;
end;

procedure TsmButton.SetTipo(const Value: TTipo);
begin
  FTipo := Value;
  Glyph := nil;
  case FTipo of
    btNovo: LoadGlyphBtn('Novo', 'NOVO');
    btExcluir: LoadGlyphBtn('Excluir', 'EXCLUIR');
    btAlterar: LoadGlyphBtn('Alterar', 'ALTERAR');
    btSalvar: LoadGlyphBtn('Salvar', 'SALVAR');
    btCancelar: LoadGlyphBtn('Cancelar', 'CANCELAR');
    btCloseForm: LoadGlyphBtn('Sair', 'SAIR');
    btAtualizar: LoadGlyphBtn('Atualizar', 'ATUALIZAR');
    btSair: LoadGlyphBtn('Sair', 'SAIR');
    btAbrir: LoadGlyphBtn('Abrir', 'ABRIR');
    btLocalizar: LoadGlyphBtn('Localizar', 'LOCALIZAR');
    btImprimir: LoadGlyphBtn('Imprimir', 'IMPRIMIR');
    btHelp: LoadGlyphBtn('Help', 'HELP');
    btOK: LoadGlyphBtn('OK', '');
    btExecutar: LoadGlyphBtn('Executar', 'EXECUTAR');
    btLogin: LoadGlyphBtn('Login', 'LOGIN');
  end;
end;

end.

