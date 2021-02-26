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

  unit Deltics.Smoketest.Assertions.Utf8Char;


interface

  uses
    Deltics.Smoketest.Assertions,
    Deltics.Smoketest.Types;


  type
    Utf8CharAssertions = interface
    ['{819314CB-486C-4DDA-81CE-C2FD837888B7}']
      function Equals(const aExpected: Utf8Char): AssertionResult;
      function EqualsText(const aExpected: Utf8Char): AssertionResult;
      function IsLeadByte: AssertionResult;
      function IsContinuationByte: AssertionResult;
      function ExpectedContinuationBytes(const aExpected: Integer): AssertionResult;
      function IsNull: AssertionResult;
      function IsNotNull: AssertionResult;
    end;


    TUtf8CharAssertions = class(TAssertions, Utf8CharAssertions)
    private
      fValue: Utf8Char;
    private
      function Equals(const aExpected: Utf8Char): AssertionResult; reintroduce;
      function EqualsText(const aExpected: Utf8Char): AssertionResult;
      function IsLeadByte: AssertionResult;
      function IsContinuationByte: AssertionResult;
      function ExpectedContinuationBytes(const aExpected: Integer): AssertionResult;
      function IsNull: AssertionResult;
      function IsNotNull: AssertionResult;
    public
      constructor Create(const aTestName: String; const aValue: Utf8Char);
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



{ TUtf8CharAssertions -------------------------------------------------------------------------- }

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  constructor TUtf8CharAssertions.Create(const aTestName: String;
                                         const aValue: Utf8Char);
  begin
    inherited Create(aTestName, AsString(aValue));

    fValue := aValue;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TUtf8CharAssertions.Equals(const aExpected: Utf8Char): AssertionResult;
  begin
    FormatExpected(AsString(aExpected));

    Description := Format('{valueName} = {expected}');
    Failure     := Format('{valueWithName} should be {expected}');

    result := Assert(fValue = aExpected);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TUtf8CharAssertions.EqualsText(const aExpected: Utf8Char): AssertionResult;
  begin
    if Ord(aExpected) > 127 then
      raise EInvalidTest.Create('EqualsText() is not a valid test for a non-ASCII Utf8Char.  Use a Utf8String assertion');

    FormatExpected(AsString(aExpected));

    Description := Format('{valueWithName} is the same text as {expected}');
    Failure     := Format('{valueWithName} is not the same text as {expected}');

    if ((Byte(fValue) or 32) in [97..123]) then
      result := Assert((Byte(fValue) or 32) = (Byte(aExpected) or 32))
    else
      result := Assert(fValue = aExpected);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TUtf8CharAssertions.ExpectedContinuationBytes(const aExpected: Integer): AssertionResult;
  var
    actual: Integer;
  begin
    if (Byte(fValue) and $e0) = $c0 then
      actual := 1
    else if (Byte(fValue) and $f0) = $e0 then
      actual := 2
    else if (Byte(fValue) and $f8) = $f0 then
      actual := 3
    else
      actual := 0;

    if aExpected = 1 then
    begin
      Description := Format('{valueName} indicates 1 continuation byte is expected');
      Failure     := Format('{valueWithName} is expected to expect 1 continuation byte but is expecting {actual:%d}', [actual]);
    end
    else
    begin
      Description := Format('{valueName} indicates {numBytes:%d} continuation bytes are expected', [aExpected]);
      Failure     := Format('{valueWithName} is expected to expect {numBytes:%d} continuation bytes but is expecting {actual:%d}', [aExpected, actual]);
    end;

    result := Assert(actual = aExpected);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TUtf8CharAssertions.IsContinuationByte: AssertionResult;
  begin
    Description := Format('{valueName} is a continuation byte (high bit set)');
    Failure     := Format('{valueWithName} is not a continuation byte (high bit not set)');

    result := Assert((Byte(fValue) and $c0) = $80);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TUtf8CharAssertions.IsLeadByte: AssertionResult;
  begin
    Description := Format('{valueName} is a lead byte');
    Failure     := Format('{valueWithName} is not a lead byte');

    result := Assert(   ((Byte(fValue) and $e0) = $c0)
                     or ((Byte(fValue) and $f0) = $e0)
                     or ((Byte(fValue) and $f8) = $f0));
end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TUtf8CharAssertions.IsNull: AssertionResult;
  begin
    Description := Format('{valueName} is null');
    Failure     := Format('{valueWithName} is not null');

    result := Assert(fValue = #$00);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TUtf8CharAssertions.IsNotNull: AssertionResult;
  begin
    Description := Format('{valueName} is not null');
    Failure     := Format('{valueWithName} is null');

    result := Assert(fValue <> #$00);
  end;







end.

