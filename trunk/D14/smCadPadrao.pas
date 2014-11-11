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


unit smCadPadrao;

interface

uses
  SysUtils, Classes, WideStrings, DbClient, DB;

type
  TBotoes = (Localizar, Novo, Salvar, Cancelar, Alterar, Deletar, Imprimir, LocalizarTudo);
  TCjBotoes = set of TBotoes;


  //classe para os items dos campos da busca
  TFieldsBuscaItem = class(TCollectionItem)
  private
    FFieldName: string;
    FDisplayName: string;
    FFieldType: TFieldType;
    FShowGrid: Boolean;
    FShowCombo: Boolean;
    FShowSelect: Boolean;

  protected
    function GetDisplayName: string; override;
  public
    constructor Create (Collection : TCollection);override;
  published
    property FieldName: string read FFieldName write FFieldName;
    property DisplayName: string read FDisplayName write FDisplayName;
    property ShowCombo: Boolean read FShowCombo write FShowCombo;
    property ShowGrid: Boolean read FShowGrid write FShowGrid;
    property ShowSelect: Boolean read FShowSelect write FShowSelect;
    property FieldType: TFieldType read FFieldType write FFieldType;
  end;


  // Classe dos colections de itens dos campos da busca
  TFieldsBuscaCollecion = class (TCollection)
  private
    FOwner: TPersistent;
    function GetItem(Index: Integer): TFieldsBuscaItem;
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TPersistent);
    property Items[Index: Integer]: TFieldsBuscaItem read GetItem; default;
    function Add: TFieldsBuscaItem;
  end;



  //classe pricipal do componente
  TsmCadPadrao = class(TComponent)
  private
    FTabela: TFileName;
    FDataSourceBusca: TDataSource;
    FDataSourceCadastro: TDataSource;
    FBuscaGetAll: Boolean;
    FBuscaVisible: Boolean;
    FBuscaSql: TStrings;
    FBuscaGetAllMsg: Boolean;
    FBotoes: TCjBotoes;
    fBuscaCondicoes: TStrings;
    FGridCreateColumns: Boolean;
    FFieldsBusca: TFieldsBuscaCollecion;
    FkeyField: string;
    FBuscaOrderBy: TStrings;
    procedure setBuscaOrderBy(const Value: TStrings);
    procedure setBuscaSql(const Value: TStrings);
    procedure setBuscaCondicoes(const Value: TStrings);
  protected
  public
    procedure FieldsBuscaAdd;
    procedure FieldsBuscaClear;
    procedure FieldsBuscaShow;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy ;override;
  published
    property Botoes: TCjBotoes read FBotoes write FBotoes;
    property BuscaGetAll: Boolean read FBuscaGetAll write FBuscaGetAll;
    property BuscaVisible: Boolean read FBuscaVisible write FBuscaVisible;
    property BuscaSql: TStrings read FBuscaSql write setBuscaSql;
    property BuscaOrderBy:TStrings read FBuscaOrderBy write setBuscaOrderBy;
    property BuscaGetAllMsg: Boolean read FBuscaGetAllMsg write FBuscaGetAllMsg;
    property BuscaCondicoes:TStrings read fBuscaCondicoes write setBuscaCondicoes;
    property DataSourceCadastro: TDataSource read FDataSourceCadastro write FDataSourceCadastro;
    property DataSourceBusca: TDataSource read FDataSourceBusca write FDataSourceBusca;
    property GridCreateColumns: Boolean read FGridCreateColumns write FGridCreateColumns;
    property Tabela: TFileName read FTabela write FTabela;
    property FieldsBusca: TFieldsBuscaCollecion read FFieldsBusca write FFieldsBusca;
    property KeyField: string read FKeyField write FKeyField;
  end;

procedure Register;

implementation

uses
  smGeral, smMensagens, smStrings;

procedure Register;
begin
  RegisterComponents('Sum182', [TsmCadPadrao]);
end;

{ TsmCadPadrao }

procedure TsmCadPadrao.FieldsBuscaAdd;
var
  I:Integer;
begin

  try
    if DataSourceCadastro.DataSet = nil then
    begin
      Msg('Propriedade DataSet do DataSourceCadastro não foi preenchida!',mtErro);
      Exit;
    end;
    Wait;

    with DataSourceCadastro.DataSet do
    begin
      FieldsBusca.Clear;
      Close;
      Open;
      for i:=0 to FieldCount - 1 do
      begin
        FieldsBusca.Add;
        FieldsBusca.Items[i].FieldName := Fields[i].FieldName;
        FieldsBusca.Items[i].DisplayName := FirstUpperCase(Fields[i].FieldName);
        FieldsBusca.Items[i].FieldType := Fields[i].DataType;
        FieldsBusca.Items[i].ShowCombo := True;
        FieldsBusca.Items[i].ShowGrid := True;
        FieldsBusca.Items[i].ShowSelect := True;
      end;
    end;
  finally
    DataSourceCadastro.DataSet.Close;
    WaitEnd;
  end;

end;

procedure TsmCadPadrao.FieldsBuscaClear;
begin
  Try
    Wait;
    FieldsBusca.Clear;
  finally
    WaitEnd;
  end;
end;

constructor TsmCadPadrao.Create(AOwner: TComponent);
begin
  inherited;
  FBuscaSql := TStringList.Create;
  FBuscaOrderBy := TStringList.Create;
  fBuscaCondicoes := TStringList.Create;
  FFieldsBusca := TFieldsBuscaCollecion.Create(self);
end;

destructor TsmCadPadrao.Destroy;
begin
  FBuscaCondicoes.Free;
  FBuscaSql.Free;
  FBuscaOrderBy.Free;
  FFieldsBusca.Free;
  inherited;
end;


procedure TsmCadPadrao.setBuscaCondicoes(const Value: TStrings);
begin
  fBuscaCondicoes.Assign(Value);
end;

procedure TsmCadPadrao.setBuscaOrderBy(const Value: TStrings);
begin
  FBuscaOrderBy.Assign(Value);
end;

procedure TsmCadPadrao.setBuscaSql(const Value: TStrings);
begin
  FBuscaSql.Assign(Value);
end;

procedure TsmCadPadrao.FieldsBuscaShow;
begin
// FieldsBusca.
end;

{ TFieldsBusca }

constructor TFieldsBuscaItem.Create(Collection: TCollection);
begin
  inherited;
  FFieldName := '';
  FDisplayName:= '';
end;

{ TFieldsBuscaCollecion }

function TFieldsBuscaCollecion.Add: TFieldsBuscaItem;
begin
  Result := TFieldsBuscaItem(inherited Add);
end;

constructor TFieldsBuscaCollecion.Create(AOwner: TPersistent);
begin
 inherited Create(TFieldsBuscaItem);
 FOwner := AOwner;
end;

function TFieldsBuscaCollecion.GetItem(Index: Integer): TFieldsBuscaItem;
begin
  Result := TFieldsBuscaItem(inherited GetItem(Index));
end;

function TFieldsBuscaCollecion.GetOwner: TPersistent;
begin
 Result := FOwner;
end;


function TFieldsBuscaItem.GetDisplayName: string;
begin
  Result := FDisplayName;
  if Result = '' then
    Result := inherited GetDisplayName;
end;

end.

