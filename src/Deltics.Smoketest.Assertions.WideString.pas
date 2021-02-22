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

  unit Deltics.Smoketest.Assertions.WideString;


interface

  uses
    Deltics.Smoketest.Assertions;


  type
    WideStringAssertions = interface
    ['{819314CB-486C-4DDA-81CE-C2FD837888B7}']
      function Contains(const aSubstring: WideString): AssertionResult; overload;
      function ContainsText(const aSubstring: WideString): AssertionResult; overload;
      function DoesNotContain(const aSubstring: WideString): AssertionResult; overload;
      function DoesNotContainText(const aSubstring: WideString): AssertionResult; overload;
      function Equals(const aExpected: WideString): AssertionResult;
      function EqualsText(const aExpected: WideString): AssertionResult;
      function IsEmpty: AssertionResult;
      function IsNotEmpty: AssertionResult;
    end;


    TWideStringAssertions = class(TAssertions, WideStringAssertions)
    private
      fValue: WideString;
    private
      function Contains(const aSubstring: WideString): AssertionResult; overload;
      function ContainsText(const aSubstring: WideString): AssertionResult; overload;
      function DoesNotContain(const aSubstring: WideString): AssertionResult; overload;
      function DoesNotContainText(const aSubstring: WideString): AssertionResult; overload;
      function Equals(const aExpected: WideString): AssertionResult; reintroduce;
      function EqualsText(const aExpected: WideString): AssertionResult;
      function IsEmpty: AssertionResult;
      function IsNotEmpty: AssertionResult;
    public
      constructor Create(const aTestName: String; const aValue: WideString);
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



{ TWideStringAssertions -------------------------------------------------------------------------- }

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  constructor TWideStringAssertions.Create(const aTestName: String;
                                           const aValue: WideString);
  begin
    inherited Create(aTestName, AsString(aValue));

    fValue := aValue;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TWideStringAssertions.Contains(const aSubstring: WideString): AssertionResult;
  begin
    FormatExpected(AsString(aSubstring));

    Description := Format('{valueName} contains {expected}');
    Failure     := Format('{valueWithName} does not contain {expected}');

    result := Assert(Pos(aSubstring, fValue) > 0);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TWideStringAssertions.ContainsText(const aSubstring: WideString): AssertionResult;
  begin
    FormatExpected(AsString(aSubstring));

    Description := Format('{valueName} contains {expected} (case insensitive)');
    Failure     := Format('{valueWithName} does not contain {expected} (case insensitive)');

    result := Assert(Pos(AnsiLowercase(aSubstring), AnsiLowercase(fValue)) > 0);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TWideStringAssertions.DoesNotContain(const aSubstring: WideString): AssertionResult;
  begin
    FormatExpected(AsString(aSubstring));

    Description := Format('{valueName} does not contain {expected}');
    Failure     := Format('{valueWithName} contains {expected}');

    result := Assert(Pos(aSubstring, fValue) = 0);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TWideStringAssertions.DoesNotContainText(const aSubstring: WideString): AssertionResult;
  begin
    FormatExpected(AsString(aSubstring));

    Description := Format('{valueName} does not contains {expected} (case insensitive)');
    Failure     := Format('{valueWithName} contains {expected} (case insensitive)');

    result := Assert(Pos(AnsiLowercase(aSubstring), AnsiLowercase(fValue)) = 0);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TWideStringAssertions.Equals(const aExpected: WideString): AssertionResult;
  begin
    FormatExpected(AsString(aExpected));

    Description := Format('{valueName} = {expected}');
    Failure     := Format('{valueWithName} should be {expected}');

    result := Assert(fValue = aExpected);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TWideStringAssertions.EqualsText(const aExpected: WideString): AssertionResult;
  begin
    FormatExpected(AsString(aExpected));

    Description := Format('{valueWithName} is the same text as {expected}');
    Failure     := Format('{valueWithName} is not the same text as {expected}');

    result := Assert(AnsiSameText(fValue, aExpected));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TWideStringAssertions.IsEmpty: AssertionResult;
  begin
    Description := Format('{valueName} is empty');
    Failure     := Format('{valueWithName} is not empty');

    result := Assert(fValue = '');
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TWideStringAssertions.IsNotEmpty: AssertionResult;
  begin
    Description := Format('{valueName} is not empty');
    Failure     := Format('{valueWithName} is empty');

    result := Assert(fValue <> '');
  end;







end.

