unit unTemplates;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ImgList, DB, ADODB, Grids, DBGrids, StdCtrls;

type
  TfrmTemplates = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    tbDetails: TADODataSet;
    dsDetails: TDataSource;
    imgEnabled: TImageList;
    imgDisabled: TImageList;
    grbxDetails: TGroupBox;
    ToolBar3: TToolBar;
    btnNew: TToolButton;
    btnPost: TToolButton;
    btnCancel: TToolButton;
    btnEdit: TToolButton;
    btnDelete: TToolButton;
    DBGrid1: TDBGrid;
    ToolButton5: TToolButton;
    procedure dsDetailsDataChange(Sender: TObject; Field: TField);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnPostClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTemplates: TfrmTemplates;

implementation

uses
  smGeral;

{$R *.dfm}

procedure TfrmTemplates.btnCancelClick(Sender: TObject);
begin
   tbDetails.Cancel;
end;

procedure TfrmTemplates.btnDeleteClick(Sender: TObject);
begin
   tbDetails.Delete;
end;

procedure TfrmTemplates.btnEditClick(Sender: TObject);
begin
   tbDetails.Edit;
end;

procedure TfrmTemplates.btnNewClick(Sender: TObject);
begin
  tbDetails.Insert;
end;

procedure TfrmTemplates.btnPostClick(Sender: TObject);
begin
   tbDetails.Post;
end;

procedure TfrmTemplates.dsDetailsDataChange(Sender: TObject; Field: TField);
begin
  ToolBarStateButtons(tbDetails,btnNew,btnPost,btnCancel,btnEdit,btnDelete);
end;

end.
