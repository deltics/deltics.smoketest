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

  unit Deltics.Smoketest.ExpectedException;


interface

  uses
    Deltics.Smoketest.TestResult;


  type
    IExpectedException = interface
    ['{8F46EA43-1FDB-474B-82A3-6FEE0D91F4D2}']
      function get_ExceptionClass: TClass;
      function get_ClassIsExact: Boolean;
      function get_Message: String;
      function get_NoneExpected: Boolean;
      function get_TestName: String;
      function Matches(const aException: TObject): Boolean;
      function MatchesClass(const aException: TObject): Boolean;
      function MatchesMessage(const aMessage: String): Boolean;

      property ExceptionClass: TClass read get_ExceptionClass;
      property ClassIsExact: Boolean read get_ClassIsExact;
      property Message: String read get_Message;
      property NoneExpected: Boolean read get_NoneExpected;
      property TestName: String read get_TestName;
    end;


    TExpectedException = class(TInterfacedObject, IExpectedException)
    private
      fExceptionClass: TClass;
      fClassIsExact: Boolean;
      fMessage: String;
      fNoneExpected: Boolean;
    public // IExpectedException
      function get_ExceptionClass: TClass;
      function get_ClassIsExact: Boolean;
      function get_Message: String;
      function get_NoneExpected: Boolean;
      function get_TestName: String;
      function Matches(const aException: TObject): Boolean;
      function MatchesClass(const aException: TObject): Boolean;
      function MatchesMessage(const aMessage: String): Boolean;
    public
      constructor Create(const aExceptionClass: TClass; const aIsExact: Boolean; const aMessage: String);
      constructor CreateNoneExpected;
    end;



implementation

  uses
    SysUtils;



{ TExpectedException }

  constructor TExpectedException.Create(const aExceptionClass: TClass;
                                        const aIsExact: Boolean;
                                        const aMessage: String);
  begin
    inherited Create;

    fExceptionClass := aExceptionClass;
    fClassIsExact   := aIsExact;
    fMessage        := aMessage;
  end;


  function TExpectedException.get_ExceptionClass: TClass;
  begin
    result := fExceptionClass;
  end;


  constructor TExpectedException.CreateNoneExpected;
  begin
    inherited Create;

    fNoneExpected := TRUE;
  end;


  function TExpectedException.get_ClassIsExact: Boolean;
  begin
    result := fClassIsExact;
  end;


  function TExpectedException.get_Message: String;
  begin
    result := fMessage;
  end;


  function TExpectedException.get_NoneExpected: Boolean;
  begin
    result := fNoneExpected;
  end;


  function TExpectedException.get_TestName: String;
  begin
    if fNoneExpected then
    begin
      result := 'No exception is raised';
      EXIT;
    end;

    if Assigned(fExceptionClass) then
    begin
      result := 'Raises ' + fExceptionClass.ClassName;
      if not fClassIsExact then
        result := result + ' (or derived exception class)';
    end
    else
      result := 'Raises an exception';

    if fMessage <> '' then
      result := result + ' with message containing ''' + fMessage + '''.';
  end;


  function TExpectedException.Matches(const aException: TObject): Boolean;
  var
    e: Exception absolute aException;
  begin
    if (aException is Exception) then
      result := MatchesClass(aException) and MatchesMessage(e.Message)
    else
      result := MatchesClass(aException) and (fMessage = '');
  end;


  function TExpectedException.MatchesClass(const aException: TObject): Boolean;
  begin
    result := (fExceptionClass = NIL);
    result := result or (fClassIsExact and (fExceptionClass = aException.ClassType));
    result := result or (NOT fClassIsExact and aException.ClassType.InheritsFrom(fExceptionClass));
  end;


  function TExpectedException.MatchesMessage(const aMessage: String): Boolean;
  var
    expected: String;
    actual: String;
  begin
    result := (fMessage = '');
    if result then
      EXIT;

    expected  := LowerCase(fMessage);
    actual    := LowerCase(aMessage);

    result := Pos(expected, actual) > 0;
  end;



end.

