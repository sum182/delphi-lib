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

  function IsSysOSAndroid:Boolean;
  function IsSysOSWindows:Boolean;
  function IsSysOSiOS:Boolean;

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

end.
