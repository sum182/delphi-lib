unit UnitTDbDateTimePicker;

interface

uses
  SysUtils, Classes, Controls, ComCtrls,StdCtrls,ExtCtrls,Db,Dbctrls;

type
  TDbDateTimePicker = class(TDateTimePicker)
  FdataLink : TFieldDataLink;
  Ftimer : TTimer;
  private
    function GetDataField: string;
    function GetDataSource: TDataSource;
    procedure SetDataField(const Value: string);
    procedure SetDataSoruce(const Value: TDataSource);
    { Private declarations }


  protected
    { Protected declarations }
    procedure AtuTime(Sender:TObject);
    procedure DataChange(Sender:TObject);
    procedure UpdateData(Sender:TObject);


  public
    { Public declarations }
    procedure Change;override;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;


  published
    { Published declarations }

    property DataField:string read GetDataField write SetDataField;
    property DataSource:TDataSource read GetDataSource write SetDataSoruce;

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Alvaro', [TDbDateTimePicker]);
end;

{ TDbDateTimePicker }

procedure TDbDateTimePicker.AtuTime(Sender: TObject);
begin
//atualiza a hora do componente
Self.Time := Now;
end;

procedure TDbDateTimePicker.Change;
begin
  //verificando se a tabela esta em estado de edicao
  if not FdataLink.Editing then
    //editando o field
    FdataLink.Edit
  ;

  //sinalizando que ouveram alteracoes
  FdataLink.Modified;
  inherited;
end;



constructor TDbDateTimePicker.Create(AOwner: TComponent);
begin
  inherited;

  //Criando o objeto que referenciara o campo da tabela
  FdataLink := TFieldDataLink.Create;

  //Metodo para exibir os dados
  FdataLink.OnDataChange := DataChange;

  //metodo para salvar os dados
  FdataLink.OnUpdateData := UpdateData;

  //criando um objeto Timer
  Ftimer         := TTimer.Create(self);
  Ftimer.OnTimer := AtuTime;

end;

procedure TDbDateTimePicker.DataChange(Sender: TObject);
begin

    if Assigned(FdataLink.DataSource) and Assigned(FdataLink.Field) then
      Begin
        //atualizando a hora do componente
        self.Date := FdataLink.Field.AsDateTime;
      end;

end;


destructor TDbDateTimePicker.Destroy;
begin
  //destroindo os objetos da memoria
  FreeAndNIl(FdataLink);
  FreeAndNil(Ftimer);
  inherited;
end;

function TDbDateTimePicker.GetDataField: string;
begin
   //pegadno o nome do field
   Result := FdataLink.FieldName;
end;

function TDbDateTimePicker.GetDataSource: TDataSource;
begin
  //pegando o datasource
  Result:= FdataLink.DataSource;
end;

procedure TDbDateTimePicker.SetDataField(const Value: string);
begin
   //setando o field
   FdataLink.FieldName := value;
end;

procedure TDbDateTimePicker.SetDataSoruce(const Value: TDataSource);
begin
     //setando o datasoruce
     FdataLink.DataSource := Value;
end;

procedure TDbDateTimePicker.UpdateData(Sender: TObject);
begin
  //atualiza o campo da tabela
  FdataLink.Field.AsDateTime := Self.Date;
end;

end.
