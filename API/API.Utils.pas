unit API.Utils;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Types,
  Vcl.Graphics,
  Vcl.ExtCtrls,
  Vcl.Imaging.jpeg,
  Vcl.Imaging.GIFImg,
  Vcl.Imaging.pngimage;

type
  TMemoryStreamHelper = class helper for TMemoryStream
    function DecodeBase64: TMemoryStream; inline;
  end;

  TPictureHelper = class helper for Vcl.Graphics.TPicture
  public
    procedure LoadFromBase64(const aBase64: string);
  end;

function LoadBase64ImageFromResource: string;

implementation

uses
  System.NetEncoding;

function LoadBase64ImageFromResource: string;
var
  LResStream: TResourceStream;
  LBase64ImageStream: TStringStream;
begin
  LResStream := TResourceStream.Create(HInstance, 'BASE64IMAGE', RT_RCDATA);
  try
    LBase64ImageStream := TStringStream.Create;
    try
      LBase64ImageStream.CopyFrom(LResStream, LResStream.Size);
      Result := LBase64ImageStream.DataString;
    finally
      LBase64ImageStream.Free;
    end;
  finally
    LResStream.Free;
  end;
end;

{ TMemoryStreamHelper }

function TMemoryStreamHelper.DecodeBase64: TMemoryStream;
var
  LOutput: TMemoryStream;
begin
  LOutput := TMemoryStream.Create;
  try
    Position := 0;

    TNetEncoding.Base64.Decode(Self, LOutput);
    LOutput.Position := 0;
    Clear;
    LOutput.SaveToStream(Self);
  finally
    LOutput.Free;
  end;
  Position := 0;
  Result := Self;
end;

{ TPictureHelper }

procedure TPictureHelper.LoadFromBase64(const aBase64: string);
var
  LBase64Stream: TMemoryStream;
begin
  LBase64Stream := TStringStream.Create(aBase64).DecodeBase64;
  try
    Self.LoadFromStream(LBase64Stream)
  finally
    LBase64Stream.Free;
  end;
end;

end.
