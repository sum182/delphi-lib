{                                                       }
{                 Sum182 Component Library              }
{                                                       }
{  Copyright (c) 2001-2016 Sum182 Software Corporation  }
{                                                       }
{                 Tel.:  55 11 98214-7819               }
{                                                       }
{                 Email: sum182@gmail.com               }
{*******************************************************}

unit smCad;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, smCadPadrao, DBActns, ActnList, DB, DBClient,
  Grids, DBGrids, ComCtrls, StdCtrls, Buttons, ToolWin, smMensagens,
  smGeral, ADoDB, ExtCtrls, SqlExpr, FMTBcd, ImgList, smDBGrid, smDB,
  System.Actions;
type
  TfrmCad = class(TForm)
    ToBaCadastro: TToolBar;
    btnLocalizar: TToolButton;
    btnNovo: TToolButton;
    btnSalvar: TToolButton;
    btnCancelar: TToolButton;
    btnAlterar: TToolButton;
    btnExcluir: TToolButton;
    btnImprimir: TToolButton;
    btnLocalizarTodosRegistros: TToolButton;
    PaCoPadrao: TPageControl;
    TaShConsulta: TTabSheet;
    grbxPesquisa: TGroupBox;
    Label1: TLabel;
    LaConteudo: TLabel;
    LaModoPesquisa: TLabel;
    CoBoCampos: TComboBox;
    EdConteudoNum: TEdit;
    EdConteudoTexto: TEdit;
    BuProcessar: TBitBtn;
    EdConteudoReal: TEdit;
    EdConteudoDataInicial: TDateTimePicker;
    TaShCadastro: TTabSheet;
    TaShRelatorio: TTabSheet;
    smCadPadrao: TsmCadPadrao;
    AcLi: TActionList;
    AcLocalizar: TAction;
    AcFirst: TDataSetFirst;
    AcPrior: TDataSetPrior;
    AcNext: TDataSetNext;
    AcLast: TDataSetLast;
    AcApplyUpdate: TAction;
    AcDelete: TAction;
    AcImprimir: TAction;
    AcTodosRegistros: TAction;
    AcNovo: TAction;
    AcEdit: TAction;
    AcCancelar: TAction;
    EdConteudoDataFinal: TDateTimePicker;
    LaDataInicial: TLabel;
    LaDataFinal: TLabel;
    ToolButton1: TToolButton;
    ToolBar1: TToolBar;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    CoBoModoPesquisa: TComboBox;
    imgEnabled: TImageList;
    imgDisabled: TImageList;
    edFocus: TEdit;
    grPesquisa: TsmDBGrid;
    stbrConsulta: TStatusBar;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BuImprimirClick(Sender: TObject);
    procedure CoBoModoPesquisaKeyPress(Sender: TObject; var Key: Char);
    procedure grPesquisaKeyPress(Sender: TObject; var Key: Char);
    procedure grPesquisaDblClick(Sender: TObject);
    procedure AcNextExecute(Sender: TObject);
    procedure AcLastExecute(Sender: TObject);
    procedure AcPriorExecute(Sender: TObject);
    procedure AcFirstExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AcTodosRegistrosExecute(Sender: TObject);
    procedure EdConteudoTextoChange(Sender: TObject);
    procedure EdConteudoRealChange(Sender: TObject);
    procedure EdConteudoDataInicialChange(Sender: TObject);
    procedure EdConteudoNumChange(Sender: TObject);
    procedure EdConteudoTextoKeyPress(Sender: TObject; var Key: Char);
    procedure EdConteudoRealKeyPress(Sender: TObject; var Key: Char);
    procedure EdConteudoDataInicialKeyPress(Sender: TObject; var Key: Char);
    procedure EdConteudoNumKeyPress(Sender: TObject; var Key: Char);
    procedure BuProcessarClick(Sender: TObject);
    procedure CoBoCamposChange(Sender: TObject);
    procedure AcCancelarExecute(Sender: TObject);
    procedure AcEditExecute(Sender: TObject);
    procedure AcNovoExecute(Sender: TObject);
    procedure AcDeleteExecute(Sender: TObject);
    procedure AcApplyUpdateExecute(Sender: TObject);
    procedure AcLocalizarExecute(Sender: TObject);
  private
    { Private declarations }
    procedure GetTable;
    procedure GetcdsCadastro;
    procedure GetDsCadastro;
    procedure SetToolBarDataSource;
    procedure OnEnterPesquisa(Key: Char);
    procedure OnChangeCamposPesquisa(PesquisaInicio: string; const PesquisaFim: string = '');
    procedure SetComponents;
    procedure VerificarClassesDataSet(DataSet: TDataSet);
    function BuscaGetCondicoes: string;
    function BuscaGetSql: string;
    function BuscaGetOrderBy:string;
  public
    function GetForm: TForm;
  protected
    tbCadastro: TDataSet;
    dsCadastro: TDataSource;
    tbTabela: TClientDataSet; //armazena as informacões da tabela
    Tabela: string;
    Joins: string;
    TipoCampoBusca: string;
    CondicaoBusca: string;
    CamposBusca: string;
    ConteudoBusca: string;
//    procedure OpenGeralSql(sql: string);
    procedure ShowTabCadastro; virtual;
    procedure ShowTabRelatorio;
    procedure ShowTabBusca;
    procedure SetBotoes;
    procedure SetToolBarButtonsState(Sender: TObject);
    procedure OpenBuscaSql(sql: string);
  end;

  //Classe dos Fields da Busca
  TFieldsBusca = class(TObject)
  private
    FForm: TfrmCad;
    procedure ClearObjects;
    procedure SetCombo(Item: Integer);
    procedure SetsqlFields(Item: Integer);
    procedure SetGrid(Item: Integer);

  public
    property Form: TfrmCad read FForm;
    procedure SetForm(AForm: TfrmCad);
    procedure SetFields();
    function GetField(DisplayName: string): TFieldsBuscaItem;

  end;
var
  frmCad: TfrmCad;
  FieldsBusca: TFieldsBusca;
  Field: TFieldsBuscaItem;

implementation



{$R *.dfm}

{ TfrmCad }

procedure TfrmCad.AcApplyUpdateExecute(Sender: TObject);
begin
  inherited;
  try
    Wait(self, 'Salvando Informações');
    sleep(520);
    edFocus.SetFocus;
    ValidarCampos(tbCadastro);
    tbCadastro.Post;
    if (smCadPadrao.DataSourceCadastro.DataSet is TClientDataSet) then
      ApplyUpdates((smCadPadrao.DataSourceCadastro.DataSet as TClientDataSet));
    AcLocalizarExecute(self);
  finally
    WaitEnd(self);
  end;
end;

procedure TfrmCad.AcCancelarExecute(Sender: TObject);
begin
  inherited;
  try
    Screen.Cursor := crSQLWait;
    tbCadastro.Cancel;
    OpenDataSet(tbCadastro);
    AcLocalizarExecute(self);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmCad.AcDeleteExecute(Sender: TObject);
begin
  inherited;
  try
    if not (Msg('Deseja Realmente excluir este registro?', mtAviso, Sim_Nao_Cancelar)) then
      Exit;
    Wait(self, 'Deletando Informações');
    sleep(320);
    tbCadastro.Delete;

    if (smCadPadrao.DataSourceCadastro.DataSet is TClientDataSet) then
      ApplyUpdates((smCadPadrao.DataSourceCadastro.DataSet as TClientDataSet));

    AcLocalizarExecute(self);
  finally
    WaitEnd(self);
  end;
end;

procedure TfrmCad.AcEditExecute(Sender: TObject);
begin
  inherited;
  try
    Screen.Cursor := crSQLWait;
    tbCadastro.Edit;
    TaShCadastro.Enabled := True;
    tbCadastro.Fields[0].FocusControl;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmCad.AcFirstExecute(Sender: TObject);
begin
  inherited;
  smCadPadrao.DataSourceBusca.DataSet.First;
end;

procedure TfrmCad.AcLastExecute(Sender: TObject);
begin
  inherited;
  smCadPadrao.DataSourceBusca.DataSet.Last;
end;

procedure TfrmCad.AcLocalizarExecute(Sender: TObject);
begin
  inherited;
  ShowTabBusca;
end;

procedure TfrmCad.AcNextExecute(Sender: TObject);
begin
  inherited;
  smCadPadrao.DataSourceBusca.DataSet.Next;
end;

procedure TfrmCad.AcNovoExecute(Sender: TObject);
begin
  inherited;
  try
    Screen.Cursor := crSQLWait;
    try
      PaCoPadrao.ActivePageIndex := 1;
      with tbCadastro do
      begin
        OpenDataSet(tbCadastro);
        Append;
        TaShCadastro.Enabled := True;
        tbCadastro.Fields[0].FocusControl;
      end;
    except on E: Exception do
      begin
        Msg('Não foi possível criar um novo registro' + #13 + E.Message, mtErro);
        OpenDataSet(tbCadastro);
        AcLocalizarExecute(self);
      end;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmCad.AcPriorExecute(Sender: TObject);
begin
  inherited;
  smCadPadrao.DataSourceBusca.DataSet.Prior;
end;

procedure TfrmCad.AcTodosRegistrosExecute(Sender: TObject);
begin
  inherited;
  try
    if not (btnLocalizarTodosRegistros.Enabled) or not (TaShConsulta.Visible) then
      Exit;

    if smCadPadrao.BuscaGetAllMsg then
      if not (Msg('Deseja trazer todos os registros desta tabela?' + #13 +
        'Este processo pode ser demorado!', mtAviso, Sim_Nao_Cancelar)) then
        Exit;

    Wait(Self, 'Carregando Informações');
    OpenBuscaSql('SELECT ' + CamposBusca + ' FROM ' + Tabela + Joins + ' ' + ' WHERE 1=1 ')

  finally
    WaitEnd(self);
    GrPesquisa.SetFocus;
  end;
end;

procedure TfrmCad.BuImprimirClick(Sender: TObject);
begin
  inherited;
  ShowTabRelatorio;
end;

procedure TfrmCad.BuProcessarClick(Sender: TObject);
var
  Field: TFieldsBuscaItem;
  procedure PrepararCondicaoBusca();
  var
    ModoBusca: Integer;
  begin
    { ITEM INDEX DO TIPO DA PESQUISA
    0 --> Exata
    1 --> Meio
    2 --> Inicio
    3 --> Final  }

    Field := (FieldsBusca.GetField(CoBoCampos.Text));

    //Campo da Condicao da Busca
    ModoBusca := CoBoModoPesquisa.ItemIndex;

    //Busca em Campo Data
    if (Field.FieldType in [ftdate, ftDateTime]) then
    begin
      case ModoBusca of
        0: CondicaoBusca := Field.FieldName + ' BETWEEN ' + FormatDateTime('mm/dd/yyyy', EdConteudoDataInicial.Date) + ' AND ' + FormatDateTime('mm/dd/yyyy', EdConteudoDataFinal.Date);
      end;
    end;

    //Busca em campo Texto
    if (Field.FieldType in [ftstring]) then
    begin
      ConteudoBusca := UpperCase(EdConteudoTexto.Text);
      case ModoBusca of
        0: CondicaoBusca := 'UPPER (' + Field.FieldName + ' ) = ' + QuotedStr(ConteudoBusca);
        1: CondicaoBusca := 'UPPER (' + Field.FieldName + ' ) LIKE  ' + QuotedStr('%' + ConteudoBusca + '%');
        2: CondicaoBusca := 'UPPER (' + Field.FieldName + ' ) LIKE  ' + QuotedStr(ConteudoBusca + '%');
        3: CondicaoBusca := 'UPPER (' + Field.FieldName + ' ) LIKE  ' + QuotedStr('%' + ConteudoBusca);
      end;
    end;

    //Busca em Campo Inteiro
    if (Field.FieldType in [ftInteger, ftSmallint]) then
    begin
      ConteudoBusca := EdConteudoNum.Text;
      case ModoBusca of
        0: CondicaoBusca := Field.FieldName + ' =  ' + ConteudoBusca;
        1: CondicaoBusca := Field.FieldName + ' >= ' + ConteudoBusca;
        2: CondicaoBusca := Field.FieldName + ' <= ' + ConteudoBusca;
      end;
    end;

    //Busca em Campo Float
    if (Field.FieldType in [ftFloat]) then
    begin
      ConteudoBusca := (EdConteudoReal.Text);
      case ModoBusca of
        0: CondicaoBusca := Field.FieldName + ' =  ' + ConteudoBusca;
        1: CondicaoBusca := Field.FieldName + ' >= ' + ConteudoBusca;
        2: CondicaoBusca := Field.FieldName + ' <= ' + ConteudoBusca;
      end;
    end;
  end;
begin
  inherited;
  PrepararCondicaoBusca;
  OpenBuscaSql(' SELECT ' + CamposBusca +
    ' FROM ' + Tabela + Joins +
    ' WHERE 1 = 1 ' +
    ' AND ' + CondicaoBusca);
  if smCadPadrao.DataSourceBusca.DataSet.IsEmpty then
    Msg('Não foram encontrados dados para esta pesquisa!');
end;

function TfrmCad.BuscaGetCondicoes: string;
var
  i: Integer;
begin
  for i := 0 to smCadPadrao.BuscaCondicoes.Count - 1 do
    Result := ' ' + Result + ' ' + smCadPadrao.BuscaCondicoes.Strings[i];
end;

function TfrmCad.BuscaGetOrderBy: string;
var
  i: Integer;
begin
  for i := 0 to smCadPadrao.BuscaOrderBy.Count - 1 do
    Result := ' ' + Result + ' ' + smCadPadrao.BuscaOrderBy.Strings[i];
end;

function TfrmCad.BuscaGetSql: string;
var
  i: Integer;
begin
  for i := 0 to smCadPadrao.BuscaSql.Count - 1 do
    Result := Result + ' ' + smCadPadrao.BuscaSql.Strings[i];
end;

procedure TfrmCad.CoBoCamposChange(Sender: TObject);
begin
  inherited;
  if CoBoCampos.Text = '' then
    Exit;

  with smCadPadrao.FieldsBusca do
  begin
    EdConteudoNum.Clear;
    EdConteudoTexto.Clear;
    EdConteudoReal.Clear;
    CoBoModoPesquisa.Items.Clear;
    Field := (FieldsBusca.GetField(CoBoCampos.Text));

    LaConteudo.Visible := not (Field.FieldType in [ftDate, ftDateTime]);
    LaDataInicial.Visible := (Field.FieldType in [ftDate, ftDateTime]);
    LaDataFinal.Visible := (Field.FieldType in [ftDate, ftDateTime]);
    EdConteudoDataInicial.Visible := (Field.FieldType in [ftDate, ftDateTime]);
    EdConteudoDataFinal.Visible := (Field.FieldType in [ftDate, ftDateTime]);

    EdConteudoNum.Visible := (Field.FieldType in [ftInteger, ftSmallint]);
    EdConteudoTexto.Visible := (Field.FieldType in [ftString]);
    EdConteudoReal.Visible := (Field.FieldType in [ftFloat]);

    //ALIMENTANDO O COMBOBOX DO MODO DA PESQUISA --> STRING
    if (Field.FieldType in [ftString]) then
    begin
      CoBoModoPesquisa.Items.Add('Conteúdo exato');
      CoBoModoPesquisa.Items.Add('Contém o conteúdo');
      CoBoModoPesquisa.Items.Add('Início do conteúdo');
      CoBoModoPesquisa.Items.Add('Término do conteúdo');
      EdConteudoTextoChange(self);
    end;

    //ALIMENTANDO O COMBOBOX DO MODO DA PESQUISA --> DATA
    if (Field.FieldType in [ftDate, ftDateTime]) then
    begin
      CoBoModoPesquisa.Items.Add('Conteúdo exato');
      EdConteudoDataInicialChange(self);
    end;

    //ALIMENTANDO O COMBOBOX DO MODO DA PESQUISA --> VALOR  INTEIRO
    if (Field.FieldType in [ftInteger, ftSmallint]) then
    begin
      CoBoModoPesquisa.Items.Add('Valor exato');
      CoBoModoPesquisa.Items.Add('Maior Igual a este valor');
      CoBoModoPesquisa.Items.Add('Menor Igual a este valor');
      EdConteudoNumChange(self);
    end;

    //ALIMENTANDO O COMBOBOX DO MODO DA PESQUISA --> VALOR  REAL
    if (Field.FieldType in [ftFloat]) then
    begin
      CoBoModoPesquisa.Items.Add('Valor exato');
      CoBoModoPesquisa.Items.Add('Maior Igual a este valor');
      CoBoModoPesquisa.Items.Add('Menor Igual a este valor');
      EdConteudoRealChange(self);
    end;
    CoBoModoPesquisa.ItemIndex := 0;
  end;
end;

procedure TfrmCad.CoBoModoPesquisaKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  OnEnterPesquisa(key);
end;

procedure TfrmCad.EdConteudoDataInicialChange(Sender: TObject);
begin
  inherited;
  OnChangeCamposPesquisa(DateToStr(EdConteudoDataInicial.Date), DateToStr(EdConteudoDataFinal.Date));
end;

procedure TfrmCad.EdConteudoDataInicialKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  OnEnterPesquisa(key);
end;

procedure TfrmCad.EdConteudoNumChange(Sender: TObject);
begin
  inherited;
  OnChangeCamposPesquisa(EdConteudoNum.Text);
end;

procedure TfrmCad.EdConteudoNumKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  OnEnterPesquisa(key);
  if (not (key in ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0']) and (Key <> #13) and (Key <> #8)) then
    Abort;
end;

procedure TfrmCad.EdConteudoRealChange(Sender: TObject);
begin
  inherited;
  OnChangeCamposPesquisa(EdConteudoReal.Text);
end;

procedure TfrmCad.EdConteudoRealKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  OnEnterPesquisa(key);
  if (not (key in [',', '.', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0']) and (Key <> #13) and (Key <> #8)) then
    Abort;
end;

procedure TfrmCad.EdConteudoTextoChange(Sender: TObject);
begin
  inherited;
  OnChangeCamposPesquisa(EdConteudoTexto.Text);
end;

procedure TfrmCad.EdConteudoTextoKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  OnEnterPesquisa(key);
end;

procedure TfrmCad.FormActivate(Sender: TObject);
begin
  if smCadPadrao.BuscaGetAll then
    AcTodosRegistrosExecute(self);
end;

procedure TfrmCad.FormCreate(Sender: TObject);
  procedure PosicionComponents();
  begin
    TaShCadastro.TabVisible := False;
    TaShConsulta.TabVisible := False;
    TaShRelatorio.TabVisible := False;
    LaConteudo.Left := LaDataInicial.Left;
    LaDataInicial.Visible := False;
    LaDataFinal.Visible := False;
    PaCoPadrao.ActivePageIndex := 0;
    TipoCampoBusca := '';

    //Setando o ClientDataset do tbCadastro
    smCadPadrao.DataSourceBusca.DataSet.Close;

    GetTable;
    GetcdsCadastro;
    GetDsCadastro;

    //Setando o DataSource da ToolBar
    SetToolBarDataSource;

    //Limpando os campos de Busca
    EdConteudoTexto.Clear;
    EdConteudoNum.Clear;
    EdConteudoReal.Clear;
    CoBoModoPesquisa.Items.Clear;
    EdConteudoDataInicial.Date := Now;
    EdConteudoDataFinal.Date := Now;

    //Setando os compoentes para a busca de dados
    CoBoCamposChange(self);
    CoBoModoPesquisa.Items.Clear;
  end;

  procedure ValidarTabela();
  begin
    if (smCadPadrao.Tabela = '') then
    begin
      Msg('Tabela principal não definida!', mtErro);
      ToBaCadastro.Enabled := False;
      PaCoPadrao.Enabled := False;
      Abort;
    end;
  end;

  procedure ValidarDataSourceCadastro();
  begin
    if not (Assigned(smCadPadrao.DataSourceCadastro)) then
    begin
      Msg('DataSource Cadastro não definido!', mtErro);
      ToBaCadastro.Enabled := False;
      PaCoPadrao.Enabled := False;
      Abort;
    end;
    VerificarClassesDataSet(smCadPadrao.DataSourceCadastro.DataSet);
  end;

  procedure ValidarDataSourceBusca();
  begin
    if not (Assigned(smCadPadrao.DataSourceBusca)) then
    begin
      Msg('DataSource Busca não definido!', mtErro);
      ToBaCadastro.Enabled := False;
      PaCoPadrao.Enabled := False;
      Abort;
    end;
    VerificarClassesDataSet(smCadPadrao.DataSourceBusca.DataSet);
  end;

begin
  inherited;
  try
    ValidarTabela;
    ValidarDataSourceCadastro;
    ValidarDataSourceBusca;
    PosicionComponents;
    FieldsBusca := TFieldsBusca.Create;
    FieldsBusca.SetForm(Self);
    FieldsBusca.SetFields();
    SetComponents;
  finally
  end;

end;

procedure TfrmCad.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(tbTabela);
  smCadPadrao.DataSourceBusca.DataSet.Close;
  smCadPadrao.DataSourceCadastro.DataSet.Close;
  CloseDataSets(self);

  if Assigned(FieldsBusca) then
    FreeAndNil(FieldsBusca);
end;

procedure TfrmCad.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN: Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TfrmCad.FormShow(Sender: TObject);
begin
  SetBotoes;
  ShowTabBusca;
  grbxPesquisa.Visible := smCadPadrao.BuscaVisible;
  WindowState := WindowState;
end;

procedure TfrmCad.grPesquisaDblClick(Sender: TObject);
begin
  inherited;
  ShowTabCadastro;
end;

procedure TfrmCad.grPesquisaKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if key = #13 then
    ShowTabCadastro;
end;

procedure TfrmCad.OnChangeCamposPesquisa(PesquisaInicio: string; const PesquisaFim: string = '');
begin
  {*******************************************************************************
  *   METODO PARA ATIVAR O BOTAO DE BUSCA                                        *
  *                                                                              *
  *                                                                              *
  *                                                                              *
  *                                                                              *
  *******************************************************************************}
  if TipoCampoBusca = 'D' then
    BuProcessar.Enabled := (PesquisaInicio <> '') and (PesquisaFim <> '')
  else
    BuProcessar.Enabled := (PesquisaInicio <> '');
end;

procedure TfrmCad.OnEnterPesquisa(Key: Char);
begin
  {*******************************************************************************
  *   METODO PARA EXECUTAR  O BOTAO DE BUSCA                                     *
  *                                                                              *
  *                                                                              *
  *                                                                              *
  *                                                                              *
  *******************************************************************************}
  if (Key = #13) and (BuProcessar.Enabled) then
    BuProcessarClick(Self);
end;

procedure TfrmCad.OpenBuscaSql(sql: string);
begin
  //Concatenando as Condicoes alocadas no BuscaCondicoes
  sql := sql + BuscaGetCondicoes + BuscaGetOrderBy;

  //Sql default
  if BuscaGetSql <> '' then
  begin
    sql := '';
    sql := BuscaGetSql;
  end;

  try
    with smCadPadrao.DataSourceBusca do
    begin
      dataset.Close;
      //ClienteDataSet
      if (Dataset is TClientDataSet) then
        (Dataset as TClientDataSet).CommandText := sql;

      //ADO dataset
      if (Dataset is TADODataSet) then
        (Dataset as TADODataSet).CommandText := sql;

      //ADOQuery
      if (Dataset is TADOQuery) then
        (Dataset as TADOQuery).SQL.Text := sql;

      //SqlDataSet
      if (Dataset is TSQLDataSet) then
        (Dataset as TSQLDataSet).CommandText := sql;

      //SQLQuery
      if (Dataset is TSQLQuery) then
        (Dataset as TSQLQuery).SQL.Text := sql;

      //IBOQuery
      {if (Dataset is TIBOQuery) then
        (Dataset as TIBOQuery).SQL.Text := sql; }

      Dataset.Open;
      stbrConsulta.Panels[0].Text := ' Total de Registros: ' + IntToStr(DataSet.RecordCount);
    end;
  except
    on E: Exception do
      Msg('Erro no processo de busca dos dados! ' +
        #13 + #13 + E.Message, mtErro);
  end;

end;

procedure TfrmCad.SetBotoes;
begin
  with smCadPadrao do
  begin
    btnLocalizar.Visible := (Localizar in Botoes);
    btnNovo.Visible := (Novo in Botoes);
    btnSalvar.Visible := (Salvar in Botoes);
    btnCancelar.Visible := (Cancelar in Botoes);
    btnAlterar.Visible := (Alterar in Botoes);
    btnExcluir.Visible := (Deletar in Botoes);
    btnImprimir.Visible := (Imprimir in Botoes);
    btnLocalizarTodosRegistros.Visible := (LocalizarTudo in Botoes);
  end;
end;

procedure TfrmCad.SetComponents;
begin
  GrPesquisa.DataSource := smCadPadrao.DataSourceBusca;
end;

procedure TfrmCad.SetToolBarButtonsState(Sender: TObject);
begin

  //DESABILITANDO TODOS OS BOTOES
  AcLocalizar.Enabled := False;
  AcNovo.Enabled := False;
  AcApplyUpdate.Enabled := False;
  AcCancelar.Enabled := False;
  AcEdit.Enabled := False;
  AcDelete.Enabled := False;
  //  AcImprimir.Enabled := False;
  btnLocalizarTodosRegistros.Enabled := False;

  //TABSHET DE tbCadastro
  if PaCoPadrao.ActivePageIndex in [1] then
  begin
    AcLocalizar.Enabled := tbCadastro.State in [dsBrowse, dsInactive, dsEdit, dsInsert];
    AcNovo.Enabled := tbCadastro.State in [dsBrowse, dsInactive, dsEdit];
    AcApplyUpdate.Enabled := tbCadastro.State in [dsEdit, dsInsert];
    AcCancelar.Enabled := tbCadastro.State in [dsEdit, dsInsert];
    AcEdit.Enabled := tbCadastro.State in [dsBrowse, dsInactive];
    AcDelete.Enabled := tbCadastro.State in [dsEdit, dsBrowse, dsInactive];
  end;

  //TABSHET DE BUSCA
  if PaCoPadrao.ActivePageIndex in [0] then
  begin
    AcNovo.Enabled := tbCadastro.State in [dsBrowse, dsInactive];
    btnLocalizarTodosRegistros.Enabled := True;
  end;

  //Botões de Navegacao
  AcFirst.Enabled := True;
  AcPrior.Enabled := True;
  AcNext.Enabled := True;
  AcLast.Enabled := True;

  { AcFirst.Enabled := not (smCadPadrao.DataSourceBusca.DataSet.IsEmpty) and ((smCadPadrao.DataSourceBusca.DataSet.RecNo >= 2));
    AcPrior.Enabled := not (smCadPadrao.DataSourceBusca.DataSet.IsEmpty) and ((smCadPadrao.DataSourceBusca.DataSet.RecNo >= 2));
    AcNext.Enabled := not (smCadPadrao.DataSourceBusca.DataSet.IsEmpty) and ((smCadPadrao.DataSourceBusca.DataSet.RecNo < smCadPadrao.DataSourceBusca.DataSet.RecordCount));
    AcLast.Enabled := not (smCadPadrao.DataSourceBusca.DataSet.IsEmpty) and ((smCadPadrao.DataSourceBusca.DataSet.RecNo < smCadPadrao.DataSourceBusca.DataSet.RecordCount));}
end;

procedure TfrmCad.GetcdsCadastro;
begin

  with smCadPadrao.DataSourceCadastro do
  begin
    if (DataSet is TClientDataSet) then
      tbCadastro := (DataSet) as TClientDataSet

    else if (DataSet is TADODataSet) then
      tbCadastro := (DataSet) as TADODataSet

    else if (DataSet is TADOQuery) then
      tbCadastro := (DataSet) as TADOQuery

    else if (DataSet is TSQLDataSet) then
      tbCadastro := (DataSet) as TSQLDataSet

    else if (DataSet is TSQLQuery) then
      tbCadastro := (DataSet) as TSQLQuery

    {else if (DataSet is TIboQuery) then
      tbCadastro := (DataSet) as TIboQuery}
  end;
end;

procedure TfrmCad.GetDsCadastro;
begin
  dsCadastro := smCadPadrao.DataSourceCadastro;
  dsCadastro.OnStateChange := SetToolBarButtonsState;
end;

function TfrmCad.GetForm: TForm;
begin
  Result := frmCad;
end;

procedure TfrmCad.GetTable;
begin
  Tabela := UpperCase(smCadPadrao.Tabela);

  if smCadPadrao.Tabela = '' then
  begin
    Msg('Tabela principal não informada', mtErro);
    ToBaCadastro.Enabled := False;
  end;

end;

procedure TfrmCad.SetToolBarDataSource;
begin
  AcFirst.DataSource := smCadPadrao.DataSourceBusca;
  AcPrior.DataSource := smCadPadrao.DataSourceBusca;
  AcNext.DataSource := smCadPadrao.DataSourceBusca;
  AcLast.DataSource := smCadPadrao.DataSourceBusca;
end;

procedure TfrmCad.ShowTabBusca;
begin
  try
    Wait(self, 'Carregando Informações');
    if tbCadastro.state in [DsInsert, DsEdit] then
      {if Msg('Deseja salvar as informações deste registro?', mtAviso, Sim_Nao_Cancelar) then
        AcApplyUpdateExecute(self)
      else}
      tbCadastro.Cancel;

    if not (smCadPadrao.DataSourceBusca.DataSet.IsEmpty) then
      OpenDataSet(smCadPadrao.DataSourceBusca.DataSet);

    PaCoPadrao.ActivePageIndex := 0;
    TaShCadastro.Enabled := False;
    SetToolBarButtonsState(self);

    if PaCoPadrao.ActivePageIndex = 0 then
      grPesquisa.SetFocus;
  finally
    WaitEnd(self);
  end;
end;

procedure TfrmCad.ShowTabCadastro;
var
  ParamCount: Integer;

  procedure GetParamsADO;
  var
    nParam, nColuna, ParamCount: Integer;
  begin
    tbCadastro.Close;
    ParamCount := (tbCadastro as TADODataSet).Parameters.Count;
    for nParam := 0 to ParamCount - 1 do
      for nColuna := 0 to smCadPadrao.DataSourceBusca.DataSet.FieldCount - 1 do
        if (UpperCase(smCadPadrao.DataSourceBusca.DataSet.Fields[nColuna].FieldName) = UpperCase((tbCadastro as TADODataSet).Parameters[nParam].Name)) then
          (tbCadastro as TADODataSet).Parameters[nParam].Value := smCadPadrao.DataSourceBusca.DataSet.Fields[nColuna].Value;
    PaCoPadrao.ActivePageIndex := 1;
    tbCadastro.Open;
  end;

  procedure GetParams;
  var
    nParam, nColuna: Integer;
  begin
    tbCadastro.Close;

    if (tbCadastro is TClientDataSet) then
    begin
      ParamCount := (tbCadastro as TClientDataSet).Params.Count;
      for nParam := 0 to ParamCount - 1 do
        for nColuna := 0 to smCadPadrao.DataSourceBusca.DataSet.FieldCount - 1 do
          if (UpperCase(smCadPadrao.DataSourceBusca.DataSet.Fields[nColuna].FieldName) = UpperCase((tbCadastro as TClientDataSet).Params[nParam].Name)) then
            (tbCadastro as TClientDataSet).Params[nParam].Value := smCadPadrao.DataSourceBusca.DataSet.Fields[nColuna].Value;
      PaCoPadrao.ActivePageIndex := 1;
      tbCadastro.Open;
    end

  end;

begin
  try
    Screen.Cursor := crSQLWait;

    if ((tbCadastro is TADODataSet) or (tbCadastro is TADOQuery)) then
      GetParamsADO
    else GetParams;

    if (tbCadastro.IsEmpty) then
    begin
      PaCoPadrao.ActivePageIndex := 0;
      Msg('Registro não localizado!', mtErro);
    end;
    SetToolBarButtonsState(self);
    btnAlterar.Click;
  finally
    Screen.Cursor := crDefault;
  end;

end;

procedure TfrmCad.ShowTabRelatorio;
begin
  PaCoPadrao.ActivePageIndex := 2;
  SetToolBarButtonsState(self);
end;

procedure TfrmCad.VerificarClassesDataSet(DataSet: TDataSet);
begin
  with DataSet do
  begin
    if not ((Dataset is TClientDataSet)
      or (Dataset is TADODataSet)
      or (Dataset is TADOQuery)
      or (Dataset is TSQLDataSet)
      or (Dataset is TSQLQuery))
      //or (Dataset is TIBOQuery))
      then
    begin

      Msg('Classe ' + dataset.ClassName + ' não definida no Cadastro Padrão!', mtErro);
      ToBaCadastro.Enabled := False;
      PaCoPadrao.Enabled := False;
      Abort;
    end;
  end;

end;

{ TFieldsBusca }

procedure TFieldsBusca.ClearObjects;
begin
  with Form do
  begin
    if (smCadPadrao.GridCreateColumns) then
      grPesquisa.Columns.Clear;
    CoBoCampos.Clear;
    CamposBusca := '';
  end;
end;

procedure TFieldsBusca.SetForm(AForm: TfrmCad);
begin
  FForm := AForm;
  ClearObjects;
end;

function TFieldsBusca.GetField(DisplayName: string): TFieldsBuscaItem;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Form.smCadPadrao.FieldsBusca.Count - 1 do
    if (Form.smCadPadrao.FieldsBusca.Items[i].DisplayName = Form.CoBoCampos.Text) then
    begin
      Result := Form.smCadPadrao.FieldsBusca.Items[i];
      Break;
    end;
end;

procedure TFieldsBusca.SetCombo(Item: Integer);
begin
  with Form.smCadPadrao.FieldsBusca.Items[Item], Form do
  begin
    if not (ShowCombo) then
      Exit;
    CoBoCampos.Items.Add(Trim(DisplayName));
  end;
end;

procedure TFieldsBusca.SetFields;
var
  i: Integer;
begin
  for i := 0 to Form.smCadPadrao.FieldsBusca.Count - 1 do
  begin
    SetCombo(i);
    SetGrid(i);
    SetsqlFields(i);
  end;
end;

procedure TFieldsBusca.SetGrid(Item: Integer);
begin
  with Form.smCadPadrao,
    Form.smCadPadrao.FieldsBusca.Items[Item],
    Form.grPesquisa do
  begin
    if not (ShowGrid and GridCreateColumns) then
      Exit;
    Columns.Add;
    Columns.Items[Columns.Count - 1].ReadOnly := True;
    Columns.Items[Columns.Count - 1].FieldName := FieldName;
    Columns.Items[Columns.Count - 1].Title.Caption := DisplayName;
  end;
end;

procedure TFieldsBusca.SetsqlFields(Item: Integer);
begin
  with Form.smCadPadrao.FieldsBusca.Items[Item], Form.CoBoCampos, Form do
  begin
    if not (ShowGrid or ShowSelect or ShowSelect) then
      Exit;

    if CamposBusca = '' then
      CamposBusca := tabela + '.' + FieldName
    else
      CamposBusca := CamposBusca + ',' + tabela + '.' + FieldName;
  end;
end;

end.

