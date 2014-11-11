unit UnitHiperLabel;

interface

uses
  SysUtils, Classes, Controls, StdCtrls,Forms,Graphics,Messages,ShellAPi,Windows;

type
  THiperLabel_TQ = class(TLabel)
  private
    { Private declarations }
  protected
    { Protected declarations }

    Procedure CMMouseEnter(var Msg:TMessage);message Cm_MouseEnter;
    procedure CMMouseLeave(var Msg:TMessage);message CM_MouseLeave;
  public
    { Public declarations }
    constructor Create(AOwner:TComponent);override;
    procedure Click;override;
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Tds', [THiperLabel_TQ]);
end;

{ THiperLabel_TQ }

procedure THiperLabel_TQ.Click;
begin
  inherited;
  ShellExecute(Application.Handle,nil,Pchar(caption),nil,nil,sw_ShowNormal);
end;

procedure THiperLabel_TQ.CMMouseEnter(var Msg: TMessage);
begin

  //EVENTO QDO O MOUSE ENTRA


  //PEGA QUALQUER METODO DA CLASSE ANCESTRAL SENDO QUE TENHA O MESMO TIPO DE PARAMETROS
  inherited;
  Font.Style   :=  Font.Style + [fsUnderline];
  Font.Color   :=  clBlue;



end;

procedure THiperLabel_TQ.CMMouseLeave(var Msg: TMessage);
begin
  //EVENTO QDO O MOUSE SAI

  Font.Style   :=  Font.Style - [fsUnderline];
  Font.Color   :=  clBlack;
  inherited;
end;

constructor THiperLabel_TQ.Create(AOwner: TComponent);
begin
  inherited;
  Cursor := crHandPoint;
end;

end.
