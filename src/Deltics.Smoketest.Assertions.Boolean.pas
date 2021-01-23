{
  * MIT LICENSE *

  Copyright © 2020 Jolyon Smith

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

  unit Deltics.Smoketest.Assertions.Boolean;


interface

  uses
    Deltics.Smoketest.Assertions;


  type
    BooleanAssertions = interface
    ['{B9DA5757-8980-4001-BDD8-89098F331E07}']
      function Equals(const aExpected: Boolean): AssertionResult;
      function IsFalse: AssertionResult;
      function IsTrue: AssertionResult;
    end;


    TBooleanAssertions = class(TAssertions, BooleanAssertions)
    private
      fValue: Boolean;
      function Equals(const aExpected: Boolean): AssertionResult; reintroduce;
      function IsFalse: AssertionResult;
      function IsTrue: AssertionResult;
    public
      constructor Create(const aTestName: String; aValue: Boolean);
      procedure BeforeDestruction; override;
    end;


implementation

  uses
    SysUtils,
    Deltics.Smoketest.TestRun;


  const
    BoolStr: array[FALSE..TRUE] of String = ('false', 'true');


  type
    TTestRunHelper = class(Deltics.Smoketest.TestRun.TTestRun);

  var TestRun: TTestRunHelper;





{ TBooleanAssertions ----------------------------------------------------------------------------- }

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  constructor TBooleanAssertions.Create(const aTestName: String;
                                              aValue: Boolean);
  begin
    inherited Create(aTestName, BoolStr[aValue]);

    fValue := aValue;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TBooleanAssertions.BeforeDestruction;
  begin
    if NOT Assigned(TestResult) then
    begin
      if fValue then
        TestRun.TestPassed(Description)
      else
        TestRun.TestFailed(Description, Failure);
    end;

    inherited;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TBooleanAssertions.Equals(const aExpected: Boolean): AssertionResult;
  begin
    FormatExpected(BoolStr[aExpected]);

    Description := Format('{valueName} = {expected}');
    Failure     := Format('{valueWithName} does not = {expected}');

    result := Assert(fValue = aExpected);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TBooleanAssertions.IsFalse: AssertionResult;
  begin
    Description := Format('{valueWithName} is false');
    Failure     := Format('{valueWithName} is not false');

    result := Assert(fValue = FALSE);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TBooleanAssertions.IsTrue: AssertionResult;
  begin
    Description := Format('{valueWithName} is true');
    Failure     := Format('{valueWithName} is not true');

    result := Assert(fValue = TRUE);
  end;



initialization
  TestRun := TTestRunHelper(Deltics.Smoketest.TestRun.TestRun);
end.
