unit Model.OrderProcessor;

interface

uses
    Spring.Collections,
    System.SysUtils,
  {}
    Model.Order,
    Model.Interfaces;

type
    TOrderProcessor = class(TInterfacedObject, IOrderProcessor)
    private
        fOrderStore: IOrdersStore;
        function GetNowDate: TDateTime;
        function GetUrgentDays: integer;
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


function TOrderProcessor.GetNowDate: TDateTime;
begin
    Result := System.SysUtils.Now();
end;

function TOrderProcessor.GetTerminatedOrdersCount: integer;
var
    aCounter: integer;
    aOrder:   TOrder;
begin
    aCounter := 0;
    for aOrder in fOrderStore.GetOrders() do
    begin
        if not aOrder.ShipDate.HasValue then
            if aOrder.RequiredDate.HasValue and
                (aOrder.RequiredDate.Value <= GetNowDate()) then
                inc(aCounter);
    end;
    Result := aCounter;
end;

function TOrderProcessor.GetUrgentCount: integer;
var
    aCounter: integer;
    aOrder:   TOrder;
begin
    aCounter := 0;
    for aOrder in fOrderStore.GetOrders() do
    begin
        if not aOrder.ShipDate.HasValue then
            if aOrder.RequiredDate.HasValue and
                (aOrder.RequiredDate.Value > GetNowDate()) and
                (aOrder.RequiredDate.Value < GetNowDate()+14) then
                inc(aCounter);
    end;
    Result := aCounter;
end;

function TOrderProcessor.GetUrgentDays: integer;
begin
    Result := 10;
end;

end.
