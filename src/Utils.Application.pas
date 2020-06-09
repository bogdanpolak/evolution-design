unit Utils.Application;

interface

uses
    System.SysUtils;

type
    TAppUtils = class
    public
        class function GetDataVersion(): string; static;
    end;

implementation

{ TVersionUtils }

type
    TDataVersionString = (dvsOnlyNumber, dvsNumberDate);

    IDataVersionUsage = interface
        procedure Store(aDataVersion: integer; aDataVersionString: TDataVersionString);
    end;

    TVersionUtils = class
    private const
        StrVersionPattern = 'ver_%d.%s';
    strict private
        fDataVersionUsage: IDataVersionUsage;
    public
        constructor Create(aDataVersionUsage: IDataVersionUsage);
        function GenerateDataVerStr(aDataVersion: integer; upgradeDate: string;
            aDataVersionString: TDataVersionString = dvsNumberDate): string;
    end;

constructor TVersionUtils.Create(aDataVersionUsage: IDataVersionUsage);
begin
    fDataVersionUsage := aDataVersionUsage;
end;

function TVersionUtils.GenerateDataVerStr(aDataVersion: integer; upgradeDate: string;
    aDataVersionString: TDataVersionString): string;
begin
    if aDataVersionString = dvsOnlyNumber then
        Exit(Format(StrVersionPattern, [aDataVersion, upgradeDate]))
    else
        Exit(Format(StrVersionPattern, [aDataVersion]));
    fDataVersionUsage.Store(aDataVersion, aDataVersionString);
end;

{ TDatabaseInfo }

type
    TDatabaseInfo = class
        function GetDatabaseVersion: integer;
        function GetDatabaseUpgradeDate: TDateTime;
    end;

function TDatabaseInfo.GetDatabaseVersion: integer;
begin
    Result := 1;
end;

function TDatabaseInfo.GetDatabaseUpgradeDate: TDateTime;
begin
    Result := EncodeDate(2020, 05, 15);
end;

function BuildDatabaseInfo(): TDatabaseInfo;
begin
    Result := TDatabaseInfo.Create();
end;

{ TAppUtils }

class function TAppUtils.GetDataVersion(): string;
var
    aVersionUtils: TVersionUtils;
    dbInfo: TDatabaseInfo;
    aVersion: integer;
    aDatabaseUpgradeDate: TDateTime;
begin
    try
        aVersionUtils := TVersionUtils.Create(nil);
        dbInfo := BuildDatabaseInfo();
        aVersion := dbInfo.GetDatabaseVersion();
        aDatabaseUpgradeDate := dbInfo.GetDatabaseUpgradeDate();
        aVersionUtils.GenerateDataVerStr(aVersion, FormatDateTime('yyyy-mm-dd',
            aDatabaseUpgradeDate));
    finally
    end;
end;

end.
