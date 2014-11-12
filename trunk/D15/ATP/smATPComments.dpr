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

    // Verifica se todas as linhas estão comentadas
    for i := 0 to SL.Count - 1 do begin
      if not IsCommented(SL[i]) then
       AllCommented := false;
    end;

    // Varre as linhas e comenta ou descomenta
    for i := 0 to SL.Count - 1 do begin


      if AllCommented then
        // se já estava comentado, remove comentário
        SL[i] := StringReplace(SL[i],'//','',[])
      else
        // senão adiciona comentário
        SL[i] := '//' + SL[i];
    end;

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
  Result := Pchar('Adicionar/Remover Comentários');
end;

function GetShortCut: PChar; stdcall;
begin
  Result := Pchar('ALT+C');
end;


exports ProcessText, GetDescription, GetShortCut;



{$R *.res}

begin
end.

