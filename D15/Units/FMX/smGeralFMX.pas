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
  FMX.TabControl,FMX.VirtualKeyboard,FMX.Platform,System.UITypes,System.Classes,System.StrUtils



  {$IFDEF ANDROID or IOS}
   ,
   FMX.Helpers.Android,
   Androidapi.JNI.JavaTypes,
   Androidapi.JNI.GraphicsContentViewText,
   Androidapi.JNIBridge,
   Androidapi.JNI.Net,
   Androidapi.JNI.Os,
   Androidapi.Helpers,
   Androidapi.IOUtils,
   Androidapi.JNI.App,
   Androidapi.NativeActivity
  {$ENDIF}


  {$IF DEFINED(MSWINDOWS)}
  ,Winapi.Windows
  {$ENDIF}

  ;


  function IsSysOSAndroid:Boolean;
  function IsSysOSWindows:Boolean;
  function IsSysOSiOS:Boolean;
  procedure KeyboardHide;
  function KeyboradShowing:Boolean;
  procedure KeyboradShow(const AControl: TFmxObject);
  procedure OnEnterFields(Form: TForm;var Key: Word; var KeyChar: System.WideChar; Shift: TShiftState);
  procedure OnClickFields(Form: TForm);


  procedure SetCursorWait(Form:TForm;CursorService: IFMXCursorService);
  procedure SetCursor(ACursor: TCursor);
  function ValidarEMail(Email: string): Boolean;
  function SomenteNumero(Valor: String): String;
  function ValidCPF(CPF: string): boolean;
  function GetGUID:string;
  function GetVersion: string;




implementation

uses
  System.SysUtils, System.Types;



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
  if not(IsSysOSAndroid) or (IsSysOSiOS) then
    Exit;

  if TPlatformServices.Current.SupportsPlatformService
    (IFMXVirtualKeyboardService, Keyboard) then
  begin
    Keyboard.HideVirtualKeyboard;
  end;
end;

procedure KeyboradShow(const AControl: TFmxObject);
var
  Keyboard: IFMXVirtualKeyboardService;
begin
  if not(IsSysOSAndroid) or (IsSysOSiOS) then
    Exit;

  if TPlatformServices.Current.SupportsPlatformService
    (IFMXVirtualKeyboardService, Keyboard) then
  begin
      Keyboard.ShowVirtualKeyboard(AControl);
  end;
end;

function KeyboradShowing:Boolean;
var
  Keyboard: IFMXVirtualKeyboardService;
begin
  if TPlatformServices.Current.SupportsPlatformService
    (IFMXVirtualKeyboardService, Keyboard) then
  begin
    result:= TVirtualKeyBoardState.Visible in Keyboard.GetVirtualKeyBoardState;
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

procedure OnClickFields(Form: TForm);
begin
  if not(IsSysOSAndroid) or (IsSysOSiOS) then
    Exit;

  if not (KeyboradShowing) then
  begin
    KeyboradShow(Form);
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

function GetGUID:string;
var
  UID : TGuid;
begin
  Result := '';
  CreateGUID(UID);
  Result := Copy(GUIDToString(UID), 2, Length(GUIDToString(UID))-2);
end;

function GetVersion: string;
{$IF DEFINED(MSWINDOWS)}
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
  V1, V2, V3, V4: Word;
{$ENDIF}

{$IFDEF ANDROID or IOS}
var
  PackageManager: JPackageManager;
  PackageInfo : JPackageInfo;
{$ENDIF}
begin
  {$IF DEFINED(MSWINDOWS)}
  VerInfoSize := GetFileVersionInfoSize(Pchar(ParamStr(0)), Dummy);
  GetMem(VerInfo, VerInfoSize);
  GetFileVersionInfo(Pchar(ParamStr(0)), 0, VerInfoSize, VerInfo);
  VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
  with VerValue^ do
  begin
    V1 := dwFileVersionMS shr 16;
    V2 := dwFileVersionMS and $FFFF;
    V3 := dwFileVersionLS shr 16;
    V4 := dwFileVersionLS and $FFFF;
  end;
  FreeMem(VerInfo, VerInfoSize);
  Result := Copy(IntToStr(100 + v1), 3, 2) + '.' +
    Copy(IntToStr(100 + v2), 3, 2) + '.' +
    Copy(IntToStr(100 + v3), 3, 2) + '.' +
    Copy(IntToStr(100 + v4), 3, 2);
  {$ENDIF}

  {$IFDEF ANDROID or IOS}
  PackageManager := SharedActivity.getPackageManager;
  PackageInfo := PackageManager.getPackageInfo(SharedActivityContext.getPackageName(), TJPackageManager.JavaClass.GET_ACTIVITIES);
  Result:= JStringToString(PackageInfo.versionName);
  {$ENDIF}
end;





end.
