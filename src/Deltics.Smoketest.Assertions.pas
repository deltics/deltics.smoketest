{
  * MIT LICENSE *

  Copyright � 2019 Jolyon Smith

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

  unit Deltics.Smoketest.Assertions;


interface

  uses
    Deltics.Smoketest.TestResult,
    Deltics.Smoketest.Utils;


  type
  {$ifNdef UNICODE}
    AnsiString = Deltics.Smoketest.Utils.AnsiString;
    UnicodeString = Deltics.Smoketest.Utils.UnicodeString;
  {$endif}


    EInvalidTest = Deltics.Smoketest.Utils.EInvalidTest;


    AssertionResult = interface
    ['{86F9B5C1-FA31-416A-84FE-FFD21BCE7BBA}']
      function get_Failed: Boolean;
      function get_Passed: Boolean;
      function WithFailureReason(const aReason: String): AssertionResult; overload;
      function WithFailureReason(const aReason: String; aArgs: array of const): AssertionResult; overload;
      property Failed: Boolean read get_Failed;
      property Passed: Boolean read get_Passed;
    end;


    TAssertions = class(TInterfacedObject, AssertionResult)
    private
      fTestName: String;
      fTestResult: TTestResult;
      fTestValue: String;
      fDescription: String;
      fFailure: String;
    private // AssertionResult
      function get_Failed: Boolean;
      function get_Passed: Boolean;
      function WithFailureReason(const aReason: String): AssertionResult; overload;
      function WithFailureReason(const aReason: String; aArgs: array of const): AssertionResult; overload;
    protected
      function Assert(const aResult: Boolean): AssertionResult; overload;
      function Assert(const aResult: Boolean; const aMessage: String): AssertionResult; overload;
      function Assert(const aResult: Boolean; const aMessage: String; aArgs: array of const): AssertionResult; overload;
      property Description: String write fDescription;
      property Failure: String write fFailure;
    public
      constructor Create(const aTestName: String; const aValueAsString: String);
    end;



implementation

  uses
    SysUtils,
    Deltics.Smoketest.TestRun;


  type
    TTestRunHelper = class(Deltics.Smoketest.TestRun.TTestRun);

  var TestRun: TTestRunHelper;


{ TFluentAssertions ------------------------------------------------------------------------------ }

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  constructor TAssertions.Create(const aTestName: String;
                                 const aValueAsString: String);
  begin
    inherited Create;

    fTestName   := aTestName;
    fTestValue  := aValueAsString;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TAssertions.get_Failed: Boolean;
  begin
    result := (fTestResult.State = rsFail);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TAssertions.get_Passed: Boolean;
  begin
    result := (fTestResult.State = rsPass);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TAssertions.Assert(const aResult: Boolean): AssertionResult;
  var
    testName: String;
  begin
    result := self;

    if fTestName <> '' then
      testName := fTestName + ' [' + fDescription + ']'
    else
      testName := fDescription;

    if aResult then
      fTestResult := TestRun.TestPassed(testName)
    else
      fTestResult := TestRun.TestFailed(testName, fFailure);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TAssertions.Assert(const aResult: Boolean;
                              const aMessage: String): AssertionResult;
  begin
    result := self;

    if aResult then
      fTestResult := TestRun.TestPassed(fTestName)
    else
      fTestResult := TestRun.TestFailed(fTestName, aMessage);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TAssertions.Assert(const aResult: Boolean;
                                       const aMessage: String;
                                             aArgs: array of const): AssertionResult;
  begin
    result := Assert(aResult, Format(aMessage, aArgs));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TAssertions.WithFailureReason(const aReason: String;
                                               aArgs: array of const): AssertionResult;
  begin
    result := WithFailureReason(Format(aReason, aArgs));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TAssertions.WithFailureReason(const aReason: String): AssertionResult;
  begin
    fTestResult.ErrorMessage := aReason;
  end;



initialization
  TestRun := TTestRunHelper(Deltics.Smoketest.TestRun.TestRun);
end.