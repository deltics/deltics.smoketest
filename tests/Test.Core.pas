
  unit Test.Core;

interface

  uses
    Deltics.Smoketest,
    Test.SelfTest;

  type
    TCoreFunctionalityTests = class(TSelfTest)
    published
      procedure ThisTestWillPass;
      procedure ThisTestWillFail;
      procedure ThisTestWillThrowAnException;
      procedure ExpectedTestResultsToThisPoint;
      // --------------------------------------------------------------------------
      // Any additional tests must be introduced AFTER this point otherwise the
      //  expected tests counts in the TestResultsAreAsExpected test will be wrong
      //  (alternatively you will need to adjust those counts accordingly).
      //
      // Similarly, the TCoreFunctionality test MUST be the FIRST test executed
      //  for the same reason.
    end;


implementation

  uses
    SysUtils,
    Deltics.Smoketest.TestRun,
    Deltics.Smoketest.Utils;



{ CoreFunctionality tests ------------------------------------------------------------------------ }

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCoreFunctionalityTests.ThisTestWillFail;
  begin
    AllAssertsExpectedToFail;
    Test('This test will fail').Assert(FALSE);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCoreFunctionalityTests.ThisTestWillPass;
  begin
    Test('This test will pass').Assert(TRUE);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCoreFunctionalityTests.ThisTestWillThrowAnException;
  begin
    ExpectingException(Exception, 'This exception was deliberately raised');

    raise Exception.Create('This exception was deliberately raised');
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCoreFunctionalityTests.ExpectedTestResultsToThisPoint;
  begin
    Test('Number of tests passed').Assert(TestRun.TestsPassed).Equals(1);
    Test('Number of tests failed').Assert(TestRun.TestsFailed).Equals(1);
    Test('Number of tests errored').Assert(TestRun.TestsError).Equals(1);
    Test('Number of tests performed').Assert(TestRun.TestCount).Equals(6);
  end;



end.
