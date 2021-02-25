{
  * MIT LICENSE *

  Copyright � 2020 Jolyon Smith

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

  unit Test.Utils;


interface

  uses
    Deltics.Smoketest;


  type
    TUtilsTests = class(TTest)
      procedure BinToHexEncodesCorrectly;
      procedure InterpolateString;
      procedure XmlEncodedAttrEncodesSymbolsCorrectly;
    {$ifdef UNICODE}
      procedure XmlEncodedAttrEncodesOrphanedHiSurrogateAsCodeReferencesNotEntities;
      procedure XmlEncodedAttrEncodesOrphanedLoSurrogateAsCodeReferencesNotEntities;
      procedure XmlEncodedAttrEncodesSupplementaryCharactersCorrectly;
    {$endif}
    end;


implementation

  uses
    Deltics.Smoketest.Utils;


{ TUtilsTests }

  procedure TUtilsTests.BinToHexEncodesCorrectly;
  var
    buf: Int64;
    s: String;
  begin
    buf := $0a0b0c0dfeff1234;
    s   := BinToHex(@buf, sizeof(BUF));

    Test('BinToHex(@$0a0b0c0dfeff1234)').Assert(s).Equals('0a0b0c0dfeff1234');
  end;


  procedure TUtilsTests.XmlEncodedAttrEncodesSymbolsCorrectly;
  begin
    Test('XmlEncodedAttr(''�2020'')').Assert(XmlEncodedAttr('�2020')).Equals({$ifdef UNICODE}'&#x00a9;2020'{$else}'&#xa9;2020'{$endif});
    Test('XmlEncodedAttr(''1 < 2'')').Assert(XmlEncodedAttr('1 < 2')).Equals('1 &lt; 2');
    Test('XmlEncodedAttr(''1 > 2'')').Assert(XmlEncodedAttr('1 > 2')).Equals('1 &gt; 2');
    Test('XmlEncodedAttr(''1 <= 2'')').Assert(XmlEncodedAttr('1 <= 2')).Equals('1 &lt;= 2');
    Test('XmlEncodedAttr(''1 >= 2'')').Assert(XmlEncodedAttr('1 >= 2')).Equals('1 &gt;= 2');
    Test('XmlEncodedAttr(''a & b'')').Assert(XmlEncodedAttr('a & b')).Equals('a &amp; b');
    Test('XmlEncodedAttr(''[TAB]indented value'')').Assert(XmlEncodedAttr(#9'indented value')).Equals('&#x9;indented value');
    Test('XmlEncodedAttr(''a "quoted" value'')').Assert(XmlEncodedAttr('a "quoted" value')).Equals('a &quot;quoted&quot; value');
    Test('XmlEncodedAttr(''Line 1[LF]Line 2'')').Assert(XmlEncodedAttr('Line 1'#10'Line 2')).Equals('Line 1&#xA;Line 2');
    Test('XmlEncodedAttr(''Line 1[CRLF]Line 2'')').Assert(XmlEncodedAttr('Line 1'#13#10'Line 2')).Equals('Line 1&#xD;&#xA;Line 2');
  end;


{$ifdef UNICODE}
  procedure TUtilsTests.InterpolateString;
  var
    s: String;
  begin
    s := Interpolate('{c:%d} + {b:%d} = {a:%d} = {b} + {c}', [2, 3, 5]);
    Test('Interpolate').Assert(s).Equals('2 + 3 = 5 = 3 + 2');
  end;


  procedure TUtilsTests.XmlEncodedAttrEncodesOrphanedHiSurrogateAsCodeReferencesNotEntities;
  const
    HI = WideChar($d834);
  begin
    Test('XmlEncodedAttr(''' + HI + ''')').Assert(XmlEncodedAttr(HI)).Equals('U+D834');
    Test('XmlEncodedAttr(''' + HI + HI + ''')').Assert(XmlEncodedAttr(HI + HI)).Equals('U+D834U+D834');
  end;


  procedure TUtilsTests.XmlEncodedAttrEncodesOrphanedLoSurrogateAsCodeReferencesNotEntities;
  const
    LO = WideChar($dd1e);
  begin
    Test('XmlEncodedAttr(''' + LO + ''')').Assert(XmlEncodedAttr(LO)).Equals('U+DD1E');
    Test('XmlEncodedAttr(''' + LO + LO + ''')').Assert(XmlEncodedAttr(LO + LO)).Equals('U+DD1EU+DD1E');
  end;


  procedure TUtilsTests.XmlEncodedAttrEncodesSupplementaryCharactersCorrectly;
  const
    CODEPOINT = '01d11e';
    CLEF      = WideChar($d834) + WideChar($dd1e);
  begin
    Test('XmlEncodedAttr(''' + CLEF + ''')').Assert(XmlEncodedAttr(CLEF)).Equals('&#x' + CODEPOINT + ';');
  end;
{$endif}


end.
