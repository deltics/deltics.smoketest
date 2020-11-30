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

  unit Test.DeprecatedAssert;


interface

  uses
    Deltics.Smoketest.Accumulators,
    SelfTest;


  type
    TDeprecatedAssertTests = class(TSelfTest)
    private
      Accumulator: IAccumulator;
    published
      procedure SetupTest;
      procedure ThisTestWillPass;
      procedure ThisTestWillFail;
      procedure ThisTestWillThrowAnException;
      procedure ExpectedTestRunStats;
      // --------------------------------------------------------------------------
      // Any additional tests must be introduced AFTER this point otherwise the
      //  expected tests counts in the previous test will be wrong
      //  (alternatively you will need to adjust the expected stats).
    end;


implementation

  uses
    SysUtils,
    Deltics.Smoketest.Accumulators.ActualStateAccumulator,
    Deltics.Smoketest.Accumulators.StateAccumulator,
    Deltics.Smoketest.TestRun,
    Deltics.Smoketest.Utils;



{ CoreFunctionality tests ------------------------------------------------------------------------ }

  {$warnings off}

  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDeprecatedAssertTests.SetupTest;
  begin
    // Register an accumulator to collect stats for the tests that are
    //  about to follow

    Accumulator := Accumulators.Register(TActualStateAccumulator);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDeprecatedAssertTests.ThisTestWillFail;
  begin
    Test.IsExpectedToFail;

    Assert('This test failed', FALSE);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDeprecatedAssertTests.ThisTestWillPass;
  begin
    Assert('This test passed', TRUE);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDeprecatedAssertTests.ThisTestWillThrowAnException;
  begin
    Test.IsExpectedToError;

    raise Exception.Create('This exception was deliberately raised');
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  procedure TDeprecatedAssertTests.ExpectedTestRunStats;
  begin
    // Detach our accumulator so that the tests we are about to perform do not
    //  affect the stats collected (which is what we're about to test)

    Accumulators.Detach(Accumulator);

    Assert('3 tests recorded to this point', Accumulator.Count = 3, Format('%d tests counted, 3 expected', [Accumulator.Count]));
    Assert('1 test passed at this point', Accumulator.Pass = 1, Format('%d tests passed, 1 expected', [Accumulator.Pass]));
    Assert('1 test failed at this point', Accumulator.Fail = 1, Format('%d tests failed, 1 expected', [Accumulator.Fail]));
    Assert('1 test error at this point', Accumulator.Error = 1, Format('%d errors, 1 expected', [Accumulator.Error]));
  end;


end.

