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

  unit Deltics.Smoketest.Assertions.Double;


interface

  uses
    Deltics.Smoketest.Assertions;


  type
    DoubleAssertions = interface
    ['{E240F603-5279-4483-80C1-995E0AB6357D}']
      function Equals(const aExpected: Double): AssertionResult;
      function GreaterThan(const aExpected: Double): AssertionResult;
      function GreaterThanOrEquals(const aExpected: Double): AssertionResult;
      function IsInteger: AssertionResult;
      function IsInfinity: AssertionResult;
      function IsNaN: AssertionResult;
      function IsNotNaN: AssertionResult;
      function IsNegative: AssertionResult;
      function IsNegativeInfinity: AssertionResult;
      function IsPositive: AssertionResult;
      function IsPositiveInfinity: AssertionResult;
      function IsZero: AssertionResult;
      function LessThan(const aExpected: Double): AssertionResult;
      function LessThanOrEquals(const aExpected: Double): AssertionResult;
      function Between(const aLowerBound, aUpperBound: Double): AssertionResult;
      function InRange(const aMin, aMax: Double): AssertionResult;
    end;


    TDoubleAssertions = class(TAssertions, DoubleAssertions)
    private
      fValue: Double;
      function Equals(const aExpected: Double): AssertionResult; reintroduce;
      function GreaterThan(const aLimit: Double): AssertionResult;
      function GreaterThanOrEquals(const aMin: Double): AssertionResult;
      function IsInteger: AssertionResult;
      function IsInfinity: AssertionResult;
      function IsNaN: AssertionResult;
      function IsNotNaN: AssertionResult;
      function IsNegative: AssertionResult;
      function IsNegativeInfinity: AssertionResult;
      function IsPositive: AssertionResult;
      function IsPositiveInfinity: AssertionResult;
      function IsZero: AssertionResult;
      function LessThan(const aLimit: Double): AssertionResult;
      function LessThanOrEquals(const aMax: Double): AssertionResult;
      function Between(const aLowerBound, aUpperBound: Double): AssertionResult;
      function InRange(const aMin, aMax: Double): AssertionResult;
    public
      constructor Create(const aTestName: String; aValue: Double);
    end;


implementation

  uses
    Math,
    SysUtils;


  procedure Swap(var a, b: Double);
  begin
    a := a + b;
    b := a - b;
    a := a - b;
  end;


{ DoubleAssertions ---------------------------------------------------------------------------- }

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  constructor TDoubleAssertions.Create(const aTestName: String;
                                               aValue: Double);
  begin
    inherited Create(aTestName, FloatToStr(aValue));

    fValue := aValue;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TDoubleAssertions.Between(const aLowerBound, aUpperBound: Double): AssertionResult;
  var
    lbound, ubound: Double;
  begin
    if aLowerBound = aUpperBound then
      raise EInvalidTest.CreateFmt('Invalid lower (%g) and upper (%g) bounds to Assert(Double).Between.  The lower and upper bounds cannot be equal.', [aLowerBound, aUpperBound]);

    lbound := aLowerBound;
    ubound := aUpperBound;
    if lbound > ubound then
      Swap(lbound, ubound);

    FormatToken('lowerBound', FloatToStr(lbound));
    FormatToken('upperBound', FloatToStr(ubound));

    Description := Format('{valueWithName} is between {lowerBound} and {upperBound} (excl.)');
    Failure     := Format('{valueWithName} is not between {lowerBound} and {upperBound} (excl.)');

    result := Assert((fValue > lbound) and (fValue < ubound));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TDoubleAssertions.Equals(const aExpected: Double): AssertionResult;
  begin
    FormatExpected(FloatToStr(aExpected));

    Description := Format('{valueName} = {expected}');
    Failure     := Format('{valueWithName} does not = {expected}');

    result := Assert(fValue = aExpected);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TDoubleAssertions.GreaterThan(const aLimit: Double): AssertionResult;
  begin
    FormatToken('limit', FloatToStr(aLimit));

    Description := Format('{valueWithName} > {limit}');
    Failure     := Format('{valueWithName} is not > {limit}');

    result := Assert(fValue > aLimit);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TDoubleAssertions.GreaterThanOrEquals(const aMin: Double): AssertionResult;
  begin
    FormatToken('min', FloatToStr(aMin));

    Description := Format('{valueWithName} >= {min}');
    Failure     := Format('{valueWithName} is not >= {min}');

    result := Assert(fValue >= aMin);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TDoubleAssertions.IsInfinity: AssertionResult;
  begin
    Description := Format('{valueWithName} is +INF');
    Failure     := Format('{valueWithName} is not +INF');

    result := Assert(IsInfinite(fValue));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TDoubleAssertions.IsInteger: AssertionResult;
  begin
    Description := Format('{valueWithName} is an Integer');
    Failure     := Format('{valueWithName} is not an Integer');

    result := Assert(fValue - Trunc(fValue) = 0);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TDoubleAssertions.IsNaN: AssertionResult;
  begin
    Description := Format('{valueWithName} is NaN');
    Failure     := Format('{valueWithName} is not NaN');

    result := Assert(Math.IsNaN(fValue));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TDoubleAssertions.IsNegative: AssertionResult;
  begin
    Description := Format('{valueWithName} is < 0');
    Failure     := Format('{valueWithName} is >= 0');

    result := Assert(fValue < 0);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TDoubleAssertions.IsNegativeInfinity: AssertionResult;
  begin
    Description := Format('{valueWithName} is -INF');
    Failure     := Format('{valueWithName} is not -INF');

    result := Assert(IsInfinite(-fValue));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TDoubleAssertions.IsNotNAN: AssertionResult;
  begin
    Description := Format('{valueWithName} is not NaN');
    Failure     := Format('{valueWithName} is NaN');

    result := Assert(NOT Math.IsNaN(fValue));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TDoubleAssertions.IsPositive: AssertionResult;
  begin
    Description := Format('{valueWithName} is > 0');
    Failure     := Format('{valueWithName} is <= 0');

    result := Assert(fValue > 0);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TDoubleAssertions.IsPositiveInfinity: AssertionResult;
  begin
    Description := Format('{valueWithName} is +INF');
    Failure     := Format('{valueWithName} is not +INF');

    result := Assert(IsInfinite(fValue));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TDoubleAssertions.IsZero: AssertionResult;
  begin
    Description := Format('{valueWithName} is zero');
    Failure     := Format('{valueWithName} is not zero');

    result := Assert(fValue = 0);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TDoubleAssertions.LessThan(const aLimit: Double): AssertionResult;
  begin
    FormatToken('limit', FloatToStr(aLimit));

    Description := Format('{valueWithName} < {limit}');
    Failure     := Format('{valueWithName} is not < {limit}');

    result := Assert(fValue < aLimit);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TDoubleAssertions.LessThanOrEquals(const aMax: Double): AssertionResult;
  begin
    FormatToken('max', FloatToStr(aMax));

    Description := Format('{valueWithName} <= {max}');
    Failure     := Format('{valueWithName} is not <= {max}');

    result := Assert(fValue <= aMax);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TDoubleAssertions.InRange(const aMin, aMax: Double): AssertionResult;
  var
    min, max: Double;
  begin
    if aMin = aMax then
      raise EInvalidTest.CreateFmt('Min (%g) and Max (%g) bounds to Assert(Double).InRange are equal.  Did you mean to use Assert.Equals() ?', [aMin, aMax]);

    min := aMin;
    max := aMax;
    if min > max then
      Swap(min, max);

    FormatToken('min', FloatToStr(min));
    FormatToken('max', FloatToStr(max));

    Description := Format('{valueWithName} is in the range {min} .. {max} (incl.)');
    Failure     := Format('{valueWithName} is not in the range {min} .. {max} (incl.)');

    result := Assert((fValue >= min) and (fValue <= max));
  end;




end.

