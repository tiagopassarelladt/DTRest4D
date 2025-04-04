unit DTRest4D;

interface

uses
  System.SysUtils,
  System.Classes,
  REST.Client,
  REST.Types,
  REST.Json,
  REST.Authenticator.Basic,
  System.Generics.Collections,
  System.NetEncoding;

type
  TProgressEvent = reference to procedure(AProgress: Integer);
  TMiddleware = reference to procedure(var ARequest: TRESTRequest);

  IDTRestRequest = interface
    ['{B8A78964-4F62-47E3-B752-45CC4A4C9D88}']

    // Configuração
    function BaseURL(const AURL: string; ADotEncode: Boolean = False): IDTRestRequest;
    function Resource(const AResource: string; ADotEncode: Boolean = False): IDTRestRequest;
    function AddHeader(const AName, AValue: string; ADotEncode: Boolean = False): IDTRestRequest;
    function AddQueryParam(const AName, AValue: string; ADotEncode: Boolean = False): IDTRestRequest;
    function Accept(const AValue: string; ADotEncode: Boolean = False): IDTRestRequest;
    function ContentType(const AValue: string; ADotEncode: Boolean = False): IDTRestRequest;
    function UseOAuth2(const AToken: string; ADotEncode: Boolean = False): IDTRestRequest;
    function UseJWT(const AToken: string; ADotEncode: Boolean = False): IDTRestRequest;
    function EnableLogging(const ALogCallback: TProc<string>): IDTRestRequest;
    function AddMiddleware(AMiddleware: TMiddleware): IDTRestRequest;
    function OnProgress(AOnProgress: TProgressEvent): IDTRestRequest;
    function Timeout(const ATimeoutMS: Integer): IDTRestRequest;
    function BasicAuthentication(const AUsername, APassword: string; ADotEncode: Boolean = False): IDTRestRequest;
    function UseDecodeResponse(const AUseDecodeResponse: Boolean): IDTRestRequest;

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
    FUseDecodeResponse: Boolean;
    procedure Log(const AMessage: string);
    procedure ExecuteMiddlewares;
    function DotEncode(const AValue: string): string;
    function DotDecode(const AValue: string): string;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IDTRestRequest;

    // Configuração
    function BaseURL(const AURL: string; ADotEncode: Boolean = False): IDTRestRequest;
    function Resource(const AResource: string; ADotEncode: Boolean = False): IDTRestRequest;
    function AddHeader(const AName, AValue: string; ADotEncode: Boolean = False): IDTRestRequest;
    function AddQueryParam(const AName, AValue: string; ADotEncode: Boolean = False): IDTRestRequest;
    function Accept(const AValue: string; ADotEncode: Boolean = False): IDTRestRequest;
    function ContentType(const AValue: string; ADotEncode: Boolean = False): IDTRestRequest;
    function UseOAuth2(const AToken: string; ADotEncode: Boolean = False): IDTRestRequest;
    function UseJWT(const AToken: string; ADotEncode: Boolean = False): IDTRestRequest;
    function EnableLogging(const ALogCallback: TProc<string>): IDTRestRequest;
    function AddMiddleware(AMiddleware: TMiddleware): IDTRestRequest;
    function OnProgress(AOnProgress: TProgressEvent): IDTRestRequest;
    function Timeout(const ATimeoutMS: Integer): IDTRestRequest;
    function BasicAuthentication(const AUsername, APassword: string; ADotEncode: Boolean = False): IDTRestRequest;
    function UseDecodeResponse(const AUseDecodeResponse: Boolean): IDTRestRequest;

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
  FUseDecodeResponse := False;

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

function TDTRestRequest.DotEncode(const AValue: string): string;
begin
  // Utiliza a codificação padrão do REST para URL encoding
  Result := TNetEncoding.URL.Encode(AValue);
end;

function TDTRestRequest.DotDecode(const AValue: string): string;
begin
  // Utiliza a decodificação padrão do REST para URL decoding
  Result := TNetEncoding.URL.Decode(AValue);
end;

function TDTRestRequest.BaseURL(const AURL: string; ADotEncode: Boolean = False): IDTRestRequest;
var
  URL: string;
begin
  Result := Self;
  if ADotEncode then
    URL := DotEncode(AURL)
  else
    URL := AURL;

  FClient.BaseURL := URL;
  Log('BaseURL set to: ' + URL);
end;

function TDTRestRequest.Resource(const AResource: string; ADotEncode: Boolean = False): IDTRestRequest;
var
  ResourceValue: string;
begin
  Result := Self;
  if ADotEncode then
    ResourceValue := DotEncode(AResource)
  else
    ResourceValue := AResource;

  FRequest.Resource := ResourceValue;
  Log('Resource set to: ' + ResourceValue);
end;

function TDTRestRequest.AddHeader(const AName, AValue: string; ADotEncode: Boolean = False): IDTRestRequest;
var
  HeaderValue: string;
begin
  Result := Self;
  if ADotEncode then
    HeaderValue := DotEncode(AValue)
  else
    HeaderValue := AValue;

  FRequest.Params.AddHeader(AName, HeaderValue);
  Log(Format('Header added: %s=%s (DotEncode: %s)', [AName, HeaderValue, BoolToStr(ADotEncode, True)]));
end;

function TDTRestRequest.AddQueryParam(const AName, AValue: string; ADotEncode: Boolean = False): IDTRestRequest;
var
  Name, Value: string;
begin
  Result := Self;

  if ADotEncode then
  begin
    Name := DotEncode(AName);
    Value := DotEncode(AValue);
  end
  else
  begin
    Name := AName;
    Value := AValue;
  end;

  FRequest.Params.AddItem(Name, Value, pkGETorPOST);
  Log(Format('Query parameter added: %s=%s (DotEncode: %s)', [Name, Value, BoolToStr(ADotEncode, True)]));
end;

function TDTRestRequest.Accept(const AValue: string; ADotEncode: Boolean = False): IDTRestRequest;
var
  Value: string;
begin
  Result := Self;

  if ADotEncode then
    Value := DotEncode(AValue)
  else
    Value := AValue;

  FRequest.Accept := Value;
  Log(Format('Accept set to: %s (DotEncode: %s)', [Value, BoolToStr(ADotEncode, True)]));
end;

function TDTRestRequest.ContentType(const AValue: string; ADotEncode: Boolean = False): IDTRestRequest;
var
  Value: string;
begin
  Result := Self;

  if ADotEncode then
    Value := DotEncode(AValue)
  else
    Value := AValue;

  FRequest.Params.ParameterByName('Content-Type').Value := Value;
  Log(Format('Content-Type set to: %s (DotEncode: %s)', [Value, BoolToStr(ADotEncode, True)]));
end;

function TDTRestRequest.UseOAuth2(const AToken: string; ADotEncode: Boolean = False): IDTRestRequest;
var
  Token: string;
begin
  Result := Self;

  if ADotEncode then
    Token := DotEncode(AToken)
  else
    Token := AToken;

  FRequest.Params.AddHeader('Authorization', 'Bearer ' + Token);
  Log(Format('OAuth2 token added (DotEncode: %s).', [BoolToStr(ADotEncode, True)]));
end;

function TDTRestRequest.UseJWT(const AToken: string; ADotEncode: Boolean = False): IDTRestRequest;
var
  Token: string;
begin
  Result := Self;

  if ADotEncode then
    Token := DotEncode(AToken)
  else
    Token := AToken;

  FRequest.Params.AddHeader('Authorization', 'JWT ' + Token);
  Log(Format('JWT token added (DotEncode: %s).', [BoolToStr(ADotEncode, True)]));
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

function TDTRestRequest.Timeout(const ATimeoutMS: Integer): IDTRestRequest;
begin
  Result := Self;
  FRequest.Timeout := ATimeoutMS;
  Log(Format('Timeout set to: %d ms', [ATimeoutMS]));
end;

function TDTRestRequest.BasicAuthentication(const AUsername, APassword: string; ADotEncode: Boolean = False): IDTRestRequest;
var
  Username, Password: string;
begin
  Result := Self;

  if ADotEncode then
  begin
    Username := DotEncode(AUsername);
    Password := DotEncode(APassword);
  end
  else
  begin
    Username := AUsername;
    Password := APassword;
  end;

  FRequest.Client.Authenticator := nil;
  FRequest.Client.Authenticator := THTTPBasicAuthenticator.Create(Username, Password);
  Log(Format('Basic Authentication set with username: %s (DotEncode: %s)',
    [Username, BoolToStr(ADotEncode, True)]));
end;

function TDTRestRequest.UseDecodeResponse(const AUseDecodeResponse: Boolean): IDTRestRequest;
begin
  Result := Self;
  FUseDecodeResponse := AUseDecodeResponse;
  Log(Format('Response decoding set to: %s', [BoolToStr(AUseDecodeResponse, True)]));
end;

function TDTRestRequest.Post(const ABody: string): string;
begin
  FRequest.Method := rmPOST;
  if not ABody.IsEmpty then
    FRequest.AddBody(ABody, ctAPPLICATION_JSON);

  ExecuteMiddlewares;
  Log('POST request initiated with body: ' + ABody);
  FRequest.Execute;

  if FUseDecodeResponse then
  begin
    Result := DotDecode(FResponse.Content);
    Log('Decoded Response: ' + Result);
  end
  else
  begin
    Result := FResponse.Content;
    Log('Response: ' + Result);
  end;
end;

function TDTRestRequest.Put(const ABody: string): string;
begin
  FRequest.Method := rmPUT;
  if not ABody.IsEmpty then
    FRequest.AddBody(ABody, ctAPPLICATION_JSON);
  ExecuteMiddlewares;
  Log('PUT request initiated with body: ' + ABody);
  FRequest.Execute;

  if FUseDecodeResponse then
  begin
    Result := DotDecode(FResponse.Content);
    Log('Decoded Response: ' + Result);
  end
  else
  begin
    Result := FResponse.Content;
    Log('Response: ' + Result);
  end;
end;

function TDTRestRequest.Patch(const ABody: string): string;
begin
  FRequest.Method := rmPATCH;
  if not ABody.IsEmpty then
    FRequest.AddBody(ABody, ctAPPLICATION_JSON);
  ExecuteMiddlewares;
  Log('PATCH request initiated with body: ' + ABody);
  FRequest.Execute;

  if FUseDecodeResponse then
  begin
    Result := DotDecode(FResponse.Content);
    Log('Decoded Response: ' + Result);
  end
  else
  begin
    Result := FResponse.Content;
    Log('Response: ' + Result);
  end;
end;

function TDTRestRequest.Delete(const ABody: string): string;
begin
  FRequest.Method := rmDELETE;
  if not ABody.IsEmpty then
    FRequest.AddBody(ABody, ctAPPLICATION_JSON);
  ExecuteMiddlewares;
  Log('DELETE request initiated with body: ' + ABody);
  FRequest.Execute;

  if FUseDecodeResponse then
  begin
    Result := DotDecode(FResponse.Content);
    Log('Decoded Response: ' + Result);
  end
  else
  begin
    Result := FResponse.Content;
    Log('Response: ' + Result);
  end;
end;

function TDTRestRequest.Get: string;
begin
  FRequest.Method := rmGET;
  ExecuteMiddlewares;
  Log('GET request initiated.');
  FRequest.Execute;

  if FUseDecodeResponse then
  begin
    Result := DotDecode(FResponse.Content);
    Log('Decoded Response: ' + Result);
  end
  else
  begin
    Result := FResponse.Content;
    Log('Response: ' + Result);
  end;
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

  if FUseDecodeResponse then
  begin
    Result := DotDecode(FResponse.Content);
    Log('Decoded Response: ' + Result);
  end
  else
  begin
    Result := FResponse.Content;
    Log('Response: ' + Result);
  end;
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
