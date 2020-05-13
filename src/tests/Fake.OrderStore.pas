unit Fake.OrderStore;

interface

uses
    System.Classes,
    Spring.Collections,
    { }
    Model.Interfaces,
    Model.Order,
    DataModule.Orders;

type
    TOrdersStoreFake = class(TInterfacedObject,
                             IOrdersStore)
    private
        fList: IList<TOrder>;
    public
        constructor Create(aList: IList<TOrder>);
        procedure Init(aDataModuleOrdes: TDataModuleOrders);
        function GetOrders(): IList<TOrder>;
        // ----
        procedure WithOrders(const aRequireDates: TArray<TDateTime>);
    end;

implementation

constructor TOrdersStoreFake.Create(aList: IList<TOrder>);
begin
    fList := aList;
end;


function TOrdersStoreFake.GetOrders: IList<TOrder>;
begin
    Result := fList;
end;


procedure TOrdersStoreFake.WithOrders(const aRequireDates: TArray<TDateTime>);
var
    idx: Integer;
begin
    for idx := 0 to High(aRequireDates) do
        fList.Add(TOrder.Create().WithRequiredDate(aRequireDates[idx]));
end;


procedure TOrdersStoreFake.Init(aDataModuleOrdes: TDataModuleOrders);
begin
end;


end.

