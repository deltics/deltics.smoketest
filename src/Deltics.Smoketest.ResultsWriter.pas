
{$i Deltics.Smoketest.inc}

  unit Deltics.Smoketest.ResultsWriter;

interface

  uses
    Deltics.Smoketest.TestResult,
    Deltics.Smoketest.TestRun;


  type
    TResultsWriter = class
    public
      procedure SaveResults(const aTestRun: TTestRun; const aFilename: String); virtual; abstract;
      class procedure Register(const aName: String);
    end;
    TResultsWriterClass = class of TResultsWriter;


  // These types and constants are brought into scope to allow implementors
  //  of writer classes to only have to reference the ContinuityResultsWriter
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

    idx := TestRun.ResultsWriters.IndexOf(name);

    if idx <> -1 then
    begin
      TestRun.ResultsWriters.Objects[idx].Free;
      TestRun.ResultsWriters.Objects[idx] := writer;
    end
    else
      TestRun.ResultsWriters.AddObject(aName, writer);
  end;



{ TContinuityResultsWriter }

  class procedure TResultsWriter.Register(const aName: String);
  begin
    _Register(aName, self);
  end;

end.
