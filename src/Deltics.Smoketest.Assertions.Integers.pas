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

  unit Deltics.Smoketest.Assertions.Integers;


interface

  uses
    Deltics.Smoketest.Assertions;


  type
    IntegerAssertions = interface
    ['{46F67D92-BD65-4D8D-B9B6-65203BC1DF41}']
      function Equals(const aExpected: Integer): AssertionResult;
      function GreaterThan(const aExpected: Integer): AssertionResult;
      function GreaterThanOrEquals(const aExpected: Integer): AssertionResult;
      function LessThan(const aExpected: Integer): AssertionResult;
      function LessThanOrEquals(const aExpected: Integer): AssertionResult;
      function Between(const aLowerBound, aUpperBound: Integer): AssertionResult;
      function InRange(const aMin, aMax: Integer): AssertionResult;
      function IsNegative: AssertionResult;
      function IsPositive: AssertionResult;
    end;


    TIntegerAssertions = class(TAssertions, IntegerAssertions)
    private
      fValue: Integer;
      function Equals(const aExpected: Integer): AssertionResult; reintroduce;
      function GreaterThan(const aExpected: Integer): AssertionResult;
      function GreaterThanOrEquals(const aExpected: Integer): AssertionResult;
      function LessThan(const aExpected: Integer): AssertionResult;
      function LessThanOrEquals(const aExpected: Integer): AssertionResult;
      function Between(const aLowerBound, aUpperBound: Integer): AssertionResult;
      function InRange(const aMin, aMax: Integer): AssertionResult;
      function IsNegative: AssertionResult;
      function IsPositive: AssertionResult;
    public
      constructor Create(const aTestName: String; aValue: Integer);
    end;


implementation

  uses
    SysUtils;


  procedure Swap(var a, b: Integer);
  begin
    a := a + b;
    b := a - b;
    a := a - b;
  end;


{ TIntegerAssertions ----------------------------------------------------------------------------- }

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  constructor TIntegerAssertions.Create(const aTestName: String;
                                              aValue: Integer);
  begin
    inherited Create(aTestName, IntToStr(aValue));

    fValue := aValue;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TIntegerAssertions.Between(const aLowerBound, aUpperBound: Integer): AssertionResult;
  var
    lbound, ubound: Integer;
  begin
    if Abs(aLowerBound - aUpperBound) < 2 then
      raise EInvalidTest.CreateFmt('Invalid lower (%d) and upper (%d) bounds to Assert(Integer).Between.  There must be a difference greater than 1 between the lower and upper bounds.', [aLowerBound, aUpperBound]);

    lbound := aLowerBound;
    ubound := aUpperBound;
    if lbound > ubound then
      Swap(lbound, ubound);

    Description := Format('%d between %d and %d (excl.)', [fValue, aLowerBound, aUpperBound]);
    Failure     := Format('%d is not between %d and %d (excl.)', [fValue, aLowerBound, aUpperBound]);

    result := Assert((fValue > lbound) and (fValue < ubound));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TIntegerAssertions.Equals(const aExpected: Integer): AssertionResult;
  begin
    Description := Format('%d = %d', [fValue, aExpected]);
    Failure     := Format('%d was expected to be %d', [fValue, aExpected]);

    result := Assert(fValue = aExpected);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TIntegerAssertions.GreaterThan(const aExpected: Integer): AssertionResult;
  begin
    Description := Format('%d > %d', [fValue, aExpected]);
    Failure     := Format('%d is not > %d', [fValue, aExpected]);

    result := Assert(fValue > aExpected);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TIntegerAssertions.GreaterThanOrEquals(const aExpected: Integer): AssertionResult;
  begin
    Description := Format('%d >= %d', [fValue, aExpected]);
    Failure     := Format('%d is not >= %d', [fValue, aExpected]);

    result := Assert(fValue >= aExpected);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TIntegerAssertions.LessThan(const aExpected: Integer): AssertionResult;
  begin
    Description := Format('%d < %d', [fValue, aExpected]);
    Failure     := Format('%d is not < %d', [fValue, aExpected]);

    result := Assert(fValue < aExpected);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TIntegerAssertions.LessThanOrEquals(const aExpected: Integer): AssertionResult;
  begin
    Description := Format('%d <= %d', [fValue, aExpected]);
    Failure     := Format('%d is not <= %d', [fValue, aExpected]);

    result := Assert(fValue <= aExpected);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TIntegerAssertions.InRange(const aMin, aMax: Integer): AssertionResult;
  var
    min, max: Integer;
  begin
    if aMin = aMax then
      raise EInvalidTest.CreateFmt('Min (%d) and Max (%d) bounds to Assert(Integer).InRange are equal.  Did you mean to use Assert.Equals() ?', [aMin, aMax]);

    min := aMin;
    max := aMax;
    if min > max then
      Swap(min, max);

    Description := Format('%d is in the range %d .. %d (incl.)', [fValue, aMin, aMax]);
    Failure     := Format('%d is not in the range %d .. %d (incl.)', [fValue, aMin, aMax]);

    result := Assert((fValue >= min) and (fValue <= max));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TIntegerAssertions.IsNegative: AssertionResult;
  begin
    Description := Format('%d is negative (< 0)', [fValue]);
    Failure     := Format('%d is not negative (< 0)', [fValue]);

    result := Assert(fValue < 0);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TIntegerAssertions.IsPositive: AssertionResult;
  begin
    Description := Format('%d is positive (> 0)', [fValue]);
    Failure     := Format('%d is not positive (> 0)', [fValue]);

    result := Assert(fValue > 0);
  end;




end.
