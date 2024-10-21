unit API.Future;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Threading,
  System.SyncObjs,
  System.Rtti;

type
  TReplyProc<T> = reference to procedure(Arg: T);
  TLogProc = TProc<string, Boolean>;

  TRequestType = TValue;

  IFutureReply = IFuture<string>;

  IAsyncFuture<TRequestType, TReplyProc> = interface ['{BA92C62C-2683-44DE-A616-E607DCFAED4C}']
    function AddQuery(aFuncProcess: TFunc<TRequestType>): IAsyncFuture<TRequestType, TReplyProc<string>>;
    procedure RunFuture(aReplyProc: TReplyProc<string>);

    procedure Log(const aLog: string);
  end;

  IAsyncStrFuture  = IAsyncFuture<string, TReplyProc<string>>;  // All cases return values as string
  IAsyncIntFuture  = IAsyncFuture<Integer, TReplyProc<string>>;
  IAsyncBoolFuture = IAsyncFuture<Boolean, TReplyProc<string>>;

  function GetAsyncStrFutureReply(aLogView: TLogProc): IAsyncStrFuture;
  function GetAsyncIntFutureReply(aLogView: TLogProc): IAsyncIntFuture;
  function GetAsyncBoolFutureReply(aLogView: TLogProc): IAsyncBoolFuture;

implementation

type
  TAsyncFuture<TQueryType, TReplyProc> = class(TInterfacedObject, IAsyncFuture<TQueryType, TReplyProc<string>>)
  strict private
    fTask: ITask;
    fFutureTask: IFutureReply;
    fOnReply: TReplyProc<string>;
    fOnLog: TLogProc;
    fLock: TCriticalSection;
    fProcess: TFunc<TQueryType>;
//    fRequest: string;

    procedure LogView(const aLog: string; aNewLine: Boolean = True);
    function DoRequest(aFuncProcess: TFunc<TQueryType>): string;
  private
    procedure Log(const aLog: string);
    function AddQuery(aFuncProcess: TFunc<TQueryType>): IAsyncFuture<TQueryType, TReplyProc<string>>;
    procedure RunFuture(aReplyProc: TReplyProc<string>);
  public
    constructor Create(aLogView: TLogProc);
    destructor Destroy; override;

  end;

function GetAsyncStrFutureReply(aLogView: TLogProc): IAsyncStrFuture;
begin
  Result := TAsyncFuture<string, TReplyProc<string>>
    .Create(aLogView) as IAsyncStrFuture;
end;

function GetAsyncIntFutureReply(aLogView: TLogProc): IAsyncIntFuture;
begin
  Result := TAsyncFuture<Integer, TReplyProc<string>>
    .Create(aLogView) as IAsyncIntFuture;
end;

function GetAsyncBoolFutureReply(aLogView: TLogProc): IAsyncBoolFuture;
begin
  Result := TAsyncFuture<Boolean, TReplyProc<string>>
    .Create(aLogView) as IAsyncBoolFuture;
end;

{ TAsyncFuture }

procedure TAsyncFuture<TQueryType, TReplyProc>
  .LogView(const aLog: string; aNewLine: Boolean);
begin
  if Assigned(fOnLog) then
  begin
    fLock.Acquire;
    try
      TThread.Queue(nil, procedure
      begin
        fOnLog(aLog, aNewLine);
      end);
    finally
      fLock.Release;
    end;
  end;
end;

procedure TAsyncFuture<TQueryType, TReplyProc>
  .Log(const aLog: string);
begin
  LogView(aLog);
end;

constructor TAsyncFuture<TQueryType, TReplyProc>
.Create(aLogView: TLogProc);

begin inherited Create;

  fLock  := TCriticalSection.Create;
  fOnLog := aLogView;
end;

destructor TAsyncFuture<TQueryType, TReplyProc>
.Destroy;
begin
  fLock.Free;

  inherited;
end;

function TAsyncFuture<TQueryType, TReplyProc>
  .AddQuery(
    aFuncProcess: TFunc<TQueryType>): IAsyncFuture<TQueryType, TReplyProc<string>>;
begin
  Result := Self as IAsyncFuture<TQueryType, TReplyProc<string>>;

//  fRequest := aRequest;
  fProcess := aFuncProcess;
end;

function TAsyncFuture<TQueryType, TReplyProc>
  .DoRequest(aFuncProcess: TFunc<TQueryType>): string;
var
  LQueryReply: TQueryType;
  LRttiValue: TValue;
begin
  LQueryReply := aFuncProcess();

  LRttiValue := TValue.From<TQueryType>(LQueryReply);

  Result := LRttiValue.ToString;
end;

procedure TAsyncFuture<TQueryType, TReplyProc>
  .RunFuture(aReplyProc: TReplyProc<string>);
begin
  fOnReply := aReplyProc;

  fTask := TTask.Run(procedure
  var
    LReply: string;
  begin
    fFutureTask := TTask.Future<string>(function: string
    begin
      Log('Processing request...');
      Result := DoRequest(fProcess);
    end);

    LReply := fFutureTask.Value;

    TThread.Queue(nil, procedure
    begin
      Log('Returning result...');
      fOnReply(LReply);
    end);
  end);
end;

end.
