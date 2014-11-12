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


unit uOTAUtils;

interface

uses
  ToolsAPI, classes, SysUtils, Dialogs;

procedure ReplaceSelection(const Text: string);
function GetSelection: string;
function GetEOL(const Text: string): string;
function TrimText(const Text: string): string;

implementation



procedure ReplaceSelection(const Text: string);
var
  View: IOTAEditView;
  BlockStart, BlockAfter: TOTACharPos;
  Editor: IOTASourceEditor;

  procedure Replace(const Inclusive: Boolean);
  var
    Writer: IOTAEditWriter;
    Start: Integer;
    After: Integer;
    DeletePos: Integer;
    Deleted: Boolean;
  begin
    if not Inclusive then begin
      Deleted := (Editor.BlockAfter.CharIndex = 1);
      if BlockAfter.CharIndex > 0 then
        Dec(BlockAfter.CharIndex);
    end else
      Deleted := False;
    Start := View.CharPosToPos(BlockStart);
    After := View.CharPosToPos(BlockAfter);
    Writer := Editor.CreateUndoableWriter;
    try
      Writer.CopyTo(Start);
      DeletePos := After;
      if (BlockAfter.CharIndex = 0) and (BlockAfter.Line - BlockStart.Line = 1) then begin
        Dec(DeletePos, Length(SLineBreak));
        if Deleted then begin
          Inc(DeletePos, Length(SLineBreak));
          Inc(DeletePos);
        end;
      end else begin
        if Deleted then
          Inc(DeletePos)
        else if BlockAfter.CharIndex > 0 then
          Inc(DeletePos);
      end;
      if DeletePos > Start then
        Writer.DeleteTo(DeletePos);
      Writer.Insert(PChar(Text));
      Writer.CopyTo(High(Longint));
    finally
      Writer := nil;
    end;
  end;

begin
  View := (BorlandIDEServices as IOTAEditorServices).TopView;

  if not Assigned(View) then Exit;

  (BorlandIDEServices as IOTAEditorServices).TopBuffer.QueryInterface(IOTASourceEditor, Editor);

  BlockStart := Editor.BlockStart;
  BlockAfter := Editor.BlockAfter;

  case Editor.BlockType of
    btInclusive: begin
      Replace(True);
    end;
    btNonInclusive: begin
      Replace(False);
    end;
    btLine: begin
      BlockStart.CharIndex := 0;
      BlockAfter.CharIndex := 1023;
      Replace(True);
    end;
  end;
  Editor.Show;
end;

function GetEOL(const Text: string): string;
var
  C: Integer;
begin
  Result := '';
  C := Length(Text);
  while (C > 1) and (Text[C] in [#13, #10]) do begin
    Result := Text[C] + Result;
    Dec(C);
  end;
end;

function TrimText(const Text: string): string;
begin
  Result := Text;
  while (Result <> '') and (Result[Length(Result)] in [#13, #10]) do
    Delete(Result, Length(Result), 1);
end;

function GetSelection: string;
var
  View: IOTAEditView;
begin
  Result := '';
  View := (BorlandIDEServices as IOTAEditorServices).TopView;
  if Assigned(View) and Assigned(View.Block) then
    Result := View.Block.Text;
end;


end.

