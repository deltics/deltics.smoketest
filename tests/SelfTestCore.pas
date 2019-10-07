
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
    // Any additional tests must be introduced AFTER this point otherwise the
    //  expected tests counts in the TestResultsAreAsExpected test will be wrong
    //  (alternatively you will need to adjust those counts accordingly).
    //
    // Similarly, the TCoreFunctionality test MUST be the FIRST test executed
    //  for the same reason.
      procedure TestExceptionHandling;
      procedure CommandLineOptionsAreIdentifiedCorrectly;
    end;



implementation

  uses
    Classes,
    SysUtils,
    Deltics.Smoketest.TestRun,
    Deltics.Smoketest.Utils;

  type
    TTestRunHelper = class(TTestRun);

  var
    TestRun: TTestRunHelper;


{ CoreFunctionality tests ------------------------------------------------------------------------ }

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCoreFunctionality.ThisTestWillFail;
  begin
    TestRun.ExpectingToFail;
    Assert('This test fails', FALSE);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCoreFunctionality.ThisTestWillPass;
  begin
    Assert('This test passes', TRUE);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCoreFunctionality.ThisTestWillThrowAnException;
  begin
    TestRun.ExpectingException(Exception, 'This exception was deliberately raised');
    raise Exception.Create('This exception was deliberately raised');
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
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


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCoreFunctionality.CommandLineOptionsAreIdentifiedCorrectly;
  {
    NOTE: We can't test the TestRun method directly as this examines the runtime
           command line args.  But the actual command line option handling is
           performed by the Utils method, which we CAN test.
  }
  var
    args: TStringList;
    value: String;
  begin
    args := TStringList.Create;
    try
      args.Add('selftest.exe');
      args.Add('-switch');
      args.Add('-mode:level=42');

      value := 'dummy';
      Assert('Present -switch is identified', HasCmdLineOption(args, 'switch', value), 'Failed to identify -switch in args');
      Assert('Present -switch has no value', value = '', Format('-switch has invalid value (%s)', [value]));

      value := 'dummy';
      Assert('-mode switch is identified', HasCmdLineOption(args, 'mode', value), 'Failed to identify -mode switch in args');
      Assert('-mode swtich value is ''level=42''', value = 'level=42', Format('-mode has invalid value (%s)', [value]));

      value := 'dummy';
      Assert('Missing -lever is not identified', NOT HasCmdLineOption(args, 'lever', value), '-lever identified as present when it is not');
      Assert('Missing -lever switch has no value', value = '', Format('-lever has invalid value (%s)', [value]));

    finally
      args.Free;
    end;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
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



initialization
  TestRun := TTestRunHelper(Deltics.Smoketest.TestRun.TestRun);
end.
