unit UnitfrmLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, XPMan, StdCtrls, Buttons;

type
  //tipo definido
  TfrmLogin = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    edtusuario: TEdit;
    edtSenha: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  end;

  TBotoes = (btnLogar,btnCancelar);

  //conjunto de botoes
  TConjBotoes = set of TBotoes;


  TLoginDialog = class(TComponent)
  private
    FLoginDialog    :TfrmLogin;
    FConjBotoes: TConjBotoes;
    FSenha: String;
    FUsuario: String;
   public
     //função que executara o dialogo
     function Executa:Boolean;
   published
     property Usuario :String      read FUsuario    write FUsuario;
     property Senha   :String      read FSenha      write FSenha;
     property Botoes  :TConjBotoes read FConjBotoes write FConjBotoes;
  end;

   procedure Register;

implementation


{$R *.dfm}

{ TfrmLogin }

procedure Register;
Begin
  RegisterComponents('Tds',[TLoginDialog]);
end;


function TLoginDialog.Executa: Boolean;
begin


   Result := False;

   try
     FLoginDialog := TFrmLogin.Create(Application);
     FLoginDialog.BitBtn1.Visible := btnLogar    in botoes;
     FLoginDialog.BitBtn2.Visible := btnCancelar in botoes;

     if (FLoginDialog.ShowModal = mrOk) then
       Result := (FLoginDialog.edtSenha.Text = Senha  ) and (FLoginDialog.edtusuario.Text = Usuario)
     ;

   finally
     FreeAndNil(FLoginDialog);
   end;

end;

end.
