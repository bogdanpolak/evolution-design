unit OrderInterfaces;

interface

uses
    Spring.Collections,
    Model.Order;

type
    IOrdersStore = interface(IInvokable)
        ['{6D0F52B4-A96F-4C96-97A4-DE45324FDE1B}']
        function GeyOrders(): IList<TOrder>;
    end;

    IOrderProcessor = interface(IInvokable)
        ['{978361F2-65F0-49F7-A00C-964C05683682}']
        function GetUrgentOrders: IList<TOrder>;
        function GetTerminatedOrders: IList<TOrder>;
    end;

implementation

end.
