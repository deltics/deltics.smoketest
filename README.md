# Build status

| Master | Develop |
|--------|---------|
|[![Build Status](https://dev.azure.com/deltics/Congress/_apis/build/status/deltics.smoketest?repoName=deltics%2Fdeltics.smoketest&branchName=master)](https://dev.azure.com/deltics/Congress/_build/latest?definitionId=33&repoName=deltics%2Fdeltics.smoketest&branchName=master)|[![Build Status](https://dev.azure.com/deltics/Congress/_apis/build/status/deltics.smoketest?repoName=deltics%2Fdeltics.smoketest&branchName=develop)](https://dev.azure.com/deltics/Congress/_build/latest?definitionId=33&repoName=deltics%2Fdeltics.smoketest&branchName=develop)|


# New in 2.7.0 / 2.6.0 / 2.5.0 / 2.4.0

* 2.4 made refinements to methods for testing exceptions
* 2.5 provided additional tests for String assertions (e.g. Contains, ContainsText, DoesNotContain etc) as well as introducing Boolean and Utf8String assertions
* 2.6 introduced Interface assertions
* 2.7 introduces Double assertions


# New in 2.3.0 / 2.2.0

2.2.0 and 2.3.0 were incremental releases adding Assert()s for further types:

* 2.2.0 Introduced: PointerAssertions
* 2.3.0 Introduced: GuidAssertions

Fixes to address compiler warnings in Delphi 7 builds from deprecated methods (for the older non-fluent Assert() tests) are also incorporated as of 2.1.2 and of course these later versions also.


# New in 2.1.0
2.1.0 was a **BIG** update to Smoketest!

A lot of the work in 2.1 took place 'in the engine room', simplifying aspects of the implementation relating to the writing of self-tests for the framework itself, resulting in a framework that allows tests to register 'accumulators' which can collect test results as they occur, allowing for subsequent tests to perform tests over those test results.

The biggest change apparent in the creation of tests (i.e. for users of the framework) is the introduction of fluent assertions and a massively simplified syntax for testing for exceptions (or not, as the case may be).

In summary:

- Updated with Delphi 10.4 support
- Fluent Assertions
- **hugely** streamlined exception testing
- Accumulators framework (simplified self-test mechanisms among other things)
- Default behaviour when running under the debugger is now to wait for user confirmation ("Hit ENTER") at the end of a test run
- Bug fixes



# Introduction
Smoketest is a lightweight testing framework.  If Smoketest had ever been released under a proper versioning scheme (as 1.0.0+), then version 2.x was a major, breaking change.  If it were a movie franchise then it would be the **(Nolan/Bale's) Batman Begins** to **(Burton/Keaton's) Batman**; a re-boot or re-imagining.

The goal for this re-imagining was to create a unit testing framework free of any dependencies on anything other than the core Delphi RTL, enabling it to be simply and easily consumed in the widest possible variety of Delphi projects and all Delphi versions from 7 to current.  The emphasis is on simplicity, ease of use and efficiency.

The two examples that follow illustrate a very simple test, first using 2.0 style Assert()s then in the fluent-style assertions introduced in 2.1:

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

      // This test uses 2.0.x style assert calls

      Assert('a + b = 4', (a + b) = 4);
    end;

  begin
    TestRun.Test(TMyTest);
  end.
```

_NOTE: The above assertion style is deprecated in 2.1 and will be removed in a future version._

The example below demonstrates fluent assertions which are the supported style going forward from 2.1:

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

      // This test uses 2.1+ style fluent-assertions

      Test('a + b').Assert(a + b).Equals(4);
    end;

  begin
    TestRun.Test(TMyTest);
  end.
```

## Test Run Output
Basic output is provided to the console during execution of the tests followed by a summary of test outcomes.  When running under the IDE the temporary console window created by the IDE to run the project will disappear the instant the test run is complete making it difficult to see this output.  To avoid this add a `-wait` option to the command line (via the `Run -> Parameters` menu in the IDE).  With this command line option specified, Smoketest will wait at the completion of a test run for a keypress before exiting.

**Only CONSOLE test suites are supported currently.**

[_New in 2.1.0_]

To reduce the amount of 'noise' in the console output, only test failures or errors are reported to the console by default.  For full output, including passed tests, specify `-showAllResults` (or the short form: `-a`) on the command line when executing the test exe.  This does not affect the totals in the test run summary output to the console at the end of a run, nor does it affect the output of any results writers.


## Saving Test Results To File
Smoketest 2.x provides a framework that supports multiple different formats for capturing test results to file.

The result output framework requires you to specify on the command line of the test suite, the name of any format you wish to output followed by the filename to be output in that format.  The format name for xUnit 2 format results is `xunit2` so for a test suite compiled as `mytests.exe` to have Smoketest output results in that format to a file called `results.xml` use the following command line:

```
    mytests.exe -xunit2:results.xml
```

In future multiple formats may be specified to capture results for a single test run in multiple files of different formats.  At present only `xunit2` is supported.


# Writing Tests

## Fluent Assertions
[_New in 2.1.0_]

Currently basic fluent assertions are provided for booleans and all string types (Ansi, Wide and Unicode where relevant) as well as integers and some basic assertions for dates and datetimes.  The importance of the 2.1 release was in stabilising the approach to implementing these assertions in the framework.  Over time these existing assertions will be extended and support for additional types introduced.

Fluent assertions start with `Test()` call which accepts a name or description of the value or expression being tested.
This is then followed by a call to the overloaded `Assert()` method, taking a single parameter which is the value to be tested (or the result of some expression).

```
    Test(aName: String).Assert(aValue: Integer);
```

On its own, a call to such an `Assert` method achieves nothing except return an interface with assertion methods appropriate to the type of the value involved.  In the above case, this would be an `IntegerAssertions` interface.  A test is performed when one of the assertion methods on this interface is called.  The most basic is an equality test, so for example if we have some value `TestCount` that we expect to have a value of `3`:

```
    Test('Result.Count').Assert(Result.Count).Equals(3);
```

Unlike the 2.0.x assert mechanism, fluent assertion methods derive an explanation for any test failure automatically.  Without fluent assertions, the test name was often quite lengthy as it needed to express the intent of a test as well as identifying the value being tested.  With fluent assertions, the intent of the test is expressed in the description of the test derived from the fluent assertion itself.  As a result, the value provided to the initial `Test()` method can usually be less verbose, often simply identifying the value or expression under test.  As an example, the derived failure reason for the example above might present something similar to:

```
    Result.Count (5) does not equal 3
```

## AssertionResult: Conditional Flows Based on Test Results

All assertion methods return an `AssertionResult` which provides details of the results for that individual assertion.  In most cases this result can be ignored, but where necessary these details can be used to determine whether or not to abort the test run:

```
    if Test('Result.Count').Assert(Result.Count).Equals(3).Failed then
      TestRun.Abort;
```

## AssertionResult: Customised Failure Reasons

As well as providing the test result outcome, the `AssertionResult` allows you to override the automatically derived test failure reason if desired:

```
    Test('Result.Count').Assert(Result.Count).Equals(42).FailsBecause('There should be {expected} results in {valueName}, but the number counted was {value}');
```

Would result in a failure reason similar to:

```
    There should be 42 results in Result.Count, but the number counted was 41
```

The `FailsBecause` method itself returns the same `AssertionResult` so you can continue to test the result if required:

```
    if Test('Result.Count').Assert(Result.Count).Equals(42).FailsBecause('reasons...').Failed then
      TestRun.Abort;
```

## AssertionResult: FailsBecause() Token Substitution
As illustrated in the customised failure reason above, the string provided to `FailsBecause` can include tokens to subsitute values used in the assertion.  The tokens that are supported vary according to the particular assertion involved.

All assertions support `value` and `valueName` tokens to substitute the value that was supplied to the `Assert()` method and the name supplied to the `Test()` method, respectively.  Tokens are identified in the reason string by surrounding `{}` braces:

```
    foo := 6;
    Test('foo').Assert(foo).Equals(12).FailsBecause('{valueName} has value {value}');
```

Results in a test failure reason of:

```
    foo has value 6
```

`valueWithName` is also supported by all assertions and is equivalent to: `{valueName} ({value})'.

An `Equals()` assertion will typically support a token for the expected value.  That is, the value supplied to the `Equals()` call:

```
    foo := 6;
    Test('foo').Assert(foo).Equals(12).FailsBecause('{valueWithName} was supposed to be {expected}');
```

Results in a test failure reason of: `foo (6) was supposed to be 12`

Refer to the documentation for each assertion for details of the specified tokens supported.  (_At time of writing that documentation is on the roadmap.  For the time being you will need to examine the source to determine the supported tokens.  Sorry_)


# Testing for Exceptions
[_New in 2.1.0_]

A new, less verbose mechanism for testing for expected exceptions is introduced in 2.1.0.  This mechanism uses a version of the `Test()` method which accepts no parameters.  This parameterless `Test` method returns `ExceptionAssertions` and can only be used to test for exceptions.

Three methods are provided by `ExceptionAssertions`:

- RaisesExceptionOf
- RaisesException
- RaisesNoException

## RaisesExceptionOf
`Test.RaisesExceptionOf(aExceptionOrBaseClass: TClass[; aMessage: String])` indicates that the test method is expected to raise an unhandled exception of the specified class or an exception that is a sub-class of that specified class.  An optional message may be provided.

If an exception is raised of an appropriate, expected class it is considered a successful test only if the message on the raised exception _exactly_ matches the specified message **or** no such message is specified.

```
    procedure TMyTestClass.SomeTestMethod;
    begin
      Test.RaisesExceptionOf(Exception);

      raise EInvalidOp.Create('This test will pass!');
    end;
```

In the above example the test passes because `EInvalidOp` is a sub-class of the specified exception class, `Exception`.

## RaisesException
`Test.RaisesException(aExceptionClass: TClass[; aMessage: String])` indicates that the test method is expected to raise an unhandled exception of the _exact_ class specified.  An optional message may be provided.  This behaves in exactly the same way as `RaisesExceptionOf` except that the expected exception to be raised must be of the specific class that is specified.

```
    procedure TMyTestClass.SomeTestMethod;
    begin
      Test.RaisesException(Exception);

      raise EInvalidOp.Create('This test will FAIL because EInvalidOp <> Exception!');
    end;
```

However, if no exception class is specified then `RaisesException([aMessage: String])` is exactly equivalent to calling `RaisesExceptionOf()` and specifying the `Exception` class.

```
    procedure TMyTestClass.SomeTestMethod;
    begin
      Test.RaisesException;

      raise EInvalidOp.Create('This test will pass!');
    end;
```

## RaisesNoException
`Test.RaisesNoException` indicates that the test method is expected to complete without any unhandled exceptions being raised.  This is if perhaps only limited use but avoids having to use an `Assert(TRUE)` to indicate that an exception free flow to completion of the method is all that is required to consitute a successful test in some circumstances.


### NOTE
_Only one exception test can be specified.  An attempt to specify an additional exception test (or RaisesNoException) will cause an `ESmoketestError` to be raised, indicating improper use of the framework._


## Exceptions and Test Outcomes
- Test method exits with an unhandled exception and no exception of any type was expected: An ERROR result is recorded.
- Test method exits with an unhandled exception which does _not_ match a specified, expected exception: A FAIL result is recorded.
- Test method exits with an unhandled exception which matches a specified, expected exception: A PASS result is recorded.
- Test method exits with **no** unhandled exception when _some_ exception was expected: A FAIL result is recorded.
- Test method exits with **no** unhandled exception and a _`RaisesNoException`_ test was specified: A PASS result is recorded (_even if no other `Assert()`s were performed in that test method_).


## DEPRECATED: AssertException / AssertBaseException
The `AssertException` and `AssertBaseException` mechanism is deprecated as of 2.1.0.  It is still supported but will be removed in a future version.  New tests should use the new mechanism and any existing tests should be converted to it.

`AssertException` is used to test for expected exceptions:

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

Note that `AssertException` is used _twice_ but only one of these will actually be called.  The first, in the `try` body, will be called **only** if the operation does not raise the excepted exception and will cause the test to fail.  The second, in the `except` section, will be called **only** if an exception is raised and this test will fail if the exception that is caught is not of the expected type.

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

**NOTE:** _Exception related assertions do not return an `AssertionResult`_.


# Getting Started - Duget Package
To use this library simply add `deltics.smoketest` to your project .duget file and run `duget update` to obtain the latest version available in any of your feeds (duget.org is recommended, or will be once it's up and running).


# Build and Test
The build pipeline for this package compiles a set of self-tests with every version of Delphi from 7 thru 10.4.  These tests use Smoketest to test itself.


# Roadmap

With no specific timeline in mind and in no particular order, some goals for this project include:

- Additional type support for fluent assertions
- A mechanism and guide for introducing custom fluent assertions (to support project specific type assertions)
- Additional results writer formats
- Further documentation and examples