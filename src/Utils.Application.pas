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
end;

procedure p1(var x: Integer);
begin
    x := 5;
end;

type
    TApplication = class
    const
        Title = 'Pattern Evolution - Orders Processor';
        Copyright = Title + ' (c) 2020 by Bogdan Polak';
    end;

    TAppHeader = packed record
        CopyrightLine: string[40];
    end;

    TAbstractData = class
        procedure Abstraction; virtual; abstract;
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
        Value: Integer;
    end;

    TDerived = class(TBase)
        fValue: Integer;
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
    abstractData := TAbstractData.Create();
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
    p0(0);
    // -----------------------------------------------------------------
end;


// ===========================================================================
// Delphi Hints
// ===========================================================================

{$HINTS OFF}

procedure Test_UnusedVariable;
var
    aUnusedVariable: Integer;
begin
end;
{$HINTS ON}

type
{.$HINTS OFF}
    TSymbolNeverUsed = class
    private
        fBar1: Integer;
        fBar2: Integer;
    public
        property Bar: Integer read fBar2 write fBar2;
    end;

procedure RunWith_Hints;
var
    aUnusedVariable: Integer;
    aValue: Integer;
begin
    // -----------------------------------------------------------------
    // H2219 Private symbol '%s' declared but never used (Delphi)
    with TSymbolNeverUsed.Create() do
    begin
        Bar := 1;
        Free;
    end;
    // -----------------------------------------------------------------
    aValue := 20;
end;

// ===========================================================================
// TMS FixInsight Warnings
// ===========================================================================

function DoSomething(aInput: Integer): Integer;
var
    Bar: Integer;
begin
    with TSymbolNeverUsed.Create() do
    begin
        Bar := 1;
        Free;
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
var
  isNewFormat: Boolean;
begin
    isNewFormat := aDataVersionString = dvsNumberDate;
    if isNewFormat then
        Exit(Format('ver.%d.%s', [aDataVersion, upgradeDate]))
    else
        Exit(Format('ver.%d.%s', [aDataVersion]));
    fDataVersionUsage.Store(aDataVersion, aDataVersionString);
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
    try
        aVersionUtils := TVersionUtils.Create(nil);
        dbInfo := BuildDatabaseInfo();
        aVersion := dbInfo.GetDatabaseVersion();
        aDatabaseUpgradeDate := dbInfo.GetDatabaseUpgradeDate();
        aVersionUtils.GenerateDataVerStr(aVersion, FormatDateTime('yyyy-mm-dd',
            aDatabaseUpgradeDate));
    finally
    end;
    RunWith_Warnings();
end;

end.
