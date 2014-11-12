{*******************************************************}
{                                                       }
{                 Sum182 Component Library              }
{                                                       }
{  Copyright (c) 2001-2010 Sum182 Software Corporation  }
{                                                       }
{                 Tel.:  55 11 8214-7819                }
{                                                       }
{                 Email: sum182@gmail.com               }
{******************************************************}

unit smForms;

interface

uses
  Classes, Dialogs, ComCtrls, StdCtrls, Windows, Messages, SysUtils,
  Variants, Graphics, Controls, DateUtils, StrUtils, Forms;
procedure OpenFormSDI(FormClass: TFormClass; out Form);
procedure OpenFormMDI(FormClass: TFormClass; out Form);
procedure OpenFormMDIClass(TFormClass: string); overload;
procedure OpenFormMDIClass(TFormClass: string;out Form); overload;
procedure CreateFormMDIClass(TFormClass: string;out Form); overload;

procedure UnloadFormsInModule(AModule: Integer);
procedure FormMDIRestore;
procedure CloseAllForms;
procedure MaximizaAllForms;

implementation

procedure OpenFormSDI(FormClass: TFormClass; out Form);
begin
  //Abri um form modal - SDI
  try
    TForm(Form) := FormClass.Create(Application);
    TForm(Form).FormStyle := fsNormal;
    TForm(Form).Visible:= False;
    TForm(Form).ShowModal;
  finally
    FreeAndNil(Form);
  end;

end;

procedure OpenFormMDI(FormClass: TFormClass; out Form);
begin
  //Abrir um Form MDI
  TForm(Form) := FormClass.Create(Application);
  TForm(Form).FormStyle := fsMDIChild;
  TForm(Form).Show;
end;

procedure OpenFormMDIClass(TformClass: string); overload;
var
  AClass: TClass;
  AForm: TForm;
  i: byte;
begin
  //Abrir um form MDI através de sua classe

  //Ponteiro dos objetos
  AForm := nil;
  AClass := nil;

  //Buscando a Classe do Formulario
  AClass := GetClass(TFormClass);

  if AClass = nil then
    Exit;

  //Verificando se o Formulario ja esta criado
  for i := 0 to Screen.FormCount - 1 do
    if Screen.Forms[i] is AClass then
    begin
      AForm := Screen.Forms[i];
      Break;
    end;
  //Criando o Form
  if (AForm = nil) then
  begin
    Application.CreateForm(TComponentClass(AClass), AForm);
    AForm.FormStyle := fsMDIChild;
  end;

  //Exibindo o Form ja em memoria
  if AForm <> nil then
    with AForm do
    begin
      BringToFront;
      SetFocus;
      Show;
    end;

end;


procedure UnloadFormsInModule(AModule: Integer);
var
  i: integer;
begin
  //Limpa todos os forms de um modulo

  with Application do
    for i := ComponentCount - 1 downto 0 do
      if FindClassHInstance(Components[i].ClassType) = AModule then
        Components[i].Free;
end;
procedure FormMDIRestore;
var
  I: Integer;
begin
  for I := 0 to Screen.FormCount - 1 do
  begin
    if Screen.Forms[i].FormStyle = fsMDIChild then
      Screen.Forms[i].WindowState := wsNormal;
  end;
end;

procedure OpenFormMDIClass(TFormClass: string;out Form ); overload;
var
  AClass: TClass;
  AForm: TForm;
  i: byte;
begin
  //Abrir um form MDI através de sua classe

  //Ponteiro dos objetos
  AForm := nil;
  AClass := nil;

  //Buscando a Classe do Formulario
  AClass := GetClass(TFormClass);

  if AClass = nil then
    Exit;

  //Verificando se o Formulario ja esta criado
  for i := 0 to Screen.FormCount - 1 do
    if Screen.Forms[i] is AClass then
    begin
      AForm := Screen.Forms[i];
      Break;
    end;

  //Criando o Form
  if (AForm = nil) then
  begin
    Application.CreateForm(TComponentClass(AClass), Form);
  end;

  if AForm <> nil then
  begin
    if TForm(Form).FormStyle <> fsMDIChild then
    begin
      TForm(Form).FormStyle := fsMDIChild;
      TForm(Form).Show;
      TForm(Form).SetFocus;
    end
    else
    begin
      TForm(Form).Show;
      TForm(Form).SetFocus;
      TForm(Form).OnShow(Application);
    end;
  end;
end;

procedure CreateFormMDIClass(TFormClass: string;out Form); overload;
var
  AClass: TClass;
  AForm: TForm;
  i: byte;
begin
  //cRIAR um form MDI através de sua classe

  //Ponteiro dos objetos
  AForm := nil;
  AClass := nil;

  //Buscando a Classe do Formulario
  AClass := GetClass(TFormClass);

  if AClass = nil then
    Exit;

  //Verificando se o Formulario ja esta criado
  for i := 0 to Screen.FormCount - 1 do
    if Screen.Forms[i] is AClass then
    begin
      AForm := Screen.Forms[i];
      Break;
    end;

  //Criando o Form
  if (AForm = nil) then
  begin
    Application.CreateForm(TComponentClass(AClass), Form);
  end;
end;

procedure CloseAllForms;
var
  i:integer;
begin
  for i := 0 to Screen.FormCount - 1 do
    if Screen.Forms[i].FormStyle = fsMDIChild then
      Screen.Forms[i].Close;
end;

procedure MaximizaAllForms;
var
  i:integer;
begin
  for i := 0 to Screen.FormCount - 1 do
    Screen.Forms[i].WindowState := wsMaximized;
end;
end.

