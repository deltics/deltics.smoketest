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
    SysUtils,
    Deltics.Smoketest.Assertions.Boolean,
    Deltics.Smoketest.Assertions.Date,
    Deltics.Smoketest.Assertions.DateTime,
    Deltics.Smoketest.Assertions.Double,
    Deltics.Smoketest.Assertions.Guid,
    Deltics.Smoketest.Assertions.Int64,
    Deltics.Smoketest.Assertions.Integer,
    Deltics.Smoketest.Assertions.Interface_,
    Deltics.Smoketest.Assertions.Pointer,
    Deltics.Smoketest.Assertions.AnsiString,
  {$ifdef UNICODE}
    Deltics.Smoketest.Assertions.UnicodeString,
  {$endif}
    Deltics.Smoketest.Assertions.Utf8String,
    Deltics.Smoketest.Assertions.WideChar,
    Deltics.Smoketest.Assertions.WideString;


  type
    IExceptionAssertions = interface
    ['{3DDF7260-CD25-40DA-9D47-C6C4683F4F49}']
      procedure FailedToRaiseException;
      procedure RaisedExceptionOf(const aExceptionBaseClass: TClass; const aExceptionMessage: String = ''); overload;
      procedure RaisedExceptionOf(const aExceptionBaseClass: TClass; const aExceptionMessage: String; aArgs: array of const); overload;
      procedure RaisedException(const aExceptionClass: TClass; const aExceptionMessage: String = ''); overload; deprecated;
      procedure RaisedException(const aExceptionClass: TClass; const aExceptionMessage: String; aArgs: array of const); overload; deprecated;
      procedure RaisedException(const aExceptionMessage: String = ''); overload;
      procedure RaisedException(const aExceptionMessage: String; aArgs: array of const); overload;
      procedure Raised(const aExceptionClass: TClass; const aExceptionMessage: String = ''); overload;
      procedure Raised(const aExceptionClass: TClass; const aExceptionMessage: String; aArgs: array of const); overload;
      procedure RaisesExceptionOf(const aExceptionBaseClass: TClass; const aExceptionMessage: String = ''); overload;
      procedure RaisesExceptionOf(const aExceptionBaseClass: TClass; const aExceptionMessage: String; aArgs: array of const); overload;
      procedure RaisesException(const aExceptionClass: TClass; const aExceptionMessage: String = ''); overload; deprecated;
      procedure RaisesException(const aExceptionClass: TClass; const aExceptionMessage: String; aArgs: array of const); overload; deprecated;
      procedure RaisesException(const aExceptionMessage: String = ''); overload;
      procedure RaisesException(const aExceptionMessage: String; aArgs: array of const); overload;
      procedure Raises(const aExceptionClass: TClass; const aExceptionMessage: String = ''); overload;
      procedure Raises(const aExceptionClass: TClass; const aExceptionMessage: String; aArgs: array of const); overload;
      procedure RaisesNoException;
    end;


    AssertFactory = interface(IExceptionAssertions)
    ['{5D45A072-5B9D-4ECC-AB86-AFD82E9F6911}']
      function Assert(const aValue: Boolean): BooleanAssertions; overload;
    {$ifdef EnhancedOverloads}
      function Assert(const aValue: Double): DoubleAssertions; overload;
      function Assert(const aValue: TDate): DateAssertions; overload;
      function Assert(const aValue: TDateTime): DateTimeAssertions; overload;
    {$endif}
      function Assert(const aValue: Pointer): PointerAssertions; overload;
      function Assert(const aValue: TGuid): GuidAssertions; overload;
      function Assert(const aValue: Int64): Int64Assertions; overload;
      function Assert(const aValue: Integer): IntegerAssertions; overload;
      function Assert(const aValue: IUnknown): InterfaceAssertions; overload;
      function Assert(const aValue: AnsiString): AnsiStringAssertions; overload;
      function Assert(const aValue: WideChar): WideCharAssertions; overload;
      function Assert(const aValue: WideString): WideStringAssertions; overload;
    {$ifdef UNICODE}
      function Assert(const aValue: UnicodeString): UnicodeStringAssertions; overload;
    {$endif}
    // These type specific asserts are needed for versions that have more limited
    //  overload discrimination but are left in versions where they are not needed
    //  to allow tests to be written once compatible with any Delphi version
      function AssertDate(const aValue: TDate): DateAssertions;
      function AssertDatetime(const aValue: TDateTime): DateTimeAssertions;
      function AssertDouble(const aValue: Double): DoubleAssertions;
      function AssertUtf8(const aValue: Utf8String): Utf8StringAssertions;
    end;


    TAssertFactory = class(TInterfacedObject, AssertFactory, IExceptionAssertions)
    private
      fValueName: String;
      procedure CheckException;
      procedure CheckNoException;
    protected
      property ValueName: String read fValueName;
      function QueryInterface(const aIID: TGUID; out aIntf): HRESULT; reintroduce; stdcall;
      class procedure Register(const aIID: TGUID);
    public
      constructor Create(const aValueName: String); virtual;
    public // AssertFactory
      function Assert(const aValue: Boolean): BooleanAssertions; overload;
    {$ifdef EnhancedOverloads}
      function Assert(const aValue: Double): DoubleAssertions; overload;
      function Assert(const aValue: TDate): DateAssertions; overload;
      function Assert(const aValue: TDateTime): DateTimeAssertions; overload;
    {$endif}
      function Assert(const aValue: Pointer): PointerAssertions; overload;
      function Assert(const aValue: TGuid): GuidAssertions; overload;
      function Assert(const aValue: Int64): Int64Assertions; overload;
      function Assert(const aValue: Integer): IntegerAssertions; overload;
      function Assert(const aValue: IUnknown): InterfaceAssertions; overload;
      function Assert(const aValue: AnsiString): AnsiStringAssertions; overload;
      function Assert(const aValue: WideChar): WideCharAssertions; overload;
      function Assert(const aValue: WideString): WideStringAssertions; overload;
    {$ifdef EnhancedOverloads}
      function Assert(const aValue: Utf8String): Utf8StringAssertions; overload;
    {$endif}
    {$ifdef UNICODE}
      function Assert(const aValue: UnicodeString): UnicodeStringAssertions; overload;
    {$endif}
      function AssertDate(const aValue: TDate): DateAssertions;
      function AssertDatetime(const aValue: TDateTime): DateTimeAssertions;
      function AssertDouble(const aValue: Double): DoubleAssertions;
      function AssertUtf8(const aValue: Utf8String): Utf8StringAssertions;
    public // IExceptionAssertions
      procedure FailedToRaiseException;
      procedure RaisedExceptionOf(const aExceptionBaseClass: TClass; const aExceptionMessage: String = ''); overload;
      procedure RaisedExceptionOf(const aExceptionBaseClass: TClass; const aExceptionMessage: String; aArgs: array of const); overload;
      procedure RaisedException(const aExceptionClass: TClass; const aExceptionMessage: String = ''); overload;
      procedure RaisedException(const aExceptionClass: TClass; const aExceptionMessage: String; aArgs: array of const); overload;
      procedure RaisedException(const aExceptionMessage: String = ''); overload;
      procedure RaisedException(const aExceptionMessage: String; aArgs: array of const); overload;
      procedure Raised(const aExceptionClass: TClass; const aExceptionMessage: String = ''); overload;
      procedure Raised(const aExceptionClass: TClass; const aExceptionMessage: String; aArgs: array of const); overload;
      procedure RaisesExceptionOf(const aExceptionBaseClass: TClass; const aExceptionMessage: String = ''); overload;
      procedure RaisesExceptionOf(const aExceptionBaseClass: TClass; const aExceptionMessage: String; aArgs: array of const); overload;
      procedure RaisesException(const aExceptionClass: TClass; const aExceptionMessage: String = ''); overload;
      procedure RaisesException(const aExceptionClass: TClass; const aExceptionMessage: String; aArgs: array of const); overload;
      procedure RaisesException(const aExceptionMessage: String = ''); overload;
      procedure RaisesException(const aExceptionMessage: String; aArgs: array of const); overload;
      procedure Raises(const aExceptionClass: TClass; const aExceptionMessage: String = ''); overload;
      procedure Raises(const aExceptionClass: TClass; const aExceptionMessage: String; aArgs: array of const); overload;
      procedure RaisesNoException;
    end;
    TAssertFactoryClass = class of TAssertFactory;


    ENoExceptionRaised = class(Exception)
    private
      constructor Create; reintroduce;
    end;


implementation

  uses
    Contnrs,
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
  constructor ENoExceptionRaised.Create;
  begin
    inherited Create('');
  end;



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
  function TAssertFactory.Assert(const aValue: Boolean): BooleanAssertions;
  begin
    result := TBooleanAssertions.Create(ValueName, aValue);
  end;


{$ifdef EnhancedOverloads}

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TAssertFactory.Assert(const aValue: Double): DoubleAssertions;
  begin
    result := TDoubleAssertions.Create(ValueName, aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TAssertFactory.Assert(const aValue: TDate): DateAssertions;
  begin
    result := TDateAssertions.Create(ValueName, aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TAssertFactory.Assert(const aValue: TDateTime): DateTimeAssertions;
  begin
    result := TDateTimeAssertions.Create(ValueName, aValue);
  end;

{$endif}


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TAssertFactory.Assert(const aValue: Pointer): PointerAssertions;
  begin
    result := TPointerAssertions.Create(ValueName, aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TAssertFactory.Assert(const aValue: TGuid): GuidAssertions;
  begin
    result := TGuidAssertions.Create(ValueName, aValue);
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
  function TAssertFactory.Assert(const aValue: IUnknown): InterfaceAssertions;
  begin
    result := TInterfaceAssertions.Create(ValueName, aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TAssertFactory.Assert(const aValue: AnsiString): AnsiStringAssertions;
  begin
    result := TAnsiStringAssertions.Create(ValueName, aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TAssertFactory.Assert(const aValue: WideChar): WideCharAssertions;
  begin
    result := TWideCharAssertions.Create(ValueName, aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TAssertFactory.Assert(const aValue: WideString): WideStringAssertions;
  begin
    result := TWideStringAssertions.Create(ValueName, aValue);
  end;

{$ifdef EnhancedOverloads}

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TAssertFactory.Assert(const aValue: Utf8String): Utf8StringAssertions;
  begin
    result := TUtf8StringAssertions.Create(ValueName, aValue);
  end;

{$endif}

{$ifdef UNICODE}

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TAssertFactory.Assert(const aValue: UnicodeString): UnicodeStringAssertions;
  begin
    result := TUnicodeStringAssertions.Create(ValueName, aValue);
  end;

{$endif}


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TAssertFactory.AssertDate(const aValue: TDate): DateAssertions;
  begin
    result := TDateAssertions.Create(ValueName, aValue);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TAssertFactory.AssertDatetime(const aValue: TDateTime): DateTimeAssertions;
  begin
    result := TDateTimeAssertions.Create(ValueName, aValue);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TAssertFactory.AssertDouble(const aValue: Double): DoubleAssertions;
  begin
    result := TDoubleAssertions.Create(ValueName, aValue);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TAssertFactory.AssertUtf8(const aValue: Utf8String): Utf8StringAssertions;
  begin
    result := Tutf8StringAssertions.Create(ValueName, aValue);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TAssertFactory.FailedToRaiseException;
  begin
    raise ENoExceptionRaised.Create;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TAssertFactory.CheckException;
  begin
    if ExceptObject = NIL then
      raise EInvalidTest.Create('RaisedException() called with no exception object in context.  Did you mean Test.RaisesException ?');
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TAssertFactory.CheckNoException;
  begin
    if ExceptObject <> NIL then
      raise EInvalidTest.Create('RaisesException() called with exception object in context.  Did you mean Test.RaisedException ?');
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TAssertFactory.RaisedException(const aExceptionClass: TClass;
                                           const aExceptionMessage: String;
                                                 aArgs: array of const);
  begin
    RaisedException(aExceptionClass, Interpolate(aExceptionMessage, aArgs));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TAssertFactory.RaisedException(const aExceptionClass: TClass;
                                           const aExceptionMessage: String);
  begin
    CheckException;
    TestRun.ExpectingException(aExceptionClass, aExceptionMessage, TRUE);
    TestRun.TestError;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TAssertFactory.Raised(const aExceptionClass: TClass;
                                  const aExceptionMessage: String;
                                        aArgs: array of const);
  begin
    Raised(aExceptionClass, Interpolate(aExceptionMessage, aArgs));
  end;


  procedure TAssertFactory.Raised(const aExceptionClass: TClass;
                                  const aExceptionMessage: String);
  begin
    CheckException;
    TestRun.ExpectingException(aExceptionClass, aExceptionMessage, TRUE);
    TestRun.TestError;
  end;


  procedure TAssertFactory.RaisedException(const aExceptionMessage: String;
                                                 aArgs: array of const);
  begin
    RaisedException(Exception, Interpolate(aExceptionMessage, aArgs));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TAssertFactory.RaisedException(const aExceptionMessage: String);
  begin
    RaisedException(Exception, aExceptionMessage);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TAssertFactory.RaisedExceptionOf(const aExceptionBaseClass: TClass;
                                             const aExceptionMessage: String);
  begin
    CheckException;
    TestRun.ExpectingException(aExceptionBaseClass, aExceptionMessage, FALSE);
    TestRun.TestError;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TAssertFactory.RaisedExceptionOf(const aExceptionBaseClass: TClass;
                                             const aExceptionMessage: String;
                                                   aArgs: array of const);
  begin
    RaisedExceptionOf(aExceptionBaseClass, Interpolate(aExceptionMessage, aArgs));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TAssertFactory.RaisesExceptionOf(const aExceptionBaseClass: TClass;
                                             const aExceptionMessage: String);
  begin
    CheckNoException;
    TestRun.ExpectingException(aExceptionBaseClass, aExceptionMessage, FALSE);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TAssertFactory.RaisesExceptionOf(const aExceptionBaseClass: TClass;
                                             const aExceptionMessage: String;
                                                   aArgs: array of const);
  begin
    CheckNoException;
    TestRun.ExpectingException(aExceptionBaseClass, Interpolate(aExceptionMessage, aArgs), FALSE);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TAssertFactory.RaisesException(const aExceptionClass: TClass;
                                           const aExceptionMessage: String);
  begin
    CheckNoException;
    TestRun.ExpectingException(aExceptionClass, aExceptionMessage, TRUE);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TAssertFactory.RaisesException(const aExceptionClass: TClass;
                                           const aExceptionMessage: String;
                                                 aArgs: array of const);
  begin
    CheckNoException;
    TestRun.ExpectingException(aExceptionClass, Interpolate(aExceptionMessage, aArgs), TRUE);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TAssertFactory.RaisesException(const aExceptionMessage: String);
  begin
    CheckNoException;
    TestRun.ExpectingException(Exception, aExceptionMessage, FALSE);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TAssertFactory.Raises(const aExceptionClass: TClass;
                                  const aExceptionMessage: String;
                                        aArgs: array of const);
  begin
    Raises(aExceptionClass, Interpolate(aExceptionMessage, aArgs));
  end;


  procedure TAssertFactory.Raises(const aExceptionClass: TClass; const aExceptionMessage: String);
  begin
    CheckNoException;
    TestRun.ExpectingException(aExceptionClass, aExceptionMessage, TRUE);
  end;


  procedure TAssertFactory.RaisesException(const aExceptionMessage: String;
                                                 aArgs: array of const);
  begin
    CheckNoException;
    TestRun.ExpectingException(Exception, Interpolate(aExceptionMessage, aArgs), FALSE);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TAssertFactory.RaisesNoException;
  begin
    CheckNoException;
    TestRun.ExpectingNoException;
  end;



initialization
  TestRun := TTestRunHelper(Deltics.Smoketest.TestRun.TestRun);

  _AssertFactoryRegistrations := TObjectList.Create(TRUE);

finalization
  _AssertFactoryRegistrations.Free;

end.
