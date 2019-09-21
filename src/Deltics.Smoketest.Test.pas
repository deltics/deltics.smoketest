
{$i Deltics.Smoketest.inc}

  unit Deltics.Smoketest.Test;

interface

  uses
  {$ifdef DELPHI2010__}
    RTTI,
  {$endif}
    Classes;

  type
    {$M+}
    TTest = class
    protected
      procedure AbortTestRun;
      function Assert(const aTest: String; const aResult: Boolean; const aReason: String = ''): Boolean;
      function AssertException(const aExceptionClass: TClass; const aMessage: String = ''; const aTestName: String = ''): Boolean;
    public
      procedure GetTestMethods(var aList: TStringList);
    end;
    {$M-}
    TTestClass = class of TTest;

    TTestArray = array of TTestClass;


implementation

{ TTest }

  uses
    SysUtils,
    TypInfo,
    Deltics.Smoketest.TestRun,
    Deltics.Smoketest.Utils;


  type
    TTestRunHelper = class(TTestRun);

  var
    TestRun: TTestRunHelper;



  procedure TTest.AbortTestRun;
  begin
    TestRun.Abort;
  end;


  function TTest.Assert(const aTest: String;
                        const aResult: Boolean;
                        const aReason: String): Boolean;
  begin
    result := aResult;
    if result then
      TestRun.TestPassed(aTest)
    else
      TestRun.TestFailed(aTest, aReason);
  end;


  function TTest.AssertException(const aExceptionClass: TClass;
                                 const aMessage: String;
                                 const aTestName: String): Boolean;
  var
    exceptionObject: TObject;
    e: Exception;
    testName: String;
  begin
    result := FALSE;

    testName := aTestName;

    if testName = '' then
    begin
      testName := 'Raised ' + aExceptionClass.ClassName;
      if aMessage <> '' then
        testName := testName + ' [' + aMessage + ']';
    end;

    exceptionObject := ExceptObject;
    if NOT Assigned(exceptionObject) then
    begin
      TestRun.TestFailed(testName, 'No exception raised');
      EXIT;
    end;

    e := NIL;

    if exceptionObject is Exception then
      e := Exception(exceptionObject);

    if ExceptObject.ClassType <> aExceptionClass then
    begin
      if Assigned(e) then
        TestRun.TestFailed(testName, 'Unexpected exception: ' + ExceptObject.ClassName + ' [' + e.Message + ']')
      else
        TestRun.TestFailed(testName, 'Unexpected exception: ' + ExceptObject.ClassName);
    end
    else if Assigned(e) and NOT SameText(e.Message, aMessage) then
      TestRun.TestFailed(testName, e.ClassName + ' raised but with unexpected message [' + e.Message + ']')
    else
    begin
      TestRun.TestPassed(testName);
      result := TRUE;
    end;
  end;


  procedure TTest.GetTestMethods(var aList: TStringList);
{$ifdef DELPHI2010__}
  var
    i: Integer;
    ctx: TRTTIContext;
    methods: TArray<TRTTIMethod>;
  begin
    methods := ctx.GetType(self.ClassType).GetMethods;

    aList.Clear;

    for i := 0 to Pred(Length(methods)) do
      if methods[i].Visibility = mvPublished then
        aList.Add(methods[i].Name);
  end;
{$else}
  var
    i: Integer;
    method: PPublishedMethod;
    methodCount: Integer;
  begin
    inherited;

    // Set the length of the array of names to accomodate all published
    //  methods in the specified class
    methodCount := GetPublishedMethodCount(self.ClassType);
    if methodCount = 0 then
      EXIT;

    aList.Clear;
    aList.Capacity := methodCount;

    // Get the first method name into the 0'th element of the array
    method := GetFirstPublishedMethod(self.ClassType);
    aList.Add(String(method.Name));

    // Now get any more method names and place them in the array in turn
    for i := 1 to Pred(methodCount) do
    begin
      method := GetNextPublishedMethod(method);
      aList.Add(String(method.Name));
    end;
  end;
{$endif}


initialization
  TestRun := TTestRunHelper(Deltics.Smoketest.TestRun.TestRun);
end.
