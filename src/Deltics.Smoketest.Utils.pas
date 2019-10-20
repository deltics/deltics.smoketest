
{$i deltics.smoketest.inc}

  unit Deltics.Smoketest.Utils;

interface

  uses
    Classes,
    SysUtils;


  type
    {$ifNdef UNICODE}
      AnsiString    = String;
      UnicodeString = WideString;
    {$endif}

    PClass = ^TClass;   // A pointer to a TClass.

    ESmoketest   = class(Exception);
    EInvalidTest = class(ESmoketest);

    //## All documented in documentation for final declaration in this group
    PSafeCallException = function(Self: TObject; ExceptObject: TObject; ExceptAddr: Pointer): HResult;  // <COMBINE PDestroy>
    PAfterConstruction = procedure(Self: TObject);                                                      // <COMBINE PDestroy>
    PBeforeDestruction = procedure(Self: TObject);                                                      // <COMBINE PDestroy>
    PDispatch          = procedure(Self: TObject; var Message);                                         // <COMBINE PDestroy>
    PDefaultHandler    = procedure(Self: TObject; var Message);                                         // <COMBINE PDestroy>
    PNewInstance       = function(Self: TClass): TObject;                                               // <COMBINE PDestroy>
    PFreeInstance      = procedure(Self: TObject);                                                      // <COMBINE PDestroy>
    PDestroy           = procedure(Self: TObject; OuterMost: ShortInt);                                 // <COMBINE PDestroy>
    {
      <TITLE Method Pointers in the VMT>

      These types identify the signatures of a number of functions and
       procedures to which pointers are found in the VMT for a class.
       These are the virtual methods that all TObject derived classes
       have by default.
    }


    PPublishedMethod = ^TPublishedMethod; // <COMBINE TPublishedMethod>
    TPublishedMethod = packed record
    {
      A record representing an entry in the published method table of
       a class VMT.

      <TABLE>
        Field          Purpose
        -------------  -------------------------------------------------------
        Size           The size of the entry.

        Address        Holds a pointer to the published method table for the
                        class, if any.

        Name           The name of the method.
      </TABLE>

      Additional information may be present for a particular method that is
       not shown in this declaration of the method record.  Further and more
       detailed information about published method records may be found in
       Ray Lischner's "Delphi In A Nutshell" (O'Reilly, ISBN 1-56592-659-5).
    }
      Size: Word;
      Address: Pointer;
      Name: ShortString;
    end;

    TPublishedMethods = packed array[0..High(Word)-1] of TPublishedMethod;
    {
      This type is used to allow us to declare the TPublishedMethodTable
       in a logical fashion.

      NOTE: The published method table does not consist of uniformly sized
             records at all.  This type exists solely as a notational aid.
    }


    PPublishedMethodTable = ^TPublishedMethodTable;  // <COMBINE TPublishedMethodTable>
    TPublishedMethodTable = packed record
    {
      A record representing the logical layout of the published method table.

      This table consists of a Count value identifying the number of entries
       in the table, followed by the entries themselves.

      Further and more detailed information about published method records may be
       found in Ray Lischner's "Delphi In A Nutshell" (O'Reilly, ISBN 1-56592-659-5).

      NOTE: Each actual entry in the published method table may vary in size
             compared to any other entry.  For this reason it is not possible
             to reference an arbitrary entry in this table directly - one-by-one
             we must "step over" all preceding entries to reach any given entry.
    }
      Count   : Word;
      Methods : TPublishedMethods;
    end;


    PVirtualMethodTable = ^TVirtualMethodTable; // <COMBINE TVirtualMethodTable>
    TVirtualMethodTable = packed record
    {
      A record representing the layout of the Virtual Method Table
       for a Delphi class. Fields of limited interest or for which
       no additional support is (yet) provided are essentially
       untyped. Fields that may be of interest and for which
       additional support is provided and/or documented are typed
       appropriately.

      Key fields of interest are described in the below table.

      <TABLE>
        Field          Purpose
        -------------  -------------------------------------------------------
        SelfPtr        Holds a pointer to the TClass to which the VMT record
                        relates.
        MethodTable    Holds a pointer to the published method table for the
                        class, if any.
        ClassName      Pointer to a ShortString holding the name of the class
                        to which the VMT relates.
        InstanceSize   Pointer to a LongInt that records the size of instance
                        data allocated for each instance of the class to which
                        the VMT relates.
        Parent         Pointer to the TClass that is the parent of the class
                        to which the VMT relates.
      </TABLE>

      Further and more detailed information about the VMT may be
      found in Ray Lischner's "Delphi In A Nutshell" (O'Reilly,
      ISBN 1-56592-659-5).

      See Also

        PDestroy

      NOTE: This record exposes the in-memory implementation details of a
             class. The layout or members of this record may change in
             future versions of Delphi.
    }
      SelfPtr           : TClass;                 // -76 / -88
      IntfTable         : Pointer;                // -72 / -84
      AutoTable         : Pointer;                // -68 / -80
      InitTable         : Pointer;                // -64 / -76
      TypeInfo          : Pointer;                // -60 / -72
      FieldTable        : Pointer;                // -56 / -68
      MethodTable       : PPublishedMethodTable;  // -52 / -64
      DynamicTable      : Pointer;                // -48 / -60
      ClassName         : PShortString;           // -44 / -56
      InstanceSize      : PLongint;               // -40 / -52
      Parent            : PClass;                 // -36 / -48
    {$ifdef DELPHI2009__}
      Equals            : Pointer;                //     / -44
      GetHashCode       : Pointer;                //     / -40
      ToString          : Pointer;                //     / -36
    {$endif}
      SafeCallException : PSafeCallException;     // -32
      AfterConstruction : PAfterConstruction;     // -28
      BeforeDestruction : PBeforeDestruction;     // -24
      Dispatch          : PDispatch;              // -20
      DefaultHandler    : PDefaultHandler;        // -16
      NewInstance       : PNewInstance;           // -12
      FreeInstance      : PFreeInstance;          // -8
      Destroy           : PDestroy;               // -4
      //## UserDefinedVirtuals: array[0..999] of procedure;
    end;


    EVMT = class(Exception);
    {
      The class of exception that is raised as a result of incorrect use of a
       class VMT.

      NOTE: The nature of the VMT and code written to access it, means that it
       is not always possible to reliably detect incorrect use of the VMT.  Care
       must always be taken when using information exposed in the VMT .
    }


  function GetPublishedMethodCount(const aClass: TClass): Integer;
  function GetPublishedMethod(const aClass: TClass; aIndex: Integer): PPublishedMethod;
  function GetFirstPublishedMethod(const aClass: TClass): PPublishedMethod;
  function GetNextPublishedMethod(const aMethod: PPublishedMethod): PPublishedMethod;

  function GetVirtualMethodTable(const aClass: TClass): PVirtualMethodTable; overload;
  function GetVirtualMethodTable(const aObject: TObject): PVirtualMethodTable; overload;

  function HasCmdLineOption(const aArgs: TStringList; const aOption: String; var aValue: String): Boolean;

  function AsString(const aValue: AnsiString): String; overload;
  function AsString(const aValue: UnicodeString): String; overload;
  function AsString(const aValue: WideString): String; overload;


implementation

  resourcestring
    rsfENoPublishedMethods  = '%s has no published methods';
    rsfEMethodIndex         = 'Invalid published method index (%d) for %s';


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function GetPublishedMethodCount(const aClass: TClass): integer;
  {
    Returns the number of entries in the published method table of the
     specified class.
  }
  var
    vmt: PPublishedMethodTable;
  begin
    result := 0;
    vmt    := GetVirtualMethodTable(aClass).MethodTable;
    if Assigned(vmt) then
      result := vmt.Count;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function GetPublishedMethod(const aClass: TClass;
                                    aIndex: Integer): PPublishedMethod;
  {
    Iterates over the published method table of the specified class and
     returns the aIndex'th entry.

    Exceptions

    Raises an EVMT exception if there are no published methods or aIndex is
     invalid for the specified class.
  }
  var
    vmt: PPublishedMethodTable;
  begin
    vmt    := GetVirtualMethodTable(aClass).MethodTable;
    if NOT Assigned(vmt) then
      raise EVMT.CreateFmt(rsfENoPublishedMethods, [aClass.ClassName]);

    if (aIndex < vmt.Count) then
    begin
      result := @vmt.Methods[0];
      while aIndex > 0 do
      begin
        result := GetNextPublishedMethod(result);
        Dec(aIndex);
      end;
    end
    else
      raise EVMT.CreateFmt(rsfEMethodIndex, [aIndex, aClass.ClassName]);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function GetFirstPublishedMethod(const aClass: TClass): PPublishedMethod;
  {
    Returns the first published method for a specified class.

    Use this in conjunction with GetNextPublishedMethod to iterate over all
     methods published by a class.
  }
  begin
    result := GetPublishedMethod(aClass, 0);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function GetNextPublishedMethod(const aMethod: PPublishedMethod): PPublishedMethod;
  {
    Returns the next published method following the method specified.  No
     checking is performed to ensure that there is a next method.  The caller
     must ensure that the correct number of calls to GetNextPublishedMethod
     are made with respect to GetPublishedMethodCount.

    Use this in conjunction with GetFirstPublishedMethod and
     GetPublishedMethodCount to efficiently iterate over all methods published
     by a class.
  }
  begin
    result := aMethod;
    if Assigned(result) then
      Inc(PByte(result), result.Size);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function GetVirtualMethodTable(const aClass: TClass): PVirtualMethodTable;
  {
    Returns the Virtual Method Table of a specified class.
  }
  begin
    result := PVirtualMethodTable(Integer(aClass) - sizeof(TVirtualMethodTable));
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function GetVirtualMethodTable(const aObject: TObject): PVirtualMethodTable;
  {
    Returns the Virtual Method Table for the class of a specified object.
  }
  begin
    result := GetVirtualMethodTable(aObject.ClassType);
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
  function HasCmdLineOption(const aArgs: TStringList;
                            const aOption: String;
                            var   aValue: String): Boolean;
  var
    i: Integer;
    s: String;
  begin
    result  := FALSE;
    aValue  := '';

    for i := 1 to Pred(aArgs.Count) do
    begin
      s := aArgs[i];
      if s[1] <> '-' then
        CONTINUE;

      Delete(s, 1, 1);
      if NOT SameText(Copy(s, 1, Length(aOption)), aOption) then
        CONTINUE;

      Delete(s, 1, Length(aOption));
      result := (s = '') or (ANSIChar(s[1]) in [':', '=']);
      if NOT result then
        CONTINUE;

      if s = '' then
        EXIT;

      Delete(s, 1, 1);

      // This is to replicate the behaviour of values parsed by ParamStr()
      //  which respects quotes to delimit values but then strips all quotes
      //  from those values!
      //
      // This is only needed to satisfy the tests which use a manually scaffolded
      //  stringlist to 'simulate' a command line and which as a result end up 
      //  with very different elements when simulating quoted values.
      //
      // This makes me VERY queasy.  Decoupling command line handling from 
      //  ParamCount/ParamStr should be done if only to eliminate the need for 
      //  this sort of chicanery!

      s := StringReplace(s, '"', '', [rfReplaceAll]);

      aValue := s;

      EXIT;
    end;
  end;


  {-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --}
    // These AsString() utilities are provided to ensure hint/warning free
    //  'casts' of Ansi/Unicode/WideString values to whatever the native
    //  'String' type is at time of compilation.
  function AsString(const aValue: AnsiString): String;
  begin
  {$ifdef UNICODE}
    result := UnicodeString(aValue);
  {$else}
    result := aValue;
  {$endif}
  end;

  {-   -   -   -   -   -   -   -   -   - -   -   -   -   -   -   -   -   -   -}
  function AsString(const aValue: UnicodeString): String;
  begin
  {$ifdef UNICODE}
    result := aValue;
  {$else}
    result := AnsiString(aValue);
  {$endif}
  end;

  {-   -   -   -   -   -   -   -   -   - -   -   -   -   -   -   -   -   -   -}
  function AsString(const aValue: WideString): String;
  begin
  {$ifdef UNICODE}
    result := aValue;
  {$else}
    result := AnsiString(aValue);
  {$endif}
  end;



end.
