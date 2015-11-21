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

unit smDB;

interface

uses
  Windows, Forms, Controls, Typinfo, SysUtils, Types, Classes,
  DBClient, DB, SqlExpr, Variants;

procedure QueryClearParams(Query: TSQLDataSet);
procedure OpenDataSet(DataSet: TDataSet);
procedure OpenDS(DataSet: TDataSet);
procedure OpenDataSets(Form: TForm); overload;
procedure OpenDataSets(DM: TDataModule); overload;
procedure CloseDataSets(Formulario: TForm); overload;
procedure CloseDataSets(DataModulo: TDataModule); overload;
procedure DataSetDelete(DataSet: TDataSet);
procedure DataSetEdit(DataSet: TDataSet);
function StateEdits(DataSet: TDataSet): Boolean;
function DataSetAlterado(DataSet: TDataSet; FieldsExcessao: array of string): boolean;
procedure CopyDataset(Origem, Destino: TDataset; DeleteDestino: boolean = True);
procedure CopyRecord(Origem, Destino: TDataset; DeleteDestino: boolean = False);

implementation

procedure QueryClearParams(Query: TSQLDataSet);
var
  i: Integer;
begin
  //Limpa os parametros de um SqlDataSet
  for I := 0 to (Query.Params.Count - 1) do
    Query.Params[i].Value := Null;
end;

procedure CloseDataSets(Formulario: TForm);
var
  I: Integer;
begin
  //Fecha os datasets de um formulario
  if (Formulario = nil) then
    Exit;

  for i := 1 to Formulario.componentCount - 1 do
    if (Formulario.Components[i] is TDataSet) then
      (Formulario.Components[i] as TDataSet).Close;

end;

procedure CloseDataSets(DataModulo: TDataModule);
var
  i: Integer;
begin
  //fecha os datasets de um DM
  if (DataModulo = nil) then
    Exit;

  for i := 1 to DataModulo.componentCount - 1 do
    if (DataModulo.Components[i] is TDataSet) then
      (DataModulo.Components[i] as TDataSet).Close;
end;

procedure OpenDataSet(DataSet: TDataset);
begin
  //Abre um dataset
  with dataset do
  begin
    Close;
    Open;
  end;
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

procedure DataSetEdit(DataSet: TDataSet);
begin
  with DataSet do
  begin
    if not (state in [dsInsert, dsEdit]) then
      Edit;
  end;
end;

function StateEdits(DataSet: TDataSet): Boolean;
begin
  with DataSet do
  begin
    Result := State in [dsInsert, dsEdit];
  end;
end;

procedure OpenDataSets(Form: TForm);
var
  i: integer;
begin
  if (Form = nil) then
    Exit;

  for i := 0 to Form.ComponentCount - 1 do
    if (Form.Components[i] is TDataSet) then
    begin
      (Form.Components[i] as TDataSet).Close;
      (Form.Components[i] as TDataSet).Open;
    end;
end;

procedure OpenDataSets(DM: TDataModule); overload;
var
  i: integer;
begin
  if (DM = nil) then
    Exit;
  for i := 0 to DM.ComponentCount - 1 do
    if (DM.Components[i] is TDataSet) then
    begin
      (DM.Components[i] as TDataSet).Close;
      (DM.Components[i] as TDataSet).Open;
    end;
end;

function DataSetAlterado(DataSet: TDataSet; FieldsExcessao: array of string): boolean;
var
  i: integer;
  e: integer;
  Excessao: boolean;
begin
  Result := False;
  Excessao := False;

  with DataSet do
  begin
    if state in [dsInsert] then
      Exit;

    for I := 0 to DataSet.Fields.Count - 1 do
    begin

      //campos em excessao
      for e := Low(FieldsExcessao) to High(FieldsExcessao) do
        if (UpperCase(DataSet.Fields[i].FieldName) = (UpperCase(FieldsExcessao[e]))) then
        begin
          Excessao := True;
          Break;
        end;
      if Excessao then
        Continue;

      //caso o conteudo do campo tenha alteracoes
      if Fields[i].OldValue <> Fields[i].NewValue then
      begin
        Result := True;
        Break;
      end;
    end;
  end;
end;

procedure OpenDS(DataSet: TDataSet);
begin
  //Abre um dataset
  with dataset do
  begin
    Close;
    Open;
  end;
end;

procedure CopyDataset(Origem, Destino: TDataset; DeleteDestino: boolean = True);
var
  i: integer;
  j: integer;
begin
  Origem.Close;
  Origem.Open;

  Destino.Close;
  Destino.Open;

  if DeleteDestino then
    DataSetDelete(Destino);

  Origem.First;
  while not (Origem.Eof) do
  begin
    Destino.Append;

    for i := 0 to Origem.FieldCount - 1 do
      for j := 0 to Destino.FieldCount - 1 do
        if (Origem.Fields[i].FieldName) = (Destino.Fields[j].FieldName) then
        begin
          Destino.Fields[i].Value := Origem.Fields[j].Value;
          Break;
        end;
    Destino.Post;
    Origem.Next;
  end;
end;

procedure CopyRecord(Origem, Destino: TDataset; DeleteDestino: boolean = False);
var
  i: integer;
  j: integer;
begin
  if DeleteDestino then
    DataSetDelete(Destino);

  Destino.Append;

  for i := 0 to Origem.FieldCount - 1 do
    for j := 0 to Destino.FieldCount - 1 do
      if (Origem.Fields[i].FieldName) = (Destino.Fields[j].FieldName) then
      begin
        Destino.Fields[i].Value := Origem.Fields[j].Value;
        Break;
      end;
  Destino.Post;

end;

end.

