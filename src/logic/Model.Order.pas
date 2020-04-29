unit Model.Order;

interface

uses
    Spring,
    Spring.Collections;

type
    TOrder = class
    private
        fOrderID:      string;
        fCompanyId:    string;
        fSaleDate:     TDateTime;
        fRequiredDate: Nullable<TDateTime>;
        fShipDate:     Nullable<TDateTime>;
        fEmployeeId:   integer;
    public
        function WithRequiredDate(aRequiredDate: TDateTime): TOrder;
        property OrderID:      string read fOrderID write fOrderID;
        property CompanyId:    string read fCompanyId write fCompanyId;
        property SaleDate:     TDateTime read fSaleDate write fSaleDate;
        property RequiredDate: Nullable<TDateTime> read fRequiredDate
            write fRequiredDate;
        property ShipDate: Nullable<TDateTime> read fShipDate write fShipDate;
        property EmployeeId:    integer read fEmployeeId write fEmployeeId;
    end;

implementation

{ TOrder }

function TOrder.WithRequiredDate(aRequiredDate: TDateTime): TOrder;
begin
    RequiredDate := aRequiredDate;
    Result := Self;
end;

end.
