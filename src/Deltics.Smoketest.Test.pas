
{$i Deltics.Smoketest.inc}

  unit Deltics.Smoketest.Test;

interface

  uses
  {$ifdef DELPHI2010__}
    RTTI,
  {$endif}
    Classes,
    Deltics.Smoketest.Assertions,
    Deltics.Smoketest.Utils;

  type
    {$M+}
    TTest = class
    protected
      procedure AbortTestRun;
      function Assert(const aTest: String; const aResult: Boolean; const aReason: String = ''): Boolean; overload;
      function Assert(const aTestName: String; const aValue: Integer): IntegerAssertions; overload;
      function Assert(const aTestName: String; const aValue: AnsiString): AnsiStringAssertions; overload;
      function Assert(const aTestName: String; const aValue: WideString): WideStringAssertions; overload;
    {$ifdef UNICODE}
      function Assert(const aTestName: String; const aValue: UnicodeString): UnicodeStringAssertions; overload;
    {$endif}
      function AssertBaseException(const aExceptionBaseClass: TClass; const aTestName: String = ''): Boolean;
      function AssertException(const aExceptionClass: TClass; const aTestName: String = ''): Boolean;
      function AssertNoException(const aTestName: String = ''): Boolean;
    public
      procedure GetTestMethods(var aList: TStringList);
    end;
    {$M-}
    TTestClass = class of TTest;


    TSelfTest = class(TTest)
    protected
      procedure ExpectingException(const aExceptionClass: TClass; const aExceptionMessage: String);
      procedure NextAssertExpectedToFail;
    end;


implementation

  uses
    SysUtils,
    TypInfo,
    Deltics.Smoketest.TestRun;


  // Test classes have privileged access to protected members of the TestRun
  //  in order to record test completion and other details.
  type
    TTestRunHelper = class(TTestRun);

  // For convenience we'll keep a ready-reference to the type-cast TestRun
  var
    TestRun: TTestRunHelper;



{ TTest ------------------------------------------------------------------------------------------ }

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TTest.AbortTestRun;
  begin
    TestRun.Abort;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
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


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TTest.Assert(const aTestName: String;
                        const aValue: Integer): IntegerAssertions;
  begin
    result := TIntegerAssertions.Create(aTestName, aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TTest.Assert(const aTestName: String;
                        const aValue: AnsiString): AnsiStringAssertions;
  begin
    result := TAnsiStringAssertions.Create(aTestName, aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TTest.Assert(const aTestName: String;
                        const aValue: WideString): WideStringAssertions;
  begin
    result := TWideStringAssertions.Create(aTestName, aValue);
  end;


{$ifdef UNICODE}

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TTest.Assert(const aTestName: String;
                        const aValue: UnicodeString): UnicodeStringAssertions;
  begin
    result := TUnicodeStringAssertions.Create(aTestName, aValue);
  end;

{$endif}


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TTest.AssertBaseException(const aExceptionBaseClass: TClass;
                                     const aTestName: String): Boolean;
  var
    e: TObject;
    testName: String;
  begin
    result   := FALSE;
    testName := aTestName;

    if testName = '' then
      testName := 'Raised ' + aExceptionBaseClass.ClassName;

    e := ExceptObject;
    if NOT Assigned(e) then
    begin
      TestRun.TestFailed(testName, 'No exception raised');
      EXIT;
    end;

    result := (e is aExceptionBaseClass);
    if result then
      TestRun.TestPassed(testName)
    else
      TestRun.TestFailed(testName, 'Unexpected exception: ' + e.ClassName);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TTest.AssertException(const aExceptionClass: TClass;
                                 const aTestName: String): Boolean;
  var
    e: TObject;
    testName: String;
  begin
    result := FALSE;

    testName := aTestName;

    if testName = '' then
      testName := 'Raised ' + aExceptionClass.ClassName;

    e := ExceptObject;
    if NOT Assigned(e) then
    begin
      TestRun.TestFailed(testName, 'No exception raised');
      EXIT;
    end;

    result := (e.ClassType = aExceptionClass);
    if result then
      TestRun.TestPassed(testName)
    else
      TestRun.TestFailed(testName, 'Unexpected exception: ' + e.ClassName);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TTest.AssertNoException(const aTestName: String): Boolean;
  var
    eo: TObject;
    e: Exception absolute eo;
    testName: String;
    msg: String;
  begin
    eo := ExceptObject;

    if testName = '' then
      testName := 'No exception raised';

    result := NOT Assigned(eo);
    if result then
    begin
      TestRun.TestPassed(testName);
      EXIT;
    end;

    msg := Format('No exception was expected but %s was raised', [eo.ClassName]);
    if e is Exception then
      msg := msg + Format(' with message %s', [e.Message]);

    TestRun.TestFailed(testName, msg);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TTest.GetTestMethods(var aList: TStringList);
  {
    Sets the contents of a supplied stringlist to the list of published
     methods on the class.

    Uses new RTTI in Delphi 2010 onwards, otherwise uses helper methods
     in the Smoketest.Utils unit.
  }
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



{ TSelfTest -------------------------------------------------------------------------------------- }

  procedure TSelfTest.ExpectingException(const aExceptionClass: TClass;
                                         const aExceptionMessage: String);
  begin
    TestRun.ExpectingException(aExceptionClass, aExceptionMessage);
  end;


  procedure TSelfTest.NextAssertExpectedToFail;
  begin
    TestRun.ExpectingToFail;
  end;



initialization
  // Initialise the local reference to the TestRun typecast to the helper
  //  type to provide access to protected members of the TestRun

  TestRun := TTestRunHelper(Deltics.Smoketest.TestRun.TestRun);
end.
