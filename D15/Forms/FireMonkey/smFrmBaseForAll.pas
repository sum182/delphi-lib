unit smFrmBaseForAll;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs;

type
  TfrmBaseForAll = class(TForm)
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
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
  frmBaseForAll: TfrmBaseForAll;

implementation

{$R *.fmx}

uses smGeralFMX;

procedure TfrmBaseForAll.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := fAllowCloseForm;
end;

procedure TfrmBaseForAll.FormCreate(Sender: TObject);
begin
  fAllowCloseForm:= False;
end;

procedure TfrmBaseForAll.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if (Key = vkHardwareBack) and (KeyboradShowing) then
  begin
    KeyboardHide;
    Key := 0;
  end;
end;

end.
