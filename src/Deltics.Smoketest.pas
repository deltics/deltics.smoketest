
{$i Deltics.Smoketest.inc}

  unit Deltics.Smoketest;

interface

  uses
    Deltics.Smoketest.Test,
    Deltics.Smoketest.TestRun;

  // Elevate the scope of the TTest class so that test class implementation units
  //  need only reference Deltics.Smoketest.
  type
    TTest = Deltics.Smoketest.Test.TTest;

  // This function provides read-only access to the TestRun variable maintained
  //  in the TestRun implementation unit.
  function TestRun: TTestRun;


implementation

  // NOTE: Ensure that results writer implementations are added to the uses clause!
  uses
    Deltics.Smoketest.ResultsWriter.XUnit2;


  function TestRun: TTestRun;
  begin
    result := Deltics.Smoketest.TestRun.TestRun;
  end;


end.
