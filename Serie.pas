unit Serie;

interface

uses XMLDoc, Utils, StrUtils, SysUtils, IdHTTP, IdBaseComponent,
    IdComponent, IdTCPConnection, IdTCPClient, Dialogs;

type
    TSerieManager = class(TObject)
    private
        _path: string;
        _id: integer;
        _title: string;
        _episode: array of array of string;
    public
        constructor Create(path: string);
        destructor Destroy; override;
        function GetID: integer;
        function GetTitle: string;
        function GetSeasonsCount: integer;
        function GetEpisodesCount(season: integer): integer;
        function GetEpisodeTitle(season: integer; episode: integer): string;
        procedure EditSerie(id: Integer; title: string);
        function Exists(id: integer): boolean;
        procedure LoadFromXML(id: integer);
        procedure SaveToXML;
        procedure addFromAllocine(id: integer; title : string);
    end;

implementation

uses Unit1;

const
    urlSaison = 'http://www.allocine.fr/series/ficheserie-XX/saisons/';
    urlAutreSaison = 'http://www.allocine.fr/series/ficheserie-XX1/saison-XX2/';

constructor TSerieManager.Create(path: string);
begin
    _path := path;
    _id := 0;
    _title := '';
    SetLength(_episode, 0);
end;

destructor TSerieManager.Destroy;
begin
    SetLength(_episode, 0);
    inherited;
end;

function TSerieManager.GetID: integer;
begin
    Result := _id;
end;

function TSerieManager.GetTitle: string;
begin
    Result := _title;
end;

function TSerieManager.GetSeasonsCount: integer;
begin
    Result := Length(_episode);
end;

function TSerieManager.GetEpisodesCount(season: integer): integer;
begin
    if season <= Length(_episode) then
        Result := Length(_episode[season - 1])
    else
        Result := 0;
end;

function TSerieManager.GetEpisodeTitle(season: integer; episode: integer)
  : string;
begin
    if ((season <= Length(_episode)) and
          (episode <= Length(_episode[season - 1]))) then
        Result := _episode[season - 1][episode - 1]
    else
        Result := '';
end;

procedure TSerieManager.EditSerie(id: Integer; title: string);
var
    XMLDoc: TXMLDocument;
    i: Integer;
begin
    XMLDoc := TXMLDocument.Create(Form1);
    XMLDoc.Active := true;
    try
        if _id=id then _title := title;

        XMLDoc.LoadFromFile(_path);

        for i := 0 to XMLDoc.DocumentElement.ChildNodes.Count - 1 do
        begin
            if XMLDoc.DocumentElement.ChildNodes[i].Attributes['id'] = IntToStr
              (id) then
            begin
                XMLDoc.DocumentElement.ChildNodes[i].ChildNodes[0].Text := title;
                break;
            end;
        end;

        XMLDoc.SaveToFile(_path);
    finally
        XMLDoc.Active := false;
        XMLDoc.Free;
    end;
end;

procedure TSerieManager.addFromAllocine(id: integer; title : string);
var
    urlMain: string;
    page, num, titre, check, buf: string;
    pos, saison, curSaison, posmax, seasonCount, index: Integer;
    autrePage: array of string;
    http : TIdHTTP;
begin
    _id := id;
    _title := title;

    urlMain := AnsiReplaceText(urlSaison, 'XX', IntToStr(id));

    http := TIdHTTP.Create(Form1);
    http.HandleRedirects := True;
    page := http.Get(urlMain);

    pos := posex('class="card card-entity card-season cf card-entity-list hred"', page);
    SetLength(autrePage, 50);
    seasonCount := 0;
    pos := posex('saison-', page, pos + 1);
    while (pos <> 0) do
    begin
        autrePage[seasonCount] := Copy(page, pos + 7, posex('/', page, pos)
              - pos - 7);

        pos := posex('>', page, pos + 1);
        inc(seasonCount);
        pos := posex('class="card card-entity card-season cf card-entity-list hred"', page, pos+1);
        if pos = 0 then
          break;
        pos := posex('saison-', page, pos + 1);
    end;
    SetLength(autrePage, seasonCount);

    SetLength(_episode, seasonCount);

    log('Number of seasons: ' + IntToStr(seasonCount));


    for saison := seasonCount downto 1 do
    begin
        urlMain := AnsiReplaceText(urlAutreSaison, 'XX1', IntToStr(id));
        urlMain := AnsiReplaceText(urlMain, 'XX2', autrePage[saison - 1]);
        page := http.Get(urlMain);

        pos := posex('titlebar-page"><div class="titlebar-title titlebar-title-lg"', page)+60;
        if (posex('Saison ', page, pos)-pos) < 15  then pos := posex('Saison ', page, pos)+7
        else continue;

        if TryStrToInt(Copy(page, pos, posex('<', page, pos)-pos), curSaison) then
        begin


        log( 'Season ' + IntToStr(curSaison) + ' ...');

        index := 0;
        SetLength(_episode[curSaison-1], 50);

        pos := posex('class="card-entity card-episode row row-col-padded-10 hred"', page);
        pos := posex('"meta-title">', page, pos)+14;
        pos := posex('>S', page, pos);
        while pos <> 0 do
        begin
            num := Copy(page, pos+5, 2);
            pos := pos + 10;
            titre := Copy(page, pos, posex('</', page, pos) - pos);
            _episode[curSaison-1][StrToInt(num) - 1] := filterName(titre);
            inc(index);
            pos := posex('class="card-entity card-episode row row-col-padded-10 hred"', page, pos);
            if pos = 0 then break;
            pos := posex('"meta-title">', page, pos);
            if pos = 0 then break;
            pos := posex('>S', page, pos);
        end;
        SetLength(_episode[curSaison-1], index);



        end;

    end;

    http.Disconnect;
    http.Free;

    SaveToXML;
end;

procedure TSerieManager.LoadFromXML(id: integer);
var
    iSerie, iSaison, iEpisode: integer;
    XMLDoc: TXMLDocument;
begin
    _id := id;

    XMLDoc := TXMLDocument.Create(Form1);
    XMLDoc.Active := true;
    if FileExists(_path) then
    begin
        XMLDoc.LoadFromFile(_path);
        with XMLDoc.DocumentElement.ChildNodes do
        begin
            for iSerie := 0 to Count - 1 do
            begin
                if Get(iSerie).Attributes['id'] = IntToStr(id) then
                begin
                    _title := Get(iSerie).ChildNodes[0].Text;
                    with Get(iSerie).ChildNodes[1].ChildNodes do
                    begin
                        SetLength(_episode, Count);
                        for iSaison := 0 to Count - 1 do
                        begin
                            SetLength(_episode[iSaison], Get(iSaison)
                                  .ChildNodes[0].ChildNodes.Count);
                            for iEpisode := 0 to Get(iSaison)
                              .ChildNodes[0].ChildNodes.Count - 1 do
                            begin
                                _episode[iSaison][iEpisode] := Get(iSaison)
                                  .ChildNodes[0].ChildNodes[iEpisode].ChildNodes
                                  [0].Text;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
    XMLDoc.Active := false;
    XMLDoc.Free;
end;

procedure TSerieManager.SaveToXML;
var
    XMLDoc: TXMLDocument;
    i, o: integer;
begin
    if _id <> 0 then
    begin
        XMLDoc := TXMLDocument.Create(Form1);
        XMLDoc.Active := true;
        try
            if FileExists(_path) then
            begin
                XMLDoc.LoadFromFile(_path);
            end
            else
            begin
                XMLDoc.Version := '1.0';
                XMLDoc.Encoding := 'UTF-8';
                XMLDoc.DocumentElement := XMLDoc.CreateElement('Series', '');
            end;

            with XMLDoc.DocumentElement.AddChild('Serie') do
            begin
                Attributes['id'] := _id;
                AddChild('Name').Text := _title;
                with AddChild('Seasons') do
                begin
                    for i := 0 to Length(_episode) - 1 do
                    begin
                        with AddChild('Season') do
                        begin
                            Attributes['num'] := IntToStr(i + 1);
                            with AddChild('Episodes') do
                            begin
                                for o := 0 to Length(_episode[i]) - 1 do
                                begin
                                    with AddChild('Episode') do
                                    begin
                                        Attributes['num'] := IntToStr(o + 1);
                                        AddChild('Title').Text := _episode[i]
                                        [o];
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;

            XMLDoc.SaveToFile(_path);
        finally
            XMLDoc.Active := false;
            XMLDoc.Free;
        end;
    end;
end;

function TSerieManager.Exists(id: integer): boolean;
var
    pos : integer;
    XMLDoc: TXMLDocument;
begin
    Result := false;
    XMLDoc := TXMLDocument.Create(Form1);
    XMLDoc.Active := true;
    if FileExists(_path) then
    begin
        XMLDoc.LoadFromFile(_path);
        for pos := 0 to XMLDoc.DocumentElement.ChildNodes.Count - 1 do
        begin
            if XMLDoc.DocumentElement.ChildNodes[pos].Attributes['id']
              = IntToStr(id) then
            begin
                Result := true;
                break;
            end;
        end;
    end;
    XMLDoc.Active := false;
    XMLDoc.Free;
end;

end.
