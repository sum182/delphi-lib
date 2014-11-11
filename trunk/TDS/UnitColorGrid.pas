unit UnitColorGrid;

interface

uses
  SysUtils, Classes, Controls, Grids, DBGrids,Graphics,Types;

type
  TColorGrid_TQ = class(TDBGrid)



  private
    FAlternateColor: TColor;
    procedure SetAlternateColor(const Value: TColor);
    { Private declarations }




  protected
    { Protected declarations }
    procedure DrawColumnCell(const Rect:TRect; DataCol:Integer; Column:TColumn; State:TGridDrawState);override;
  public
    { Public declarations }




  published
    { Published declarations }

          property AlternateColor:TColor read FAlternateColor write SetAlternateColor;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Tds', [TColorGrid_TQ]);
end;

{ TColorGrid_TQ }

procedure TColorGrid_TQ.DrawColumnCell(const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  inherited;

  //verifica se é par  --> odd = impar
  if not odd(DataSource.DataSet.RecNo) then

    //verifica se a linha nao esta selecionada
    if not(gdSelected in State) then
      begin

        //setando a cor da linha
        self.Canvas.Brush.Color := AlternateColor;

        //pinta a celula
        self.Canvas.FillRect(Rect);

        //pinta o texto da coluna
        Self.DefaultDrawDataCell(rect,column.Field,state);
      end;
end;

procedure TColorGrid_TQ.SetAlternateColor(const Value: TColor);
begin
  FAlternateColor := Value;
  self.Refresh;
end;

end.
