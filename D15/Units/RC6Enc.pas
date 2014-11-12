unit RC6Enc;

interface

uses Sysutils, Classes;

const
  NUMROUNDS = 20;

type
  TRC6Data = record
    IV, LB: array[0..15] of byte;
    KeyData: array[0..((NUMROUNDS * 2) + 3)] of LongWord;
  end;

  EWrongPassword = class(Exception);
  EInvalidFile = class(Exception);

function B64Encode(const S: string): string;
function B64Decode(const S: string): string;

function Decrypt(S, Key: string): string; overload;
function Encrypt(S, Key: string): string; overload;

function Encrypt(N, Key: Integer): Integer; overload;
function Decrypt(N, Key: Integer): Integer; overload;

procedure EncryptStream(Stream: TStream; Key: string);
procedure DecryptStream(Stream: TStream; Key: string);

function HasEncHeader(Stream: TStream): Boolean;

procedure EncodeStream(Stream: TStream);
procedure DecodeStream(Stream: TStream);

function LRot16(X: Word; c: longint): Word;
function RRot16(X: Word; c: longint): Word;
function LRot32(X: LongWord; c: longint): LongWord;
function RRot32(X: LongWord; c: longint): LongWord;
function SwapDWord(X: LongWord): LongWord;
procedure XorBlock(I1, I2, O1: PByteArray; Len: longint);

procedure RC6Init(var Data: TRC6Data; var Key; Size: longint; IVector: pointer);
procedure RC6Reset(var Data: TRC6Data);
procedure RC6Burn(var Data: TRC6Data);
procedure RC6EncryptECB(var Data: TRC6Data; const InBlock; var OutBlock);
procedure RC6DecryptECB(var Data: TRC6Data; const InBlock; var OutBlock);
procedure RC6EncryptCBC(var Data: TRC6Data; const InData; var OutData; Size: longint);
procedure RC6DecryptCBC(var Data: TRC6Data; const InData; var OutData; Size: longint);
procedure RC6EncryptCFB(var Data: TRC6Data; const InData; var OutData; Size: longint);
procedure RC6DecryptCFB(var Data: TRC6Data; const InData; var OutData; Size: longint);

implementation

const
  B64Table = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  CodePage = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/-_''~`{}[]<>,./?|!@#$%*()Á«·¡‡¿';

  sBox: array[0..51] of LongWord = (
    $B7E15163, $5618CB1C, $F45044D5, $9287BE8E, $30BF3847, $CEF6B200,
    $6D2E2BB9, $0B65A572, $A99D1F2B, $47D498E4, $E60C129D, $84438C56,
    $227B060F, $C0B27FC8, $5EE9F981, $FD21733A, $9B58ECF3, $399066AC,
    $D7C7E065, $75FF5A1E, $1436D3D7, $B26E4D90, $50A5C749, $EEDD4102,
    $8D14BABB, $2B4C3474, $C983AE2D, $67BB27E6, $05F2A19F, $A42A1B58,
    $42619511, $E0990ECA, $7ED08883, $1D08023C, $BB3F7BF5, $5976F5AE,
    $F7AE6F67, $95E5E920, $341D62D9, $D254DC92, $708C564B, $0EC3D004,
    $ACFB49BD, $4B32C376, $E96A3D2F, $87A1B6E8, $25D930A1, $C410AA5A,
    $62482413, $007F9DCC, $9EB71785, $3CEE913E);

function B64Encode;
var
  i: integer;
  InBuf: array[0..2] of byte;
  OutBuf: array[0..3] of char;
begin
  SetLength(Result, ((Length(S) + 2) div 3) * 4);
  for i := 1 to ((Length(S) + 2) div 3) do
  begin
    if Length(S) < (i * 3) then
      Move(S[(i - 1) * 3 + 1], InBuf, Length(S) - (i - 1) * 3)
    else
      Move(S[(i - 1) * 3 + 1], InBuf, 3);
    OutBuf[0] := B64Table[((InBuf[0] and $FC) shr 2) + 1];
    OutBuf[1] := B64Table[(((InBuf[0] and $03) shl 4) or ((InBuf[1] and $F0) shr 4)) + 1];
    OutBuf[2] := B64Table[(((InBuf[1] and $0F) shl 2) or ((InBuf[2] and $C0) shr 6)) + 1];
    OutBuf[3] := B64Table[(InBuf[2] and $3F) + 1];
    Move(OutBuf, Result[(i - 1) * 4 + 1], 4);
  end;
  if (Length(S) mod 3) = 1 then
  begin
    Result[Length(Result) - 1] := '=';
    Result[Length(Result)] := '=';
  end
  else if (Length(S) mod 3) = 2 then
    Result[Length(Result)] := '=';
end;

function B64Decode;
var
  i: integer;
  InBuf: array[0..3] of byte;
  OutBuf: array[0..2] of byte;
begin
  if (Length(S) mod 4) <> 0 then
  begin
    raise Exception.Create('Base64: Incorrect string format');
    Exit;
  end;
{$WARNINGS OFF}
  SetLength(Result, ((Length(S) div 4) - 1) * 3);
  for i := 1 to ((Length(S) div 4) - 1) do
  begin
    Move(S[(i - 1) * 4 + 1], InBuf, 4);
    if (InBuf[0] > 64) and (InBuf[0] < 91) then
      Dec(InBuf[0], 65)
    else if (InBuf[0] > 96) and (InBuf[0] < 123) then
      Dec(InBuf[0], 71)
    else if (InBuf[0] > 47) and (InBuf[0] < 58) then
      Inc(InBuf[0], 4)
    else if InBuf[0] = 43 then
      InBuf[0] := 62
    else
      InBuf[0] := 63;
    if (InBuf[1] > 64) and (InBuf[1] < 91) then
      Dec(InBuf[1], 65)
    else if (InBuf[1] > 96) and (InBuf[1] < 123) then
      Dec(InBuf[1], 71)
    else if (InBuf[1] > 47) and (InBuf[1] < 58) then
      Inc(InBuf[1], 4)
    else if InBuf[1] = 43 then
      InBuf[1] := 62
    else
      InBuf[1] := 63;
    if (InBuf[2] > 64) and (InBuf[2] < 91) then
      Dec(InBuf[2], 65)
    else if (InBuf[2] > 96) and (InBuf[2] < 123) then
      Dec(InBuf[2], 71)
    else if (InBuf[2] > 47) and (InBuf[2] < 58) then
      Inc(InBuf[2], 4)
    else if InBuf[2] = 43 then
      InBuf[2] := 62
    else
      InBuf[2] := 63;
    if (InBuf[3] > 64) and (InBuf[3] < 91) then
      Dec(InBuf[3], 65)
    else if (InBuf[3] > 96) and (InBuf[3] < 123) then
      Dec(InBuf[3], 71)
    else if (InBuf[3] > 47) and (InBuf[3] < 58) then
      Inc(InBuf[3], 4)
    else if InBuf[3] = 43 then
      InBuf[3] := 62
    else
      InBuf[3] := 63;
    OutBuf[0] := (InBuf[0] shl 2) or ((InBuf[1] shr 4) and $03);
    OutBuf[1] := (InBuf[1] shl 4) or ((InBuf[2] shr 2) and $0F);
    OutBuf[2] := (InBuf[2] shl 6) or (InBuf[3] and $3F);
    Move(OutBuf, Result[(i - 1) * 3 + 1], 3);
  end;
  if Length(S) <> 0 then
  begin
    Move(S[Length(S) - 3], InBuf, 4);
    if InBuf[2] = 61 then
    begin
      if (InBuf[0] > 64) and (InBuf[0] < 91) then
        Dec(InBuf[0], 65)
      else if (InBuf[0] > 96) and (InBuf[0] < 123) then
        Dec(InBuf[0], 71)
      else if (InBuf[0] > 47) and (InBuf[0] < 58) then
        Inc(InBuf[0], 4)
      else if InBuf[0] = 43 then
        InBuf[0] := 62
      else
        InBuf[0] := 63;
      if (InBuf[1] > 64) and (InBuf[1] < 91) then
        Dec(InBuf[1], 65)
      else if (InBuf[1] > 96) and (InBuf[1] < 123) then
        Dec(InBuf[1], 71)
      else if (InBuf[1] > 47) and (InBuf[1] < 58) then
        Inc(InBuf[1], 4)
      else if InBuf[1] = 43 then
        InBuf[1] := 62
      else
        InBuf[1] := 63;
      OutBuf[0] := (InBuf[0] shl 2) or ((InBuf[1] shr 4) and $03);
      Result := Result + char(OutBuf[0]);
    end
    else if InBuf[3] = 61 then
    begin
      if (InBuf[0] > 64) and (InBuf[0] < 91) then
        Dec(InBuf[0], 65)
      else if (InBuf[0] > 96) and (InBuf[0] < 123) then
        Dec(InBuf[0], 71)
      else if (InBuf[0] > 47) and (InBuf[0] < 58) then
        Inc(InBuf[0], 4)
      else if InBuf[0] = 43 then
        InBuf[0] := 62
      else
        InBuf[0] := 63;
      if (InBuf[1] > 64) and (InBuf[1] < 91) then
        Dec(InBuf[1], 65)
      else if (InBuf[1] > 96) and (InBuf[1] < 123) then
        Dec(InBuf[1], 71)
      else if (InBuf[1] > 47) and (InBuf[1] < 58) then
        Inc(InBuf[1], 4)
      else if InBuf[1] = 43 then
        InBuf[1] := 62
      else
        InBuf[1] := 63;
      if (InBuf[2] > 64) and (InBuf[2] < 91) then
        Dec(InBuf[2], 65)
      else if (InBuf[2] > 96) and (InBuf[2] < 123) then
        Dec(InBuf[2], 71)
      else if (InBuf[2] > 47) and (InBuf[2] < 58) then
        Inc(InBuf[2], 4)
      else if InBuf[2] = 43 then
        InBuf[2] := 62
      else
        InBuf[2] := 63;
      OutBuf[0] := (InBuf[0] shl 2) or ((InBuf[1] shr 4) and $03);
      OutBuf[1] := (InBuf[1] shl 4) or ((InBuf[2] shr 2) and $0F);
      Result := Result + char(OutBuf[0]) + char(OutBuf[1]);
    end
    else
    begin
      if (InBuf[0] > 64) and (InBuf[0] < 91) then
        Dec(InBuf[0], 65)
      else if (InBuf[0] > 96) and (InBuf[0] < 123) then
        Dec(InBuf[0], 71)
      else if (InBuf[0] > 47) and (InBuf[0] < 58) then
        Inc(InBuf[0], 4)
      else if InBuf[0] = 43 then
        InBuf[0] := 62
      else
        InBuf[0] := 63;
      if (InBuf[1] > 64) and (InBuf[1] < 91) then
        Dec(InBuf[1], 65)
      else if (InBuf[1] > 96) and (InBuf[1] < 123) then
        Dec(InBuf[1], 71)
      else if (InBuf[1] > 47) and (InBuf[1] < 58) then
        Inc(InBuf[1], 4)
      else if InBuf[1] = 43 then
        InBuf[1] := 62
      else
        InBuf[1] := 63;
      if (InBuf[2] > 64) and (InBuf[2] < 91) then
        Dec(InBuf[2], 65)
      else if (InBuf[2] > 96) and (InBuf[2] < 123) then
        Dec(InBuf[2], 71)
      else if (InBuf[2] > 47) and (InBuf[2] < 58) then
        Inc(InBuf[2], 4)
      else if InBuf[2] = 43 then
        InBuf[2] := 62
      else
        InBuf[2] := 63;
      if (InBuf[3] > 64) and (InBuf[3] < 91) then
        Dec(InBuf[3], 65)
      else if (InBuf[3] > 96) and (InBuf[3] < 123) then
        Dec(InBuf[3], 71)
      else if (InBuf[3] > 47) and (InBuf[3] < 58) then
        Inc(InBuf[3], 4)
      else if InBuf[3] = 43 then
        InBuf[3] := 62
      else
        InBuf[3] := 63;
      OutBuf[0] := (InBuf[0] shl 2) or ((InBuf[1] shr 4) and $03);
      OutBuf[1] := (InBuf[1] shl 4) or ((InBuf[2] shr 2) and $0F);
      OutBuf[2] := (InBuf[2] shl 6) or (InBuf[3] and $3F);
      Result := Result + char(OutBuf[0]) + char(OutBuf[1]) + char(OutBuf[2]);
    end;
  end;
end;

procedure EncodeStream(Stream: TStream);
const
  MaxBufSize = $B400;
var
  BufSize, N, Size: LongWord;
  InBuff, OutBuff: string;
  Tmp: TStream;
begin
  Size := Stream.Size;
  Tmp := TMemoryStream.Create;
  Stream.Position := 0;

  if Size > MaxBufSize then
    BufSize := MaxBufSize
  else
    BufSize := Size;

  SetLength(InBuff, BufSize);
  while Size <> 0 do
  begin
    if Size > BufSize then
      N := BufSize
    else
      N := Size;

    Stream.ReadBuffer(InBuff[1], N);
    OutBuff := B64Encode(Copy(InBuff, 1, N));
    Tmp.WriteBuffer(OutBuff[1], Length(OutBuff));
    Dec(Size, N);
  end;
  Stream.Size := 0;
  Stream.CopyFrom(Tmp, 0);
  Tmp.Free;
end;

procedure DecodeStream(Stream: TStream);
const
  MaxBufSize = $F000;
var
  BufSize, N, Size: LongWord;
  InBuff, OutBuff: string;
  Tmp: TStream;
begin
  Size := Stream.Size;
  Tmp := TMemoryStream.Create;
  Stream.Position := 0;

  if Size > MaxBufSize then
    BufSize := MaxBufSize
  else
    BufSize := Size;

  SetLength(InBuff, BufSize);
  while Size <> 0 do
  begin
    if Size > BufSize then
      N := BufSize
    else
      N := Size;

    Stream.ReadBuffer(InBuff[1], N);
    OutBuff := B64Decode(Copy(InBuff, 1, N));
    Tmp.WriteBuffer(OutBuff[1], Length(OutBuff));
    Dec(Size, N);
  end;
  Stream.Size := 0;
  Stream.CopyFrom(Tmp, 0);
  Tmp.Free;
end;

function Encrypt(S, Key: string): string;
var
  i: integer;
  RC6Data: TRC6Data;
begin
  i := Length(S);
  if i < 8 then
  begin
    SetLength(S, 8);
    FillChar(S[i + 1], 8 - i, #32);
  end;

  SetLength(Result, Length(S));
  RC6Init(RC6Data, Key[1], Length(Key) * 8, nil);
  RC6EncryptCFB(RC6Data, S[1], Result[1], Length(S));
  RC6Burn(RC6Data);

  Result := B64Encode(Result);
end;

function Decrypt(S, Key: string): string;
var
  RC6Data: TRC6Data;
begin
  S := B64Decode(S);

  SetLength(Result, Length(S));
  RC6Init(RC6Data, Key[1], Length(Key) * 8, nil);
  RC6DecryptCFB(RC6Data, S[1], Result[1], Length(S));
  RC6Burn(RC6Data);

  Result := Trim(Result);
end;

function Encrypt(N, Key: Integer): Integer; overload;
var
  RC6Data: TRC6Data;
begin
  RC6Init(RC6Data, Key, SizeOf(Integer) * 8, nil);
  RC6EncryptCFB(RC6Data, N, Result, SizeOf(Integer));
end;

function Decrypt(N, Key: Integer): Integer; overload;
var
  RC6Data: TRC6Data;
begin
  RC6Init(RC6Data, Key, SizeOf(Integer) * 8, nil);
  RC6DecryptCFB(RC6Data, N, Result, SizeOf(Integer));
end;

procedure EncryptStream(Stream: TStream; Key: string);
const
  MaxBufSize = $F000;
  Header = '0000ENC';
var
  RC6Data: TRC6Data;
  BufSize, N, iSize: LongWord;
  Buffer: array[1..MaxBufSize] of char;
  vKey: array[1..50] of char;
  Tmp: TStream;
begin
  if Stream.Size = 0 then Exit;

  iSize := Stream.Size;
  Stream.Position := 0;

  FillChar(vKey, 50, 0);
  N := Length(Key);
  if N > 50 then N := 50;
  Move(Key[1], vKey, N);
  RC6Init(RC6Data, vKey, SizeOf(vKey) * 8, nil);
  RC6EncryptCFB(RC6Data, vKey, vKey, 50);

  Tmp := TMemoryStream.Create;
  Tmp.Write(Header, Length(Header)); // Flag q mostra q o arquivo esta encriptado
  Tmp.Write(vKey, 50);

  if iSize > MaxBufSize then
    BufSize := MaxBufSize
  else
    BufSize := iSize;

  while iSize <> 0 do
  begin
    if iSize > BufSize then
      N := BufSize
    else
      N := iSize;

    Stream.ReadBuffer(Buffer[1], N);
    RC6EncryptCFB(RC6Data, Buffer[1], Buffer[1], N);
    Tmp.WriteBuffer(Buffer[1], N);
    Dec(iSize, N);
  end;

  RC6Burn(RC6Data);
  Stream.Size := 0;
  Stream.CopyFrom(Tmp, 0);
  Tmp.Free;
end;

function HasEncHeader(Stream: TStream): Boolean;
const
  Header = '0000ENC';
var
  Buffer: array[1..Length(Header)] of char;
  c: byte;
begin
  c := 1;

  Result := True;

  Stream.Read(Buffer[1], Length(Header));

  while Result and (c <= 7) do
  begin
    Result := Buffer[c] = Header[c];
    Inc(c);
  end;
end;

procedure DecryptStream(Stream: TStream; Key: string);
const
  MaxBufSize = $F000;
  Header = '0000ENC';
var
  RC6Data: TRC6Data;
  c: byte;
  BufSize, N, iSize: LongWord;
  Buffer: array[1..MaxBufSize] of char;
  vKey: array[1..50] of char;
  Tmp: TStream;
  bOk: Boolean;
begin
  if Stream.Size = 0 then Exit;

  iSize := Stream.Size;
  Stream.Position := 0;

  FillChar(vKey, 50, 0);
  N := Length(Key);
  if N > 50 then N := 50;
  Move(Key[1], vKey, N);
  RC6Init(RC6Data, vKey, SizeOf(vKey) * 8, nil);
  RC6EncryptCFB(RC6Data, vKey[1], vKey[1], 50);

  bOk := HasEncHeader(Stream);
  if not bOk then
{$IFDEF MAXSECURITY}
    raise EInvalidFile.Create('Arquivo Inv·lido');
{$ELSE}
    Exit;
{$ENDIF}

  Stream.Read(Buffer[1], 50);

  c := 1;
  while bOk and (c <= 50) do
  begin
    bOk := Buffer[c] = vKey[c];
    Inc(c);
  end;

  if not bOk then
  begin
    raise EWrongPassword.Create('Senha Inv·lida');
    Exit;
  end;

  Tmp := TMemoryStream.Create;
  Dec(iSize, 57);

  if iSize > MaxBufSize then
    BufSize := MaxBufSize
  else
    BufSize := iSize;

  while iSize <> 0 do
  begin
    if iSize > BufSize then
      N := BufSize
    else
      N := iSize;

    Stream.ReadBuffer(Buffer[1], N);
    RC6DecryptCFB(RC6Data, Buffer[1], Buffer[1], N);
    Tmp.WriteBuffer(Buffer[1], N);
    Dec(iSize, N);
  end;

  RC6Burn(RC6Data);
  Stream.Size := 0;
  Stream.CopyFrom(Tmp, 0);
  Tmp.Free;
end;

function LRot16(X: Word; c: longint): Word;
asm
  mov ecx,&c
  mov ax,&X
  rol ax,cl
  mov &Result,ax
end;

function RRot16(X: Word; c: longint): Word;
asm
  mov ecx,&c
  mov ax,&X
  ror ax,cl
  mov &Result,ax
end;

function LRot32(X: LongWord; c: longint): LongWord; register;
asm
  mov ecx, edx
  rol eax, cl
end;

function RRot32(X: LongWord; c: longint): LongWord; register;
asm
  mov ecx, edx
  ror eax, cl
end;

function SwapDWord(X: LongWord): LongWord; register;
asm
  xchg al,ah
  rol  eax,16
  xchg al,ah
end;

procedure XorBlock(I1, I2, O1: PByteArray; Len: longint);
var
  i: longint;
begin
  for i := 0 to Len - 1 do
    O1^[i] := I1^[i] xor I2^[i];
end;

procedure RC6EncryptECB;
var
  X: array[0..3] of LongWord;
  u, t: LongWord;
  i: longint;
begin
  with Data do
  begin
    Move(InBlock, X, SizeOf(X));
    X[1] := X[1] + KeyData[0];
    X[3] := X[3] + KeyData[1];
    for i := 1 to NUMROUNDS do
    begin
      t := LRot32(X[1] * (2 * X[1] + 1), 5);
      u := LRot32(X[3] * (2 * X[3] + 1), 5);
      X[0] := LRot32(X[0] xor t, u) + KeyData[2 * i];
      X[2] := LRot32(X[2] xor u, t) + KeyData[2 * i + 1];
      t := X[0];
      X[0] := X[1];
      X[1] := X[2];
      X[2] := X[3];
      X[3] := t;
    end;
    X[0] := X[0] + KeyData[(2 * NUMROUNDS) + 2];
    X[2] := X[2] + KeyData[(2 * NUMROUNDS) + 3];
    Move(X, OutBlock, SizeOf(X));
  end;
end;

procedure RC6DecryptECB;
var
  X: array[0..3] of LongWord;
  u, t: LongWord;
  i: longint;
begin
  with Data do
  begin
    Move(InBlock, X, SizeOf(X));
    X[2] := X[2] - KeyData[(2 * NUMROUNDS) + 3];
    X[0] := X[0] - KeyData[(2 * NUMROUNDS) + 2];
    for i := NUMROUNDS downto 1 do
    begin
      t := X[0];
      X[0] := X[3];
      X[3] := X[2];
      X[2] := X[1];
      X[1] := t;
      u := LRot32(X[3] * (2 * X[3] + 1), 5);
      t := LRot32(X[1] * (2 * X[1] + 1), 5);
      X[2] := RRot32(X[2] - KeyData[2 * i + 1], t) xor u;
      X[0] := RRot32(X[0] - KeyData[2 * i], u) xor t;
    end;
    X[3] := X[3] - KeyData[1];
    X[1] := X[1] - KeyData[0];
    Move(X, OutBlock, SizeOf(X));
  end;
end;

procedure RC6Init;
var
  xKeyD: array[0..63] of LongWord;
  i, j, k, xKeyLen: longint;
  A, B: LongWord;
begin
  if (Size > 2048) or (Size <= 0) or ((Size mod 8) <> 0) then
    Exit;

  with Data do
  begin
    Size := Size div 8;
    FillChar(xKeyD, SizeOf(xKeyD), 0);
    Move(Key, xKeyD, Size);
    xKeyLen := Size div 4;
    if (Size mod 4) <> 0 then
      Inc(xKeyLen);
    Move(sBox, KeyData, ((NUMROUNDS * 2) + 4) * 4);
    i := 0;
    j := 0;
    A := 0;
    B := 0;
    if xKeyLen > ((NUMROUNDS * 2) + 4) then
      k := xKeyLen * 3
    else
      k := ((NUMROUNDS * 2) + 4) * 3;
    for k := 1 to k do
    begin
      A := LRot32(KeyData[i] + A + B, 3);
      KeyData[i] := A;
      B := LRot32(xKeyD[j] + A + B, A + B);
      xKeyD[j] := B;
      i := (i + 1) mod ((NUMROUNDS * 2) + 4);
      j := (j + 1) mod xKeyLen;
    end;
    FillChar(xKeyD, SizeOf(xKeyD), 0);

    if IVector = nil then
    begin
      FillChar(IV, SizeOf(IV), $FF);
      RC6EncryptECB(Data, IV, IV);
      Move(IV, LB, SizeOf(LB));
    end
    else
    begin
      Move(IVector^, IV, SizeOf(IV));
      Move(IV, LB, SizeOf(IV));
    end;
  end;
end;

procedure RC6Burn;
begin
  with Data do
  begin
    FillChar(KeyData, SizeOf(KeyData), $FF);
    FillChar(IV, SizeOf(IV), $FF);
    FillChar(LB, SizeOf(LB), $FF);
  end;
end;

procedure RC6Reset;
begin
  with Data do
    Move(IV, LB, SizeOf(LB));
end;

procedure RC6EncryptCBC;
var
  TB: array[0..15] of byte;
  i: longint;
begin
  with Data do
  begin
    for i := 1 to (Size div 16) do
    begin
      XorBlock(pointer(longint(@InData) + ((i - 1) * 16)), @LB, @TB, SizeOf(TB));
      RC6EncryptECB(Data, TB, TB);
      Move(TB, pointer(longint(@OutData) + ((i - 1) * 16))^, SizeOf(TB));
      Move(TB, LB, SizeOf(TB));
    end;
    if (Size mod 16) <> 0 then
    begin
      RC6EncryptECB(Data, LB, TB);
      XorBlock(@TB, @pointer(longint(@InData) + Size - (Size mod 16))^, @pointer(longint(@OutData) + Size - (Size mod 16))^, Size mod 16);
    end;
    FillChar(TB, SizeOf(TB), $FF);
  end;
end;

procedure RC6DecryptCBC;
var
  TB: array[0..15] of byte;
  i: longint;
begin
  with Data do
  begin
    for i := 1 to (Size div 16) do
    begin
      Move(pointer(longint(@InData) + ((i - 1) * 16))^, TB, SizeOf(TB));
      RC6DecryptECB(Data, pointer(longint(@InData) + ((i - 1) * 16))^, pointer(longint(@OutData) + ((i - 1) * 16))^);
      XorBlock(@LB, pointer(longint(@OutData) + ((i - 1) * 16)), pointer(longint(@OutData) + ((i - 1) * 16)), SizeOf(TB));
      Move(TB, LB, SizeOf(TB));
    end;
    if (Size mod 16) <> 0 then
    begin
      RC6EncryptECB(Data, LB, TB);
      XorBlock(@TB, @pointer(longint(@InData) + Size - (Size mod 16))^, @pointer(longint(@OutData) + Size - (Size mod 16))^, Size mod 16);
    end;
    FillChar(TB, SizeOf(TB), $FF);
  end;
end;

procedure RC6EncryptCFB;
var
  i: longint;
  TB: array[0..15] of byte;
begin
  with Data do
  begin
    for i := 0 to Size - 1 do
    begin
      RC6EncryptECB(Data, LB, TB);
      PByteArray(@OutData)^[i] := PByteArray(@InData)^[i] xor TB[0];
      Move(LB[1], LB[0], 15);
      LB[15] := PByteArray(@OutData)^[i];
    end;
  end;
end;

procedure RC6DecryptCFB;
var
  i: longint;
  TB: array[0..15] of byte;
  B: byte;
begin
  with Data do
  begin
    for i := 0 to Size - 1 do
    begin
      B := PByteArray(@InData)^[i];
      RC6EncryptECB(Data, LB, TB);
      PByteArray(@OutData)^[i] := PByteArray(@InData)^[i] xor TB[0];
      Move(LB[1], LB[0], 15);
      LB[15] := B;
    end;
  end;
end;

end.

