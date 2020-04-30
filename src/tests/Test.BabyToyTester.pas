unit Test.BabyToyTester;

interface

uses
    System.Classes,
    System.SysUtils,
    Spring.Collections;

type
    TBabyToyTester = class(TComponent)
    private
        fOutputStrings: TStrings;
        procedure ClearOutput();
        procedure OutputLog(
            const aFormatedText: string;
            const aFormatArgs: array of const);
    public
        constructor Create(AOwner: TComponent); override;
        function WithOutput(const aOutputStrings: TStrings): TBabyToyTester;
        procedure RunTests();
    published
        procedure Test1();
    end;


implementation

uses
    Model.Interfaces,
    DataModule.Orders,
    Model.Order,
    Model.OrderProcessor;


// ---------------------------------------------------------
// TFakeOrdersStore
// ---------------------------------------------------------

type
    TOrdersStoreFake = class(TInterfacedObject,
                             IOrdersStore)
    private
        fList: IList<TOrder>;
    public
        constructor Create(aList: IList<TOrder>);
        procedure Init(aDataModuleOrdes: TDataModuleOrders);
        function GetOrders(): IList<TOrder>;
    end;

constructor TOrdersStoreFake.Create(aList: IList<TOrder>);
begin
    fList := aList;
end;


function TOrdersStoreFake.GetOrders: IList<TOrder>;
begin
    Result := fList;
end;


procedure TOrdersStoreFake.Init(aDataModuleOrdes: TDataModuleOrders);
begin
end;


// ---------------------------------------------------------
// TSimpleOrderProcessorTest
// ---------------------------------------------------------


constructor TBabyToyTester.Create(AOwner: TComponent);
begin
    inherited;
    fOutputStrings := nil;
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
    Test1;
end;


function WithOrderList(const aRequireDates: TArray<TDateTime>): IList<TOrder>;
var
    idx: Integer;
begin
    Result := TCollections.CreateList<TOrder>(true);
    for idx := 0 to High(aRequireDates) do
    begin
        Result.Add(TOrder.Create().WithRequiredDate(aRequireDates[idx]));
    end;
end;


procedure TBabyToyTester.Test1;
var
    aOrders: IList<TOrder>;
    aOrderProcessor: TOrderProcessor;
begin
    aOrders := WithOrderList([EncodeDate(2020, 04, 04), // termianted order
        EncodeDate(2020, 05, 05), // urgent order (have to be shipped within 14 days
        EncodeDate(2020, 06, 04) // normal order
        ]);

    aOrderProcessor := TOrderProcessor.Create(TOrdersStoreFake.Create(aOrders));

    OutputLog(
        '  GetUrgentOrders()          = 1 | actual: %d',
        [aOrderProcessor.GetUrgentCount()]);
    OutputLog(
        '  GetTerminatedOrdersCount() = 1 | actual: %d',
        [aOrderProcessor.GetTerminatedOrdersCount()]);

    aOrderProcessor.Free;
end;


function TBabyToyTester.WithOutput(const aOutputStrings: TStrings): TBabyToyTester;
begin
    Result := Self;
    fOutputStrings := aOutputStrings;
end;

// ---------------------------------------------------------


end.
