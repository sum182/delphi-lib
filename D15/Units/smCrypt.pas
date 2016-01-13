{*******************************************************}
{                                                       }
{                 Sum182 Component Library              }
{                                                       }
{  Copyright (c) 2001-2016 Sum182 Software Corporation  }
{                                                       }
{                 Tel.:  55 11 98214-7819               }
{                                                       }
{                 Email: sum182@gmail.com               }
{*******************************************************}

unit smCrypt;

interface

uses
  Windows, Forms, Controls, Typinfo, SysUtils, Types, Classes,
  DBClient, DB, SqlExpr, Variants, System.NetEncoding;

function Encrypt(S: string): string;overload;
function Decrypt(S: string): string;overload;

const
  Key = '16854@#*sum182@#*9987';

implementation



function Encrypt(S: string): string;
begin
  //metodo antigo da unit RC6Enc
  //Result := Encrypt(S,Key);

  Result:= TNetEncoding.Base64.Encode(Key + S);
end;

function Decrypt(S: string): string;
begin
  //metodo antigo da unit RC6Enc
  //Result := Decrypt(S,Key);

  Result := TNetEncoding.Base64.Decode(S);
  Result := StringReplace(result,key,'',[]);
end;

end.

