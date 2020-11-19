
  unit Test.IntegerAssertions;

interface

  uses
    Deltics.Smoketest,
    Deltics.Smoketest.Assertions.Integers,
    Test.SelfTest;


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
    AllAssertsExpectedToFail;
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
    ExpectingException(EInvalidTest);
    Assert(42).Between(42, 42);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.BetweenRaisesEInvalidTestWhenLowerAndUpperBoundsDifferByOne;
  begin
    ExpectingException(EInvalidTest);
    Assert(42).Between(42, 43);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.EqualsFailsWhenValueIsNotEqual;
  begin
    AllAssertsExpectedToFail;
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
    AllAssertsExpectedToFail;
    Assert(42).GreaterThan(42);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.GreaterThanFailsWhenValueIsLesser;
  begin
    AllAssertsExpectedToFail;
    Assert(-1).GreaterThan(0);
    Assert(42).GreaterThan(43);
    Assert(MaxInt - 1).GreaterThan(MaxInt);
    Assert(-MaxInt).GreaterThan(-MaxInt + 1);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.GreaterThanOrEqualFailsWhenValueIsLesser;
  begin
    AllAssertsExpectedToFail;
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
    AllAssertsExpectedToFail;
    Assert(42).LessThan(42);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.LessThanFailsWhenValueIsGreater;
  begin
    AllAssertsExpectedToFail;
    Assert(0).LessThan(-1);
    Assert(43).LessThan(42);
    Assert(MaxInt).LessThan(MaxInt - 1);
    Assert(-MaxInt + 1).LessThan(-MaxInt);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.LessThanOrEqualFailsWhenValueIsGreater;
  begin
    AllAssertsExpectedToFail;
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
    AllAssertsExpectedToFail;

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
    ExpectingException(EInvalidTest);
    Assert(42).InRange(42, 42);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TIntegerAssertionTests.IsNegativeFailsWhenValueIsZeroOrPositive;
  begin
    AllAssertsExpectedToFail;
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
    AllAssertsExpectedToFail;
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
