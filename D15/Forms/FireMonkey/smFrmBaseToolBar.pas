unit smFrmBaseToolBar;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  smFrmBase, FMX.Controls.Presentation, FMX.Layouts;

type
  TfrmBaseToolBar = class(TfrmBase)
    ToolBar1: TToolBar;
    lblTitulo: TLabel;
    layToolBarMenu: TLayout;
    btnVoltar: TSpeedButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBaseToolBar: TfrmBaseToolBar;

implementation

{$R *.fmx}

end.
