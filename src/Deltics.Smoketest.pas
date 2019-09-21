
{$i Deltics.Smoketest.inc}

  unit Deltics.Smoketest;

interface

  uses
    Deltics.Smoketest.Test,
    Deltics.Smoketest.TestRun;

  type
    TTest = Deltics.Smoketest.Test.TTest;

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
                     {$ifdef VER180} // See above
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
                     {$ifdef VER330} '10.3' {$endif}
                     ;

  function TestRun: TTestRun;


implementation

  function TestRun: TTestRun;
  begin
    result := Deltics.Smoketest.TestRun.TestRun;
  end;


end.
