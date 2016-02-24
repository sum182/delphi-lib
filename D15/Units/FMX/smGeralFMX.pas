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


unit smGeralFMX;


interface

uses
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Objects, FMX.Controls.Presentation, FMX.Edit, FMX.Layouts, smCrypt, FMX.ListBox,
  FMX.TabControl,FMX.VirtualKeyboard,FMX.Platform,System.UITypes,System.Classes,System.StrUtils;

  function IsSysOSAndroid:Boolean;
  function IsSysOSWindows:Boolean;
  function IsSysOSiOS:Boolean;
  procedure KeyboardHide;
  procedure SetCursorWait(Form:TForm;CursorService: IFMXCursorService);
  procedure SetCursor(ACursor: TCursor);
  function ValidarEMail(Email: string): Boolean;
  function SomenteNumero(Valor: String): String;
  procedure OnEnterFields(Form:TForm;var Key: Word; var KeyChar: System.WideChar; Shift: TShiftState);
  function ValidCPF(CPF: string): boolean;


implementation

uses
  System.SysUtils;



function IsSysOSAndroid:Boolean;
begin
  Result:=False;
  {$IF DEFINED(ANDROID)}
  Result:=True;
  {$ENDIF}
end;

function IsSysOSWindows:Boolean;
begin
  Result:=False;
  {$IF DEFINED(MSWINDOWS)}
  Result:=True;
  {$ENDIF}
end;

function IsSysOSiOS:Boolean;
begin
  Result:=False;
  {$IF DEFINED(iOS)}
  Result:=True;
  {$ENDIF}
end;

procedure KeyboardHide;
var
  Keyboard: IFMXVirtualKeyboardService;
begin
    if TPlatformServices.Current.SupportsPlatformService
      (IFMXVirtualKeyboardService, Keyboard) then
    begin
      Keyboard.HideVirtualKeyboard;
    end;

end;

procedure SetCursorWait(Form:TForm;CursorService: IFMXCursorService);
begin
  //esta rotina não foi devidamente testada
  if TPlatformServices.Current.SupportsPlatformService(IFMXCursorService) then
    CursorService := TPlatformServices.Current.GetPlatformService(IFMXCursorService) as IFMXCursorService;

  if Assigned(CursorService) then
  begin
    Form.Cursor := CursorService.GetCursor;
    CursorService.SetCursor(crHourGlass);
  end;
end;

procedure SetCursor(ACursor: TCursor);
var
  CS: IFMXCursorService;
begin
  //esta rotina não foi devidamente testada
  if TPlatformServices.Current.SupportsPlatformService(IFMXCursorService) then
  begin
    CS := TPlatformServices.Current.GetPlatformService(IFMXCursorService) as IFMXCursorService;
  end;
  if Assigned(CS) then
  begin
    CS.SetCursor(ACursor);
  end;
end;


function ValidarEMail(Email: string): Boolean;
begin
 Email := Trim(UpperCase(Email));

 if Pos('@', Email) > 1 then
 begin
   Delete(Email, 1, pos('@', Email));
   Result := (Length(Email) > 0) and (Pos('.', Email) > 2);
 end
 else
   Result := False;
end;

function SomenteNumero(Valor: String): String;
var
  I : Byte;
begin
   Result := '';
   for I := 0 To Length(Valor) do
       if Valor [I] In ['0'..'9'] Then
            Result := Result + Valor [I];
end;

procedure OnEnterFields(Form:TForm;var Key: Word; var KeyChar: System.WideChar; Shift: TShiftState);
begin
  if Key = vkReturn then
  begin
    KeyboardHide;
    Key := vkTab;
    Form.KeyDown(Key, KeyChar, Shift);
   end;
end;

function ValidCPF(CPF: string): boolean;
var
  d1, d4, xx, nCount, resto, digito1, digito2: Integer;
  Check: string;
begin
  if (CPF = '111.111.111.11') or
    (CPF = '222.222.222.22') or
    (CPF = '333.333.333.33') or
    (CPF = '444.444.444.44') or
    (CPF = '555.555.555.55') or
    (CPF = '666.666.666.66') or
    (CPF = '777.777.777.77') or
    (CPF = '888.888.888.88') or
    (CPF = '999.999.999.99') then
  begin
    Result := False;
    Exit;
  end;

  d1 := 0;
  d4 := 0;
  xx := 1;
  for nCount := 1 to Length(CPF) - 2 do
  begin
    if Pos(Copy(CPF, nCount, 1), '/-.') = 0 then
    begin
      d1 := d1 + (11 - xx) * StrToInt(Copy(CPF, nCount, 1));
      d4 := d4 + (12 - xx) * StrToInt(Copy(CPF, nCount, 1));
      xx := xx + 1;
    end;
  end;
  resto := (d1 mod 11);
  if resto < 2 then
    digito1 := 0
  else
    digito1 := 11 - resto;
  d4 := d4 + 2 * digito1;
  resto := (d4 mod 11);
  if resto < 2 then
    digito2 := 0
  else
    digito2 := 11 - resto;
  Check := IntToStr(Digito1) + IntToStr(Digito2);
  if Check <> RightStr(CPF, 2) then
    Result := False
  else
    Result := True;
end;


end.
