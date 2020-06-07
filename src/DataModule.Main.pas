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
        fConnectionStrtring: string;
        procedure CloneDemoDatabseToAppFolder;
    private const
        CONNDEF_SQLiteDemo = 'SQLite_Demo';
    public
        procedure Connect();
    end;

var
    DataModuleMain: TDataModuleMain;

implementation

uses
    System.IOUtils, 
    UpgradeDatabase;

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

procedure TDataModuleMain.DataModuleCreate(Sender: TObject);
begin
    // TODO: DataMoule initialization
end;

procedure TDataModuleMain.CloneDemoDatabseToAppFolder();
var
    aConnectionDef: IFDStanConnectionDef;
    aConnectionStr: string;
    aDatabaseFile: string;
    aFileName: string;
begin
    aConnectionDef := FDManager.ConnectionDefs.FindConnectionDef(CONNDEF_SQLiteDemo);
    if aConnectionDef = nil then
        raise Exception.Create
            (Format('FireDAC %s connection definition is required to run application',
            [CONNDEF_SQLiteDemo]));
    aConnectionStr := aConnectionDef.BuildString();
    aDatabaseFile := aConnectionDef.AsString['Database'];
    aFileName := ExtractFileName(aDatabaseFile);
    if not FileExists(aFileName) then
        TFile.Copy(aDatabaseFile, aFileName);
    aConnectionStr := StringReplace(aConnectionStr, aDatabaseFile, aFileName, []);
    fConnectionStrtring := aConnectionStr;
end;

procedure TDataModuleMain.Connect();
begin
    CloneDemoDatabseToAppFolder();
    FDConnection.Open(fConnectionStrtring);
    TDatabaseUpgrader.UpgradeDatabase(FDConnection);
end;

end.
