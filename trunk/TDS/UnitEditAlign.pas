unit UnitEditAlign;

interface

uses
  SysUtils, Classes, Controls, StdCtrls;

type
  TeditAlign = class(TEdit)
  private
    { Private declarations }
  protected
    { Protected declarations }
    procedure Createparams(var params:TCreateParams);override;
  public
    { Public declarations }
  published
    { Published declarations }
  end;

procedure Register;

implementation

uses
  Windows;

procedure Register;
begin
  RegisterComponents('Tds', [TeditAlign]);
end;

{ TeditAlign }

procedure TeditAlign.Createparams(var params: TCreateParams);
begin
  inherited;

  CreateParams(params);
  params.Style := params.Style + es_right
end;

end.
