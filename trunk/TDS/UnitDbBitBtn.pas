unit UnitDbBitBtn;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, Buttons, DB,DbClient;

type
  TAcao = (novo,Excluir,Editar,Gravar,Cancelar,Apply,Primeiro,Proximo,Anterior,Ultimo);
  TDbBitBtn = class(TBitBtn)



  private
    { Private declarations }
    FAcao        : TAcao;
    FDataSource  :TDataSource;
    procedure SetAcao(const Value: TAcao);
    procedure LoadGlyphBtn(pcaption:string;pimage:pAnsiChar);

  protected
    { Protected declarations }
    procedure Notification(AComponent:TComponent;Operation :TOperation);override;




  public
    { Public declarations }

      procedure Click;override;
      constructor Create(AOwner:TComponent);override;
  published
    { Published declarations }

     property Acao:TAcao read FAcao Write SetAcao ;
     property DataSource:TDataSource read FDataSource write FDataSource; 

  end;

procedure Register;

implementation

{$R Botoes.Res}

uses
  Dialogs, Windows;

procedure Register;
begin
  RegisterComponents('Tds', [TDbBitBtn]);
end;

{ TDbBitBtn }

procedure TDbBitBtn.Click;
begin
  inherited;


  if Assigned(DataSource) then

  case Acao of
    novo:DataSource.DataSet.Append ;

    Excluir: if MessageDlg('Tem Certeza?',mtInformation,[mbYes,mbNo],0)= mrYes Then
      DataSource.DataSet.Delete
    ;

    Editar: DataSource.DataSet.Edit;
    Gravar: DataSource.DataSet.post;
    Cancelar: DataSource.DataSet.Cancel;

    Apply: if DataSource.DataSet is TClientDataSet then
      (DataSource.DataSet as tClientDataSet).applyUpdates(0)
    ;


    Primeiro: DataSource.DataSet.First;
    Proximo: DataSource.DataSet.Next;
    Anterior: DataSource.DataSet.Prior;
    Ultimo: DataSource.DataSet.Last;
  end;





end;

constructor TDbBitBtn.Create(AOwner: TComponent);
begin
  inherited;
  acao := novo;
end;

procedure TDbBitBtn.LoadGlyphBtn(pcaption: string; pimage: pAnsiChar);
begin

   //BUSCANDO A IMAGEM
   Glyph.Handle := LoadBitmap(HInstance,pimage);

   //CAPTION DO BUTON
   caption := pcaption;

end;

procedure TDbBitBtn.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;

  //ESTE METODO E ACIONADO SEMPRE DEPOIS DE UMA INCLUSAO/EXCLUSAO DE UM COMPONENTE DO FORM

  if (AComponent = DataSource)  and (Operation = opRemove)then
    DaTaSource := Nil
  ;

end;

procedure TDbBitBtn.SetAcao(const Value: TAcao);
begin
   FAcao := Value;

   case Acao of
     novo      :LoadGlyphBtn('Novo'         ,'BXTNOVO');
     Excluir   :LoadGlyphBtn('Excluir'      ,'BXTEXCLUIR');
     Editar    :LoadGlyphBtn('Editar'       ,'BXTEDITAR');
     Gravar    :LoadGlyphBtn('Gravar'       ,'BXTGRAVAR');
     Cancelar  :LoadGlyphBtn('Cancelar'     ,'BXTCANCELAR');
     Apply     :LoadGlyphBtn('Apply Updates','BXTAPLICAR');
     Primeiro  :LoadGlyphBtn('Primeiro'     ,'BXTPRIMEIRO');
     Proximo   :LoadGlyphBtn('Próximo'      ,'BXTPROXIMO');
     Anterior  :LoadGlyphBtn('Anterior'     ,'BXTANTERIOR');
     Ultimo    :LoadGlyphBtn('Último'       ,'BXTULTIMO');
   end;
end;

end.
