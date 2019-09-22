
{$apptype CONSOLE}

program selftest;

  uses
  SysUtils,
  Deltics.Smoketest in '..\src\Deltics.Smoketest.pas',
  Deltics.Smoketest.Test in '..\src\Deltics.Smoketest.Test.pas',
  Deltics.Smoketest.TestRun in '..\src\Deltics.Smoketest.TestRun.pas',
  Deltics.Smoketest.TestResult in '..\src\Deltics.Smoketest.TestResult.pas',
  Deltics.Smoketest.ResultsWriter in '..\src\Deltics.Smoketest.ResultsWriter.pas',
  Deltics.Smoketest.ResultsWriter.XUnit2 in '..\src\Deltics.Smoketest.ResultsWriter.XUnit2.pas',
  Deltics.Smoketest.Utils in '..\src\Deltics.Smoketest.Utils.pas',
  SelfTestCore in 'SelfTestCore.pas';

begin
  TestRun.Environment := 'Delphi ' + Uppercase(DELPHI_VERSION);
  try
    TestRun.Test(TCoreFunctionality);

  except
    on e: Exception do
      WriteLn('ERROR: ' + e.Message);
  end;
end.
