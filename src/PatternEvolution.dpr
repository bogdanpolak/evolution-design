program PatternEvolution;

uses
  FastMM4 in 'fastmm4\FastMM4.pas',
  Vcl.Forms,
  Form.Main in 'Form.Main.pas' {Form1},
  Model.Order in 'logic\Model.Order.pas',
  Model.Interfaces in 'logic\Model.Interfaces.pas',
  Model.OrderProcessor in 'logic\Model.OrderProcessor.pas',
  Model.OrderStore in 'logic\Model.OrderStore.pas',
  Composer in 'Composer.pas',
  DataModule.Orders in 'DataModule.Orders.pas' {DataModuleOrders: TDataModule},
  Test.BabyToyTester in 'tests\Test.BabyToyTester.pas',
  Test.OrderProcessor in 'tests\Test.OrderProcessor.pas',
  FastMM4Messages in 'fastmm4\FastMM4Messages.pas',
  Utils.FastMM in 'Utils.FastMM.pas',
  Delphi.Mocks.AutoMock in 'dephi-mocks\Delphi.Mocks.AutoMock.pas',
  Delphi.Mocks.Behavior in 'dephi-mocks\Delphi.Mocks.Behavior.pas',
  Delphi.Mocks.Expectation in 'dephi-mocks\Delphi.Mocks.Expectation.pas',
  Delphi.Mocks.Helpers in 'dephi-mocks\Delphi.Mocks.Helpers.pas',
  Delphi.Mocks.Interfaces in 'dephi-mocks\Delphi.Mocks.Interfaces.pas',
  Delphi.Mocks.MethodData in 'dephi-mocks\Delphi.Mocks.MethodData.pas',
  Delphi.Mocks.ObjectProxy in 'dephi-mocks\Delphi.Mocks.ObjectProxy.pas',
  Delphi.Mocks.ParamMatcher in 'dephi-mocks\Delphi.Mocks.ParamMatcher.pas',
  Delphi.Mocks in 'dephi-mocks\Delphi.Mocks.pas',
  Delphi.Mocks.Proxy in 'dephi-mocks\Delphi.Mocks.Proxy.pas',
  Delphi.Mocks.Proxy.TypeInfo in 'dephi-mocks\Delphi.Mocks.Proxy.TypeInfo.pas',
  Delphi.Mocks.ReturnTypePatch in 'dephi-mocks\Delphi.Mocks.ReturnTypePatch.pas',
  Delphi.Mocks.Utils in 'dephi-mocks\Delphi.Mocks.Utils.pas',
  Delphi.Mocks.Validation in 'dephi-mocks\Delphi.Mocks.Validation.pas',
  Delphi.Mocks.VirtualInterface in 'dephi-mocks\Delphi.Mocks.VirtualInterface.pas',
  Delphi.Mocks.VirtualMethodInterceptor in 'dephi-mocks\Delphi.Mocks.VirtualMethodInterceptor.pas',
  Delphi.Mocks.WeakReference in 'dephi-mocks\Delphi.Mocks.WeakReference.pas',
  Delphi.Mocks.When in 'dephi-mocks\Delphi.Mocks.When.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDataModuleOrders, DataModuleOrders);
  Application.Run;
end.

