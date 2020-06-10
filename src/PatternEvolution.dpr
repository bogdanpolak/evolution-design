program PatternEvolution;

uses
  FastMM4 in '..\components\fastmm4\FastMM4.pas',
  Vcl.Forms,
  Form.Main in 'Form.Main.pas' {Form1},
  Model.Order in 'logic\Model.Order.pas',
  Model.Interfaces in 'logic\Model.Interfaces.pas',
  Model.OrderProcessor in 'logic\Model.OrderProcessor.pas',
  Model.OrderStore in 'logic\Model.OrderStore.pas',
  Composer in 'Composer.pas',
  DataModule.Main in 'DataModule.Main.pas' {DataModuleMain: TDataModule},
  Test.BabyToyTester in 'tests\Test.BabyToyTester.pas',
  Test.OrderProcessor in 'tests\Test.OrderProcessor.pas',
  FastMM4Messages in '..\components\fastmm4\FastMM4Messages.pas',
  Utils.FastMM in 'Utils.FastMM.pas',
  Delphi.Mocks.AutoMock in '..\components\dephi-mocks\Delphi.Mocks.AutoMock.pas',
  Delphi.Mocks.Behavior in '..\components\dephi-mocks\Delphi.Mocks.Behavior.pas',
  Delphi.Mocks.Expectation in '..\components\dephi-mocks\Delphi.Mocks.Expectation.pas',
  Delphi.Mocks.Helpers in '..\components\dephi-mocks\Delphi.Mocks.Helpers.pas',
  Delphi.Mocks.Interfaces in '..\components\dephi-mocks\Delphi.Mocks.Interfaces.pas',
  Delphi.Mocks.MethodData in '..\components\dephi-mocks\Delphi.Mocks.MethodData.pas',
  Delphi.Mocks.ObjectProxy in '..\components\dephi-mocks\Delphi.Mocks.ObjectProxy.pas',
  Delphi.Mocks.ParamMatcher in '..\components\dephi-mocks\Delphi.Mocks.ParamMatcher.pas',
  Delphi.Mocks in '..\components\dephi-mocks\Delphi.Mocks.pas',
  Delphi.Mocks.Proxy in '..\components\dephi-mocks\Delphi.Mocks.Proxy.pas',
  Delphi.Mocks.Proxy.TypeInfo in '..\components\dephi-mocks\Delphi.Mocks.Proxy.TypeInfo.pas',
  Delphi.Mocks.ReturnTypePatch in '..\components\dephi-mocks\Delphi.Mocks.ReturnTypePatch.pas',
  Delphi.Mocks.Utils in '..\components\dephi-mocks\Delphi.Mocks.Utils.pas',
  Delphi.Mocks.Validation in '..\components\dephi-mocks\Delphi.Mocks.Validation.pas',
  Delphi.Mocks.VirtualInterface in '..\components\dephi-mocks\Delphi.Mocks.VirtualInterface.pas',
  Delphi.Mocks.VirtualMethodInterceptor in '..\components\dephi-mocks\Delphi.Mocks.VirtualMethodInterceptor.pas',
  Delphi.Mocks.WeakReference in '..\components\dephi-mocks\Delphi.Mocks.WeakReference.pas',
  Delphi.Mocks.When in '..\components\dephi-mocks\Delphi.Mocks.When.pas',
  Comp.Generator.DataProxy in '..\components\delphi-dataproxy\Comp.Generator.DataProxy.pas',
  Data.DataProxy in '..\components\delphi-dataproxy\Data.DataProxy.pas',
  UpgradeDatabase in 'UpgradeDatabase.pas',
  Utils.Application in 'Utils.Application.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDataModuleMain, DataModuleMain);
  Application.Run;
end.

