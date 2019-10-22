
  unit Test.StringAssertions;

interface

  uses
    Deltics.Smoketest;

  type
    TStringTests = class(TSelfTest)
      procedure AnsiStringEqualsPassesWhenStringsAreExactMatch;
      procedure AnsiStringEqualsFailsWhenStringsAreNotAnExactMatch;
      procedure AnsiStringEqualsTextPassesWhenStringsAreExactMatch;
      procedure AnsiStringEqualsTextPassesWhenStringsDifferOnlyInCase;
      procedure AnsiStringEqualsTextFailsWhenStringsDifferByMoreThanCase;
    {$ifdef UNICODE}
      procedure UnicodeStringEqualsPassesWhenStringsAreExactMatch;
      procedure UnicodeStringEqualsFailsWhenStringsAreNotAnExactMatch;
      procedure UnicodeStringEqualsTextPassesWhenStringsAreExactMatch;
      procedure UnicodeStringEqualsTextPassesWhenStringsDifferOnlyInCase;
      procedure UnicodeStringEqualsTextFailsWhenStringsDifferByMoreThanCase;
    {$endif}
      procedure WideStringEqualsPassesWhenStringsAreExactMatch;
      procedure WideStringEqualsFailsWhenStringsAreNotAnExactMatch;
      procedure WideStringEqualsTextPassesWhenStringsAreExactMatch;
      procedure WideStringEqualsTextPassesWhenStringsDifferOnlyInCase;
      procedure WideStringEqualsTextFailsWhenStringsDifferByMoreThanCase;
    end;



implementation

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.AnsiStringEqualsFailsWhenStringsAreNotAnExactMatch;
  const
    A: AnsiString = 'abc';
    B: AnsiString = 'def';
  begin
    AllAssertsExpectedToFail;
    Assert(A).Equals(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.AnsiStringEqualsPassesWhenStringsAreExactMatch;
  const
    A: AnsiString = 'abc';
    B: AnsiString = 'abc';
  begin
    Assert(A).Equals(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.AnsiStringEqualsTextFailsWhenStringsDifferByMoreThanCase;
  const
    A: AnsiString = 'abc';
    B: AnsiString = 'ABC!';
  begin
    AllAssertsExpectedToFail;
    Assert(A).Equals(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.AnsiStringEqualsTextPassesWhenStringsAreExactMatch;
  const
    A: AnsiString = 'abc';
    B: AnsiString = 'abc';
  begin
    Assert(A).EqualsText(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.AnsiStringEqualsTextPassesWhenStringsDifferOnlyInCase;
  const
    A: AnsiString = 'abc';
    B: AnsiString = 'ABC';
  begin
    Assert(A).EqualsText(B);
  end;


{$ifdef UNICODE}

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.UnicodeStringEqualsFailsWhenStringsAreNotAnExactMatch;
  const
    A: UnicodeString = 'abc';
    B: UnicodeString = 'def';
  begin
    AllAssertsExpectedToFail;
    Assert(A).Equals(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.UnicodeStringEqualsPassesWhenStringsAreExactMatch;
  const
    A: UnicodeString = 'abc';
    B: UnicodeString = 'abc';
  begin
    Assert(A).Equals(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.UnicodeStringEqualsTextFailsWhenStringsDifferByMoreThanCase;
  const
    A: UnicodeString = 'abc';
    B: UnicodeString = 'ABC!';
  begin
    AllAssertsExpectedToFail;
    Assert(A).Equals(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.UnicodeStringEqualsTextPassesWhenStringsAreExactMatch;
  const
    A: UnicodeString = 'abc';
    B: UnicodeString = 'abc';
  begin
    Assert(A).EqualsText(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.UnicodeStringEqualsTextPassesWhenStringsDifferOnlyInCase;
  const
    A: UnicodeString = 'abc';
    B: UnicodeString = 'ABC';
  begin
    Assert(A).EqualsText(B);
  end;

{$endif}


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.WideStringEqualsFailsWhenStringsAreNotAnExactMatch;
  const
    A: WideString = 'abc';
    B: WideString = 'def';
  begin
    AllAssertsExpectedToFail;
    Assert(A).Equals(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.WideStringEqualsPassesWhenStringsAreExactMatch;
  const
    A: WideString = 'abc';
    B: WideString = 'abc';
  begin
    Assert(A).Equals(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.WideStringEqualsTextFailsWhenStringsDifferByMoreThanCase;
  const
    A: WideString = 'abc';
    B: WideString = 'ABC!';
  begin
    AllAssertsExpectedToFail;
    Assert(A).Equals(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.WideStringEqualsTextPassesWhenStringsAreExactMatch;
  const
    A: WideString = 'abc';
    B: WideString = 'abc';
  begin
    Assert(A).EqualsText(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.WideStringEqualsTextPassesWhenStringsDifferOnlyInCase;
  const
    A: WideString = 'abc';
    B: WideString = 'ABC';
  begin
    Assert(A).EqualsText(B);
  end;


end.