{
  * MIT LICENSE *

  Copyright © 2019 Jolyon Smith

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

  unit Deltics.Smoketest.Utils;


interface

  uses
    Classes,
    SysUtils,
    Deltics.Smoketest.Types;


  type
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

  function AsQuotedString(const aValue: AnsiString): UnicodeString; overload;
  function AsQuotedString(const aValue: UnicodeString): UnicodeString; overload;

  function AsString(const aValue: AnsiString): UnicodeString; overload;
  function AsString(const aValue: Utf8Char): UnicodeString; overload;
  function AsString(const aValue: WideChar): UnicodeString; overload;
  function AsString(const aValue: WideString): UnicodeString; overload;
{$ifdef UNICODE}
  function AsString(const aValue: UnicodeString): UnicodeString; overload;
{$endif}
  function Utf8AsString(const aValue: Utf8String): UnicodeString;

  function Enquote(const aValue: UnicodeString): UnicodeString;
  function Interpolate(const aString: UnicodeString; aValues: array of const): UnicodeString;
  function XmlEncodedAttr(const aValue: UnicodeString): UnicodeString;

  function GuidsAreEqual(const a, b: TGUID): Boolean;

  function BinToHex(const aBuf: Pointer; const aSize: Integer): UnicodeString;



implementation

  uses
    Math,
    Windows;


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
  function AsQuotedString(const aValue: AnsiString): UnicodeString;
  begin
  {$ifdef UNICODE}
    result := AsString(aValue);
  {$else}
    result := aValue;
  {$endif}

    result := Enquote(result);
  end;

  {-   -   -   -   -   -   -   -   -   - -   -   -   -   -   -   -   -   -   -}
  function AsQuotedString(const aValue: UnicodeString): UnicodeString;
  begin
    result := Enquote(result);
  end;


  {-   -   -   -   -   -   -   -   -   - -   -   -   -   -   -   -   -   -   -}
  function AsString(const aValue: AnsiString): UnicodeString;
  var
    len: Integer;
  begin
    if aValue = '' then
    begin
      result := '';
      EXIT;
    end;

    len := MultiByteToWideChar(CP_ACP, 0, PAnsiChar(aValue), -1, NIL, 0);
    SetLength(result, len - 1);

    MultiByteToWideChar(CP_ACP, 0, PAnsiChar(aValue), -1, PWideChar(result), len);
  end;


  {-   -   -   -   -   -   -   -   -   - -   -   -   -   -   -   -   -   -   -}
  function AsString(const aValue: Utf8Char): UnicodeString;
  begin
    if (Ord(aValue) < 32) or (Ord(aValue) > 127) then
      result := Format('U+%.2x', [Ord(aValue)])
    else
      result := '''' + aValue + '''';
  end;


  {-   -   -   -   -   -   -   -   -   - -   -   -   -   -   -   -   -   -   -}
  function AsString(const aValue: WideChar): UnicodeString;
  begin
    result := Format('U+%.4x', [Ord(aValue)]);
  end;


  {-   -   -   -   -   -   -   -   -   - -   -   -   -   -   -   -   -   -   -}
  function AsString(const aValue: WideString): UnicodeString;
  begin
    result := aValue;
  end;


{$ifdef UNICODE}
  {-   -   -   -   -   -   -   -   -   - -   -   -   -   -   -   -   -   -   -}
  function AsString(const aValue: UnicodeString): UnicodeString;
  begin
    result := aValue;
  end;
{$endif}

  {-   -   -   -   -   -   -   -   -   - -   -   -   -   -   -   -   -   -   -}
  function Utf8AsString(const aValue: Utf8String): UnicodeString;
  var
    len: Integer;
  begin
    if aValue = '' then
    begin
      result := '';
      EXIT;
    end;

    len := MultiByteToWideChar(CP_UTF8, 0, PAnsiChar(aValue), -1, NIL, 0);
    SetLength(result, len - 1);

    MultiByteToWideChar(CP_UTF8, 0, PAnsiChar(aValue), -1, PWideChar(result), len);
  end;


  function Enquote(const aValue: UnicodeString): UnicodeString;
  var
    ii: Integer;
    io: Integer;
  begin
    SetLength(result, Length(aValue) * 2);

    io := 0;
    for ii := 1 to Length(aValue) do
    begin
      Inc(io);
      result[io] := aValue[ii];

      if aValue[ii] = '''' then
      begin
        Inc(io);
        result[io] := '''';
      end;
    end;

    SetLength(result, io);
  end;



  function Interpolate(const aString: UnicodeString;
                             aValues: array of const): UnicodeString;
  type
  {$ifdef UNICODE}
    TStringArray = TStringList;
  {$else}
    TStringArray = array of UnicodeString;
  {$endif}
  var
    resolved: TStringArray;

    function AddString({$ifdef UNICODE}const{$else}var{$endif} aList: TStringArray; const aString: UnicodeString): Integer;
    begin
    {$ifdef UNICODE}
      result := aList.Add(aString);
    {$else}
      SetLength(aList, Length(aList) + 1);
      aList[Length(aList) - 1] := aString;

      result := Length(aList) - 1;
    {$endif}
    end;

    function IndexOf(const aList: TStringArray; const aName: UnicodeString): Integer;
    begin
    {$ifdef UNICODE}
      result := aList.IndexOf(aName);
    {$else}
      for result := 0 to Pred(Length(aList)) do
      begin
        if aList[result] = aName then
          EXIT;
      end;
      result := -1;
    {$endif}
    end;

    function ValueForName(const aList: TStringArray; const aName: UnicodeString): UnicodeString;
    {$ifNdef UNICODE}
    var
      i: Integer;
      item: UnicodeString;
      ep: Integer;
      name: UnicodeString;
    {$endif}
    begin
    {$ifdef UNICODE}
      result := aList.Values[aName];
    {$else}
      result := '';

      for i := 0 to Pred(Length(aList)) do
      begin
        item := aList[i];
        ep := Pos('=', item);
        if ep > 0 then
          name := Copy(item, 1, ep - 1)
        else
          name := item;

        if name = aName then
        begin
          if (ep > 0) then
            result := Copy(item, ep + 1, Length(item) - ep);

          EXIT;
        end;
      end;
    {$endif}
    end;

    function IsResolved(const aRef: UnicodeString): Boolean;
    {$ifNdef UNICODE}
    var
      i: Integer;
      name: WideString;
      ep: Integer;
    {$endif}
    begin
    {$ifdef UNICODE}
      result := resolved.IndexOfName(aRef) <> -1;
    {$else}
      result := TRUE;
      for i := 0 to Pred(Length(resolved)) do
      begin
        name  := resolved[i];
        ep    := Pos('=', name);
        if ep > 0 then
          name := Copy(name, 1, ep - 1);

        if name = aRef then
          EXIT;
      end;
      result := FALSE;
    {$endif}
    end;

    procedure SplitNameAndFormatSpec(const aString: UnicodeString;
                                     var   aName: UnicodeString;
                                     var   aFormatSpec: UnicodeString);
    var
      cp: Integer;
    begin
      aName       := aString;
      aFormatSpec := '';

      cp := Pos(':', aString);
      if cp = 0 then
        EXIT;

      aName       := WideLowercase(Copy(aString, 1, cp - 1));
      aFormatSpec := Copy(aString, cp + 1, Length(aString) - cp);
    end;

  var
    i: Integer;
    msgLen: Integer;
    inPropertyRef: Boolean;
    propertyRef: UnicodeString;
    numRefs: Integer;
    refs: TStringArray;
    args: TStringArray;
    name: UnicodeString;
    formatSpec: UnicodeString;
    argIndex: Integer;
  begin
    result := aString;
    if Length(aValues) = 0 then
      EXIT;

    inPropertyRef := FALSE;
    propertyRef   := '';

  {$ifdef UNICODE}
    refs  := TStringList.Create;
    resolved := TStringList.Create;
    resolved.Sorted      := TRUE;
    resolved.Duplicates  := dupIgnore;

    args := TStringList.Create;
  {$endif}
    try
      i       := 1;
      msgLen  := Length(result);
      while i <= msgLen do
      begin
        if inPropertyRef and (result[i] = '}') then
        begin
          inPropertyRef := FALSE;

        {$ifdef UNICODE}
          propertyRef := Lowercase(propertyRef);
        {$else}
          propertyRef := WideLowercase(propertyRef);
        {$endif}

          AddString(refs, propertyRef);
        end
        else if (result[i] = '{') then
        begin
          if (i < msgLen) and (result[i + 1] <> '{') then
          begin
            inPropertyRef := TRUE;
            propertyRef   := '';
          end
          else
            Inc(i);
        end
        else if (result[i] = '}') then
        begin
          if (i < msgLen) and (result[i + 1] = '}') then
            Inc(i)
          else
            raise ESmoketest.CreateFmt('Error in interpolated string ''%s''.'#13'Found ''}'' at %d but but expected ''}}''.', [result, i]);
        end
        else
          propertyRef := propertyRef + result[i];

        Inc(i);
      end;

    {$ifdef UNICODE}
      numRefs := refs.Count;
    {$else}
      numRefs := Length(refs);
    {$endif}

      for i := 0 to Pred(numRefs) do
      begin
        propertyRef := refs[i];
        SplitNameAndFormatSpec(propertyRef, name, formatSpec);

        if NOT IsResolved(name) then
        begin
          argIndex := AddString(args, name);

          if formatSpec = '' then
            formatSpec := '%s';

          AddString(resolved, name + '=' + formatSpec)
        end
        else
        begin
          argIndex := IndexOf(args, name);

          if formatSpec = '' then
            formatSpec := ValueForName(resolved, name);
        end;

        Delete(formatSpec, 1, 1);

        formatSpec  := '%' + IntToStr(argIndex) + ':' + formatSpec;

        if Pos('s', formatSpec) <> 0 then
          formatSpec := '''' + formatSpec + '''';

        result := StringReplace(result, '{' + propertyRef + '}', formatSpec, [rfIgnoreCase, rfReplaceAll]);
      end;

      result := Format(result, aValues);

    finally
    {$ifdef UNICODE}
      refs.Free;
      args.Free;
      resolved.Free;
    {$endif}
    end;
  end;


  function XmlEncodedAttr(const aValue: UnicodeString): UnicodeString;
  const
    TAB = #9;
    LF  = #10;
    CR  = #13;
  var
    i, j: Integer;
    c: WideChar;

    hiSurrogate: WideChar;
    codepoint: Cardinal;

    function PairToCodePoint(hi, lo: WideChar): Cardinal;
    const
      LEAD_OFFSET       = $d800 - ($10000 shr 10);
      SURROGATE_OFFSET  = $10000 - ($d800 shl 10) - $dC00;
    begin
      result := (Word(hi) shl 10) + Word(lo) + SURROGATE_OFFSET;
    end;

    procedure Append(const aString: UnicodeString);
    var
      ai: Integer;
    begin
      if (j + Length(aString)) >= Length(result) then
        SetLength(result, Max(j + Length(aString), 2 * Length(result)));

      for ai := 1 to Length(aString) do
      begin
        Inc(j);
        result[j] := aString[ai];
      end;
    end;

  begin
    hiSurrogate := #$0000;
    SetLength(result, Length(aValue) * 2);

    j := 0;
    for i := 1 to Length(aValue) do
    begin
      c := aValue[i];

      if hiSurrogate <> #$0000 then
      begin
        codepoint := 0;

        if (Word(c) >= $dc00) and (Word(c) <= $dfff) then
        begin
          codepoint := PairToCodePoint(hiSurrogate, c);
          Append('&#x' + BinToHex(@codepoint, 3) + ';');
        end
        else
          Append('U+' + Uppercase(BinToHex(@hiSurrogate, 2)));

        hiSurrogate := #$0000;

        // If we obtained a codepoint from a surrogate pair then we can
        //  move on to the next iteration of the loop.
        //
        // If not, then we had an orphaned hi-surrogate which was dealt
        //  with and now "drop thru" to process the following char as usual.

        if codepoint <> 0 then
          CONTINUE;
      end;

      if (Ord(c) > 127) then
      begin
        // Hi Surrogate?  Stash the char and go around to pick up the lo-surrogate
        if (Word(c) >= $d800) and (Word(c) <= $dbff) then
        begin
          hiSurrogate := c;
          CONTINUE;
        end;

        // Lo Surrogate?  If we reached it here, it must be an orphan
        if (Word(c) >= $dc00) and (Word(c) <= $dfff) then
        begin
          Append('U+' + Uppercase(BinToHex(@c, 2)));
          CONTINUE;
        end;

        Append('&#x' + BinToHex(@c, 2) + ';');
      end
      else case c of
        TAB : Append('&#x9;');
        LF  : Append('&#xA;');
        CR  : Append('&#xD;');
        '<' : Append('&lt;');
        '>' : Append('&gt;');
        '&' : Append('&amp;');
        '"' : Append('&quot;');
      else
        if j = Length(result) then
          SetLength(result, 2 * Length(result));

        Inc(j);
        result[j] := c;
      end;
    end;

    if hiSurrogate <> #$0000 then
      Append('U+' + Uppercase(BinToHex(@hiSurrogate, 2)));

    SetLength(result, j);
  end;


  function GuidsAreEqual(const a, b: TGUID): Boolean;
  begin
    result := CompareMem(@a, @b, sizeof(a));
  end;



  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function BinToHex(const aBuf: Pointer; const aSize: Integer): UnicodeString;
  const
    DIGITS: WideString = '0123456789abcdef';
  var
    i: Integer;
    c: PByte;
    ci: Integer;
  begin
    SetLength(result, aSize * 2);

    c := aBuf;
    for i := aSize downto 1 do
    begin
      ci := i * 2;
      result[ci - 1]  := DIGITS[(c^ and $F0) shr 4 + 1];
      result[ci]      := DIGITS[(c^ and $0F) + 1];
      Inc(c);
    end;
  end;


end.
