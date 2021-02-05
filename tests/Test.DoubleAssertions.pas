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

  unit Test.DoubleAssertions;


interface

  uses
    Deltics.Smoketest,
    SelfTest;


  type
    TDoubleAssertionTests = class(TSelfTest)
      procedure BetweenFailsWhenValueIsOutsideLowerAndUpperBounds;
      procedure BetweenPassesWhenValueIsBetweenLowerAndUpperBounds;
      procedure BetweenPassesWhenValueIsBetweenReversedLowerAndUpperBounds;
      procedure BetweenRaisesEInvalidTestWhenLowerAndUpperBoundsAreEqual;
      procedure EqualsFailsWhenValueIsNotEqual;
      procedure EqualsPassesWhenValueIsEqual;
      procedure GreaterThanFailsWhenValueIsEqual;
      procedure GreaterThanFailsWhenValueIsLesser;
      procedure GreaterThanPassesWhenValueIsGreater;
      procedure GreaterThanOrEqualFailsWhenValueIsLesser;
      procedure GreaterThanOrEqualPassesWhenValueIsEqual;
      procedure GreaterThanOrEqualPassesWhenValueIsGreater;
      procedure InRangeFailsWhenValueIsOutsideRange;
      procedure InRangePassesWhenValueIsInRange;
      procedure InRangePassesWhenValueIsInReversedRange;
      procedure InRangeRaisesEInvalidTestWhenLowerAndUpperBoundsAreEqual;
      procedure LessThanFailsWhenValueIsEqual;
      procedure LessThanFailsWhenValueIsGreater;
      procedure LessThanPassesWhenValueIsLesser;
      procedure LessThanOrEqualFailsWhenValueIsGreater;
      procedure LessThanOrEqualPassesWhenValueIsEqual;
      procedure LessThanOrEqualPassesWhenValueIsLesser;
      procedure IsNegativeFailsWhenValueIsZeroOrPositive;
      procedure IsNegativePassesWhenValueIsLessThanZero;
      procedure IsPositiveFailsWhenValueIsZeroOrNegatve;
      procedure IsPositivePassesWhenValueIsGreaterThanZero;
      procedure IsInfinityPassesWhenValueExceedsDoubleRange;
      procedure IsNegativeInfinityPassesWhenValueExceedsNegativeDoubleRange;
      procedure IsNANPassesWhenValueIsNotAValidNumber;
      procedure IsNANFailsWhenValueIsAValidNumber;
    end;


implementation

  uses
    SysUtils;


{ TDoubleAssertionTests }

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDoubleAssertionTests.BetweenFailsWhenValueIsOutsideLowerAndUpperBounds;
  begin
    Test.IsExpectedToFail;

    AssertDouble(-1).Between(0, 41);
    AssertDouble(42).Between(0, 41);
    AssertDouble(-42).Between(-41, 41);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDoubleAssertionTests.BetweenPassesWhenValueIsBetweenLowerAndUpperBounds;
  begin
    AssertDouble(42).Between(0, 100);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDoubleAssertionTests.BetweenPassesWhenValueIsBetweenReversedLowerAndUpperBounds;
  begin
    AssertDouble(42).Between(100, 0);
    AssertDouble(42.0015).Between(42.001, 42.002);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDoubleAssertionTests.BetweenRaisesEInvalidTestWhenLowerAndUpperBoundsAreEqual;
  begin
    Test.Raises(EInvalidTest);

    AssertDouble(42).Between(42, 42);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDoubleAssertionTests.EqualsFailsWhenValueIsNotEqual;
  begin
    Test.IsExpectedToFail;

    AssertDouble(42).Equals(0);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDoubleAssertionTests.EqualsPassesWhenValueIsEqual;
  begin
    AssertDouble(42).Equals(42);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDoubleAssertionTests.GreaterThanFailsWhenValueIsEqual;
  begin
    Test.IsExpectedToFail;

    AssertDouble(42).GreaterThan(42);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDoubleAssertionTests.GreaterThanFailsWhenValueIsLesser;
  begin
    Test.IsExpectedToFail;

    AssertDouble(-1).GreaterThan(0);
    AssertDouble(42).GreaterThan(43);
    AssertDouble(MaxInt - 1).GreaterThan(MaxInt);
    AssertDouble(-MaxInt).GreaterThan(-MaxInt + 1);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDoubleAssertionTests.GreaterThanOrEqualFailsWhenValueIsLesser;
  begin
    Test.IsExpectedToFail;

    AssertDouble(-1).GreaterThanOrEquals(0);
    AssertDouble(42).GreaterThanOrEquals(43);
    AssertDouble(MaxInt - 1).GreaterThanOrEquals(MaxInt);
    AssertDouble(-MaxInt).GreaterThanOrEquals(-MaxInt + 1);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDoubleAssertionTests.GreaterThanOrEqualPassesWhenValueIsEqual;
  begin
    AssertDouble(-1).GreaterThanOrEquals(-1);
    AssertDouble(42).GreaterThanOrEquals(42);
    AssertDouble(MaxInt - 1).GreaterThanOrEquals(MaxInt - 1);
    AssertDouble(-MaxInt).GreaterThanOrEquals(-MaxInt);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDoubleAssertionTests.GreaterThanOrEqualPassesWhenValueIsGreater;
  begin
    AssertDouble(0).GreaterThanOrEquals(-1);
    AssertDouble(42).GreaterThanOrEquals(41);
    AssertDouble(MaxInt).GreaterThanOrEquals(MaxInt - 1);
    AssertDouble(-MaxInt + 1).GreaterThanOrEquals(-MaxInt);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDoubleAssertionTests.GreaterThanPassesWhenValueIsGreater;
  begin
    AssertDouble(0).GreaterThan(-1);
    AssertDouble(42).GreaterThan(41);
    AssertDouble(MaxInt).GreaterThan(MaxInt - 1);
    AssertDouble(1).GreaterThan(-MaxInt);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDoubleAssertionTests.LessThanFailsWhenValueIsEqual;
  begin
    Test.IsExpectedToFail;

    AssertDouble(42).LessThan(42);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDoubleAssertionTests.LessThanFailsWhenValueIsGreater;
  begin
    Test.IsExpectedToFail;

    AssertDouble(0).LessThan(-1);
    AssertDouble(43).LessThan(42);
    AssertDouble(MaxInt).LessThan(MaxInt - 1);
    AssertDouble(-MaxInt + 1).LessThan(-MaxInt);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDoubleAssertionTests.LessThanOrEqualFailsWhenValueIsGreater;
  begin
    Test.IsExpectedToFail;

    AssertDouble(0).LessThanOrEquals(-1);
    AssertDouble(42).LessThanOrEquals(41);
    AssertDouble(MaxInt).LessThanOrEquals(MaxInt - 1);
    AssertDouble(-MaxInt + 1).LessThanOrEquals(-MaxInt);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDoubleAssertionTests.LessThanOrEqualPassesWhenValueIsEqual;
  begin
    AssertDouble(-1).LessThanOrEquals(-1);
    AssertDouble(42).LessThanOrEquals(42);
    AssertDouble(MaxInt - 1).LessThanOrEquals(MaxInt - 1);
    AssertDouble(-MaxInt).LessThanOrEquals(-MaxInt);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDoubleAssertionTests.LessThanOrEqualPassesWhenValueIsLesser;
  begin
    AssertDouble(-1).LessThanOrEquals(0);
    AssertDouble(42).LessThanOrEquals(43);
    AssertDouble(MaxInt - 1).LessThanOrEquals(MaxInt);
    AssertDouble(-MaxInt).LessThanOrEquals(-MaxInt + 1);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDoubleAssertionTests.LessThanPassesWhenValueIsLesser;
  begin
    AssertDouble(-1).LessThan(0);
    AssertDouble(42).LessThan(43);
    AssertDouble(MaxInt - 1).LessThan(MaxInt);
    AssertDouble(-MaxInt).LessThan(-MaxInt + 1);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDoubleAssertionTests.InRangeFailsWhenValueIsOutsideRange;
  begin
    Test.IsExpectedToFail;

    AssertDouble(-42).InRange(-1, -41);
    AssertDouble(-42).InRange(-43, -100);

    AssertDouble(42).InRange(1, 41);
    AssertDouble(42).InRange(43, 100);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDoubleAssertionTests.InRangePassesWhenValueIsInRange;
  begin
    AssertDouble(-42).InRange(-1, -42);
    AssertDouble(-42).InRange(-42, -100);
    AssertDouble(-42).InRange(-41, -43);
    AssertDouble(-42).InRange(-1, -100);
    AssertDouble(-42).InRange(-MaxInt, MaxInt);

    AssertDouble(42).InRange(1, 42);
    AssertDouble(42).InRange(42, 100);
    AssertDouble(42).InRange(41, 43);
    AssertDouble(42).InRange(1, 100);
    AssertDouble(42).InRange(-MaxInt, MaxInt);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDoubleAssertionTests.InRangePassesWhenValueIsInReversedRange;
  begin
    AssertDouble(-42).InRange(-1, -42);
    AssertDouble(-42).InRange(-42, -100);
    AssertDouble(-42).InRange(-41, -43);
    AssertDouble(-42).InRange(-100, -1);
    AssertDouble(-42).InRange(MaxInt, -MaxInt);

    AssertDouble(42).InRange(42, 1);
    AssertDouble(42).InRange(100, 42);
    AssertDouble(42).InRange(43, 41);
    AssertDouble(42).InRange(100, 1);
    AssertDouble(42).InRange(MaxInt, -MaxInt);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDoubleAssertionTests.InRangeRaisesEInvalidTestWhenLowerAndUpperBoundsAreEqual;
  begin
    Test.Raises(EInvalidTest);

    AssertDouble(42).InRange(42, 42);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDoubleAssertionTests.IsInfinityPassesWhenValueExceedsDoubleRange;
  begin
    AssertDouble(1.8e308).IsInfinity;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDoubleAssertionTests.IsNANFailsWhenValueIsAValidNumber;
  begin
    Test.IsExpectedToFail;

    AssertDouble(1.42).IsNAN;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDoubleAssertionTests.IsNANPassesWhenValueIsNotAValidNumber;
  begin
    AssertDouble(0.0 / 0.0).IsNAN;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDoubleAssertionTests.IsNegativeFailsWhenValueIsZeroOrPositive;
  begin
    Test.IsExpectedToFail;

    AssertDouble(0).IsNegative;
    AssertDouble(1).IsNegative;
    AssertDouble(MaxInt).IsNegative;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDoubleAssertionTests.IsNegativeInfinityPassesWhenValueExceedsNegativeDoubleRange;
  begin
    AssertDouble(-1.8e308).IsNegativeInfinity;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDoubleAssertionTests.IsNegativePassesWhenValueIsLessThanZero;
  begin
    AssertDouble(-1).IsNegative;
    AssertDouble(-MaxInt).IsNegative;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDoubleAssertionTests.IsPositiveFailsWhenValueIsZeroOrNegatve;
  begin
    Test.IsExpectedToFail;

    AssertDouble(0).IsPositive;
    AssertDouble(-1).IsPositive;
    AssertDouble(-MaxInt).IsPositive;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDoubleAssertionTests.IsPositivePassesWhenValueIsGreaterThanZero;
  begin
    AssertDouble(1).IsPositive;
    AssertDouble(MaxInt).IsPositive;
  end;



end.
