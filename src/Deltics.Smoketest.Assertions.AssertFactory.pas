
{$i deltics.smoketest.inc}

  unit Deltics.Smoketest.Assertions.AssertFactory;

interface

  uses
    Classes,
    Deltics.Smoketest.Assertions.Date,
    Deltics.Smoketest.Assertions.DateTime,
    Deltics.Smoketest.Assertions.Integers,
    Deltics.Smoketest.Assertions.AnsiStrings,
    Deltics.Smoketest.Assertions.UnicodeStrings,
    Deltics.Smoketest.Assertions.WideStrings;


  type
    IExceptionAssertions = interface
    ['{3DDF7260-CD25-40DA-9D47-C6C4683F4F49}']
      function AssertBaseException(const aExceptionBaseClass: TClass; const aExceptionMessage: String = ''): Boolean;
      function AssertException(const aExceptionClass: TClass; const aExceptionMessage: String = ''): Boolean;
      function AssertNoException: Boolean;
    end;


    AssertFactory = interface(IExceptionAssertions)
    ['{5D45A072-5B9D-4ECC-AB86-AFD82E9F6911}']
      function Assert(const aValue: Boolean): Boolean; overload;
      function Assert(const aValue: TDate): DateAssertions; overload;
      function Assert(const aValue: TDateTime): DateTimeAssertions; overload;
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
      function Assert(const aValue: TDate): DateAssertions; overload;
      function Assert(const aValue: TDateTime): DateTimeAssertions; overload;
      function Assert(const aValue: Integer): IntegerAssertions; overload;
      function Assert(const aValue: AnsiString): AnsiStringAssertions; overload;
      function Assert(const aValue: WideString): WideStringAssertions; overload;
    {$ifdef UNICODE}
      function Assert(const aValue: UnicodeString): UnicodeStringAssertions; overload;
    {$endif}
    public // IExceptionAssertions
      function AssertBaseException(const aExceptionBaseClass: TClass; const aExceptionMessage: String = ''): Boolean;
      function AssertException(const aExceptionClass: TClass; const aExceptionMessage: String = ''): Boolean;
      function AssertNoException: Boolean;
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
  function TAssertFactory.Assert(const aValue: TDate): DateAssertions;
  begin
    result := TDateAssertions.Create(ValueName, aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TAssertFactory.Assert(const aValue: TDateTime): DateTimeAssertions;
  begin
    result := TDateTimeAssertions.Create(ValueName, aValue);
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


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TAssertFactory.AssertBaseException(const aExceptionBaseClass: TClass;
                                              const aExceptionMessage: String): Boolean;
  begin
    result := TestRun.TestException(ValueName, aExceptionBaseClass, TRUE, aExceptionMessage);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TAssertFactory.AssertException(const aExceptionClass: TClass;
                                 const aExceptionMessage: String): Boolean;
  begin
    result := TestRun.TestException(ValueName, aExceptionClass, FALSE, aExceptionMessage);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TAssertFactory.AssertNoException: Boolean;
  var
    eo: TObject;
    e: Exception absolute eo;
    testName: String;
    msg: String;
  begin
    eo := ExceptObject;

    testName := ValueName + ' raised no exception';

    result := NOT Assigned(eo);
    if result then
    begin
      TestRun.TestPassed(testName);
      EXIT;
    end;

    msg := Format('No exception was expected but %s was raised', [eo.ClassName]);
    if e is Exception then
      msg := msg + Format(' with message %s', [e.Message]);

    TestRun.TestFailed(testName, msg);
  end;





initialization
  TestRun := TTestRunHelper(Deltics.Smoketest.TestRun.TestRun);

  _AssertFactoryRegistrations := TObjectList.Create(TRUE);

finalization
  _AssertFactoryRegistrations.Free;

end.
