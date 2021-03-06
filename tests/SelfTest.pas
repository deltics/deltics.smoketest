{
  * MIT LICENSE *

  Copyright � 2020 Jolyon Smith

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

  unit SelfTest;


interface

  uses
  {$ifdef __DELPHI2007} // TDate declared in Controls up to Delphi 2007
    Controls,
  {$endif}
    Deltics.Smoketest.Test,
    Deltics.Smoketest.Assertions.Factory,
    Deltics.Smoketest.Assertions.Boolean,
    Deltics.Smoketest.Assertions.Int64,
    Deltics.Smoketest.Assertions.Integer,
    Deltics.Smoketest.Assertions.Interface_,
    Deltics.Smoketest.Assertions.Pointer,
    Deltics.Smoketest.Assertions.Guid,
    Deltics.Smoketest.Assertions.Date,
    Deltics.Smoketest.Assertions.DateTime,
    Deltics.Smoketest.Assertions.Double,
    Deltics.Smoketest.Assertions.AnsiString,
    Deltics.Smoketest.Assertions.UnicodeString,
    Deltics.Smoketest.Assertions.Utf8Char,
    Deltics.Smoketest.Assertions.Utf8String,
    Deltics.Smoketest.Assertions.WideChar,
    Deltics.Smoketest.Assertions.WideString,
    Deltics.Smoketest.Types;


  type
    ISelfTest = interface(IExceptionAssertions)
      procedure IsExpectedToError;
      procedure IsExpectedToFail;
    end;


    TSelfTest = class(TTest)
    protected
      function Test: ISelfTest; overload;
    {$ifdef DELPHI7} {$WARNINGS OFF} {$endif}
      function Assert(aValue: Boolean): BooleanAssertions; overload;
      function Assert(aValue: Integer): IntegerAssertions; overload;
      function Assert(aValue: Int64): Int64Assertions; overload;
      function Assert(aValue: TGuid): GuidAssertions; overload;
      function Assert(aValue: IUnknown): InterfaceAssertions; overload;
      function Assert(aValue: Pointer): PointerAssertions; overload;
      function Assert(aValue: AnsiString): AnsiStringAssertions; overload;
      function Assert(aValue: WideChar): WideCharAssertions; overload;
      function Assert(aValue: WideString): WideStringAssertions; overload;
    {$ifdef EnhancedOverloads}
      function Assert(const aValue: Double): DoubleAssertions; overload;
      function Assert(const aValue: TDate): DateAssertions; overload;
      function Assert(const aValue: TDateTime): DateTimeAssertions; overload;
      function Assert(const aValue: Utf8String): Utf8StringAssertions; overload;
    {$endif}
    {$ifdef UNICODE}
      function Assert(aValue: UnicodeString): UnicodeStringAssertions; overload;
    {$endif}
      function AssertDate(const aValue: TDate): DateAssertions;
      function AssertDatetime(const aValue: TDateTime): DateTimeAssertions;
      function AssertDouble(const aValue: Double): DoubleAssertions;
      function AssertUtf8(aValue: Utf8Char): Utf8CharAssertions; overload;
      function AssertUtf8(const aValue: Utf8String): Utf8StringAssertions; overload;
    {$ifdef DELPHI7} {$WARNINGS ON} {$endif}
    end;



implementation

  uses
    Deltics.Smoketest.TestRun;


  // More shenanigans to obtain privileged access to protected members of the TestRun
  //  in order to record test completion and other details plus (in this case) other
  //  capabilities specifically designed to be used solely by self-tests.
  type
    TTestRunHelper = class(TTestRun);

  // For convenience we'll keep a ready-reference to the type-cast TestRun
  var
    TestRun: TTestRunHelper;

  type
    TSelfTestInterface = class(TAssertFactory, ISelfTest)
    public // ISelfTest
      procedure IsExpectedToError;
      procedure IsExpectedToFail;
    end;


  procedure TSelfTestInterface.IsExpectedToFail;
  begin
    TestRun.ExpectingToFail;
  end;


  procedure TSelfTestInterface.IsExpectedToError;
  begin
    TestRun.ExpectingToError;
  end;


  var
    _SelfTest: ISelfTest;



{ TSelfTest -------------------------------------------------------------------------------------- }

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TSelfTest.Test: ISelfTest;
  begin
    result := _SelfTest;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TSelfTest.Assert(aValue: Boolean): BooleanAssertions;
  begin
    result := Test('test').Assert(aValue);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TSelfTest.Assert(aValue: Integer): IntegerAssertions;
  begin
    result := Test('test').Assert(aValue);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TSelfTest.Assert(aValue: Int64): Int64Assertions;
  begin
    result := Test('test').Assert(aValue);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TSelfTest.Assert(aValue: TGuid): GuidAssertions;
  begin
    result := Test('test').Assert(aValue);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TSelfTest.Assert(aValue: IUnknown): InterfaceAssertions;
  begin
    result := Test('test').Assert(aValue);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TSelfTest.Assert(aValue: Pointer): PointerAssertions;
  begin
    result := Test('test').Assert(aValue);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TSelfTest.Assert(aValue: AnsiString): AnsiStringAssertions;
  begin
    result := Test('test').Assert(aValue);
  end;


{$ifdef UNICODE}
  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TSelfTest.Assert(aValue: UnicodeString): UnicodeStringAssertions;
  begin
    result := Test('test').Assert(aValue);
  end;

{$endif}


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TSelfTest.Assert(aValue: WideChar): WideCharAssertions;
  begin
    result := Test('test').Assert(aValue);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TSelfTest.Assert(aValue: WideString): WideStringAssertions;
  begin
    result := Test('test').Assert(aValue);
  end;


{$ifdef EnhancedOverloads}

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TSelfTest.Assert(const aValue: Double): DoubleAssertions;
  begin
    result := Test('test').Assert(aValue);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TSelfTest.Assert(const aValue: TDate): DateAssertions;
  begin
    result := Test('test').Assert(aValue);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TSelfTest.Assert(const aValue: TDateTime): DateTimeAssertions;
  begin
    result := Test('test').Assert(aValue);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TSelfTest.Assert(const aValue: Utf8String): Utf8StringAssertions;
  begin
    result := Test('test').AssertUtf8(aValue);
  end;

{$endif}

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TSelfTest.AssertDate(const aValue: TDate): DateAssertions;
  begin
    result := Test('test').AssertDate(aValue);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TSelfTest.AssertDatetime(const aValue: TDateTime): DateTimeAssertions;
  begin
    result := Test('test').AssertDatetime(aValue);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TSelfTest.AssertDouble(const aValue: Double): DoubleAssertions;
  begin
    result := Test('test').AssertDouble(aValue);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TSelfTest.AssertUtf8(aValue: Utf8Char): Utf8CharAssertions;
  begin
    result := Test('test').AssertUtf8(aValue);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TSelfTest.AssertUtf8(const aValue: Utf8String): Utf8StringAssertions;
  begin
    result := Test('test').AssertUtf8(aValue);
  end;



initialization
  _SelfTest := TSelfTestInterface.Create('test');

  TestRun := TTestRunHelper(Deltics.Smoketest.TestRun.TestRun);

finalization
  _SelfTest:= NIL;
end.
