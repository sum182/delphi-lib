unit smFrmBaseToolBar;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  smFrmBase, FMX.Controls.Presentation, FMX.Layouts, FMX.Objects;

type
  TfrmBaseToolBar = class(TfrmBase)
    ToolBar1: TToolBar;
    lblTitulo: TLabel;
    layToolBarVoltar: TLayout;
    btnVoltar: TSpeedButton;
    imgVoltar: TImage;
    procedure imgVoltarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBaseToolBar: TfrmBaseToolBar;

implementation

{$R *.fmx}

procedure TfrmBaseToolBar.imgVoltarClick(Sender: TObject);
begin
  inherited;
  btnVoltar.OnClick(self);
end;

end.
