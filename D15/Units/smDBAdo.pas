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

unit smDBAdo;

interface

  Uses
    AdoDB,Db,smSQL,Forms;

   procedure SalvarSQL(DataSet: TADOQuery);overload;
   procedure SalvarSQL(DataSet: TADODataSet);overload;


implementation


procedure SalvarSQL(DataSet: TADOQuery);
var
  SQL:TSQL;
begin
  //Metodo para exportar o SQL do Dataset
  Try
    SQL := TSQL.Create;
    with SQL do
    begin
      Name := DataSet.Name;
      Expressao := DataSet.SQL.GetText;
      SalvarSQL;
    end;
  finally
    SQL := Nil;
    SQL.Free;
  end;
end;

procedure SalvarSQL(DataSet: TADODataSet);
var
  SQL:TSQL;
begin
  //Metodo para exportar o SQL do Dataset
  Try
    SQL := TSQL.Create;
    with SQL do
    begin
      Name := DataSet.Name;
      Expressao := DataSet.CommandText;
      SalvarSQL;
    end;
  finally
    SQL := Nil;
    SQL.Free;
  end;
end;

end.
