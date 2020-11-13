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

  unit Deltics.Smoketest;


interface

  uses
    Deltics.Smoketest.Test,
    Deltics.Smoketest.TestRun,
    Deltics.Smoketest.Utils;

  // Elevate the scope of the TTest class so that test class implementation units
  //  need only reference Deltics.Smoketest.
  type
    TTest         = Deltics.Smoketest.Test.TTest;
    EInvalidTest  = Deltics.Smoketest.Utils.EInvalidTest;

  const
    METHOD_NAME = Deltics.Smoketest.Test.METHOD_NAME;
    TEST_NAME   = Deltics.Smoketest.Test.TEST_NAME;


  // This function provides read-only access to the TestRun variable maintained
  //  in the TestRun implementation unit.
  function TestRun: TTestRun;


  const
    DELPHI_VERSION = {$ifdef VER80}  '1' {$endif}
                     {$ifdef VER90}  '2' {$endif}
                     {$ifdef VER100} '3' {$endif}
                     {$ifdef VER120} '4' {$endif}
                     {$ifdef VER130} '5' {$endif}
                     {$ifdef VER140} '6' {$endif}
                     {$ifdef VER150} '7' {$endif}
                     {$ifdef VER160} '8' {$endif}

                     {$ifdef VER170} '2005' {$endif}
                     {$ifdef VER180} // VER180 is defined for both Delphi 2006 and 2007
                       {$ifdef VER185}
                         '2007'
                       {$else}
                         '2006'
                       {$endif}
                     {$endif}
                     {$ifdef VER200} '2009' {$endif}
                     {$ifdef VER210} '2010' {$endif}

                     {$ifdef VER220} 'xe'  {$endif}
                     {$ifdef VER230} 'xe2' {$endif}
                     {$ifdef VER240} 'xe3' {$endif}
                     {$ifdef VER250} 'xe4' {$endif}
                     {$ifdef VER260} 'xe5' {$endif}
                     {$ifdef VER270} 'xe6' {$endif}
                     {$ifdef VER280} 'xe7' {$endif}
                     {$ifdef VER290} 'xe8' {$endif}

                     {$ifdef VER300} '10'   {$endif}
                     {$ifdef VER310} '10.1' {$endif}
                     {$ifdef VER320} '10.2' {$endif}
                     {$ifdef VER330} '10.3' {$endif};

    DELPHI_VERSION_NAME = {$ifdef VER80}  'Delphi 1' {$endif}
                          {$ifdef VER90}  'Delphi 2' {$endif}
                          {$ifdef VER100} 'Delphi 3' {$endif}
                          {$ifdef VER120} 'Delphi 4' {$endif}
                          {$ifdef VER130} 'Delphi 5' {$endif}
                          {$ifdef VER140} 'Delphi 6' {$endif}
                          {$ifdef VER150} 'Delphi 7' {$endif}
                          {$ifdef VER160} 'Delphi 8' {$endif}

                          {$ifdef VER170} 'Delphi 2005' {$endif}
                          {$ifdef VER180} // VER180 is defined for both Delphi 2006 and 2007
                            {$ifdef VER185}
                              'Delphi 2007'
                            {$else}
                              'Delphi 2006'
                            {$endif}
                          {$endif}
                          {$ifdef VER200} 'Delphi 2009' {$endif}
                          {$ifdef VER210} 'Delphi 2010' {$endif}

                          {$ifdef VER220} 'Delphi XE'  {$endif}
                          {$ifdef VER230} 'Delphi XE2' {$endif}
                          {$ifdef VER240} 'Delphi XE3' {$endif}
                          {$ifdef VER250} 'Delphi XE4' {$endif}
                          {$ifdef VER260} 'Delphi XE5' {$endif}
                          {$ifdef VER270} 'Delphi XE6' {$endif}
                          {$ifdef VER280} 'Delphi XE7' {$endif}
                          {$ifdef VER290} 'Delphi XE8' {$endif}

                          {$ifdef VER300} 'Delphi 10 Seattle' {$endif}
                          {$ifdef VER310} 'Delphi 10.1 Berlin'{$endif}
                          {$ifdef VER320} 'Delphi 10.2 Tokyo' {$endif}
                          {$ifdef VER330} 'Delphi 10.3 Rio'   {$endif};



implementation

  // NOTE: Ensure that results writer implementations are added to this uses clause!
  uses
    Deltics.Smoketest.ResultsWriter.XUnit2;


  function TestRun: TTestRun;
  begin
    result := Deltics.Smoketest.TestRun.TestRun;
  end;


end.
