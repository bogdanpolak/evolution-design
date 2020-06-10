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

// ===========================================================================
// Delphi Warnings
// ===========================================================================

type
    TWeekDay = (wdMonday, wdTuesday, wdWednesday, wdThursday, wdFriday);

procedure SendToLog(const aText: string; const aParams: array of const);
begin
    Format(aText, aParams);
end;

procedure p0(p: PWordArray);
begin
    if p<>nil then
        p^[0]:=1;
    if p <> nil then
        p^[0] := 1;
end;

procedure p1(x: Integer);
begin
    x := 5;
    if x > 0 then
        SendToLog('%d', [x]);
end;

type
    TApplication = class
    const
        Title = 'Pattern Evolution - Orders Processor';
        Copyright = Title + ' (c) 2020 by Bogdan Polak';
    end;

    TAppHeader = packed record
        CopyrightLine: string[80];
    end;

    TAbstractData = class
        procedure Abstraction; virtual; abstract;
    end;

    TBussinessData = class(TAbstractData)
        procedure Abstraction; override;
    end;

// -----------------------------------------------------------------------------
// http://docwiki.embarcadero.com/RADStudio/Rio/en/Warning_messages_(Delphi)
// -----------------------------------------------------------------------------
// ON OFF ERROR DEFAULT

{$WARN HIDING_MEMBER DEFAULT}   // W1009 Redeclaration of '%s' hides a member in the base class
{$WARN USE_BEFORE_DEF DEFAULT}  // W1036 Variable '%s' might not have been initialized (Delphi)
{$WARN NO_RETVAL DEFAULT}       // W1035 Return value of function '%s' might be undefined (Delphi)

type
    // -----------------------------------------------------------------
    // W1009 Redeclaration of '%s' hides a member in the base class
    TBase = class
    protected
        fValue: Integer;
    end;

    TDerived = class(TBase)
        property Value: Integer read fValue write fValue;
    end;
    // -----------------------------------------------------------------

// W1035 Return value of function '%s' might be undefined (Delphi)
function HoursPerDay(aWeekDay: TWeekDay): Double;
begin
    case aWeekDay of
        wdMonday, wdTuesday, wdWednesday:
            Result := 4.5;
        wdFriday:
            Result := 6;
    else
        Result := 0;
    end;
end;

procedure RunWith_Warnings;
var
    ch: char;
    aHeader: TAppHeader;
    i: Integer;
    aZoomSession: Integer;
    abstractData: TAbstractData;
begin
    // -----------------------------------------------------------------
    abstractData := TBussinessData.Create();
    abstractData.Free;
    // -----------------------------------------------------------------
    // W1050 WideChar reduced to byte char in set expressions
{$WARN WIDECHAR_REDUCED OFF}
    ch := 'a';
    if ch in ['a', 'b'] then
        SendToLog('character = ', [ch]);
{$WARN WIDECHAR_REDUCED DEFAULT}
    // -----------------------------------------------------------------
    // W1015 FOR-Loop variable '%s' cannot be passed as var parameter
    for i := 0 to 5 do
        p1(i);
    // -----------------------------------------------------------------
    // W1036 Variable '%s' might not have been initialized (Delphi)
    try
        Assert(TApplication.Title = 'Pattern Evolution');
        aZoomSession := 9;
    except
        aZoomSession := 0;
    end;
    SendToLog('Session nr: %d', [aZoomSession]);
    // -----------------------------------------------------------------
    // W1014 String constant truncated to fit STRING%ld (Delphi)
    aHeader.CopyrightLine := TApplication.Copyright;
    // -----------------------------------------------------------------
    // W1013 Constant 0 converted to NIL (Delphi)
    p0(nil);
    // -----------------------------------------------------------------
end;


// ===========================================================================
// Delphi Hints
// ===========================================================================

{$HINTS OFF}

procedure Test_UnusedVariable;
var
    aUnusedVariable: Integer;
begin  //FI:W519
    // TODO: Robota na "jutro"
end;
{$HINTS ON}

type
{.$HINTS OFF}
    TSymbolNeverUsed = class
    private
        fBar2: Integer;
    public
        property Bar: Integer read fBar2 write fBar2;
    end;

procedure RunWith_Hints;
begin
    // -----------------------------------------------------------------
    // H2219 Private symbol '%s' declared but never used (Delphi)
    with TSymbolNeverUsed.Create() do
    begin
        Bar := 1;
        Free;
    end;
    // -----------------------------------------------------------------
end;

// ===========================================================================
// TMS FixInsight Warnings
// ===========================================================================

function DoSomething(): Integer;
var
    aBar: Integer;
    aSymbolNeverUsed: TSymbolNeverUsed;
begin
    aBar := 1;
    Result := aBar;
    aSymbolNeverUsed := TSymbolNeverUsed.Create();
    try
        aSymbolNeverUsed.Bar := aBar;
    finally
        aSymbolNeverUsed.Free;
    end;
end;

// ===========================================================================
// ===========================================================================

{ TVersionUtils }

type
    TDataVersionString = (dvsOnlyNumber, dvsNumberDate);

    IDataVersionUsage = interface
        procedure Store(aDataVersion: Integer; aDataVersionString: TDataVersionString);
    end;

    TVersionUtils = class
    strict private
        fDataVersionUsage: IDataVersionUsage;
    public
        constructor Create(aDataVersionUsage: IDataVersionUsage);
        function GenerateDataVerStr(aDataVersion: Integer; upgradeDate: string;
            aDataVersionString: TDataVersionString = dvsNumberDate): string;
    end;

constructor TVersionUtils.Create(aDataVersionUsage: IDataVersionUsage);
begin
    fDataVersionUsage := aDataVersionUsage;
end;

function TVersionUtils.GenerateDataVerStr(aDataVersion: Integer; upgradeDate: string;
    aDataVersionString: TDataVersionString): string;
begin
    if aDataVersionString = dvsNumberDate then
    begin
        fDataVersionUsage.Store(aDataVersion, aDataVersionString);
        Result := Format('ver.%d.%s', [aDataVersion, upgradeDate]);
    end
    else
        Result := Format('ver.%d', [aDataVersion]);
end;

{ TDatabaseInfo }

type
    TDatabaseInfo = class
        function GetDatabaseVersion: Integer;
        function GetDatabaseUpgradeDate: TDateTime;
    end;

function TDatabaseInfo.GetDatabaseVersion: Integer;
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
    aVersion: Integer;
    aDatabaseUpgradeDate: TDateTime;
begin
    aVersionUtils := TVersionUtils.Create(nil);
    try
        try
            dbInfo := BuildDatabaseInfo();
            aVersion := dbInfo.GetDatabaseVersion();
            aDatabaseUpgradeDate := dbInfo.GetDatabaseUpgradeDate();
            Result := aVersionUtils.GenerateDataVerStr(aVersion, FormatDateTime('yyyy-mm-dd',
                aDatabaseUpgradeDate));
        finally
            aVersionUtils.Free;
        end;
    except on e: Exception do
        begin
            RunWith_Warnings();
            Result := '';
        end;
    end;
end;

{ TBussinessData }

procedure TBussinessData.Abstraction;
begin
end;

end.
