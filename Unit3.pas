unit Unit3;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, ExtCtrls;

type
    TForm3 = class(TForm)
        Button1: TButton;
        Button2: TButton;
        LabeledEdit2: TLabeledEdit;
        LabeledEdit3: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
    private
        { Déclarations privées }
    public
        { Déclarations publiques }
    end;

var
    Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.FormCreate(Sender: TObject);
begin
    Icon.Assign(Application.Icon);
end;

end.
