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

  unit Deltics.Smoketest.Assertions;


interface

  uses
    Classes,
    Deltics.Smoketest.TestResult,
    Deltics.Smoketest.Types;


  type
  {$ifNdef UNICODE}
    AnsiString = Deltics.Smoketest.Types.AnsiString;
    UnicodeString = Deltics.Smoketest.Types.UnicodeString;
  {$endif}


    EInvalidTest = Deltics.Smoketest.Types.EInvalidTest;


    AssertionResult = interface
    ['{86F9B5C1-FA31-416A-84FE-FFD21BCE7BBA}']
      function get_Failed: Boolean;
      function get_Passed: Boolean;
      function FailsBecause(const aReason: UnicodeString): AssertionResult; overload;
      function FailsBecause(const aReason: UnicodeString; aArgs: array of const): AssertionResult; overload;
      property Failed: Boolean read get_Failed;
      property Passed: Boolean read get_Passed;
    end;


    TAssertions = class(TInterfacedObject, AssertionResult)
    private
      fTestResult: TTestResult;
      fDescription: UnicodeString;
      fFailure: UnicodeString;
      fFormatTokens: TStringList;
      fValueAsString: UnicodeString;
      fValueName: UnicodeString;
    private // AssertionResult
      function get_Failed: Boolean;
      function get_Passed: Boolean;
      function ReplaceTokensIn(const aString: UnicodeString): UnicodeString;
      function FailsBecause(const aReason: UnicodeString): AssertionResult; overload;
      function FailsBecause(const aReason: UnicodeString; aArgs: array of const): AssertionResult; overload;
    protected
      function Assert(const aResult: Boolean): AssertionResult; overload;
      function Assert(const aResult: Boolean; const aMessage: UnicodeString): AssertionResult; overload;
      function Assert(const aResult: Boolean; const aMessage: UnicodeString; aArgs: array of const): AssertionResult; overload;
      function Format(const aString: UnicodeString): UnicodeString; overload;
      function Format(const aString: UnicodeString; aArgs: array of const): UnicodeString; overload;
      procedure FormatExpected(const aTokenValue: UnicodeString);
      procedure FormatToken(const aTokenString: UnicodeString; const aTokenValue: UnicodeString);
      property Description: UnicodeString read fDescription write fDescription;
      property Failure: UnicodeString read fFailure write fFailure;
      property TestResult: TTestResult read fTestResult;
      property ValueName: UnicodeString read fValueName;
    public
      constructor Create(const aValueName: UnicodeString; const aValueAsString: UnicodeString);
      destructor Destroy; override;
    end;



implementation

  uses
    SysUtils,
    Deltics.Smoketest.TestRun,
    Deltics.Smoketest.Utils;


  type
    TTestRunHelper = class(Deltics.Smoketest.TestRun.TTestRun);

  var TestRun: TTestRunHelper;


{ TFluentAssertions ------------------------------------------------------------------------------ }

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  constructor TAssertions.Create(const aValueName: UnicodeString;
                                 const aValueAsString: UnicodeString);
  begin
    inherited Create;

    fFormatTokens := TStringList.Create;

    fValueName     := aValueName;
    fValueAsString := aValueAsString;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  destructor TAssertions.Destroy;
  begin
    fFormatTokens.Free;

    inherited;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TAssertions.Format(const aString: UnicodeString): UnicodeString;
  begin
    result := Format(aString, []);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TAssertions.Format(const aString: UnicodeString; aArgs: array of const): UnicodeString;
  begin
    result := ReplaceTokensIn(aString);
    result := Interpolate(result, aArgs);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TAssertions.FormatExpected(const aTokenValue: UnicodeString);
  begin
    FormatToken('expected', aTokenValue);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TAssertions.FormatToken(const aTokenString, aTokenValue: UnicodeString);
  begin
    fFormatTokens.Values[Lowercase(aTokenString)] := aTokenValue;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TAssertions.get_Failed: Boolean;
  begin
    result := (fTestResult.State = rsFail);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TAssertions.get_Passed: Boolean;
  begin
    result := (fTestResult.State = rsPass);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TAssertions.ReplaceTokensIn(const aString: UnicodeString): UnicodeString;
  var
    i: Integer;
  begin
    result := aString;

    for i := 0 to Pred(fFormatTokens.Count) do
      result := StringReplace(result, '{' + fFormatTokens.Names[i] + '}', fFormatTokens.ValueFromIndex[i], [rfReplaceAll, rfIgnoreCase]);

    result := StringReplace(result, '{valueWithName}',  '{valueName} ({value})', [rfReplaceAll, rfIgnoreCase]);
    result := StringReplace(result, '{valueName}', fValueName, [rfReplaceAll, rfIgnoreCase]);
    result := StringReplace(result, '{value}', fValueAsString, [rfReplaceAll, rfIgnoreCase]);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TAssertions.Assert(const aResult: Boolean): AssertionResult;
  begin
    result := self;

    if aResult then
      fTestResult := TestRun.TestPassed(Description)
    else
      fTestResult := TestRun.TestFailed(Description, Failure);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TAssertions.Assert(const aResult: Boolean;
                              const aMessage: UnicodeString): AssertionResult;
  begin
    result := self;

    if aResult then
      fTestResult := TestRun.TestPassed(Description)
    else
      fTestResult := TestRun.TestFailed(Description, ReplaceTokensIn(aMessage));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TAssertions.Assert(const aResult: Boolean;
                              const aMessage: UnicodeString;
                                    aArgs: array of const): AssertionResult;
  begin
    result := Assert(aResult, Format(ReplaceTokensIn(aMessage), aArgs));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TAssertions.FailsBecause(const aReason: UnicodeString;
                                          aArgs: array of const): AssertionResult;
  begin
    result := FailsBecause(Format(ReplaceTokensIn(aReason), aArgs));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TAssertions.FailsBecause(const aReason: UnicodeString): AssertionResult;
  begin
    fTestResult.ErrorMessage := ReplaceTokensIn(aReason);
  end;





initialization
  TestRun := TTestRunHelper(Deltics.Smoketest.TestRun.TestRun);
end.
