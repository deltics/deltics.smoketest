
  unit Test.ExceptionHandling;

interface

  uses
    Deltics.SmokeTest,
    Test.SelfTest;

  type
    TExceptionHandlingTests = class(TSelfTest)
      procedure EDivByZeroIsCaughtByAssertingEDivByZero;
      procedure EDivByZeroIsCaughtByAssertingBaseException;
      procedure EDivByZeroNotCaughtByAssertExceptionCausesTestToFail;
      procedure AssertingAnExceptionThatIsNotRaisedCausesTestToFail;
    end;




implementation

  uses
    SysUtils,
    Deltics.Smoketest.TestRun;


  // We wouldn't normally need to do this, but these self-tests area a special
  //  case that need access to protected members of the TestRun (designed
  //  specifically for this self-test scenario)
  type
    TTestRunHelper = class(TTestRun);

  function TestRun: TTestRunHelper;
  begin
    result := TTestRunHelper(Deltics.Smoketest.TestRun.TestRun);
  end;



{ ExceptionHandling tests ------------------------------------------------------------------------ }

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TExceptionHandlingTests.EDivByZeroIsCaughtByAssertingEDivByZero;
  begin
    try
      raise EDivByZero.Create('This exception was deliberately raised');
    except
      AssertException(EDivByZero);
    end;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TExceptionHandlingTests.EDivByZeroIsCaughtByAssertingBaseException;
  begin
    try
      raise EDivByZero.Create('EDivByZero is an Exception');
    except
      AssertBaseException(Exception);
    end;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TExceptionHandlingTests.EDivByZeroNotCaughtByAssertExceptionCausesTestToFail;
  begin
    NextAssertExpectedToFail;
    try
      raise EDivByZero.Create('Testing for a specific exception type');
    except
      AssertException(Exception);
    end;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TExceptionHandlingTests.AssertingAnExceptionThatIsNotRaisedCausesTestToFail;
  begin
    NextAssertExpectedToFail;
    try
      AssertException(Exception);
    except
      // NO-OP (there is no exception raised)
    end;
  end;



end.
