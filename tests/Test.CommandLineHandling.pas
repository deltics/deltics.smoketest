
  unit Test.CommandLineHandling;

interface

  uses
    Classes,
    Deltics.Smoketest;


  type
    TCommandLineHandlingTests = class(TTest)
    {
      NOTE: We can't test the TestRun method directly as this examines the runtime
      command line args.  But the actual command line option handling is
      performed by the Utils method, which we CAN test.
    }
    private
      Args: TStringList;
      Value: String;
    published
      procedure SetupTest;
      procedure SetupMethod;
      procedure TearDownTest;
      procedure SwitchPresentWithNoValueIsHandledCorrectly;
      procedure SwitchPresentWithValueIsHandledCorrectly;
      procedure SwitchNotPresentIsHandledCorrectly;
      procedure QuotedSwitchValueIsUnquotedCorrectly;
  end;


implementation

  uses
    SysUtils,
    Deltics.Smoketest.Utils;


{ CommandLineHandling tests ---------------------------------------------------------------------- }

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCommandLineHandlingTests.SetupTest;
  begin
    Args := TStringList.Create;
    Args.Add('selftest.exe');
    Args.Add('-switch');
    Args.Add('-mode:level=42');
    Args.Add('-quoted:"value ""contains"" quotes"');
  end;

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCommandLineHandlingTests.SetupMethod;
  begin
    Value := 'initialised';
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCommandLineHandlingTests.TearDownTest;
  begin
    Args.Free;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCommandLineHandlingTests.SwitchPresentWithNoValueIsHandledCorrectly;
  begin
    Assert('-switch is identified as present', HasCmdLineOption(Args, 'switch', Value), 'Failed to identify -switch in args');
    Assert('-switch has no value', Value).Equals('');
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCommandLineHandlingTests.SwitchPresentWithValueIsHandledCorrectly;
  begin
    Assert('-mode switch is identified as present', HasCmdLineOption(Args, 'mode', Value), 'Failed to identify -mode switch in args');
    Assert('-mode switch value', Value).Equals('level=42');
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCommandLineHandlingTests.SwitchNotPresentIsHandledCorrectly;
  begin
    Assert('-lever switch is identified as not present', NOT HasCmdLineOption(Args, 'lever', Value), '-lever option identified as present when it is not');
    Assert('-lever switch has no value', Value).Equals('');
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCommandLineHandlingTests.QuotedSwitchValueIsUnquotedCorrectly;
  begin
    Assert('-quoted switch is identified as present', HasCmdLineOption(Args, 'quoted', Value), 'Failed to identify -quoted in args');
    Assert(Value).Equals('value contains quotes');
  end;


end.
