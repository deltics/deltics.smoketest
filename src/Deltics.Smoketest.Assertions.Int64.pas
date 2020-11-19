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

  unit Deltics.Smoketest.Assertions.Int64;


interface

  uses
    Deltics.Smoketest.Assertions;


  type
    Int64Assertions = interface
    ['{46F67D92-BD65-4D8D-B9B6-65203BC1DF41}']
      function Equals(const aExpected: Int64): AssertionResult;
      function GreaterThan(const aExpected: Int64): AssertionResult;
      function GreaterThanOrEquals(const aExpected: Int64): AssertionResult;
      function LessThan(const aExpected: Int64): AssertionResult;
      function LessThanOrEquals(const aExpected: Int64): AssertionResult;
      function Between(const aLowerBound, aUpperBound: Int64): AssertionResult;
      function InRange(const aMin, aMax: Int64): AssertionResult;
      function IsNegative: AssertionResult;
      function IsPositive: AssertionResult;
    end;


    TInt64Assertions = class(TAssertions, Int64Assertions)
    private
      fValue: Int64;
      function Equals(const aExpected: Int64): AssertionResult; reintroduce;
      function GreaterThan(const aLimit: Int64): AssertionResult;
      function GreaterThanOrEquals(const aMin: Int64): AssertionResult;
      function LessThan(const aLimit: Int64): AssertionResult;
      function LessThanOrEquals(const aMax: Int64): AssertionResult;
      function Between(const aLowerBound, aUpperBound: Int64): AssertionResult;
      function InRange(const aMin, aMax: Int64): AssertionResult;
      function IsNegative: AssertionResult;
      function IsPositive: AssertionResult;
    public
      constructor Create(const aTestName: String; aValue: Int64);
    end;


implementation

  uses
    SysUtils;


  procedure Swap(var a, b: Int64);
  begin
    a := a + b;
    b := a - b;
    a := a - b;
  end;


{ TInt64Assertions ----------------------------------------------------------------------------- }

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  constructor TInt64Assertions.Create(const aTestName: String;
                                              aValue: Int64);
  begin
    inherited Create(aTestName, IntToStr(aValue));

    fValue := aValue;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TInt64Assertions.Between(const aLowerBound, aUpperBound: Int64): AssertionResult;
  var
    lbound, ubound: Int64;
  begin
    if Abs(aLowerBound - aUpperBound) < 2 then
      raise EInvalidTest.CreateFmt('Invalid lower (%d) and upper (%d) bounds to Assert(Int64).Between.  There must be a difference greater than 1 between the lower and upper bounds.', [aLowerBound, aUpperBound]);

    lbound := aLowerBound;
    ubound := aUpperBound;
    if lbound > ubound then
      Swap(lbound, ubound);

    FormatToken('lowerBound', IntToStr(lbound));
    FormatToken('upperBound', IntToStr(ubound));

    Description := Format('{valueWithName} is between {lowerBound} and {upperBound} (excl.)');
    Failure     := Format('{valueWithName} is not between {lowerBound} and {upperBound} (excl.)');

    result := Assert((fValue > lbound) and (fValue < ubound));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TInt64Assertions.Equals(const aExpected: Int64): AssertionResult;
  begin
    FormatExpected(IntToStr(aExpected));

    Description := Format('{valueName} = {expected}');
    Failure     := Format('{valueWithName} does not = {expected}');

    result := Assert(fValue = aExpected);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TInt64Assertions.GreaterThan(const aLimit: Int64): AssertionResult;
  begin
    FormatToken('limit', IntToStr(aLimit));

    Description := Format('{valueWithName} > {limit}');
    Failure     := Format('{valueWithName} is not > {limit}');

    result := Assert(fValue > aLimit);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TInt64Assertions.GreaterThanOrEquals(const aMin: Int64): AssertionResult;
  begin
    FormatToken('min', IntToStr(aMin));

    Description := Format('{valueWithName} >= {min}');
    Failure     := Format('{valueWithName} is not >= {min}');

    result := Assert(fValue >= aMin);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TInt64Assertions.LessThan(const aLimit: Int64): AssertionResult;
  begin
    FormatToken('limit', IntToStr(aLimit));

    Description := Format('{valueWithName} < {limit}');
    Failure     := Format('{valueWithName} is not < {limit}');

    result := Assert(fValue < aLimit);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TInt64Assertions.LessThanOrEquals(const aMax: Int64): AssertionResult;
  begin
    FormatToken('max', IntToStr(aMax));

    Description := Format('{valueWithName} <= {max}');
    Failure     := Format('{valueWithName} is not <= {max}');

    result := Assert(fValue <= aMax);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TInt64Assertions.InRange(const aMin, aMax: Int64): AssertionResult;
  var
    min, max: Int64;
  begin
    if aMin = aMax then
      raise EInvalidTest.CreateFmt('Min (%d) and Max (%d) bounds to Assert(Int64).InRange are equal.  Did you mean to use Assert.Equals() ?', [aMin, aMax]);

    min := aMin;
    max := aMax;
    if min > max then
      Swap(min, max);

    FormatToken('min', IntToStr(min));
    FormatToken('max', IntToStr(max));

    Description := Format('{valueWithName} is in the range {min} .. {max} (incl.)');
    Failure     := Format('{valueWithName} is not in the range {min} .. {max} (incl.)');

    result := Assert((fValue >= min) and (fValue <= max));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TInt64Assertions.IsNegative: AssertionResult;
  begin
    Description := Format('{valueWithName} is negative (< 0)');
    Failure     := Format('{valueWithName} is not negative (< 0)');

    result := Assert(fValue < 0);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TInt64Assertions.IsPositive: AssertionResult;
  begin
    Description := Format('{valueWithName} is positive (> 0)');
    Failure     := Format('{valueWithName} is not positive (> 0)');

    result := Assert(fValue > 0);
  end;




end.
