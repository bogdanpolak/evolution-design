unit Model.Interfaces;

interface

uses
    Spring.Collections,
  {}
    DataModule.Orders,
    Model.Order;

type
    IOrdersStore = interface(IInvokable)
        ['{6D0F52B4-A96F-4C96-97A4-DE45324FDE1B}']
        procedure Init(aDataModuleOrdes: TDataModuleOrders);
        function GetOrders(): IList<TOrder>;
    end;

    IOrderProcessor = interface(IInvokable)
        ['{978361F2-65F0-49F7-A00C-964C05683682}']
        function GetUrgentCount: integer;
        function GetTerminatedOrdersCount: integer;
    end;

implementation

end.
