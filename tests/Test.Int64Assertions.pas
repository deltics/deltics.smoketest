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

  unit Test.Int64Assertions;


interface

  uses
    Deltics.Smoketest,
    SelfTest;


  type
    TInt64AssertionTests = class(TSelfTest)
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

{ TInt64AssertionTests }

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TInt64AssertionTests.BetweenFailsWhenValueIsOutsideLowerAndUpperBounds;
  begin
    Test.IsExpectedToFail;

    Assert(Int64(-1)).Between(0, 41);
    Assert(Int64(42)).Between(0, 41);
    Assert(Int64(-42)).Between(-41, 41);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TInt64AssertionTests.BetweenPassesWhenValueIsBetweenLowerAndUpperBounds;
  begin
    Assert(Int64(42)).Between(0, 100);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TInt64AssertionTests.BetweenPassesWhenValueIsBetweenReversedLowerAndUpperBounds;
  begin
    Assert(Int64(42)).Between(100, 0);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TInt64AssertionTests.BetweenRaisesEInvalidTestWhenLowerAndUpperBoundsAreEqual;
  begin
    Test.Raises(EInvalidTest);

    Assert(Int64(42)).Between(42, 42);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TInt64AssertionTests.BetweenRaisesEInvalidTestWhenLowerAndUpperBoundsDifferByOne;
  begin
    Test.Raises(EInvalidTest);

    Assert(Int64(42)).Between(42, 43);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TInt64AssertionTests.EqualsFailsWhenValueIsNotEqual;
  begin
    Test.IsExpectedToFail;

    Assert(Int64(42)).Equals(0);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TInt64AssertionTests.EqualsPassesWhenValueIsEqual;
  begin
    Assert(Int64(42)).Equals(42);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TInt64AssertionTests.GreaterThanFailsWhenValueIsEqual;
  begin
    Test.IsExpectedToFail;

    Assert(Int64(42)).GreaterThan(42);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TInt64AssertionTests.GreaterThanFailsWhenValueIsLesser;
  begin
    Test.IsExpectedToFail;

    Assert(Int64(-1)).GreaterThan(0);
    Assert(Int64(42)).GreaterThan(43);
    Assert(High(Int64) - 1).GreaterThan(High(Int64));
    Assert(Low(Int64)).GreaterThan(Low(Int64) + 1);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TInt64AssertionTests.GreaterThanOrEqualFailsWhenValueIsLesser;
  begin
    Test.IsExpectedToFail;

    Assert(Int64(-1)).GreaterThanOrEquals(0);
    Assert(Int64(42)).GreaterThanOrEquals(43);
    Assert(High(Int64) - 1).GreaterThanOrEquals(High(Int64));
    Assert(Low(Int64)).GreaterThanOrEquals(Low(Int64) + 1);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TInt64AssertionTests.GreaterThanOrEqualPassesWhenValueIsEqual;
  begin
    Assert(Int64(-1)).GreaterThanOrEquals(-1);
    Assert(Int64(42)).GreaterThanOrEquals(42);
    Assert(High(Int64) - 1).GreaterThanOrEquals(High(Int64) - 1);
    Assert(Low(Int64)).GreaterThanOrEquals(Low(Int64));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TInt64AssertionTests.GreaterThanOrEqualPassesWhenValueIsGreater;
  begin
    Assert(Int64(0)).GreaterThanOrEquals(-1);
    Assert(Int64(42)).GreaterThanOrEquals(41);
    Assert(High(Int64)).GreaterThanOrEquals(High(Int64) - 1);
    Assert(Low(Int64) + 1).GreaterThanOrEquals(Low(Int64));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TInt64AssertionTests.GreaterThanPassesWhenValueIsGreater;
  begin
    Assert(Int64(0)).GreaterThan(-1);
    Assert(Int64(42)).GreaterThan(41);
    Assert(High(Int64)).GreaterThan(High(Int64) - 1);
    Assert(Int64(1)).GreaterThan(Low(Int64));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TInt64AssertionTests.LessThanFailsWhenValueIsEqual;
  begin
    Test.IsExpectedToFail;

    Assert(Int64(42)).LessThan(42);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TInt64AssertionTests.LessThanFailsWhenValueIsGreater;
  begin
    Test.IsExpectedToFail;

    Assert(Int64(0)).LessThan(-1);
    Assert(Int64(43)).LessThan(42);
    Assert(High(Int64)).LessThan(High(Int64) - 1);
    Assert(Low(Int64) + 1).LessThan(Low(Int64));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TInt64AssertionTests.LessThanOrEqualFailsWhenValueIsGreater;
  begin
    Test.IsExpectedToFail;

    Assert(Int64(0)).LessThanOrEquals(-1);
    Assert(Int64(42)).LessThanOrEquals(41);
    Assert(High(Int64)).LessThanOrEquals(High(Int64) - 1);
    Assert(Low(Int64) + 1).LessThanOrEquals(Low(Int64));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TInt64AssertionTests.LessThanOrEqualPassesWhenValueIsEqual;
  begin
    Assert(Int64(-1)).LessThanOrEquals(-1);
    Assert(Int64(42)).LessThanOrEquals(42);
    Assert(High(Int64) - 1).LessThanOrEquals(High(Int64) - 1);
    Assert(Low(Int64)).LessThanOrEquals(Low(Int64));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TInt64AssertionTests.LessThanOrEqualPassesWhenValueIsLesser;
  begin
    Assert(Int64(-1)).LessThanOrEquals(0);
    Assert(Int64(42)).LessThanOrEquals(43);
    Assert(High(Int64) - 1).LessThanOrEquals(High(Int64));
    Assert(Low(Int64)).LessThanOrEquals(Low(Int64) + 1);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TInt64AssertionTests.LessThanPassesWhenValueIsLesser;
  begin
    Assert(Int64(-1)).LessThan(0);
    Assert(Int64(42)).LessThan(43);
    Assert(High(Int64) - 1).LessThan(High(Int64));
    Assert(Low(Int64)).LessThan(Low(Int64) + 1);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TInt64AssertionTests.InRangeFailsWhenValueIsOutsideRange;
  begin
    Test.IsExpectedToFail;

    Assert(Int64(-42)).InRange(-1, -41);
    Assert(Int64(-42)).InRange(-43, -100);

    Assert(Int64(42)).InRange(1, 41);
    Assert(Int64(42)).InRange(43, 100);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TInt64AssertionTests.InRangePassesWhenValueIsInRange;
  begin
    Assert(Int64(-42)).InRange(-1, -42);
    Assert(Int64(-42)).InRange(-42, -100);
    Assert(Int64(-42)).InRange(-41, -43);
    Assert(Int64(-42)).InRange(-1, -100);
    Assert(Int64(-42)).InRange(Low(Int64), High(Int64));

    Assert(Int64(42)).InRange(1, 42);
    Assert(Int64(42)).InRange(42, 100);
    Assert(Int64(42)).InRange(41, 43);
    Assert(Int64(42)).InRange(1, 100);
    Assert(Int64(42)).InRange(Low(Int64), High(Int64));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TInt64AssertionTests.InRangePassesWhenValueIsInReversedRange;
  begin
    Assert(Int64(-42)).InRange(-1, -42);
    Assert(Int64(-42)).InRange(-42, -100);
    Assert(Int64(-42)).InRange(-41, -43);
    Assert(Int64(-42)).InRange(-100, -1);
    Assert(Int64(-42)).InRange(High(Int64), Low(Int64));

    Assert(Int64(42)).InRange(42, 1);
    Assert(Int64(42)).InRange(100, 42);
    Assert(Int64(42)).InRange(43, 41);
    Assert(Int64(42)).InRange(100, 1);
    Assert(Int64(42)).InRange(High(Int64), Low(Int64));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TInt64AssertionTests.InRangeRaisesEInvalidTestWhenLowerAndUpperBoundsAreEqual;
  begin
    Test.Raises(EInvalidTest);

    Assert(Int64(42)).InRange(42, 42);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TInt64AssertionTests.IsNegativeFailsWhenValueIsZeroOrPositive;
  begin
    Test.IsExpectedToFail;

    Assert(Int64(0)).IsNegative;
    Assert(Int64(1)).IsNegative;
    Assert(High(Int64)).IsNegative;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TInt64AssertionTests.IsNegativePassesWhenValueIsLessThanZero;
  begin
    Assert(Int64(-1)).IsNegative;
    Assert(Low(Int64)).IsNegative;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TInt64AssertionTests.IsPositiveFailsWhenValueIsZeroOrNegatve;
  begin
    Test.IsExpectedToFail;

    Assert(Int64(0)).IsPositive;
    Assert(Int64(-1)).IsPositive;
    Assert(Low(Int64)).IsPositive;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TInt64AssertionTests.IsPositivePassesWhenValueIsGreaterThanZero;
  begin
    Assert(Int64(1)).IsPositive;
    Assert(High(Int64)).IsPositive;
  end;



end.
