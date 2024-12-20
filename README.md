Parece que houve um problema ao recuperar o arquivo diretamente. Vou gerar o conteúdo atualizado para você aqui. Um momento enquanto faço isso.

Aqui está a versão atualizada do arquivo `README.md` com exemplos detalhados:

```markdown
# 🌐 **DTRest4D**

`DTRest4D` é uma biblioteca poderosa para facilitar o consumo de APIs REST no Delphi, com suporte avançado para:
- 🔗 Upload e download de arquivos (com suporte a retomada).
- 📊 Monitoramento de progresso em uploads/downloads.
- ⚙️ Envio de JSON, arquivos binários e dados complexos.
- 🛠️ Middlewares para customização das requisições.
- 🔒 Autenticação via OAuth2 e JWT.
- 📋 Logs personalizáveis.

---

## **Recursos principais**

- 🚀 Suporte a todos os métodos HTTP: `GET`, `POST`, `PUT`, `PATCH`, `DELETE`, `HEAD`.
- 🛠️ Flexibilidade com qualquer tipo de `Content-Type` (ex.: JSON, XML, multipart/form-data, octet-stream).
- 📁 Upload e download de arquivos com **streams**.
- 🔄 Retomada de downloads interrompidos.
- 📡 Envio e recebimento de JSON diretamente ou via objetos Delphi.
- 🔍 Monitoramento de progresso em tempo real.

---

## **📦 Instalação**

1. Faça o download do arquivo [DTRest4D.pas](DTRest4D.pas).
2. Adicione o arquivo ao seu projeto Delphi.
3. Certifique-se de que os módulos nativos (`REST.Client`, `REST.Types`, etc.) estejam disponíveis.

---

## **🚀 Como Usar**

### **1. Configuração Básica** 🛠️

```delphi
var
  Request: IDTRestRequest;
  Response: string;
begin
  Request := TDTRestRequest.New
    .BaseURL('https://api.example.com')
    .Resource('endpoint')
    .AddHeader('Authorization', 'Bearer your-token')
    .Accept('application/json');

  Response := Request.Get;

  ShowMessage(Response);
end;
```

---

### **2. Envio de JSON** 📤

#### **2.1 Envio de JSON como String**

```delphi
var
  JSON: string;
  Response: string;
begin
  JSON := '{"key": "value"}';

  Response := TDTRestRequest.New
    .BaseURL('https://api.example.com')
    .Resource('endpoint')
    .ContentType('application/json')
    .Post(JSON);

  ShowMessage(Response);
end;
```

#### **2.2 Envio de Objetos Delphi como JSON**

```delphi
type
  TMyObject = class
    Key: string;
  end;

var
  MyObject: TMyObject;
  Response: string;
begin
  MyObject := TMyObject.Create;
  try
    MyObject.Key := 'value';

    Response := TDTRestRequest.New
      .BaseURL('https://api.example.com')
      .Resource('endpoint')
      .PostAs<TMyObject>(MyObject);

    ShowMessage(Response);
  finally
    MyObject.Free;
  end;
end;
```

---

### **3. Upload de Arquivos** 📁

#### **3.1 Upload de Arquivo como Stream**

```delphi
var
  FileStream: TFileStream;
  Response: string;
begin
  FileStream := TFileStream.Create('C:\path\to\file.zip', fmOpenRead);
  try
    Response := TDTRestRequest.New
      .BaseURL('https://api.example.com')
      .Resource('upload')
      .ContentType('application/octet-stream')
      .UploadFile('file.zip', FileStream);

    ShowMessage(Response);
  finally
    FileStream.Free;
  end;
end;
```

#### **3.2 Upload com Multipart/Form-Data**

```delphi
uses
  REST.Client, REST.Types;

var
  MultiPart: TMultipartFormData;
  Response: string;
begin
  MultiPart := TMultipartFormData.Create;
  try
    MultiPart.AddField('key', 'value');
    MultiPart.AddFile('file', 'C:\path\to\file.txt');

    Response := TDTRestRequest.New
      .BaseURL('https://api.example.com')
      .Resource('upload')
      .ContentType('multipart/form-data')
      .Post(MultiPart.AsString);
  finally
    MultiPart.Free;
  end;

  ShowMessage(Response);
end;
```

---

### **4. Download de Arquivos** 📥

#### **4.1 Download Completo**

```delphi
var
  FileStream: TFileStream;
begin
  FileStream := TFileStream.Create('C:\path\to\downloaded_file.zip', fmCreate);
  try
    if TDTRestRequest.New
      .BaseURL('https://api.example.com')
      .Resource('file.zip')
      .DownloadFile('file.zip', FileStream) then
    begin
      ShowMessage('Download concluído com sucesso!');
    end;
  finally
    FileStream.Free;
  end;
end;
```

#### **4.2 Retomada de Downloads Interrompidos**

```delphi
var
  FilePath: string;
begin
  FilePath := 'C:\path\to\partial_file.zip';

  if TDTRestRequest.New
    .BaseURL('https://api.example.com')
    .ResumeDownloadFile('largefile.zip', FilePath) then
  begin
    ShowMessage('Download retomado e concluído com sucesso!');
  end
  else
  begin
    ShowMessage('Falha ao retomar o download!');
  end;
end;
```

---

### **5. Logs e Middlewares** 📋

#### **5.1 Habilitando Logs**

```delphi
TDTRestRequest.New
  .BaseURL('https://api.example.com')
  .EnableLogging(
    procedure(LogMessage: string)
    begin
      Writeln(LogMessage); // Exibe os logs no console ou salva em arquivo
    end
  )
  .Get;
```

#### **5.2 Usando Middlewares**

```delphi
TDTRestRequest.New
  .BaseURL('https://api.example.com')
  .AddMiddleware(
    procedure(var Request: TRESTRequest)
    begin
      // Adicionar cabeçalhos personalizados dinamicamente
      Request.Params.AddHeader('Dynamic-Header', 'HeaderValue');
    end
  )
  .Get;
```

---

### **6. Progresso de Upload e Download** 📊

#### **6.1 Monitorando Progresso no Upload**

```delphi
var
  FileStream: TFileStream;
begin
  FileStream := TFileStream.Create('C:\path\to\file.zip', fmOpenRead);
  try
    TDTRestRequest.New
      .BaseURL('https://api.example.com')
      .OnProgress(
        procedure(AProgress: Integer)
        begin
          Writeln('Progresso do upload: ' + AProgress.ToString + '%');
        end
      )
      .UploadFile('file.zip', FileStream);
  finally
    FileStream.Free;
  end;
end;
```

#### **6.2 Monitorando Progresso no Download**

```delphi
var
  FilePath: string;
begin
  FilePath := 'C:\path\to\file.zip';

  TDTRestRequest.New
    .BaseURL('https://api.example.com')
    .OnProgress(
      procedure(AProgress: Integer)
      begin
        Writeln('Progresso do download: ' + AProgress.ToString + '%');
      end
    )
    .ResumeDownloadFile('largefile.zip', FilePath);
end;
```

---

## **📚 Documentação Avançada**
Consulte os exemplos detalhados acima para entender como usar cada funcionalidade. Se tiver dúvidas, sinta-se à vontade para contribuir ou abrir uma issue!

---

## **⚖️ Licença**
Esta biblioteca é distribuída sob a licença MIT. Consulte o arquivo `LICENSE` para mais detalhes.

---

## **✉️ Contato**
Para dúvidas ou sugestões, entre em contato pelo e-mail: `suporte@exemplo.com`.
```

Se precisar de algo mais, é só avisar! 🚀