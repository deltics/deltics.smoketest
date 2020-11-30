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

  unit Test.SelfTestResultsAndAccumulators;


interface

  uses
    Deltics.Smoketest.Accumulators,
    SelfTest;


  type
    TSelfTestResultsAndAccumulatorTests = class(TSelfTest)
    private
      ResultAccumulator: IAccumulator;
      ActualResultAccumulator: IAccumulator;
    published
      procedure SetupTest;
      procedure ThisTestWillPass;
      procedure ThisTestWillFail;
      procedure ThisTestWillThrowAnException;
      procedure AccumulatorTotalsAreCorrect;
      // --------------------------------------------------------------------------
      // Any additional tests must be introduced AFTER this point otherwise the
      //  expected tests counts in the TestResultsAreAsExpected test will be wrong
      //  (alternatively you will need to adjust those counts accordingly).
      //
      // Similarly, the TCoreFunctionality test MUST be the SECOND test executed
      //  for the same reason.
    end;


implementation

  uses
    SysUtils,
    Deltics.Smoketest.Accumulators.StateAccumulator,
    Deltics.Smoketest.Accumulators.ActualStateAccumulator,
    Deltics.Smoketest.TestRun,
    Deltics.Smoketest.Utils;



{ CoreFunctionality tests ------------------------------------------------------------------------ }

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TSelfTestResultsAndAccumulatorTests.SetupTest;
  begin
    // Register accumulators to collect stats for the tests that are
    //  about to follow

    ResultAccumulator       := Accumulators.Register(TStateAccumulator);
    ActualResultAccumulator := Accumulators.Register(TActualStateAccumulator);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TSelfTestResultsAndAccumulatorTests.ThisTestWillFail;
  begin
    Test.IsExpectedToFail;

    Test('This test will fail').Assert(FALSE);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TSelfTestResultsAndAccumulatorTests.ThisTestWillPass;
  begin
    Test('This test will pass').Assert(TRUE);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TSelfTestResultsAndAccumulatorTests.ThisTestWillThrowAnException;
  begin
    Test.IsExpectedToError;

    raise Exception.Create('This exception was deliberately raised');
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TSelfTestResultsAndAccumulatorTests.AccumulatorTotalsAreCorrect;
  begin
    // Detach our accumulator so that the tests we are about to perform do not
    //  affect the stats collected (which is what we're about to test)

    Accumulators.Detach(ResultAccumulator);
    Accumulators.Detach(ActualResultAccumulator);

    Test('ActualResult.Total').Assert(ActualResultAccumulator.Count).Equals(3);
    Test('ActualResult.Pass').Assert(ActualResultAccumulator.Pass).Equals(1);
    Test('ActualResult.Fail').Assert(ActualResultAccumulator.Fail).Equals(1);
    Test('ActualResult.Error').Assert(ActualResultAccumulator.Error).Equals(1);

    Test('Result.Total').Assert(ResultAccumulator.Count).Equals(3);
    Test('Result.Pass').Assert(ResultAccumulator.Pass).Equals(3);
    Test('Result.Fail').Assert(ResultAccumulator.Fail).Equals(0);
    Test('Result.Error').Assert(ResultAccumulator.Error).Equals(0);
  end;



end.
