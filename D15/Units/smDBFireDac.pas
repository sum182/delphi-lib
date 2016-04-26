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


unit smDBFireDac;

interface

Uses
  Classes,  DBClient,  DB, SqlExpr,FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,System.SysUtils,smStrings;

  procedure SalvarQueryMaster(Dataset:TFDQuery);
  procedure DataSetDelete(DataSet: TDataSet);
  procedure CopyDataSet(Origem:TDataset; Destino: TFDDataSet; DeleteDestino: boolean = True; AOptions: TFDCopyDataSetOptions = [coRestart, coAppend]);
  procedure CopyDataSetByRecord(Origem, Destino: TFDDataSet;var Exceptions:String);
  function GetKeyValuesDataSet(DataSet:TDataSet; KeyField:String):String;



implementation


procedure SalvarQueryMaster(Dataset:TFDQuery);
begin
  if Dataset.State in [dsInactive] then
    Exit;

  if not(Dataset.State in [dsEdit,dsInsert])then
    Exit;

  DataSet.Edit;
  DataSet.Post;
  DataSet.Edit;
end;

procedure DataSetDelete(DataSet: TDataSet);
begin
  //Deleta todos os registros de um dataset
  if DataSet.State in [dsInactive] then
    DataSet.Active := True;

  try
    DataSet.DisableControls;
    with dataset do
    begin
      First;
      while not (eof) do
        Delete;
    end;
  finally
    DataSet.EnableControls;
  end;

end;


procedure CopyDataSet(Origem:TDataset; Destino: TFDDataSet;DeleteDestino: boolean = True; AOptions: TFDCopyDataSetOptions = [coRestart, coAppend]);
begin
  if Origem.State in [dsInactive] then
    Origem.Active := True;

  if Destino.State in [dsInactive] then
    Destino.Active := True;

  try
    Origem.DisableControls;
    Destino.DisableControls;

    if DeleteDestino then
      DataSetDelete(Destino);

    Destino.CopyDataSet(Origem, AOptions);
  finally
    Origem.EnableControls;
    Destino.EnableControls;
  end;
end;

procedure CopyDataSetByRecord(Origem, Destino: TFDDataSet;var Exceptions:String);
begin
  if Origem.State in [dsInactive] then
    Origem.Active := True;

  if Destino.State in [dsInactive] then
    Destino.Active := True;

  if Origem.RecordCount >= 1 then
  begin

    Origem.First;
    while not (Origem.Eof) do
    begin
      try
        Destino.Append;
        Destino.CopyRecord(Origem);
        Destino.Post;
        Origem.Next;
      except on E:Exception do
      begin
        //if E.Errors[i].ErrorCode = ERRCODE_KEYVIOL then
        //if Pos('for key ' + QuotedStr('PRIMARY'),E.Message)<> 0 then
        //if Pos('for key ',E.Message)<> 0 then
          Exceptions:= Exceptions + E.Message;
        Destino.Cancel;
        Origem.Next;
      end;
      end;
    end;
  end;
end;

function GetKeyValuesDataSet(DataSet:TDataSet; KeyField:String):String;
begin
  Result:= EmptyStr;

  if DataSet.State in [dsInactive] then
    DataSet.Open;

  if (DataSet.FindField(KeyField)= Nil) then
    Exit;

  DataSet.First;
  while not(DataSet.Eof)  do
  begin
    AddCommaStr(Result, QuoTedStr(DataSet.FieldByName(KeyField).AsString), ',');
    DataSet.Next;
  end;

  DataSet.First;

  if Result = EmptyStr then
    Result:= QuoTedStr('0');
end;

end.
