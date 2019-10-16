
{$apptype CONSOLE}

program selftest;

  uses
    Deltics.Smoketest,
    Test.CoreFunctionality in 'Test.CoreFunctionality.pas',
    Test.ExceptionHandling in 'Test.ExceptionHandling.pas',
    Test.CommandLineHandling in 'Test.CommandLineHandling.pas',
    Test.StringAssertions in 'Test.StringAssertions.pas';

begin
  TestRun.Environment := 'Delphi ' + DELPHI_VERSION;

  TestRun.Test([TCoreFunctionalityTests,
                TStringTests,
                TExceptionHandlingTests,
                TCommandLineHandlingTests]);
end.
