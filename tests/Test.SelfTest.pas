
  unit Test.SelfTest;

interface

  uses
    Deltics.Smoketest.Test;


  type
    TSelfTest = class(TTest)
    protected
      procedure ExpectingException(const aExceptionClass: TClass; const aExceptionMessage: String);
      procedure NextAssertExpectedToFail;
    end;



implementation

  uses
    Deltics.Smoketest.TestRun;

  // More shenanigans to obtain privileged access to protected members of the TestRun
  //  in order to record test completion and other details plus (in this case) other
  //  capabilities specifically designed to be used solely by self-tests.
  type
    TTestRunHelper = class(TTestRun);

  // For convenience we'll keep a ready-reference to the type-cast TestRun
  var
    TestRun: TTestRunHelper;



{ TSelfTest -------------------------------------------------------------------------------------- }

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TSelfTest.ExpectingException(const aExceptionClass: TClass;
                                         const aExceptionMessage: String);
  begin
    TestRun.ExpectingException(aExceptionClass, aExceptionMessage);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TSelfTest.NextAssertExpectedToFail;
  begin
    TestRun.ExpectingToFail;
  end;




initialization
  TestRun := TTestRunHelper(Deltics.Smoketest.TestRun.TestRun);
end.
