unit DTRest4D;

interface

uses
  System.SysUtils, System.Classes, REST.Client, REST.Types, REST.Json,
  System.Generics.Collections;

type
  TProgressEvent = reference to procedure(AProgress: Integer);
  TMiddleware = reference to procedure(var ARequest: TRESTRequest);

  IDTRestRequest = interface
    ['{B8A78964-4F62-47E3-B752-45CC4A4C9D88}']

    // Configuração
    function BaseURL(const AURL: string): IDTRestRequest;
    function Resource(const AResource: string): IDTRestRequest;
    function AddHeader(const AName, AValue: string): IDTRestRequest;
    function AddQueryParam(const AName, AValue: string): IDTRestRequest;
    function Accept(const AValue: string): IDTRestRequest;
    function ContentType(const AValue: string): IDTRestRequest;
    function UseOAuth2(const AToken: string): IDTRestRequest;
    function UseJWT(const AToken: string): IDTRestRequest;
    function EnableLogging(const ALogCallback: TProc<string>): IDTRestRequest;
    function AddMiddleware(AMiddleware: TMiddleware): IDTRestRequest;
    function OnProgress(AOnProgress: TProgressEvent): IDTRestRequest;

    // Métodos HTTP
    function Post(const ABody: string): string;
    function Put(const ABody: string): string;
    function Patch(const ABody: string): string;
    function Delete(const ABody: string): string;
    function Get: string;
    function Head: TRESTResponse;

    // Status
    function StatusCode: Integer;

    // Upload e Download
    function UploadFile(const AFileName: string; const AStream: TStream): string;
    function DownloadFile(const AResource: string; const AStream: TStream): Boolean;
    function ResumeDownloadFile(const AResource: string; const AFilePath: string): Boolean;
  end;

  TDTRestRequest = class(TInterfacedObject, IDTRestRequest)
  private
    FClient: TRESTClient;
    FRequest: TRESTRequest;
    FResponse: TRESTResponse;
    FLogCallback: TProc<string>;
    FProgressCallback: TProgressEvent;
    FMiddlewares: TList<TMiddleware>;
    procedure Log(const AMessage: string);
    procedure ExecuteMiddlewares;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IDTRestRequest;

    // Configuração
    function BaseURL(const AURL: string): IDTRestRequest;
    function Resource(const AResource: string): IDTRestRequest;
    function AddHeader(const AName, AValue: string): IDTRestRequest;
    function AddQueryParam(const AName, AValue: string): IDTRestRequest;
    function Accept(const AValue: string): IDTRestRequest;
    function ContentType(const AValue: string): IDTRestRequest;
    function UseOAuth2(const AToken: string): IDTRestRequest;
    function UseJWT(const AToken: string): IDTRestRequest;
    function EnableLogging(const ALogCallback: TProc<string>): IDTRestRequest;
    function AddMiddleware(AMiddleware: TMiddleware): IDTRestRequest;
    function OnProgress(AOnProgress: TProgressEvent): IDTRestRequest;

    // Métodos HTTP
    function Post(const ABody: string): string;
    function Put(const ABody: string): string;
    function Patch(const ABody: string): string;
    function Delete(const ABody: string): string;
    function Get: string;
    function Head: TRESTResponse;

    // Status
    function StatusCode: Integer;

    // Upload e Download
    function UploadFile(const AFileName: string; const AStream: TStream): string;
    function DownloadFile(const AResource: string; const AStream: TStream): Boolean;
    function ResumeDownloadFile(const AResource: string; const AFilePath: string): Boolean;
  end;

implementation

{ TDTRestRequest }

constructor TDTRestRequest.Create;
begin
  FClient := TRESTClient.Create(nil);
  FRequest := TRESTRequest.Create(nil);
  FResponse := TRESTResponse.Create(nil);
  FMiddlewares := TList<TMiddleware>.Create;

  FRequest.Client := FClient;
  FRequest.Response := FResponse;
end;

destructor TDTRestRequest.Destroy;
begin
  FMiddlewares.Free;
  FResponse.Free;
  FRequest.Free;
  FClient.Free;
  inherited;
end;

class function TDTRestRequest.New: IDTRestRequest;
begin
  Result := TDTRestRequest.Create;
end;

procedure TDTRestRequest.ExecuteMiddlewares;
var
  Middleware: TMiddleware;
begin
  for Middleware in FMiddlewares do
    Middleware(FRequest);
end;

procedure TDTRestRequest.Log(const AMessage: string);
begin
  if Assigned(FLogCallback) then
    FLogCallback(AMessage);
end;

function TDTRestRequest.BaseURL(const AURL: string): IDTRestRequest;
begin
  Result := Self;
  FClient.BaseURL := AURL;
  Log('BaseURL set to: ' + AURL);
end;

function TDTRestRequest.Resource(const AResource: string): IDTRestRequest;
begin
  Result := Self;
  FRequest.Resource := AResource;
  Log('Resource set to: ' + AResource);
end;

function TDTRestRequest.AddHeader(const AName, AValue: string): IDTRestRequest;
begin
  Result := Self;
  FRequest.Params.AddHeader(AName, AValue);
  Log(Format('Header added: %s=%s', [AName, AValue]));
end;

function TDTRestRequest.AddQueryParam(const AName, AValue: string): IDTRestRequest;
begin
  Result := Self;
  FRequest.Params.AddItem(AName, AValue, pkGETorPOST);
  Log(Format('Query parameter added: %s=%s', [AName, AValue]));
end;

function TDTRestRequest.Accept(const AValue: string): IDTRestRequest;
begin
  Result := Self;
  FRequest.Accept := AValue;
  Log('Accept set to: ' + AValue);
end;

function TDTRestRequest.ContentType(const AValue: string): IDTRestRequest;
begin
  Result := Self;
  FRequest.Params.ParameterByName('Content-Type').Value := AValue;
  Log('Content-Type set to: ' + AValue);
end;

function TDTRestRequest.UseOAuth2(const AToken: string): IDTRestRequest;
begin
  Result := Self;
  FRequest.Params.AddHeader('Authorization', 'Bearer ' + AToken);
  Log('OAuth2 token added.');
end;

function TDTRestRequest.UseJWT(const AToken: string): IDTRestRequest;
begin
  Result := Self;
  FRequest.Params.AddHeader('Authorization', 'JWT ' + AToken);
  Log('JWT token added.');
end;

function TDTRestRequest.EnableLogging(const ALogCallback: TProc<string>): IDTRestRequest;
begin
  Result := Self;
  FLogCallback := ALogCallback;
  Log('Logging enabled.');
end;

function TDTRestRequest.AddMiddleware(AMiddleware: TMiddleware): IDTRestRequest;
begin
  Result := Self;
  FMiddlewares.Add(AMiddleware);
  Log('Middleware added.');
end;

function TDTRestRequest.OnProgress(AOnProgress: TProgressEvent): IDTRestRequest;
begin
  Result := Self;
  FProgressCallback := AOnProgress;
end;

function TDTRestRequest.Post(const ABody: string): string;
begin
  FRequest.Method := rmPOST;
  if not ABody.IsEmpty then
    FRequest.AddBody(ABody, ctAPPLICATION_JSON);

  ExecuteMiddlewares;
  Log('POST request initiated with body: ' + ABody);
  FRequest.Execute;
  Log('Response: ' + FResponse.Content);
  Result := FResponse.Content;
end;

function TDTRestRequest.Put(const ABody: string): string;
begin
  FRequest.Method := rmPUT;
  if not ABody.IsEmpty then
    FRequest.AddBody(ABody, ctAPPLICATION_JSON);
  ExecuteMiddlewares;
  Log('PUT request initiated with body: ' + ABody);
  FRequest.Execute;
  Log('Response: ' + FResponse.Content);
  Result := FResponse.Content;
end;

function TDTRestRequest.Patch(const ABody: string): string;
begin
  FRequest.Method := rmPATCH;
  if not ABody.IsEmpty then
    FRequest.AddBody(ABody, ctAPPLICATION_JSON);
  ExecuteMiddlewares;
  Log('PATCH request initiated with body: ' + ABody);
  FRequest.Execute;
  Log('Response: ' + FResponse.Content);
  Result := FResponse.Content;
end;

function TDTRestRequest.Delete(const ABody: string): string;
begin
  FRequest.Method := rmDELETE;
  if not ABody.IsEmpty then
    FRequest.AddBody(ABody, ctAPPLICATION_JSON);
  ExecuteMiddlewares;
  Log('DELETE request initiated with body: ' + ABody);
  FRequest.Execute;
  Log('Response: ' + FResponse.Content);
  Result := FResponse.Content;
end;

function TDTRestRequest.Get: string;
begin
  FRequest.Method := rmGET;
  ExecuteMiddlewares;
  Log('GET request initiated.');
  FRequest.Execute;
  Log('Response: ' + FResponse.Content);
  Result := FResponse.Content;
end;

function TDTRestRequest.Head: TRESTResponse;
begin
  FRequest.Method := rmGET; // Simulando HEAD para compatibilidade
  ExecuteMiddlewares;
  Log('HEAD request simulated as GET.');
  FRequest.Execute;
  Result := FResponse;
end;

function TDTRestRequest.UploadFile(const AFileName: string; const AStream: TStream): string;
begin
  FRequest.Method := rmPOST;
  FRequest.AddBody(AStream, ctAPPLICATION_OCTET_STREAM);
  ExecuteMiddlewares;
  Log('File upload initiated: ' + AFileName);
  FRequest.Execute;
  Result := FResponse.Content;
end;

function TDTRestRequest.DownloadFile(const AResource: string; const AStream: TStream): Boolean;
begin
  Result := False;
  FRequest.Method := rmGET;
  FRequest.Resource := AResource;
  ExecuteMiddlewares;
  Log('File download initiated: ' + AResource);
  FRequest.Execute;
  if FResponse.StatusCode = 200 then
  begin
    AStream.WriteBuffer(FResponse.RawBytes, Length(FResponse.RawBytes));
    Result := True;
    Log('File downloaded successfully.');
  end;
end;

function TDTRestRequest.ResumeDownloadFile(const AResource: string; const AFilePath: string): Boolean;
var
  FileStream: TFileStream;
  FileSize: Int64;
  TotalSize: Int64;
begin
  Result := False;
  if FileExists(AFilePath) then
    FileSize := TFileStream.Create(AFilePath, fmOpenRead).Size
  else
    FileSize := 0;
  if FileSize > 0 then
    AddHeader('Range', Format('bytes=%d-', [FileSize]));
  FileStream := TFileStream.Create(AFilePath, fmOpenReadWrite or fmShareDenyNone);
  try
    if FileSize > 0 then
      FileStream.Seek(0, soEnd);
    FRequest.Method := rmGET;
    FRequest.Resource := AResource;
    ExecuteMiddlewares;
    Log(Format('Resuming download from byte %d', [FileSize]));
    FRequest.Execute;
    if (FResponse.StatusCode = 200) or (FResponse.StatusCode = 206) then
    begin
      TotalSize := FResponse.Headers.Values['Content-Range'].ToInt64;
      FileStream.WriteBuffer(FResponse.RawBytes, Length(FResponse.RawBytes));
      Log(Format('Downloaded %d of %d bytes', [FileStream.Size, TotalSize]));
      Result := FileStream.Size = TotalSize;
    end;
  finally
    FileStream.Free;
  end;
end;

function TDTRestRequest.StatusCode: Integer;
begin
   Log(Format('Status code: %s', [FResponse.StatusCode.ToString]));
   Result := FResponse.StatusCode;
end;

end.

