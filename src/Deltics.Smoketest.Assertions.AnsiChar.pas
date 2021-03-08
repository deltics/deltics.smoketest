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

  unit Deltics.Smoketest.Assertions.AnsiChar;


interface

  uses
    Deltics.Smoketest.Assertions;


  type
    AnsiCharAssertions = interface
    ['{8FD22B51-B61B-49F2-9681-4453F569F16D}']
      function Equals(const aExpected: AnsiChar): AssertionResult;
      function EqualsText(const aExpected: AnsiChar): AssertionResult;
      function IsNull: AssertionResult;
      function IsNotNull: AssertionResult;
    end;


    TAnsiCharAssertions = class(TAssertions, AnsiCharAssertions)
    private
      fValue: AnsiChar;
    private
      function Equals(const aExpected: AnsiChar): AssertionResult; reintroduce;
      function EqualsText(const aExpected: AnsiChar): AssertionResult;
      function IsNull: AssertionResult;
      function IsNotNull: AssertionResult;
    public
      constructor Create(const aTestName: String; const aValue: AnsiChar);
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



{ TAnsiCharAssertions -------------------------------------------------------------------------- }

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  constructor TAnsiCharAssertions.Create(const aTestName: String;
                                         const aValue: AnsiChar);
  begin
    inherited Create(aTestName, AsString(aValue));

    fValue := aValue;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TAnsiCharAssertions.Equals(const aExpected: AnsiChar): AssertionResult;
  begin
    FormatExpected(AsString(aExpected));

    Description := Format('{valueName} = {expected}');
    Failure     := Format('{valueWithName} should be {expected}');

    result := Assert(fValue = aExpected);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TAnsiCharAssertions.EqualsText(const aExpected: AnsiChar): AssertionResult;
  begin
    FormatExpected(AsString(aExpected));

    Description := Format('{valueWithName} is the same text as {expected}');
    Failure     := Format('{valueWithName} is not the same text as {expected}');

    case fValue of
      #65..#91,
      #97..#123 : result := Assert((Ord(fValue) xor 32) = (Ord(aExpected) xor 32));
    else
      result := Assert(fValue = aExpected);
    end;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TAnsiCharAssertions.IsNull: AssertionResult;
  begin
    Description := Format('{valueName} is null');
    Failure     := Format('{valueWithName} is not null');

    result := Assert(fValue = #$0000);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TAnsiCharAssertions.IsNotNull: AssertionResult;
  begin
    Description := Format('{valueName} is not null');
    Failure     := Format('{valueWithName} is null');

    result := Assert(fValue <> #$0000);
  end;







end.

