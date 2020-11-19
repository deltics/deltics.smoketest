
  unit Test.SelfTest;

interface

  uses
    Deltics.Smoketest.Test,
    Deltics.Smoketest.Assertions.Int64,
    Deltics.Smoketest.Assertions.Integers;


  type
    TSelfTest = class(TTest)
    protected
      procedure ExpectingException(const aExceptionClass: TClass; const aExceptionMessage: String = '');
      procedure AllAssertsExpectedToFail;
      procedure NextAssertExpectedToFail;
      procedure NextAssertsExpectedToFail(aCount: Integer);
      function Assert(aValue: Integer): IntegerAssertions; overload;
      function Assert(aValue: Int64): Int64Assertions; overload;
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
  procedure TSelfTest.AllAssertsExpectedToFail;
  begin
    TestRun.ExpectingToFail(-1);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TSelfTest.NextAssertsExpectedToFail(aCount: Integer);
  begin
    TestRun.ExpectingToFail(aCount);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TSelfTest.NextAssertExpectedToFail;
  begin
    TestRun.ExpectingToFail(1);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TSelfTest.Assert(aValue: Integer): IntegerAssertions;
  begin
    result := Test('test').Assert(aValue);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function TSelfTest.Assert(aValue: Int64): Int64Assertions;
  begin
    result := Test('test').Assert(aValue);
  end;



initialization
  TestRun := TTestRunHelper(Deltics.Smoketest.TestRun.TestRun);
end.
