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

  unit Deltics.Smoketest.Assertions.WideChar;


interface

  uses
    Deltics.Smoketest.Assertions;


  type
    WideCharAssertions = interface
    ['{819314CB-486C-4DDA-81CE-C2FD837888B7}']
      function Equals(const aExpected: WideChar): AssertionResult;
      function EqualsText(const aExpected: WideChar): AssertionResult;
      function IsHiSurrogate: AssertionResult;
      function IsLoSurrogate: AssertionResult;
      function IsNotSurrogate: AssertionResult;
      function IsNull: AssertionResult;
      function IsNotNull: AssertionResult;
    end;


    TWideCharAssertions = class(TAssertions, WideCharAssertions)
    private
      fValue: WideChar;
    private
      function Equals(const aExpected: WideChar): AssertionResult; reintroduce;
      function EqualsText(const aExpected: WideChar): AssertionResult;
      function IsHiSurrogate: AssertionResult;
      function IsLoSurrogate: AssertionResult;
      function IsNotSurrogate: AssertionResult;
      function IsNull: AssertionResult;
      function IsNotNull: AssertionResult;
    public
      constructor Create(const aTestName: String; const aValue: WideChar);
    end;



implementation

  uses
    SysUtils,
  {$ifdef DELPHI2006__}
    {$ifdef __DELPHI2009}
      Windows,
    {$endif}
  {$endif}
    Deltics.Smoketest.Utils;



{ TWideCharAssertions -------------------------------------------------------------------------- }

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  constructor TWideCharAssertions.Create(const aTestName: String;
                                         const aValue: WideChar);
  begin
    inherited Create(aTestName, AsString(aValue));

    fValue := aValue;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TWideCharAssertions.Equals(const aExpected: WideChar): AssertionResult;
  begin
    FormatExpected(AsString(aExpected));

    Description := Format('{valueName} = {expected}');
    Failure     := Format('{valueWithName} should be {expected}');

    result := Assert(fValue = aExpected);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TWideCharAssertions.EqualsText(const aExpected: WideChar): AssertionResult;
  begin
    FormatExpected(AsString(aExpected));

    Description := Format('{valueWithName} is the same text as {expected}');
    Failure     := Format('{valueWithName} is not the same text as {expected}');

    result := Assert(AnsiSameText(fValue, aExpected));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TWideCharAssertions.IsHiSurrogate: AssertionResult;
  begin
    Description := Format('{valueName} is high surrogate');
    Failure     := Format('{valueWithName} is not high surrogate');

    result := Assert((fValue >= #$d800) and (fValue <= #$dbff));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TWideCharAssertions.IsLoSurrogate: AssertionResult;
  begin
    Description := Format('{valueName} is low surrogate');
    Failure     := Format('{valueWithName} is not low surrogate');

    result := Assert((fValue >= #$dc00) and (fValue <= #$dfff));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TWideCharAssertions.IsNotSurrogate: AssertionResult;
  begin
    Description := Format('{valueName} is not surrogate');
    Failure     := Format('{valueWithName} is high/low surrogate');

    result := Assert((fValue < #$d800) or (fValue > #$dfff));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TWideCharAssertions.IsNull: AssertionResult;
  begin
    Description := Format('{valueName} is null');
    Failure     := Format('{valueWithName} is not null');

    result := Assert(fValue = #$0000);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TWideCharAssertions.IsNotNull: AssertionResult;
  begin
    Description := Format('{valueName} is not null');
    Failure     := Format('{valueWithName} is null');

    result := Assert(fValue <> #$0000);
  end;







end.

