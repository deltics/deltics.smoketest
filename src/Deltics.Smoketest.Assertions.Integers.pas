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
    Deltics.Smoketest.Assertions.Base;


  type
    IntegerAssertions = interface
    ['{46F67D92-BD65-4D8D-B9B6-65203BC1DF41}']
      function Equals(const aExpected: Integer): AssertionResult;
      function GreaterThan(const aExpected: Integer): AssertionResult;
      function GreaterThanOrEqualTo(const aExpected: Integer): AssertionResult;
      function LessThan(const aExpected: Integer): AssertionResult;
      function LessThanOrEqualTo(const aExpected: Integer): AssertionResult;
      function Between(const aLowerBound, aUpperBound: Integer): AssertionResult;
      function InRange(const aMin, aMax: Integer): AssertionResult;
      function IsNegative: AssertionResult;
      function IsPositive: AssertionResult;
    end;


    TIntegerAssertions = class(TFluentAssertions, IntegerAssertions)
    private
      fValue: Integer;
      function Equals(const aExpected: Integer): AssertionResult; reintroduce;
      function GreaterThan(const aExpected: Integer): AssertionResult;
      function GreaterThanOrEqualTo(const aExpected: Integer): AssertionResult;
      function LessThan(const aExpected: Integer): AssertionResult;
      function LessThanOrEqualTo(const aExpected: Integer): AssertionResult;
      function Between(const aLowerBound, aUpperBound: Integer): AssertionResult;
      function InRange(const aMin, aMax: Integer): AssertionResult;
      function IsNegative: AssertionResult;
      function IsPositive: AssertionResult;
    public
      constructor Create(const aTestName: String; aValue: Integer);
    end;


implementation

{ TIntegerAssertions ----------------------------------------------------------------------------- }

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  constructor TIntegerAssertions.Create(const aTestName: String;
                                              aValue: Integer);
  begin
    inherited Create(aTestName);

    fValue := aValue;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TIntegerAssertions.Between(const aLowerBound, aUpperBound: Integer): AssertionResult;
  begin
    if Abs(aLowerBound - aUpperBound) < 2 then
      raise EInvalidTest.CreateFmt('Invalid lower (%d) and upper (%d) bounds to Assert(Integer).Between.  There must be a difference greater than 1 between the lower and upper bounds.', [aLowerBound, aUpperBound]);

    if aUpperBound < aLowerBound then
      result := Between(aUpperBound, aLowerBound)
    else
      result := SetResult((fValue > aLowerBound) and (fValue < aUpperBound),
                          'Value is expected to be between %d and %d (exclusive) but is %d',
                          [aLowerBound, aUpperBound, fValue]);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TIntegerAssertions.Equals(const aExpected: Integer): AssertionResult;
  begin
    result := SetResult(fValue = aExpected,
                        'Value is expected to be %d but is %d',
                        [aExpected, fValue]);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TIntegerAssertions.GreaterThan(const aExpected: Integer): AssertionResult;
  begin
    result := SetResult(fValue > aExpected,
                        'Value is expected to be greater than %d but is %d',
                        [aExpected, fValue]);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TIntegerAssertions.InRange(const aMin, aMax: Integer): AssertionResult;
  begin
    if aMin = aMax then
      result := Equals(aMax)
    else if aMax < aMin then
      result := InRange(aMax, aMin)
    else
    begin
      result := SetResult((fValue >= aMin) and (fValue <= aMax),
                          'Value is expected to be between %d and %d (inclusive) but is %d',
                          [aMin, aMax, fValue]);
    end;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TIntegerAssertions.IsNegative: AssertionResult;
  begin
    result := SetResult(fValue < 0,
                        'Value is expected to be negative (< 0) but is %d',
                        [fValue]);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TIntegerAssertions.IsPositive: AssertionResult;
  begin
    result := SetResult(fValue > 0,
                        'Value is expected to be positive (> 0) but is %d',
                        [fValue]);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TIntegerAssertions.LessThan(const aExpected: Integer): AssertionResult;
  begin
    result := SetResult(fValue < aExpected,
                        'Value is expected to be less than %d but is %d',
                        [aExpected, fValue]);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TIntegerAssertions.LessThanOrEqualTo(const aExpected: Integer): AssertionResult;
  begin
    result := SetResult(fValue <= aExpected,
                        'Value is expected to be less than or equal to %d but is %d',
                        [aExpected, fValue]);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TIntegerAssertions.GreaterThanOrEqualTo(const aExpected: Integer): AssertionResult;
  begin
    result := SetResult(fValue >= aExpected,
                        'Value is expected to be greater than or equal to %d but is %d',
                        [aExpected, fValue]);
  end;



end.
