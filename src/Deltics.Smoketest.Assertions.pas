
{$i deltics.smoketest.inc}

  unit Deltics.Smoketest.Assertions;


interface

  uses
    Deltics.Smoketest.Assertions.Integers,
    Deltics.Smoketest.Assertions.AnsiStrings,
    Deltics.Smoketest.Assertions.UnicodeStrings,
    Deltics.Smoketest.Assertions.WideStrings;

  type
    IntegerAssertions = IIntegerAssertions;

    TIntegerAssertions = Deltics.Smoketest.Assertions.Integers.TIntegerAssertions;

    AnsiStringAssertions    = IAnsiStringAssertions;
    UnicodeStringAssertions = IUnicodeStringAssertions;
    WideStringAssertions    = IWideStringAssertions;

    TAnsiStringAssertions     = TAnsiStringAssertionsImpl;
    TUnicodeStringAssertions  = TUnicodeStringAssertionsImpl;
    TWideStringAssertions     = TWideStringAssertionsImpl;


implementation

end.
