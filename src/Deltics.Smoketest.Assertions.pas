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

  unit Deltics.Smoketest.Assertions;


interface

  uses
    Deltics.Smoketest.Assertions.Integers,
    Deltics.Smoketest.Assertions.AnsiStrings,
    Deltics.Smoketest.Assertions.UnicodeStrings,
    Deltics.Smoketest.Assertions.WideStrings;

  type
    IntegerAssertions       = Deltics.Smoketest.Assertions.Integers.IntegerAssertions;
    AnsiStringAssertions    = Deltics.Smoketest.Assertions.AnsiStrings.AnsiStringAssertions;
    UnicodeStringAssertions = Deltics.Smoketest.Assertions.UnicodeStrings.UnicodeStringAssertions;
    WideStringAssertions    = Deltics.Smoketest.Assertions.WideStrings.WideStringAssertions;

    TIntegerAssertions        = Deltics.Smoketest.Assertions.Integers.TIntegerAssertions;
    TAnsiStringAssertions     = Deltics.Smoketest.Assertions.AnsiStrings.TAnsiStringAssertions;
    TUnicodeStringAssertions  = Deltics.Smoketest.Assertions.UnicodeStrings.TUnicodeStringAssertions;
    TWideStringAssertions     = Deltics.Smoketest.Assertions.WideStrings.TWideStringAssertions;


implementation


end.
