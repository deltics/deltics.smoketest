
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
      procedure QuotedValueIsUnquotedCorrectly;
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
    Assert('Present -switch is identified', HasCmdLineOption(Args, 'switch', Value), 'Failed to identify -switch in args');
    Assert('Present -switch has no value', Value = '', Format('-switch without value yielded value of ''%s''', [Value]));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCommandLineHandlingTests.SwitchPresentWithValueIsHandledCorrectly;
  begin
    Assert('-mode switch is identified', HasCmdLineOption(Args, 'mode', Value), 'Failed to identify -mode switch in args');
    Assert('-mode value is ''level=42''', Value = 'level=42', Format('-mode value was expected to be ''level=42'' but was ''%s''', [Value]));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCommandLineHandlingTests.SwitchNotPresentIsHandledCorrectly;
  begin
    Assert('Missing -lever is not identified', NOT HasCmdLineOption(Args, 'lever', Value), '-lever option identified as present when it is not');
    Assert('Missing -lever has no value', Value = '', Format('Missing -lever option yielded value ''%s'' but should be ''''', [Value]));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCommandLineHandlingTests.QuotedValueIsUnquotedCorrectly;
  begin
    HasCmdLineOption(Args, 'quoted', Value);
    Assert('Quoted value is unquoted correctly', Value = 'value contains quotes', Format('Quoted value should have unquoted as ''value contains quotes'' but was ''%s''', [Value]));
  end;


end.
