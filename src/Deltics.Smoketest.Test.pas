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

  unit Deltics.Smoketest.Test;


interface

  uses
  {$ifdef DELPHI2010__}
    RTTI,
  {$endif}
    Classes,
    Deltics.Smoketest.Assertions.Integers,
    Deltics.Smoketest.Assertions.AnsiStrings,
    Deltics.Smoketest.Assertions.UnicodeStrings,
    Deltics.Smoketest.Assertions.WideStrings,
    Deltics.Smoketest.Utils;

  type
    {$M+}
    TTest = class
    private
      fDefaultTestName: String;
      function get_DefaultTestName: String;
    protected
      procedure AbortTestRun;
      function Assert(const aTest: String; const aResult: Boolean; const aReason: String = ''): Boolean; overload;
      function Assert(const aValue: Integer): IntegerAssertions; overload;
      function Assert(const aTestName: String; const aValue: Integer): IntegerAssertions; overload;
      function Assert(const aValue: AnsiString): AnsiStringAssertions; overload;
      function Assert(const aTestName: String; const aValue: AnsiString): AnsiStringAssertions; overload;
      function Assert(const aValue: WideString): WideStringAssertions; overload;
      function Assert(const aTestName: String; const aValue: WideString): WideStringAssertions; overload;
    {$ifdef UNICODE}
      function Assert(const aValue: UnicodeString): UnicodeStringAssertions; overload;
      function Assert(const aTestName: String; const aValue: UnicodeString): UnicodeStringAssertions; overload;
    {$endif}
      function AssertBaseException(const aExceptionBaseClass: TClass; const aExceptionMessage: String = ''): Boolean;
      function AssertException(const aExceptionClass: TClass; const aExceptionMessage: String = ''): Boolean;
      function AssertNoException(const aTestName: String = ''): Boolean;
      procedure GetTestMethods(var aList: TStringList);
      property DefaultTestName: String read get_DefaultTestName write fDefaultTestName;
    end;
    {$M-}
    TTestClass = class of TTest;


  const
    METHOD_NAME = '{methodName}';
    TEST_NAME   = '{testName}';



implementation

  uses
  {$ifdef DELPHI2006__}
    {$ifNdef DELPHI2010__}
      Windows,
    {$endif}
  {$endif}
    SysUtils,
    TypInfo,
    Deltics.Smoketest.TestResult,
    Deltics.Smoketest.TestRun;


  // Test classes have privileged access to protected members of the TestRun
  //  in order to record test completion and other details.
  type
    TTestRunHelper = class(TTestRun);

  // For convenience we'll keep a ready-reference to the type-cast TestRun
  var
    TestRun: TTestRunHelper;


  const
    NO_NAME = '';



{ TTest ------------------------------------------------------------------------------------------ }

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TTest.get_DefaultTestName: String;
  begin
    result := fDefaultTestName;
    if result = '' then
      result := TestRun.DefaultTestName;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
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
  function TTest.Assert(const aValue: Integer): IntegerAssertions;
  begin
    result := TIntegerAssertions.Create(DefaultTestName, aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TTest.Assert(const aTestName: String;
                        const aValue: Integer): IntegerAssertions;
  begin
    result := TIntegerAssertions.Create(aTestName, aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TTest.Assert(const aValue: AnsiString): AnsiStringAssertions;
  begin
    result := TAnsiStringAssertions.Create(DefaultTestName, aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TTest.Assert(const aTestName: String;
                        const aValue: AnsiString): AnsiStringAssertions;
  begin
    result := TAnsiStringAssertions.Create(aTestName, aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TTest.Assert(const aValue: WideString): WideStringAssertions;
  begin
    result := TWideStringAssertions.Create(DefaultTestName, aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TTest.Assert(const aTestName: String;
                        const aValue: WideString): WideStringAssertions;
  begin
    result := TWideStringAssertions.Create(aTestName, aValue);
  end;


{$ifdef UNICODE}

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TTest.Assert(const aValue: UnicodeString): UnicodeStringAssertions;
  begin
    result := TUnicodeStringAssertions.Create(DefaultTestName, aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TTest.Assert(const aTestName: String;
                        const aValue: UnicodeString): UnicodeStringAssertions;
  begin
    result := TUnicodeStringAssertions.Create(aTestName, aValue);
  end;

{$endif}


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TTest.AssertBaseException(const aExceptionBaseClass: TClass;
                                     const aExceptionMessage: String): Boolean;
  begin
    result := TestRun.TestException(aExceptionBaseClass, TRUE, aExceptionMessage);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TTest.AssertException(const aExceptionClass: TClass;
                                 const aExceptionMessage: String): Boolean;
  begin
    result := TestRun.TestException(aExceptionClass, FALSE, aExceptionMessage);
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




initialization
  // Initialise the local reference to the TestRun typecast to the helper
  //  type to provide access to protected members of the TestRun

  TestRun := TTestRunHelper(Deltics.Smoketest.TestRun.TestRun);
end.
