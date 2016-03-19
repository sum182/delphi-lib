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
  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  frmBase: TfrmBase;

implementation

{$R *.fmx}

uses smGeralFMX;

end.



