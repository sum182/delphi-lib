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


unit uATP;

interface

uses
  Menus, ToolsAPI, SysUtils, UATPPlugins, FileCtrl,
  Windows, Registry;

type
  TATP = class
  private
    ATPMenuItem: TMenuItem;
    ConfigMenuItem: TMenuItem;
    Plugins: TATPPlugins;
    procedure ConfigMenuItemClick(Sender: TObject);
    procedure LoadATPMenu;

    // Obtem e grava a pasta de plugins no registro do windows
    // Solicita ao usuário caso não a encontre
    function GetPluginPathFromRegistry(const ForceSelection: Boolean = false): String;
  public
    constructor Create;
    destructor Destroy; override;
  published

  end;

var
  ATP: TATP;

implementation

{ TATPMenu }

procedure TATP.ConfigMenuItemClick(Sender: TObject);
begin
  Plugins.Path := GetPluginPathFromRegistry(true);
  LoadATPMenu;
end;

constructor TATP.Create;
begin
  ATPMenuItem := TMenuItem.Create(nil);
  ATPMenuItem.Caption := 'Sum 182';

  // Instancia a lista de Plugins
  Plugins := TATPPlugins.Create;

  // Carrega Pasta de Plugins e inicializa a lista
  Plugins.Path := GetPluginPathFromRegistry(false);

  // Carrega Menus do ATP
  LoadATPMenu;

  // Adiciona item de Menu ao Delphi
  (BorlandIDEServices as INTAServices).MainMenu.Items.Add(ATPMenuItem);
end;

destructor TATP.Destroy;
begin
  ATPMenuItem.Free;
  if Assigned(Plugins) then
    FreeAndNil(Plugins);
  inherited;
end;

function TATP.GetPluginPathFromRegistry(const ForceSelection: Boolean = false): String;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
   Reg.RootKey := HKEY_CURRENT_USER;
   if Reg.OpenKey('\Software\ATP\', True) then begin
     Result := Reg.ReadString('PluginPath');
   end;
   if (Result = '') or ForceSelection then begin
    if SelectDirectory('Selecione Pasta de Plugins','',Result) then begin
      Reg.WriteString('PluginPath',Result);
    end;
   end;
  finally
   Reg.Free;
  end;
end;

procedure TATP.LoadATPMenu;
var
  i: integer;
  Menu: TMenuItem;
  Description: string;
  SShortCut: string;
begin
  ATPMenuItem.Clear;

  ConfigMenuItem := TMenuItem.Create(ATPMenuItem);
  ConfigMenuItem.Caption := '&Configuração...';
  ConfigMenuItem.OnClick := ConfigMenuItemClick;

  ATPMenuItem.Add(ConfigMenuItem);

  // Varre a lista de plugins e cria os menus
  for i := 0 to Plugins.Count - 1 do begin
    // Obtem descrição e Tecla de atalho da DLL do plugin
    Description := Plugins[i].GetDescription;
    SShortCut := Plugins[i].GetShortCut;

    if Description <> '' then begin
      Menu := TMenuItem.Create(ATPMenuItem);
      Menu.Caption := Description;

      // Aponta o OnClick para o método do plugin que realiza o trabalho
      // principal da aplicação que é processar e substituir o texto selecionado
      // no editor do Delphi.
      Menu.OnClick := Plugins[i].Execute;

      // converte o string  de tecla de atalho retornado pela DLL em  um
      // ShortCut válido para o item de menu.
      if SShortCut <> '' then
        Menu.ShortCut := TextToShortCut(SShortCut);

      ATPMenuItem.Add(Menu);
    end;
  end;
end;

initialization
  ATP := TATP.Create;

finalization
  if Assigned(ATP) then
    FreeAndNil(ATP);

end.

