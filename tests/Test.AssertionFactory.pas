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

  unit Test.AssertionFactory;


interface

  uses
    Deltics.Smoketest,
    SelfTest;


  type
    TAssertionFactoryTests = class(TSelfTest)
      procedure AssertOverTDateYieldsCorrectAssertions;
      procedure AssertOverTDatetimeYieldsCorrectAssertions;
      procedure AssertOverAnsiStringYieldsCorrectAssertions;
    {$ifdef UNICODE}
      procedure AssertOverUnicodeStringYieldsCorrectAssertions;
    {$endif}
      procedure AssertOverWideStringYieldsCorrectAssertions;
    end;


implementation

  uses
  {$ifdef __DELPHI2007} // TDate declared in Controls in Delphi 2007 and earlier
    Controls,
  {$endif}
    SysUtils,
    Deltics.Smoketest.Assertions.Date,
    Deltics.Smoketest.Assertions.DateTime,
    Deltics.Smoketest.Assertions.Int64,
    Deltics.Smoketest.Assertions.Integer,
    Deltics.Smoketest.Assertions.AnsiString,
  {$ifdef UNICODE}
    Deltics.Smoketest.Assertions.UnicodeString,
  {$endif}
    Deltics.Smoketest.Assertions.WideString;



  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TAssertionFactoryTests.AssertOverTDateYieldsCorrectAssertions;
  var
    dt: TDate;
    assertions: IUnknown;
  begin
    dt := Now;

  {$ifdef EnhancedOverloads}
    assertions := Assert(dt);
  {$else}
    assertions := AssertDate(dt);
  {$endif}

    Assert(Supports(assertions, DateAssertions));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TAssertionFactoryTests.AssertOverTDatetimeYieldsCorrectAssertions;
  var
    dt: TDatetime;
    assertions: IUnknown;
  begin
    dt := Now;

  {$ifdef EnhancedOverloads}
    assertions := Assert(dt);
  {$else}
    assertions := AssertDatetime(dt);
  {$endif}

    Assert(Supports(assertions, DatetimeAssertions));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TAssertionFactoryTests.AssertOverAnsiStringYieldsCorrectAssertions;
  var
    s: AnsiString;
    assertions: IUnknown;
  begin
    assertions := Assert(s);

    Assert(Supports(assertions, AnsiStringAssertions));
  end;


{$ifdef UNICODE}
  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TAssertionFactoryTests.AssertOverUnicodeStringYieldsCorrectAssertions;
  var
    s: UnicodeString;
    assertions: IUnknown;
  begin
    assertions := Assert(s);

    Assert(Supports(assertions, UnicodeStringAssertions));
  end;
{$endif}


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TAssertionFactoryTests.AssertOverWideStringYieldsCorrectAssertions;
  var
    s: WideString;
    assertions: IUnknown;
  begin
    assertions := Assert(s);

    Assert(Supports(assertions, WideStringAssertions));
  end;




end.
