
// This is an exact copy of deltics.inc with the addition of the
//  Smoketest DEBUGINFO check at the end.  It is duplicated here
//  to avoid Smoketest taking a dependency on the deltics.inc package 
//  which would cause a circular dependency (in the build pipelines,
//  not the packaged code itself).
//
// It also ensures that Smoketest adheres to the "No dependencies
//  other than the RTL" rule.

{$define UNKNOWN_COMPILER_VERSION}

// Here we simply take the compiler defined VERXXX symbol and use this
//  to $define a more relatable symbol identifying the corresponding 
//  Delphi version (e.g. VER150 ==> DELPHI7)

{$ifdef VER80} // Delphi 1
  {$define DELPHI1}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER90} // Delphi 2
  {$define DELPHI2}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER100} // Delphi 3
  {$define DELPHI3}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER120} // Delphi 4
  {$define DELPHI4}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER130} // Delphi 5
  {$define DELPHI5}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER140} // Delphi 6
  {$define DELPHI6}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER150} // Delphi 7
  {$define DELPHI7}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER160} // Delphi 8 (.net) == NOT SUPPORTED
  DELPHI_8_IS_NOT_SUPPORTED
{$endif}

{$ifdef VER170} // Delphi 2005
  {$define DELPHI2005}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER180} // Delphi 2006
  {$define DELPHI2006}
  {$define DELPHI2006_OR_2007}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER185} // Delphi 2007
  {$UNDEF DELPHI2006}
  {$define DELPHI2007}
  {$define DELPHI2006_OR_2007}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER200} // RAD Studio 2009
  {$define DELPHI2009}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER210} // RAD Studio 2010
  {$define DELPHI2010}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER220} // RAD Studio XE
  {$define DELPHIXE}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER230} // RAD Studio XE2
  {$define DELPHIXE2}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER240} // RAD Studio XE3
  {$define DELPHIXE3}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER250} // RAD Studio XE4
  {$define DELPHIXE4}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER260} // RAD Studio XE5
  {$define DELPHIXE5}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER270} // RAD Studio XE6
  {$define DELPHIXE6}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER280} // RAD Studio XE7
  {$define DELPHIXE7}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER290} // RAD Studio XE8
  {$define DELPHIXE8}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER300} // RAD Studio 10 Seattle
  {$define DELPHI10}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER310} // RAD Studio 10.1 Berlin
  {$define DELPHI10_1}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER320} // RAD Studio 10.2 Tokyo
  {$define DELPHI10_2}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER330} // RAD Studio 10.3 Rio
  {$define DELPHI10_3}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

{$ifdef VER340} // RAD Studio 10.4 Sydney
  {$define DELPHI10_4}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$endif}

(*
  Template for adding support for new versions of Delphi as they come along.
   Don't forget to also update XX__ and __XX section! (below)

{$ifdef VER NEW}
  {$define DELPHIVER}
{$endif}
*)

// If we have not identified the compiler version then we abort compilation.
//  Since older versions don't support more graceful mechanisms for aborting
//  compilation, I'll achieve the same thing by just emitting a non-compilable
//  symbol which both chokes the compiler and also explains why.

{$ifdef UNKNOWN_COMPILER_VERSION}
  UNKNOWN_COMPILER_VERSION
{$endif}


// With relatable DELPHI version symbols $define'd. we can now define
//   symbols for "VER and earlier" (__VER) and "VER and later" (VER__).
//
// __VER is defined for all versions up to and including VER
// VER__ is defined for all versions from VER onward
//
// We start by defining ALL __VER symbols (versions up to VER).
//  We will subsequently $UNDEFine those which are not applicable.

{.$define __DELPHIVER}
{$define __DELPHI10_4}
{$define __DELPHI10_3}
{$define __DELPHI10_2}
{$define __DELPHI10_1}
{$define __DELPHI10}
{$define __DELPHIXE8}
{$define __DELPHIXE7}
{$define __DELPHIXE6}
{$define __DELPHIXE5}
{$define __DELPHIXE4}
{$define __DELPHIXE3}
{$define __DELPHIXE2}
{$define __DELPHIXE}
{$define __DELPHI2010}
{$define __DELPHI2009}
{$define __DELPHI2007}
{$define __DELPHI2006}
{$define __DELPHI2005}
{$define __DELPHI7}
{$define __DELPHI6}
{$define __DELPHI5}
{$define __DELPHI4}
{$define __DELPHI3}
{$define __DELPHI2}
{$define __DELPHI1}

// Now we $define VER__ for the identified VER (version VER and later)

(* {$ifdef DELPHIVER}  {$define DELPHIVER__} {$endif} *)
{$ifdef DELPHI10_4} {$define DELPHI10_4__}  {$endif}
{$ifdef DELPHI10_3} {$define DELPHI10_3__}  {$endif}
{$ifdef DELPHI10_2} {$define DELPHI10_2__}  {$endif}
{$ifdef DELPHI10_1} {$define DELPHI10_1__}  {$endif}
{$ifdef DELPHI10}   {$define DELPHI10__}  {$endif}
{$ifdef DELPHIXE8}  {$define DELPHIXE8__} {$endif}
{$ifdef DELPHIXE7}  {$define DELPHIXE7__} {$endif}
{$ifdef DELPHIXE6}  {$define DELPHIXE6__} {$endif}
{$ifdef DELPHIXE5}  {$define DELPHIXE5__} {$endif}
{$ifdef DELPHIXE4}  {$define DELPHIXE4__} {$endif}
{$ifdef DELPHIXE3}  {$define DELPHIXE3__} {$endif}
{$ifdef DELPHIXE2}  {$define DELPHIXE2__} {$endif}
{$ifdef DELPHIXE}   {$define DELPHIXE__} {$endif}
{$ifdef DELPHI2010} {$define DELPHI2010__} {$endif}
{$ifdef DELPHI2009} {$define DELPHI2009__} {$endif}
{$ifdef DELPHI2007} {$define DELPHI2007__} {$endif}
{$ifdef DELPHI2006} {$define DELPHI2006__} {$endif}
{$ifdef DELPHI2005} {$define DELPHI2005__} {$endif}
{$ifdef DELPHI7}    {$define DELPHI7__} {$endif}
{$ifdef DELPHI6}    {$define DELPHI6__} {$endif}
{$ifdef DELPHI5}    {$define DELPHI5__} {$endif}
{$ifdef DELPHI4}    {$define DELPHI4__} {$endif}
{$ifdef DELPHI3}    {$define DELPHI3__} {$endif}
{$ifdef DELPHI2}    {$define DELPHI2__} {$endif}
{$ifdef DELPHI1}    {$define DELPHI1__} {$endif}

// Now starting with the most recent known version, if VER is defined
//  then we ensure that VER-1__ (and later) is defined but that VER-1
//  itself is UNDEFined.

(* {$ifdef DELPHIVER__}   {$define DELPHIVER-1__}  {$undef __DELPHIVER-1}  {$endif} *)
{$ifdef DELPHI10_4__}  {$define DELPHI10_3__}  {$undef __DELPHI10_3}  {$endif}
{$ifdef DELPHI10_3__}  {$define DELPHI10_2__}  {$undef __DELPHI10_2}  {$endif}
{$ifdef DELPHI10_2__}  {$define DELPHI10_1__}  {$undef __DELPHI10_1}  {$endif}
{$ifdef DELPHI10_1__}  {$define DELPHI10__}    {$undef __DELPHI10}  {$endif}
{$ifdef DELPHI10__}    {$define DELPHIXE8__}   {$undef __DELPHIXE8}  {$endif}
{$ifdef DELPHIXE8__}   {$define DELPHIXE7__}   {$undef __DELPHIXE7}  {$endif}
{$ifdef DELPHIXE7__}   {$define DELPHIXE6__}   {$undef __DELPHIXE6}  {$endif}
{$ifdef DELPHIXE6__}   {$define DELPHIXE5__}   {$undef __DELPHIXE5}  {$endif}
{$ifdef DELPHIXE5__}   {$define DELPHIXE4__}   {$undef __DELPHIXE4}  {$endif}
{$ifdef DELPHIXE4__}   {$define DELPHIXE3__}   {$undef __DELPHIXE3}  {$endif}
{$ifdef DELPHIXE3__}   {$define DELPHIXE2__}   {$undef __DELPHIXE2}  {$endif}
{$ifdef DELPHIXE2__}   {$define DELPHIXE__}    {$undef __DELPHIXE}   {$endif}
{$ifdef DELPHIXE__}    {$define DELPHI2010__}  {$undef __DELPHI2010} {$endif}
{$ifdef DELPHI2010__}  {$define DELPHI2009__}  {$undef __DELPHI2009} {$endif}
{$ifdef DELPHI2009__}  {$define DELPHI2007__}  {$undef __DELPHI2007} {$endif}
{$ifdef DELPHI2007__}  {$define DELPHI2006__}  {$undef __DELPHI2006} {$endif}
{$ifdef DELPHI2006__}  {$define DELPHI2005__}  {$undef __DELPHI2005} {$endif}
{$ifdef DELPHI2005__}  {$define DELPHI7__}     {$undef __DELPHI7}    {$endif}
{$ifdef DELPHI7__}     {$define DELPHI6__}     {$undef __DELPHI6}    {$endif}
{$ifdef DELPHI6__}     {$define DELPHI5__}     {$undef __DELPHI5}    {$endif}
{$ifdef DELPHI5__}     {$define DELPHI4__}     {$undef __DELPHI4}    {$endif}
{$ifdef DELPHI4__}     {$define DELPHI3__}     {$undef __DELPHI3}    {$endif}
{$ifdef DELPHI3__}     {$define DELPHI2__}     {$undef __DELPHI2}    {$endif}
{$ifdef DELPHI2__}     {$define DELPHI1__}     {$undef __DELPHI1}    {$endif}

// For 10.x we also define the city names associated with each version
//  as these could be considered easier to use (if not quite as obvious)

{$ifdef DELPHI10}   {$define SEATTLE}   {$endif}
{$ifdef DELPHI10__} {$define SEATTLE__} {$endif}
{$ifdef __DELPHI10} {$define __SEATTLE} {$endif}

{$ifdef DELPHI10_1}   {$define BERLIN}   {$endif}
{$ifdef DELPHI10_1__} {$define BERLIN__} {$endif}
{$ifdef __DELPHI10_1} {$define __BERLIN} {$endif}

{$ifdef DELPHI10_2}   {$define TOKYO}   {$endif}
{$ifdef DELPHI10_2__} {$define TOKYO__} {$endif}
{$ifdef __DELPHI10_2} {$define __TOKYO} {$endif}

{$ifdef DELPHI10_3}   {$define RIO}   {$endif}
{$ifdef DELPHI10_3__} {$define RIO__} {$endif}
{$ifdef __DELPHI10_3} {$define __RIO} {$endif}

{$ifdef DELPHI10_4}   {$define SYDNEY}   {$endif}
{$ifdef DELPHI10_4__} {$define SYDNEY__} {$endif}
{$ifdef __DELPHI10_4} {$define __SYDNEY} {$endif}

// At this point if we are compiling with Delphi VER:
//
//     DELPHIVER     defined
//     DELPHIVER__   defined
//     __DELPHIVER   defined
//
//     DELPHIVER-1   NOT defined
//     DELPHIVER+1   NOT defined


{ ------------------------------------------------------------------------------------------------ }
{ Some useful additional settings.                                                                 }
{ ------------------------------------------------------------------------------------------------ }

{$ifdef DELPHI6__}

  // Delphi 6 introduced the ability toggle specific warnings on/oof

  {$ifdef DELPHI7__}
    // Delphi 7 introduced platform warnings as part of the compatibility with Kylix/C++
    //
    // I disable these by default since the Deltics libraries are (currently) Windows
    //  specific and not intended to be used by C++ developers

    {$WARN SYMBOL_PLATFORM      OFF}
    {$WARN UNIT_PLATFORM        OFF}
    {$WARN DUPLICATE_CTOR_DTOR  OFF}
  {$endif}

{$endif}


// Convenience defines for 32/64-bit detection

{$ifdef CPUX64}   {$define 64BIT} {$endif}
{$ifdef CPUARM64} {$define 64BIT} {$endif}
{$ifNdef 64BIT}   {$define 32BIT} {$endif}


// Delphi 2005 introduced for-in loops with enumerator support.

  {$ifdef DELPHI2005__}
    {$define ForInEnumerators}
  {$endif}


  {$ifdef DELPHI2009__}
    {$define EnhancedOverloads}
  {$endif}


// Delphi 2006 introduced inline methods and class helpers.
// + Delphi XE3 extended helpers to other types.

  {$ifdef DELPHI2006__}
    {$define CLASS_HELPERS}
    {$define ClassHelpers}

    {$define INLINE_METHODS}
    {$define InlineMethods}

    {$ifdef DELPHIXE3__}
      {$define TYPE_HELPERS}
      {$define TypeHelpers}
    {$endif}
  {$endif}


// Delphi 2009 introduced the ability to overload on Utf8 strings

  {$ifdef DELPHI2009__}
    {$define UTF8_OVERLOADABLE}
    {$define Utf8Overloads}
  {$endif}


// XE2 introduced scoped enums as ON by default.  I prefer them OFF
//  but you can restore XE2+ behaviour by adding a DEFINE for
//  ScopedEnumDefaultBehaviour in your project(s).

  {$ifdef DELPHIXE2__}
    {$ifNdef ScopedEnumDefaultBehaviour}
      {$scopedenums OFF}
    {$endif}
  {$endif}


// NOTE: This will only work to determine the compiled EXE type if you $include
//  this file (or another include file which includes this one) in your DPR.
//
// You can then use the CONSOLE define itself to determine when to include
//  (or not) GUI related code.

{$ifdef CONSOLE}
  {$APPTYPE CONSOLE}
{$endif}


// A few additional defines to make compiler settings a little clearer.
//  NOTE: This will only tell you the state of these settings at the time
//  this file is processed.  They won't reflect any subsequent changes to
//  compiler settings modified by directives later in the following
//  source file.

  {$ifopt C+}
    {$define ASSERTIONS_ON}
    {$define Assertions}
  {$endif}

  {$ifopt D+}
    {$define DEBUGINFO_ON}
    {$define DebugInfo}
  {$endif}

  {$ifopt T+}
    {$define TYPEDADDRESS_ON}
    {$define TypedAddresses}
  {$endif}


// By default, Smoketest itself will not be compiled with debuginfo to enable
//  debugging sessions to focus on user-code.  If you suspect a problem in
//  Smoketest itself, simply add a DEFINE for debugDelticsSmoketest and rebuild.

{$ifdef debug_DelticsSmoketest}
  {$debuginfo ON}
{$else}
  {$debuginfo OFF}
{$endif}