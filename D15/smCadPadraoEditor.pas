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


unit smCadPadraoEditor;

interface

  Uses DesignEditors,DesignIntf,smCadPadrao;
  type
    TAddFieldsBusca = class(TComponentEditor)

    public
      function GetVerbCount:integer;override;//Total de itens
      function GetVerb(Index:integer):string;override;//Retorna a string
      procedure ExecuteVerb(index:Integer);override;//Executa
      procedure Edit; override;
    end;

    procedure Register;

implementation


{ TAddFieldsBusca }

procedure Register;
begin
  RegisterComponentEditor(TsmCadPadrao,TAddFieldsBusca);
end;

procedure TAddFieldsBusca.Edit;
begin
  inherited;
  ExecuteVerb(0);
end;

procedure TAddFieldsBusca.ExecuteVerb(index: Integer);
begin
  inherited;
  case Index of
 // 0: Edit;
  1: (Component as TsmCadPadrao).FieldsBuscaAdd;
  2: (Component as TsmCadpadrao).FieldsBuscaClear;
  end;
end;

function TAddFieldsBusca.GetVerb(Index: integer): string;
begin
  Result := '';
  case Index of
    0: Result := 'Fields Busca...';
    1: Result := 'Add Fields Busca';
    2: Result := 'Clear Fields Busca';
  end;
end;

function TAddFieldsBusca.GetVerbCount: integer;
begin
  Result := 3;
end;

end.
