unit Test.OrderProcessor;

interface

uses
    System.Classes,
    System.SysUtils,
    Spring.Collections,
    Test.BabyToyTester,
    {}
    Model.OrderProcessor,
    Model.Interfaces,
    Model.Order,
    Fake.OrderStore;

type
    TestOrderProcessor = class(TBabyToyTester)
    private
        fOrders: IList<TOrder>;
        fOrderProcessor: TOrderProcessor;
        fFakeOrderStore: TOrdersStoreFake;
    public
        procedure Setup;
        procedure Teardown;
    published
        procedure GetTerminatedOrdersCount;
        procedure TestGetUrgentCount;
    end;


implementation


procedure TestOrderProcessor.Setup;
begin
    fOrders := TCollections.CreateObjectList<TOrder>(true);
    fFakeOrderStore := TOrdersStoreFake.Create(fOrders);
    fOrderProcessor := TOrderProcessor.Create(fFakeOrderStore);
end;


procedure TestOrderProcessor.Teardown;
begin
    fOrderProcessor.Free;
end;


procedure TestOrderProcessor.TestGetUrgentCount;
var
    actualUrgent: Integer;
    aToday: TDateTime;
begin
    // 3xA:
    // ARRANGE
    aToday := Date();
    fFakeOrderStore.WithOrders([aToday - 2, // termianted order
        aToday + 2, // urgent order (have to be shipped within 14 days
        aToday + 14 // normal order
        ]);

    // ACT
    actualUrgent := fOrderProcessor.GetUrgentCount();

    // ASSERT
    OutputLog(
        '  GetUrgentOrders()          = 1 | actual: %d',
        [actualUrgent]);
end;


procedure TestOrderProcessor.GetTerminatedOrdersCount;
var
    actualTerminated: Integer;
    aToday: TDateTime;
begin
    // 3xA:
    // ARRANGE
    aToday := Date();
    fFakeOrderStore.WithOrders([aToday - 2, // termianted order
        aToday + 2, // urgent order (have to be shipped within 14 days
        aToday + 14 // normal order
        ]);

    // ACT
    actualTerminated := fOrderProcessor.GetTerminatedOrdersCount();

    // ASSERT
    OutputLog(
        '  GetTerminatedOrdersCount() = 1 | actual: %d',
        [actualTerminated]);
end;

end.
