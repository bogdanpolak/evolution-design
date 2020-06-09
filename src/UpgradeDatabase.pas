unit UpgradeDatabase;

interface

uses
    System.Classes,
    System.SysUtils,
    FireDAC.Comp.Client;

type
    TDatabaseUpgrader = class
    public
        class procedure UpgradeDatabase(aConnection: TFDConnection);
        constructor Create(aConnection: TFDConnection);
        procedure Execute();
    private const
        DATABASE_ExpectedVersion = 2;
    private
        fConnection: TFDConnection;
        procedure CreateVersionTableIfNotExist();
        function GetDatabaseVersion(): integer;
        function Ver001_to_Ver002: integer;
    end;

implementation


procedure SendLog (const aText: string; const aParams: array of const);
begin
end;

constructor TDatabaseUpgrader.Create(aConnection: TFDConnection);
begin
    fConnection := aConnection;
end;

class procedure TDatabaseUpgrader.UpgradeDatabase(aConnection: TFDConnection);
begin
    with TDatabaseUpgrader.Create(aConnection) do
        try
            Execute()
        finally
            Free;
        end;
end;

procedure TDatabaseUpgrader.Execute();
var
    aCurrentVersion: integer;
begin
    aCurrentVersion := GetDatabaseVersion();
    while aCurrentVersion < DATABASE_ExpectedVersion do
    begin
        SendLog('Version before - %d',[aCurrentVersion]);
        case aCurrentVersion of
            1:
                aCurrentVersion := Ver001_to_Ver002()
        else
            raise Exception.Create('Unspported database version');
        end;
        SendLog('Version after - %d',[aCurrentVersion])
    end;
end;

procedure TDatabaseUpgrader.CreateVersionTableIfNotExist;
var
    slNames: TStringList;
begin
    slNames := TStringList.Create();
    try
        fConnection.GetTableNames('', '', 'Configuration', slNames);
        if slNames.Count = 0 then
        begin
            fConnection.ExecSQL('CREATE TABLE Configuration (' +
            {} ' Name varchar(30) NOT NULL,' +
            {} ' Value varchar(255),' +
            {} ' Description varchar(255),' +
            {} ' Primary Key (Name))');
            fConnection.ExecSQL('INSERT INTO Configuration' +
            {} ' (Name,Value,Description)' +
            {}' VALUES (''Version'',''1'',''Database version'')');
        end;
    finally
        slNames.Free;
    end;
end;

function TDatabaseUpgrader.GetDatabaseVersion(): integer;
var
    sVersion: string;
begin
    CreateVersionTableIfNotExist();
    sVersion := fConnection.ExecSQLScalar
        ('SELECT Value FROM Configuration WHERE Name=''Version''');
    Result := StrToInt(sVersion);
end;

function TDatabaseUpgrader.Ver001_to_Ver002(): integer;
begin
    Result := 2;
end;

end.
