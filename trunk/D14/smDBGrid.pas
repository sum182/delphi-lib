{*******************************************************}
{                                                       }
{                 Sum182 Component Library              }
{                                                       }
{  Copyright (c) 2001-2007 Sum182 Software Corporation  }
{                                                       }
{                 Tel.:  55 11 8214-7819                }
{                                                       }
{                 Email: sum182@gmail.com               }
{*******************************************************}


unit smDBGrid;

interface

uses
  SysUtils, Classes, Controls, Grids, DBGrids, Graphics, Types,
  DBClient,DB;

type
  TsmDBGrid = class(TDBGrid)
  private
    FAlternateColor: TColor;
    procedure SetAlternateColor(const Value: TColor);
  protected
    procedure DrawColumnCell(const Rect: TRect; DataCol: Integer;
                             Column: TColumn;
                             State: TGridDrawState); override;
    procedure TitleClick(Column: TColumn); override;
    procedure OrdenarDataSetGrid(CDS:TClientDataSet;
                               var DBG:TsmDBGrid;
                                   Column: TColumn);
  public
  published
    constructor Create(Aowner: TComponent); override;
    property AlternateColor: TColor read FAlternateColor write SetAlternateColor;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Sum182', [TsmDBGrid]);
end;

{ TColorGrid_TQ }

constructor TsmDBGrid.Create(Aowner: TComponent);
begin
  inherited;
  //azul
  //SetAlternateColor($0FFEEDF);

  //cinza
  SetAlternateColor($00EEEEEE);

  Options :=[dgEditing,dgTitles,dgColumnResize,dgColLines,
             dgRowLines,dgTabs,dgRowSelect,dgConfirmDelete,dgCancelOnExit]
end;

procedure TsmDBGrid.DrawColumnCell(const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  inherited;
  //verifica se é par  --> odd = impar
  if not odd(DataSource.DataSet.RecNo) then

    //verifica se a linha nao esta selecionada
    if not (gdSelected in State) then
    begin
      //setando a cor da linha
      self.Canvas.Brush.Color := AlternateColor;

      //pinta a celula
      self.Canvas.FillRect(Rect);

      //pinta o texto da coluna
      Self.DefaultDrawDataCell(rect, column.Field, state);
    end;
end;

procedure TsmDBGrid.OrdenarDataSetGrid(CDS: TClientDataSet;
  var DBG: TsmDBGrid; Column: TColumn);
const
  idxDefault = 'DEFAUT_ORDER';
var
  strColumn: string;
  i: integer;
  bolUsed: boolean;
  idOptions: TIndexOptions;
begin
  strColumn := idxDefault;

  if Column.Field.FieldKind in [fkCalculated, fkLookup, fkAggregate] then
    Exit;

  if Column.Field.DataType in [ftblob,ftMemo] then
    Exit;

  for I := 0 to DBG.Columns.Count - 1 do
  begin
    DBG.Columns[i].Title.Font.Style := [];
  end;

  DBG.Columns[Column.Index].Title.Font.Style := [fsBold];
  bolUsed := (Column.Field.FieldName = CDS.IndexName);

  CDS.IndexDefs.Update;
  for I := 0 to CDS.IndexDefs.Count - 1 do
  begin
    if CDS.IndexDefs.Items[i].Name = Column.Field.FieldName then
    begin
      strColumn := Column.Field.FieldName;
      case (CDS.IndexDefs.Items[i].Options = [ixDescending]) of
        True: idOptions := [];
        False: idOptions := [ixDescending];
      end;
    end;
  end;

  if (strColumn = idxDefault) or (bolUsed)then
  begin
    if bolUsed then
      CDS.DeleteIndex(Column.Field.FieldName);
    try
      CDS.AddIndex(Column.Field.FieldName,
                   Column.Field.FieldName,
                   idOptions,
                   '',
                   '',
                   0);
       strColumn := Column.Field.FieldName;
   except
     if bolUsed then
       strColumn := idxDefault;
   end;
  end;

  try
    cds.IndexName := strColumn;
  except
    CDS.IndexName := idxDefault;
  end;
end;

procedure TsmDBGrid.SetAlternateColor(const Value: TColor);
begin
  FAlternateColor := Value;
  Refresh;
end;

procedure TsmDBGrid.TitleClick(Column: TColumn);
begin
  inherited;
  if (DataSource.DataSet is TClientDataSet) then
    OrdenarDataSetGrid((DataSource.DataSet as TClientDataSet),
                        self,
                        Column);
end;

end.

