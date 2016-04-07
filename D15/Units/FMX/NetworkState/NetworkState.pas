unit NetworkState;

interface

{$IFDEF ANDROID or IOS}
type
  TCustomNetworkState = class(TObject)
    function CurrentSSID: string; virtual; abstract;
    function IsConnected: Boolean; virtual; abstract;
    function IsWifiConnected: Boolean; virtual; abstract;
    function IsMobileConnected: Boolean; virtual; abstract;
  end;

  TNetworkState = class(TCustomNetworkState)
  private
    FPlatformNetworkState: TCustomNetworkState;
  public
    constructor Create;
    destructor Destroy; override;
    function CurrentSSID: string;
    function IsConnected: Boolean; override;
    function IsWifiConnected: Boolean; override;
    function IsMobileConnected: Boolean; override;
  end;
{$ENDIF}

implementation

{$IFDEF IOS}
uses
  NetworkState.iOS;
{$ENDIF}


{$IFDEF ANDROID}
uses
  NetworkState.Android;
{$ENDIF}

{ TNetworkState }

{$IFDEF ANDROID or IOS}
constructor TNetworkState.Create;
begin
  inherited;
  FPlatformNetworkState := TPlatformNetworkState.Create;
end;

destructor TNetworkState.Destroy;
begin
  FPlatformNetworkState.Free;
  inherited;
end;

function TNetworkState.CurrentSSID: string;
begin
  Result := FPlatformNetworkState.CurrentSSID;
end;

function TNetworkState.IsConnected: Boolean;
begin
  Result := FPlatformNetworkState.IsConnected;
end;

function TNetworkState.IsMobileConnected: Boolean;
begin
  Result := FPlatformNetworkState.IsMobileConnected;
end;

function TNetworkState.IsWifiConnected: Boolean;
begin
  Result := FPlatformNetworkState.IsWifiConnected;
end;

{$ENDIF}


end.
