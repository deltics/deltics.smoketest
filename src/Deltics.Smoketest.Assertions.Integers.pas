
  unit Deltics.Smoketest.Assertions.Integers;

interface

  uses
    Deltics.Smoketest.Assertions.Base;


  type
    IIntegerAssertions = interface
    ['{DDC0C272-A878-4FF5-BF6C-61F9A0B91E98}']
      function Equals(const aExpected: Integer): Boolean;
      function GreaterThan(const aExpected: Integer): Boolean;
      function GreaterThanOrEqualTo(const aExpected: Integer): Boolean;
      function LessThan(const aExpected: Integer): Boolean;
      function LessThanOrEqualTo(const aExpected: Integer): Boolean;
      function Between(const aLowerBound, aUpperBound: Integer): Boolean;
      function InRange(const aMin, aMax: Integer): Boolean;
      function IsNegative: Boolean;
      function IsPositive: Boolean;
    end;


    TIntegerAssertions = class(TFluentAssertions, IIntegerAssertions)
    private
      fValue: Integer;
      function Equals(const aExpected: Integer): Boolean; reintroduce;
      function GreaterThan(const aExpected: Integer): Boolean;
      function GreaterThanOrEqualTo(const aExpected: Integer): Boolean;
      function LessThan(const aExpected: Integer): Boolean;
      function LessThanOrEqualTo(const aExpected: Integer): Boolean;
      function Between(const aLowerBound, aUpperBound: Integer): Boolean;
      function InRange(const aMin, aMax: Integer): Boolean;
      function IsNegative: Boolean;
      function IsPositive: Boolean;
    public
      constructor Create(const aTestName: String; aValue: Integer);
    end;


implementation

{ TIntegerAssertions }

  constructor TIntegerAssertions.Create(const aTestName: String;
                                              aValue: Integer);
  begin
    inherited Create(aTestName);

    fValue := aValue;
  end;


  function TIntegerAssertions.Between(const aLowerBound, aUpperBound: Integer): Boolean;
  begin
    if Abs(aLowerBound - aUpperBound) < 2 then
      raise EInvalidTest.CreateFmt('Invalid lower (%d) and upper (%d) bounds to Integer.Between test (must allow a non-zero range between the lower and upper bounds)', [aLowerBound, aUpperBound]);

    if aUpperBound < aLowerBound then
      result := Between(aUpperBound, aLowerBound)
    else
      result := SetResult((fValue > aLowerBound) and (fValue < aUpperBound),
                          'Value is expected to be between %d and %d (exclusive) but is %d',
                          [aLowerBound, aUpperBound, fValue]);
  end;


  function TIntegerAssertions.Equals(const aExpected: Integer): Boolean;
  begin
    result := SetResult(fValue = aExpected,
                        'Value is expected to be %d but is %d',
                        [aExpected, fValue]);
  end;


  function TIntegerAssertions.GreaterThan(const aExpected: Integer): Boolean;
  begin
    result := SetResult(fValue > aExpected,
                        'Value is expected to be greater than %d but is %d',
                        [aExpected, fValue]);
  end;


  function TIntegerAssertions.InRange(const aMin, aMax: Integer): Boolean;
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


  function TIntegerAssertions.IsNegative: Boolean;
  begin
    result := SetResult(fValue < 0,
                        'Value is expected to be negative (< 0) but is %d',
                        [fValue]);
  end;


  function TIntegerAssertions.IsPositive: Boolean;
  begin
    result := SetResult(fValue > 0,
                        'Value is expected to be positive (> 0) but is %d',
                        [fValue]);
  end;


  function TIntegerAssertions.LessThan(const aExpected: Integer): Boolean;
  begin
    result := SetResult(fValue < aExpected,
                        'Value is expected to be less than %d but is %d',
                        [aExpected, fValue]);
  end;


  function TIntegerAssertions.LessThanOrEqualTo(const aExpected: Integer): Boolean;
  begin
    result := SetResult(fValue <= aExpected,
                        'Value is expected to be less than or equal to %d but is %d',
                        [aExpected, fValue]);
  end;


  function TIntegerAssertions.GreaterThanOrEqualTo(const aExpected: Integer): Boolean;
  begin
    result := SetResult(fValue >= aExpected,
                        'Value is expected to be greater than or equal to %d but is %d',
                        [aExpected, fValue]);
  end;



end.
