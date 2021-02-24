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

  unit Test.CharAssertions;


interface

  uses
    Deltics.Smoketest,
    SelfTest;


  type
    TCharAssertions = class(TSelfTest)
      procedure Utf8CharEquals;
      procedure Utf8CharEqualsText;
      procedure WideCharEqualsIsTrueWhenCharsAreEqual;
      procedure WideCharIsHiSurrogateIsTrueWhenCharIsHiSurrogate;
      procedure WideCharIsLoSurrogateIsTrueWhenCharIsHiSurrogate;
      procedure WideCharIsNotSurrogateIsTrueWhenCharIsNotASurrogate;
    end;



implementation

  uses
    Deltics.Smoketest.Types;

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCharAssertions.Utf8CharEquals;
  begin
    AssertUtf8('a').Equals('a');
    AssertUtf8('A').Equals('A');

    AssertUtf8('z').Equals('z');
    AssertUtf8('Z').Equals('Z');

    AssertUtf8('@').Equals('@');
    AssertUtf8('[').Equals('[');

    Test.IsExpectedToFail;
    AssertUtf8('a').Equals('A');

    Test.IsExpectedToFail;
    AssertUtf8('z').Equals('Z');

    Test.IsExpectedToFail;
    AssertUtf8('@').Equals('`');

    Test.IsExpectedToFail;
    AssertUtf8('[').Equals('(');
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCharAssertions.Utf8CharEqualsText;
  begin
    AssertUtf8('a').EqualsText('a');
    AssertUtf8('a').EqualsText('A');
    AssertUtf8('A').EqualsText('A');

    AssertUtf8('z').EqualsText('z');
    AssertUtf8('z').EqualsText('Z');
    AssertUtf8('Z').EqualsText('Z');

    AssertUtf8('@').EqualsText('@');
    AssertUtf8('[').EqualsText('[');

    Test.IsExpectedToFail;
    AssertUtf8('@').EqualsText('`');

    Test.IsExpectedToFail;
    AssertUtf8('[').EqualsText('(');
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCharAssertions.WideCharEqualsIsTrueWhenCharsAreEqual;
  begin
    Assert(#$00a9).Equals(#$00a9);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCharAssertions.WideCharIsHiSurrogateIsTrueWhenCharIsHiSurrogate;
  begin
    Assert(#$d800).IsHiSurrogate;
    Assert(#$daaa).IsHiSurrogate;
    Assert(#$dbff).IsHiSurrogate;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCharAssertions.WideCharIsLoSurrogateIsTrueWhenCharIsHiSurrogate;
  begin
    Assert(#$dc00).IsLoSurrogate;
    Assert(#$dddd).IsLoSurrogate;
    Assert(#$dfff).IsLoSurrogate;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCharAssertions.WideCharIsNotSurrogateIsTrueWhenCharIsNotASurrogate;
  begin
    Assert(WideChar(#$0000)).IsNotSurrogate;
    Assert(WideChar(#$0001)).IsNotSurrogate;
    Assert(WideChar(#$00a9)).IsNotSurrogate;
    Assert(#$d7ff).IsNotSurrogate;
    Assert(#$e000).IsNotSurrogate;
    Assert(#$888).IsNotSurrogate;
    Assert(#$ffff).IsNotSurrogate;
  end;



end.
