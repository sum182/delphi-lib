{*******************************************************}
{                                                       }
{                 Sum182 Component Library              }
{                                                       }
{  Copyright (c) 2001-2007 Sum182 Software Corporation  }
{                                                       }
{                 Tel.:  55 11 8214-7819                }
{                                                       }
{                 Email: sum182@gmail.com               }
{*******************************************************}

unit smRBuilder;

interface

uses
  SysUtils, Classes, Graphics,
  ppReport,ppClass,ppCtrls,ppComm, ppRelatv, ppDBPipe, ppParameter, ppBands,
  ppCache, ppProd, ppDB,ppVar, ppMemo,ppTypes,smGeral;

type
  TTextoFont = class(TPersistent)
  private
    FFont: TFont;
    FText: TStrings;
    FOwner: TPersistent;
    procedure SetFont(const Value: TFont);
    procedure SetText(const Value: TStrings);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TPersistent);
    destructor Destroy; override;
  published
    property Text: TStrings read FText write SetText;
    property Font: TFont read FFont write SetFont;
  end;

  TExports = (DotMatrix, Excel, Graphic, Html, Lotus, PDF, Quattro, RTF, XHTML);
  TExportsCj = set of TExports;
  TsmRbuilder = class(TComponent)
  private
    CabecalhoBand: TppBand;
    CabecalhoMemo: TppMemo;
    CabecalhoTitulo: TppLabel;
    CabecalhoLine: TppLine;
    RodapeBand: TppBand;
    RodapeMemo: TppMemo;
    RodapeLine: TppLine;
    lblDataHora: TppSystemVariable;
    lblPags: TppSystemVariable;
    LogoRel: TppImage;

    { TODO : Consertar ExtraOptions }
    //FExtraOptions: TExtraOptions;
    FIcon: TIcon;
    FCabecalho: TStrings;
    FRodape: TStrings;
    FLogo: TBitMap;
    FCabecalhoFont: TFont;
    FRodapeFont: TFont;
    FRelatorio: Tppreport;
    FTitulo: string;
    FOutlineSettings: Boolean;
    FPrintToFile: Boolean;
    FOnBeforePrint: TNotifyEvent;
    FOnAfterPrint: TNotifyEvent;
    FLogoExibir: Boolean;
    FShowDateTime :Boolean;
    FExportar: TExportsCj;
    FCabecTeste: TTextoFont;
    FPeriodo: string;
    lblPeriodo: TppLabel;
    FShowPages: boolean;
    procedure SetCabecTeste(const Value: TTextoFont);
    procedure SetRodapeFont(const Value: TFont);
    procedure SetCabecalhoFont(const Value: TFont);
    procedure SetLogo(const Value: TBitMap);
    procedure SetRodape(const Value: TStrings);
    procedure SetCabecalho(const Value: TStrings);
    procedure SetIcon(const Value: TIcon);
    procedure SetCabecalhoRel;
    procedure SetRodapeRel;
    procedure SetLogoRel;
    procedure SetIconRel;
    procedure CriarObjetos;
    procedure DestruirObjetos;
    procedure SetOutLineSettings;
    procedure SetConfig;
    procedure SetExportar;
    procedure SetTitulo;
    procedure AddPeriodo;
  protected
  public
    constructor Create (AOwner: Tcomponent);override;
    destructor Destroy; override;
    procedure Print; overload;
    procedure Print(ppReport: TppReport);overload;
    procedure BeforePrint;
    procedure AfterPrint;
    procedure SetPeriodo(DtInicio: string;DtFim: string );
  published
    property Icon: TIcon read FIcon write SetIcon;
    property Cabecalho: TStrings read FCabecalho write SetCabecalho;
    property CabecalhoFont: TFont read FCabecalhoFont write SetCabecalhoFont;
    property Titulo: string read FTitulo write FTitulo;
    property Rodape: TStrings read FRodape write SetRodape;
    property RodapeFont: TFont read FRodapeFont write SetRodapeFont;
    property Logo: TBitMap read FLogo write SetLogo;
    property Relatorio: Tppreport read FRelatorio  write FRelatorio;
    property OutlineSettings: Boolean read FOutlineSettings write FOutlineSettings;
    property PrintToFile: Boolean read FPrintToFile write FPrintToFile;
    property OnBeforePrint:TNotifyEvent read FOnBeforePrint write FOnBeforePrint;
    property OnAfterPrint:TNotifyEvent read FOnAfterPrint write FOnAfterPrint;
    property LogoExibir:Boolean read FLogoExibir write FLogoExibir;
    property Exportar: TExportsCj read FExportar write FExportar;
    property CabecTeste: TTextoFont read FCabecTeste write SetCabecTeste;
    property ShowDateTime:boolean read FShowDateTime write FShowDateTime;
    property ShowPages:boolean read FShowPages write FShowPages;
  end;

procedure Register;

implementation

uses
  ppPrnabl, ppOutlineReportSettings, Forms, smMensagens;

procedure Register;
begin
  RegisterComponents('Sum182', [TsmRbuilder]);
end;

{ TTextoFont }

constructor TTextoFont.Create(AOwner: TPersistent);
begin
  inherited Create;
  FOwner := AOwner;
  FText := TStringList.Create;
  FFont := TFont.Create;
end;

destructor TTextoFont.Destroy;
begin
  FText.Free;
  FFont.Free;
  inherited;
end;

function TTextoFont.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TTextoFont.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TTextoFont.SetText(const Value: TStrings);
begin
  FText.Assign(Value);
end;

{ TsmRbuilder }

procedure TsmRbuilder.AddPeriodo;
begin
  //Verificando se nao foi criado a Banda de Titulo
  if not (Assigned(CabecalhoBand)) then Exit;
  if FPeriodo = '' then Exit;
  with lblPeriodo do
  begin
    Caption := FPeriodo;
    Band := CabecalhoBand;
    Border.Visible := False;
    Font.Color := clBlack;
    Font.Name := 'TIMES NEW ROMAN';
    Font.Size := 12;
    Font.Style := [fsBold, fsItalic];
    Alignment := taCenter;
    Transparent := True;
    Top := CabecalhoBand.Height + 0.10;
    ParentWidth := True;
    CabecalhoBand.Height := CabecalhoBand.Height + Height + 0.10;
  end;
end;

procedure TsmRbuilder.AfterPrint;
begin
  if Assigned(FOnAfterPrint) then
    OnAfterPrint(self);
end;

procedure TsmRbuilder.BeforePrint;
begin
  if Assigned(FOnBeforePrint) then
    OnBeforePrint(self);
end;

constructor TsmRbuilder.Create(AOwner: Tcomponent);
begin
  inherited;
  FIcon := TIcon.Create;
  FCabecalho := TStringList.Create;
  FCabecalhoFont := TFont.Create;
  FRodape := TStringList.Create;
  FRodapeFont := TFont.Create;
  FLogo := TBitMap.Create;

  { TODO : Consertar ExtraOptions }
//  FExtraOptions := TExtraOptions.Create(self);
  Exportar := [Excel,Graphic,Html,PDF,RTF,XHTML];
  FCabecTeste := TTextoFont.Create(Self);
  ShowDateTime := True;
  ShowPages := True;
end;

procedure TsmRbuilder.CriarObjetos;
begin
  CabecalhoBand:= FRelatorio.HeaderBand;
  CabecalhoMemo:= TppMemo.Create(CabecalhoBand);
  CabecalhoTitulo:= TppLabel.Create(CabecalhoBand);
  CabecalhoLine:= TppLine.Create(CabecalhoBand);
  RodapeBand:= FRelatorio.FooterBand;
  RodapeMemo:= TppMemo.Create(RodapeBand);
  RodapeLine:= TppLine.Create(RodapeBand);
  lblDataHora:= TppSystemVariable.Create(RodapeBand);
  lblPags:= TppSystemVariable.Create(RodapeBand);
  LogoRel := TppImage.Create(CabecalhoBand);
  lblPeriodo := TppLabel.Create(self);
end;

destructor TsmRbuilder.Destroy;
begin
  FIcon.Free;
  FCabecalho.Free;
  FCabecalhoFont.Free;
  FRodape.Free;
  FRodapeFont.Free;
  FLogo.Free;
{ TODO : Consertar ExtraOptions }
//  FExtraOptions.Free;
  inherited;
end;

procedure TsmRbuilder.DestruirObjetos;
begin
  CabecalhoMemo.Free;
  CabecalhoTitulo.Free;
  CabecalhoLine.Free;
  RodapeMemo.Free;
  RodapeLine.Free;
  lblDataHora.Free;
  lblPags.Free;
  LogoRel.Free;
  lblPeriodo.Free;
end;


procedure TsmRbuilder.Print(ppReport: TppReport);
begin
  Relatorio := ppReport;
  Print;
end;

procedure TsmRbuilder.Print;
begin
  try
    if not Assigned(Relatorio) then Exit;
    Wait;
    SetTitulo;
    BeforePrint;
    CriarObjetos;
    SetCabecalhoRel;
    SetRodapeRel;
    SetOutLineSettings;
    SetConfig;
    SetIconRel;
    SetExportar;
    FRelatorio.Print;
    AfterPrint;
  finally
    DestruirObjetos;
    WaitEnd;
  end;
end;

procedure TsmRbuilder.SetIcon(const Value: TIcon);
begin
  FIcon.Assign(Value);
end;


procedure TsmRbuilder.SetIconRel;
begin
  if Icon <> nil then
    Relatorio.Icon := Icon;
end;

procedure TsmRbuilder.SetLogo(const Value: TBitMap);
begin
  FLogo.Assign(Value);
end;

procedure TsmRbuilder.SetLogoRel;
begin
  if (LogoExibir)  and Assigned(Logo) then
  begin
    with  LogoRel do
    begin
      Picture.Bitmap := Logo;
      Left := 0;
      Top:= 0;
      AutoSize := True;
      Band := CabecalhoBand;
      Border.Visible := False;
      Alignment := taLeftJustify;
    end;
  end;
end;

procedure TsmRbuilder.SetOutLineSettings;
begin
  with Frelatorio.OutlineSettings do
  begin
    CreateNode := FOutlineSettings;
    CreatePageNodes:= FOutlineSettings;
    Enabled:= FOutlineSettings;
    Visible:= FOutlineSettings;
  end;
end;

procedure TsmRbuilder.SetPeriodo(DtInicio, DtFim: string);
begin
  FPeriodo := 'Período do Relatório de: ' + DtInicio + ' à ' + DtFim;
end;

procedure TsmRbuilder.SetConfig;
begin
  with FRelatorio do
  begin
    PreviewFormSettings.ZoomPercentage := 100;
    PreviewFormSettings.WindowState := wsMaximized;
    AllowPrintToArchive := False;
    AllowPrintToFile := PrintToFile;
  end;
end;

procedure TsmRbuilder.SetExportar;
begin
  { TODO : Consertar ExtraOptions }

{  FExtraOptions.DotMatrix.Visible := (DotMatrix in Exportar);
  FExtraOptions.Excel.Visible := (Excel in Exportar);
  FExtraOptions.Graphic.Visible := (Graphic in Exportar);
  FExtraOptions.Html.Visible := (Html in Exportar);
  FExtraOptions.Lotus.Visible := (Lotus in Exportar);
  FExtraOptions.Quattro.Visible := (Quattro in Exportar);
  FExtraOptions.RTF.Visible := (RTF in Exportar);
  FExtraOptions.XHTML.Visible := (XHTML in Exportar);

  //O RBuilder coloca automaticamente a exportacao pra PDF gerando erros
  FExtraOptions.PDF.Visible := False ;//(PDF in Exportar);
}
end;

procedure TsmRbuilder.SetRodape(const Value: TStrings);
begin
  FRodape.Assign(Value);
end;

procedure TsmRbuilder.SetRodapeFont(const Value: TFont);
begin
  FRodapeFont.Assign(Value);
end;

procedure TsmRbuilder.SetRodapeRel;
begin

  if not(Assigned(RodapeBand)) then Exit;

  //Linhas do Rodape
  if FRodape.Count >= 1 then
  begin
    with RodapeMemo do
    begin
      Lines := FRodape;
      Font := FRodapeFont;
      Band := RodapeBand;
      Border.Visible := False;
      Transparent := True;
      ParentWidth := True;
      ParentHeight := True;
      TextAlignment := taCentered;
      RodapeBand.Height := Rodape.Count * 0.20;
    end;
  end;

  //Data e Hora do Sistema
  with lblDataHora do
  begin
    Band := RodapeBand;
    AutoSize := True;
    Border.Visible := False;
    vartype := vtDateTime;
    Font := FRodapeFont;
    Transparent := True;
    Left := 3.35;
    Top := RodapeBand.Height - 0.20;
    ParentWidth := True;
    TextAlignment := taLeftJustified;
    Visible := ShowDateTime;
  end;

  //Paginas
  with lblPags do
  begin
    Band := RodapeBand;
    AutoSize := True;
    Border.Visible := False;
    vartype := vtPageSetDesc;
    Font := FRodapeFont;
    Transparent := True;
    Left := 6.87;
    Top := RodapeBand.Height - 0.20;
    ParentWidth := True;
    TextAlignment := taRightJustified;
    Visible:= ShowPages;
  end;

  //Linha divisoria do BandRodape
  with RodapeLine do
  begin
    Band := RodapeBand;
    ParentHeight := True;
    ParentWidth := True;
    Position := lpBottom;
    Border.Visible := False;
    Pen.Color := clGray;
  end;

end;

procedure TsmRbuilder.SetTitulo;
begin
  if not Assigned(Relatorio) then Exit;

  if (Relatorio.PrinterSetup.DocumentName <> 'Report') and
    (Relatorio.PrinterSetup.DocumentName <> '') then
    Titulo := Relatorio.PrinterSetup.DocumentName;
end;

procedure TsmRbuilder.SetCabecalho(const Value: TStrings);
begin
  FCabecalho.Assign(Value);
end;


procedure TsmRbuilder.SetCabecalhoFont(const Value: TFont);
begin
  FCabecalhoFont.Assign(Value);
end;

procedure TsmRbuilder.SetCabecalhoRel;
begin

  //Verificando se nao foi criado a Banda de Titulo
  if not (Assigned(CabecalhoBand)) then Exit;

  CabecalhoBand.Height := 0;

  //Linhas do Cabecalho
  if Cabecalho.Count >= 1 then
  begin
    with CabecalhoMemo do
    begin
      Lines := FCabecalho;
      Font := FCabecalhoFont;
      Band := CabecalhoBand;
      Border.Visible := False;
      Transparent := True;
      ParentWidth := True;
      ParentHeight := True;
      TextAlignment := taCentered;
      CabecalhoBand.Height := Cabecalho.Count * 0.27;
      SendToBack;
    end;
  end;

  //Titulo do relatorio
  if FTitulo <> '' then
  begin
    with CabecalhoTitulo do
    begin
      Caption := FTitulo;
      Band := CabecalhoBand;
      Border.Visible := False;
      Font.Color := clBlack;
      Font.Name := 'TIMES NEW ROMAN';
      Font.Size := 15;
      Font.Style := [fsBold, fsItalic];
      Alignment := taCenter;
      Transparent := True;
      Top := CabecalhoBand.Height + 0.10;
      ParentWidth := True;
      CabecalhoBand.Height := CabecalhoBand.Height + Height + 0.10;
    end;
  end;

  //Logotipo
  SetLogoRel;
  //Periodo
  AddPeriodo;

  //Linha divisoria do Cabecalho
  with CabecalhoLine do
  begin
    Band := CabecalhoBand;
    Border.Visible := False;
    ParentWidth := True;
    ParentHeight := True;
    Position := lpBottom;
    ParentWidth := False;
    ParentHeight := False;
    CabecalhoBand.Height := CabecalhoBand.Height + 0.28;
  end;
end;

procedure TsmRbuilder.SetCabecTeste(const Value: TTextoFont);
begin
  FCabecTeste.Assign(Value);
end;

end.
