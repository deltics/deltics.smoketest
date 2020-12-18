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

  unit Test.GuidAssertions;


interface

  uses
    Deltics.Smoketest,
    SelfTest;


  type
    TGuidAssertionTests = class (TSelfTest)
      procedure EqualsFailsWhenGuidsAreNotEqual;
      procedure EqualsPassesWhenGuidsAreEqual;
      procedure IsNotNullGuidFailsWhenGuidIsNullGuid;
      procedure IsNotNullGuidPassesWhenGuidIsNotNullGuid;
      procedure IsNullGuidFailsWhenGuidIsNotNullGuid;
      procedure IsNullGuidPassesWhenGuidIsNullGuid;
    end;


implementation




  const
    NullGuidStr = '{00000000-0000-0000-0000-000000000000}';



{ TGuidAssertionTests }

  procedure TGuidAssertionTests.EqualsFailsWhenGuidsAreNotEqual;
  const
    A: TGuid = '{3BDC813E-E5AD-4BD5-A4BE-74ED22E67044}';
    B: TGuid = '{516C9CA0-B864-4483-B075-1C6326C21EC8}';
  begin
    Test.IsExpectedToFail;

    Assert(A).Equals(B);
  end;


  procedure TGuidAssertionTests.EqualsPassesWhenGuidsAreEqual;
  const
    A: TGuid = '{3BDC813E-E5AD-4BD5-A4BE-74ED22E67044}';
    B: TGuid = '{3BDC813E-E5AD-4BD5-A4BE-74ED22E67044}';
  begin
    Assert(A).Equals(B);
  end;


  procedure TGuidAssertionTests.IsNotNullGuidFailsWhenGuidIsNullGuid;
  const
    A: TGuid = NullGuidStr;
  begin
    Test.IsExpectedToFail;

    Assert(A).IsNotNullGuid;
  end;


  procedure TGuidAssertionTests.IsNotNullGuidPassesWhenGuidIsNotNullGuid;
  const
    A: TGuid = '{9E821E7E-747B-4EE7-B986-3F2586687833}';
  begin
    Assert(A).IsNotNullGuid;
  end;


  procedure TGuidAssertionTests.IsNullGuidFailsWhenGuidIsNotNullGuid;
  const
    A: TGuid = '{9E821E7E-747B-4EE7-B986-3F2586687833}';
  begin
    Test.IsExpectedToFail;

    Assert(A).IsNullGuid;
  end;


  procedure TGuidAssertionTests.IsNullGuidPassesWhenGuidIsNullGuid;
  const
    A: TGuid = NullGuidStr;
  begin
    Assert(A).IsNullGuid;
  end;



end.
