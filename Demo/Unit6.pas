unit Unit6;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,DTRest4D;

type
  TForm6 = class(TForm)
    mResult: TMemo;
    edtUrlBase: TEdit;
    Label1: TLabel;
    edtResource: TEdit;
    Label2: TLabel;
    Button1: TButton;
    mLog: TMemo;
    Label3: TLabel;
    Label4: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
      procedure Log( msg : string);
  public

  end;

var
  Form6: TForm6;

implementation

{$R *.dfm}

procedure TForm6.Button1Click(Sender: TObject);
var
Request : IDTRestRequest;
begin
     mLog.Lines.Clear;
     mResult.Lines.Clear;

  Request := TDTRestRequest.New
                  .BaseURL(edtUrlBase.Text)
                  .Resource(edtResource.Text)  // endpoint
                  .Accept('application/json')
                  .Timeout(10000)
                  .UseDecodeResponse(True)
                  .EnableLogging(log); // log de eventos

    mResult.Lines.Add(Request.Get);
end;

procedure TForm6.FormCreate(Sender: TObject);
begin
     mLog.Lines.Clear;
     mResult.Lines.Clear;
end;

procedure TForm6.Log(msg: string);
begin
     mLog.Lines.Add(msg);
end;

end.
