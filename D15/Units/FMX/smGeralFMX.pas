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


implementation



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

procedure SetCursor(ACursor: TCursor);
var
  CS: IFMXCursorService;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXCursorService) then
  begin
    CS := TPlatformServices.Current.GetPlatformService(IFMXCursorService) as IFMXCursorService;
  end;
  if Assigned(CS) then
  begin
    CS.SetCursor(ACursor);
  end;
end;


end.
