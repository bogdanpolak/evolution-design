unit uOrder;

interface

uses
    Spring.Collections;

type
    TOrderItem = class
    private
    public
    end;

    TOrder = class
    private
        FOrderID:      string;
        FSaleDate:     TDateTime;
        FRequiredDate: TDateTime;
        FShipDate:     TDateTime;
        function GetItems: IList<TOrderItem>;
    public
        property OrderID:  string read FOrderID write FOrderID;
        property SaleDate: TDateTime read FSaleDate write FSaleDate;
        property RequiredDate: TDateTime read FRequiredDate write FRequiredDate;
        property ShipDate: TDateTime read FShipDate write FShipDate;
        property Items:    IList<TOrderItem> read GetItems;
    end;

implementation

end.
