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
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    fAllowCloseForm : Boolean;
  end;

var
  frmBaseToolBar: TfrmBaseToolBar;

implementation

{$R *.fmx}

procedure TfrmBaseToolBar.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  CanClose := fAllowCloseForm;
end;

procedure TfrmBaseToolBar.FormCreate(Sender: TObject);
begin
  inherited;
  fAllowCloseForm:= False;
end;

procedure TfrmBaseToolBar.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  if Key = vkHardwareBack then
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
