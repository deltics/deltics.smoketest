
  unit Deltics.Smoketest.Assertions.WideStrings;

interface

  uses
    Deltics.Smoketest.Assertions.Base;


  type
    IWideStringAssertions = interface
    ['{819314CB-486C-4DDA-81CE-C2FD837888B7}']
      function Equals(const aExpected: WideString): Boolean;
      function EqualsText(const aExpected: WideString):Boolean;
    end;


    TWideStringAssertionsImpl = class(TFluentAssertions, IWideStringAssertions)
    private
      fValue: WideString;
    public
      function Equals(const aExpected: WideString):Boolean; reintroduce;
      function EqualsText(const aExpected: WideString):Boolean;
      constructor Create(const aTestName: WideString; const aValue: WideString);
    end;



implementation

  uses
  {$ifdef DELPHI2006__}
    Windows,
  {$endif}
  {$ifdef DELPHI2009__}
    AnsiStrings;
  {$else}
    SysUtils;
  {$endif}


{ TWideStringAssertions }

  constructor TWideStringAssertionsImpl.Create(const aTestName: WideString;
                                               const aValue: WideString);
  begin
    inherited Create(aTestName);

    fValue := aValue;
  end;


  function TWideStringAssertionsImpl.Equals(const aExpected: WideString): Boolean;
  begin
    result := SetResult(fValue = aExpected,
                        '''%s'' is not the expected value (''%s'')',
                        [fValue, aExpected]);
  end;


  function TWideStringAssertionsImpl.EqualsText(const aExpected: WideString): Boolean;
  begin
    result := SetResult(AnsiSameText(fValue, aExpected),
                        '''%s'' is not the expected value (''%s'')',
                        [fValue, aExpected]);
  end;



end.

