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

  unit Deltics.Smoketest.Assertions.Factory;


interface

  uses
    Classes,
  {$ifdef __DELPHI2007}
    Controls,
  {$endif}
    Deltics.Smoketest.Assertions.Date,
    Deltics.Smoketest.Assertions.DateTime,
    Deltics.Smoketest.Assertions.Int64,
    Deltics.Smoketest.Assertions.Integer,
    Deltics.Smoketest.Assertions.AnsiString,
    Deltics.Smoketest.Assertions.UnicodeString,
    Deltics.Smoketest.Assertions.WideString;


  type
    IExceptionAssertions = interface
    ['{3DDF7260-CD25-40DA-9D47-C6C4683F4F49}']
      procedure RaisesExceptionOf(const aExceptionBaseClass: TClass; const aExceptionMessage: String = '');
      procedure RaisesException(const aExceptionClass: TClass; const aExceptionMessage: String = ''); overload;
      procedure RaisesException(const aExceptionMessage: String = ''); overload;
      procedure RaisesNoException;
    end;


    AssertFactory = interface(IExceptionAssertions)
    ['{5D45A072-5B9D-4ECC-AB86-AFD82E9F6911}']
      function Assert(const aValue: Boolean): Boolean; overload;
    {$ifdef EnhancedOverloads}
      function Assert(const aValue: TDate): DateAssertions; overload;
      function Assert(const aValue: TDateTime): DateTimeAssertions; overload;
    {$else}
      function AssertDate(const aValue: TDate): DateAssertions; overload;
      function AssertDatetime(const aValue: TDateTime): DateTimeAssertions; overload;
    {$endif}
      function Assert(const aValue: Int64): Int64Assertions; overload;
      function Assert(const aValue: Integer): IntegerAssertions; overload;
      function Assert(const aValue: AnsiString): AnsiStringAssertions; overload;
      function Assert(const aValue: WideString): WideStringAssertions; overload;
    {$ifdef UNICODE}
      function Assert(const aValue: UnicodeString): UnicodeStringAssertions; overload;
    {$endif}
    end;


    TAssertFactory = class(TInterfacedObject, AssertFactory, IExceptionAssertions)
    private
      fValueName: String;
    protected
      property ValueName: String read fValueName;
      function QueryInterface(const aIID: TGUID; out aIntf): HRESULT; reintroduce; stdcall;
      class procedure Register(const aIID: TGUID);
    public
      constructor Create(const aValueName: String); virtual;
    public // AssertFactory
      function Assert(const aValue: Boolean): Boolean; overload;
    {$ifdef EnhancedOverloads}
      function Assert(const aValue: TDate): DateAssertions; overload;
      function Assert(const aValue: TDateTime): DateTimeAssertions; overload;
    {$else}
      function AssertDate(const aValue: TDate): DateAssertions; overload;
      function AssertDatetime(const aValue: TDateTime): DateTimeAssertions; overload;
    {$endif}
      function Assert(const aValue: Int64): Int64Assertions; overload;
      function Assert(const aValue: Integer): IntegerAssertions; overload;
      function Assert(const aValue: AnsiString): AnsiStringAssertions; overload;
      function Assert(const aValue: WideString): WideStringAssertions; overload;
    {$ifdef UNICODE}
      function Assert(const aValue: UnicodeString): UnicodeStringAssertions; overload;
    {$endif}
    public // IExceptionAssertions
      procedure RaisesExceptionOf(const aExceptionOrBaseClass: TClass; const aExceptionMessage: String = '');
      procedure RaisesException(const aExceptionClass: TClass; const aExceptionMessage: String = ''); overload;
      procedure RaisesException(const aExceptionMessage: String = ''); overload;
      procedure RaisesNoException;
    end;
    TAssertFactoryClass = class of TAssertFactory;



implementation

  uses
    Contnrs,
    SysUtils,
    TypInfo,
    Deltics.Smoketest.TestRun,
    Deltics.Smoketest.Utils;


  type
    TAssertFactoryRegistration = class
      IID: TGUID;
      FactoryClass: TAssertFactoryClass;
    end;

  var
    _AssertFactoryRegistrations: TObjectList;


  // Test classes have privileged access to protected members of the TestRun
  //  in order to record test completion and other details.
  type
    TTestRunHelper = class(TTestRun);

  // For convenience we'll keep a ready-reference to the type-cast TestRun
  var
    TestRun: TTestRunHelper;



  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  constructor TAssertFactory.Create(const aValueName: String);
  begin
    inherited Create;

    fValueName := aValueName;
  end;



  function TAssertFactory.QueryInterface(const aIID: TGUID;
                                         out   aIntf): HRESULT;
  var
    i: Integer;
    reg: TAssertFactoryRegistration;
    factory: TObject;
  begin
    // Give the inherited QueryInterface an opportunity to resolve the
    //  request interface.  If successful, we have no more work to do

    result := inherited QueryInterface(aIID, aIntf);
    if result = S_OK then
      EXIT;

    // In the event that the interface was not resolved then there may
    //  be a registered extension, so check for that...

    for i := 0 to Pred(_AssertFactoryRegistrations.Count) do
    begin
      reg := TAssertFactoryRegistration(_AssertFactoryRegistrations[i]);
      if GuidsAreEqual(reg.IID, aIID) then
      begin
        factory := reg.FactoryClass.Create(ValueName);
        factory.GetInterface(aIID, aIntf);
        EXIT;
      end;
    end;

    result := S_FALSE;
  end;


  class procedure TAssertFactory.Register(const aIID: TGUID);
  var
    reg: TAssertFactoryRegistration;
  begin
    reg := TAssertFactoryRegistration.Create;
    reg.IID           := aIID;
    reg.FactoryClass  := self;

    _AssertFactoryRegistrations.Add(reg);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TAssertFactory.Assert(const aValue: Boolean): Boolean;
  begin
    result := aValue;
    if result then
      TestRun.TestPassed(ValueName)
    else
      TestRun.TestFailed(ValueName, ValueName + ' is not TRUE');
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
{$ifdef EnhancedOverloads}
  function TAssertFactory.Assert(const aValue: TDate): DateAssertions;
{$else}
  function TAssertFactory.AssertDate(const aValue: TDate): DateAssertions;
{$endif}
  begin
    result := TDateAssertions.Create(ValueName, aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
{$ifdef EnhancedOverloads}
  function TAssertFactory.Assert(const aValue: TDateTime): DateTimeAssertions;
{$else}
  function TAssertFactory.AssertDatetime(const aValue: TDateTime): DateTimeAssertions;
{$endif}
  begin
    result := TDateTimeAssertions.Create(ValueName, aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TAssertFactory.Assert(const aValue: Int64): Int64Assertions;
  begin
    result := TInt64Assertions.Create(ValueName, aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TAssertFactory.Assert(const aValue: Integer): IntegerAssertions;
  begin
    result := TIntegerAssertions.Create(ValueName, aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TAssertFactory.Assert(const aValue: AnsiString): AnsiStringAssertions;
  begin
    result := TAnsiStringAssertions.Create(ValueName, aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TAssertFactory.Assert(const aValue: WideString): WideStringAssertions;
  begin
    result := TWideStringAssertions.Create(ValueName, aValue);
  end;


{$ifdef UNICODE}

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TAssertFactory.Assert(const aValue: UnicodeString): UnicodeStringAssertions;
  begin
    result := TUnicodeStringAssertions.Create(ValueName, aValue);
  end;

{$endif}


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TAssertFactory.RaisesExceptionOf(const aExceptionOrBaseClass: TClass;
                                                const aExceptionMessage: String);
  begin
    TestRun.ExpectingException(aExceptionOrBaseClass, aExceptionMessage, FALSE);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TAssertFactory.RaisesException(const aExceptionClass: TClass;
                                                     const aExceptionMessage: String);
  begin
    TestRun.ExpectingException(aExceptionClass, aExceptionMessage, TRUE);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TAssertFactory.RaisesException(const aExceptionMessage: String);
  begin
    TestRun.ExpectingException(Exception, aExceptionMessage, FALSE);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TAssertFactory.RaisesNoException;
  begin
    TestRun.ExpectingNoException;
  end;



initialization
  TestRun := TTestRunHelper(Deltics.Smoketest.TestRun.TestRun);

  _AssertFactoryRegistrations := TObjectList.Create(TRUE);

finalization
  _AssertFactoryRegistrations.Free;

end.
