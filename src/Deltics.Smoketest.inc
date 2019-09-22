
// This is a hugely simplified version of deltics.inc, reproduced in this fashion
//  to avoid taking a dependency on the deltics.inc package which would cause
//  problems since Continuity is used to test that package.
//
// i.e. although there is no mutual dependency between the packages themselves,
//       this would create a circular dependency in the build pipelines.

{$define UNKNOWN_COMPILER_VERSION}

{$ifdef VER120} // Delphi 4
  {$define DELPHI4__}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER130} // Delphi 5
  {$define DELPHI4__}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER140} // Delphi 6
  {$define DELPHI4__}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER150} // Delphi 7
  {$define DELPHI4__}
  {$define DELPHI7__}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER170} // Delphi 2005
  {$define DELPHI4__}
  {$define DELPHI7__}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER180} // Delphi 2006
  {$define DELPHI4__}
  {$define DELPHI7__}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER185} // Delphi 2007
  {$define DELPHI4__}
  {$define DELPHI7__}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER200} // RAD Studio 2009
  {$define DELPHI4__}
  {$define DELPHI7__}
  {$define DELPHI2009__}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER210} // RAD Studio 2010
  {$define DELPHI4__}
  {$define DELPHI7__}
  {$define DELPHI2009__}
  {$define DELPHI2010__}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER220} // RAD Studio XE
  {$define DELPHI4__}
  {$define DELPHI7__}
  {$define DELPHI2009__}
  {$define DELPHI2010__}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER230} // RAD Studio XE2
  {$define DELPHI4__}
  {$define DELPHI7__}
  {$define DELPHI2009__}
  {$define DELPHI2010__}
  {$define DELPHIXE2__}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER240} // RAD Studio XE3
  {$define DELPHI4__}
  {$define DELPHI7__}
  {$define DELPHI2009__}
  {$define DELPHI2010__}
  {$define DELPHIXE2__}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER250} // RAD Studio XE4    \
  {$define DELPHI4__}
  {$define DELPHI7__}
  {$define DELPHI2009__}
  {$define DELPHI2010__}
  {$define DELPHIXE2__}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER260} // RAD Studio XE5
  {$define DELPHI4__}
  {$define DELPHI7__}
  {$define DELPHI2009__}
  {$define DELPHI2010__}
  {$define DELPHIXE2__}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER270} // RAD Studio XE6
  {$define DELPHI4__}
  {$define DELPHI7__}
  {$define DELPHI2009__}
  {$define DELPHI2010__}
  {$define DELPHIXE2__}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER280} // RAD Studio XE7
  {$define DELPHI4__}
  {$define DELPHI7__}
  {$define DELPHI2009__}
  {$define DELPHI2010__}
  {$define DELPHIXE2__}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER290} // RAD Studio XE8
  {$define DELPHI4__}
  {$define DELPHI7__}
  {$define DELPHI2009__}
  {$define DELPHI2010__}
  {$define DELPHIXE2__}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER300} // RAD Studio 10 Seattle
  {$define DELPHI4__}
  {$define DELPHI7__}
  {$define DELPHI2009__}
  {$define DELPHI2010__}
  {$define DELPHIXE2__}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER310} // RAD Studio 10.1 Berlin
  {$define DELPHI4__}
  {$define DELPHI7__}
  {$define DELPHI2009__}
  {$define DELPHI2010__}
  {$define DELPHIXE2__}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER320} // RAD Studio 10.2 Tokyo
  {$define DELPHI4__}
  {$define DELPHI7__}
  {$define DELPHI2009__}
  {$define DELPHI2010__}
  {$define DELPHIXE2__}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER330} // RAD Studio 10.3 Rio
  {$define DELPHI4__}
  {$define DELPHI7__}
  {$define DELPHI2009__}
  {$define DELPHI2010__}
  {$define DELPHIXE2__}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

// If we have not identified the compiler version then we abort compilation.
//  Since older versions don't support more graceful mechanisms for aborting
//  compilation, I'll achieve the same thing by just emitting a non-compilable
//  symbol which both chokes the compiler and also explains why.

{$ifdef UNKNOWN_COMPILER_VERSION}
  UNKNOWN_COMPILER_VERSION
{$endif}


{$ifdef DELPHI7__}
  {$warn SYMBOL_PLATFORM      OFF}
  {$warn UNIT_PLATFORM        OFF}
  {$warn DUPLICATE_CTOR_DTOR  OFF}
{$endif}


{$ifdef DELPHIXE2__}
  {$scopedenums OFF}
{$endif}

