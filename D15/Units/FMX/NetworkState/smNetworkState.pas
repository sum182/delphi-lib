unit smNetworkState;

interface

  function CurrentSSID: string;
  function IsConnected: Boolean;
  function IsWifiConnected: Boolean;
  function IsMobileConnected: Boolean;


implementation

uses
  NetworkState;

function CurrentSSID: string;
{$IFDEF ANDROID or IOS}
var
  NS: TNetworkState;
{$ENDIF}
begin
  {$IFDEF ANDROID or IOS}
  NS := TNetworkState.Create;
  try
    Result := NS.CurrentSSID;
  finally
    NS.Free;
  end;
  {$ENDIF}
end;

function IsConnected: Boolean;
{$IFDEF ANDROID or IOS}
var
  NS: TNetworkState;
{$ENDIF}
begin
  {$IFDEF ANDROID or IOS}
  NS := TNetworkState.Create;
  try
    Result := NS.IsConnected;
  finally
    NS.Free;
  end;
  {$ENDIF}
end;

function IsWifiConnected: Boolean;
{$IFDEF ANDROID or IOS}
var
  NS: TNetworkState;
{$ENDIF}
begin
  {$IFDEF ANDROID or IOS}
  NS := TNetworkState.Create;
  try
    Result := NS.IsWifiConnected;
  finally
    NS.Free;
  end;
  {$ENDIF}
end;

function IsMobileConnected: Boolean;
{$IFDEF ANDROID or IOS}
var
  NS: TNetworkState;
{$ENDIF}
begin
  {$IFDEF ANDROID or IOS}
  NS := TNetworkState.Create;
  try
    Result := NS.IsMobileConnected;
  finally
    NS.Free;
  end;
  {$ENDIF}
end;






end.
