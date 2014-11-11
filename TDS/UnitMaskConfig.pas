unit UnitMaskConfig;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, Mask;

type
  TTipo =(Cnpj,CPF,Data,Hora);
  TMaskConfig = class(TMaskEdit)

  private
    FTipo: TTipo;
    procedure SetFtipo(const Value: TTipo);
    { Private declarations }
  protected
    { Protected declarations }

  public
    { Public declarations }
     constructor Create (Aowner:TComponent);override;
  published
    { Published declarations }
    property Maskara:TTipo read FTipo write SetFtipo;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Tds', [TMaskConfig]);
end;

{ TMaskConfig }

constructor TMaskConfig.Create(Aowner: TComponent);
begin
  inherited;

end;

procedure TMaskConfig.SetFtipo(const Value: TTipo);
begin
  FTipo := Value;
  case FTipo of
   Cnpj:  EditMask := '##.###.###/####-##';
   CPF:   EditMask := '###.###.###-##';
   Data:  EditMask :='##/##/####';
   Hora:  EditMask :='##:##';

  end;

end;

end.
