unit UnitMascFem;

interface

uses
  SysUtils, Classes, Controls, StdCtrls;

type
  TMascFem_TQ = class(TGroupBox)
  private
    FMasc: TRadioButton;
    FFem : TRadioButton;
    { Private declarations }
  protected
    { Protected declarations }
    procedure CreateWnd;override;
  public
    { Public declarations }
    constructor Create(Aowner:Tcomponent);override;
    destructor Destroy;override;



  published //--> serve para aparecer no Object Inspector

    property Masc:TRadioButton read Fmasc write Fmasc;
    property Fem :TRadioButton read FFem write FFem;

    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Tds', [TMascFem_TQ]);
end;

{ TMascFem_TQ }

constructor TMascFem_TQ.Create(Aowner: Tcomponent);
begin
  inherited;

  FMasc          := TRadioButton.Create(self);
  FMasc.Parent   := Self;
  FMasc.Caption  := 'Masculino';
  Fmasc.Left     := 20;
  Fmasc.Top      := 15;
  Fmasc.Width    := 75;
  //DECLARANDO QUE O RADIO BUTON E UM SUBCOMPONENTE DO GROUP BOX
  FMasc.SetSubComponent(True);

  FFem          := TRadioButton.Create(self);
  FFem.Parent   := Self;
  FFem.Caption  := 'Feminino';
  FFem.Left     := 20;
  FFem.Top      := 35;
  FFem.Width    := 75;
  FFem.SetSubComponent(True);


end;

procedure TMascFem_TQ.CreateWnd;
begin
  inherited;
  Caption := '';
end;

destructor TMascFem_TQ.Destroy;
begin

  FreeAndNil(FMasc);
  FreeAndNil(FFem);


  inherited;
end;

end.
