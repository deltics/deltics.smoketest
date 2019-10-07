
{$i Deltics.Smoketest.inc}

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
