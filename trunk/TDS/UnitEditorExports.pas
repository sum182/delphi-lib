unit UnitEditorExports;

interface

  uses  Sysutils,Forms,unitXMLExport,DesignIntf,DesignEditors,DesignMenus,DesignConst,DesignWindows,
        Dialogs;
  type
    TExportProperty = class(TStringProperty)

    public
      function GetAttributes:TPropertyAttributes;override;
      procedure Edit;override;
    end;

    //Este comando e sensitive case pois trabalha com baixo nivel-->Register cai na prova
    procedure Register;

implementation



procedure Register;
begin
  RegisterPropertyEditor(TypeInfo(string),TXmlExport,'Arquivo',TExportProperty);
end;


{ TExportProperty }

procedure TExportProperty.Edit;
var SaveDialog:TSaveDialog;
begin
  inherited;
  Try
    SaveDialog := TSaveDialog.Create(nil);
    SaveDialog.DefaultExt := 'XML';
    SaveDialog.FileName := GetValue;
    SaveDialog.Filter := 'XML Files (*.xml)|*.xml|';

    if SaveDialog.Execute then
      SetValue(SaveDialog.FileName);
  Finally
    FreeAndNil(SaveDialog);
  End;


end;

function TExportProperty.GetAttributes: TPropertyAttributes;
begin

   //paDialog --> tres pontos ... 
   Result := inherited GetAttributes + [paDialog];

end;

end.
