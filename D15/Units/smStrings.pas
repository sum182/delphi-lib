{*******************************************************}
{                                                       }
{                 Sum182 Component Library              }
{                                                       }
{  Copyright (c) 2001-2010 Sum182 Software Corporation  }
{                                                       }
{                 Tel.:  55 11 8214-7819                }
{                                                       }
{                 Email: sum182@gmail.com               }
{*******************************************************}


unit smStrings;

interface
uses
  SysUtils, Variants, Classes;

  function RemoveAcentos(str: string): string;
  function FirstUpperCase(str: string): string;
  procedure AddCommaStr(var Text: string; Item: string; Ch: string);

implementation

function RemoveAcentos(Str: string): string;
const
  ComAcento = '‡‚ÍÙ˚„ı·ÈÌÛ˙Á¸¿¬ ‘€√’¡…Õ”⁄«‹';
  SemAcento = 'aaeouaoaeioucuAAEOUAOAEIOUCU';
var
  x: Integer;
begin
  //Remove os acentos
  for x := 1 to Length(Str) do
  begin
    if Pos(Str[x], ComAcento) <> 0 then
    begin
      Str[x] := SemAcento[Pos(Str[x], ComAcento)];
    end;
  end;
  Result := Str;
end;

function FirstUpperCase(str: string): string;
var
  i: Integer;
begin
  Result := ''; 
  //Deixa todas as palvras com a 1™ letra maisucula
  for i := 1 to length(str) do
    if (i = 1) or (str[i - 1] = ' ') then
      Result := Result + UpperCase(str[I])
    else
      Result := Result + LowerCase(str[I]);
end;

procedure AddCommaStr(var Text: string; Item: string; Ch: string);
begin
  if (Item = '') then
    Exit;
  if (Text = '') then
    Text := Item
  else
    Text := Text + Ch + Item;
end;

end.

