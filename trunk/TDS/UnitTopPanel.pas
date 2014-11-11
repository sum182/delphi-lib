unit UnitTopPanel;

interface

uses
  SysUtils, Classes, Controls, ExtCtrls;

type
  TTopPanel_TQ = class(TPanel)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published

    //OVERRIDE --> SOBRESCREVENDO O METODO DO ANCESTOR 
    constructor Create(Aowner:TComponent);override;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Tds', [TTopPanel_TQ]);
end;

{ TTopPanel_TQ }

constructor TTopPanel_TQ.Create(Aowner: TComponent);
begin
  inherited;
  Align := alTop;

end;

end.
