unit smFrmBase;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, smFrmBaseForAll,
  FGX.VirtualKeyboard;

type
  TfrmBase = class(TfrmBaseForAll)
    layBase: TLayout;
    fgVirtualKeyboard: TfgVirtualKeyboard;
    procedure fgVirtualKeyboardHide(Sender: TObject; const Bounds: TRect);
    procedure fgVirtualKeyboardShow(Sender: TObject; const Bounds: TRect);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBase: TfrmBase;

implementation

{$R *.fmx}

procedure TfrmBase.fgVirtualKeyboardHide(Sender: TObject; const Bounds: TRect);
begin
  inherited;
  layBase.Align := TAlignLayout.Client;
end;

procedure TfrmBase.fgVirtualKeyboardShow(Sender: TObject; const Bounds: TRect);
begin
  inherited;
  layBase.Align := TAlignLayout.Top;

  if BorderStyle <> TFmxFormBorderStyle.None then
    layBase.Height := Screen.Size.Height - Bounds.Height
  else
    layBase.Height := Screen.Size.Height - Bounds.Height - 20;
end;

end.

