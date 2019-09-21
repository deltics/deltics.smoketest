
{$i Deltics.Continuity.inc}

  unit Deltics.Continuity.Test;

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
    Deltics.Continuity.TestRun,
    Deltics.Continuity.Utils;


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
  TestRun := TTestRunHelper(Deltics.Continuity.TestRun.TestRun);
end.
