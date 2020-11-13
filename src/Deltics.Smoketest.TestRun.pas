{
  * MIT LICENSE *

  Copyright © 2019 Jolyon Smith

  Permission is hereby granted, free of charge, to any person obtaining a copy of
   this software and associated documentation files (the "Software"), to deal in
   the Software without restriction, including without limitation the rights to
   use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
   of the Software, and to permit persons to whom the Software is furnished to do
   so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
   copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
   SOFTWARE.


  * GPL and Other Licenses *

  The FSF deem this license to be compatible with version 3 of the GPL.
   Compatability with other licenses should be verified by reference to those
   other license terms.


  * Contact Details *

  Original author : Jolyon Direnko-Smith
  e-mail          : jsmith@deltics.co.nz
  github          : deltics/deltics.smoketest
}

{$i deltics.smoketest.inc}

  unit Deltics.Smoketest.TestRun;


interface

  uses
    Classes,
    SysUtils,
    Deltics.Smoketest.Test,
    Deltics.Smoketest.TestResult;


  type
    TTestMethod = procedure of object;

    TTestRun = class
    private
      fCmdLineArgs: TStringList;
      fCelebrateSuccess: Boolean;
      fVerboseOutput: Boolean;
      fLineFeedBeforeTypeNameOrSummary: Boolean;

      fDefaultTestName: String;
      fName: String;
      fEnvironment: String;
      fIsAborted: Boolean;
      fIsFinished: Boolean;
      fIsRunning: Boolean;
      fStartTime: TDateTime;
      fFinishTime: TDateTime;

      fTypeName: String;
      fHumanisedMethodName: String;
      fMethodName: String;
      fPreviousMethodName: String;
      fPreviousTypeName: String;
      fTestName: String;
      fTestNamePrefix: String;
      fExpectedFailures: Integer;
      fExpectedResult: TResultState;
      fExpectedErrorClass: TClass;
      fExpectedErrorMessage: String;
      fTestsExpected: Boolean;

      fTestsCount: Integer;
      fTestsPassed: Integer;
      fTestsFailed: Integer;
      fTestsSkipped: Integer;
      fTestsError: Integer;
      fTestIndex: Integer;

      fResults: TList;
      fWriters: TStringList;

      function get_FinishTime: TDateTime;
      function get_RunTime: Integer;
      function get_Failed: Boolean;
      function get_Result(const aIndex: Integer): TTestResult;
      function get_ResultCount: Integer;
      procedure set_Environment(const aValue: String);
      procedure set_Name(const aValue: String);

      function AddResult(const aTestName: String; const aResult: TResultState; const aReason: String; const aException: Exception): TTestResult;
      procedure CheckExpectedStates;
      procedure EmitMethodName;
      procedure EmitTypeName;
      function ExtractMethod(const aTest: TTest; const aMethodList: TStringList; const aMethodToExtract: String): TTestMethod;

      procedure SaveResults;

    protected
      procedure Abort;
      procedure BeginRun;
      procedure Complete;
      procedure SetTestType(const aTypeName: String);
      procedure SetTestMethod(const aMethodName: String);
      procedure SetTestNamePrefix(const aPrefix: String);
      procedure ExpectingException(const aExceptionClass: TClass; const aMessage: String);
      procedure ExpectingToFail(aCount: Integer);
      function TestError(const aException: Exception = NIL): TTestResult;
      function TestException(const aValueName: String; aExceptionClass: TClass; aBaseException: Boolean; const aMessage: String): Boolean;
      function TestFailed(const aTestName: String; const aReason: String): TTestResult;
      function TestPassed(const aTestName: String): TTestResult;

    public
      constructor Create;
      destructor Destroy; override;

      function HasCmdLineOption(const aName: String; var aValue: String): Boolean; overload;
      function HasCmdLineOption(const aName: String): Boolean; overload;
      procedure NoTestsPerformed;
      procedure Test(const aTest: TTestClass; const aNamePrefix: String = ''); overload;
      procedure Test(const aTests: array of TTestClass; const aNamePrefix: String = ''); overload;

      property DefaultTestName: String read fDefaultTestName write fDefaultTestName;
      property Name: String read fName write set_Name;
      property Environment: String read fEnvironment write set_Environment;
      property IsAborted: Boolean read fIsAborted;
      property IsFinished: Boolean read fIsFinished;
      property IsRunning: Boolean read fIsRunning;
      property Failed: Boolean read get_Failed;

      property StartTime: TDateTime read fStartTime;
      property FinishTime: TDateTime read get_FinishTime;
      property RunTime: Integer read get_RunTime;

      property ResultCount: Integer read get_ResultCount;
      property Results[const aIndex: Integer]: TTestResult read get_Result;
      property ResultsWriters: TStringList read fWriters;

      property TestCount: Integer read fTestsCount;
      property TestsPassed: Integer read fTestsPassed;
      property TestsFailed: Integer read fTestsFailed;
      property TestsSkipped: Integer read fTestsSkipped;
      property TestsError: Integer read fTestsError;
    end;


  var
    TestRun: TTestRun;


implementation

  uses
  {$ifdef DELPHI2006__}
    {$ifdef __DELPHI2009}
      Windows,
    {$endif}
  {$endif}
    Deltics.Smoketest.ResultsWriter,
    Deltics.Smoketest.Utils;


  type
    TTestHelper = class(TTest); // For access to protected GetTestMethods


  function Humanised(const aString: String): String;
  var
    i, j: Integer;
    c, nc: AnsiChar;
  begin
    if aString = '' then
    begin
      result := '';
      EXIT;
    end;

    SetLength(result, 2 * Length(aString));
    j := 1;
    for i := 1 to Length(aString) do
    begin
      c := AnsiChar(aString[i]);
      if (c in ['A'..'Z']) then
      begin
        nc := AnsiChar(aString[i + 1]);

        if (i > 1) then
        begin
          if (i < Length(aString)) and NOT (nc in ['A'..'Z']) then
          begin
            result[j] := ' ';
            Inc(j);
          end;

          if i > 1 then
            result[j] := Char(Ord(aString[i]) + 32);
        end
        else
          result[j] := aString[i];

        Inc(j);
      end
      else
      begin
        result[j] := aString[i];
        Inc(j);
      end;
    end;

    SetLength(result, j - 1);
  end;



{ TTestRun --------------------------------------------------------------------------------------- }

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  constructor TTestRun.Create;
  var
    i: Integer;
  begin
    inherited Create;

    fExpectedResult := rsPass;

    fCmdLineArgs  := TStringList.Create;
    fResults      := TList.Create;
    fWriters      := TStringList.Create;

    for i := 0 to ParamCount do
      fCmdLineArgs.Add(ParamStr(i));

    fCelebrateSuccess := HasCmdLineOption('celebrateSuccess') or HasCmdLineOption('cs');
    fVerboseOutput    := HasCmdLineOption('verbose') or HasCmdLineOption('v');
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  destructor TTestRun.Destroy;
  var
    i: Integer;
  begin
    for i := 0 to Pred(fResults.Count) do
      TObject(fResults[i]).Free;

    for i := 0 to Pred(fWriters.Count) do
      fWriters.Objects[i].Free;

    fResults.Free;
    fWriters.Free;
    fCmdLineArgs.Free;

    inherited;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TTestRun.get_Failed: Boolean;
  begin
    result := (fTestsFailed + fTestsError) > 0;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TTestRun.get_FinishTime: TDateTime;
  {
    It is an error to attempt to reference the testrun finishtime if the
     testrun has not yet actually finished.
  }
  begin
    if NOT fIsFinished then
      raise Exception.Create('Test run has not yet finished');

    result := fFinishTime;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TTestRun.get_Result(const aIndex: Integer): TTestResult;
  begin
    result := TTestResult(fResults[aIndex]);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TTestRun.get_ResultCount: Integer;
  begin
    result := fResults.Count;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TTestRun.get_RunTime: Integer;
  {
    Returns the runtime (in milliseconds) of the testrun.  If the testrun
     is finished then the runtime reflects the time from start to finish.
     If the testrun is not yet finished then the runtime reflects the time
     from start to now (and thus will keep increasing until the testrun is
     finished).
  }
  var
    finish: TDateTime;
  begin
    if fIsFinished then
      finish := FinishTime
    else
      finish := Now;

    result := Round((finish - fStartTime) * 24 * 60 * 60 * 1000);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TTestRun.set_Environment(const aValue: String);
  begin
    if fIsRunning then
      WriteLn('WARNING: Attempt to change TestRun.Environment during test run (ignored)')
    else if fIsFinished then
      WriteLn('WARNING: Attempt to change TestRun.Environment after test run completion (ignored)')
    else
      fEnvironment := aValue;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TTestRun.set_Name(const aValue: String);
  begin
    if fIsRunning then
      WriteLn('WARNING: Ignored attempt to change TestRun.Name during test run')
    else if fIsFinished then
      WriteLn('WARNING: Ignored attempt to change TestRun.Name after test run completion')
    else
      fName := aValue;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TTestRun.Abort;
  begin
    fIsAborted := TRUE;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TTestRun.AddResult(const aTestName: String;
                              const aResult: TResultState;
                              const aReason: String;
                              const aException: Exception): TTestResult;

    function HumanisedTypeName: String;
    begin
      result := fTypeName;
      if (result[1] = 'T') and (AnsiChar(result[2]) in ['A'..'Z']) then
        Delete(result, 1, 1);

      result := Humanised(result);
    end;

    function GetTestName: String;
    {
      Calculates and returns the name of the current test.

      If no test name has been explicitly set then the name will default to the
       name of the currently executing test method.  If there is no method name
       then the test (class) name is used.

      Any specified name prefix is then applied.

      Finally, where the name has been derived from either the method or test
       class name, the name is appended by a numeric identifier of the test
       being performed (since in this case there are likely to be multiple
       'unnamed' tests being performed) to help identify which test is being
       referenced.
    }
    begin
      result := fTestName;

      result := StringReplace(result, METHOD_NAME, fHumanisedMethodName, [rfReplaceAll, rfIgnoreCase]);
      result := StringReplace(result, TEST_NAME, HumanisedTypeName, [rfReplaceAll, rfIgnoreCase]);

      if result = '' then
        result := fMethodName + ' test #' + IntToStr(fTestIndex);

      if fTestNamePrefix <> '' then
        result := '[' + fTestNamePrefix + '] ' + result;
    end;

  const
    STATE_LABEL: array[TResultState] of String = ('PASSED', 'FAILED', 'skipped', 'ERROR');
  var
    state: TResultState;
    testName: String;
    expectedError: Boolean;
    reason: String;
  begin
    fTestName := aTestName;
    try
      Inc(fTestsCount);
      Inc(fTestIndex);

      state := aResult;
      if IsAborted then
        state := rsSkip;

      case state of
        rsFail  : Inc(fTestsFailed);
        rsPass  : Inc(fTestsPassed);
        rsSkip  : Inc(fTestsSkipped);
        rsError : Inc(fTestsError);
      end;

      testName  := GetTestName;
      reason    := aReason;

      if (state = rsError) then
      begin
        expectedError := (fExpectedResult = rsError)
                     and (fExpectedErrorClass = aException.ClassType)
                     and ((fExpectedErrorMessage = '') or (fExpectedErrorMessage = aException.Message));

        if expectedError then
          reason := reason + ' (Expected exception)'
        else
          fExpectedResult := rsPass;
      end
      else
        expectedError := FALSE;

      result := TTestResult.Create(testName, fTypeName, fMethodName, fTestIndex, fExpectedResult, state, reason);

      fResults.Add(result);

      if (state = fExpectedResult)  and (expectedError or (state <> rsError)) then
        state := rsPass
      else if state = rsPass then
        state := rsFail;

      if NOT (fVerboseOutput or fCelebrateSuccess or (state in [rsFail, rsError])) then
        EXIT;

      EmitTypeName;
      EmitMethodName;
      fLineFeedBeforeTypeNameOrSummary := TRUE;

      Write('    + ');
      if (state = aResult) then
      begin
        WriteLn(STATE_LABEL[state] + ': ' + testName);
        if state in [rsFail, rsError] then
          WriteLn('      [' + reason + ']');
      end
      else
        WriteLn(STATE_LABEL[aResult] + ' (=> ' + STATE_LABEL[state] + '): ' + testName);

    finally
      fTestName             := '';
      fExpectedErrorClass   := NIL;
      fExpectedErrorMessage := '';

      if (fExpectedFailures > 0) then
        Dec(fExpectedFailures);

      if fExpectedFailures = 0 then
        fExpectedResult := rsPass;
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TTestRun.BeginRun;
  begin
    if fIsRunning then
    begin
      WriteLn('WARNING: Multiple calls to TestRun.BeginRun detected (first call started the run)');
      EXIT;
    end;

    if (fName = '') then
      fName := ExtractFilename(ParamStr(0));

    if fEnvironment = '' then
      fEnvironment := 'Test';

    WriteLn(':> ' + CmdLine);
    WriteLn('Smoketest test run: Name=' + fName + ', Environment=' + fEnvironment);
    Write('Writers supported: ');
    if fWriters.Count > 0 then WriteLn(fWriters.CommaText) else WriteLn('(none)');
    WriteLn;

    fStartTime := Now;
    fIsRunning := TRUE;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TTestRun.CheckExpectedStates;
  var
    i: Integer;
    result: TTestResult;
  begin
    for i := 0 to Pred(ResultCount) do
    begin
      result := Results[i];

      if (result.ExpectedState = rsPass) then
        CONTINUE;

      case result.ActualState of
        rsPass  : Dec(fTestsPassed);
        rsFail  : Dec(fTestsFailed);
        rsSkip  : Dec(fTestsSkipped);
        rsError : Dec(fTestsError);
      end;

      if result.ActualState = result.ExpectedState then
      begin
        Inc(fTestsPassed);
        result.State := rsPass;
      end
      else if result.ActualState = rsFail then
      begin
        Inc(fTestsFailed);
        result.State := rsFail;
      end
      else if result.ActualState = rsError then
        Inc(fTestsError);
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TTestRun.Complete;
  begin
    if fIsFinished then
    begin
      WriteLn('WARNING: Attempt to call TestRun.Complete multiple times.');
      WriteLn('         (The first call already terminated the run)');
      EXIT;
    end;

    fIsFinished := TRUE;
    fFinishTime := Now;

    CheckExpectedStates;
    try
      if fTestsCount = 0 then
      begin
        WriteLn('WARNING: No tests performed.');
        EXIT;
      end;

      if fLineFeedBeforeTypeNameOrSummary then
        WriteLn;

      WriteLn(Format('Total Tests = %d, Passed = %d, Failed = %d, Skipped = %d, Errors = %d',
                     [fTestsCount, fTestsPassed, fTestsFailed, fTestsSkipped, fTestsError]));

      SaveResults;

    finally
      if HasCmdLineOption('wait') then
        ReadLn;

      if (fTestsFailed + fTestsError > 0) then
        ExitCode := 1;
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TTestRun.EmitMethodName;
  begin
    if (fPreviousMethodName <> fMethodName) then
    begin
      WriteLn('  > ' + fMethodName);
      fPreviousMethodName := fMethodName;
    end;
  end;


  procedure TTestRun.EmitTypeName;
  begin
    if (fPreviousTypeName <> fTypeName) then
    begin
      if fLineFeedBeforeTypeNameOrSummary then
        WriteLn;

      WriteLn(' ' + fTypeName);
      fPreviousTypeName := fTypeName;
      fLineFeedBeforeTypeNameOrSummary := FALSE;
    end;
  end;


  procedure TTestRun.ExpectingException(const aExceptionClass: TClass;
                                        const aMessage: String);
  {
    Sets details of an expected exception.  If the next test that is performed
     raises an exception that matches these details then this will be
     acknowledged as the expected result (i.e. a PASS) rather than an error.

    These details are cleared and the expected result reset to Pass by the
     execution of a test.  That is, setting details of an expected exception
     applies only for the immediately following test.

    NOTE: This method is intended only to be called by the tests implemented
           in the smoketest selftest project.  It is NOT designed or intended
           for general use.
  }
  begin
    fExpectedResult       := rsError;
    fExpectedErrorClass   := aExceptionClass;
    fExpectedErrorMessage := aMessage;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TTestRun.ExpectingToFail(aCount: Integer);
  {
    Sets the expected result to Fail.  If the next test that is performed
     fails then this can be acknowledged as the expected result (i.e. a PASS)
     rather than an actual failure.

    The expected result will be reset to Pass by the execution of a test.
     That is, setting the expected result to Fail applies only for the
     immediately following test.

    NOTE: This method is intended only to be called by the tests implemented
           in the smoketest selftest project.  It is NOT designed or intended
           for general use.
  }
  begin
    fExpectedFailures := aCount;

    if aCount <> 0 then
      fExpectedResult := rsFail
    else
      fExpectedResult := rsPass;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TTestRun.TestError(const aException: Exception): TTestResult;
  var
    eo: TObject;
    e: Exception;
    msg: String;
  begin
    e := aException;

    if NOT Assigned(e) then
    begin
      eo := ExceptObject;

      if eo is Exception then
        e := Exception(eo);
    end
    else
      eo := e;

    if Assigned(e) then
      msg := e.Message
    else
      msg := '';

    result := AddResult('', rsError, Format('Raised exception [%s: %s]', [eo.ClassName, msg]), e);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TTestrun.TestException(const aValueName: String;
                                        aExceptionClass: TClass;
                                        aBaseException: Boolean;
                                  const aMessage: String): Boolean;
  var
    eo: TObject;
    e: Exception absolute eo;
    testName: String;
    failure: String;
    messageTested: Boolean;
    messageOk: Boolean;
  begin
    result := FALSE;

    testName := aValueName + ' raises ' + aExceptionClass.ClassName;

    if aBaseException then
      testName := testName + ' (or subclass)';

    eo := ExceptObject;
    if NOT Assigned(eo) then
    begin
      TestRun.TestFailed(testName, 'No exception was raised');
      EXIT;
    end;

    messageTested := FALSE;
    messageOk     := TRUE;
    if (aMessage <> '') then
    begin
      if (eo is Exception) then
      begin
        messageOk     := AnsiSameText(e.Message, aMessage);
        messageTested := TRUE;
      end
      else
        WriteLn('WARNING: Expected exception message could not be tested as ' + eo.ClassName + ' does not derive from Exception');
    end;

    if aBaseException then
      result := (e is aExceptionClass) and messageOk
    else
      result := (eo.ClassType = aExceptionClass) and messageOk;

    if NOT result then
    begin
      failure := 'Expected ' + aExceptionClass.ClassName;

      if aBaseException then
        failure := failure + ' (or subclass)';

      if aMessage <> '' then
        failure := failure + ' with message ''' + aMessage + '''';

      if eo.ClassType <> aExceptionClass then
      begin
        failure := failure + ' but ' + eo.ClassName + ' was raised';
        if messageTested and NOT messageOk then
          failure := failure + ' and';
      end
      else if messageTested then
        failure := failure + ' but';

      if NOT messageOk then
        failure := failure + ' message was ''' + e.Message + '''';

      TestRun.TestFailed(testName, failure);
    end
    else
      TestRun.TestPassed(testName);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TTestRun.TestFailed(const aTestName: String;
                               const aReason: String): TTestResult;
  begin
    result := AddResult(aTestName, rsFail, aReason, NIL);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TTestRun.TestPassed(const aTestName: String): TTestResult;
  begin
    result := AddResult(aTestName, rsPass, '', NIL);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TTestRun.ExtractMethod(const aTest: TTest;
                                  const aMethodList: TStringList;
                                  const aMethodToExtract: String): TTestMethod;
  var
    i: Integer;
  begin
    TMethod(result).Data := NIL;
    TMethod(result).Code := NIL;

    for i := 0 to Pred(aMethodList.Count) do
    begin
      if NOT SameText(aMethodList[i], aMethodToExtract) then
        CONTINUE;

      TMethod(result).Data := aTest;
      TMethod(result).Code := aTest.MethodAddress(aMethodList[i]);

      aMethodList.Delete(i);
      BREAK;
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TTestRun.SetTestType(const aTypeName: String);
  begin
    fTypeName := aTypeName;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TTestRun.SetTestMethod(const aMethodName: String);
  begin
    fHumanisedMethodName  := Humanised(aMethodName);
    fMethodName           := aMethodName;

    fTestIndex     := 0;
    fTestsExpected := TRUE;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TTestRun.SetTestNamePrefix(const aPrefix: String);
  begin
    fTestNamePrefix := aPrefix;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TTestRun.SaveResults;
  {
    Identifies command line options that specify known results writer
     formats.  For each identified writer option, call the writer to
     output the test results as required.
  }
  var
    i: Integer;
    filename: String;
  begin
    for i := 0 to Pred(fWriters.Count) do
    begin
      if NOT HasCmdLineOption(fWriters[i], filename) then
        CONTINUE;

      try
        WriteLn(Format('Writing %s results to %s', [fWriters[i], filename]));
        TResultsWriter(fWriters.Objects[i]).SaveResults(filename);

      except
        on e: Exception do
          WriteLn(Format('ERROR: Failed to write %s results to %s (%s: %s)', [fWriters[i], filename, e.ClassName, e.Message]));
      end;
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TTestRun.HasCmdLineOption(const aName: String): Boolean;
  {
    Convenience function for determining the presence of a command line
     option where there is no associated value or the value is of no interest.
  }
  var
    notUsed: String;
  begin
    result := HasCmdLineOption(aName, notUsed);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TTestRun.NoTestsPerformed;
  {
    Indicates to the TestRun that a test method explicitly did not perform
     any tests.  This suppresses the console warning that is usually produced
     when a test method does not perform any tests.

    NOTE: This indicator auto-resets for each method.
  }
  begin
    fTestsExpected := FALSE;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TTestRun.HasCmdLineOption(const aName: String;
                                     var   aValue: String): Boolean;
  {
    Examines the command line looking for the presence of a specified option
     with an optional value which, if present, is passed back in the var
     aValue parameter.

    Options are expected to be specified in one of the three forms:

         -name
         -name:value
         -name=value

    If value contains spaces, then the value should be quoted:

         -name="value with spaces"

    If a quoted value contains quotes then these will be stripped from the value,
     even if they are 'escaped' by doubling.  This is due to poor handling of
     quoted command line elements by the ParamSTR() RTL function and will
     possibly change in the future by avoiding the use of ParamStr() but only
     if the need becomes pressing.  For now be aware that quoted values will
     not themselves contain ANY quotes:

         -name="1 foot = 12"""           ->   value = '1 foot = 12'
         -name="1 foot = 12"             ->   value = '1 foot = 12'
         -name="value ""with"" spaces"   ->   value = 'value with spaces'

    The first provides the option but has no value.  The second and third
     forms provide the option and the associated value follows the separator
     character which must be either a ':' or a '='.  Only the first occurence
     of either of these separators is significant for the purpose of identifying
     options and associated values:

         -mode:level=42      > identifies option 'mode' with value 'level=42'
         -mode=level:42      > identifies option 'mode' with value 'level:42'
         -mode:level:42      > identifies option 'mode' with value 'level:42'
         -mode=level=42      > identifies option 'mode' with value 'level=42'
  }
  begin
    result := Deltics.Smoketest.Utils.HasCmdLineOption(fCmdLineArgs, aName, aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TTestRun.Test(const aTest: TTestClass;
                          const aNamePrefix: String);
  {
    Identifies and executes test methods on the specified class.

    The outcome of tests performed by each test method is recorded on the test
     run by the Assert() mechanisms implemented in the Test class and called
     during the execution of each method.
  }

    procedure PerformMethod(const aMethod: TTestMethod;
                            const aMessage: String;
                                  aIndent: Integer);
    var
      indent: String;
    begin
      if NOT Assigned(aMethod) then
        EXIT;

      indent := StringOfChar(' ', aIndent);
      if fVerboseOutput and (aMessage <> '') then
        WriteLn(indent + aMessage);

      try
        aMethod;

      except
        on e: Exception do
          WriteLn(indent + Format('  ERROR [%s]: %s', [e.ClassName, e.Message]));
      end;
    end;

  var
    i: Integer;
    test: TTest;
    methods: TStringList;
    method: TTestMethod;
    resultCountBeforeMethodRan: Integer;
    setupTest: TTestMethod;
    setupMethod: TTestMethod;
    teardownMethod: TTestMethod;
    teardownTest: TTestMethod;
  begin
    if IsFinished then
    begin
      WriteLn(Format('WARNING: Methods in test class %s not performed as TestRun has already finished', [aTest.ClassName]));
      EXIT;
    end;

    if NOT IsRunning then
      BeginRun;

    test    := aTest.Create;
    methods := TStringList.Create;
    try
      SetTestType(test.ClassName);
      SetTestNamePrefix(aNamePrefix);

      if (fVerboseOutput) then
        EmitTypeName;

      TTestHelper(test).GetTestMethods(methods);

      if methods.Count = 0 then
      begin
        WriteLn(Format('WARNING: Test class %s implements no test methods', [fTypeName]));
        EXIT;
      end;

      setupTest       := ExtractMethod(test, methods, 'SetupTest');
      setupMethod     := ExtractMethod(test, methods, 'SetupMethod');
      teardownMethod  := ExtractMethod(test, methods, 'TeardownMethod');
      teardownTest    := ExtractMethod(test, methods, 'TeardownTest');

      PerformMethod(setupTest, 'Setup Test', 2);
      try
        for i := 0 to Pred(methods.Count) do
        begin
          SetTestMethod(methods[i]);

          TMethod(method).Data := test;
          TMethod(method).Code := test.MethodAddress(methods[i]);

          resultCountBeforeMethodRan := fTestsCount;
          try
            try
              PerformMethod(setupMethod, 'Setup ' + methods[i], 4);
              try
                fExpectedFailures := 0;
                fExpectedResult   := rsPass;

                if (fVerboseOutput) then
                  EmitMethodName;

                method;

                if Assigned(fExpectedErrorClass) then
                  TestException(fMethodName, fExpectedErrorClass, FALSE, fExpectedErrorMessage);

              finally
                PerformMethod(teardownMethod, 'Teardown ' + methods[i], 4);
              end;

            except
              on e: Exception do
                TestError(e);
            end;

          finally
            if fTestsExpected and (fTestsCount = resultCountBeforeMethodRan) then
              WriteLn(Format('WARNING: Test method %s.%s did not perform any tests', [fTypeName, fMethodName]));

            SetTestMethod('');
          end;
        end;

      finally
        PerformMethod(teardownTest, 'Teardown Test', 2);
      end;

    finally
      SetTestNamePrefix('');
      SetTestType('');

      methods.Free;
      test.Free;
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TTestRun.Test(const aTests: array of TTestClass;
                          const aNamePrefix: String);
  {
    Executes test methods on one or more identified test classes.
  }
  var
    i: Integer;
  begin
    for i := 0 to High(aTests) do
      Test(aTests[i], aNamePrefix);
  end;




initialization
  TestRun := TTestRun.Create;

finalization
  if Assigned(TestRun) and NOT TestRun.IsFinished then
    TestRun.Complete;

end.
