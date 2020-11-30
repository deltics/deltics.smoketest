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

  unit Deltics.Smoketest.Assertions.DateTime;


interface

  uses
  {$ifdef __DELPHI2007}
    Controls,
  {$endif}
    Deltics.Smoketest.Assertions;


  type
    DateTimeAssertions = interface
    ['{3DC4331F-F70C-4230-B806-B44063D29B6A}']
      function Equals(const aExpected: TDateTime): AssertionResult;
      function EqualsDate(const aExpected: TDate): AssertionResult; overload;
      function EqualsDate(const aYear, aMonth, aDay: Word): AssertionResult; overload;
      function GreaterThan(const aExpected: TDateTime): AssertionResult;
      function GreaterThanOrEquals(const aExpected: TDateTime): AssertionResult;
      function LessThan(const aExpected: TDateTime): AssertionResult;
      function LessThanOrEquals(const aExpected: TDateTime): AssertionResult;
      function Between(const aLowerBound, aUpperBound: TDateTime): AssertionResult;
      function InRange(const aMin, aMax: TDateTime): AssertionResult;
    end;


    TDateTimeAssertions = class(TAssertions, DateTimeAssertions)
    private
      fValue: TDateTime;
      function Equals(const aExpected: TDateTime): AssertionResult; reintroduce;
      function EqualsDate(const aExpected: TDate): AssertionResult; overload;
      function EqualsDate(const aYear, aMonth, aDay: Word): AssertionResult; overload;
      function GreaterThan(const aLimit: TDateTime): AssertionResult;
      function GreaterThanOrEquals(const aMin: TDateTime): AssertionResult;
      function LessThan(const aLimit: TDateTime): AssertionResult;
      function LessThanOrEquals(const aMax: TDateTime): AssertionResult;
      function Between(const aLowerBound, aUpperBound: TDateTime): AssertionResult;
      function InRange(const aMin, aMax: TDateTime): AssertionResult;
    public
      constructor Create(const aTestName: String; aValue: TDateTime);
    end;


implementation

  uses
    SysUtils;


  procedure Swap(var a, b: TDateTime);
  begin
    a := a + b;
    b := a - b;
    a := a - b;
  end;


{ TDateTimeAssertions ---------------------------------------------------------------------------- }

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  constructor TDateTimeAssertions.Create(const aTestName: String;
                                               aValue: TDateTime);
  begin
    inherited Create(aTestName, DatetimeToStr(aValue));

    fValue := aValue;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TDateTimeAssertions.Between(const aLowerBound, aUpperBound: TDateTime): AssertionResult;
  var
    lbound, ubound: TDateTime;
  begin
    if Abs(aLowerBound - aUpperBound) < 2 then
      raise EInvalidTest.CreateFmt('Invalid lower (%d) and upper (%d) bounds to Assert(TDateTime).Between.  There must be a difference greater than 1 between the lower and upper bounds.', [aLowerBound, aUpperBound]);

    lbound := aLowerBound;
    ubound := aUpperBound;
    if lbound > ubound then
      Swap(lbound, ubound);

    FormatToken('lowerBound', DatetimeToStr(lbound));
    FormatToken('upperBound', DatetimeToStr(ubound));

    Description := Format('{valueWithName} is between {lowerBound} and {upperBound} (excl.)');
    Failure     := Format('{valueWithName} is not between {lowerBound} and {upperBound} (excl.)');

    result := Assert((fValue > lbound) and (fValue < ubound));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TDateTimeAssertions.Equals(const aExpected: TDateTime): AssertionResult;
  begin
    FormatExpected(DatetimeToStr(aExpected));

    Description := Format('{valueName} = {expected}');
    Failure     := Format('{valueWithName} does not = {expected}');

    result := Assert(fValue = aExpected);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TDateTimeAssertions.EqualsDate(const aYear, aMonth, aDay: Word): AssertionResult;
  begin
    result := EqualsDate(EncodeDate(aYear, aMonth, aDay));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TDateTimeAssertions.EqualsDate(const aExpected: TDate): AssertionResult;
  begin
    FormatExpected(DateToStr(aExpected));

    Description := Format('{valueName} = {expected}');
    Failure     := Format('{valueWithName} does not = {expected}');

    result := Assert(Trunc(fValue) = Trunc(aExpected));

  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TDateTimeAssertions.GreaterThan(const aLimit: TDateTime): AssertionResult;
  begin
    FormatToken('limit', DatetimeToStr(aLimit));

    Description := Format('{valueWithName} > {limit}');
    Failure     := Format('{valueWithName} is not > {limit}');

    result := Assert(fValue > aLimit);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TDateTimeAssertions.GreaterThanOrEquals(const aMin: TDateTime): AssertionResult;
  begin
    FormatToken('min', DatetimeToStr(aMin));

    Description := Format('{valueWithName} >= {min}');
    Failure     := Format('{valueWithName} is not >= {min}');

    result := Assert(fValue >= aMin);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TDateTimeAssertions.LessThan(const aLimit: TDateTime): AssertionResult;
  begin
    FormatToken('limit', DatetimeToStr(aLimit));

    Description := Format('{valueWithName} < {limit}');
    Failure     := Format('{valueWithName} is not < {limit}');

    result := Assert(fValue < aLimit);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TDateTimeAssertions.LessThanOrEquals(const aMax: TDateTime): AssertionResult;
  begin
    FormatToken('max', DatetimeToStr(aMax));

    Description := Format('{valueWithName} <= {max}');
    Failure     := Format('{valueWithName} is not <= {max}');

    result := Assert(fValue <= aMax);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TDateTimeAssertions.InRange(const aMin, aMax: TDateTime): AssertionResult;
  var
    min, max: TDateTime;
  begin
    if aMin = aMax then
      raise EInvalidTest.CreateFmt('Min (%d) and Max (%d) bounds to Assert(TDateTime).InRange are equal.  Did you mean to use Assert.Equals() ?', [aMin, aMax]);

    min := aMin;
    max := aMax;
    if min > max then
      Swap(min, max);

    FormatToken('min', DatetimeToStr(min));
    FormatToken('max', DatetimeToStr(max));

    Description := Format('{valueWithName} is in the range {min} .. {max} (incl.)');
    Failure     := Format('{valueWithName} is not in the range {min} .. {max} (incl.)');

    result := Assert((fValue >= min) and (fValue <= max));
  end;




end.
