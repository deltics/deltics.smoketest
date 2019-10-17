
  unit Test.StringAssertions;

interface

  uses
    Deltics.Smoketest,
    Test.SelfTest;

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
    NextAssertExpectedToFail;
    Assert('AnsiString.Equals() fails when strings do not match', A).Equals(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.AnsiStringEqualsPassesWhenStringsAreExactMatch;
  const
    A: AnsiString = 'abc';
    B: AnsiString = 'abc';
  begin
    Assert('AnsiString.Equals() passes when strings are an exact match', A).Equals(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.AnsiStringEqualsTextFailsWhenStringsDifferByMoreThanCase;
  const
    A: AnsiString = 'abc';
    B: AnsiString = 'ABC!';
  begin
    NextAssertExpectedToFail;
    Assert('AnsiString.EqualsText() fails when strings differ by more than case', A).Equals(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.AnsiStringEqualsTextPassesWhenStringsAreExactMatch;
  const
    A: AnsiString = 'abc';
    B: AnsiString = 'abc';
  begin
    Assert('AnsiString.EqualsText() passes when strings are an exact match', A).EqualsText(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.AnsiStringEqualsTextPassesWhenStringsDifferOnlyInCase;
  const
    A: AnsiString = 'abc';
    B: AnsiString = 'ABC';
  begin
    Assert('AnsiString.EqualsText() passes when string differ only in case', A).EqualsText(B);
  end;


{$ifdef UNICODE}

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.UnicodeStringEqualsFailsWhenStringsAreNotAnExactMatch;
  const
    A: UnicodeString = 'abc';
    B: UnicodeString = 'def';
  begin
    NextAssertExpectedToFail;
    Assert('UnicodeString.Equals() fails when strings do not match', A).Equals(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.UnicodeStringEqualsPassesWhenStringsAreExactMatch;
  const
    A: UnicodeString = 'abc';
    B: UnicodeString = 'abc';
  begin
    Assert('UnicodeString.Equals() passes when strings are an exact match', A).Equals(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.UnicodeStringEqualsTextFailsWhenStringsDifferByMoreThanCase;
  const
    A: UnicodeString = 'abc';
    B: UnicodeString = 'ABC!';
  begin
    NextAssertExpectedToFail;
    Assert('UnicodeString.EqualsText() fails when strings differ by more than case', A).Equals(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.UnicodeStringEqualsTextPassesWhenStringsAreExactMatch;
  const
    A: UnicodeString = 'abc';
    B: UnicodeString = 'abc';
  begin
    Assert('UnicodeString.EqualsText() passes when strings are an exact match', A).EqualsText(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.UnicodeStringEqualsTextPassesWhenStringsDifferOnlyInCase;
  const
    A: UnicodeString = 'abc';
    B: UnicodeString = 'ABC';
  begin
    Assert('UnicodeString.EqualsText() passes when string differ only in case', A).EqualsText(B);
  end;

{$endif}


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.WideStringEqualsFailsWhenStringsAreNotAnExactMatch;
  const
    A: WideString = 'abc';
    B: WideString = 'def';
  begin
    NextAssertExpectedToFail;
    Assert('WideString.Equals() fails when strings do not match', A).Equals(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.WideStringEqualsPassesWhenStringsAreExactMatch;
  const
    A: WideString = 'abc';
    B: WideString = 'abc';
  begin
    Assert('WideString.Equals() passes when strings are an exact match', A).Equals(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.WideStringEqualsTextFailsWhenStringsDifferByMoreThanCase;
  const
    A: WideString = 'abc';
    B: WideString = 'ABC!';
  begin
    NextAssertExpectedToFail;
    Assert('WideString.EqualsText() fails when strings differ by more than case', A).Equals(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.WideStringEqualsTextPassesWhenStringsAreExactMatch;
  const
    A: WideString = 'abc';
    B: WideString = 'abc';
  begin
    Assert('WideString.EqualsText() passes when strings are an exact match', A).EqualsText(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.WideStringEqualsTextPassesWhenStringsDifferOnlyInCase;
  const
    A: WideString = 'abc';
    B: WideString = 'ABC';
  begin
    Assert('WideString.EqualsText() passes when string differ only in case', A).EqualsText(B);
  end;


end.
