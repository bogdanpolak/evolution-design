unit Test.OrderProcessor;

interface

uses
    System.Classes,
    System.SysUtils,
    System.RTTI,
    Spring.Collections,
    Test.BabyToyTester,
    {}
    Model.OrderProcessor,
    Model.Interfaces,
    Model.Order,
    Delphi.Mocks;

type
    TestOrderProcessor = class(TBabyToyTester)
    private
        fOrders: IList<TOrder>;
        fOrderProcessor: TOrderProcessor;
        fMockOrderStore: TMock<IOrdersStore>;
        procedure GivenOrders_WithRequireDates(const aRequireDates: TArray<TDateTime>);
    public
        procedure Setup;
        procedure Teardown;
    published
        procedure GetTerminatedOrdersCount;
        procedure TestGetUrgentCount;
    end;


implementation


function Today(): TDateTime;
begin
    Result := Date();
end;


procedure TestOrderProcessor.Setup;
begin
    fOrders := TCollections.CreateObjectList<TOrder>(true);

    fMockOrderStore := TMock<IOrdersStore>.Create();
    fMockOrderStore.Setup
        .WillReturn(TValue.From<IList<TOrder>>(fOrders))
        .When.GetOrders();

    fOrderProcessor := TOrderProcessor.Create(fMockOrderStore);
end;


procedure TestOrderProcessor.Teardown;
begin
    fOrderProcessor.Free;
end;


procedure TestOrderProcessor.GivenOrders_WithRequireDates(
	const aRequireDates: TArray<TDateTime>);
var
  idx: Integer;
begin
    for idx := 0 to High(aRequireDates) do
	    fOrders.Add(TOrder.Create().WithRequiredDate(aRequireDates[idx]));
end;


procedure TestOrderProcessor.TestGetUrgentCount;
var
    actualUrgent: Integer;
begin
    GivenOrders_WithRequireDates([
        Today()+2
    ]);

    actualUrgent := fOrderProcessor.GetUrgentCount();

    OutputLog(
        '  GetUrgentOrders()          = 1 | actual: %d',
        [actualUrgent]);
end;


procedure TestOrderProcessor.GetTerminatedOrdersCount;
var
    actualTerminated: Integer;
begin
    GivenOrders_WithRequireDates([
        Today()+25,
        Today()-365,
        Today()-3,
        Today()+1,
        Today()+365
    ]);

    actualTerminated := fOrderProcessor.GetTerminatedOrdersCount();

    OutputLog(
        '  GetTerminatedOrdersCount() = 2 | actual: %d',
        [actualTerminated]);
end;

end.
