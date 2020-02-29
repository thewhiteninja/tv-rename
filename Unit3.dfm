object Form3: TForm3
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Edit file ...'
  ClientHeight = 75
  ClientWidth = 293
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
  object Button1: TButton
    Left = 60
    Top = 40
    Width = 83
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 154
    Top = 40
    Width = 83
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object LabeledEdit2: TLabeledEdit
    Left = 60
    Top = 8
    Width = 73
    Height = 21
    EditLabel.Width = 42
    EditLabel.Height = 13
    EditLabel.Caption = 'Season: '
    LabelPosition = lpLeft
    MaxLength = 3
    NumbersOnly = True
    TabOrder = 2
  end
  object LabeledEdit3: TLabeledEdit
    Left = 204
    Top = 8
    Width = 73
    Height = 21
    EditLabel.Width = 47
    EditLabel.Height = 13
    EditLabel.Caption = 'Episode : '
    LabelPosition = lpLeft
    MaxLength = 3
    NumbersOnly = True
    TabOrder = 3
  end
end
