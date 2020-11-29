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

  unit Deltics.Smoketest.ResultsWriter;

interface

  uses
    Deltics.Smoketest.TestResult,
    Deltics.Smoketest.TestRun;


  type
    TResultsWriter = class
    {
      Base class for result writer implementations.  Register your implementation
       in the initialization section of your implementation unit.

      NOTE: To maintain the ability for consumers of the Smoketest framework to
             only need to 'use' the Deltics.Smoketest unit, be sure to add any
             result writer unit to the implementation uses clause of the
             Deltics.Smoketest unit.  This will ensure that the writer
             implementation is 'used' and therefore registered for use at runtime.
    }
    private
      fTestRun: TTestRun;
    public
      procedure SaveResults(const aFilename: String); virtual; abstract;
      property TestRun: TTestRun read fTestRun;
      class procedure Register(const aName: String);
    end;
    TResultsWriterClass = class of TResultsWriter;


  // These types and constants are brought into scope to allow implementors
  //  of writer classes to only have to reference the Deltics.Smoketest.ResultsWriter
  //  unit in their writer implementation units.
  type
    TTestResult = Deltics.Smoketest.TestResult.TTestResult;
    TTestRun    = Deltics.Smoketest.TestRun.TTestRun;

  const
    rsPass  = Deltics.Smoketest.TestResult.rsPass;
    rsFail  = Deltics.Smoketest.TestResult.rsFail;
    rsSkip  = Deltics.Smoketest.TestResult.rsSkip;
    rsError = Deltics.Smoketest.TestResult.rsError;


implementation

  uses
    SysUtils;


  procedure _Register(const aName: String;
                      const aWriterClass: TResultsWriterClass);
  var
    idx: Integer;
    name: String;
    writer: TResultsWriter;
  begin
    name    := Lowercase(aName);
    writer  := aWriterClass.Create;
    writer.fTestRun := TestRun;

    idx := TestRun.ResultsWriters.IndexOf(name);

    if idx <> -1 then
    begin
      TestRun.ResultsWriters.Objects[idx].Free;
      TestRun.ResultsWriters.Objects[idx] := writer;
    end
    else
      TestRun.ResultsWriters.AddObject(aName, writer);
  end;



  class procedure TResultsWriter.Register(const aName: String);
  begin
    _Register(aName, self);
  end;



end.
