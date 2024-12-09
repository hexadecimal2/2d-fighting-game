unit Timer;

{$mode DelphiUnicode}

interface

uses
  Classes, SysUtils, Windows, Display;

type

	{ TTimer }

 TTimer = class

   constructor Init;
   procedure Tick(var Window: TDisplay);
   procedure Limit(FPS : Integer);
   function DeltaTime : Double;



   private
     PrevTicks, CurrentTicks, Freq, DeltaTicks : Int64;
     FPS, Count, DT : Double;

   procedure CalculateFPS(var Window: TDisplay);

 end;


implementation

{ TTimer }

constructor TTimer.Init;
begin

 PrevTicks := 0;
 Count := 0;
 QueryPerformanceCounter(@CurrentTicks);
 QueryPerformanceFrequency(@Freq);
 FPS := 0;
 DT := 0;
end;

procedure TTimer.Tick(var Window : TDisplay);
begin
  QueryPerformanceCounter(@CurrentTicks);
  DeltaTicks := CurrentTicks - PrevTicks;
  PrevTicks := CurrentTicks;

  FPS := Freq / DeltaTicks;

  Count += (DeltaTicks / Freq);

  CalculateFPS(Window);

end;

function TTimer.DeltaTime : Double;
begin

  result := DeltaTicks / Freq;

end;

procedure TTimer.Limit(FPS: Integer);
begin

  DT := DeltaTicks / Freq;

  while DT <= 1/FPS do
  begin

   QueryPerformanceCounter(@CurrentTicks);
   DT := (CurrentTicks - PrevTicks) / Freq;
  end;

end;

procedure TTimer.CalculateFPS(var Window : TDisplay);
begin

  if (Count >= 1) then
  begin
    WriteLn('FPS : ' + FormatFloat('0', FPS));
    Count := 0;
  end;

end;

end.

