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

  unit Deltics.Smoketest.Assertions.Pointer;


interface

  uses
    Deltics.Smoketest.Assertions;


  type
    PointerAssertions = interface
    ['{46F67D92-BD65-4D8D-B9B6-65203BC1DF41}']
      function DoesNotEqual(const aExpected: Pointer): AssertionResult;
      function Equals(const aExpected: Pointer): AssertionResult;
      function EqualsBytes(const aExpected: Pointer; const aBytes: Integer): AssertionResult;
      function HasUnequalBytes(const aExpected: Pointer; const aBytes: Integer): AssertionResult;
      function IsAssigned: AssertionResult;
      function IsNIL: AssertionResult;
      function IsNotNIL: AssertionResult;
    end;


    TPointerAssertions = class(TAssertions, PointerAssertions)
    private
      fValue: Pointer;
      function DoesNotEqual(const aExpected: Pointer): AssertionResult;
      function Equals(const aExpected: Pointer): AssertionResult;
      function EqualsBytes(const aExpected: Pointer; const aBytes: Integer): AssertionResult;
      function HasUnequalBytes(const aExpected: Pointer; const aBytes: Integer): AssertionResult;
      function IsAssigned: AssertionResult;
      function IsNIL: AssertionResult;
      function IsNotNIL: AssertionResult;
    public
      constructor Create(const aTestName: String; aValue: Pointer);
    end;


implementation

  uses
    Classes,
    SysUtils,
    Deltics.Smoketest.Utils;



{ TPointerAssertions ----------------------------------------------------------------------------- }

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  constructor TPointerAssertions.Create(const aTestName: String;
                                              aValue: Pointer);
  begin
    inherited Create(aTestName, BinToHex(@aValue, sizeof(Pointer)));

    fValue := aValue;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TPointerAssertions.DoesNotEqual(const aExpected: Pointer): AssertionResult;
  begin
    FormatExpected(BinToHex(@aExpected, sizeof(Pointer)));

    Description := Format('{valueName} does not = {expected}');
    Failure     := Format('{valueWithName} = {expected}');

    result := Assert(fValue <> aExpected);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TPointerAssertions.Equals(const aExpected: Pointer): AssertionResult;
  begin
    FormatExpected(BinToHex(@aExpected, sizeof(Pointer)));

    Description := Format('{valueName} = {expected}');
    Failure     := Format('{valueWithName} does not = {expected}');

    result := Assert(fValue = aExpected);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TPointerAssertions.EqualsBytes(const aExpected: Pointer;
                                          const aBytes: Integer): AssertionResult;
  begin
    FormatExpected(BinToHex(aExpected, aBytes));

    Description := Format('{valueName} has bytes equal to [{expected}]');
    Failure     := Format('{valueWithName} does not have bytes equal to [{expected}]');

    result := Assert(CompareMem(fValue, aExpected, aBytes));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TPointerAssertions.HasUnequalBytes(const aExpected: Pointer;
                                              const aBytes: Integer): AssertionResult;
  begin
    FormatExpected(BinToHex(aExpected, aBytes));

    Description := Format('{valueName} does not have bytes equal to [{expected}]');
    Failure     := Format('{valueWithName} has equal bytes [{expected}]');

    result := Assert(NOT CompareMem(fValue, aExpected, aBytes));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TPointerAssertions.IsAssigned: AssertionResult;
  begin
    Description := Format('{valueWithName} is assigned (not NIL)');
    Failure     := Format('{valueWithName} is NIL');

    result := Assert(Assigned(fValue));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TPointerAssertions.IsNIL: AssertionResult;
  begin
    Description := Format('{valueWithName} is NIL');
    Failure     := Format('{valueWithName} is not NIL');

    result := Assert(fValue = NIL);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TPointerAssertions.IsNotNIL: AssertionResult;
  begin
    Description := Format('{valueWithName} is NOT NIL');
    Failure     := Format('{valueWithName} is NIL');

    result := Assert(fValue <> NIL);
  end;



end.
