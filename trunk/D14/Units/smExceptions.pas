{*******************************************************}
{                                                       }
{                 Sum182 Component Library              }
{                                                       }
{  Copyright (c) 2001-2010 Sum182 Software Corporation  }
{                                                       }
{                 Tel.:  55 11 8214-7819                }
{                                                       }
{                 Email: sum182@gmail.com               }
{*******************************************************}

unit smExceptions;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Controls, StdCtrls, smMensagens,
  ComObj;

procedure ShowException(E: Exception; const Title: string = 'Erro do Sistema'; const MsgDefault: string = '');

implementation

procedure ShowException(E: Exception; const Title: string = 'Erro do Sistema'; const MsgDefault: string = '');
var
  EExibida: Boolean;
  msgErro: string;

  procedure ClassException(ClassName, Mensagem: string);
  begin
    if (UpperCase(E.ClassName) = UpperCase(ClassName)) and not (EExibida) then
    begin
      Msg(Mensagem, mtErro, ok, Title);
      EExibida := True;
    end;
  end;

  procedure MensagemException(MsgException, Mensagem: string);
  begin
    if (pos(UpperCase(MsgException),
      UpperCase(E.Message)) <> 0) and not (EExibida) then
    begin
      Msg(Mensagem, mtErro, ok, Title);
      EExibida := True;
    end;
  end;

  procedure FieldRequery();
  var
    mensagemerro : string;
    p1, p2: integer;
  begin
    if pos(upperCase('must have a value'), UpperCase(E.Message)) > 0 then
    begin
      p1 := Pos('''', E.Message);
      mensagemerro := E.Message;
      delete(mensagemerro, p1, 1);
      p2 := Pos('''', mensagemerro);
      mensagemerro := copy(E.Message, p1 + 1, p2 - p1);
      Msg('O campo [ ' + mensagemerro + ' ] � de preenchimento obrigat�rio.',
        mtErro, ok, Title);
    end;

    if pos(upperCase('validation error for column'), UpperCase(E.Message)) > 0 then
    begin
      mensagemerro := Copy(E.Message, 29, pos(',', E.Message) - 29);
      Msg('O campo [ ' + mensagemerro + ' ] � de preenchimento obrigat�rio.',
        mtErro, ok, Title);
    end;
  end;

begin
  EExibida := False;

  if E is EAbort then
    Exit;

  ClassException('ESocketError', 'Socket Server n�o est� em execu��o');
  ClassException('EAccessViolation', 'Acess Violation');
  ClassException('EConvertError', 'Erro de convers�o de tipos');
  ClassException('EDivByZero', 'Divis�o de inteiro por zero');
  ClassException('EInOutError', 'Erro de Entrada ou Sa�da');
  ClassException('EIntOverFlow', 'Resultado de um c�lculo inteiro excedeu o limite');
  ClassException('EInvalidCast', 'TypeCast inv�lido com o operador as');
  ClassException('EInvalidOp', 'Opera��o inv�lida com n�mero de ponto flutuante');
  ClassException('EOutOfMemory', 'Mem�ria insuficiente');
  ClassException('EOverflow', 'Resultado de um c�lculo com n�mero real excedeu o limite');
  ClassException('ERangeError', 'Valor excede o limite do tipo inteiro ao qual foi atribu�da');
  ClassException('EUnderflow', 'Resultado de um c�lculo com n�mero real � menor que a faixa v�lida');
  ClassException('EVariantError', 'Erro em opera��o com variant');
  ClassException('EZeroDivide', 'Divis�o de real por zero');

  MensagemException('violation of primary or unique key constraint',
    'O valor digitado para o campo chave j� existe no cadastro.');

  MensagemException('Input value',
    'Campo preenchido com valor inv�lido. Proceda a corre��o');

  MensagemException('is Not a valid date',
    'Data inv�lida, proceda a corre��o.');

  FieldRequery;

  if EExibida then
    Exit;

  if MsgDefault <> '' then
    msgErro := MsgDefault;

  if e.Message <> '' then
    msgErro := msgErro + #13 + e.Message;

  if e is Exception then
    Msg(msgErro, mtErro, Ok, Title)
  else
    Msg(msgErro + #13+ 'Exception Class:' + e.ClassName, mtErro, Ok, Title);
end;

end.

