
{$i Deltics.Smoketest.inc}

  unit Deltics.Smoketest.TestResult;

interface

  type
    TResultState = (rsPass, rsFail, rsSkip, rsError);

    TTestResult = class
    private
      fTestIndex: Integer;
      fTestName: String;
      fTypeName: String;
      fMethodName: String;
      fErrorMessage: String;
      fState: TResultState;
      fActualState: TResultState;
      fExpectedState: TResultState;
    public
      constructor Create(const aTestName: String; const aTypeName: String; const aMethodName: String; const aTestIndex: Integer; const aExpectedState: TResultState; const aActualState: TResultState; const aErrorMessage: String);
      property TestIndex: Integer read fTestIndex;
      property TestName: String read fTestName;
      property TypeName: String read fTypeName;
      property TestMethod: String read fMethodName;
      property ErrorMessage: String read fErrorMessage;
      property State: TResultState read fState write fState;
      property ActualState: TResultState read fActualState;
      property ExpectedState: TResultState read fExpectedState;
    end;

implementation

{ TTestResult }

  constructor TTestResult.Create(const aTestName: String;
                                 const aTypeName: String;
                                 const aMethodName: String;
                                 const aTestIndex: Integer;
                                 const aExpectedState: TResultState;
                                 const aActualState: TResultState;
                                 const aErrorMessage: String);
  begin
    inherited Create;

    fActualState    := aActualState;
    fExpectedState  := aExpectedState;

    fTestIndex      := aTestIndex;
    fTestName       := aTestName;
    fTypeName       := aTypeName;
    fMethodName     := aMethodName;
    fState          := aActualState;
    fErrorMessage   := aErrorMessage;
  end;




end.
