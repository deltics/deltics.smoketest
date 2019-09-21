
  unit SelfTestCore;

interface

  uses
    Deltics.Continuity;

  type
    TCoreFunctionality = class(TTest)
      procedure ThisTestWillPass;
      procedure ThisTestWillFail;
      procedure ThisTestWillThrowAnException;
      procedure TestResultsAreAsExpected;
    end;


implementation

  uses
    SysUtils;


{ TCoreFunctionality }

  procedure TCoreFunctionality.ThisTestWillFail;
  begin
    TestRun.ExpectingToFail;
    Assert('This test fails', FALSE);
  end;


  procedure TCoreFunctionality.ThisTestWillPass;
  begin
    Assert('This test passes', TRUE);
  end;


  procedure TCoreFunctionality.ThisTestWillThrowAnException;
  begin
    TestRun.ExpectingError(Exception, 'This exception was deliberately thrown');
    raise Exception.Create('This exception was deliberately thrown');
  end;


  procedure TCoreFunctionality.TestResultsAreAsExpected;
  var
    passed: Integer;
    failed: Integer;
    errors: Integer;
    total: Integer;
  begin
    // We need to read these values since the tests we are about to apply
    //  will change the stats on the TestRun!

    passed  := TestRun.TestsPassed;
    failed  := TestRun.TestsFailed;
    errors  := TestRun.TestsError;
    total   := TestRun.TestCount;

    Assert('The expected total number of tests',  total  = 3, Format('%d tests counted, 3 expected', [total]));
    Assert('The expected number of tests passed', passed = 1, Format('%d tests passed, 1 expected', [passed]));
    Assert('The expected number of tests failed', failed = 1, Format('%d tests failed, 1 expected', [failed]));
    Assert('The expected number of errors',       errors = 1, Format('%d errors, 1 expected', [errors]));
  end;




end.
