
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
    Test('-switch is identified as present').Assert(HasCmdLineOption(Args, 'switch', Value));
    Test('-switch has no value').Assert(Value).Equals('');
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCommandLineHandlingTests.SwitchPresentWithValueIsHandledCorrectly;
  begin
    Test('-mode switch is identified as present').Assert(HasCmdLineOption(Args, 'mode', Value));
    Test('-mode switch value').Assert(Value).Equals('level=42');
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCommandLineHandlingTests.SwitchNotPresentIsHandledCorrectly;
  begin
    Test('-lever switch is identified as not present').Assert(NOT HasCmdLineOption(Args, 'lever', Value));
    Test('-lever switch has no value').Assert(Value).Equals('');
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TCommandLineHandlingTests.QuotedSwitchValueIsUnquotedCorrectly;
  begin
    Test('-quoted switch is identified as present').Assert(HasCmdLineOption(Args, 'quoted', Value));
    Test('-quoted switch value').Assert(Value).Equals('value contains quotes');
  end;


end.
