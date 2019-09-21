
{$i Deltics.Smoketest.inc}

  unit Deltics.Smoketest.TestRun;

interface

  uses
    Classes,
    SysUtils,
    Deltics.Smoketest.Test,
    Deltics.Smoketest.TestResult;


  type
    TTestRun = class
    private
      fName: String;
      fEnvironment: String;
      fIsAborted: Boolean;
      fIsFinished: Boolean;
      fIsRunning: Boolean;
      fStartTime: TDateTime;
      fFinishTime: TDateTime;

      fTypeName: String;
      fMethodName: String;
      fTestName: String;
      fTestNamePrefix: String;
      fExpectedResult: TResultState;
      fExpectedErrorClass: TClass;
      fExpectedErrorMessage: String;

      fTestsCount: Integer;
      fTestsPassed: Integer;
      fTestsFailed: Integer;
      fTestsSkipped: Integer;
      fTestsError: Integer;
      fTestIndex: Integer;

      fResults: TList;
      fWriters: TStringList;

      function get_CurrentTestName: String;
      function get_FinishTime: TDateTime;
      function get_RunTime: Integer;
      function get_Failed: Boolean;
      function get_Result(const aIndex: Integer): TTestResult;
      function get_ResultCount: Integer;
      procedure set_Environment(const aValue: String);
      procedure set_Name(const aValue: String);

      procedure AddResult(const aTestName: String; const aResult: TResultState; const aReason: String);
      procedure CheckExpectedStates;

      procedure SaveResults;
      property CurrentTestName: String read get_CurrentTestName;

    protected
      procedure Abort;
      procedure BeginRun;
      procedure Complete;
      procedure SetTestType(const aTypeName: String);
      procedure SetTestMethod(const aMethodName: String);
      procedure SetTestNamePrefix(const aPrefix: String);

      procedure TestError(const aException: Exception);
      procedure TestPassed(const aTest: String);
      procedure TestFailed(const aTest: String; const aReason: String);

    public
      constructor Create;
      destructor Destroy; override;

      function HasCmdLineOption(const aName: String; var aValue: String): Boolean; overload;
      function HasCmdLineOption(const aName: String): Boolean; overload;
      procedure ExpectingError(const aExceptionClass: TClass; const aMessage: String);
      procedure ExpectingToFail;
      procedure Execute(const aTest: TTestClass; const aNamePrefix: String = ''); overload;
      procedure Execute(const aTests: TTestArray; const aNamePrefix: String = ''); overload;

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
    Deltics.Smoketest,
    Deltics.Smoketest.ResultsWriter;


  type
    TTestMethod = procedure;
    TTestMethodArray = array of TTestMethod;


{ TTestRun }

  constructor TTestRun.Create;
  begin
    inherited Create;

    fExpectedResult := rsPass;

    fResults := TList.Create;
    fWriters := TStringList.Create;
  end;


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

    inherited;
  end;


  procedure TTestRun.Abort;
  begin
    fIsAborted := TRUE;
  end;


  procedure TTestRun.AddResult(const aTestName: String;
                               const aResult: TResultState;
                               const aReason: String);
  var
    result: TResultState;
    testName: String;
  begin
    fTestName := aTestName;
    try
      Inc(fTestsCount);
      Inc(fTestIndex);

      result := aResult;
      if IsAborted then
        result := rsSkip;

      case result of
        rsFail  : Inc(fTestsFailed);
        rsPass  : Inc(fTestsPassed);
        rsSkip  : Inc(fTestsSkipped);
        rsError : Inc(fTestsError);
      end;

      testName := fTestName;
      if testName = '' then
        testName := CurrentTestName;

      fResults.Add(TTestResult.Create(testName, fTypeName, fMethodName, fTestIndex, fExpectedResult, result, aReason));

      case result of
        rsFail  : if aReason = '' then
                    WriteLn(testName + ': FAILED')
                  else
                    WriteLn(testName + ': FAILED  [' + aReason + ']');

        rsPass  : WriteLn(testName + ': PASSED');

        rsSkip  : WriteLn(testName + ': skipped');

        rsError : // Handled specifically in TestError
      end;

    finally
      fTestName             := '';
      fExpectedResult       := rsPass;
      fExpectedErrorClass   := NIL;
      fExpectedErrorMessage := '';
    end;
  end;


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

    fStartTime := Now;
    fIsRunning := TRUE;
  end;


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
      else
      begin
        Inc(fTestsFailed);
        result.State := rsFail;
      end;
    end;
  end;


  procedure TTestRun.Complete;
  begin
    if fIsFinished then
    begin
      WriteLn('WARNING: Attempt to call TestRun.Complete multiple times (First call terminated the run)');
      EXIT;
    end;

    fIsFinished := TRUE;
    fFinishTime := Now;

    CheckExpectedStates;

    WriteLn(Format('Total Tests = %d, Passed = %d, Failed = %d, Skipped = %d, Errors = %d', [fTestsCount, fTestsPassed, fTestsFailed, fTestsSkipped, fTestsError]));

    try
      SaveResults;

    finally
      if HasCmdLineOption('wait') then
        ReadLn;

      if (fTestsFailed + fTestsError > 0) then
        ExitCode := 1;
    end;
  end;


  procedure TTestRun.ExpectingError(const aExceptionClass: TClass;
                                    const aMessage: String);
  begin
    fExpectedResult       := rsError;
    fExpectedErrorClass   := aExceptionClass;
    fExpectedErrorMessage := aMessage;
  end;


  procedure TTestRun.ExpectingToFail;
  begin
    fExpectedResult := rsFail;
  end;


  function TTestRun.get_CurrentTestName: String;
  begin
    result := fTestName;
    if result = '' then
      result := fMethodName;

    if result = '' then
      result := fTypeName;

    if fTestNamePrefix <> '' then
      result := fTestNamePrefix + '.' + result;

    if (fTestName = '') then
      result := result + ' test ' + IntToStr(fTestIndex);
  end;


  function TTestRun.get_Failed: Boolean;
  begin
    result := (fTestsFailed + fTestsError) > 0;
  end;


  function TTestRun.get_FinishTime: TDateTime;
  begin
    if NOT fIsFinished then
      raise Exception.Create('Test run has not yet finished');

    result := fFinishTime;
  end;


  function TTestRun.get_Result(const aIndex: Integer): TTestResult;
  begin
    result := TTestResult(fResults[aIndex]);
  end;


  function TTestRun.get_ResultCount: Integer;
  begin
    result := fResults.Count;
  end;


  function TTestRun.get_RunTime: Integer;
  var
    finish: TDateTime;
  begin
    if fIsFinished then
      finish := FinishTime
    else
      finish := Now;

    result := Round((finish - fStartTime) * 24 * 60 * 60);
  end;


  procedure TTestRun.SetTestType(const aTypeName: String);
  begin
    fTypeName := aTypeName;
  end;


  procedure TTestRun.set_Environment(const aValue: String);
  begin
    if fIsRunning then
      WriteLn('WARNING: Ignored attempt to change TestRun.Environment during test run')
    else if fIsFinished then
      WriteLn('WARNING: Ignored attempt to change TestRun.Environment after test run completion')
    else
      fEnvironment := aValue;
  end;


  procedure TTestRun.set_Name(const aValue: String);
  begin
    if fIsRunning then
      WriteLn('WARNING: Ignored attempt to change TestRun.Name during test run')
    else if fIsFinished then
      WriteLn('WARNING: Ignored attempt to change TestRun.Name after test run completion')
    else
      fName := aValue;
  end;


  procedure TTestRun.SetTestNamePrefix(const aPrefix: String);
  begin
    fTestNamePrefix := aPrefix;
  end;


  procedure TTestRun.SaveResults;
  var
    i: Integer;
    filename: String;
  begin
    for i := 0 to Pred(fWriters.Count) do
      try
        if HasCmdLineOption(fWriters[i], filename) then
        begin
          TResultsWriter(fWriters.Objects[i]).SaveResults(TestRun, filename);
          WriteLn(Format('%s results written to %s', [fWriters[i], filename]));
        end;

      except
        on e: Exception do
          WriteLn(Format('ERROR: Failed to write %s results to %s (%s: %s)', [fWriters[i], filename, e.ClassName, e.Message]));
      end;
  end;


  procedure TTestRun.SetTestMethod(const aMethodName: String);
  begin
    fMethodName := aMethodName;
    fTestIndex  := 0;
  end;


  procedure TTestRun.TestError(const aException: Exception);
  begin
    if (fExpectedErrorClass = aException.ClassType)
     and (fExpectedErrorMessage = aException.Message) then
    begin
      AddResult('', rsError, Format('Threw expected exception [%s: %s]', [aException.ClassName, aException.Message]));
      WriteLn(Format('%s threw expected exception [%s: %s]', [CurrentTestName, aException.ClassName, aException.Message]));
    end
    else
    begin
      AddResult('', rsError, Format('%s: %s', [aException.ClassName, aException.Message]));
      WriteLn(Format('ERROR: %s threw %s: %s', [CurrentTestName, aException.ClassName, aException.Message]));
    end;
  end;



  procedure TTestRun.TestFailed(const aTest: String;
                                const aReason: String);
  begin
    AddResult(aTest, rsFail, aReason);
  end;



  procedure TTestRun.TestPassed(const aTest: String);
  begin
    AddResult(aTest, rsPass, '');
  end;


  function TTestRun.HasCmdLineOption(const aName: String): Boolean;
  var
    notUsed: String;
  begin
    result := HasCmdLineOption(aName, notUsed);
  end;


  function TTestRun.HasCmdLineOption(const aName: String;
                                     var aValue: String): Boolean;
  var
    i: Integer;
    s: String;
  begin
    result  := FALSE;
    aValue  := '';

    for i := 1 to ParamCount do
    begin
      s := ParamStr(i);
      if s[1] <> '-' then
        CONTINUE;

      Delete(s, 1, 1);
      if NOT SameText(Copy(s, 1, Length(aName)), aName) then
        CONTINUE;

      Delete(s, 1, Length(aName));
      result := (s = '') or (ANSIChar(s[1]) in [':', '=']);
      if NOT result then
        CONTINUE;

      if s = '' then
        EXIT;

      Delete(s, 1, 1);
      aValue := s;
      EXIT;
    end;
  end;


  procedure TTestRun.Execute(const aTest: TTestClass;
                             const aNamePrefix: String);
  var
    i: Integer;
    test: TTest;
    methods: TStringList;
    method: procedure of object;
  begin
    if IsFinished then
    begin
      WriteLn('WARNING: Methods in test class %s not performed as TestRun has already finished');
      EXIT;
    end;

    if NOT IsRunning then
      BeginRun;

    test    := aTest.Create;
    methods := TStringList.Create;
    try
      SetTestType(test.ClassName);
      SetTestNamePrefix(aNamePrefix);

      test.GetTestMethods(methods);

      for i := 0 to Pred(methods.Count) do
      begin
        SetTestMethod(methods[i]);

        TMethod(method).Data := test;
        TMethod(method).Code := test.MethodAddress(methods[i]);
        try
          try
            method;

          except
            on e: Exception do
              TestError(e);
          end;

        finally
          SetTestMethod('');
        end;
      end;

    finally
      methods.Free;
      test.Free;
    end;
  end;


  procedure TTestRun.Execute(const aTests: TTestArray;
                             const aNamePrefix: String);
  var
    i: Integer;
  begin
    for i := 0 to High(aTests) do
      Execute(aTests[i], aNamePrefix);
  end;







initialization
  TestRun := TTestRun.Create;

finalization
  if Assigned(TestRun) and NOT TestRun.IsFinished then
    TestRun.Complete;

end.
