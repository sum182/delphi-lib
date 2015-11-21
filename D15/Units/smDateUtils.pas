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

unit smDateUtils;

interface

  Uses
      SysUtils,Classes,smResourceString,Forms,smGeral,DateUtils,
      StrUtils,Variants;

  Type
  TDayOfWeek = (Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday);

  function IsWeekEnd(Data:TDateTime):Boolean;
  function ZerarMilliSeconds(Data:TDateTime):TDateTime;
  function GetFirstDayMonthPrevious(Data: TDateTime): string;
  function GetLastDayMonthPrevious(Data: TDateTime): string;

implementation

uses
  DB, Controls;

function IsWeekEnd(Data:TDateTime):Boolean;
begin
  Result := ( (DayOfWeek(data) = 7) or (DayOfWeek(data) = 1) );
end;

function ZerarMilliSeconds(Data:TDateTime):TDateTime;
begin
  Result := StrToDateTime(FormatDateTime('dd/mm/yyyy hh:mm',Data));
end;

function GetLastDayMonthPrevious(Data: TDateTime): string;
var
  DataAux: TDate;
  Mes: Variant;
  Ano: Variant;
  nDia, nMes, nAno: Word;
begin
  //ESTA FUNCAO RETORNA O ULTIMO DO DIA DO MES ATUAL
  DecodeDate(IncMonth(Data, - 1), nAno, nMes, nDia);
  DataAux := EncodeDate(nAno, nMes, 01) + 31;
  DecodeDate(DataAux, nAno, nMes, nDia);
  DataAux := EncodeDate(nAno, nMes, 01) - 1;
  Result := DateToStr(DataAux);
end;

function GetFirstDayMonthPrevious(Data: TDateTime): string;
begin
  Result := DateToStr(StartOfTheMonth(IncMonth(now,-1)));
end;




end.
