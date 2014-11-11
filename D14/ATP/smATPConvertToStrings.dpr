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


library smATPConvertToStrings;

uses
  SysUtils, Classes, Dialogs;

function ProcessText(Text: Pchar): PChar; stdcall;
var
  SText: String;
  SL: TStringList;
  i: integer;
  QL: String;
begin
  // Obtem quebra de linha do usuário
  // SLineBreak é a constante de quebra de linha do sistema (#13#10)
  QL := InputBox('','Quebra de Linha','sLineBreak');

  SText := String(Text);

  // Utiliza a classe TStrings para processar as linhas do Texto;
  SL := TStringList.Create;
  try
    SL.Text := SText;
    SText := '';

    // Processa as linhas do Texto e formata como um String Pascal
    // Colocando as linhas entre aspas e incluindo as quebras de linha
    for i := 0 to SL.Count - 1 do begin
      if SText <> '' then
        SText := SText +  ' + ' + QL + ' +' + SLineBreak;
      SText :=  SText +  QuotedStr(SL[i]);
    end;
//    SText := SText + ';'
  finally
    SL.Free;

    // Aloca Memória para o String de retorno (+1 para ter espaço para o terminador nulo do string)
    GetMem(Result,Length(SText)+1);

    // Copia o String para a área de memória alocada
    Result := StrPCopy(Result,SText);
  end;
end;

function GetDescription: PChar; stdcall;
begin
  Result := Pchar('Converter para String');
end;

function GetShortCut: PChar; stdcall;
begin
  Result := Pchar('SHIFT+CTRL+ALT+S');
end;


exports ProcessText, GetDescription, GetShortCut;



{$R *.res}

begin
end.

