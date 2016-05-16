unit DSSupportClasses;



interface



uses System.Classes, System.ZLib, System.SysUtils;



type

  TDSSupportZLib = class(TObject)

  private

    { private declarations }

  protected

    { protected declarations }

  public

    { public declarations }

    class function ZCompressString(aText: string): TBytes;overload;
    class function ZDecompressString(aText: TBytes): string; overload;

    //http://www.codeproject.com/Articles/516096/String-compression-decompression-routines-using-De
    class function ZCompressString(aText: string; aCompressionLevel: TZCompressionLevel): string;overload;
    class function ZDecompressString(aText: string): string;overload;
    class function ZCompressStringTeste(aText: string): string;overload;

  end;



implementation



{ TDSSupport }



class function TDSSupportZLib.ZCompressString(aText: string): TBytes;

var

  strInput: TBytesStream;

  strOutput: TBytesStream;

  Zipper: TZCompressionStream;

begin

  SetLength(Result, 0);

  strInput := TBytesStream.Create(TEncoding.UTF8.GetBytes(aText));

  strOutput := TBytesStream.Create;

  try

    Zipper := TZCompressionStream.Create(TCompressionLevel.clMax, strOutput);

    try

      Zipper.CopyFrom(strInput, strInput.size);

    finally

      Zipper.Free;

    end;

    Result := Copy(strOutput.Bytes, 0, strOutput.size);

  finally

    strInput.Free;

    strOutput.Free;

  end;

end;





class function TDSSupportZLib.ZCompressString(aText: string;
  aCompressionLevel: TZCompressionLevel): string;
var
  strInput,
  strOutput: TStringStream;
  Zipper: TZCompressionStream;
begin
  Result:= '';
  strInput:= TStringStream.Create(aText);
  strOutput:= TStringStream.Create;
  try
    //Zipper:= TZCompressionStream.Create(strOutput, aCompressionLevel);
    Zipper := TZCompressionStream.Create(TCompressionLevel.clMax, strOutput);

    try
      Zipper.CopyFrom(strInput, strInput.Size);
    finally
      Zipper.Free;
    end;
    Result:= strOutput.DataString;
  finally
    strInput.Free;
    strOutput.Free;
  end;
end;

class function TDSSupportZLib.ZCompressStringTeste(aText: string): string;
var
  strInput,
  strOutput: TStringStream;
  Zipper: TZCompressionStream;
begin
  Result:= '';
  strInput:= TStringStream.Create(aText,TEncoding.UTF8);
  strOutput:= TStringStream.Create;
  try
    //Zipper:= TZCompressionStream.Create(strOutput, aCompressionLevel);
    Zipper := TZCompressionStream.Create(TCompressionLevel.clMax, strOutput);

    try
      Zipper.CopyFrom(strInput, strInput.Size);
    finally
      Zipper.Free;
    end;
    Result:= utf8encode(strOutput.DataString);
  finally
    strInput.Free;
    strOutput.Free;
  end;
end;

class function TDSSupportZLib.ZDecompressString(aText: string): string;
var
  strInput,
  strOutput: TStringStream;
  Unzipper: TZDecompressionStream;
begin
  Result:= '';
  strInput:= TStringStream.Create(aText);
  strOutput:= TStringStream.Create;
  try
    Unzipper:= TZDecompressionStream.Create(strInput);
    try
      strOutput.CopyFrom(Unzipper, Unzipper.Size);
    finally
      Unzipper.Free;
    end;
    Result:= strOutput.DataString;
  finally
    strInput.Free;
    strOutput.Free;
  end;
end;

class function TDSSupportZLib.ZDecompressString(aText: TBytes): string;

var

  strInput: TBytesStream;

  strOutput: TBytesStream;

  UnZipper: TZDecompressionStream;

begin

  Result := '';

  strInput := TBytesStream.Create(aText);

  strOutput := TBytesStream.Create;

  try

    UnZipper := TZDecompressionStream.Create(strInput);

    try

      try

        strOutput.CopyFrom(UnZipper, 0);

      except

        on E: Exception do

        begin

          raise Exception.Create('Error Message: ' + E.Message);

        end;

      end;

    finally

      UnZipper.Free;

    end;

    Result := TEncoding.UTF8.GetString(strOutput.Bytes, 0, strOutput.size);

  finally

    strInput.Free;

    strOutput.Free;

  end;

end;



end.