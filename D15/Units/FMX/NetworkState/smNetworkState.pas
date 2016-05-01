unit smNetworkState;

interface

  function CurrentSSID: string;
  function IsConnected: Boolean;
  function IsWifiConnected: Boolean;
  function IsMobileConnected: Boolean;
  function ValidarConexao: Boolean;


implementation

uses
  NetworkState, smMensagensFMX;

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
    NS.DisposeOf;
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
    NS.DisposeOf;
  end;
  {$ENDIF}

  {$IF DEFINED(MSWINDOWS)}
    Result:= True;
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
    NS.DisposeOf;
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
    NS.DisposeOf;
  end;
  {$ENDIF}
end;


function ValidarConexao: Boolean;
begin
  Result:=IsConnected;
  if not IsConnected then
    MsgPoupUp('Verifique sua conexão de dados');
end;






end.
