object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'TV Rename'
  ClientHeight = 623
  ClientWidth = 626
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 523
    Width = 626
    Height = 1
    Cursor = crVSplit
    Align = alBottom
    Color = clBtnFace
    ParentColor = False
    ExplicitTop = 334
    ExplicitWidth = 600
  end
  object Splitter2: TSplitter
    Left = 185
    Top = 0
    Height = 523
    ExplicitLeft = 232
    ExplicitTop = 184
    ExplicitHeight = 100
  end
  object ListView1: TListView
    AlignWithMargins = True
    Left = 188
    Top = 3
    Width = 438
    Height = 519
    Margins.Left = 0
    Margins.Right = 0
    Margins.Bottom = 1
    Align = alClient
    Columns = <
      item
        AutoSize = True
        Caption = 'File'
      end
      item
        Alignment = taCenter
        Caption = 'Season'
        MaxWidth = 60
        MinWidth = 60
        Width = 60
      end
      item
        Alignment = taCenter
        Caption = 'Episode'
        MaxWidth = 60
        MinWidth = 60
        Width = 60
      end>
    DoubleBuffered = True
    DragKind = dkDock
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    ParentDoubleBuffered = False
    PopupMenu = PopupMenu1
    SmallImages = ImageList1
    SortType = stBoth
    TabOrder = 0
    ViewStyle = vsReport
    OnCompare = ListView1Compare
    OnCustomDrawItem = ListView1CustomDrawItem
    OnCustomDrawSubItem = ListView1CustomDrawSubItem
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 604
    Width = 626
    Height = 19
    Panels = <>
  end
  object Panel1: TPanel
    Left = 0
    Top = 524
    Width = 626
    Height = 80
    Margins.Left = 0
    Margins.Right = 0
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object Memo1: TMemo
      AlignWithMargins = True
      Left = 0
      Top = 3
      Width = 626
      Height = 74
      Margins.Left = 0
      Margins.Right = 0
      Align = alClient
      Lines.Strings = (
        'Logs')
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
      ExplicitLeft = 2
      ExplicitWidth = 620
    end
  end
  object GroupBox1: TGroupBox
    AlignWithMargins = True
    Left = 0
    Top = 3
    Width = 185
    Height = 520
    Margins.Left = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alLeft
    Caption = 'TV series'
    TabOrder = 3
    object ListView2: TListView
      Left = 2
      Top = 15
      Width = 181
      Height = 503
      Align = alClient
      Columns = <
        item
          AutoSize = True
        end>
      RowSelect = True
      PopupMenu = PopupMenu2
      ShowColumnHeaders = False
      SortType = stText
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = ListView2Click
      OnEdited = ListView2Edited
      OnSelectItem = ListView2SelectItem
    end
  end
  object MainMenu1: TMainMenu
    Left = 288
    Top = 32
    object Fichier1: TMenuItem
      Caption = 'File'
      object Supprimer3: TMenuItem
        Caption = 'Refresh series'
        OnClick = Supprimer3Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object Importeruneliste1: TMenuItem
        Caption = 'Import ...'
        OnClick = Importeruneliste1Click
      end
      object Exporterlaliste1: TMenuItem
        Caption = 'Export ...'
        OnClick = Exporterlaliste1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Ajouterdesfichiers1: TMenuItem
        Caption = 'Exit'
        OnClick = Ajouterdesfichiers1Click
      end
    end
    object Edition1: TMenuItem
      Caption = 'Edition'
      object Ajouterdesfichiers2: TMenuItem
        Caption = 'Add files ...'
        OnClick = Ajouter1Click
      end
      object Ajouterundossier1: TMenuItem
        Caption = 'Add a directory ...'
        OnClick = Ajouterundossier1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Supprimer2: TMenuItem
        Caption = 'Remove selected files'
        OnClick = Supprimer1Click
      end
      object out1: TMenuItem
        Caption = 'Remove all'
        OnClick = out1Click
      end
    end
    object Format1: TMenuItem
      Caption = 'Format'
      object N8: TMenuItem
        Caption = '-'
      end
      object Editerlalistedesformats1: TMenuItem
        Caption = 'Edit formats ...'
        OnClick = Editerlalistedesformats1Click
      end
    end
    object Actions1: TMenuItem
      Caption = 'Actions'
      object Ajouterunesrie1: TMenuItem
        Caption = 'Add a serie ...'
        OnClick = Ajouterunesrie1Click
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object Annulerlerenommage1: TMenuItem
        Caption = 'Show original filenames'
        OnClick = Annulerlerenommage1Click
      end
      object Validerlerenommage1: TMenuItem
        Caption = 'Rename'
        Default = True
        OnClick = Validerlerenommage1Click
      end
    end
    object Options1: TMenuItem
      Caption = 'Options'
      object Dtectiondelasaisonetnumro1: TMenuItem
        AutoCheck = True
        Caption = 'Detect season and episode'
        Checked = True
      end
      object Crerunesauvegarde1: TMenuItem
        AutoCheck = True
        Caption = 'Ask for a backup'
        Checked = True
      end
    end
    object N1: TMenuItem
      Caption = '?'
      object Aide1: TMenuItem
        Caption = 'Help'
        OnClick = Aide1Click
      end
      object Apropos1: TMenuItem
        Caption = 'About'
        OnClick = Apropos1Click
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 344
    Top = 32
    object Ajouter1: TMenuItem
      Caption = 'Add files ...'
      OnClick = Ajouter1Click
    end
    object Supprimer1: TMenuItem
      Caption = 'Remove selected files'
      OnClick = Supprimer1Click
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object Editer1: TMenuItem
      Caption = 'Edit ...'
      OnClick = Editer1Click
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 
      'Fichiers vid'#233'os|*.avi;*.mkv;*.mp4;*.mov;*.wmv|Tous les fichiers|' +
      '*.*'
    Options = [ofHideReadOnly, ofShowHelp, ofAllowMultiSelect, ofFileMustExist, ofEnableSizing, ofForceShowHidden]
    Left = 400
    Top = 32
  end
  object SaveDialog1: TSaveDialog
    Left = 456
    Top = 32
  end
  object IdAntiFreeze1: TIdAntiFreeze
    Left = 552
    Top = 32
  end
  object ImageList1: TImageList
    BlendColor = clWhite
    BkColor = clWhite
    DrawingStyle = dsTransparent
    Left = 240
    Top = 32
  end
  object PopupMenu2: TPopupMenu
    Left = 504
    Top = 32
    object Editerlenom1: TMenuItem
      Caption = 'Edit name'
      OnClick = Editerlenom1Click
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object Actualiserlalistedessries1: TMenuItem
      Caption = 'Reload series'
      OnClick = Supprimer3Click
    end
  end
end
