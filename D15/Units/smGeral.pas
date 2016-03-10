{*******************************************************}
{                                                       }
{                 Sum182 Component Library              }
{                                                       }
{  Copyright (c) 2001-2016 Sum182 Software Corporation  }
{                                                       }
{                 Tel.:  55 11 98214-7819               }
{                                                       }
{                 Email: sum182@gmail.com               }
{*******************************************************}

unit smGeral;

interface

uses
  Classes,
  Dialogs, ComCtrls, StdCtrls, Buttons, Grids, DBGrids, DB,
  Windows, Messages, SysUtils, Variants, Graphics, Controls, Forms,
  DateUtils, ExtCtrls, DBCLIENT, smMensagens, StrUtils, Checklst, TLHelp32,
  FileCtrl, smDBGrid, registry, Menus,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,smStrings;

type
  TBanco = (bdOracle, bdFireBid, bdPervasive, bdPostGre, bdSqlServer, BdMySql);

function VerificarNumero(Expressao: Variant): Boolean;
function VerificarFloat(Expressao: Variant): Boolean;
procedure ValidarCampo(Field: TField);
procedure ValidarCampos(DataSet: TDataSet);
function GetFirstDay(): string;
function GetLastDay(): string;
function GetIdade(DtNasc: TDateTime): Integer;
procedure OpenForm(FrmClass: TFormClass); overload;
procedure Wait(Formulario: TForm; Mensagem: string = ''; milliseconds: Cardinal = 0); overload;
procedure Wait(milliseconds: Cardinal = 0); overload;
procedure WaitRefresh(Formulario: TForm; Mensagem: string = ''; milliseconds: Cardinal = 0);
procedure WaitEnd(Formulario: TForm; milliseconds: Cardinal = 0); overload;
procedure WaitEnd(milliseconds: Cardinal = 0); overload;
function ApplyUpdates(cds: TClientDataSet): Boolean;overload;
function ApplyUpdates(fdq: TFDQuery): Boolean;overload;
function ApplyUpdates(Schema: TFDSchemaAdapter): Boolean;overload;

procedure ToolBarStateButtons(DataSet: TDataSet; btnNew, btnPost, btnCancel, btnEdit, btnDelete: TToolButton);
procedure ToolBarStateButtonsDetails(DataSetMaster, DatasetDetails: TDataSet; btnNew, btnPost, btnCancel, btnEdit, btnDelete: TToolButton);
procedure DataSetSetFkDetails(DataSetMaster, DataSetDetails: TDataSet; FieldMaster, FieldDetails: TField);
function DecToBin(Valor: Integer): string;
function BinToDec(Value: string): Integer;
procedure TirarFocus(Form: TForm);
function SelectTop(Banco: TBanco; Table: string; Rows: Integer = 1): string;
procedure GravaStream(Stream: TStream; Texto: string);
procedure SetLabelsTransparent(Formulario: TForm);
function GetSOType: string;
procedure ChecklstBoxClear(CheckListBox: TCheckListBox; AddTodos: Boolean = True; CheckedAll: Boolean = True);
procedure ChecklstBoxAddTodos(CheckListBox: TCheckListBox);
procedure ChecklstBoxSelect(Sender: TObject);
procedure ChecklstBoxCheckAll(CheckListBox: TCheckListBox; CheckedAll: Boolean = True);
procedure FillDataSet(ADataSet: TDataSet; Lines: TStrings; TextField: string; KeyField: string = '');
function chlSelected(Campo: string; chl: TCheckListBox): string;
function LerFlag(const Num: Cardinal; const Bit: Byte): Boolean; overload;
procedure GravaFlag(var Num: Integer; const Bit: Byte; Value: Boolean); overload;
procedure GravaFlag(F: TField; const Bit: Byte; Value: Boolean); overload;
procedure GravaFlag(var Num2: Cardinal; const Bit: Byte; Value: Boolean); overload;
function Booleano(FieldBoolean: string): string;
procedure ProcessList(List: TStrings);
function ProcessExecute(Process: string): Boolean;
function DirectorySelect(var Directory: string; Title:
  string = 'Selecione o diretório';
  DirDefault: string = ''): boolean;
function StrBoolean(FieldBoolean: string): boolean;
function InArray(Vetor: array of integer; Valor: integer): Boolean; overload;
function InArray(Vetor: array of string; Valor: string): Boolean; overload;
function IsArrayNull(Vetor: array of integer): Boolean; overload;
function IsArrayNull(Vetor: array of string): Boolean; overload;

procedure AddArray(var Vetor: array of string; Value: string;
  AllowValueDuplicated: boolean = True); overload;

function GetVersion(FileName: string): string;
function KillTask(ExeFileName: string): Integer;
procedure OrdenarDataSetGrid(var CDS: TClientDataSet;
  var DBG: TDBGrid;
  Column: TColumn); overload;
procedure OrdenarDataSetGrid(var CDS: TClientDataSet;
  var DBG: TsmDBGrid;
  Column: TColumn); overload;
function SaveToFile(FilterFiles: string = '';
  DefaultExtFile: string = '';
  DirIni: string = ''): string;
function ValidEmail(email: string): boolean;
function ValidCPF(CPF: string): boolean;
function GetSpace: string;
function GetSpaceQuotedStr: string;
procedure NextFocus(Ctrl: TWinControl);
procedure StatusBarSetBusca(StatusBar: TStatusbar; Registros: integer);
procedure SpoolerImpressaoStart;
procedure SpoolerImpressaoStop;
procedure StartService(Service: string);
procedure StopService(Service: PWideChar);
procedure LockedPenDriver;
procedure UnlockedPenDriver;
function GetSQLFileName:string;
procedure CopyMenuItem(Src, Dest: TMenuItem);
function SomenteNumero(Valor: String): String;
function GetGUID:string;


implementation

uses
  System.TypInfo;

function VerificarNumero(Expressao: Variant): Boolean;
begin
  //Verifica se a expressao e um Numero Inteiro
  if StrToIntDef(Expressao, 0) = 0 then
    Result := False
  else
    Result := True;
end;

function VerificarFloat(Expressao: Variant): Boolean;
begin
  //Verifica se a expressao e um Float
  if StrToFloatDef(Expressao, 0) = 0 then
    Result := False
  else
    Result := True;
end;

procedure ValidarCampo(Field: TField);
var
  nCampo: Integer;
begin
  //Valida os campos obrigatorios
    if (Field.IsNull) then
    begin
      Msg('É obrigatório o preenchimento do campo: ' + Field.DisplayName, mtErro);
      Field.FocusControl;
      Abort;
    end;
end;


procedure ValidarCampos(DataSet: TDataSet);
var
  nCampo: Integer;
begin
  //Valida os campos obrigatorios
  for nCampo := 0 to DataSet.FieldCount - 1 do
    if (DataSet.Fields[nCampo].Required) and ((DataSet.Fields[nCampo].IsNull) or (Trim(DataSet.Fields[nCampo].Value) = '')) then
    begin
      Msg('É obrigatório o preenchimento do campo: ' + DataSet.Fields[nCampo].DisplayLabel, mtErro);
      DataSet.Fields[nCampo].FocusControl;
      Abort;
    end;
end;

function GetFirstDay(): string;
begin
  //Retorna o 1º dia do mes
  Result := DateToStr(StartOfTheMonth(now));
end;

function GetLastDay(): string;
begin
  //Retona o ultimo dia do mes
  Result := DateToStr(EndOfTheMonth(now));
end;

function GetIdade(DtNasc: TDateTime): Integer;
begin
  //Calcula a idade
  Result := 0;
  if YearOf(DtNasc) < 1900 then
    Exit;
  Result := YearOf(Now) - YearOF(DtNasc);
end;

procedure OpenForm(FrmClass: TFormClass); overload;
begin
  //Abrir um Form
  with FrmClass.Create(nil) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure Wait(Formulario: TForm; Mensagem: string = ''; milliseconds: Cardinal = 0);
var
  pngAguarde: TPanel;
begin
  //Cria uma Mensagem de Aguarde

  WaitEnd(Formulario);
  Mensagem := Mensagem + ' ...';
  Screen.Cursor := crHourGlass;
  pngAguarde := TPanel.Create(Formulario);
  with pngAguarde do
  begin
    Width := Length(Mensagem) * 9;
    Left := (Formulario.Width - Width) div 2;
    Top := (Formulario.Height - Height) div 2;
    Name := 'pngAguarde';
    Parent := formulario;
    Caption := Mensagem;
    Height := 59;
    BorderStyle := bsSingle;
    Color := $00DEDCBE;
    Color := clSkyBlue;
    Font.Charset := DEFAULT_CHARSET;
    Font.Color := clWindowText;
    Font.Height := -11;
    Font.Name := 'Tahoma';
    Font.Size := 10;
    Font.Style := [fsBold];
    ParentFont := False;
    ParentColor := False;
    ParentBackground := False;
    Application.ProcessMessages;
  end;
  sleep(milliSeconds);
end;

procedure Wait(milliseconds: Cardinal = 0);
begin
  //Cursor de Aguarde
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  Sleep(milliSeconds);
end;

procedure WaitEnd(Formulario: TForm; milliseconds: Cardinal = 0);
var
  I: Integer;
begin
  //Finaliza a tela de aguarde
  //pequena gambirra pra nao gerar excecao
  try
    if not (Assigned(Formulario)) then
      Exit;

    try
      Application.ProcessMessages;
      for i := 0 to formulario.ComponentCount - 1 do
        if (formulario.Components[i] is TPanel) then
          if ((formulario.Components[i] as TPanel).Name = 'pngAguarde')
            and (Assigned((formulario.Components[i] as TPanel))) then
            (formulario.Components[i] as TPanel).Destroy;
    finally
      WaitEnd;
    end;
  except
  end;
end;

procedure WaitEnd(milliseconds: Cardinal = 0);
begin
  Screen.Cursor := crDefault;
  Application.ProcessMessages;
  Sleep(milliSeconds);
end;

procedure WaitRefresh(Formulario: TForm; Mensagem: string = ''; milliseconds: Cardinal = 0);
var
  pngAguarde: TPanel;
  I: Integer;
begin
  //Atualiza a tela de aguarde
  //este codigo esta com uma pequena gambiarra no try except
  try
    if Formulario = nil then
      Exit;
    try
      Mensagem := Mensagem + ' ...';
      Screen.Cursor := crHourGlass;

      Application.ProcessMessages;
      for i := 0 to formulario.ComponentCount - 1 do
        if (formulario.Components[i] is TPanel) then
          if (formulario.Components[i] as TPanel).Name = 'pngAguarde' then
          begin
            pngAguarde := (formulario.Components[i] as TPanel);
            with pngAguarde do
            begin
              Width := Length(Mensagem) * 9;
              Left := (Formulario.Width - Width) div 2;
              Top := (Formulario.Height - Height) div 2;
              Name := 'pngAguarde';
              Parent := formulario;
              Caption := Mensagem;
              Height := 59;
              BorderStyle := bsSingle;
              Color := $00DEDCBE;
              Color := clSkyBlue;
              Font.Charset := DEFAULT_CHARSET;
              Font.Color := clWindowText;
              Font.Height := -11;
              Font.Name := 'Tahoma';
              Font.Size := 10;
              Font.Style := [fsBold];
              ParentFont := False;
              ParentColor := False;
              ParentBackground := False;
            end;
          end;
    finally
      Application.ProcessMessages;
    end;
  except
  end;
end;

function ApplyUpdates(cds: TClientDataSet): Boolean;
begin
  //Executa o apply updates do ClientDataSet
  Result := True;
  if (cds.ApplyUpdates(0) >= 1) then
  begin
    Msg('Erro no processo de atualização dos dados!', mtErro);
    Result := False;
    Exit;
  end;
end;


function ApplyUpdates(fdq: TFDQuery): Boolean;
begin
  //Executa o apply updates
  Result := True;
  if (fdq.ApplyUpdates(0) >= 1) then
  begin
    Msg('Erro no processo de atualização dos dados!', mtErro);
    Result := False;
    Exit;
  end;
end;

function ApplyUpdates(Schema: TFDSchemaAdapter): Boolean;
begin
  //Executa o apply updates do TFDSchemaAdapter
  Result := True;
  if (Schema.ApplyUpdates(0) >= 1) then
  begin
    Msg('Erro no processo de atualização dos dados!', mtErro);
    Result := False;
    Exit;
  end;
end;

procedure ToolBarStateButtons(DataSet: TDataSet; btnNew, btnPost, btnCancel, btnEdit, btnDelete: TToolButton);
begin
  //seta os botoes da toolbar
  with dataset do
  begin
    btnNew.Enabled := State in [dsBrowse];
    btnPost.Enabled := State in [dsEdit, dsInsert];
    btnCancel.Enabled := State in [dsEdit, dsInsert];
    btnEdit.Enabled := State in [dsBrowse];
    btnDelete.Enabled := State in [dsBrowse];
  end;
end;

procedure ToolBarStateButtonsDetails(DataSetMaster, DatasetDetails: TDataSet; btnNew, btnPost, btnCancel, btnEdit, btnDelete: TToolButton);
begin
  //Seta os botoes da toolba details
  if DataSetMaster.State in [dsEdit, dsInsert] then
    ToolBarStateButtons(DatasetDetails, btnNew, btnPost, btnCancel, btnEdit, btnDelete)
  else
  begin
    btnNew.Enabled := False;
    btnPost.Enabled := False;
    btnCancel.Enabled := False;
    btnEdit.Enabled := False;
    btnDelete.Enabled := False;
  end;
end;

procedure DataSetSetFkDetails(DataSetMaster, DataSetDetails: TDataSet; FieldMaster, FieldDetails: TField);
begin
  //Setar o ID no Master nos Details
  if DataSetMaster.State in [dsInsert] then
  begin
    DataSetDetails.DisableControls;
    with DataSetDetails do
    begin
      First;
      while not eof do
      begin
        Edit;
        FieldDetails.Value := FieldMaster.Value;
        Next;
      end;
    end;
    DataSetDetails.EnableControls;
  end;
end;

function DecToBin(Valor: Integer): string;
var
  S: string;
  i: integer;
  Negative: boolean;
begin
  //Converte Decimal em Binario

  Negative := (valor < 0);

  valor := Abs(valor);
  for i := 1 to SizeOf(valor) * 8 do
  begin
    if valor < 0 then
      S := S + '1'
    else
      S := S + '0';
    valor := valor shl 1;
  end;
  Delete(S, 1, Pos('1', S) - 1);

  if Negative then
    S := '-' + S;
  Result := S;
end;

function BinToDec(Value: string): Integer;
var
  i, Size, Expoente: Integer;
begin
  //converte Binario em Decimal
  // 1 shl 0 1 elavado a zero
  Result := 0;
  Expoente := 0;
  Size := Length(Value);
  for i := Size downto 1 do
  begin
    if Copy(Value, i, 1) = '1' then
    begin
      Result := Result + (1 shl expoente);
    end;
    Inc(Expoente);
  end;
end;

procedure TirarFocus(Form: TForm);
begin
  //Tira o focu de um campo/botao
  with TEdit.Create(Form) do
  begin
    try
      Parent := Form;
      SetFocus;
    finally
      Free;
    end;
  end;
end;

function SelectTop(Banco: TBanco; Table: string; Rows: Integer = 1): string;
var
  Fields, Where: string;
begin
  //traz os primeiros registros de acordo com o tipo de BD

  case Banco of
    bdOracle:
      begin
        Fields := '*';
        Where := 'Where RowNum <= ' + IntToStr(Rows);
      end;

    bdFireBid: Fields := 'First ' + IntToStr(Rows) + ' * ';
    bdPervasive: Fields := 'Top ' + IntToStr(Rows) + ' * ';
    bdPostGre: ;
    bdSqlServer: ;
    BdMySql: ;
  end;

  Fields := ' ' + Fields + ' ';
  Where := ' ' + Where + ' ';
  Table := ' ' + Table + ' ';

  Result := 'select' + Fields + 'from' + Table + Where;
end;

procedure GravaStream(Stream: TStream; Texto: string);
begin
  //Grava uma string num arquivo
  Texto := Texto + #13#10;
  Stream.Write(Texto[1], Length(Texto));
end;

procedure SetLabelsTransparent(Formulario: TForm);
var
  i: Integer;
begin
  //Deixa todas as Labels transparents
  for i := 0 to Formulario.ComponentCount - 1 do
    if (Formulario.Components[i] is Tlabel) then
      (Formulario.Components[i] as TLabel).Transparent := True;
end;

function GetSOType: string;
var
  osv: TOSVersionInfo;
begin
  //Retorna o tipo do sistema operacional

  osv.dwOSVersionInfoSize := sizeof(osv);
  GetVersionEx(osv);
  case osv.dwPlatformId of
    VER_PLATFORM_WIN32_NT: Result := 'Windows XP';
    VER_PLATFORM_WIN32_WINDOWS: Result := 'Windows 98';
  else
    Result := 'Sistema Operacional não enconrado!';
  end;

end;

procedure ChecklstBoxClear(CheckListBox: TCheckListBox; AddTodos: Boolean = True; CheckedAll: Boolean = True);
begin
  //Metodo para Limpar todos os items e adicionar o item Todos num checklistbox

  try
    Wait;
    with CheckListBox do
    begin
      Clear;
      if AddTodos then
        ChecklstBoxAddTodos(CheckListBox);

      if CheckedAll then
        ChecklstBoxCheckAll(CheckListBox);
    end;
  finally
    WaitEnd;
  end;
end;

procedure ChecklstBoxAddTodos(CheckListBox: TCheckListBox);
begin
  //Metodo para adicionar o item Todos num checklistbox
  try
    Wait;
    CheckListBox.Items.Insert(0, 'Todos');
  finally
    WaitEnd;
  end;
end;

procedure ChecklstBoxSelect(Sender: TObject);
var
  i: Integer;
begin
  //Metodo para selecionar todos os item do checklistbox
  //***Chame esta rotina no evento OnClickCheck do CheckListBox

  with TCheckListBox(Sender) do
    if (ItemIndex = 0) then
    begin
      for i := 1 to Items.Count - 1 do
        Checked[i] := Checked[0];
    end
    else
      Checked[0] := False;
end;

procedure ChecklstBoxCheckAll(CheckListBox: TCheckListBox; CheckedAll: Boolean = True);
var
  i: Integer;
begin
  with CheckListBox do
  begin
    for i := 0 to Items.Count - 1 do
      Checked[i] := CheckedAll;
  end;
end;

procedure FillDataSet(ADataSet: TDataSet; Lines: TStrings; TextField: string; KeyField: string);
var
  bm: TBookmark;
  tf, kf: TField;
begin
  if not Assigned(ADataSet) then
    Exit;
  with ADataSet do
  begin
    if not Active then
      Open;
    DisableControls;
    Lines.BeginUpdate;
    bm := GetBookmark;
    tf := FindField(TextField);
    kf := FindField(KeyField);
    First;
    Lines.Clear;
    while not Eof do
    try
      if (kf = nil) then
        Lines.Add(Trim(tf.AsString))
      else
        Lines.AddObject(Trim(tf.AsString), TObject(kf.AsInteger));
    finally
      Next;
    end;
    if (BookmarkValid(bm)) then
    begin
      GotoBookmark(bm);
      FreeBookmark(bm);
    end;
    EnableControls;
    Lines.EndUpdate;
  end;

end;


function chlSelected(Campo: string; chl: TCheckListBox): string;
var
  Total, Check, i: Integer;
  GetChecked: Boolean;
begin
  Check := 0;
  with chl, Items do
    for i := 1 to Count - 1 do
      if Checked[i] then
        Inc(Check);

  Result := '';
  Total := chl.Items.Count - 1;
  GetChecked := Check < (Total div 2);
  if not ((Check = 0) or (Check = Total)) then
    with chl, Items do
      for i := 1 to Count - 1 do
        if not (Checked[i] xor GetChecked) then
          AddCommaStr(Result, IntToStr(Integer(Objects[i])), ',');

  if (Result <> '') then
  begin
    if GetChecked then
      Result := Campo + ' in (' + Result + ')'
    else
      Result := Campo + ' not in (' + Result + ')';
  end
end;

function LerFlag(const Num: Cardinal; const Bit: Byte): Boolean;
begin
  Result := (Num and (1 shl Bit) > 0);
end;

procedure GravaFlag(var Num: Integer; const Bit: Byte; Value: Boolean);
begin
  if Value then
    Num := Num or (1 shl Bit)
  else
    Num := Num and not (1 shl Bit);
end;

procedure GravaFlag(F: TField; const Bit: Byte; Value: Boolean);
begin
  if Value then
    F.AsInteger := F.AsInteger or (1 shl Bit)
  else
    F.AsInteger := F.AsInteger and not (1 shl Bit);
end;

procedure GravaFlag(var Num2: Cardinal; const Bit: Byte; Value: Boolean);
begin
  if Value then
    Num2 := Num2 or (1 shl Bit)
  else
    Num2 := Num2 and not (1 shl Bit);
end;

function Booleano(FieldBoolean: string): string;
begin
  //metodo para retornar Sim ou Nao para campos booleanos
  FieldBoolean := UpperCase(FieldBoolean);
  if (FieldBoolean = 'T') or (FieldBoolean = 'TRUE') or
    (FieldBoolean = 'SIM') or (FieldBoolean = 'S') then
    result := 'Sim'
  else
    result := 'Não';
end;

procedure ProcessList(List: TStrings);
var
  ProcEntry: TProcessEntry32;
  Hnd: THandle;
  Fnd: Boolean;
begin
  //Lista todos os processos em execucao
  List.Clear;
  Hnd := CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0);
  if Hnd <> -1 then
  begin
    ProcEntry.dwSize := SizeOf(TProcessEntry32);
    Fnd := Process32First(Hnd, ProcEntry);
    while Fnd do
    begin
      List.Add(ProcEntry.szExeFile);
      Fnd := Process32Next(Hnd, ProcEntry);
    end;
    CloseHandle(Hnd);
  end;
end;

function ProcessExecute(Process: string): Boolean;
var
  ProcEntry: TProcessEntry32;
  Hnd: THandle;
  Fnd: Boolean;
  Processo: string;
begin
  //Verifica se o processo esta em execucao
  Process := UpperCase(Process);
  Hnd := CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0);
  if Hnd <> -1 then
  begin
    ProcEntry.dwSize := SizeOf(TProcessEntry32);
    Fnd := Process32First(Hnd, ProcEntry);

    while Fnd do
    begin
      Processo := UpperCase(ProcEntry.szExeFile);
      Fnd := Process32Next(Hnd, ProcEntry);
      if (Process = Processo) then
        Break;
    end;
    CloseHandle(Hnd);
    Result := (Process = Processo);
  end;
end;

function DirectorySelect(var Directory: string; Title:
  string = 'Selecione o diretório';
  DirDefault: string = ''): boolean;
begin
  Result := SelectDirectory(Title,
    DirDefault,
    Directory,
    [sdNewUI, sdShowEdit, sdNewFolder],
    nil);
end;

function StrBoolean(FieldBoolean: string): boolean;
begin
  FieldBoolean := Booleano(FieldBoolean);
  Result := (FieldBoolean = 'Sim');
end;

function InArray(Vetor: array of integer; Valor: integer): Boolean; overload;
var
  i: integer;
begin
  Result := False;
  for i := Low(Vetor) to High(Vetor) do
    if (Valor = (Vetor[i])) then
    begin
      Result := True;
      Exit;
    end;
end;

function InArray(Vetor: array of string; Valor: string): Boolean; overload;
var
  i: integer;
begin
  Result := False;
  for i := Low(Vetor) to High(Vetor) do
    if (Valor = (Vetor[i])) then
    begin
      Result := True;
      Exit;
    end;
end;

function IsArrayNull(Vetor: array of integer): Boolean; overload;
var
  i: integer;
begin
  Result := True;
  for i := Low(Vetor) to High(Vetor) do
    if Vetor[i] <> 0 then
    begin
      Result := False;
      Exit;
    end;
end;

function IsArrayNull(Vetor: array of string): Boolean; overload;
var
  i: integer;
begin
  Result := True;
  for i := Low(Vetor) to High(Vetor) do
    if Vetor[i] <> '' then
    begin
      Result := False;
      Exit;
    end;
end;

function GetVersion(FileName: string): string;
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
  V1, V2, V3, V4: Word;
begin
  VerInfoSize := GetFileVersionInfoSize(PChar(FileName), Dummy);
  GetMem(VerInfo, VerInfoSize);
  GetFileVersionInfo(PChar(FileName), 0, VerInfoSize, VerInfo);
  VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
  with VerValue^ do
  begin
    V1 := dwFileVersionMS shr 16;
    V2 := dwFileVersionMS and $FFFF;
    V3 := dwFileVersionLS shr 16;
    V4 := dwFileVersionLS and $FFFF;
  end;
  FreeMem(VerInfo, VerInfoSize);
  result := Copy(IntToStr(100 + v1), 3, 2) + '.' +
    Copy(IntToStr(100 + v2), 3, 2) + '.' +
    Copy(IntToStr(100 + v3), 3, 2) + '.' +
    Copy(IntToStr(100 + v4), 3, 2);
end;

function KillTask(ExeFileName: string): Integer;
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(ExeFileName)) or
      (UpperCase(FProcessEntry32.szExeFile) = UpperCase(ExeFileName))) then
      Result := Integer(TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0),
        FProcessEntry32.th32ProcessID), 0));
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

procedure OrdenarDataSetGrid(var CDS: TClientDataSet;
  var DBG: TDBGrid;
  Column: TColumn); overload;
const
  idxDefault = 'DEFAUT_ORDER';
var
  strColumn: string;
  i: integer;
  bolUsed: boolean;
  idOptions: TIndexOptions;
begin
  strColumn := idxDefault;

  if Column.Field.FieldKind in [fkCalculated, fkLookup, fkAggregate] then
    Exit;

  if Column.Field.DataType in [ftblob, ftMemo] then
    Exit;

  for I := 0 to DBG.Columns.Count - 1 do
  begin
    DBG.Columns[i].Title.Font.Style := [];
  end;

  DBG.Columns[Column.Index].Title.Font.Style := [fsBold];
  bolUsed := (Column.Field.FieldName = CDS.IndexName);

  CDS.IndexDefs.Update;
  for I := 0 to CDS.IndexDefs.Count - 1 do
  begin
    if CDS.IndexDefs.Items[i].Name = Column.Field.FieldName then
    begin
      strColumn := Column.Field.FieldName;
      case (CDS.IndexDefs.Items[i].Options = [ixDescending]) of
        True: idOptions := [];
        False: idOptions := [ixDescending];
      end;
    end;
  end;

  if (strColumn = idxDefault) or (bolUsed) then
  begin
    if bolUsed then
      CDS.DeleteIndex(Column.Field.FieldName);
    try
      CDS.AddIndex(Column.Field.FieldName,
        Column.Field.FieldName,
        idOptions,
        '',
        '',
        0);
      strColumn := Column.Field.FieldName;
    except
      if bolUsed then
        strColumn := idxDefault;
    end;
  end;

  try
    cds.IndexName := strColumn;
  except
    CDS.IndexName := idxDefault;
  end;

end;

procedure OrdenarDataSetGrid(var CDS: TClientDataSet;
  var DBG: TsmDBGrid;
  Column: TColumn); overload;
const
  idxDefault = 'DEFAUT_ORDER';
var
  strColumn: string;
  i: integer;
  bolUsed: boolean;
  idOptions: TIndexOptions;
begin
  strColumn := idxDefault;

  if Column.Field.FieldKind in [fkCalculated, fkLookup, fkAggregate] then
    Exit;

  if Column.Field.DataType in [ftblob, ftMemo] then
    Exit;

  for I := 0 to DBG.Columns.Count - 1 do
  begin
    DBG.Columns[i].Title.Font.Style := [];
  end;

  DBG.Columns[Column.Index].Title.Font.Style := [fsBold];
  bolUsed := (Column.Field.FieldName = CDS.IndexName);

  CDS.IndexDefs.Update;
  for I := 0 to CDS.IndexDefs.Count - 1 do
  begin
    if CDS.IndexDefs.Items[i].Name = Column.Field.FieldName then
    begin
      strColumn := Column.Field.FieldName;
      case (CDS.IndexDefs.Items[i].Options = [ixDescending]) of
        True: idOptions := [];
        False: idOptions := [ixDescending];
      end;
    end;
  end;

  if (strColumn = idxDefault) or (bolUsed) then
  begin
    if bolUsed then
      CDS.DeleteIndex(Column.Field.FieldName);
    try
      CDS.AddIndex(Column.Field.FieldName,
        Column.Field.FieldName,
        idOptions,
        '',
        '',
        0);
      strColumn := Column.Field.FieldName;
    except
      if bolUsed then
        strColumn := idxDefault;
    end;
  end;

  try
    cds.IndexName := strColumn;
  except
    CDS.IndexName := idxDefault;
  end;

end;

procedure AddArray(var Vetor: array of string; Value: string;
  AllowValueDuplicated: boolean = True); overload;
var
  i: integer;
begin
  for I := Low(Vetor) to High(Vetor) do
  begin
    if Vetor[i] = '' then
    begin
      if not (AllowValueDuplicated) then
      begin
        if not (InArray(Vetor, Value)) then
          Vetor[i] := Value
      end
      else
        Vetor[i] := Value;
      Break;
    end;
  end;
end;

function SaveToFile(FilterFiles: string = '';
  DefaultExtFile: string = '';
  DirIni: string = ''): string;
begin

  with TSaveDialog.Create(nil) do
  try
    begin
      if DirIni = '' then
        DirIni := GetCurrentDir;

      InitialDir := DirIni;
      Filter := FilterFiles;
      Options := Options + [ofPathMustExist];
      DefaultExt := DefaultExtFile;
      if Execute then
        Result := FileName;
    end;
  finally
    Free;
  end;
end;

function ValidEmail(email: string): boolean;
const
  // Valid characters in an "atom"
  atom_chars = [#33..#255] - ['(', ')', '<', '>', '@', ',', ';', ':',
    '\', '/', '"', '.', '[', ']', #127];
  // Valid characters in a "quoted-string"
  quoted_string_chars = [#0..#255] - ['"', #13, '\'];
  // Valid characters in a subdomain
  letters = ['A'..'Z', 'a'..'z'];
  letters_digits = ['0'..'9', 'A'..'Z', 'a'..'z'];
  subdomain_chars = ['-', '0'..'9', 'A'..'Z', 'a'..'z'];
type
  States = (STATE_BEGIN, STATE_ATOM, STATE_QTEXT, STATE_QCHAR,
    STATE_QUOTE, STATE_LOCAL_PERIOD, STATE_EXPECTING_SUBDOMAIN,
    STATE_SUBDOMAIN, STATE_HYPHEN);
var
  State: States;
  i, n, subdomains: integer;
  c: char;
begin
  State := STATE_BEGIN;
  n := Length(email);
  i := 1;
  subdomains := 1;
  while (i <= n) do
  begin
    c := email[i];
    case State of
      STATE_BEGIN:
        if c in atom_chars then
          State := STATE_ATOM
        else if c = '"' then
          State := STATE_QTEXT
        else
          break;
      STATE_ATOM:
        if c = '@' then
          State := STATE_EXPECTING_SUBDOMAIN
        else if c = '.' then
          State := STATE_LOCAL_PERIOD
        else if not (c in atom_chars) then
          break;
      STATE_QTEXT:
        if c = '\' then
          State := STATE_QCHAR
        else if c = '"' then
          State := STATE_QUOTE
        else if not (c in quoted_string_chars) then
          break;
      STATE_QCHAR:
        State := STATE_QTEXT;
      STATE_QUOTE:
        if c = '@' then
          State := STATE_EXPECTING_SUBDOMAIN
        else if c = '.' then
          State := STATE_LOCAL_PERIOD
        else
          break;
      STATE_LOCAL_PERIOD:
        if c in atom_chars then
          State := STATE_ATOM
        else if c = '"' then
          State := STATE_QTEXT
        else
          break;
      STATE_EXPECTING_SUBDOMAIN:
        if c in letters then
          State := STATE_SUBDOMAIN
        else
          break;
      STATE_SUBDOMAIN:
        if c = '.' then
        begin
          inc(subdomains);
          State := STATE_EXPECTING_SUBDOMAIN
        end
        else if c = '-' then
          State := STATE_HYPHEN
        else if not (c in letters_digits) then
          break;
      STATE_HYPHEN:
        if c in letters_digits then
          State := STATE_SUBDOMAIN
        else if c <> '-' then
          break;
    end;
    inc(i);
  end;
  if i <= n then
    Result := False
  else
    Result := (State = STATE_SUBDOMAIN) and (subdomains >= 2);
end;

function ValidCPF(CPF: string): boolean;
var
  d1, d4, xx, nCount, resto, digito1, digito2: Integer;
  Check: string;
begin
  if (CPF = '111.111.111.11') or
    (CPF = '222.222.222.22') or
    (CPF = '333.333.333.33') or
    (CPF = '444.444.444.44') or
    (CPF = '555.555.555.55') or
    (CPF = '666.666.666.66') or
    (CPF = '777.777.777.77') or
    (CPF = '888.888.888.88') or
    (CPF = '999.999.999.99') then
  begin
    Result := False;
    Exit;
  end;

  d1 := 0;
  d4 := 0;
  xx := 1;
  for nCount := 1 to Length(CPF) - 2 do
  begin
    if Pos(Copy(CPF, nCount, 1), '/-.') = 0 then
    begin
      d1 := d1 + (11 - xx) * StrToInt(Copy(CPF, nCount, 1));
      d4 := d4 + (12 - xx) * StrToInt(Copy(CPF, nCount, 1));
      xx := xx + 1;
    end;
  end;
  resto := (d1 mod 11);
  if resto < 2 then
    digito1 := 0
  else
    digito1 := 11 - resto;
  d4 := d4 + 2 * digito1;
  resto := (d4 mod 11);
  if resto < 2 then
    digito2 := 0
  else
    digito2 := 11 - resto;
  Check := IntToStr(Digito1) + IntToStr(Digito2);
  if Check <> RightStr(CPF, 2) then
    Result := False
  else
    Result := True;
end;

function GetSpace: string;
begin
  Result := ' ';
end;

function GetSpaceQuotedStr: string;
begin
  Result := QuoTedStr(GetSpace);
end;

procedure NextFocus(Ctrl: TWinControl);
begin
  //Implementar Codigo Comentado
  // ActiveControl := nil;
  PostMessage(TWinControl(Ctrl).Handle, WM_SETFOCUS, 0, 0);
  TWinControl(Ctrl).SetFocus;
end;

procedure StatusBarSetBusca(StatusBar: TStatusbar; Registros: integer);
begin
  StatusBar.Panels[0].Text := ' Total de Registros:' +
    IntToStr(Registros);
end;

procedure SpoolerImpressaoStart;
begin
  StartService('Spooler de Impressão');
end;

procedure SpoolerImpressaoStop;
begin
  StopService('Spooler de Impressão');
end;

procedure StartService(Service: string);
begin
//  WinExec(PWideChar('net start ' + '"' + Service + '"'), SW_HIDE);
end;

procedure StopService(Service: PWideChar);
begin
  try
//    WinExec(('net stop ' + '"' + Service + '"'), SW_HIDE);
    Wait(100);
  finally
    WaitEnd;
  end;
end;

procedure UnlockedPenDriver;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.create;
  with Reg do
  begin
    RootKey := HKEY_LOCAL_MACHINE;
    Openkey('SYSTEM\CurrentControlSet\Services\USBSTOR', true);
    WriteInteger('Start', 3);
    CloseKey;
  end;
end;

procedure LockedPenDriver;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.create;
  with Reg do
  begin
    RootKey := HKEY_LOCAL_MACHINE;
    Openkey('SYSTEM\CurrentControlSet\Services\USBSTOR', true);
    WriteInteger('Start', 4);
    CloseKey;
  end;
end;

function GetSQLFileName:string;
var
  Dia: Variant;
  Mes: Variant;
  Hora: Variant;
  Agora: string;
begin
  //PEGANDO O HORA
  Agora := TimeToStr(now);
  Hora := LeftStr(Agora, 2);

  //PEGANDO OS MINUTOS
  Agora := RightStr(Agora, 5);
  Hora := Hora + LeftStr(Agora, 2);

  Mes := MonthOf(now);
  Dia := DayOf(Now);

  //se o mes for menor que 9 colocar um zero na frente do mes
  Mes := VarToStr(Mes);
  if StrToInt(Mes) <= 9 then Mes := '0' + Mes;

  Dia := VarToStr(Dia);
  Hora := VarToStr(Hora);

  CreateDir(GetCurrentDir + '\SQL');

  Result := GetCurrentDir + '\SQL\'
                           + 'SQL' + '_'
                           + Hora
                           + '_'
                           + Dia
                           + Mes
                           + '.sql';
end;
procedure CopyMenuItem(Src, Dest: TMenuItem);
var
  i: Integer;
  Item: TMenuItem;
begin
  Dest.Caption := Src.Caption;
  Dest.Enabled := Src.Enabled;
  Dest.Tag := Src.Tag;
  Dest.Hint := Src.Hint;
  Dest.OnClick := Src.OnClick;

  for i := 0 to Src.Count-1 do
  begin
    Item := TMenuItem.Create(Dest);
    Dest.Add(Item);
    CopyMenuItem(Src.Items[i], Item);
  end;
end;


function SomenteNumero(Valor: String): String;
var
  I : Byte;
begin
   Result := '';
   for I := 1 To Length(Valor) do
       if Valor [I] In ['0'..'9'] Then
            Result := Result + Valor [I];
end;


function GetGUID:string;
var
  UID : TGuid;
begin
  Result := '';
  CreateGUID(UID);
  Result := Copy(GUIDToString(UID), 2, Length(GUIDToString(UID))-2);
end;


end.

