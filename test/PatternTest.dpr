program PatternTest;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}{$STRONGLINKTYPES ON}
uses
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ENDIF }
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.TestFramework,
  Test2.OrderProcessor in 'Test2.OrderProcessor.pas',
  Model.Interfaces in '..\src\logic\Model.Interfaces.pas',
  Model.Order in '..\src\logic\Model.Order.pas',
  Model.OrderProcessor in '..\src\logic\Model.OrderProcessor.pas',
  Model.OrderStore in '..\src\logic\Model.OrderStore.pas',
  DataModule.Orders in '..\src\DataModule.Orders.pas' {DataModuleOrders: TDataModule},
  Delphi.Mocks.AutoMock in '..\src\dephi-mocks\Delphi.Mocks.AutoMock.pas',
  Delphi.Mocks.Behavior in '..\src\dephi-mocks\Delphi.Mocks.Behavior.pas',
  Delphi.Mocks.Expectation in '..\src\dephi-mocks\Delphi.Mocks.Expectation.pas',
  Delphi.Mocks.Helpers in '..\src\dephi-mocks\Delphi.Mocks.Helpers.pas',
  Delphi.Mocks.Interfaces in '..\src\dephi-mocks\Delphi.Mocks.Interfaces.pas',
  Delphi.Mocks.MethodData in '..\src\dephi-mocks\Delphi.Mocks.MethodData.pas',
  Delphi.Mocks.ObjectProxy in '..\src\dephi-mocks\Delphi.Mocks.ObjectProxy.pas',
  Delphi.Mocks.ParamMatcher in '..\src\dephi-mocks\Delphi.Mocks.ParamMatcher.pas',
  Delphi.Mocks in '..\src\dephi-mocks\Delphi.Mocks.pas',
  Delphi.Mocks.Proxy in '..\src\dephi-mocks\Delphi.Mocks.Proxy.pas',
  Delphi.Mocks.Proxy.TypeInfo in '..\src\dephi-mocks\Delphi.Mocks.Proxy.TypeInfo.pas',
  Delphi.Mocks.ReturnTypePatch in '..\src\dephi-mocks\Delphi.Mocks.ReturnTypePatch.pas',
  Delphi.Mocks.Utils in '..\src\dephi-mocks\Delphi.Mocks.Utils.pas',
  Delphi.Mocks.Validation in '..\src\dephi-mocks\Delphi.Mocks.Validation.pas',
  Delphi.Mocks.VirtualInterface in '..\src\dephi-mocks\Delphi.Mocks.VirtualInterface.pas',
  Delphi.Mocks.VirtualMethodInterceptor in '..\src\dephi-mocks\Delphi.Mocks.VirtualMethodInterceptor.pas',
  Delphi.Mocks.WeakReference in '..\src\dephi-mocks\Delphi.Mocks.WeakReference.pas',
  Delphi.Mocks.When in '..\src\dephi-mocks\Delphi.Mocks.When.pas';

var
  runner : ITestRunner;
  results : IRunResults;
  logger : ITestLogger;
  nunitLogger : ITestLogger;
begin
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
  exit;
{$ENDIF}
  try
    //Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    //Create the test runner
    runner := TDUnitX.CreateRunner;
    //Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := True;
    //tell the runner how we will log things
    //Log to the console window
    logger := TDUnitXConsoleLogger.Create(true);
    runner.AddLogger(logger);
    //Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);
    runner.FailsOnNoAsserts := False; //When true, Assertions must be made during tests;

    //Run tests
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

    {$IFNDEF CI}
    //We don't want this happening when running under CI.
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
end.
