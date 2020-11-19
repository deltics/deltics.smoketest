
{$i deltics.smoketest.inc}

  unit Test.DateAssertions;


interface

  uses
    Deltics.Smoketest;


  type
    TDateAssertionTests = class (TTest)
      procedure AssertingOverATDateYieldsDateAssertionFactory;
      procedure AssertingOverATDatetimeYieldsDatetimeAssertionFactory;
    end;


implementation

  uses
  {$ifdef __DELPHI2007}
    Controls,
  {$endif}
    SysUtils,
    Deltics.Smoketest.Assertions.Date,
    Deltics.Smoketest.Assertions.Datetime;



{ TDateAssertionTests }

  procedure TDateAssertionTests.AssertingOverATDateYieldsDateAssertionFactory;
  var
    dt: TDate;
    assertions: IUnknown;
    notUsed: DateAssertions;
  begin
    dt := EncodeDate(2020, 2, 20);

  {$ifdef EnhancedOverloads}
    assertions := Test('test').Assert(dt);
  {$else}
    assertions := Test('test').AssertDate(dt);
  {$endif}

    Test('assertions').Assert(Supports(assertions, DateAssertions, notUsed));
  end;


  procedure TDateAssertionTests.AssertingOverATDatetimeYieldsDatetimeAssertionFactory;
  var
    dt: TDatetime;
    assertions: IUnknown;
    notUsed: DatetimeAssertions;
  begin
    dt := EncodeDate(2020, 2, 20) + EncodeTime(2, 2, 2, 0);

  {$ifdef EnhancedOverloads}
    assertions := Test('test').Assert(dt);
  {$else}
    assertions := Test('test').AssertDatetime(dt);
  {$endif}

    Test('assertions').Assert(Supports(assertions, DatetimeAssertions, notUsed));
  end;



end.
