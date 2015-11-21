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


unit smDBFireBird;

interface

Uses
  Classes,  DBClient,  DB, SqlExpr;
  Function GetGenerator(Generator:string; cdsBusca:TClientDataSet): Integer;overload;
  Function GetGenerator(Generator:string; cdsBusca:TClientDataSet;
                          Field: TField): Integer;overload;


implementation

Function GetGenerator(Generator:string; cdsBusca:TClientDataSet): Integer;
begin
  //Retorna o valor do generator
  Try
    with cdsBusca do
    begin
      Close;
      CommandText := 'SELECT GEN_ID(' + Generator + ', 1 ) AS N_ID FROM RDB$DATABASE';
      Open;
      Result := cdsBusca.FieldByName('N_ID').AsInteger;
    end;
  Finally
    cdsBusca.Close;
  end;
end;

Function GetGenerator(Generator:string; cdsBusca:TClientDataSet;
                        Field: TField): Integer;overload;
begin
  //Seta o field com o valor do generator
  Try
    with cdsBusca do
    begin
      Close;
      CommandText := 'SELECT GEN_ID(' + Generator + ', 1 ) AS N_ID FROM RDB$DATABASE';
      Open;
      Result := cdsBusca.FieldByName('N_ID').AsInteger;
      Field.Value := Result;
    end;
  Finally
    cdsBusca.Close;
  end;
end;





end.
