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


unit smJson;

interface

  Uses
      SysUtils,Classes,Forms,DateUtils,StrUtils,Variants,DB, System.JSON;

   function CheckItemAdd(JSONArray:TJSONArray;Value:String):Boolean;


implementation

{ TSQL }

function CheckItemAdd(JSONArray:TJSONArray;Value:String):Boolean;
var
  i:Integer;
begin
  Result := True;

  for i := 0 to JSONArray.Count - 1 do
    if JSONArray.Items[i].Value = Value then
      Exit;
  Result := False;
end;


end.
