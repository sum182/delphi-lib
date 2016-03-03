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
  FireDAC.Comp.Client;

  procedure SalvarQueryMaster(Dataset:TFDQuery);
  procedure DataSetDelete(DataSet: TDataSet);
  procedure CopyDataSet(Origem, Destino: TFDDataSet; DeleteDestino: boolean = True; AOptions: TFDCopyDataSetOptions = [coRestart, coAppend]);


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
  with dataset do
  begin
    First;
    while not (eof) do
      Delete;
  end;
end;


procedure CopyDataSet(Origem, Destino: TFDDataSet; DeleteDestino: boolean = True; AOptions: TFDCopyDataSetOptions = [coRestart, coAppend]);
begin
  if Origem.State in [dsInactive] then
    Origem.Active := True;

  if Destino.State in [dsInactive] then
    Destino.Active := True;

  if DeleteDestino then
    DataSetDelete(Destino);

  Destino.CopyDataSet(Origem, AOptions);
end;





end.
