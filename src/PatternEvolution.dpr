program PatternEvolution;

uses
  Vcl.Forms,
  Form.Main in 'Form.Main.pas' {Form1},
  Model.Order in 'logic\Model.Order.pas',
  Model.Interfaces in 'logic\Model.Interfaces.pas',
  Model.OrderProcessor in 'logic\Model.OrderProcessor.pas',
  Model.OrderStore in 'logic\Model.OrderStore.pas',
  Composer in 'Composer.pas',
  DataModule.Orders in 'DataModule.Orders.pas' {DataModuleOrders: TDataModule},
  Test.OrderProcessorWithFake in 'tests\Test.OrderProcessorWithFake.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDataModuleOrders, DataModuleOrders);
  Application.Run;
end.
