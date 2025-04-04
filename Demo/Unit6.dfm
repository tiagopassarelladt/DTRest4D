object Form6: TForm6
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Demo - DTRest4D'
  ClientHeight = 499
  ClientWidth = 496
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 48
    Height = 15
    Caption = 'Base URL'
  end
  object Label2: TLabel
    Left = 271
    Top = 8
    Width = 48
    Height = 15
    Caption = 'Resource'
  end
  object Label3: TLabel
    Left = 8
    Top = 343
    Width = 41
    Height = 15
    Caption = 'Eventos'
  end
  object Label4: TLabel
    Left = 8
    Top = 67
    Width = 32
    Height = 15
    Caption = 'Result'
  end
  object mResult: TMemo
    Left = 8
    Top = 88
    Width = 478
    Height = 249
    Color = 4276545
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'mResult')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object edtUrlBase: TEdit
    Left = 8
    Top = 29
    Width = 257
    Height = 23
    TabOrder = 1
    Text = 'https://viacep.com.br/ws/'
  end
  object edtResource: TEdit
    Left = 271
    Top = 29
    Width = 150
    Height = 23
    TabOrder = 2
    Text = '01001000/json/'
  end
  object Button1: TButton
    Left = 429
    Top = 28
    Width = 59
    Height = 25
    Cursor = crHandPoint
    Caption = 'Send'
    TabOrder = 3
    OnClick = Button1Click
  end
  object mLog: TMemo
    Left = 8
    Top = 364
    Width = 478
    Height = 127
    Color = 4276545
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'mLog')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 4
  end
end
