
  unit Test.CoreFunctionality;

interface

  uses
    Deltics.Smoketest,
    Test.SelfTest;

  type
    TCoreFunctionalityTests = class(TSelfTest)
    private
      TestsCounted: Integer;
      TestsPassed: Integer;
      TestsFailed: Integer;
      TestsErrored: Integer;
    published
      procedure ThisTestWillPass;
      procedure ThisTestWillFail;
      procedure ThisTestWillThrowAnException;
      procedure CaptureStats;
      procedure ThreeTestsHaveBeenRecordedAtThisPoint;
      procedure OneTestHasPassed;
      procedure OneTestHasFailed;
      procedure OneTestHasErrored;
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
    Assert('This test will fail', FALSE);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCoreFunctionalityTests.ThisTestWillPass;
  begin
    Assert('This test will pass', TRUE);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCoreFunctionalityTests.ThisTestWillThrowAnException;
  begin
    ExpectingException(Exception, 'This exception was deliberately raised');
    raise Exception.Create('This exception was deliberately raised');
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCoreFunctionalityTests.CaptureStats;
  begin
    // We need to read and store these values since the tests we are about
    //  to run will change the stats on the TestRun!

    TestsPassed  := TestRun.TestsPassed;
    TestsFailed  := TestRun.TestsFailed;
    TestsErrored := TestRun.TestsError;
    TestsCounted := TestRun.TestCount;

    TestRun.NoTestsPerformed;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCoreFunctionalityTests.ThreeTestsHaveBeenRecordedAtThisPoint;
  begin
    Assert(TestsCounted).Equals(3);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCoreFunctionalityTests.OneTestHasPassed;
  begin
    Assert(TestsPassed).Equals(1);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCoreFunctionalityTests.OneTestHasFailed;
  begin
    Assert(TestsFailed).Equals(1);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCoreFunctionalityTests.OneTestHasErrored;
  begin
    Assert(TestsErrored).Equals(1);
  end;


end.
