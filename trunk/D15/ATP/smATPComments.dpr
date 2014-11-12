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


library smATPComments;

uses
  SysUtils, Classes, Dialogs;

function ProcessText(Text: Pchar): PChar; stdcall;
var
  SText: String;
  SL: TStringList;
  i: integer;
  AllCommented: Boolean;

  function IsCommented(const Text: String): Boolean;
  begin
    Result := Pos('//',Trim(Text)) = 1
  end;

begin
  SText := String(Text);

  // Utiliza a classe TStrings para processar as linhas do Texto;
  SL := TStringList.Create;
  try
    SL.Text := SText;
    SText := '';

    AllCommented := true;

    // Verifica se todas as linhas est�o comentadas
    for i := 0 to SL.Count - 1 do begin
      if not IsCommented(SL[i]) then
       AllCommented := false;
    end;

    // Varre as linhas e comenta ou descomenta
    for i := 0 to SL.Count - 1 do begin


      if AllCommented then
        // se j� estava comentado, remove coment�rio
        SL[i] := StringReplace(SL[i],'//','',[])
      else
        // sen�o adiciona coment�rio
        SL[i] := '//' + SL[i];
    end;

    SText := SL.Text;

  finally
    SL.Free;

    // Aloca Mem�ria para o String de retorno (+1 para ter espa�o para o terminador nulo do string)
    GetMem(Result,Length(SText)+1);

    // Copia o String para a �rea de mem�ria alocada
    Result := StrPCopy(Result,SText);

  end;
end;

function GetDescription: PChar; stdcall;
begin
  Result := Pchar('Adicionar/Remover Coment�rios');
end;

function GetShortCut: PChar; stdcall;
begin
  Result := Pchar('ALT+C');
end;


exports ProcessText, GetDescription, GetShortCut;



{$R *.res}

begin
end.

