
{$apptype CONSOLE}

program selftest;

  uses
  SysUtils,
  Deltics.Smoketest,
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
