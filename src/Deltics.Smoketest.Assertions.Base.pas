
  unit Deltics.Smoketest.Assertions.Base;

interface

  uses
    Deltics.Smoketest.Utils;


  type
  {$ifNdef UNICODE}
    AnsiString = Deltics.Smoketest.Utils.AnsiString;
    UnicodeString = Deltics.Smoketest.Utils.UnicodeString;
  {$endif}

    EInvalidTest = Deltics.Smoketest.Utils.EInvalidTest;

    TFluentAssertions = class(TInterfacedObject)
    private
      fTestName: String;
    protected
      function SetResult(const aResult: Boolean; const aMessage: String): Boolean; overload;
      function SetResult(const aResult: Boolean; const aMessage: String; aArgs: array of const): Boolean; overload;
    public
      constructor Create(const aTestName: String);
    end;

implementation

  uses
    SysUtils,
    Deltics.Smoketest.TestRun;


  type
    TTestRunHelper = class(Deltics.Smoketest.TestRun.TTestRun);

  var TestRun: TTestRunHelper;


{ TFluentAssertions }

  constructor TFluentAssertions.Create(const aTestName: String);
  begin
    inherited Create;

    fTestName := aTestName;
  end;


  function TFluentAssertions.SetResult(const aResult: Boolean;
                                       const aMessage: String): Boolean;
  begin
    result := aResult;

    if NOT aResult then
      TestRun.TestFailed(fTestName, aMessage)
    else
      TestRun.TestPassed(fTestName);
  end;


  function TFluentAssertions.SetResult(const aResult: Boolean;
                                       const aMessage: String;
                                             aArgs: array of const): Boolean;
  begin
    result := SetResult(aResult, Format(aMessage, aArgs));
  end;



initialization
  TestRun := TTestRunHelper(Deltics.Smoketest.TestRun.TestRun);
end.
