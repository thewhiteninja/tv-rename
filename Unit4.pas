unit Unit4;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ComCtrls, StdCtrls, ExtCtrls, StrUtils, Utils;

type
    TForm4 = class(TForm)
        StatusBar1: TStatusBar;
        LabeledEdit2: TLabeledEdit;
        Label1: TLabel;
        Button1: TButton;
        Button2: TButton;
        Label2: TLabel;
        Label3: TLabel;
        Label4: TLabel;
        Button3: TButton;
        Button4: TButton;
    Button5: TButton;
    BalloonHint1: TBalloonHint;
    GroupBox1: TGroupBox;
    ListBox1: TListBox;
        procedure FormCreate(Sender: TObject);
        procedure LabeledEdit2Change(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    private
        { Déclarations privées }
    public
        { Déclarations publiques }
    end;

var
    Form4: TForm4;

implementation

{$R *.dfm}


procedure TForm4.Button1Click(Sender: TObject);
begin
    ListBox1.Items.Add(LabeledEdit2.Text);
end;

procedure TForm4.Button2Click(Sender: TObject);
var i : integer;
begin
        for i := 0 to ListBox1.Items.Count - 1 do
            if ListBox1.Selected[i] then
            begin
             ListBox1.DeleteSelected;
             break;
            end;

        if i>0 then dec(i);
        LabeledEdit2.Text := ListBox1.Items[i];
end;

procedure TForm4.FormCreate(Sender: TObject);
var
    format: TStringList;
    i: integer;
begin
    icon.Assign(Application.icon);

    format := TStringList.Create;
    if FileExists(IncludeTrailingPathDelimiter
          (ExtractFileDir(Application.ExeName)) + 'formats.dat') then
        format.LoadFromFile(IncludeTrailingPathDelimiter
              (ExtractFileDir(Application.ExeName)) + 'formats.dat');

    if format.Count > 0 then
    begin
        for i := 0 to format.Count - 1 do
        begin
            if ((trim(format[i]) = '') or (trim(format[i])[1] = '#')) then
            begin
                Continue;
            end;
            ListBox1.Items.Add(format[i]);
        end;
    end
    else
    begin
        ListBox1.Items.Add('[title].[season]x[Episode].[name]');
        ListBox1.Items.Add('[title].S[Season]E[Episode].[name]');
    end;

    format.Free;
    LabeledEdit2.Text := ListBox1.Items[0];

    Button5.Hint := 'Help :'+#13#10+
                    ''+#13#10+
                    '[title]        title'+#13#10+
                    '[season]    season number '+#13#10+
                    '[Season]    season number zero-padded'+#13#10+
                    '[episode]  episode number'+#13#10+
                    '[Episode]  episode number zero-padded'+#13#10+
                    '[name]        episode name'+#13#10+
                    '';
end;

procedure TForm4.LabeledEdit2Change(Sender: TObject);
var
nom : string;
begin
    nom := LabeledEdit2.Text;
    nom := ReplaceStr(nom, '[title]', 'MacGyver');
    nom := ReplaceStr(nom, '[season]', '2');
    nom := ReplaceStr(nom, '[episode]', '5');
    nom := ReplaceStr(nom, '[Season]', '02');
    nom := ReplaceStr(nom, '[Episode]', '05');
    nom := ReplaceStr(nom, '[name]', 'Final approach');
    nom := nom  + '.avi';
    Label4.Caption := nom;
end;

procedure TForm4.ListBox1Click(Sender: TObject);
var i : integer;
begin
        for i := 0 to ListBox1.Items.Count - 1 do
            if ListBox1.Selected[i] then LabeledEdit2.Text := ListBox1.Items[i];
end;

end.
