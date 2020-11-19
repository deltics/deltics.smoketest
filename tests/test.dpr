
{$apptype CONSOLE}

program test;

  uses
  Deltics.Smoketest in '..\src\Deltics.Smoketest.pas',
  Deltics.Smoketest.Assertions in '..\src\Deltics.Smoketest.Assertions.pas',
  Deltics.Smoketest.Assertions.AssertFactory in '..\src\Deltics.Smoketest.Assertions.AssertFactory.pas',
  Deltics.Smoketest.Assertions.Date in '..\src\Deltics.Smoketest.Assertions.Date.pas',
  Deltics.Smoketest.Assertions.DateTime in '..\src\Deltics.Smoketest.Assertions.DateTime.pas',
  Deltics.Smoketest.Assertions.AnsiStrings in '..\src\Deltics.Smoketest.Assertions.AnsiStrings.pas',
  Deltics.Smoketest.Assertions.Int64 in '..\src\Deltics.Smoketest.Assertions.Int64.pas',
  Deltics.Smoketest.Assertions.Integers in '..\src\Deltics.Smoketest.Assertions.Integers.pas',
  Deltics.Smoketest.Assertions.UnicodeStrings in '..\src\Deltics.Smoketest.Assertions.UnicodeStrings.pas',
  Deltics.Smoketest.Assertions.WideStrings in '..\src\Deltics.Smoketest.Assertions.WideStrings.pas',
  Deltics.Smoketest.ResultsWriter in '..\src\Deltics.Smoketest.ResultsWriter.pas',
  Deltics.Smoketest.ResultsWriter.XUnit2 in '..\src\Deltics.Smoketest.ResultsWriter.XUnit2.pas',
  Deltics.Smoketest.Test in '..\src\Deltics.Smoketest.Test.pas',
  Deltics.Smoketest.TestResult in '..\src\Deltics.Smoketest.TestResult.pas',
  Deltics.Smoketest.TestRun in '..\src\Deltics.Smoketest.TestRun.pas',
  Deltics.Smoketest.Utils in '..\src\Deltics.Smoketest.Utils.pas',
  Test.SelfTest in 'Test.SelfTest.pas',
  Test.Core in 'Test.Core.pas',
  Test.ExceptionHandling in 'Test.ExceptionHandling.pas',
  Test.CommandLineHandling in 'Test.CommandLineHandling.pas',
  Test.IntegerAssertions in 'Test.IntegerAssertions.pas',
  Test.StringAssertions in 'Test.StringAssertions.pas',
  Test.DateAssertions in 'Test.DateAssertions.pas',
  Test.Int64Assertions in 'Test.Int64Assertions.pas';

begin
  TestRun.Environment     := 'Delphi ' + DELPHI_VERSION;
  TestRun.DefaultTestName := METHOD_NAME;

  TestRun.Test(TCoreFunctionalityTests);
  TestRun.Test(TExceptionHandlingTests);
  TestRun.Test(TCommandLineHandlingTests);
  TestRun.Test(TStringTests);
  TestRun.Test(TDateAssertionTests);
  TestRun.Test(TIntegerAssertionTests);
end.
