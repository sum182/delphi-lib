{*******************************************************}
{                                                       }
{                 Sum182 Component Library              }
{                                                       }
{  Copyright (c) 2001-2010 Sum182 Software Corporation  }
{                                                       }
{                 Tel.:  55 11 8214-7819                }
{                                                       }
{                 Email: sum182@gmail.com               }
{*******************************************************}


unit smSQL;

interface

  Uses
      SysUtils,Classes,smResourceString,Forms,smGeral,DateUtils,
      StrUtils,Variants,DB;

  Type
    TSQL = class
    private
      FOrderBy: string;
      FUpperCase: Boolean;
      FGroupBy: string;
      FExpressao: string;
      FSQL: string;
      FJoins: string;
      FCondicoes: string;
      FWhere: string;
      FLowerCase: Boolean;
      FName: string;
      procedure SetLowerCase(const Value: Boolean);
      procedure SetCondicoes(const Value: string);
      procedure SetWhere(const Value: string);overload;
      procedure SetJoins(const Value: string);
      function GeTSQL: string;
      procedure SetExpressao(const Value: string);
      procedure SetGroupBy(const Value: string);
      procedure SetOrderBy(const Value: string);
      procedure SetUpperCase(const Value: Boolean);
      procedure SetWhere;overload;
      procedure SetFSQL;

    protected
    public
      constructor Create;
      destructor Destroy;override;

      property SQL:string read GeTSQL ;
      property Expressao: string read FExpressao write SetExpressao;
      property Joins: string read FJoins write SetJoins;
      property Where: string read FWhere write SetWhere;
      property Condicoes: string read FCondicoes write SetCondicoes;
      property OrderBy: string read FOrderBy write SetOrderBy;
      property GroupBy: string read FGroupBy write SetGroupBy;
      property UpperCase: Boolean read FUpperCase write SetUpperCase;
      property LowerCase: Boolean read FLowerCase write SetLowerCase;
      property Name: string read FName write FName;
      procedure AddCondicao(Value: string);
      procedure AddJoin(Value: string);
      procedure AddExpressao(Value: string);
      procedure AddGroupBy(Value: string);
      procedure AddOrderBy(Value: string);
      procedure Clear;
      procedure SalvarSQL;
  end;


implementation

{ TSQL }

procedure TSQL.AddCondicao(Value: string);
begin
  //Metodo para incrementar as Condicoes
  Condicoes := Condicoes + ' ' + Trim(Value);
end;

procedure TSQL.AddExpressao(Value: string);
begin
  //Metodo para incrementar a Expressao
  Expressao := Expressao + ' ' + Trim(Value);
end;

procedure TSQL.AddGroupBy(Value: string);
begin
  //Metodo para incrementar o GroupBy
  GroupBy := GroupBy + ' ' + Trim(Value);
end;

procedure TSQL.AddJoin(Value: string);
begin
  //Metodo para incrementar os Joins
  Joins := Joins + ' ' + Trim(Value);
end;

procedure TSQL.AddOrderBy(Value: string);
begin
  //Metodo para incrementar o Order by
  OrderBy := OrderBy + ' ' + Trim(Value);
end;

procedure TSQL.Clear;
begin
  Expressao := '';
  Joins     := '';
  Where     := '';
  Condicoes := '';
  OrderBy   := '';
  GroupBy   := '';
End;

constructor TSQL.Create;
begin
  Inherited Create;
  UpperCase := False;
  LowerCase := False;
  Clear;
end;

destructor TSQL.Destroy;
begin
  inherited;
end;

function TSQL.GeTSQL: string;
begin
  SetFSQL;
  SetWhere;
  if LowerCase then FSQL := SysUtils.LowerCase(FSQL);
  if UpperCase then FSQL := SysUtils.UpperCase(FSQL);

  SalvarSQL;
  Result := FSQL;
end;

procedure TSQL.SalvarSQL;
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
                           + Name + '_'
                           + Hora
                           + '_'
                           + Dia
                           + Mes
                           + '.sql';
  Try
    fs := TFileStream.Create(Arquivo,fmCreate);
    GravaStream(fs,Expressao);
    GravaStream(fs,Joins);
    GravaStream(fs,Where);
    GravaStream(fs,Condicoes);
    GravaStream(fs,GroupBy);
    GravaStream(fs,OrderBy);
  finally
    //fs.Free;
    FreeAndNil(fs);
  end;
 end;



procedure TSQL.SetCondicoes(const Value: string);
begin
  FCondicoes := Value;
end;

procedure TSQL.SetExpressao(const Value: string);
begin
  FExpressao := Value;
end;

procedure TSQL.SetFSQL;
begin
  FSQL := Expressao  +  ' ' +
          Joins      +  ' ' +
          Where      +  ' ' +
          Condicoes  +  ' ' +
          GroupBy    +  ' ' +
          OrderBy;
end;

procedure TSQL.SetGroupBy(const Value: string);
begin
  FGroupBy := Value;
end;

procedure TSQL.SetJoins(const Value: string);
begin
  FJoins := Value;
end;

procedure TSQL.SetLowerCase(const Value: Boolean);
begin
  FLowerCase := Value;
end;

procedure TSQL.SetOrderBy(const Value: string);
begin
  FOrderBy := Value;
end;



procedure TSQL.SetUpperCase(const Value: Boolean);
begin
  FUpperCase := Value;
end;

procedure TSQL.SetWhere;
Var
  s: string;
begin
  //Metodo para verificar se ja adicionado um WHERE

  s:= FSQL;
  s:= SysUtils.UpperCase(s);

  if (Pos('WHERE',s) = 0) and (Where  = '')then
  begin
    Where := 'Where 1 = 1 ';
    SetFSQL;
  end;
end;

procedure TSQL.SetWhere(const Value: string);
begin
  FWhere := Value;
end;

end.
