unit Model.OrderProcessor;

interface

uses
    Spring.Collections,
    System.SysUtils,
    {}
    Model.Order,
    Model.Interfaces;

type
    TOrderProcessor = class(TInterfacedObject,
                            IOrderProcessor)
    private
        fOrderStore: IOrdersStore;
        function GetToday(): TDateTime;
    public
        constructor Create(aOrderStore: IOrdersStore);
        function GetUrgentCount: integer;
        function GetTerminatedOrdersCount: integer;
    end;

implementation


constructor TOrderProcessor.Create(aOrderStore: IOrdersStore);
begin
    fOrderStore := aOrderStore;
end;


function TOrderProcessor.GetToday(): TDateTime;
begin
    Result := Int(System.SysUtils.Now());
end;


function TOrderProcessor.GetTerminatedOrdersCount: integer;
var
    aCounter: integer;
    aOrder: TOrder;
begin
    aCounter := 0;
    for aOrder in fOrderStore.GetOrders() do
    begin
        if not aOrder.ShipDate.HasValue then
            if aOrder.RequiredDate.HasValue and (aOrder.RequiredDate.Value <= GetToday())
            then
                inc(aCounter);
    end;
    Result := aCounter;
end;


function TOrderProcessor.GetUrgentCount: integer;
var
    aCounter: integer;
    aOrder: TOrder;
    isDateUrgent : boolean;
begin
    aCounter := 0;
    isDateUrgent := False;
    for aOrder in fOrderStore.GetOrders() do
    begin
        if not aOrder.ShipDate.HasValue and aOrder.RequiredDate.HasValue  then
            isDateUrgent := (aOrder.RequiredDate.Value > GetToday()) and (aOrder.RequiredDate.Value < GetToday() + 14);
            if isDateUrgent then
                inc(aCounter);
    end;
    Result := aCounter;
end;


end.
