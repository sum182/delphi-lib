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


unit uATPPlugins;

interface

uses
  SysUtils, Classes, Contnrs, Windows,UOTAUtils;

type
  TGetStringProc = function: PChar; stdcall;
  TProcessTextProc = function(Text: Pchar): PChar; stdcall;

  TATPPlugin = class
  private
    // Caminho e nome do arquivo da DLL
    FDLLFileName: String;

    // Ponteiros para as funções da DLL
    FProcessTextProc: TProcessTextProc;
    FGetDescriptionProc: TGetStringProc;
    FGetShortCutProc: TGetStringProc;

    // Manipulador da DLL
    DLLHandle: THandle;

  public
     // Executa a rotina de processamento de texto do plugin
    // O Parametro Sender é para tornar o método compativel com TNotifyEvent
    // usado em eventos OnClick
    procedure Execute(Sender: TObject);


    constructor create(const ADLLFileName: String);

    // Carrega a DLL do Plugin
    procedure LoadPlugin;

    // Descarrega a DLL do Plugin
    procedure UnLoadPlugin;

    // Funções da DLL
    function ProcessText(const Text: String): String;
    function GetDescription: String;
    function GetShortCut: String;

    property DLLFileName: String read FDLLFileName write FDLLFileName;
  end;

TATPPlugins = class(TObjectList)
  private
    FPath: String;
    function GetItem(Index: Integer): TATPPlugin;
    procedure SetItem(Index: Integer; const Value: TATPPlugin);
    procedure SetPath(const Value: String);
  protected
  public
    Constructor Create;

    // Varre pasta de plugins e carrega uma lista de Objetos TATPPlugin
    procedure LoadPlugins;

    property Items[Index: Integer]: TATPPlugin read GetItem write SetItem; default;

    // Pasta onde estão as DLLs
    property Path: String read FPath write SetPath;
  end;



implementation

{ TATPPlugin }

constructor TATPPlugin.create(const ADLLFileName: String);
begin
   // Limpa referências
   FProcessTextProc := nil;
   FGetDescriptionProc := nil;
   FGetShortCutProc := nil;
   DLLHandle := 0;
   DLLFileName := ADLLFileName;
end;


function TATPPlugin.ProcessText(const Text: String): String;
begin
  Result := Text;

  // Carrega DLL do Plugin
  LoadPlugin;

  try
   if Assigned(FProcessTextProc) then begin
     try
       // Executa função ProcessText da DLL carregada
       Result := FProcessTextProc(Pchar(Text));
     except
      Result := Text;
     end;
   end;
  finally
   // Descarrega DLL do Plugin
   UnLoadPlugin;
  end;
end;



procedure TATPPlugin.LoadPlugin;
begin
  try
   // Carrega DLL para a memória
   DLLHandle := LoadLibrary(Pchar(DLLFileName));
  except
   DLLHandle := 0
  end;

  // Obtem referências dinâmicas para as funções da DLL
  // que serão executadas pela aplicação
  if DLLHandle <> 0 then begin
   FProcessTextProc := GetProcAddress(DLLHandle,'ProcessText');
   FGetDescriptionProc := GetProcAddress(DLLHandle,'GetDescription');
   FGetShortCutProc := GetProcAddress(DLLHandle,'GetShortCut');
  end;
end;

procedure TATPPlugin.Execute(Sender: TObject);
var
  Text: String;
  EOL: String;
begin
   // Obtem texto selecionado do Editor do Delphi
   Text := GetSelection;

   if Text = '' then exit;

   // Verifica se possui quebras de Linha no final do texto
   // e as remove para não causar problemas de linhas a mais ou a menos
   // após o processamento pelo plugin
   EOL := GetEOL(Text);
   Text := TrimText(Text);

   // Processa o Texto com a rotina do Plugin
   Text := ProcessText(Text);

   // Restaura as quebras de linha originais
   Text := Text + EOL;

   // Substitui a seleção pelo novo texto
   ReplaceSelection(Text);
end;

function TATPPlugin.GetDescription: String;

begin
   Result := '';

   // Carrega DLL do Plugin
   LoadPlugin;

   try
    if Assigned(FGetDescriptionProc) then begin
      try

       // Executa função GetDescription da DLL carregada
       Result := FGetDescriptionProc;

      except
       Result := '';
      end;
    end;
   finally
    // Descarrega DLL do Plugin
    UnLoadPlugin;
   end;
end;

procedure TATPPlugin.UnLoadPlugin;
begin
   // Descarrega DLL da memória
   if DLLHandle <> 0 then
     FreeLibrary(DLLHandle);

   // Limpa referências
   FProcessTextProc := nil;
   FGetDescriptionProc := nil;
   FGetShortCutProc := nil;
   DLLHandle := 0;
end;

function TATPPlugin.GetShortCut: String;
begin
   Result := '';

   // Carrega DLL do Plugin
   LoadPlugin;

   try
    if Assigned(FGetShortCutProc) then begin
      try

       // Executa função GetShortCut da DLL carregada
       Result := FGetShortCutProc;

      except
       Result := '';
      end;
    end;
   finally
    // Descarrega DLL do Plugin
    UnLoadPlugin;
   end;
end;

{ TATPPlugins }

constructor TATPPlugins.Create;
begin
  inherited Create(true);
end;

function TATPPlugins.GetItem(Index: Integer): TATPPlugin;
begin
    Result := TATPPlugin(inherited GetItem(Index));
end;

procedure TATPPlugins.SetItem(Index: Integer; const Value: TATPPlugin);
begin
 inherited SetItem(Index,Value);
end;

procedure TATPPlugins.SetPath(const Value: String);
begin
  FPath := Value;
  LoadPlugins;
end;

procedure TATPPlugins.LoadPlugins;
var
  SearchRec: TSearchRec;
begin
  // Limpa plugins se já existirem
  Clear;

  if FPath <> '' then begin

    // Localiza arquivos DLL na pasta de plugins configurada
    if FindFirst(ExcludeTrailingPathDelimiter(FPath) + '\*.dll',faArchive,SearchRec) = 0 then begin

      // instancia objeto de plugin e adiciona na lista
      Add(TATPPlugin.Create(ExcludeTrailingPathDelimiter(FPath)+ '\' + SearchRec.Name));

      while FindNext(SearchRec) = 0 do
        // instancia objeto de plugin e adiciona na lista
        Add(TATPPlugin.Create(ExcludeTrailingPathDelimiter(FPath)+ '\' + SearchRec.Name));

      SysUtils.FindClose(SearchRec)
    end;
  end;
end;


end.
