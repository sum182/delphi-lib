unit UnitXmlExport;

interface

uses
  SysUtils, Classes,Db,DbClient,Provider;

type
  TXmlExport = class(TComponent)
  private
    FdataSet: TDataSet;
    FClientDataSet:TClientDataSet;
    FProvider:TDataSetProvider;
    FArquivo: String;
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    procedure ExportFile;


  published
    property Arquivo:String read FArquivo write FArquivo;
    property Dataset:TDataSet read FdataSet write FDataSet;
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Tds', [TXmlExport]);
end;

{ TXmlExport }

procedure TXmlExport.ExportFile;
begin

  try
     FClientDataSet    := TClientDataSet.Create(nil);
     FProvider         := TDataSetProvider.Create(nil);
     FProvider.DataSet := Dataset;
     FClientDataSet.SetProvider(FProvider);
     FClientDataSet.Active := True;

     if Arquivo = '' then
       raise Exception.Create('Arquivo não foi informado...verifique!')
     else
       FClientDataSet.SaveToFile(arquivo,dfXMLUTF8);
  finally
    FreeAndNil(FClientDataSet);
    FreeAndNil(FProvider);
  end;

end;

end.
