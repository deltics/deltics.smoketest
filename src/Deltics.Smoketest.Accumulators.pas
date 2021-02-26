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

  unit Deltics.Smoketest.Accumulators;


interface

  uses
    Classes,
    Deltics.Smoketest.TestResult;


  type
    TTestResult = Deltics.Smoketest.TestResult.TTestResult;

  const
    rsError = Deltics.Smoketest.TestResult.rsError;
    rsFail  = Deltics.Smoketest.TestResult.rsFail;
    rsPass  = Deltics.Smoketest.TestResult.rsPass;
    rsSkip  = Deltics.Smoketest.TestResult.rsSkip;



  type
    IAccumulator = interface
    ['{73B54089-CB9E-4DD7-A5B5-66F14D410FB8}']
      function get_Count: Integer;
      function get_Pass: Integer;
      function get_Error: Integer;
      function get_Fail: Integer;
      function get_Skip: Integer;
      function get_Result(const aIndex: Integer): TTestResult;
      procedure Accumulate(const aResult: TTestResult);

      property Count: Integer read get_Count;
      property Pass: Integer read get_Pass;
      property Error: Integer read get_Error;
      property Fail: Integer read get_Fail;
      property Skip: Integer read get_Skip;
      property Results[const aIndex: Integer]: TTestResult read get_Result; default;
    end;


    TAccumulator = class(TInterfacedObject, IAccumulator)
    private
      fResults: TList;
    protected
      PassCount: Integer;
      ErrorCount: Integer;
      FailCount: Integer;
      SkipCount: Integer;
    protected
      procedure UpdateCounts(const aResult: TTestResult; var aPass, aFail, aSkip, aError: Integer); virtual; abstract;
    public // IAccumulator
      function get_Count: Integer;
      function get_Pass: Integer;
      function get_Error: Integer;
      function get_Fail: Integer;
      function get_Skip: Integer;
      function get_Result(const aIndex: Integer): TTestResult;
      procedure Accumulate(const aResult: TTestResult);
      property Results[const aIndex: Integer]: TTestResult read get_Result; default;
    public
      constructor Create; virtual;
      destructor Destroy; override;
    end;
    TAccumulatorClass = class of TAccumulator;


    Accumulators = class
    protected
      class procedure Execute(const aResult: TTestResult);
    public
      class procedure Detach(const aAccumulator: IAccumulator);
      class function New: IAccumulator;
      class function Register(const aClass: TAccumulatorClass): IAccumulator;
    end;





implementation

  uses
    SysUtils,
    Deltics.Smoketest.Accumulators.ActualStateAccumulator,
    Deltics.Smoketest.Types;


  var
    _Accumulators: array of IAccumulator;



  class procedure Accumulators.Execute(const aResult: TTestResult);
  var
    i: Integer;
  begin
    for i := Low(_Accumulators) to High(_Accumulators) do
      _Accumulators[i].Accumulate(aResult);
  end;


  class procedure Accumulators.Detach(const aAccumulator: IAccumulator);
  var
    i, j: Integer;
    remaining: array of IAccumulator;
  begin
    if NOT Assigned(aAccumulator) then
      raise ESmoketestError.Create('Attempt to detach a NIL accumulator reference');

    SetLength(remaining, Length(_Accumulators) - 1);

    j := 0;
    for i := 0 to Pred(Length(_Accumulators)) do
    begin
      if _Accumulators[i] <> aAccumulator then
        remaining[j] := _Accumulators[i]
      else
        Inc(j);
    end;

    SetLength(_Accumulators, Length(remaining));

    for i := 0 to Pred(Length(remaining)) do
      _Accumulators[i] := remaining[i];
  end;


  class function Accumulators.New: IAccumulator;
  begin
    result := Register(TActualStateAccumulator);
  end;


  class function Accumulators.Register(const aClass: TAccumulatorClass): IAccumulator;
  var
    obj: TObject;
  begin
    if (aClass = TAccumulator) then
      raise ESmoketestError.Create('Cannot register TAccumulator deirectly.  You must provide a sub-class of TAccumulator that overrides UpdateCounts');

    obj := aClass.Create;

    if Supports(obj, IAccumulator, result) then
    begin
      SetLength(_Accumulators, Length(_Accumulators) + 1);
      _Accumulators[Length(_Accumulators) - 1] := result;
    end
    else
    begin
      obj.Free;
      raise ESmoketestError.CreateFmt('%s does not implement IAccumulator', [aClass.ClassName]);
    end;
  end;


  procedure TAccumulator.Accumulate(const aResult: TTestResult);
  begin
    fResults.Add(aResult);

    UpdateCounts(aResult, PassCount, FailCount, SkipCount, ErrorCount);
  end;


  function TAccumulator.get_Error: Integer;
  begin
    result := ErrorCount;
  end;


  function TAccumulator.get_Fail: Integer;
  begin
    result := FailCount;
  end;


  function TAccumulator.get_Pass: Integer;
  begin
    result := PassCount;
  end;


  function TAccumulator.get_Result(const aIndex: Integer): TTestResult;
  begin
    result := TTestResult(fResults[aIndex]);
  end;


  function TAccumulator.get_Skip: Integer;
  begin
    result := SkipCount;
  end;


  constructor TAccumulator.Create;
  begin
    inherited;

    fResults := TList.Create;
  end;


  destructor TAccumulator.Destroy;
  begin
    fResults.Free;

    inherited;
  end;


  function TAccumulator.get_Count: Integer;
  begin
    result := fResults.Count;
  end;






initialization
  // NO-OP

finalization
  SetLength(_Accumulators, 0);
end.
