unit UnitColorEdit;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, Graphics;

type
  TTipoVal = (Tdata,tHora,Tnumero,tString);
  TColorEdit_TQ = class(TEdit)


  private
    FCorFoco,FCorAntiga: TColor;
    FTipoVal:TTipoVal;
    { Private declarations }


  protected
    { Protected declarations }
    procedure DoEnter;override;
    procedure DoExit;override;


  public
    { Public declarations }
    constructor Create (Aowner:TComponent);override;



  published
    { Published declarations }
    property CorDeFoco:TColor read FCorFoco Write FCorFoco;
    property TipoDado :TTipoVal read FTipoVal Write FTipoVal;

  end;

procedure Register;

implementation

uses
  Dialogs;

procedure Register;
begin
  RegisterComponents('Tds', [TColorEdit_TQ]);
end;

{ TColorEdit_TQ }

constructor TColorEdit_TQ.Create(Aowner: TComponent);
begin
  inherited;

end;

procedure TColorEdit_TQ.DoEnter;
begin
  inherited;
  FCorAntiga := Color;
  Color      := CorDeFoco;
end;

procedure TColorEdit_TQ.DoExit;
begin
  inherited;
  color := FCorAntiga;

  if Text = '' then
    exit
  ;



  try

     case TipoDado of
       Tdata:StrToDate(Text) ;
       tHora:StrToTime(Text) ;
       Tnumero:StrToFloat(Text) ;
       tString: ;
     end;

  except

    on EConvertError do
     begin
       ShowMessage('Tipo Incorreto!');
       SetFocus;
     end;

  end;

end;

end.
