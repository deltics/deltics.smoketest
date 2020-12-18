{
  * MIT LICENSE *

  Copyright © 2020 Jolyon Smith

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

  unit Test.ExceptionHandling;


interface

  uses
    Deltics.SmokeTest,
    SelfTest;


  type
    TExceptionHandlingTests = class(TSelfTest)
      procedure ExactExceptionSatisfiesTestForThatExceptionClass;
      procedure ExceptionSatisfiesTestForGeneralisedException;
      procedure ExceptionThatDoesNotSatisfyTestForGeneralisedExceptionCausesTestToFail;
      procedure TestExceptionPassesIfRaisedExceptionMessageMatchesTheRequiredText;
      procedure TestExceptionPassesIfRaisedExceptionMessageContainsTheRequiredText;
      procedure TestExceptionFailsIfRaisedExceptionDoesNotContainTheRequiredText;
      procedure TestThatExpectsAnExceptionFailsWhenNoneIsRaised;
      procedure MultipleExceptionTestsCanBePerformedUsingTryExcept;
      procedure FailedToRaiseExceptionFailsTheTestWhenExpectedExceptionIsNotRaised;
      procedure RaisedExceptionFailsWhenExceptionOfWrongClassIsRaised;
      procedure RaisedExceptionFailsWhenExceptionRaisedOfExpectedClassHasWrongMessage;
      procedure RaisedExceptionOfStillFailsWhenFailedToRaiseExceptionRaisesENoExceptionRaised;
      procedure RaisedExceptionOfFailsWhenExceptionOfWrongClassIsRaised;
      procedure RaisedExceptionOfFailsWhenExceptionRaisedOfExpectedClassHasWrongMessage;
    end;




implementation

  uses
    SysUtils,
    Deltics.Smoketest.TestRun;


{ ExceptionHandling tests ------------------------------------------------------------------------ }

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TExceptionHandlingTests.ExactExceptionSatisfiesTestForThatExceptionClass;
  begin
    Test.RaisesExceptionOf(EDivByZero);

    raise EDivByZero.Create('This exception was deliberately raised');
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TExceptionHandlingTests.ExceptionSatisfiesTestForGeneralisedException;
  begin
    Test.RaisesExceptionOf(Exception);

    raise EDivByZero.Create('EDivByZero is an Exception');
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TExceptionHandlingTests.ExceptionThatDoesNotSatisfyTestForGeneralisedExceptionCausesTestToFail;
  begin
    Test.IsExpectedToFail;
    Test.RaisesExceptionOf(EInvalidOp);

    raise EDivByZero.Create('Testing for a specific exception type');
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TExceptionHandlingTests.TestThatExpectsAnExceptionFailsWhenNoneIsRaised;
  begin
    Test.IsExpectedToFail;

    Test.RaisesExceptionOf(Exception);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TExceptionHandlingTests.TestExceptionFailsIfRaisedExceptionDoesNotContainTheRequiredText;
  begin
    Test.IsExpectedToFail;
    Test.RaisesException(Exception, 'is the');

    raise Exception.Create('This message text');
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TExceptionHandlingTests.TestExceptionPassesIfRaisedExceptionMessageContainsTheRequiredText;
  begin
    Test.RaisesException(Exception, 'message text');

    raise Exception.Create('This message text');
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TExceptionHandlingTests.TestExceptionPassesIfRaisedExceptionMessageMatchesTheRequiredText;
  begin
    Test.RaisesException(Exception, 'This message text');

    raise Exception.Create('This message text');
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TExceptionHandlingTests.MultipleExceptionTestsCanBePerformedUsingTryExcept;
  var
    acc: IAccumulator;
  begin
    acc := Accumulators.New;
    try
      raise Exception.Create('This exception is detected');

    except
      Test.RaisedException(Exception, 'This exception is detected');
    end;

    try
      raise Exception.Create('This exception is also detected');

    except
      Test.RaisedException(Exception, 'This exception is also detected');
    end;

    try
      raise Exception.Create('The message on this exception is not important');

    except
      Test.RaisedException(Exception);
    end;

    Accumulators.Detach(acc);

    Test('Exception tests performed').Assert(acc.Count).Equals(3);
    Test('Exception tests pass').Assert(acc.Pass).Equals(3);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TExceptionHandlingTests.FailedToRaiseExceptionFailsTheTestWhenExpectedExceptionIsNotRaised;
  begin
    Test.IsExpectedToFail;
    try
      Test.FailedToRaiseException;

    except
      Test.RaisedException(Exception);
    end;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TExceptionHandlingTests.RaisedExceptionFailsWhenExceptionRaisedOfExpectedClassHasWrongMessage;
  begin
    Test.IsExpectedToFail;
    try
      raise Exception.Create('This exception has the wrong message');

    except
      Test.RaisedException(Exception, 'This exception has a specific message');
    end;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TExceptionHandlingTests.RaisedExceptionFailsWhenExceptionOfWrongClassIsRaised;
  begin
    Test.IsExpectedToFail;
    try
      raise EConvertError.Create('This is the wrong exception, the message is irrelevant');

    except
      Test.RaisedException(EArgumentException);
    end;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TExceptionHandlingTests.RaisedExceptionOfStillFailsWhenFailedToRaiseExceptionRaisesENoExceptionRaised;
  begin
    Test.IsExpectedToFail;
    try
      // This test is significant because FailedToRaiseException will itself raise an
      //  ENoExceptionRaised exception, which derives from Exception, and this test
      //  is using RaisedExceptionOf(Exception) so the ENoExceptionRaised should
      //  ordinarily cause this test to PASS.  However, the ENoExceptionRaised class
      //  is treated as a special case by Smoketest, and this test should still FAIL.

      Test.FailedToRaiseException;

    except
      Test.RaisedExceptionOf(Exception);
    end;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TExceptionHandlingTests.RaisedExceptionOfFailsWhenExceptionRaisedOfExpectedClassHasWrongMessage;
  begin
    Test.IsExpectedToFail;
    try
      raise Exception.Create('This exception has the wrong message');

    except
      Test.RaisedExceptionOf(Exception, 'This exception has a specific message');
    end;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TExceptionHandlingTests.RaisedExceptionOfFailsWhenExceptionOfWrongClassIsRaised;
  begin
    Test.IsExpectedToFail;
    try
      raise EConvertError.Create('This is the wrong exception, the message is irrelevant');

    except
      Test.RaisedExceptionOf(EArgumentException);
    end;
  end;



end.
