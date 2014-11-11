unit UnitMegaFilter;

interface

uses
  SysUtils, Classes, Controls, ExtCtrls, StdCtrls, DBGrids,Graphics,Db,
  DbTables,Messages,Windows;


 const
   WM_CHANGE_COMBOBOX = WM_USER + 500;

type
  TMegaFilter = class(TPanel)
  private

    Lista         :TStringList;
    cbCampo1      :TComboBox;
    cbCampo2      :TComboBox;
    cbOperadores1 :TComboBox;
    cbOperadores2 :TComboBox;
    cbCondicao    :TComboBox;
    edtPesquisa1  :Tedit;
    edtPesquisa2  :Tedit;
    lblFiltro     :TLabel;
    DbGrid1       :TDbGrid;
    Button1       :TButton;
    Button2       :TButton;
    FDataSource: TDataSource;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;
    procedure SetDataSource(const Value: TDataSource);


    { Private declarations }
  protected
    { Protected declarations }
    procedure Resize;override;
    procedure WmChangeComboBox(Var Msg:Tmessage);message WM_CHANGE_COMBOBOX;

  public
    { Public declarations }
    constructor Create(AOwner:TComponent);override;
    destructor  Destroy;override;
    procedure Consulta(Sender:TObject);
    procedure Limpar(Sender:Tobject);

  published
    { Published declarations }
    property Datasource:TDataSource read FDataSource  write SetDataSource;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Tds', [TMegaFilter]);
end;

{ TMegaFilter }

procedure TMegaFilter.Consulta(Sender: TObject);
var Sentenca:String;
begin
    lblFiltro.Caption := '';

    if cbCampo1.Text <> '' then
      if cbOperadores1.Text <> '' then
        if edtPesquisa1.Text <> '' then
          Sentenca := Sentenca + cbCampo1.Text + ' ' + cbOperadores1.Text + QuoTedStr(edtPesquisa1.Text)
    ;



    if cbCampo2.Text <> '' then
      if cbOperadores2.Text <> '' then
        if edtPesquisa2.Text <> '' then
          Sentenca := Sentenca + cbCampo2.Text + ' ' + cbOperadores2.Text + QuoTedStr(edtPesquisa2.Text)
    ;


    Datasource.DataSet.Filter   := Sentenca;
    Datasource.DataSet.Filtered := True;



end;

constructor TMegaFilter.Create(AOwner: TComponent);
begin
inherited;
  Width   := 539;
  Height  := 348;



  lblFiltro := TLabel.Create(Self);
  with lblFiltro do
  begin
    SetBounds(16,324,28,13);
    Caption  := 'Filtro: ';
    Parent   := Self;
  end;



  EdtPesquisa1 := TEdit.Create(Self);
  with EdtPesquisa1 do
  begin
    SetBounds(244,23,121,21);
    TabOrder := 4;
    Parent   := Self;
  end;



  EdtPesquisa2 := TEdit.Create(Self);
  with EdtPesquisa2 do
  begin
    SetBounds(244,62,121,21);
    TabOrder := 5;
    Parent   := Self;
  end;



  DBGrid1 := TDBGrid.Create(Self);
  with DBGrid1 do
  begin
    SetBounds(8,93,524,220);
    TabOrder := 6;
    Parent   := Self;
  end;



  Button1 := TButton.Create(Self);
  with Button1 do
  Begin
    SetBounds(450,23,75,25);
    Caption   := 'Consultar';
    TabOrder  := 7;
    Parent    := Self;
    OnClick   := Consulta;
  end;



  Button2 := TButton.Create(Self);
  with Button2 do
  Begin
    SetBounds(451,58,75,25);
    Caption   := 'Limpar';
    TabOrder  := 8;
    Parent    := Self;
    OnClick   := Limpar;
  end;



  cbCampo1 := TComboBox.Create(Self);
  with cbCampo1 do
  begin
    SetBounds(8,23,165,21);
    Sorted   := True;
    TabOrder := 0;
    Parent   := Self;
  end;



  cbOperadores1 := TComboBox.Create(Self);
  with cbOperadores1 do
  begin
    SetBounds(180,23,57,21);
    ItemHeight := 13;
    TabOrder   := 1;
    Parent     := Self;
  end;



  cbCampo2 := TComboBox.Create(Self);
  with cbCampo2 do
  begin
    SetBounds(8,62,165,21);
    ItemHeight := 13;
    Sorted     := True;
    TabOrder   := 2;
    Parent     := Self;
  end;



  cbOperadores2 := TComboBox.Create(Self);
  with cbOperadores2 do
  begin
    SetBounds(180,62,57,21);
    ItemHeight := 13;
    TabOrder   := 3;
    Parent     := Self;
  end;



  cbCondicao := TComboBox.Create(Self);
  with cbCondicao do
  begin
    SetBounds(376,40,57,21);
    ItemHeight := 13;
    TabOrder   := 4;
    Parent     := Self;
  end;



  Lista := TStringList.Create;
  with Lista do
  begin
    Add('=');
    Add('<>');
    Add('>');
    Add('<');
    Add('>=');
    Add('<=');
  end;


end;

destructor TMegaFilter.Destroy;
begin


  FreeAndNil(Lista);
  FreeAndNil(cbCampo1);
  FreeAndNil(cbCampo2);
  FreeAndNil(cbOperadores1);
  FreeAndNil(cbOperadores2);
  FreeAndNil(cbCondicao);
  FreeAndNil(edtPesquisa1);
  FreeAndNil(edtPesquisa2);
  FreeAndNil(lblFiltro);
  FreeAndNil(DbGrid1);
  FreeAndNil(Button1);
  FreeAndNil(Button2);
   inherited;
end;

procedure TMegaFilter.Limpar(Sender: Tobject);
begin

  cbCampo1.text := '';
  cbCampo2.text := '';

  cbOperadores1.Text := '';
  cbOperadores2.Text := '';

  cbCondicao.Text := '';

  edtPesquisa1.Clear;
  edtPesquisa2.Clear;

  lblFiltro.Caption := 'Filtro:';
  if (datasource.DataSet <> Nil) then
    begin
      Datasource.DataSet.Filter:='';
      Datasource.DataSet.Filtered:=False;
      Datasource.DataSet.Filtered:=True;
    end;

end;

procedure TMegaFilter.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;

  if (AComponent = DataSource) and (Operation = opRemove)then
       Datasource := Nil
  ;
  
end;

procedure TMegaFilter.Resize;
begin
  inherited;
  Width   := 539;
  Height  := 348;
end;

procedure TMegaFilter.SetDataSource(const Value: TDataSource);
begin
  FDataSource := Value;
  DbGrid1.DataSource:= Value;
  PostMessage(Handle,WM_CHANGE_COMBOBOX,0,0);
end;

procedure TMegaFilter.WmChangeComboBox(var Msg: Tmessage);
begin

  //ADICIONA  A LISTA DE CAMPOS AO COMBO BOX
  Datasource.DataSet.GetFieldNames(cbCampo1.Items);
  Datasource.DataSet.GetFieldNames(cbCampo2.Items);


  cbOperadores1.Items := Lista;
  cbOperadores2.Items := Lista;

  cbCondicao.Items.Add('AND');
  cbCondicao.Items.Add('OR');


end;

end.
