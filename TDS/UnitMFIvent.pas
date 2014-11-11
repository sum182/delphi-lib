unit UnitMFIvent;

interface

uses
  SysUtils, Classes, Controls, StdCtrls;

type
  TMFIvent = class(TGroupBox)


  private
    Fmasc:TradioButton;
    Ffem:TradioButton;

    //USADO PARA EVENTOS SIMPLES
    FONRadioClick: TNotifyEvent;

    function GetFem: Boolean;
    function GetMasc: Boolean;
    procedure SetFem(const Value: Boolean);
    procedure SetMasc(const Value: Boolean);

    { Private declarations }
  protected
    { Protected declarations }
    procedure CreateWnd; override;
    procedure RadioClick(Sender :TObject);virtual;
  public
    { Public declarations }
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;

  published
    { Published declarations }
    property MascChecado:Boolean read GetMasc write SetMasc;
    property FemChecado:Boolean read GetFem write SetFem;
    //EVENTO
    property OnRadioClick:TNotifyEvent read FONRadioClick write FONRadioClick;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Tds', [TMFIvent]);
end;

{ TMFIvent }

constructor TMFIvent.Create(AOwner: TComponent);
begin
  inherited;


  FMasc          := TRadioButton.Create(self);
  FMasc.Parent   := Self;
  FMasc.Caption  := 'Masculino';
  Fmasc.Left     := 20;
  Fmasc.Top      := 15;
  Fmasc.Width    := 75;


  FFem          := TRadioButton.Create(self);
  FFem.Parent   := Self;
  FFem.Caption  := 'Feminino';
  FFem.Left     := 20;
  FFem.Top      := 35;
  FFem.Width    := 75;

  Fmasc.OnClick := RadioClick;
  Ffem.OnClick := RadioClick;

end;

procedure TMFIvent.CreateWnd;
begin
  inherited;
   Caption := '';

end;

destructor TMFIvent.Destroy;
begin
  FreeAndNil(FMasc);
  FreeAndNil(FFem);
  inherited;
end;

function TMFIvent.GetFem: Boolean;
begin
 Result := Ffem.Checked;
end;

function TMFIvent.GetMasc: Boolean;
begin
 Result := Fmasc.Checked;
end;

procedure TMFIvent.RadioClick(Sender: TObject);
begin
  if Assigned(FONRadioClick) then
    FONRadioClick(self)
  ;
end;

procedure TMFIvent.SetFem(const Value: Boolean);
begin
   Ffem.Checked := Value;
end;

procedure TMFIvent.SetMasc(const Value: Boolean);
begin
  Fmasc.Checked := Value;
end;

end.
