{******************************************************}
{                                                       }
{                 Sum182 Component Library              }
{                                                       }
{  Copyright (c) 2001-2007 Sum182 Software Corporation  }
{                                                       }
{                 Tel.:  55 11 8214-7819                }
{                                                       }
{                 Email: sum182@gmail.com               }
{*******************************************************}

unit smCrypt;

interface

uses
  Windows, Forms, Controls, Typinfo, SysUtils, Types, Classes,
  DBClient, DB, SqlExpr, Variants, RC6Enc;

function Encrypt(S: string): string;overload;
function Decrypt(S: string): string;overload;

const
  Key = '16854@#*sum182@#*9987';

implementation



function Encrypt(S: string): string;
begin
  Result := Encrypt(S,Key);
end;

function Decrypt(S: string): string;
begin
  Result := Decrypt(S,Key);
end;

end.

