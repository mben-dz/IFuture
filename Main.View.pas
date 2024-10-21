unit Main.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  System.Threading, System.SyncObjs, Vcl.ExtCtrls, Vcl.ComCtrls,
//
  API.Future;

type
  TMainView = class(TForm)
    Pnl_Status: TPanel;
    Img_Future: TImage;
    Progress_Future: TProgressBar;
    Memo_Log: TMemo;
    Btn_Run: TButton;
    procedure Btn_RunClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    fAsyncStrRequest: IAsyncStrFuture;
    function QueryReply(const aRequest: string): string;
    function DoRequest(const aRequest: string): string;
  public
    { Public declarations }
  end;

var
  MainView: TMainView;

implementation

uses
  System.RegularExpressions,
  System.NetEncoding,
  API.Utils,
  API.ResData;

{$R *.dfm}

procedure TMainView.FormCreate(Sender: TObject);
begin
  fAsyncStrRequest := GetAsyncStrFutureReply
    (procedure (aLogMsg: string; aNewLine: Boolean) begin

      Memo_Log.Lines.Append(aLogMsg);

    end)
end;

function TMainView.DoRequest(const aRequest: string): string;
var
  LRegex: TRegEx;
  LMatch: TMatch;
begin

  LRegex := TRegEx.Create('src="data:image/png;base64,([^"]+)"');
  // Simulate network delay (3 seconds = 3000 milliseconds)
  Sleep(3000);
  try
    // Search for the Base64 string
    LMatch := LRegex.Match(aRequest);
    if LMatch.Success then
    begin
      fAsyncStrRequest.Log(LMatch.Groups[1].Value);
      fAsyncStrRequest.Log('Successfully Get "Base64 Image Code" ..');
    end
    else
    begin
      fAsyncStrRequest.Log('No Base64 image found.');
    end;
  except
    on Ex: Exception do
      fAsyncStrRequest.Log('Error: ' + Ex.Message);
  end;

  Result := LMatch.Groups[1].Value;
end;

function TMainView.QueryReply(const aRequest: string): string;
var
  LTaskList: array of ITask;
begin
  SetLength(LTaskList, 3);

  // Assign tasks to run in parallel
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  LTaskList[0] := TTask.Run(
    procedure
    begin
      Sleep(1000); // Simulate work
      fAsyncStrRequest.Log('Task [1] finished Successfully ..');
    end);

  LTaskList[1] := TTask.Run(
    procedure
    begin
      Sleep(2000); // Simulate work
      fAsyncStrRequest.Log('Task [2] finished Successfully ..');
    end);

  LTaskList[2] := TTask.Run(
    procedure
    begin
      Sleep(1500); // Simulate work
      fAsyncStrRequest.Log('Task [3] finished Successfully ..');
    end);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  // Wait for all tasks to complete ..
  TTask.WaitForAll(LTaskList);

  Result := DoRequest(aRequest);
end;

procedure TMainView.Btn_RunClick(Sender: TObject);
var
  LPicXPATHLink: string;
begin
  LPicXPATHLink := Format(PICTURE_XPATH_LINK, [LoadBase64ImageFromResource]);

  Img_Future.Picture.Graphic := nil;
  Memo_Log.Clear;

  Btn_Run.Enabled := False;
  try
    fAsyncStrRequest.AddQuery(
      function: string
      begin
        Result := QueryReply(LPicXPATHLink);
      end)
      .RunFuture(
      procedure(aResultFuture: string)
      begin
        try
          if aResultFuture <> '' then
          begin
            Img_Future.Picture.LoadFromBase64(aResultFuture);
            fAsyncStrRequest.Log('Image loaded successfully from Base64 string.');
          end else
            fAsyncStrRequest.Log('No valid Base64 image string found.');

        finally
          Btn_Run.Enabled := True;
        end;
      end);
  finally

  end;
end;

end.
