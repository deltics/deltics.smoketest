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

  unit Deltics.Smoketest.Assertions.Guid;


interface

  uses
    Deltics.Smoketest.Assertions;


  type
    GuidAssertions = interface
    ['{2511AFF0-5B28-4DBD-AA0A-00A6F9BFDA7E}']
      function Equals(const aExpected: TGuid): AssertionResult;
      function IsNullGuid: AssertionResult;
      function IsNotNullGuid: AssertionResult;
    end;


    TGuidAssertions = class(TAssertions, GuidAssertions)
    private
      fValue: TGuid;
      function Equals(const aExpected: TGuid): AssertionResult; reintroduce;
      function IsNullGuid: AssertionResult;
      function IsNotNullGuid: AssertionResult;
    public
      constructor Create(const aTestName: String; aValue: TGuid);
    end;


implementation

  uses
    SysUtils;


  const
    NullGuidStr     = '{00000000-0000-0000-0000-000000000000}';
    NullGuid: TGuid = NullGuidStr;



{ TGuidAssertions ---------------------------------------------------------------------------- }

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  constructor TGuidAssertions.Create(const aTestName: String;
                                              aValue: TGuid);
  begin
    inherited Create(aTestName, GuidToString(aValue));

    fValue := aValue;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TGuidAssertions.Equals(const aExpected: TGuid): AssertionResult;
  begin
    FormatExpected(GuidToString(aExpected));

    Description := Format('{valueName} = {expected}');
    Failure     := Format('{valueWithName} does not = {expected}');

  {$ifdef DELPHI7}
    result := Assert(fValue = aExpected);
  {$else}
    result := Assert(CompareMem(@fValue, @aExpected, sizeof(TGuid)));
  {$endif}
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TGuidAssertions.IsNullGuid;
  begin
    result := Equals(NullGuid);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TGuidAssertions.IsNotNullGuid: AssertionResult;
  begin
    FormatExpected(NullGuidStr);

    Description := Format('{valueName} does not = {expected}');
    Failure     := Format('{valueWithName} = {expected}');

  {$ifdef DELPHI7}
    result := Assert(fValue <> NullGuid);
  {$else}
    result := Assert(NOT CompareMem(@fValue, @NullGuid, sizeof(TGuid)));
  {$endif}
  end;




end.
