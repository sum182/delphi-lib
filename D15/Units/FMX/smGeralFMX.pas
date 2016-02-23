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
  FMX.TabControl,FMX.VirtualKeyboard,FMX.Platform,System.UITypes;

  function IsSysOSAndroid:Boolean;
  function IsSysOSWindows:Boolean;
  function IsSysOSiOS:Boolean;
  procedure KeyboardHide;
  procedure SetCursorWait(Form:TForm;CursorService: IFMXCursorService);
  procedure SetCursor(ACursor: TCursor);
  function ValidarEMail(Email: string): Boolean;
  function SomenteNumero(Valor: String): String;


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

end.
