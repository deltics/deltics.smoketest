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



end.
