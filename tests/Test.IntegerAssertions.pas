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

  unit Test.IntegerAssertions;


interface

  uses
    Deltics.Smoketest,
    SelfTest;


  type
    TIntegerAssertionTests = class(TSelfTest)
      procedure BetweenFailsWhenValueIsOutsideLowerAndUpperBounds;
      procedure BetweenPassesWhenValueIsBetweenLowerAndUpperBounds;
      procedure BetweenPassesWhenValueIsBetweenReversedLowerAndUpperBounds;
      procedure BetweenRaisesEInvalidTestWhenLowerAndUpperBoundsAreEqual;
      procedure BetweenRaisesEInvalidTestWhenLowerAndUpperBoundsDifferByOne;
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
    end;


implementation

  uses
    SysUtils;


{ TIntegerAssertionTests }

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.BetweenFailsWhenValueIsOutsideLowerAndUpperBounds;
  begin
    Test.IsExpectedToFail;

    Assert(-1).Between(0, 41);
    Assert(42).Between(0, 41);
    Assert(-42).Between(-41, 41);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.BetweenPassesWhenValueIsBetweenLowerAndUpperBounds;
  begin
    Assert(42).Between(0, 100);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.BetweenPassesWhenValueIsBetweenReversedLowerAndUpperBounds;
  begin
    Assert(42).Between(100, 0);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.BetweenRaisesEInvalidTestWhenLowerAndUpperBoundsAreEqual;
  begin
    Test.Raises(EInvalidTest);

    Assert(42).Between(42, 42);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.BetweenRaisesEInvalidTestWhenLowerAndUpperBoundsDifferByOne;
  begin
    Test.Raises(EInvalidTest);

    Assert(42).Between(42, 43);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.EqualsFailsWhenValueIsNotEqual;
  begin
    Test.IsExpectedToFail;

    Assert(42).Equals(0);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.EqualsPassesWhenValueIsEqual;
  begin
    Assert(42).Equals(42);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.GreaterThanFailsWhenValueIsEqual;
  begin
    Test.IsExpectedToFail;

    Assert(42).GreaterThan(42);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.GreaterThanFailsWhenValueIsLesser;
  begin
    Test.IsExpectedToFail;

    Assert(-1).GreaterThan(0);
    Assert(42).GreaterThan(43);
    Assert(MaxInt - 1).GreaterThan(MaxInt);
    Assert(-MaxInt).GreaterThan(-MaxInt + 1);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.GreaterThanOrEqualFailsWhenValueIsLesser;
  begin
    Test.IsExpectedToFail;

    Assert(-1).GreaterThanOrEquals(0);
    Assert(42).GreaterThanOrEquals(43);
    Assert(MaxInt - 1).GreaterThanOrEquals(MaxInt);
    Assert(-MaxInt).GreaterThanOrEquals(-MaxInt + 1);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.GreaterThanOrEqualPassesWhenValueIsEqual;
  begin
    Assert(-1).GreaterThanOrEquals(-1);
    Assert(42).GreaterThanOrEquals(42);
    Assert(MaxInt - 1).GreaterThanOrEquals(MaxInt - 1);
    Assert(-MaxInt).GreaterThanOrEquals(-MaxInt);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.GreaterThanOrEqualPassesWhenValueIsGreater;
  begin
    Assert(0).GreaterThanOrEquals(-1);
    Assert(42).GreaterThanOrEquals(41);
    Assert(MaxInt).GreaterThanOrEquals(MaxInt - 1);
    Assert(-MaxInt + 1).GreaterThanOrEquals(-MaxInt);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.GreaterThanPassesWhenValueIsGreater;
  begin
    Assert(0).GreaterThan(-1);
    Assert(42).GreaterThan(41);
    Assert(MaxInt).GreaterThan(MaxInt - 1);
    Assert(1).GreaterThan(-MaxInt);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.LessThanFailsWhenValueIsEqual;
  begin
    Test.IsExpectedToFail;

    Assert(42).LessThan(42);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.LessThanFailsWhenValueIsGreater;
  begin
    Test.IsExpectedToFail;

    Assert(0).LessThan(-1);
    Assert(43).LessThan(42);
    Assert(MaxInt).LessThan(MaxInt - 1);
    Assert(-MaxInt + 1).LessThan(-MaxInt);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.LessThanOrEqualFailsWhenValueIsGreater;
  begin
    Test.IsExpectedToFail;

    Assert(0).LessThanOrEquals(-1);
    Assert(42).LessThanOrEquals(41);
    Assert(MaxInt).LessThanOrEquals(MaxInt - 1);
    Assert(-MaxInt + 1).LessThanOrEquals(-MaxInt);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.LessThanOrEqualPassesWhenValueIsEqual;
  begin
    Assert(-1).LessThanOrEquals(-1);
    Assert(42).LessThanOrEquals(42);
    Assert(MaxInt - 1).LessThanOrEquals(MaxInt - 1);
    Assert(-MaxInt).LessThanOrEquals(-MaxInt);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.LessThanOrEqualPassesWhenValueIsLesser;
  begin
    Assert(-1).LessThanOrEquals(0);
    Assert(42).LessThanOrEquals(43);
    Assert(MaxInt - 1).LessThanOrEquals(MaxInt);
    Assert(-MaxInt).LessThanOrEquals(-MaxInt + 1);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.LessThanPassesWhenValueIsLesser;
  begin
    Assert(-1).LessThan(0);
    Assert(42).LessThan(43);
    Assert(MaxInt - 1).LessThan(MaxInt);
    Assert(-MaxInt).LessThan(-MaxInt + 1);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.InRangeFailsWhenValueIsOutsideRange;
  begin
    Test.IsExpectedToFail;

    Assert(-42).InRange(-1, -41);
    Assert(-42).InRange(-43, -100);

    Assert(42).InRange(1, 41);
    Assert(42).InRange(43, 100);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.InRangePassesWhenValueIsInRange;
  begin
    Assert(-42).InRange(-1, -42);
    Assert(-42).InRange(-42, -100);
    Assert(-42).InRange(-41, -43);
    Assert(-42).InRange(-1, -100);
    Assert(-42).InRange(-MaxInt, MaxInt);

    Assert(42).InRange(1, 42);
    Assert(42).InRange(42, 100);
    Assert(42).InRange(41, 43);
    Assert(42).InRange(1, 100);
    Assert(42).InRange(-MaxInt, MaxInt);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.InRangePassesWhenValueIsInReversedRange;
  begin
    Assert(-42).InRange(-1, -42);
    Assert(-42).InRange(-42, -100);
    Assert(-42).InRange(-41, -43);
    Assert(-42).InRange(-100, -1);
    Assert(-42).InRange(MaxInt, -MaxInt);

    Assert(42).InRange(42, 1);
    Assert(42).InRange(100, 42);
    Assert(42).InRange(43, 41);
    Assert(42).InRange(100, 1);
    Assert(42).InRange(MaxInt, -MaxInt);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.InRangeRaisesEInvalidTestWhenLowerAndUpperBoundsAreEqual;
  begin
    Test.Raises(EInvalidTest);

    Assert(42).InRange(42, 42);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.IsNegativeFailsWhenValueIsZeroOrPositive;
  begin
    Test.IsExpectedToFail;

    Assert(0).IsNegative;
    Assert(1).IsNegative;
    Assert(MaxInt).IsNegative;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.IsNegativePassesWhenValueIsLessThanZero;
  begin
    Assert(-1).IsNegative;
    Assert(-MaxInt).IsNegative;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.IsPositiveFailsWhenValueIsZeroOrNegatve;
  begin
    Test.IsExpectedToFail;

    Assert(0).IsPositive;
    Assert(-1).IsPositive;
    Assert(-MaxInt).IsPositive;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.IsPositivePassesWhenValueIsGreaterThanZero;
  begin
    Assert(1).IsPositive;
    Assert(MaxInt).IsPositive;
  end;



end.
