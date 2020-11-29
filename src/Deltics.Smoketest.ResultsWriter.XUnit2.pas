{
  * MIT LICENSE *

  Copyright © 2019 Jolyon Smith

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
    SysUtils,
    Deltics.Smoketest.Accumulators,
    Deltics.Smoketest.Utils;


{ TXUnit2Writer ---------------------------------------------------------------------------------- }

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TXUnit2Writer.SaveResults(const aFilename: String);
  var
    i: Integer;
    output: TStringList;
    y, m, d, h, n, s, z: Word;
    result: TTestResult;
    state: String;
    results: IAccumulator;
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

      results := TestRun.Results;

      output.Add(Format('  <assembly name="%s" test-framework="Smoketest" environment="%s" '
                        + 'run-date="%d-%.2d-%.2d" run-time="%.2d:%.2d:%.2d" '
                        + 'time="%.3f" '
                        + 'total="%d" passed="%d" failed="%d" skipped="%d" errors="%d">',
                        [TestRun.Name,
                         TestRun.Environment,
                         y, m, d, h, n, s,
                         TestRun.RunTime / 1000,
                         results.Count, results.Pass, results.Fail, results.Skip, results.Error]));

      output.Add(Format('    <collection name="Default" time="%.3f" '
                          + 'total="%d" passed="%d" failed="%d" skipped="%d">',
                          [TestRun.RunTime / 1000,
                           results.Count, results.Pass, results.Fail, results.Skip]));

      for i := 0 to Pred(results.Count) do
      begin
        result := results[i];

        case result.State of
          rsPass  : state := 'Pass';
          rsSkip  : state := 'Skip';
          rsFail  : state := 'Fail';
          rsError : state := 'Error';
        end;

        if (result.State = rsPass) or (result.ErrorMessage = '') then
        begin
          output.Add(Format('      <test name="%s" type="%s" method="%s" time="0" result="%s" />',
                                   [XmlEncodedAttr(result.TestName), result.TypeName, result.TestMethod, state]));
          CONTINUE;
        end;

        output.Add(Format('      <test name="%s" type="%s" method="%s" time="0" result="%s">',
                                 [XmlEncodedAttr(result.TestName), result.TypeName, result.TestMethod, state]));
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
