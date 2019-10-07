
  unit Test.ExceptionHandling;

interface

  uses
    Deltics.SmokeTest;

  type
    TExceptionHandlingTests = class(TTest)
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
      AssertException(EDivByZero, 'EDivByZero caught by AssertException(EDivByZero)');
    end;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TExceptionHandlingTests.EDivByZeroIsCaughtByAssertingBaseException;
  begin
    try
      raise EDivByZero.Create('EDivByZero is an Exception');
    except
      AssertBaseException(Exception, 'EDivByZero caught by AssertBaseException(Exception)');
    end;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TExceptionHandlingTests.EDivByZeroNotCaughtByAssertExceptionCausesTestToFail;
  begin
    TestRun.ExpectingToFail;
    try
      raise EDivByZero.Create('Testing for a specific exception type');
    except
      AssertException(Exception, 'EDivByZero not caught by Assert(Exception) causes test to fail');
    end;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TExceptionHandlingTests.AssertingAnExceptionThatIsNotRaisedCausesTestToFail;
  begin
    TestRun.ExpectingToFail;
    try
      AssertException(Exception, 'Unexpected Exception raised causes test to fail');
    except
      // NO-OP (there is no exception raised)
    end;
  end;



end.
