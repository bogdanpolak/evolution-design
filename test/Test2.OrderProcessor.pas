unit Test2.OrderProcessor;

interface

uses
    System.SysUtils,
    System.RTTI,
    DUnitX.TestFramework,
    Spring.Collections,

    Model.OrderProcessor,
    Model.Interfaces,
    Model.Order,
    Delphi.Mocks;

{$M+}
type

    [TestFixture]
    TestOrderProcessor = class(TObject)
    private
        fOrders: IList<TOrder>;
        fOrderProcessor: TOrderProcessor;
        fMockOrderStore: TMock<IOrdersStore>;
        procedure GivenOrders_WithRequireDates(const aRequireDates: TArray<TDateTime>);
    public
        [Setup]
        procedure Setup;
        [TearDown]
        procedure TearDown;
    published
        procedure GetUrgentCount;
        procedure GetTerminatedOrdersCount_TwoTerminated_OneUrgent_Others;
        procedure GetTerminatedOrdersCount_OneTerminated;
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
    fMockOrderStore.Setup.WillReturn(TValue.From < IList < TOrder >> (fOrders))
        .When.GetOrders();

    fOrderProcessor := TOrderProcessor.Create(fMockOrderStore);
end;

procedure TestOrderProcessor.TearDown;
begin
    fOrderProcessor.Free;
end;

procedure TestOrderProcessor.GivenOrders_WithRequireDates(const aRequireDates
    : TArray<TDateTime>);
var
    idx: Integer;
begin
    for idx := 0 to High(aRequireDates) do
        fOrders.Add(TOrder.Create().WithRequiredDate(aRequireDates[idx]));
end;

procedure TestOrderProcessor.GetUrgentCount;
var
    actualUrgent: Integer;
begin
    GivenOrders_WithRequireDates([Today() + 2]);

    actualUrgent := fOrderProcessor.GetUrgentCount();

    Assert.AreEqual(1, actualUrgent);
end;

procedure TestOrderProcessor.GetTerminatedOrdersCount_TwoTerminated_OneUrgent_Others;
var
    actualTerminated: Integer;
begin
    GivenOrders_WithRequireDates([Today() - 365, Today() - 3, Today() + 1, Today() + 25,
        Today() + 365]);

    actualTerminated := fOrderProcessor.GetTerminatedOrdersCount();

    Assert.AreEqual(2, actualTerminated);
end;

procedure TestOrderProcessor.GetTerminatedOrdersCount_OneTerminated;
begin
    GivenOrders_WithRequireDates([Today()]);

    Assert.AreEqual(1, fOrderProcessor.GetTerminatedOrdersCount());
end;

initialization

TDUnitX.RegisterTestFixture(TestOrderProcessor);

end.
