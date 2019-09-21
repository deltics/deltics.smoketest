
{$i Deltics.Continuity.inc}

  unit Deltics.Continuity.ResultsWriter;

interface

  uses
    Deltics.Continuity.TestResult,
    Deltics.Continuity.TestRun;


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
    TTestResult = Deltics.Continuity.TestResult.TTestResult;
    TTestRun    = Deltics.Continuity.TestRun.TTestRun;

  const
    rsPass  = Deltics.Continuity.TestResult.rsPass;
    rsFail  = Deltics.Continuity.TestResult.rsFail;
    rsSkip  = Deltics.Continuity.TestResult.rsSkip;
    rsError = Deltics.Continuity.TestResult.rsError;



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
