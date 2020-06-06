unit DataModule.Main;

interface

uses
    System.SysUtils,
    System.Classes,
    FireDAC.Stan.Intf,
    FireDAC.Stan.Option,
    FireDAC.Stan.Error,
    FireDAC.UI.Intf,
    FireDAC.Phys.Intf,
    FireDAC.Stan.Def,
    FireDAC.Stan.Pool,
    FireDAC.Stan.Async,
    FireDAC.Phys,
    FireDAC.Phys.SQLite,
    FireDAC.Phys.SQLiteDef,
    FireDAC.Stan.ExprFuncs,
    FireDAC.VCLUI.Wait,
    FireDAC.Stan.Param,
    FireDAC.DatS,
    FireDAC.DApt.Intf,
    FireDAC.DApt,
    Data.DB,
    FireDAC.Comp.DataSet,
    FireDAC.Comp.Client;

type
    TDataModuleMain = class(TDataModule)
        FDConnection: TFDConnection;
        fdqOrders: TFDQuery;
        fdqOrdersOrderID: TFDAutoIncField;
        fdqOrdersCustomerID: TStringField;
        fdqOrdersEmployeeID: TIntegerField;
        fdqOrdersOrderDate: TDateTimeField;
        fdqOrdersRequiredDate: TDateTimeField;
        fdqOrdersShippedDate: TDateTimeField;
        fdqOrdersShipVia: TIntegerField;
        fdqOrdersFreight: TCurrencyField;
        fdqOrdersShipName: TStringField;
        fdqOrdersShipAddress: TStringField;
        fdqOrdersShipCity: TStringField;
        fdqOrdersShipRegion: TStringField;
        fdqOrdersShipPostalCode: TStringField;
        fdqOrdersShipCountry: TStringField;
        procedure DataModuleCreate(Sender: TObject);
    private
    public
        procedure Connect();
    end;

var
    DataModuleMain: TDataModuleMain;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

procedure TDataModuleMain.DataModuleCreate(Sender: TObject);
begin
    // TODO: DataMoule initialization
end;

procedure TDataModuleMain.Connect();
begin
    FDConnection.Open();
end;

end.
