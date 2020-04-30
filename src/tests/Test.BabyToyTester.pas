unit Test.BabyToyTester;

interface

uses
    System.Classes,
    System.SysUtils,
    Spring.Collections;

type
    TBabyToyTester = class
    private
        class var fOutputStrings: TStrings;
        class procedure Test1();
    public
        class procedure RunTests(const aOutputStrings: TStrings);
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
    TOrdersStoreFake = class(TInterfacedObject, IOrdersStore)
    private
        fList: IList<TOrder>;
    public
        constructor Create(aList: IList<TOrder>);
        procedure Init(aDataModuleOrdes: TDataModuleOrders);
        function GetOrders(): IList<TOrder>;
    end;

constructor TOrdersStoreFake.Create(aList: IList<TOrder>);
begin
    fList:= aList;
end;

function TOrdersStoreFake.GetOrders: IList<TOrder>;
begin
    Result:= fList;
end;


procedure TOrdersStoreFake.Init(aDataModuleOrdes: TDataModuleOrders);
begin
end;


// ---------------------------------------------------------
// TSimpleOrderProcessorTest
// ---------------------------------------------------------


function WithOrderList(const aRequireDates: TArray<TDateTime>): IList<TOrder>;
var
  idx: Integer;
begin
    Result := TCollections.CreateList<TOrder>(true);
    for idx := 0 to High(aRequireDates) do
    begin
        Result.Add( TOrder.Create().WithRequiredDate(aRequireDates[idx]) );
    end;
end;

class procedure TBabyToyTester.RunTests(const aOutputStrings: TStrings);
begin
    fOutputStrings := aOutputStrings;
    Test1;
end;


class procedure TBabyToyTester.Test1;
var
    aOrders: IList<TOrder>;
    aOrderProcessor: TOrderProcessor;
begin
    aOrders := WithOrderList([
        EncodeDate(2020,04,04),  // termianted order
        EncodeDate(2020,05,12),  // urgent order (have to be shipped within 14 days
        EncodeDate(2020,06,04)   // normal order
    ]);

    aOrderProcessor := TOrderProcessor.Create(TOrdersStoreFake.Create(aOrders));

    fOutputStrings.Clear();
    fOutputStrings.Add(Format('  GetUrgentOrders()          | actual: %d',
        [aOrderProcessor.GetUrgentCount()]));
    fOutputStrings.Add(Format('  GetTerminatedOrdersCount() | actual: %d',
        [aOrderProcessor.GetTerminatedOrdersCount()]));

    aOrderProcessor.Free;
end;

// ---------------------------------------------------------


end.
