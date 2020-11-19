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

  unit Deltics.Smoketest.Assertions.Date;


interface

  uses
    Deltics.Smoketest.Assertions;


  type
    DateAssertions = interface
    ['{B4C93E4C-7CFA-4328-A822-2EFE063A45FB}']
      function Equals(const aExpected: TDate): AssertionResult;
      function GreaterThan(const aExpected: TDate): AssertionResult;
      function GreaterThanOrEquals(const aExpected: TDate): AssertionResult;
      function LessThan(const aExpected: TDate): AssertionResult;
      function LessThanOrEquals(const aExpected: TDate): AssertionResult;
      function Between(const aLowerBound, aUpperBound: TDate): AssertionResult;
      function InRange(const aMin, aMax: TDate): AssertionResult;
    end;


    TDateAssertions = class(TAssertions, DateAssertions)
    private
      fValue: TDate;
      function Equals(const aExpected: TDate): AssertionResult; reintroduce;
      function GreaterThan(const aLimit: TDate): AssertionResult;
      function GreaterThanOrEquals(const aMin: TDate): AssertionResult;
      function LessThan(const aLimit: TDate): AssertionResult;
      function LessThanOrEquals(const aMax: TDate): AssertionResult;
      function Between(const aLowerBound, aUpperBound: TDate): AssertionResult;
      function InRange(const aMin, aMax: TDate): AssertionResult;
    public
      constructor Create(const aTestName: String; aValue: TDate);
    end;


implementation

  uses
    SysUtils;


  procedure Swap(var a, b: TDate);
  begin
    a := a + b;
    b := a - b;
    a := a - b;
  end;


{ TDateAssertions ---------------------------------------------------------------------------- }

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  constructor TDateAssertions.Create(const aTestName: String;
                                               aValue: TDate);
  begin
    inherited Create(aTestName, DateToStr(aValue));

    fValue := aValue;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TDateAssertions.Between(const aLowerBound, aUpperBound: TDate): AssertionResult;
  var
    lbound, ubound: TDate;
  begin
    if Abs(aLowerBound - aUpperBound) < 2 then
      raise EInvalidTest.CreateFmt('Invalid lower (%d) and upper (%d) bounds to Assert(TDate).Between.  There must be a difference greater than 1 between the lower and upper bounds.', [aLowerBound, aUpperBound]);

    lbound := aLowerBound;
    ubound := aUpperBound;
    if lbound > ubound then
      Swap(lbound, ubound);

    FormatToken('lowerBound', DateToStr(lbound));
    FormatToken('upperBound', DateToStr(ubound));

    Description := Format('{valueWithName} is between {lowerBound} and {upperBound} (excl.)');
    Failure     := Format('{valueWithName} is not between {lowerBound} and {upperBound} (excl.)');

    result := Assert((fValue > lbound) and (fValue < ubound));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TDateAssertions.Equals(const aExpected: TDate): AssertionResult;
  begin
    FormatExpected(DateToStr(aExpected));

    Description := Format('{valueName} = {expected}');
    Failure     := Format('{valueWithName} does not = {expected}');

    result := Assert(fValue = aExpected);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TDateAssertions.GreaterThan(const aLimit: TDate): AssertionResult;
  begin
    FormatToken('limit', DateToStr(aLimit));

    Description := Format('{valueWithName} > {limit}');
    Failure     := Format('{valueWithName} is not > {limit}');

    result := Assert(fValue > aLimit);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TDateAssertions.GreaterThanOrEquals(const aMin: TDate): AssertionResult;
  begin
    FormatToken('min', DateToStr(aMin));

    Description := Format('{valueWithName} >= {min}');
    Failure     := Format('{valueWithName} is not >= {min}');

    result := Assert(fValue >= aMin);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TDateAssertions.LessThan(const aLimit: TDate): AssertionResult;
  begin
    FormatToken('limit', DateToStr(aLimit));

    Description := Format('{valueWithName} < {limit}');
    Failure     := Format('{valueWithName} is not < {limit}');

    result := Assert(fValue < aLimit);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TDateAssertions.LessThanOrEquals(const aMax: TDate): AssertionResult;
  begin
    FormatToken('max', DateToStr(aMax));

    Description := Format('{valueWithName} <= {max}');
    Failure     := Format('{valueWithName} is not <= {max}');

    result := Assert(fValue <= aMax);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TDateAssertions.InRange(const aMin, aMax: TDate): AssertionResult;
  var
    min, max: TDate;
  begin
    if aMin = aMax then
      raise EInvalidTest.CreateFmt('Min (%d) and Max (%d) bounds to Assert(TDate).InRange are equal.  Did you mean to use Assert.Equals() ?', [aMin, aMax]);

    min := aMin;
    max := aMax;
    if min > max then
      Swap(min, max);

    FormatToken('min', DateToStr(min));
    FormatToken('max', DateToStr(max));

    Description := Format('{valueWithName} is in the range {min} .. {max} (incl.)');
    Failure     := Format('{valueWithName} is not in the range {min} .. {max} (incl.)');

    result := Assert((fValue >= min) and (fValue <= max));
  end;




end.
