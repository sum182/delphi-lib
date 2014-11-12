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

unit smExcel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBXpress, FMTBcd, StdCtrls, DB, SqlExpr, Provider, DBClient,
  OleServer, Grids, DBGrids, Gauges,
  ExtCtrls, DBCtrls, ExcelXP;

procedure DataSetToExcel(Dataset: TDataSet;
                         VisibleExcel:boolean = False);

function PegaLetraColuna(IntNumber: Integer): string;

implementation

uses
  smGeral;

function PegaLetraColuna(IntNumber: Integer): string;
begin
  if IntNumber < 1 then
    Result := 'A'
  else
  begin
    if IntNumber > 256 then
      Result := 'IV'
    else
    begin
      if IntNumber > 26 then
      begin
        Result := Chr(64 + (IntNumber div 26));
        Result := Result + Chr(64 + (IntNumber mod 26));
      end
      else
        Result := Chr(64 + IntNumber);
    end;
  end;
end;

procedure DataSetToExcel(Dataset: TDataSet;
                         VisibleExcel:boolean = False);
var
  NumLinha, NumColuna, LCID: Integer;
  StrCell: string;
  AdtoMru, CreateBck, ROREcommended: OleVariant;
  Excel: TExcelApplication;
  ArqNome: OleVariant;
begin
  ArqNome:= SaveToFile('*.xls','xls');

  if ArqNome = '' then
    Exit;

  Excel := TExcelApplication.Create(Application);

  LCID := GetUserDefaultLCID;
  with Excel do
  begin
    Screen.Cursor:=crSQLWait;
    Connect;
    try
      Visible[LCID] := VisibleExcel;
      Workbooks.Add(EmptyParam, LCID);
      NumLinha := 1;

      (* Aqui pega o nome dos CAMPOS do Dataset *)
      with Dataset do
      begin
        for NumColuna := 1 to Fields.Count do
        begin
          if (FieldDefs[NumColuna - 1].DataType in [ftBlob]) then
             Continue;

          StrCell := PegaLetraColuna(NumColuna) + IntToStr(NumLinha);

          (* Usa "DisplayLabel" das colunas para preencher as células ou "FieldName" *)
          if Fields[NumColuna - 1].DisplayLabel <> '' then
            Range[StrCell, StrCell].Value2 := Fields[NumColuna - 1].DisplayLabel
          else
            Range[StrCell, StrCell].Value2 := Fields[NumColuna - 1].FieldName;

        end;
      end;

      NumLinha := 2;

      with Dataset do
      begin
        First;
        while not Eof do
        begin
          for NumColuna := 1 to Fields.Count do
          begin
            if (FieldDefs[NumColuna - 1].DataType in [ftBlob]) then
              Continue;

            StrCell := PegaLetraColuna(NumColuna) + IntToStr(NumLinha);

            if (Fields.Fields[NumColuna - 1].DataType = ftDate)
               or  (Fields.Fields[NumColuna - 1].DataType = ftDateTime) then
            begin
              if (not Fields.Fields[NumColuna - 1].IsNull) then
                Range[StrCell, StrCell].Value2 := '''' + DateToStr(Fields[NumColuna - 1].AsDateTime)
                //Range[StrCell, StrCell].Value2 := FormatDateTime('DD/MM/YYYY',Fields[NumColuna - 1].AsDateTime)
              else
                Range[StrCell, StrCell].Value2 := '';
            end
            else
              Range[StrCell, StrCell].Value2 := Fields.Fields[NumColuna - 1].Value;
          end;
          Next;
          Inc(NumLinha);
        end;
      end;
      Range['A1', StrCell].EntireColumn.Autofit;

      AdtoMru := False;
      CreateBck := False;
      ROREcommended := False;

      ActiveWorkbook.SaveAs(ArqNome,
        xlnormal,
        EmptyParam,
        EmptyParam,
        ROREcommended,
        CreateBck,
        xlNoChange,
        xlUserResolution,
        AdtoMru,
        Emptyparam,
        emptyparam,
        emptyparam,
        lcid);


      Quit;
    finally
      Disconnect;
      Excel.Free;
      Screen.Cursor:=crDefault;
     end;
  end;
end;

end.

