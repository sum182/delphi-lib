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


unit smMensagensFMX;


interface

uses
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Objects, FMX.Controls.Presentation, FMX.Edit, FMX.Layouts, smCrypt, FMX.ListBox,
  FMX.TabControl,FMX.VirtualKeyboard,FMX.Platform,System.UITypes,System.Classes,System.StrUtils;

  procedure MsgPoupUp(Mensagem:String);


implementation

uses
  smGeralFMX,FGX.Toasts;

procedure MsgPoupUp(Mensagem:String);
begin
  if IsSysOSAndroid then
    TfgToast.Show(Mensagem, TfgToastDuration.Short);

  if IsSysOSWindows then
    ShowMessage(Mensagem);

  if IsSysOSiOS then
    ShowMessage(Mensagem);
end;

end.
