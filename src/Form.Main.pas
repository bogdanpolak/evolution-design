unit Form.Main;

interface

uses
    System.SysUtils,
    System.Variants,
    System.Classes,
    Spring,
    Spring.Collections,
  {VCL}
    Winapi.Windows,
    Winapi.Messages,
    Vcl.Graphics,
    Vcl.Controls,
    Vcl.Forms,
    Vcl.Dialogs,
    Vcl.StdCtrls,
    Vcl.ExtCtrls,
  {}
    Model.Interfaces,
    Model.Order,
    Composer;

type
    TForm1 = class(TForm)
        btnConnect: TButton;
        GroupBox1: TGroupBox;
        Memo1: TMemo;
        Splitter1: TSplitter;
        btnProcess: TButton;
        btnListDates: TButton;
        btnRunSimpleTest: TButton;
        procedure FormCreate(Sender: TObject);
        procedure btnConnectClick(Sender: TObject);
        procedure btnProcessClick(Sender: TObject);
        procedure btnListDatesClick(Sender: TObject);
        procedure btnRunSimpleTestClick(Sender: TObject);
    private
        fOrderProcessor: IOrderProcessor;
    public
    end;

var
    Form1: TForm1;

implementation

{$R *.dfm}

uses
    DataModule.Orders,
    Model.OrderProcessor;

{ TFakeOrderStore }

type
    TFakeOrderStore = class(TInterfacedObject, IOrdersStore)
        procedure Init(aDataModuleOrdes: TDataModuleOrders);
        function GetOrders(): IList<TOrder>;
    end;

function TFakeOrderStore.GetOrders: IList<TOrder>;
var
    aOrder: TOrder;
begin
    Result:= TCollections.CreateList<TOrder>;
    Result.Add( 
        TOrder.Create()
            .WithRequiredDate(EncodeDate(2020,04,29)+14));
    Result.Add( 
        TOrder.Create()
            .WithRequiredDate(EncodeDate(2020,06,04)));
    Result.Add( 
        TOrder.Create()
            .WithRequiredDate(EncodeDate(2020,04,04)));
end;

procedure TFakeOrderStore.Init(aDataModuleOrdes: TDataModuleOrders);
begin

end;


function DateToString(aDate: Nullable<TDateTime>): string;
begin
    if aDate.HasValue then
        Result := FormatDateTime('yyyy-mm-dd', aDate)
    else
        Result := '---- -- --';
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    TComposer.RegisterTypes();
    fOrderProcessor := TComposer.GetCompositionRoot;

end;

procedure TForm1.btnConnectClick(Sender: TObject);
begin
    TComposer.GetOrderStore.Init(DataModuleOrders);
end;

procedure TForm1.btnProcessClick(Sender: TObject);
begin
    Memo1.Lines.Add(Format(' Urgent orders: %d,  Terminated orders %d',
        [fOrderProcessor.GetUrgentCount(),
        fOrderProcessor.GetTerminatedOrdersCount()]));
end;

procedure TForm1.btnRunSimpleTestClick(Sender: TObject);
begin
    Memo1.Lines.Clear();
    Memo1.Lines.Add(
        'GetUrgentCount() = ' +
        TOrderProcessor.Create(TFakeOrderStore.Create)
            .GetUrgentCount().ToString()
    );
    Memo1.Lines.Add(
        'GetTerminatedOrdersCount() = ' +
        TOrderProcessor.Create(TFakeOrderStore.Create)
            .GetTerminatedOrdersCount().ToString()
    );
end;

procedure TForm1.btnListDatesClick(Sender: TObject);
var
    aOrder: TOrder;
    sl:     TStringList;
begin
    sl := TStringList.Create;
    try
        for aOrder in TComposer.GetOrderStore.GetOrders() do
            sl.Add(Format('  %s  %s  %s,', [DateToString(aOrder.SaleDate),
                DateToString(aOrder.RequiredDate),
                DateToString(aOrder.ShipDate)]));
        Memo1.Lines := sl;
    finally
        sl.Free;
    end;
end;

end.
