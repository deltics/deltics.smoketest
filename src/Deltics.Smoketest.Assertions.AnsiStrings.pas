
{$i deltics.smoketest.inc}

  unit Deltics.Smoketest.Assertions.AnsiStrings;

interface

  uses
    Deltics.Smoketest.Assertions.Base;


  type
    IAnsiStringAssertions = interface
    ['{62ECF808-5F81-4B5F-BF86-928B5D62B313}']
      function Equals(const aExpected: AnsiString): Boolean;
      function EqualsText(const aExpected: AnsiString): Boolean;
    end;


    TAnsiStringAssertionsImpl = class(TFluentAssertions, IAnsiStringAssertions)
    private
      fValue: AnsiString;
    public
      function Equals(const aExpected: AnsiString):Boolean; reintroduce;
      function EqualsText(const aExpected: AnsiString):Boolean;
      constructor Create(const aTestName: String; const aValue: AnsiString);
    end;



implementation

  uses
{$ifdef DELPHI2009__}
    AnsiStrings,
    Windows;
{$else}
    SysUtils;
{$endif}


{ TAnsiStringAssertions }

  constructor TAnsiStringAssertionsImpl.Create(const aTestName: String; const aValue: AnsiString);
  begin
    inherited Create(aTestName);

    fValue := aValue;
  end;


  function TAnsiStringAssertionsImpl.Equals(const aExpected: AnsiString): Boolean;
  begin
    result := SetResult(fValue = aExpected,
                        '''%s'' is not the expected value (''%s'')',
                        [fValue, aExpected]);
  end;


  function TAnsiStringAssertionsImpl.EqualsText(const aExpected: AnsiString): Boolean;
  begin
    result := SetResult(AnsiSameText(fValue, aExpected),
                        '''%s'' is not the expected value (''%s'')',
                        [fValue, aExpected]);
  end;



end.
