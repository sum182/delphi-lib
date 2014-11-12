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


unit smCheckListBox;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, CheckLst,smMensagens,DB;

type
  TsmCheckListBox = class(TCheckListBox)
  private
    FKeyField: string;
    FTextField: string;
    FDataSet: TDataSet;
    FKeyFieldAlias: string;
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    procedure ClickCheck;override;
    procedure AddTodos;
    procedure CheckedAll;
    procedure UnchekedAll;
    procedure FillDataSet;
    function GetSelected: string;
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
  published
    { Published declarations }
      property KeyField: string read FKeyField write FKeyField;
      property KeyFieldAlias: string read FKeyFieldAlias write FKeyFieldAlias;
      property TextField: string read FTextField write FTextField;
      property DataSet: TDataSet read FDataSet write FDataSet;
  end;

procedure Register;

implementation

uses
  smGeral;

procedure Register;
begin
  RegisterComponents('Sum182', [TsmCheckListBox]);
end;

{ TsmCheckListBox }

procedure TsmCheckListBox.AddTodos;
var
  I:Integer;
begin
  //Analisar esta rotina para funcionar no Create
  Items.Insert(0,'Todos');
  for I := 0 to Items.Count-1 do
   Checked[I] := True;
end;

procedure TsmCheckListBox.ClickCheck;
var
  I:Integer;
begin
  inherited;
  if (ItemIndex = 0) then
  begin
    for I := 1 to Items.Count-1 do
      Checked[I] := Checked[0];
  end
  else
    Checked[0] := False;
end;


constructor TsmCheckListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;


destructor TsmCheckListBox.Destroy;
begin
  inherited;
end;

procedure TsmCheckListBox.FillDataSet;
var
  bm: TBookmark;
  tf, kf: TField;
  fTextField: string;
  fKeyField: string;
begin
  if KeyFieldAlias = '' then
    KeyFieldAlias := KeyField;
    
  fKeyField:= copy(KeyField,pos('.',KeyField) +1,length(KeyField));
  fTextField:= copy(TextField,pos('.',TextField) +1,length(TextField));

  if not Assigned(DataSet) then Exit;
  with DataSet do
  begin
    if not Active then Open;
    DisableControls;
    Items.BeginUpdate;
    bm := GetBookmark;
    tf := FindField(fTextField);
    kf := FindField(fKeyField);
    First;
    Items.Clear;
    while not Eof do
    try
      if (kf = nil) then
        Items.Add(Trim(tf.AsString))
      else
        Items.AddObject(Trim(tf.AsString), TObject(kf.AsInteger));
    finally
      Next;
    end;
    if (BookmarkValid(bm)) then
    begin
      GotoBookmark(bm);
      FreeBookmark(bm);
    end;
    EnableControls;
    Items.EndUpdate;
  end;
  AddTodos;
end;


function TsmCheckListBox.GetSelected: string;
var
  Total, Check, i: Integer;
  GetChecked: Boolean;
begin
  Check := 0;
  with  Items do
    for i := 1 to Count-1 do
      if Checked[i] then
        Inc(Check);

  //Nenhum item checkado
  if Check = 0 then
  begin
    Result := KeyFieldAlias + ' in (-123456)';
    Exit;
  end;

  Result := '';
  Total :=  Items.Count-1;
  GetChecked := Check < (Total div 2);
  if not ((Check = 0) or (Check = Total)) then
  with Items do
    for i := 1 to Count-1 do
      if not (Checked[i] xor GetChecked) then
        AddCommaStr(Result, IntToStr(Integer(Objects[i])),',');

  if (Result <> '') then
  begin
    if GetChecked then Result := KeyFieldAlias + ' in (' + Result + ')'
    else Result := KeyFieldAlias + ' not in (' + Result + ')';
  end;

end;

procedure TsmCheckListBox.UnchekedAll;
var
  i:integer;
begin
  for i := 0 to Items.Count - 1 do
    Checked[i]:= False;
end;

procedure TsmCheckListBox.CheckedAll;
var
  i:integer;
begin
  for i := 0 to Items.Count - 1 do
    Checked[i]:= True;
end;

end.
