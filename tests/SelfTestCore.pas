
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
      raise Exception.Create('This exception was deliberately raised');
    except
      AssertException(Exception, 'This exception was deliberately raised');
    end;

    TestRun.ExpectingToFail;
    try
      AssertException(Exception, 'No exception was raised');
    except
      // NO-OP (there is no expection raised
    end;

    TestRun.ExpectingToFail;
    try
      raise EArgumentException.Create('The wrong exception class was deliberately raised');
    except
      AssertException(Exception, 'The wrong exception class was deliberately raised');
    end;

    TestRun.ExpectingToFail;
    try
      raise Exception.Create('This exception was deliberately raised with the wrong message');
    except
      AssertException(Exception, 'Exception has the wrong message');
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
