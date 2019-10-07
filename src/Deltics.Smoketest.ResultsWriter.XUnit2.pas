
{$i Deltics.Smoketest.inc}

  unit Deltics.Smoketest.ResultsWriter.XUnit2;

interface

  uses
    Deltics.Smoketest.ResultsWriter;


  type
    TXUnit2Writer = class(TResultsWriter)
    {
      Implements a results writer that will output test run results in xUnit 2.x format.
       The xUnit 2.x format is documented in full at:

         https://xunit.net/docs/format-xml-v2.html

      This writer will create a file if necessary or append test run results to the
       contents of an existing file if the specified file already exists.  If the file
       exists it is ASSUMED to be an xUnit2 format file.  Further, it is ASSUMED to be
       an xUnit2 file WRITTEN BY THIS WRITER (or in a compatible fashion, with tags
       on separate lines in the file).

      A testrun is output to the file as a single <collection> within a single <assembly>.

      Collections are an xUnit concept not directly applicable to Smoketest but a <collection>
       element is required in the format and so a 'Default' collection is created.

      NOTE: There is no formal XML handling in this writer.  The XML is constructed as
             a simple stringlist with manually forced indentation.
    }
      procedure SaveResults(const aFilename: String); override;
    end;


implementation

  uses
    Classes,
    SysUtils;


{ TXUnit2Writer ---------------------------------------------------------------------------------- }

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TXUnit2Writer.SaveResults(const aFilename: String);
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
        // Remove everything upto and including the closing </assemblies> tag from
        //  the existing file.
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

      DecodeDate(TestRun.StartTime, y, m, d);
      DecodeTime(TestRun.StartTime, h, n, s, z);

      output.Add(Format('  <assembly name="%s" test-framework="Smoketest" environment="%s" '
                        + 'run-date="%d-%.2d-%.2d" run-time="%.2d:%.2d:%.2d" '
                        + 'time="%.3f" '
                        + 'total="%d" passed="%d" failed="%d" skipped="%d" errors="%d">',
                        [TestRun.Name,
                         TestRun.Environment,
                         y, m, d, h, n, s,
                         TestRun.RunTime / 1000,
                         TestRun.TestCount, TestRun.TestsPassed,
                          TestRun.TestsFailed, TestRun.TestsSkipped, TestRun.TestsError]));

      output.Add(Format('    <collection name="Default" time="%.3f" '
                          + 'total="%d" passed="%d" failed="%d" skipped="%d">',
                          [TestRun.RunTime / 1000,
                           TestRun.TestCount, TestRun.TestsPassed, TestRun.TestsFailed,
                            TestRun.TestsSkipped]));

      for i := 0 to Pred(TestRun.ResultCount) do
      begin
        result := TestRun.Results[i];

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
