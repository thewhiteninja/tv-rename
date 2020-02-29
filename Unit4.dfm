object Form4: TForm4
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Edit formats'
  ClientHeight = 437
  ClientWidth = 407
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
    Left = 32
    Top = 58
    Width = 12
    Height = 13
    Caption = '->'
  end
  object Label2: TLabel
    Left = 18
    Top = 39
    Width = 28
    Height = 13
    Caption = 'Test :'
  end
  object Label3: TLabel
    Left = 52
    Top = 39
    Width = 169
    Height = 13
    Caption = 'MacGyver.2x05.Final Approach.avi'
  end
  object Label4: TLabel
    Left = 52
    Top = 58
    Width = 344
    Height = 24
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 418
    Width = 407
    Height = 19
    Panels = <>
    ExplicitWidth = 405
  end
  object LabeledEdit2: TLabeledEdit
    Left = 52
    Top = 8
    Width = 345
    Height = 21
    EditLabel.Width = 41
    EditLabel.Height = 13
    EditLabel.Caption = 'Format :'
    LabelPosition = lpLeft
    TabOrder = 1
    OnChange = LabeledEdit2Change
  end
  object Button1: TButton
    Left = 311
    Top = 95
    Width = 88
    Height = 25
    Caption = 'Add'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 311
    Top = 126
    Width = 88
    Height = 25
    Caption = 'Remove'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 311
    Top = 351
    Width = 88
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 4
  end
  object Button4: TButton
    Left = 311
    Top = 382
    Width = 88
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object Button5: TButton
    Left = 311
    Top = 312
    Width = 86
    Height = 25
    CustomHint = BalloonHint1
    Caption = 'Help'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
  end
  object GroupBox1: TGroupBox
    Left = 3
    Top = 90
    Width = 302
    Height = 326
    Caption = 'Formats'
    TabOrder = 7
    object ListBox1: TListBox
      AlignWithMargins = True
      Left = 5
      Top = 18
      Width = 292
      Height = 303
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
      OnClick = ListBox1Click
    end
  end
  object BalloonHint1: TBalloonHint
    Delay = 0
    Left = 336
    Top = 168
  end
end
