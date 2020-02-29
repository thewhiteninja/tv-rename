object Form2: TForm2
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Add serie'
  ClientHeight = 378
  ClientWidth = 324
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 5
    Top = 45
    Width = 42
    Height = 13
    Caption = 'Results :'
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 359
    Width = 324
    Height = 19
    Panels = <>
    SimplePanel = True
    ExplicitWidth = 317
  end
  object LabeledEdit1: TLabeledEdit
    Left = 39
    Top = 8
    Width = 203
    Height = 21
    EditLabel.Width = 31
    EditLabel.Height = 13
    EditLabel.Caption = 'Name:'
    LabelPosition = lpLeft
    TabOrder = 1
    OnKeyPress = LabeledEdit1KeyPress
  end
  object Button1: TButton
    Left = 245
    Top = 6
    Width = 69
    Height = 24
    Caption = 'Search'
    TabOrder = 2
    OnClick = Button1Click
  end
  object ListView1: TListView
    Left = 3
    Top = 64
    Width = 311
    Height = 262
    Columns = <
      item
        Caption = 'Name'
        MaxWidth = 257
        MinWidth = 257
        Width = 257
      end
      item
        Alignment = taCenter
        Caption = 'Year'
        MaxWidth = 50
        MinWidth = 50
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 3
    ViewStyle = vsReport
  end
  object Button2: TButton
    Left = 58
    Top = 330
    Width = 95
    Height = 25
    Caption = 'Add'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 159
    Top = 330
    Width = 95
    Height = 25
    Caption = 'Cancel'
    TabOrder = 5
    OnClick = Button3Click
  end
  object IdHTTP1: TIdHTTP
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 232
    Top = 40
  end
end
