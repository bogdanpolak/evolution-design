unit Test.BabyToyTester;

interface

uses
    System.Classes,
    System.SysUtils,
    System.RTTI,
    System.TypInfo,
    Spring.Collections;

type
    TBabyToyTester = class(TComponent)
    private
        fOutputStrings: TStrings;
    protected
        procedure ClearOutput();
        procedure OutputLog(
            const aFormatedText: string;
            const aFormatArgs: array of const);
    public
        constructor Create(AOwner: TComponent); override;
        function WithOutput(const aOutputStrings: TStrings): TBabyToyTester;
        procedure RunTests();
    end;


implementation

// ---------------------------------------------------------
// TBabyToyTester
// ---------------------------------------------------------


constructor TBabyToyTester.Create(AOwner: TComponent);
begin
    inherited;
    fOutputStrings := nil;
end;


procedure InvokeTestMethods(aComponent: TComponent);
var
    aRttiContext: TRttiContext;
    aClassInfo: TRttiType;
    aSetupMethodInfo: TRttiMethod;
    aTearDownMethodInfo: TRttiMethod;
    aMethodInfo: TRttiMethod;
begin
    aClassInfo := aRttiContext.GetType(aComponent.ClassType);
    aSetupMethodInfo := aClassInfo.GetMethod('Setup');
    aTearDownMethodInfo := aClassInfo.GetMethod('TearDown');
    for aMethodInfo in aClassInfo.GetMethods do
    begin
        if (aMethodInfo.Visibility = mvPublished) and
            (Length(aMethodInfo.GetParameters) = 0) and
            (aMethodInfo.Name.ToUpper <> 'SETUP') and
            (aMethodInfo.Name.ToUpper <> 'TEARDOWN') then
        begin
            if aSetupMethodInfo <> nil then
                aSetupMethodInfo.Invoke(
                    aComponent,
                    []);
            aMethodInfo.Invoke(
                aComponent,
                []);
            if aTearDownMethodInfo <> nil then
                aTearDownMethodInfo.Invoke(
                    aComponent,
                    []);
        end;
    end;
end;


procedure TBabyToyTester.ClearOutput;
begin
    if fOutputStrings <> nil then
        fOutputStrings.Clear();
end;


procedure TBabyToyTester.OutputLog(
    const aFormatedText: string;
    const aFormatArgs: array of const);
begin
    if fOutputStrings <> nil then
        fOutputStrings.Add(Format(aFormatedText, aFormatArgs));
end;


procedure TBabyToyTester.RunTests();
begin
    ClearOutput();
    InvokeTestMethods(Self);
end;


function TBabyToyTester.WithOutput(const aOutputStrings: TStrings): TBabyToyTester;
begin
    Result := Self;
    fOutputStrings := aOutputStrings;
end;

// ---------------------------------------------------------


end.

