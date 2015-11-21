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

unit smBuscaCep;

interface

uses
  IdHTTP;

type
  TsmBuscaCep = class(TObject)
  private
    Indy: TIdHTTP;
    FLogradouro: string;
    FBairro: string;
    FUF: string;
    FCep: string;
    FNome: string;
    FCidade: string;
    FLastError: string;
    FEndereco: string;
  public
    constructor Create;
    destructor Destroy; override;

    function Busca(ACep: string;
                   ProxyServer:string = '';
                   ProxyPort:integer = 0 ): Boolean;

    property Logradouro: string read FLogradouro;
    property Endereco: string read FEndereco;
    property Nome: string read FNome;
    property Bairro: string read FBairro;
    property Cidade: string read FCidade;
    property UF: string read FUF;
    property Cep: string read FCep;
    property LastError: string read FLastError;
  end;

implementation

uses
  StrUtils, SysUtils;

const
  cWebService = 'http://www.bronzebusiness.com.br/webservices/wscep.asmx/cep?strcep=';

function LerTag(const s, Tag: string): string;
var
  Inicio, Fim: Integer;
begin
  Result := '';
  Inicio := Pos('<' + Tag + '>', s);
  if (Inicio = 0) then Exit;
  Inicio := Inicio + Length(Tag) + 2;
  Fim := PosEx('<', s, Inicio);
  if (Fim = 0) then Exit;
  Result := Copy(s, Inicio, Fim - Inicio);
end;

{ TsmBuscaCep }

function TsmBuscaCep.Busca(ACep: string;
                   ProxyServer:string = '';
                   ProxyPort:integer = 0 ): Boolean;

var
  s, tmp: string;
begin
  Result := False;
  FLastError := '';

  if ProxyServer <> '' Then
    Indy.ProxyParams.ProxyServer := ProxyServer;

  if ProxyPort <> 0 Then
    Indy.ProxyParams.ProxyPort := ProxyPort;

  try
    s := Indy.Get(cWebService + ACep);
    tmp := LerTag(s, 'logradouro');
    if (tmp = '') then Exit;
    FLogradouro := tmp;
    FNome := LerTag(s, 'nome');
    FBairro := LerTag(s, 'bairro');
    FCidade := LerTag(s, 'cidade');
    FUF := LerTag(s, 'UF');
    FCep := ACep;
    FEndereco := FLogradouro + ' ' + FNome;

    Result := True;
  except
    on E: Exception do
      FLastError := E.Message;
  end;
end;

constructor TsmBuscaCep.Create;
begin
  inherited;
  Indy := TIdHTTP.Create(nil);
end;

destructor TsmBuscaCep.Destroy;
begin
  Indy.Free;
  inherited;
end;

end.
