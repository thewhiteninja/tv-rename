unit Unit2;

interface

uses
    Windows, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  Controls, ComCtrls, StdCtrls, ExtCtrls, Classes, Forms, RegExpr, StrUtils,
  IdURI, SysUtils, Utils;

type
    TForm2 = class(TForm)
        StatusBar1: TStatusBar;
        LabeledEdit1: TLabeledEdit;
        Button1: TButton;
        Label1: TLabel;
        ListView1: TListView;
        Button2: TButton;
        Button3: TButton;
    IdHTTP1: TIdHTTP;
        procedure Button1Click(Sender: TObject);
        procedure Button2Click(Sender: TObject);
        procedure Button3Click(Sender: TObject);
        procedure FormCreate(Sender: TObject);
    procedure LabeledEdit1KeyPress(Sender: TObject; var Key: Char);
    private
        { Déclarations privées }
    public
        id: integer;
        titre: string;
    end;

var
    Form2: TForm2;

const
    urlSearch = 'http://www.allocine.fr/recherche/6/?q=';

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
var
    url, nom, annee, id: string;
    resp: string;
    count: integer;
    re: TRegExpr;
    i, o: integer;
    item: TListItem;
begin
    if LabeledEdit1.Text <> '' then
    begin
        ListView1.Clear;
        re := TRegExpr.Create;
        re.ModifierI := True;
        re.ModifierG := false;
        IdHTTP1.Disconnect;
        url := urlSearch + ReplaceText(LabeledEdit1.Text, ' ', '+');
        resp := IdHTTP1.Get(TIdURI.URLEncode(url));

        re.Expression := 'Merci de préciser votre recherche :[^0-9]*([0-9]+)';
        if (re.Exec(resp)) then
        begin
            count := StrToInt(re.Match[1]);
            StatusBar1.SimpleText := IntToStr(count) + ' résultat(s) trouvé(s)';

            i := PosEx('<table class="totalwidth noborder purehtml">', resp);
            for o := 0 to count - 1 do
            begin
                item := ListView1.Items.Add;
                i := PosEx('<tr>', resp, i);
                i := PosEx('cserie', resp, i);
                id := trim(copy(resp, i + 7, PosEx('.html', resp, i) - i - 7));

                i := PosEx('<a', resp, i);
                i := PosEx('>', resp, i + 1);
                nom := trim(copy(resp, i + 2, PosEx('</a>', resp, i) - i - 2));
                re.Expression := '<[^>]*>';
                nom := re.Replace(nom, '', True);
                item.Caption := filterName(nom);

                i := PosEx('11">', resp, i + 1);
                annee := trim(copy(resp, i + 4, PosEx('<br', resp, i) - i - 4));
                if (annee = '') then
                    item.SubItems.Add('')
                else
                    item.SubItems.Add(IntToStr(StrToInt(annee)));
                item.ImageIndex := StrToInt(id);

                i := PosEx('<tr>', resp, i);
            end;
        end;

        re.Free;
    end;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
    if (ListView1.SelCount > 0) then
    begin
        id := ListView1.Selected.ImageIndex;
        titre := ListView1.Selected.Caption;
        ModalResult := mrOk;
    end
    else
        ModalResult := mrCancel;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
    ModalResult := mrCancel;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
    id := 0;
    Icon.Assign(Application.Icon);
end;

procedure TForm2.LabeledEdit1KeyPress(Sender: TObject; var Key: Char);
begin
    if (Key = #13) then
    begin
        Key := #0;
        Button1Click(nil);
    end;
end;

end.
