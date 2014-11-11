unit UExportCompEditor;

interface

  Uses DesignEditors,DesignIntf,UnitXmlExport;

  Type
    TExportComponentEditor = class(TComponentEditor)

    //RECUPERA O NUMERO DE ITENS ADICIONADOS NO MENU LOCAL
    function GetVerbCount:integer;override;


    //RETORNA A STRING REFERENTE AO INDICE INFORMADO QUE DEVE APARECER NO MENU LOCAL
    function GetVerb(Index:integer):string;override;

    //RECEBE O INDICE DO MENU LOCAL E EXECUTA O PROCEDIMENTO
    procedure ExecuteVerb(index:Integer);override;

    end;

    Procedure Register;
implementation


procedure Register;
begin
    RegisterComponentEditor(TxmlExport,TExportComponentEditor);
end;
{ TExportComponentEditor }

procedure TExportComponentEditor.ExecuteVerb(index: Integer);
begin

  //Executando o evento de acordo com o indice selecionado
  inherited;
  case Index of
  0: (Component as TXmlExport).ExportFile;
  end;


end;

function TExportComponentEditor.GetVerb(Index: integer): string;
begin

  //Dando o nome aos itens do menu
  Result := '';
  case Index of
    0: Result := 'Export To XML';
  end;

end;

function TExportComponentEditor.GetVerbCount: integer;
begin

  //LISTANDO QTOS ITENS TERA O MENU
  Result:= 1;
end;

end.
