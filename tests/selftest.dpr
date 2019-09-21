
{$apptype CONSOLE}

program selftest;

  uses
  SysUtils,
  Deltics.Continuity in '..\src\Deltics.Continuity.pas',
  Deltics.Continuity.Test in '..\src\Deltics.Continuity.Test.pas',
  Deltics.Continuity.TestRun in '..\src\Deltics.Continuity.TestRun.pas',
  Deltics.Continuity.TestResult in '..\src\Deltics.Continuity.TestResult.pas',
  Deltics.Continuity.ResultsWriter in '..\src\Deltics.Continuity.ResultsWriter.pas',
  Deltics.Continuity.ResultsWriter.XUnit2 in '..\src\Deltics.Continuity.ResultsWriter.XUnit2.pas',
  Deltics.Continuity.Utils in '..\src\Deltics.Continuity.Utils.pas',
  SelfTestCore;

begin
  TestRun.Environment := 'Delphi ' + Uppercase(DELPHI_VERSION);
  try
    TestRun.Execute(TCoreFunctionality);

  except
    on e: Exception do
      WriteLn('ERROR: ' + e.Message);
  end;
end.
