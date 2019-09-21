
{$i Deltics.Smoketest.inc}

  unit Deltics.Smoketest.ResultsWriter.XUnit2;

interface

  uses
    Deltics.Smoketest.ResultsWriter;


  type
    TXUnit2Writer = class(TResultsWriter)
      procedure SaveResults(const aTestRun: TTestRun; const aFilename: String); override;
    end;


implementation

  uses
    Classes,
    SysUtils;


{ TXUnit2Writer }

  procedure TXUnit2Writer.SaveResults(const aTestRun: TTestRun;
                                      const aFilename: String);
  var
    i: Integer;
    output: TStringList;
    y, m, d, h, n, s, z: Word;
    result: TTestResult;
    state: String;
  begin
    output := TStringList.Create;
    try
      if FileExists(aFilename) then
      begin
        output.LoadFromFile(aFilename);
        while output[output.Count - 1] <> '</assemblies>' do
          output.Delete(output.Count - 1);

        output.Delete(output.Count - 1);
      end
      else
      begin
        output.Add('<?xml version="1.0" encoding="utf-8" ?>');
        output.Add('<assemblies>');
      end;

      DecodeDate(aTestRun.StartTime, y, m, d);
      DecodeTime(aTestRun.StartTime, h, n, s, z);

      output.Add(Format('  <assembly name="%s" test-framework="Smoketest" environment="%s" '
                        + 'run-date="%d-%.2d-%.2d" run-time="%.2d:%.2d:%.2d" '
                        + 'time="%d" '
                        + 'total="%d" passed="%d" failed="%d" skipped="%d" errors="%d">',
                        [aTestRun.Name,
                         aTestRun.Environment,
                         y, m, d, h, n, s,
                         aTestRun.RunTime,
                         aTestRun.TestCount, aTestRun.TestsPassed, aTestRun.TestsFailed, aTestRun.TestsSkipped, aTestRun.TestsError]));

      output.Add(Format('    <collection name="Default" time="%d" '
                          + 'total="%d" passed="%d" failed="%d" skipped="%d">',
                          [aTestRun.RunTime,
                           aTestRun.TestCount, aTestRun.TestsPassed, aTestRun.TestsFailed, aTestRun.TestsSkipped]));

      for i := 0 to Pred(aTestRun.ResultCount) do
      begin
        result := aTestRun.Results[i];

        case result.State of
          rsPass  : state := 'Pass';
          rsSkip  : state := 'Skip';
          rsFail  : state := 'Fail';
          rsError : state := 'Error';
        end;

        if (result.State = rsPass) or (result.ErrorMessage = '') then
        begin
          output.Add(Format('      <test name="%s" type="%s" method="%s" time="0" result="%s" />',
                                   [result.TestName, result.TypeName, result.TestMethod, state]));
          CONTINUE;
        end;

        output.Add(Format('      <test name="%s" type="%s" method="%s" time="0" result="%s">',
                                 [result.TestName, result.TypeName, result.TestMethod, state]));
               output.Add('        <failure exception-type="Assertion">');
               output.Add('          <message>');
               output.Add('            <![CDATA[' + result.ErrorMessage + ']]>');
               output.Add('          </message>');
               output.Add('        </failure>');
               output.Add('      </test>');
      end;

      output.Add('    </collection>');
      output.Add('  </assembly>');
      output.Add('</assemblies>');
      output.SaveToFile(aFilename {$ifdef DELPHI2009__}, TEncoding.UTF8{$endif});

    finally
      output.Free;
    end;
  end;


initialization
  TXUnit2Writer.Register('xunit2');
end.
