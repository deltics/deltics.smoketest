
{$apptype CONSOLE}

program test;

uses
  Deltics.Smoketest in '..\src\Deltics.Smoketest.pas',
  Deltics.Smoketest.Accumulators in '..\src\Deltics.Smoketest.Accumulators.pas',
  Deltics.Smoketest.Accumulators.ActualStateAccumulator in '..\src\Deltics.Smoketest.Accumulators.ActualStateAccumulator.pas',
  Deltics.Smoketest.Accumulators.StateAccumulator in '..\src\Deltics.Smoketest.Accumulators.StateAccumulator.pas',
  Deltics.Smoketest.Assertions in '..\src\Deltics.Smoketest.Assertions.pas',
  Deltics.Smoketest.Assertions.Factory in '..\src\Deltics.Smoketest.Assertions.Factory.pas',
  Deltics.Smoketest.Assertions.Boolean in '..\src\Deltics.Smoketest.Assertions.Boolean.pas',
  Deltics.Smoketest.Assertions.Date in '..\src\Deltics.Smoketest.Assertions.Date.pas',
  Deltics.Smoketest.Assertions.DateTime in '..\src\Deltics.Smoketest.Assertions.DateTime.pas',
  Deltics.Smoketest.Assertions.Double in '..\src\Deltics.Smoketest.Assertions.Double.pas',
  Deltics.Smoketest.Assertions.AnsiString in '..\src\Deltics.Smoketest.Assertions.AnsiString.pas',
  Deltics.Smoketest.Assertions.Guid in '..\src\Deltics.Smoketest.Assertions.Guid.pas',
  Deltics.Smoketest.Assertions.Int64 in '..\src\Deltics.Smoketest.Assertions.Int64.pas',
  Deltics.Smoketest.Assertions.Integer in '..\src\Deltics.Smoketest.Assertions.Integer.pas',
  Deltics.Smoketest.Assertions.Interface_ in '..\src\Deltics.Smoketest.Assertions.Interface_.pas',
  Deltics.Smoketest.Assertions.Pointer in '..\src\Deltics.Smoketest.Assertions.Pointer.pas',
  Deltics.Smoketest.Assertions.UnicodeString in '..\src\Deltics.Smoketest.Assertions.UnicodeString.pas',
  Deltics.Smoketest.Assertions.Utf8Char in '..\src\Deltics.Smoketest.Assertions.Utf8Char.pas',
  Deltics.Smoketest.Assertions.Utf8String in '..\src\Deltics.Smoketest.Assertions.Utf8String.pas',
  Deltics.Smoketest.Assertions.WideChar in '..\src\Deltics.Smoketest.Assertions.WideChar.pas',
  Deltics.Smoketest.Assertions.WideString in '..\src\Deltics.Smoketest.Assertions.WideString.pas',
  Deltics.Smoketest.ExpectedException in '..\src\Deltics.Smoketest.ExpectedException.pas',
  Deltics.Smoketest.ResultsWriter in '..\src\Deltics.Smoketest.ResultsWriter.pas',
  Deltics.Smoketest.ResultsWriter.XUnit2 in '..\src\Deltics.Smoketest.ResultsWriter.XUnit2.pas',
  Deltics.Smoketest.SelfTestContext in '..\src\Deltics.Smoketest.SelfTestContext.pas',
  Deltics.Smoketest.Test in '..\src\Deltics.Smoketest.Test.pas',
  Deltics.Smoketest.TestResult in '..\src\Deltics.Smoketest.TestResult.pas',
  Deltics.Smoketest.TestRun in '..\src\Deltics.Smoketest.TestRun.pas',
  Deltics.Smoketest.Types in '..\src\Deltics.Smoketest.Types.pas',
  Deltics.Smoketest.Utils in '..\src\Deltics.Smoketest.Utils.pas',
  SelfTest in 'SelfTest.pas',
  Test.CommandLineHandling in 'Test.CommandLineHandling.pas',
  Test.AssertionFactory in 'Test.AssertionFactory.pas',
  Test.SelfTestResultsAndAccumulators in 'Test.SelfTestResultsAndAccumulators.pas',
  Test.DeprecatedAssert in 'Test.DeprecatedAssert.pas',
  Test.ExceptionHandling in 'Test.ExceptionHandling.pas',
  Test.IntegerAssertions in 'Test.IntegerAssertions.pas',
  Test.InterfaceAssertions in 'Test.InterfaceAssertions.pas',
  Test.PointerAssertions in 'Test.PointerAssertions.pas',
  Test.StringAssertions in 'Test.StringAssertions.pas',
  Test.GuidAssertions in 'Test.GuidAssertions.pas',
  Test.DateAssertions in 'Test.DateAssertions.pas',
  Test.Int64Assertions in 'Test.Int64Assertions.pas',
  Test.Utils in 'Test.Utils.pas',
  Test.DoubleAssertions in 'Test.DoubleAssertions.pas',
  Test.CharAssertions in 'Test.CharAssertions.pas',
  Deltics.Smoketest.Assertions.AnsiChar in '..\src\Deltics.Smoketest.Assertions.AnsiChar.pas';

begin
  TestRun.Environment     := DELPHI_VERSION_NAME;
  TestRun.DefaultTestName := METHOD_NAME;

  TestRun.Test(TAssertionFactoryTests);
  TestRun.Test(TSelfTestResultsAndAccumulatorTests);
  TestRun.Test(TCommandLineHandlingTests);
  TestRun.Test(TUtilsTests);

  TestRun.Test(TDeprecatedAssertTests);
  TestRun.Test(TExceptionHandlingTests);
  TestRun.Test(TStringTests);
  TestRun.Test(TCharAssertions);
  TestRun.Test(TGuidAssertionTests);
//  TestRun.Test(TDateAssertionTests);
  TestRun.Test(TDoubleAssertionTests);
  TestRun.Test(TIntegerAssertionTests);
  TestRun.Test(TInterfaceAssertionTests);
  TestRun.Test(TInt64AssertionTests);
  TestRun.Test(TPointerAssertionTests);
end.
