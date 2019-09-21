
  unit SelfTestCore;

interface

  uses
    Deltics.Smoketest;

  type
    TCoreFunctionality = class(TTest)
      procedure ThisTestWillPass;
      procedure ThisTestWillFail;
      procedure ThisTestWillThrowAnException;
      procedure TestResultsAreAsExpected;
      procedure TestExceptionHandling;
    end;


implementation

  uses
    SysUtils,
    Deltics.Smoketest.TestRun;

  type
    TTestRunHelper = class(TTestRun);

  var
    TestRun: TTestRunHelper;


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
    TestRun.ExpectingException(Exception, 'This exception was deliberately raised');
    raise Exception.Create('This exception was deliberately raised');
  end;


  procedure TCoreFunctionality.TestExceptionHandling;
  begin
    try
      raise EDivByZero.Create('This exception was deliberately raised');
    except
      AssertException(EDivByZero);
    end;

    try
      raise EDivByZero.Create('EDivByZero is an Exception');
    except
      AssertBaseException(Exception);
    end;

    TestRun.ExpectingToFail;
    try
      raise EDivByZero.Create('Testing for a specific exception type');
    except
      AssertException(Exception, 'EDivByZero is a sub-class of Exception');
    end;

    TestRun.ExpectingToFail;
    try
      AssertException(Exception);
    except
      // NO-OP (there is no expection raised
    end;
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



initialization
  TestRun := TTestRunHelper(Deltics.Smoketest.TestRun.TestRun);
end.
