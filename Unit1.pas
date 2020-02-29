unit Unit1;

interface

uses
  Windows, ImgList, Controls, IdAntiFreezeBase, IdAntiFreeze, Dialogs, Menus,
  StdCtrls, ExtCtrls, ComCtrls, Classes, Forms, XMLDoc, StrUtils, SysUtils,
  RegExpr, ShellAPI, Utils, Messages, Graphics, Serie, IdBaseComponent, ShlObj,
  System.ImageList, System.UITypes;

type
  TItemData = record
    path: string;
    newpath: string;
  end;

type
  TForm1 = class(TForm)
    ListView1: TListView;
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    Fichier1: TMenuItem;
    N1: TMenuItem;
    Apropos1: TMenuItem;
    Ajouterdesfichiers1: TMenuItem;
    Options1: TMenuItem;
    Dtectiondelasaisonetnumro1: TMenuItem;
    PopupMenu1: TPopupMenu;
    Ajouter1: TMenuItem;
    Supprimer1: TMenuItem;
    OpenDialog1: TOpenDialog;
    N2: TMenuItem;
    Edition1: TMenuItem;
    Ajouterdesfichiers2: TMenuItem;
    Supprimer2: TMenuItem;
    out1: TMenuItem;
    Importeruneliste1: TMenuItem;
    Exporterlaliste1: TMenuItem;
    SaveDialog1: TSaveDialog;
    Actions1: TMenuItem;
    Panel1: TPanel;
    Memo1: TMemo;
    Splitter1: TSplitter;
    IdAntiFreeze1: TIdAntiFreeze;
    Format1: TMenuItem;
    Validerlerenommage1: TMenuItem;
    Annulerlerenommage1: TMenuItem;
    Crerunesauvegarde1: TMenuItem;
    N4: TMenuItem;
    Supprimer3: TMenuItem;
    ImageList1: TImageList;
    GroupBox1: TGroupBox;
    Splitter2: TSplitter;
    N5: TMenuItem;
    Ajouterunesrie1: TMenuItem;
    ListView2: TListView;
    N3: TMenuItem;
    PopupMenu2: TPopupMenu;
    Editerlenom1: TMenuItem;
    N6: TMenuItem;
    Actualiserlalistedessries1: TMenuItem;
    N7: TMenuItem;
    Editer1: TMenuItem;
    Ajouterundossier1: TMenuItem;
    N8: TMenuItem;
    Editerlalistedesformats1: TMenuItem;
    Aide1: TMenuItem;
    procedure Ajouterdesfichiers1Click(Sender: TObject);
    procedure Apropos1Click(Sender: TObject);
    procedure Ajouter1Click(Sender: TObject);
    procedure Supprimer1Click(Sender: TObject);
    procedure out1Click(Sender: TObject);
    procedure Importeruneliste1Click(Sender: TObject);
    procedure Exporterlaliste1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListView1CustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListView1CustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure Validerlerenommage1Click(Sender: TObject);
    procedure Annulerlerenommage1Click(Sender: TObject);
    procedure ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure TraiteMessage(var Msg: TMsg; var Handled: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure Ajouterunesrie1Click(Sender: TObject);
    procedure ListView2SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Supprimer3Click(Sender: TObject);
    procedure ListView2Edited(Sender: TObject; Item: TListItem; var S: string);
    procedure Editerlenom1Click(Sender: TObject);
    procedure Editer1Click(Sender: TObject);
    procedure ListView2Click(Sender: TObject);
    procedure Ajouterundossier1Click(Sender: TObject);
    procedure Editerlalistedesformats1Click(Sender: TObject);
    procedure Aide1Click(Sender: TObject);
  private
    procedure FormatItemClick(Sender: TObject);
  public
    start: TDateTime;
    serieManager: TSerieManager;
    procedure loadSeriesFromXML;
    procedure loadFormatsFromDAT;
    procedure ajoute(S: string);
  end;

var
  Form1: TForm1;

const
  reSaison: array [0 .. 3] of string = ('([0-9]+)x([0-9]+)',
    's[a-z]*([0-9]+)[\.-x]?e[p]?[\.]?([0-9]+)', '([0-9]{1,2})([0-9]{2})',
    's([0-9]+)[\.]([0-9]+)');

implementation

uses Unit2, Unit3, Unit4;
{$R *.dfm}

procedure TForm1.loadSeriesFromXML;
var
  XMLDoc: TXMLDocument;
  Item: TListItem;
  i: Integer;
  Data: ^TItemData;
begin
  ListView2.Clear;
  XMLDoc := TXMLDocument.Create(Form1);
  XMLDoc.Active := true;
  try
    if FileExists(IncludeTrailingPathDelimiter
      (ExtractFileDir(Application.ExeName)) + 'data.xml') then
    begin
      XMLDoc.LoadFromFile(IncludeTrailingPathDelimiter
        (ExtractFileDir(Application.ExeName)) + 'data.xml');

      for i := 0 to XMLDoc.DocumentElement.ChildNodes.Count - 1 do
      begin
        Item := ListView2.Items.Add;
        Item.Caption := XMLDoc.DocumentElement.ChildNodes[i].ChildNodes[0].Text;
        new(Data);
        Data.path := XMLDoc.DocumentElement.ChildNodes[i].Attributes['id'];
        Data.newpath := '';
        Item.Data := Data;
      end;
      if XMLDoc.DocumentElement.ChildNodes.Count > 0 then
        log(IntToStr(XMLDoc.DocumentElement.ChildNodes.Count) +
          ' TV serie(s) loaded');
    end;
  finally
    XMLDoc.Active := false;
    XMLDoc.Free;
  end;
end;

procedure TForm1.Editer1Click(Sender: TObject);
begin
  if ListView1.SelCount > 0 then
  begin
    with TForm3.Create(Form1) do
    begin
      LabeledEdit2.Text := ListView1.Selected.SubItems[0];
      LabeledEdit3.Text := ListView1.Selected.SubItems[1];
      if ShowModal = mrOk then
      begin
        ListView1.Selected.SubItems[0] := LabeledEdit2.Text;
        ListView1.Selected.SubItems[1] := LabeledEdit3.Text;
      end;
      Free;
      if ListView1.SelCount > 0 then
        ListView2SelectItem(Sender, nil, true);
    end;
  end;
end;

procedure TForm1.FormatItemClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to MainMenu1.Items[2].Count - 3 do
  begin
    MainMenu1.Items[2].Items[i].Checked := false;
  end;
  TMenuItem(Sender).Checked := true;
  ListView2SelectItem(Sender, nil, true);
end;

procedure TForm1.loadFormatsFromDAT;
var
  format: TStringList;
  Item: TMenuItem;
  i, comment: Integer;
begin
  for i := 0 to MainMenu1.Items[2].Count - 3 do
  begin
    MainMenu1.Items[2].Delete(0);
  end;

  format := TStringList.Create;
  if FileExists(IncludeTrailingPathDelimiter(ExtractFileDir(Application.ExeName)
    ) + 'formats.dat') then
    format.LoadFromFile(IncludeTrailingPathDelimiter
      (ExtractFileDir(Application.ExeName)) + 'formats.dat');
  comment := 0;
  if format.Count > 0 then
  begin
    for i := 0 to format.Count - 1 do
    begin
      if ((trim(format[i]) = '') or (trim(format[i])[1] = '#')) then
      begin
        inc(comment);
        Continue;
      end;
      Item := TMenuItem.Create(MainMenu1);
      Item.Caption := StringReplace(format[i], '&', '', [rfReplaceAll]);
      Item.RadioItem := true;
      Item.Tag := i;
      Item.OnClick := FormatItemClick;
      MainMenu1.Items[2].Insert(i - comment, Item);
    end;
    log(IntToStr(format.Count - comment) + ' format(s) loaded');
    MainMenu1.Items[2].Items[0].Checked := true;
  end
  else
  begin
    Item := TMenuItem.Create(MainMenu1);
    Item.Caption := '[title].[season]x[Episode].[name]';
    Item.RadioItem := true;
    Item.Checked := true;
    Item.OnClick := FormatItemClick;
    Item.Tag := 0;
    MainMenu1.Items[2].Insert(0, Item);
    Item := TMenuItem.Create(MainMenu1);
    Item.Caption := '[title].S[Season]E[Episode].[name]';
    Item.RadioItem := true;
    Item.Checked := true;
    Item.OnClick := FormatItemClick;
    Item.Tag := 1;
    MainMenu1.Items[2].Insert(1, Item);
    log('2 format loaded');
  end;
  format.Free;
end;

procedure TForm1.Editerlalistedesformats1Click(Sender: TObject);
var
  t: TStringList;
begin
  with TForm4.Create(Form1) do
  begin
    if (ListBox1.Items.Count > 0) then
      ListBox1.Selected[0] := true;
    if ShowModal = mrOk then
    begin
      t := TStringList.Create;
      t.Add('# [title]    title');
      t.Add('# [season]	season number');
      t.Add('# [Season]	season number zero-padded');
      t.Add('# [episode]	epidode number');
      t.Add('# [Episode]	episode number zero-padded');
      t.Add('# [name]		episode name');
      t.Add('');
      t.AddStrings(ListBox1.Items);
      t.SaveToFile(IncludeTrailingPathDelimiter
        (ExtractFileDir(Application.ExeName)) + 'formats.dat');
      t.Free;
      loadFormatsFromDAT;
    end;
    Free;
  end;
end;

procedure TForm1.Editerlenom1Click(Sender: TObject);
begin
  if ListView2.SelCount > 0 then
  begin
    ListView2.Selected.EditCaption;
  end;
end;

procedure TForm1.Aide1Click(Sender: TObject);
begin
  MessageDlg('Usage:' + #13#10 + #13#10 +
    '1 - If your TV serie to rename is not in the list, add it.'#13#10 +
    '           Actions > Add a serie ...' + #13#10 +
    '2 - Add your video files to the list.' + #13#10 +
    '           Edition > Add files | Add a folder' + #13#10 +
    '3 - Check that the season and episode are detected for each file, else' +
    #13#10 + '           Right click on the file > Edit ...' + #13#10 +
    '4 - Click on your serie, new filenames will be displayed in red.' + #13#10
    + '5 - To validate the changes, Actions > Rename,' + #13#10 +
    '5-  To cancel, Actions > Show original filenames.', mtInformation,
    [mbOK], 0);
end;

procedure TForm1.ajoute(S: string);
var
  iReg: Integer;
  re: TRegExpr;
  Item: TListItem;
  Data: ^TItemData;
  Icon: TIcon;
  FileInfo: SHFILEINFO;
  Info: TSearchRec;
  dir: string;
begin
  if SysUtils.DirectoryExists(S) then
  begin
    S := IncludeTrailingPathDelimiter(S);
    If FindFirst(S + '*.*', faAnyFile, Info) = 0 Then
    Begin
      Repeat
        if ((strpas(Info.FindData.cFileName) <> '.') and
          (strpas(Info.FindData.cFileName) <> '..')) then
          ajoute(S + Info.FindData.cFileName);
      Until FindNext(Info) <> 0;
      FindClose(Info);
    End;
  end
  else
  begin
    if not FileExists(S) then
      exit;

    if AnsiCompareText('Thumbs.db', ExtractFileName(S)) = 0 then
    begin
      log('File "' + S + '" has been ignored');
      exit;
    end;

    for iReg := 0 to ListView1.Items.Count - 1 do
    begin
      if S = TItemData(ListView1.Items[iReg].Data^).path then
      begin
        log('File "' + S + '" has been already added');
        exit;
      end;
    end;

    log('Adding "' + S + '"');

    re := TRegExpr.Create;
    re.ModifierI := true;

    ListView1.Items.BeginUpdate;
    Item := ListView1.Items.Add;
    Item.Caption := ExtractFileName(S);
    new(Data);
    Data.path := S;
    Data.newpath := '';
    Item.Data := Data;

    SHGetFileInfo(PChar(S), 0, FileInfo, sizeof(FileInfo),
      SHGFI_ICON or SHGFI_SMALLICON);
    Icon := TIcon.Create;
    Icon.Handle := FileInfo.hIcon;
    Item.ImageIndex := ImageList1.AddIcon(Icon);
    Icon.Free;
    DestroyIcon(FileInfo.hIcon);

    if (MainMenu1.Items[4].Items[0].Checked) then
    begin
      for iReg := 0 to Length(reSaison) - 1 do
      begin
        re.Expression := reSaison[iReg];
        if ((re.Exec(StringReplace(Item.Caption, ' ', '', [rfReplaceAll]))) and
          (re.SubExprMatchCount = 2)) then
        begin
          Item.SubItems.Add(IntToStr(StrToInt(re.Match[1])));
          Item.SubItems.Add(IntToStr(StrToInt(re.Match[2])));
          break;
        end;
      end;
    end;

    if Item.SubItems.Count = 0 then
    begin
      re.Expression := '([0-9]{1,2})';
      dir := StringReplace(ExtractFileName(ExtractFileDir(S)), ' ', '',
        [rfReplaceAll]);
      if (re.Exec(dir) and (re.SubExprMatchCount > 0)) then
        Item.SubItems.Add(IntToStr(StrToInt(re.Match[re.SubExprMatchCount])));
      if (re.Exec(StringReplace(Item.Caption, ' ', '', [rfReplaceAll])) and
        (re.SubExprMatchCount > 0)) then
        Item.SubItems.Add(IntToStr(StrToInt(re.Match[1])))
      else
        Item.SubItems.Clear;
    end;

    re.Free;
    ListView1.Items.EndUpdate;
  end;
end;

procedure TForm1.Ajouter1Click(Sender: TObject);
var
  i: Integer;
  c: Integer;
begin
  c := ListView1.Items.Count;
  OpenDialog1.Title := 'Add files ...';
  OpenDialog1.Filter :=
    'Video files|*.avi;*.mkv;*.mp4;*.mov;*.wmv|All files|*.*';
  if OpenDialog1.Execute then
  begin
    for i := 0 to OpenDialog1.Files.Count - 1 do
    begin
      ajoute(OpenDialog1.Files[i]);
    end;
    log('Total: ' + IntToStr(ListView1.Items.Count - c) + ' file(s)');
  end;
end;

procedure TForm1.Ajouterdesfichiers1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Ajouterundossier1Click(Sender: TObject);
var
  DirSelected: string;
begin
  DirSelected := ChooseFolder;
  if ((DirSelected <> '') and (SysUtils.DirectoryExists(DirSelected))) then
    ajoute(DirSelected);
end;

procedure TForm1.Ajouterunesrie1Click(Sender: TObject);
begin
  with TForm2.Create(Form1) do
  begin
    if ShowModal = mrOk then
    begin
      if serieManager.Exists(id) then
      begin
        MessageDlg('Information about this serie has been already downloaded !',
          mtInformation, [mbOK], 0);
        exit;
      end;

      log('Downloading information on "' + titre + '" ...');

      serieManager.addFromAllocine(id, titre);

      loadSeriesFromXML;

      log('Downloading information on "' + titre + '" finished');

    end;
    Free;
  end;
end;

procedure TForm1.Annulerlerenommage1Click(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to ListView1.Items.Count - 1 do
  begin
    ListView1.Items[i].Caption :=
      ExtractFileName(TItemData(ListView1.Items[i].Data^).path);
    TItemData(ListView1.Items[i].Data^).newpath := '';
  end;
  ListView1.Refresh;
end;

procedure TForm1.Apropos1Click(Sender: TObject);
begin
  About;
end;

procedure TForm1.Exporterlaliste1Click(Sender: TObject);
var
  f: TStringList;
  i: Integer;
begin
  SaveDialog1.Title := 'Export the list of files ...';
  SaveDialog1.Filter := 'All files|*.*';
  if (ListView1.Items.Count > 0) and SaveDialog1.Execute then
  begin
    f := TStringList.Create;
    for i := 0 to ListView1.Items.Count - 1 do
    begin
      f.Add(ListView1.Items[i].Caption);
    end;
    log('Exporting ' + IntToStr(f.Count) + ' file(s)');
    f.SaveToFile(SaveDialog1.FileName);
    f.Free;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  start := now;
  Icon.Assign(Application.Icon);
  DragAcceptFiles(ListView1.Handle, true);
  Application.OnMessage := TraiteMessage;

  Memo1.Lines.Clear;
  log('TV Rename starts');

  serieManager := TSerieManager.Create
    (IncludeTrailingPathDelimiter(ExtractFileDir(Application.ExeName)) +
    'data.xml');
  loadFormatsFromDAT;
  loadSeriesFromXML;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  ImageList1.Clear;
  serieManager.Free;
end;

procedure TForm1.TraiteMessage(var Msg: TMsg; var Handled: Boolean);
var
  NombreDeFichiers, i, c: Integer;
  NomDuFichierStr: string;
  NomDuFichier: array [0 .. 255] of char;
begin
  if Msg.message = WM_DROPFILES then
  begin
    NombreDeFichiers := DragQueryFile(Msg.wParam, $FFFFFFFF, NomDuFichier,
      sizeof(NomDuFichier));
    c := ListView1.Items.Count;
    for i := 0 to NombreDeFichiers - 1 do
    begin
      DragQueryFile(Msg.wParam, i, NomDuFichier, sizeof(NomDuFichier));
      NomDuFichierStr := NomDuFichier;
      ajoute(NomDuFichierStr);
    end;
    log('Total: ' + IntToStr(ListView1.Items.Count - c) + ' file(s)');
  end;
end;

procedure TForm1.Importeruneliste1Click(Sender: TObject);
var
  f: TStringList;
  i: Integer;
  c: Integer;
begin
  OpenDialog1.Title := 'Import a list of files ...';
  OpenDialog1.Filter := 'All files|*.*';
  OpenDialog1.Options := OpenDialog1.Options - [ofAllowMultiSelect];
  c := ListView1.Items.Count;
  if OpenDialog1.Execute then
  begin
    f := TStringList.Create;
    f.LoadFromFile(OpenDialog1.FileName);
    for i := 0 to f.Count - 1 do
    begin
      ajoute(f[i]);
    end;
    log('Total: ' + IntToStr(ListView1.Items.Count - c) + ' file(s)');
    f.Free;
  end;
  OpenDialog1.Options := OpenDialog1.Options + [ofAllowMultiSelect];
end;

procedure TForm1.ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
var
  N1, N2: Integer;
begin
  if ((Item1.SubItems.Count = 2) and (Item2.SubItems.Count = 2)) then
  begin
    N1 := StrToInt(Item1.SubItems[0]);
    N2 := StrToInt(Item2.SubItems[0]);
    if N1 > N2 then
      Compare := 1
    else if N1 < N2 then
      Compare := -1
    else
    begin
      N1 := StrToInt(Item1.SubItems[1]);
      N2 := StrToInt(Item2.SubItems[1]);
      if N1 > N2 then
        Compare := 1
      else if N1 < N2 then
        Compare := -1
      else
        Compare := 0;
    end;
  end
  else
    Compare := CompareStr(Item1.Caption, Item2.Caption);
end;

procedure TForm1.ListView1CustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if TItemData(Item.Data^).newpath <> '' then
    ListView1.Canvas.Font.Color := clRed;
end;

procedure TForm1.ListView1CustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  ListView1.Canvas.Font.Color := clBlack;
end;

procedure TForm1.ListView2Click(Sender: TObject);
begin
  ListView2SelectItem(Sender, nil, true);
end;

procedure TForm1.ListView2Edited(Sender: TObject; Item: TListItem;
  var S: string);
begin
  serieManager.EditSerie(StrToInt(TItemData(Item.Data^).path), S);
  ListView2SelectItem(Sender, Item, true);
  log('Renaming "' + Item.Caption + '" to "' + S + '"');
end;

procedure TForm1.ListView2SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
  i: Integer;
  format, nom, n, S: string;
  Msg: Boolean;
begin
  Msg := false;
  if ((ListView2.SelCount > 0) and (ListView1.Items.Count > 0)) then
  begin
    format := '[title].[season]x[Episode].[name]';
    for i := 0 to MainMenu1.Items[2].Count - 3 do
      if MainMenu1.Items[2].Items[i].Checked then
        format := MainMenu1.Items[2].Items[i].Caption;

    serieManager.LoadFromXML
      (StrToInt(TItemData(ListView2.Selected.Data^).path));

    for i := 0 to Form1.ListView1.Items.Count - 1 do
    begin
      if (Form1.ListView1.Items[i].SubItems.Count = 2) then
      begin
        S := Form1.ListView1.Items[i].SubItems[0];
        n := Form1.ListView1.Items[i].SubItems[1];

        nom := ReplaceText(format, '&', '');
        nom := ReplaceStr(nom, '[title]', serieManager.GetTitle);
        nom := ReplaceStr(nom, '[season]', S);
        nom := ReplaceStr(nom, '[episode]', n);
        nom := ReplaceStr(nom, '[Season]', leadingZero(S));
        nom := ReplaceStr(nom, '[Episode]', leadingZero(n));
        if ((StrToInt(S) <= serieManager.GetSeasonsCount) and
          (StrToInt(n) <= serieManager.GetEpisodesCount(StrToInt(S)))) then
        begin
          nom := ReplaceStr(nom, '[name]',
            serieManager.GetEpisodeTitle(StrToInt(S), StrToInt(n)));
          Form1.ListView1.Items[i].Caption :=
            nom + ExtractFileExt
            (TItemData(Form1.ListView1.Items[i].Data^).path);
          if TItemData(Form1.ListView1.Items[i].Data^).newpath = '' then
            Msg := true;
          TItemData(Form1.ListView1.Items[i].Data^).newpath :=
            IncludeTrailingPathDelimiter
            (ExtractFileDir(TItemData(Form1.ListView1.Items[i].Data^).path)) +
            nom + ExtractFileExt
            (TItemData(Form1.ListView1.Items[i].Data^).path);
        end
        else
        begin
          ListView1.Items[i].Caption :=
            ExtractFileName(TItemData(ListView1.Items[i].Data^).path);
          TItemData(Form1.ListView1.Items[i].Data^).newpath := '';

          if StrToInt(S) > serieManager.GetSeasonsCount then
          begin
            if Item <> nil then
              log('Serie "' + serieManager.GetTitle + '" contains only ' +
                IntToStr(serieManager.GetSeasonsCount) +
                ' seasons (there is no season ' + IntToStr(StrToInt(S)) + ')');
          end
          else
          begin
            if StrToInt(n) > serieManager.GetEpisodesCount(StrToInt(S)) then
            begin
              if Item <> nil then
                log('Season ' + IntToStr(StrToInt(S)) + ' of "' +
                  serieManager.GetTitle + '" contains only ' +
                  IntToStr(serieManager.GetEpisodesCount(StrToInt(S))) +
                  ' episodes (no episode ' + IntToStr(StrToInt(n)) + ')');
            end;
          end;
          exit;
        end;
      end
      else
      begin
        if Item <> nil then
          log('Season and episode of file "' + Form1.ListView1.Items[i].Caption
            + '" are missing');
      end;
    end;
    if ((Item <> nil) and (Msg)) then
      log('Items that can be renamed are in red');
    ListView1.Repaint;
  end;
end;

procedure TForm1.out1Click(Sender: TObject);
begin
  ListView1.Clear;
  Memo1.Lines.Add('[' + TimeToStr(now) + '] - ' + 'Removing all files');
end;

procedure TForm1.Supprimer1Click(Sender: TObject);
var
  i, Count: Integer;
begin
  Count := 0;
  for i := ListView1.Items.Count - 1 downto 0 do
  begin
    if (ListView1.Items[i].Selected) then
    begin
      Dispose(ListView1.Items[i].Data);
      ListView1.Items[i].Delete;
      inc(Count);
    end;
  end;
  if Count > 0 then
    Memo1.Lines.Add('[' + TimeToStr(now) + '] - ' + 'Removing ' +
      IntToStr(Count) + ' file(s)');
end;

procedure TForm1.Supprimer3Click(Sender: TObject);
begin
  loadSeriesFromXML;
end;

procedure TForm1.Validerlerenommage1Click(Sender: TObject);
var
  i, ok: Integer;
  Count: Integer;
  save: TStringList;
begin
  Count := 0;
  save := TStringList.Create;

  for i := 0 to ListView1.Items.Count - 1 do
  begin
    if (TItemData(ListView1.Items[i].Data^).newpath <> '') then
    begin
      save.Add('ren "' + TItemData(ListView1.Items[i].Data^).newpath + '" "' +
        ExtractFileName(TItemData(ListView1.Items[i].Data^).path) + '"');
      Memo1.Lines.Add('[' + TimeToStr(now) + '] - ' + 'Renaming "' +
        TItemData(ListView1.Items[i].Data^).path + '" to "' +
        ExtractFileName((TItemData(ListView1.Items[i].Data^).newpath) + '"'));
      RenameFile(TItemData(ListView1.Items[i].Data^).path,
        TItemData(ListView1.Items[i].Data^).newpath);
      TItemData(ListView1.Items[i].Data^).path :=
        TItemData(ListView1.Items[i].Data^).newpath;
      TItemData(ListView1.Items[i].Data^).newpath := '';
      inc(Count);
    end;
  end;
  if Count > 0 then
  begin
    Memo1.Lines.Add('[' + TimeToStr(now) + '] - ' + 'Renaming ' +
      IntToStr(Count) + ' file(s) finished');
    ListView1.Refresh;
    if (MainMenu1.Items[4].Items[1].Checked) then
    begin
      ok := MessageDlg('Create a backup ?', mtConfirmation, mbOKCancel, 0);
      SaveDialog1.Title := 'Backup name ...';
      SaveDialog1.Filter := 'Command files|*.bat';
      SaveDialog1.InitialDir := 'E:\Ma Famille D''Abord-My.Wife.and.Kids.S01';
      if ((ok = mrOk) and (SaveDialog1.Execute)) then
      begin
        save.SaveToFile(ChangeFileExt(SaveDialog1.FileName, '.bat'));
        ConvertFileToOEM(ChangeFileExt(SaveDialog1.FileName, '.bat'));
        Memo1.Lines.Add('[' + TimeToStr(now) + '] - ' + 'Writing backup (' +
          ExtractFileName(ChangeFileExt(SaveDialog1.FileName, '.bat')) + ')');
      end;
    end;
  end;
  save.Free;
end;

end.
