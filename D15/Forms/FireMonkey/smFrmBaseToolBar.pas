unit smFrmBaseToolBar;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  smFrmBase, FMX.Controls.Presentation, FMX.Layouts, FMX.Objects,
  FGX.VirtualKeyboard;

type
  TfrmBaseToolBar = class(TfrmBase)
    ToolBar1: TToolBar;
    lblTitulo: TLabel;
    layToolBarVoltar: TLayout;
    btnVoltar: TSpeedButton;
    imgVoltar: TImage;
    procedure imgVoltarClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  frmBaseToolBar: TfrmBaseToolBar;

implementation

{$R *.fmx}

uses smGeralFMX;

procedure TfrmBaseToolBar.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  if (Key = vkHardwareBack) and not (KeyboradShowing) then
  begin
    Key := 0;
    btnVoltar.OnClick(self);
  end;
end;

procedure TfrmBaseToolBar.imgVoltarClick(Sender: TObject);
begin
  inherited;
  btnVoltar.OnClick(self);
end;

end.
