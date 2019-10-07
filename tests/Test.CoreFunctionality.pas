
  unit Test.CoreFunctionality;

interface

  uses
    Deltics.Smoketest;

  type
    TCoreFunctionalityTests = class(TTest)
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


  // We wouldn't normally need to do this, but these self-tests area a special
  //  case that need access to protected members of the TestRun (designed
  //  specifically for this self-test scenario)
  type
    TTestRunHelper = class(TTestRun);

  function TestRun: TTestRunHelper;
  begin
    result := TTestRunHelper(Deltics.Smoketest.TestRun.TestRun);
  end;



{ CoreFunctionality tests ------------------------------------------------------------------------ }

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCoreFunctionalityTests.ThisTestWillFail;
  begin
    TestRun.ExpectingToFail;
    Assert('This test failed', FALSE);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCoreFunctionalityTests.ThisTestWillPass;
  begin
    Assert('This test passed', TRUE);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCoreFunctionalityTests.ThisTestWillThrowAnException;
  begin
    TestRun.ExpectingException(Exception, 'This exception was deliberately raised');
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
    Assert('3 tests recorded to this point', TestsCounted = 3, Format('%d tests counted, 3 expected', [TestsCounted]));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCoreFunctionalityTests.OneTestHasPassed;
  begin
    Assert('1 test passed at this point', TestsPassed = 1, Format('%d tests passed, 1 expected', [TestsPassed]));
  end;



  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCoreFunctionalityTests.OneTestHasFailed;
  begin
    Assert('1 test failed at this point', TestsFailed = 1, Format('%d tests failed, 1 expected', [TestsFailed]));
  end;



  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCoreFunctionalityTests.OneTestHasErrored;
  begin
    Assert('1 test error at this point', TestsErrored = 1, Format('%d errors, 1 expected', [TestsErrored]));
  end;


end.
