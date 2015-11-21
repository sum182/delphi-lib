{                                                       }
{                 Sum182 Component Library              }
{                                                       }
{  Copyright (c) 2001-2016 Sum182 Software Corporation  }
{                                                       }
{                 Tel.:  55 11 98214-7819               }
{                                                       }
{                 Email: sum182@gmail.com               }
{*******************************************************}

unit smCadChild;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, smCad, ImgList, DBActns, ActnList, smCadPadrao, ComCtrls, Grids,
  DBGrids, smDBGrid, StdCtrls, Buttons, ToolWin, System.Actions;

type
  TfrmCadChild = class(TfrmCad)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCadChild: TfrmCadChild;

implementation

{$R *.dfm}

procedure TfrmCadChild.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  self := nil;
  Action := caFree;
end;

end.
