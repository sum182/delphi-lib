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

unit smIBO;

interface

Uses
  Windows, Forms, Controls, Typinfo, SysUtils, Types,  Classes,
  DBClient, DB,SqlExpr,Variants,IBODataset,smGeral,DateUtils;

  procedure OpenIBOQuerys(Form: TForm);
  procedure CloseIBOQuerys(Form: TForm);
  procedure SqlSaveToFile(DataSet: TIBOQuery);

implementation

uses
  StrUtils;




procedure OpenIBOQuerys(Form: TForm);
var
  i:integer;
begin
  for i := 0 to Form.ComponentCount - 1 do
    if (Form.Components[i] is TIBOQuery)  then
    begin
      (Form.Components[i] as TIBOQuery).Close;
      (Form.Components[i] as TIBOQuery).Open;
    end;
end;



procedure CloseIBOQuerys(Form: TForm);
var
  i:integer;
begin
  for i := 0 to Form.ComponentCount - 1 do
    if (Form.Components[i] is TIBOQuery)  then
      (Form.Components[i] as TIBOQuery).Close;
end;


procedure SqlSaveToFile(DataSet: TIBOQuery);
var
  fs: TFileStream;
  Arquivo: string;
  Dia: Variant;
  Mes: Variant;
  Hora: Variant;
  Agora: string;
begin
  //PEGANDO O HORA
  Agora := TimeToStr(now);
  Hora := LeftStr(Agora, 2);

  //PEGANDO OS MINUTOS
  Agora := RightStr(Agora, 5);
  Hora := Hora + LeftStr(Agora, 2);

  Mes := MonthOf(now);
  Dia := DayOf(Now);

  //se o mes for menor que 9 colocar um zero na frente do mes
  Mes := VarToStr(Mes);
  if StrToInt(Mes) <= 9 then Mes := '0' + Mes;

  Dia := VarToStr(Dia);
  Hora := VarToStr(Hora);

  CreateDir(GetCurrentDir + '\SQL');

  Arquivo := GetCurrentDir + '\SQL\'
                           + DataSet.Name + '_'
                           + Hora
                           + '_'
                           + Dia
                           + Mes
                           + '.sql';
  Try
    fs := TFileStream.Create(Arquivo,fmCreate);
    GravaStream(fs,DataSet.SQL.GetText);
  finally
    FreeAndNil(fs);
  end;
end;

end.
