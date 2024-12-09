unit Player;

{$mode DelphiUnicode}

interface

uses
  Classes, SysUtils, Graphics, Input;

type

		{ TPlayer }

  TPlayer = class

      public

      procedure Update(deltaTime : Double); virtual; abstract;
      procedure Draw; virtual; abstract;

		end;

  implementation

end.

