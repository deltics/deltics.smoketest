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



end.
