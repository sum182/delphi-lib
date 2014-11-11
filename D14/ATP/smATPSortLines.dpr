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


library smATPSortLines;

uses
  SysUtils, Classes;

function ProcessText(Text: Pchar): PChar; stdcall;
var
  SText: String;
  SL: TStringList;
begin


  SText := String(Text);

  // Utiliza a classe TStrings para ordenar as linhas do Texto;
  SL := TStringList.Create;
  try
    SL.Text := SText;
    SL.Sort;
    SText := SL.Text;
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
  Result := Pchar('Ordenar Linhas');
end;

function GetShortCut: PChar; stdcall;
begin
  Result := Pchar('SHIFT+CTRL+ALT+O');
end;


exports ProcessText, GetDescription, GetShortCut;



{$R *.res}

begin
end.

