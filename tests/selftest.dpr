
{$apptype CONSOLE}

program selftest;

  uses
  Deltics.Smoketest,
  Test.CoreFunctionality in 'Test.CoreFunctionality.pas',
  Test.ExceptionHandling in 'Test.ExceptionHandling.pas',
  Test.CommandLineHandling in 'Test.CommandLineHandling.pas',
  Test.StringAssertions in 'Test.StringAssertions.pas',
  Test.IntegerAssertions in 'Test.IntegerAssertions.pas';

begin
  TestRun.Environment     := 'Delphi ' + DELPHI_VERSION;
  TestRun.DefaultTestName := METHOD_NAME;

  TestRun.Test([
                TCoreFunctionalityTests,
                TExceptionHandlingTests,
                TCommandLineHandlingTests,
                TStringTests,
                TIntegerAssertionTests
               ]);
end.
