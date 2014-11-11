unit UnitNoCapPanel;

interface

uses
  SysUtils, Classes, Controls, ExtCtrls;

type
  TNOCapPanel_tq = class(TPanel)
  private
    { Private declarations }
  protected
    { Protected declarations }
    procedure CreateWnd;override;
  public
    { Public declarations }

    constructor Create(AOwner:TComponent);override;

  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Tds', [TNOCapPanel_tq]);
end;

{ TNOCapPanel_tq }

constructor TNOCapPanel_tq.Create(AOwner: TComponent);
begin
  inherited;
  //NAO FUNCIONA POIS NAS CLASSES ANCESTRAIS NAO E PERMITIDO UM COMPONENTE COM NOME NULLO
  Caption := '';
end;

procedure TNOCapPanel_tq.CreateWnd;
begin
  inherited;
  Caption := '';
end;

end.
