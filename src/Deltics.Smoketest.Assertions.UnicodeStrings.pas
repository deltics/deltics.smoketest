
{$i deltics.smoketest.inc}

  unit Deltics.Smoketest.Assertions.UnicodeStrings;


interface

  uses
    Deltics.Smoketest.Assertions.Base;


  type
    IUnicodeStringAssertions = interface
    ['{780F8AAC-ACA4-406E-8C44-F4EB45475848}']
      function Equals(const aExpected: UnicodeString): Boolean;
      function EqualsText(const aExpected: UnicodeString): Boolean;
    end;


    TUnicodeStringAssertionsImpl = class(TFluentAssertions, IUnicodeStringAssertions)
    private
      fValue: UnicodeString;
    public
      function Equals(const aExpected: UnicodeString):Boolean; reintroduce;
      function EqualsText(const aExpected: UnicodeString):Boolean;
      constructor Create(const aTestName: String; const aValue: UnicodeString);
    end;



implementation

  uses
  {$ifdef DELPHI2006__}
    Windows,
  {$endif}
  {$ifdef DELPHI2009__}
    AnsiStrings,
  {$endif}
    SysUtils;


{ TStringAssertions }

  constructor TUnicodeStringAssertionsImpl.Create(const aTestName: String;
                                                  const aValue: UnicodeString);
  begin
    inherited Create(aTestName);

    fValue := aValue;
  end;


  function TUnicodeStringAssertionsImpl.Equals(const aExpected: UnicodeString): Boolean;
  begin
    result := SetResult(fValue = aExpected,
                        '''%s'' is not the expected value (''%s'')',
                        [fValue, aExpected]);
  end;


  function TUnicodeStringAssertionsImpl.EqualsText(const aExpected: UnicodeString): Boolean;
  begin
    result := SetResult(AnsiSameText(fValue, aExpected),
                        '''%s'' is not the expected value (''%s'')',
                        [fValue, aExpected]);
  end;



end.

