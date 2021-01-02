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

  unit Test.StringAssertions;


interface

  uses
    Deltics.Smoketest,
    SelfTest;


  type
    TStringTests = class(TSelfTest)
      procedure AnsiStringEqualsPassesWhenStringsAreExactMatch;
      procedure AnsiStringEqualsFailsWhenStringsAreNotAnExactMatch;
      procedure AnsiStringEqualsTextPassesWhenStringsAreExactMatch;
      procedure AnsiStringEqualsTextPassesWhenStringsDifferOnlyInCase;
      procedure AnsiStringEqualsTextFailsWhenStringsDifferByMoreThanCase;
      procedure AnsiStringContainsFailsWhenStringDoesNotContainSubstring;
      procedure AnsiStringContainsFailsWhenStringContainsSubstringInDifferentCase;
      procedure AnsiStringContainsPassesWhenStringContainsSubstringInSameCase;
      procedure AnsiStringContainsTextFailsWhenStringDoesNotContainSubstring;
      procedure AnsiStringContainsTextPassesWhenStringContainsSubstringInDifferentCase;
      procedure AnsiStringContainsTextPassesWhenStringContainsSubstringInSameCase;
      procedure AnsiStringDoesNotContainFailsWhenStringContainsSubstringInSameCase;
      procedure AnsiStringDoesNotContainPassesWhenStringContainsSubstringInDifferentCase;
      procedure AnsiStringDoesNotContainPassesWhenStringDoesNotContainsSubstring;
      procedure AnsiStringDoesNotContainTextFailsWhenStringContainsSubstringInSameCase;
      procedure AnsiStringDoesNotContainTextFailsWhenStringContainsSubstringInDifferentCase;
      procedure AnsiStringDoesNotContainTextPassesWhenStringDoesNotContainsSubstring;
      procedure AnsiStringIsEmptyFailsWhenStringIsNotEmpty;
      procedure AnsiStringIsEmptyPassesWhenStringIsEmpty;
      procedure AnsiStringIsNotEmptyFailsWhenStringIsEmpty;
      procedure AnsiStringIsNotEmptyPassesWhenStringIsNotEmpty;
    {$ifdef UNICODE}
      procedure UnicodeStringEqualsPassesWhenStringsAreExactMatch;
      procedure UnicodeStringEqualsFailsWhenStringsAreNotAnExactMatch;
      procedure UnicodeStringEqualsTextPassesWhenStringsAreExactMatch;
      procedure UnicodeStringEqualsTextPassesWhenStringsDifferOnlyInCase;
      procedure UnicodeStringEqualsTextFailsWhenStringsDifferByMoreThanCase;
      procedure UnicodeStringContainsFailsWhenStringDoesNotContainSubstring;
      procedure UnicodeStringContainsFailsWhenStringContainsSubstringInDifferentCase;
      procedure UnicodeStringContainsPassesWhenStringContainsSubstringInSameCase;
      procedure UnicodeStringContainsTextFailsWhenStringDoesNotContainSubstring;
      procedure UnicodeStringContainsTextPassesWhenStringContainsSubstringInDifferentCase;
      procedure UnicodeStringContainsTextPassesWhenStringContainsSubstringInSameCase;
      procedure UnicodeStringDoesNotContainFailsWhenStringContainsSubstringInSameCase;
      procedure UnicodeStringDoesNotContainPassesWhenStringContainsSubstringInDifferentCase;
      procedure UnicodeStringDoesNotContainPassesWhenStringDoesNotContainsSubstring;
      procedure UnicodeStringDoesNotContainTextFailsWhenStringContainsSubstringInSameCase;
      procedure UnicodeStringDoesNotContainTextFailsWhenStringContainsSubstringInDifferentCase;
      procedure UnicodeStringDoesNotContainTextPassesWhenStringDoesNotContainsSubstring;
      procedure UnicodeStringIsEmptyFailsWhenStringIsNotEmpty;
      procedure UnicodeStringIsEmptyPassesWhenStringIsEmpty;
      procedure UnicodeStringIsNotEmptyFailsWhenStringIsEmpty;
      procedure UnicodeStringIsNotEmptyPassesWhenStringIsNotEmpty;
    {$endif}
      procedure WideStringEqualsPassesWhenStringsAreExactMatch;
      procedure WideStringEqualsFailsWhenStringsAreNotAnExactMatch;
      procedure WideStringEqualsTextPassesWhenStringsAreExactMatch;
      procedure WideStringEqualsTextPassesWhenStringsDifferOnlyInCase;
      procedure WideStringEqualsTextFailsWhenStringsDifferByMoreThanCase;
      procedure WideStringContainsFailsWhenStringDoesNotContainSubstring;
      procedure WideStringContainsFailsWhenStringContainsSubstringInDifferentCase;
      procedure WideStringContainsPassesWhenStringContainsSubstringInSameCase;
      procedure WideStringContainsTextFailsWhenStringDoesNotContainSubstring;
      procedure WideStringContainsTextPassesWhenStringContainsSubstringInDifferentCase;
      procedure WideStringContainsTextPassesWhenStringContainsSubstringInSameCase;
      procedure WideStringDoesNotContainFailsWhenStringContainsSubstringInSameCase;
      procedure WideStringDoesNotContainPassesWhenStringContainsSubstringInDifferentCase;
      procedure WideStringDoesNotContainPassesWhenStringDoesNotContainsSubstring;
      procedure WideStringDoesNotContainTextFailsWhenStringContainsSubstringInSameCase;
      procedure WideStringDoesNotContainTextFailsWhenStringContainsSubstringInDifferentCase;
      procedure WideStringDoesNotContainTextPassesWhenStringDoesNotContainsSubstring;
      procedure WideStringIsEmptyFailsWhenStringIsNotEmpty;
      procedure WideStringIsEmptyPassesWhenStringIsEmpty;
      procedure WideStringIsNotEmptyFailsWhenStringIsEmpty;
      procedure WideStringIsNotEmptyPassesWhenStringIsNotEmpty;
    end;



implementation

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.AnsiStringContainsFailsWhenStringContainsSubstringInDifferentCase;
  const
    A: AnsiString = 'the fox';
    B: AnsiString = 'FOX';
  begin
    Test.IsExpectedToFail;

    Assert(A).Contains(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.AnsiStringContainsFailsWhenStringDoesNotContainSubstring;
  const
    A: AnsiString = 'the fox';
    B: AnsiString = 'wolf';
  begin
    Test.IsExpectedToFail;

    Assert(A).Contains(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.AnsiStringContainsPassesWhenStringContainsSubstringInSameCase;
  const
    A: AnsiString = 'the fox';
    B: AnsiString = 'fox';
  begin
    Assert(A).Contains(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.AnsiStringContainsTextFailsWhenStringDoesNotContainSubstring;
  const
    A: AnsiString = 'the fox';
    B: AnsiString = 'wolf';
  begin
    Test.IsExpectedToFail;

    Assert(A).ContainsText(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.AnsiStringContainsTextPassesWhenStringContainsSubstringInDifferentCase;
  const
    A: AnsiString = 'the fox';
    B: AnsiString = 'FOX';
  begin
    Assert(A).ContainsText(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.AnsiStringContainsTextPassesWhenStringContainsSubstringInSameCase;
  const
    A: AnsiString = 'the fox';
    B: AnsiString = 'fox';
  begin
    Assert(A).ContainsText(B);
  end;



  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.AnsiStringDoesNotContainFailsWhenStringContainsSubstringInSameCase;
  const
    A: AnsiString = 'the fox';
    B: AnsiString = 'fox';
  begin
    Test.IsExpectedToFail;

    Assert(A).DoesNotContain(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.AnsiStringDoesNotContainPassesWhenStringContainsSubstringInDifferentCase;
  const
    A: AnsiString = 'the fox';
    B: AnsiString = 'FOX';
  begin
    Assert(A).DoesNotContain(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.AnsiStringDoesNotContainPassesWhenStringDoesNotContainsSubstring;
  const
    A: AnsiString = 'the fox';
    B: AnsiString = 'wolf';
  begin
    Assert(A).DoesNotContain(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.AnsiStringDoesNotContainTextFailsWhenStringContainsSubstringInDifferentCase;
  const
    A: AnsiString = 'the fox';
    B: AnsiString = 'FOX';
  begin
    Test.IsExpectedToFail;

    Assert(A).DoesNotContain(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.AnsiStringDoesNotContainTextFailsWhenStringContainsSubstringInSameCase;
  const
    A: AnsiString = 'the fox';
    B: AnsiString = 'fox';
  begin
    Test.IsExpectedToFail;

    Assert(A).DoesNotContain(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.AnsiStringDoesNotContainTextPassesWhenStringDoesNotContainsSubstring;
  const
    A: AnsiString = 'the fox';
    B: AnsiString = 'wolf';
  begin
    Assert(A).DoesNotContain(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.AnsiStringEqualsFailsWhenStringsAreNotAnExactMatch;
  const
    A: AnsiString = 'abc';
    B: AnsiString = 'def';
  begin
    Test.IsExpectedToFail;

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
    Test.IsExpectedToFail;

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


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.AnsiStringIsEmptyFailsWhenStringIsNotEmpty;
  const
    A: AnsiString = 'foo';
  begin
    Test.IsExpectedToFail;

    Assert(A).IsEmpty;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.AnsiStringIsEmptyPassesWhenStringIsEmpty;
  const
    A: AnsiString = '';
  begin
    Assert(A).IsEmpty;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.AnsiStringIsNotEmptyFailsWhenStringIsEmpty;
  const
    A: AnsiString = '';
  begin
    Test.IsExpectedToFail;

    Assert(A).IsNotEmpty;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.AnsiStringIsNotEmptyPassesWhenStringIsNotEmpty;
  const
    A: AnsiString = 'foo';
  begin
    Assert(A).IsNotEmpty;
  end;



{$ifdef UNICODE}

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.UnicodeStringEqualsFailsWhenStringsAreNotAnExactMatch;
  const
    A: UnicodeString = 'abc';
    B: UnicodeString = 'def';
  begin
    Test.IsExpectedToFail;

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
    Test.IsExpectedToFail;
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


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.UnicodeStringContainsFailsWhenStringContainsSubstringInDifferentCase;
  const
    A: UnicodeString = 'the fox';
    B: UnicodeString = 'FOX';
  begin
    Test.IsExpectedToFail;

    Assert(A).Contains(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.UnicodeStringContainsFailsWhenStringDoesNotContainSubstring;
  const
    A: UnicodeString = 'the fox';
    B: UnicodeString = 'wolf';
  begin
    Test.IsExpectedToFail;

    Assert(A).Contains(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.UnicodeStringContainsPassesWhenStringContainsSubstringInSameCase;
  const
    A: UnicodeString = 'the fox';
    B: UnicodeString = 'fox';
  begin
    Assert(A).Contains(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.UnicodeStringContainsTextFailsWhenStringDoesNotContainSubstring;
  const
    A: UnicodeString = 'the fox';
    B: UnicodeString = 'wolf';
  begin
    Test.IsExpectedToFail;

    Assert(A).ContainsText(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.UnicodeStringContainsTextPassesWhenStringContainsSubstringInDifferentCase;
  const
    A: UnicodeString = 'the fox';
    B: UnicodeString = 'FOX';
  begin
    Assert(A).ContainsText(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.UnicodeStringContainsTextPassesWhenStringContainsSubstringInSameCase;
  const
    A: UnicodeString = 'the fox';
    B: UnicodeString = 'fox';
  begin
    Assert(A).ContainsText(B);
  end;



  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.UnicodeStringDoesNotContainFailsWhenStringContainsSubstringInSameCase;
  const
    A: UnicodeString = 'the fox';
    B: UnicodeString = 'fox';
  begin
    Test.IsExpectedToFail;

    Assert(A).DoesNotContain(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.UnicodeStringDoesNotContainPassesWhenStringContainsSubstringInDifferentCase;
  const
    A: UnicodeString = 'the fox';
    B: UnicodeString = 'FOX';
  begin
    Assert(A).DoesNotContain(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.UnicodeStringDoesNotContainPassesWhenStringDoesNotContainsSubstring;
  const
    A: UnicodeString = 'the fox';
    B: UnicodeString = 'wolf';
  begin
    Assert(A).DoesNotContain(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.UnicodeStringDoesNotContainTextFailsWhenStringContainsSubstringInDifferentCase;
  const
    A: UnicodeString = 'the fox';
    B: UnicodeString = 'FOX';
  begin
    Test.IsExpectedToFail;

    Assert(A).DoesNotContain(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.UnicodeStringDoesNotContainTextFailsWhenStringContainsSubstringInSameCase;
  const
    A: UnicodeString = 'the fox';
    B: UnicodeString = 'fox';
  begin
    Test.IsExpectedToFail;

    Assert(A).DoesNotContain(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.UnicodeStringDoesNotContainTextPassesWhenStringDoesNotContainsSubstring;
  const
    A: UnicodeString = 'the fox';
    B: UnicodeString = 'wolf';
  begin
    Assert(A).DoesNotContain(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.UnicodeStringIsEmptyFailsWhenStringIsNotEmpty;
  const
    A: UnicodeString = 'foo';
  begin
    Test.IsExpectedToFail;

    Assert(A).IsEmpty;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.UnicodeStringIsEmptyPassesWhenStringIsEmpty;
  const
    A: UnicodeString = '';
  begin
    Assert(A).IsEmpty;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.UnicodeStringIsNotEmptyFailsWhenStringIsEmpty;
  const
    A: UnicodeString = '';
  begin
    Test.IsExpectedToFail;

    Assert(A).IsNotEmpty;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.UnicodeStringIsNotEmptyPassesWhenStringIsNotEmpty;
  const
    A: UnicodeString = 'foo';
  begin
    Assert(A).IsNotEmpty;
  end;


{$endif}


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.WideStringEqualsFailsWhenStringsAreNotAnExactMatch;
  const
    A: WideString = 'abc';
    B: WideString = 'def';
  begin
    Test.IsExpectedToFail;

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
    Test.IsExpectedToFail;

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


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.WideStringContainsFailsWhenStringContainsSubstringInDifferentCase;
  const
    A: WideString = 'the fox';
    B: WideString = 'FOX';
  begin
    Test.IsExpectedToFail;

    Assert(A).Contains(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.WideStringContainsFailsWhenStringDoesNotContainSubstring;
  const
    A: WideString = 'the fox';
    B: WideString = 'wolf';
  begin
    Test.IsExpectedToFail;

    Assert(A).Contains(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.WideStringContainsPassesWhenStringContainsSubstringInSameCase;
  const
    A: WideString = 'the fox';
    B: WideString = 'fox';
  begin
    Assert(A).Contains(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.WideStringContainsTextFailsWhenStringDoesNotContainSubstring;
  const
    A: WideString = 'the fox';
    B: WideString = 'wolf';
  begin
    Test.IsExpectedToFail;

    Assert(A).ContainsText(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.WideStringContainsTextPassesWhenStringContainsSubstringInDifferentCase;
  const
    A: WideString = 'the fox';
    B: WideString = 'FOX';
  begin
    Assert(A).ContainsText(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.WideStringContainsTextPassesWhenStringContainsSubstringInSameCase;
  const
    A: WideString = 'the fox';
    B: WideString = 'fox';
  begin
    Assert(A).ContainsText(B);
  end;



  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.WideStringDoesNotContainFailsWhenStringContainsSubstringInSameCase;
  const
    A: WideString = 'the fox';
    B: WideString = 'fox';
  begin
    Test.IsExpectedToFail;

    Assert(A).DoesNotContain(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.WideStringDoesNotContainPassesWhenStringContainsSubstringInDifferentCase;
  const
    A: WideString = 'the fox';
    B: WideString = 'FOX';
  begin
    Assert(A).DoesNotContain(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.WideStringDoesNotContainPassesWhenStringDoesNotContainsSubstring;
  const
    A: WideString = 'the fox';
    B: WideString = 'wolf';
  begin
    Assert(A).DoesNotContain(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.WideStringDoesNotContainTextFailsWhenStringContainsSubstringInDifferentCase;
  const
    A: WideString = 'the fox';
    B: WideString = 'FOX';
  begin
    Test.IsExpectedToFail;

    Assert(A).DoesNotContain(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.WideStringDoesNotContainTextFailsWhenStringContainsSubstringInSameCase;
  const
    A: WideString = 'the fox';
    B: WideString = 'fox';
  begin
    Test.IsExpectedToFail;

    Assert(A).DoesNotContain(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.WideStringDoesNotContainTextPassesWhenStringDoesNotContainsSubstring;
  const
    A: WideString = 'the fox';
    B: WideString = 'wolf';
  begin
    Assert(A).DoesNotContain(B);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.WideStringIsEmptyFailsWhenStringIsNotEmpty;
  const
    A: WideString = 'foo';
  begin
    Test.IsExpectedToFail;

    Assert(A).IsEmpty;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.WideStringIsEmptyPassesWhenStringIsEmpty;
  const
    A: WideString = '';
  begin
    Assert(A).IsEmpty;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.WideStringIsNotEmptyFailsWhenStringIsEmpty;
  const
    A: WideString = '';
  begin
    Test.IsExpectedToFail;

    Assert(A).IsNotEmpty;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TStringTests.WideStringIsNotEmptyPassesWhenStringIsNotEmpty;
  const
    A: WideString = 'foo';
  begin
    Assert(A).IsNotEmpty;
  end;





end.
