# Introduction 
A lightweight testing framework.  If Smoketest had ever been released under a proper versioning scheme as 1.0.0, then this would be version 2.0.0 - a major, breaking change.  If it were a movie franchise then this would be a re-boot or re-imagining.

The goal for this re-imagining was to create a unit testing framework free of any dependencies on anything other than the core Delphi RTL, enabling it to be simply and easily consumed in the widest possible variety of Delphi projects.

Only CONSOLE test suites are supported currently.

The simplest possible test suite would be:

```
  {$apptype CONSOLE}
  program MyTests;

  uses Deltics.Smoketest;

  type TMyTest = class(TTest)
         procedure TestSimpleAddition;
       end;

    procedure TMyTest.TestSimpleAddition;
    var
      a, b: Integer;
    begin
      a := 2;
      b := 2;
      Assert('a + b = 4', (a + b) = 4, 'a + b in fact equals ' + IntToStr(a + b));
    end;

  begin
    TestRun.Test(TMyTest);
  end.
  }
```

Currently the mechanisms for performing tests are very basic, comprising only of an `Assert` and `AssertException` method.  An example of `Assert` appears above.  `AssertException` is used to test for expected exceptions:

    procedure TMyTest.TestDivisonByZeroError;
    var
      a: Integer;
    begin
      try
        a := SomeOperationThatIsExpectedToCauseDivisionByZero;

        AssertException(EDivByZero);
      except
        AssertException(EDivByZero);
      end;
    end;

Note that `AssertException` is used _twice_ but only one of these will actually be called.  The first will be called **only** if the operation does not raise the excepted exception and will cause the test to fail.  The second will be called **only** if an exception is raised and this test will fail if the exception that is caught is not of the expected type or has a different message to that specified (an optional second parameter to the `AssertException` test.  If no message is specified then only the exception class is significant for the test).

The `AssertException` test will construct a name for the test automatically based on the parameters and the context.  Alternatively an explicit test name may be provided as a third parameter.  To specify a test name where the exception message is not important to the test simply pass an empty string in the second parameter.


# Getting Started - Duget Package
To use this library simply add `deltics.smoketest` to your project .duget file and run `duget update` to obtain the latest version available in any of your feeds (duget.org is recommended, or will be once it's up and running).

# Build and Test
The build pipeline for this package compiles a set of self-tests with every version of Delphi from 7 thru 10.3.  These tests use Smoketest to test itself.