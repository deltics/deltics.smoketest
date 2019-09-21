# Introduction 
A lightweight testing framework.  If Smoketest had ever been released under a proper versioning scheme (as 1.0.0+), then this is version 2.0.0 - a major, breaking change.  If it were a movie franchise then this would be a re-boot or re-imagining.

The goal for this re-imagining was to create a unit testing framework free of any dependencies on anything other than the core Delphi RTL, enabling it to be simply and easily consumed in the widest possible variety of Delphi projects and all Delphi versions from 7 to current.  The emphasis is on simplicity, ease of use and efficiency.

The simplest possible test suite would be:

```
  {$apptype CONSOLE}
  program MyTests;

  uses Deltics.Smoketest;

    type
      TMyTest = class(TTest)
        procedure TestSimpleAddition;
      end;

    procedure TMyTest.TestSimpleAddition;
    var
      a, b: Integer;
    begin
      a := 2;
      b := 2;
      Assert('a + b = 4', (a + b) = 4);
    end;

  begin
    TestRun.Test(TMyTest);
  end.
```

## Test Run Output
Basic output is provided to the console during execution of the tests followed by a summary of test outcomes.  When running under the IDE the temporary console window created by the IDE to run the project will disappear the instant the test run is complete making it difficult to see this output.  To avoid this add a `-wait` option to the command line (via the `Run -> Parameters` menu in the IDE).  With this command line option specified, Smoketest will wait at the completion of a test run for a keypress before exiting.

**Only CONSOLE test suites are supported currently.**


## Saving Test Results To File
Smoketest 2.0 provides a framework that supports multiple different formats for capturing test results to file.

The result output framework requires you to specify on the command line of the test suite, the name of any format you wish to output followed by the filename to be output in that format.  The format name for xUnit 2 format results is `xunit2` so for a test suite compiled as `mytests.exe` to have Smoketest output results in that format to a file called `results.xml` use the following command line:

    mytests.exe -xunit2:results.xml

In future multiple formats may be specified to capture results for a single test run in multiple files of different formats.  At present only `xunit2` is supported.


## Writing Tests
Currently the mechanisms for performing tests are very basic, comprising only of an `Assert` and `AssertException` method.  An example of `Assert` appears above.  `AssertException` is used to test for expected exceptions:

```
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
```

Note that `AssertException` is used _twice_ but only one of these will actually be called.  The first will be called **only** if the operation does not raise the excepted exception and will cause the test to fail.  The second will be called **only** if an exception is raised and this test will fail if the exception that is caught is not of the expected type.

Notice that `AssertException` will pass only if the caught exception matches the expected exception class exactly.  To test for any exception that derives from a given exception class, use `AssertBaseException`. e.g. in the following example, _both_ tests will pass since the exception raised will be an **EDivByZero** exception and **EDivByZero** is also a subclass of the **Exception** class:

```
  try
    a := SomeOperationThatIsExpectedToCauseDivisionByZero;
        
  except
    AssertException(EDivByZero);
    AssertBaseException(Exception);
  end;
```

Both `AssertException` and `AssertBaseException` will construct a name for the test automatically based on the parameters and the context.  Alternatively an explicit test name may be provided as a second parameter.


# Getting Started - Duget Package
To use this library simply add `deltics.smoketest` to your project .duget file and run `duget update` to obtain the latest version available in any of your feeds (duget.org is recommended, or will be once it's up and running).


# Build and Test
The build pipeline for this package compiles a set of self-tests with every version of Delphi from 7 thru 10.3.  These tests use Smoketest to test itself.


# Roadmap

With no specific timeline in mind and in no particular order, some goals for this project include:

- Restoration of the fluent testing Api similar to the original Smoketest
- Additional results writer formats
- Documentation and examples