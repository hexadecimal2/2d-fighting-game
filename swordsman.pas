unit Swordsman;

{$mode DelphiUnicode}

interface

uses
  Classes, SysUtils, Player, Graphics, Input;

type

		{ TSwordsman }

  TSwordsman = class(TPlayer)

    public
    constructor Create(X, Y, Z :Single; Width, Height: Integer; Texture: TTexture);
    procedure Update(deltaTime: Double); override;
    procedure Draw; override;

    private

    X, Y, Z : Single;
    Width, Height : Integer;
    Texture : TTexture;


		end;

implementation

{ TSwordsman }

constructor TSwordsman.Create(X, Y, Z: Single;  Width, Height: Integer; Texture: TTexture);
begin

    Self.Texture := Texture;
    Self.X := X;
    Self.Y := Y;
    Self.Z := Z;
    Self.Width := Width;
    Self.Height := Height;

end;

procedure TSwordsman.Update(deltaTime: Double);
begin

   if IsKeyDown(VK_D) then
   begin
     X += 1000 * deltaTime;
			end;

   if IsKeyDown(VK_A) then
   begin
     X -= 1000 * deltaTime;
			end;

   if IsKeyDown(VK_W) then
   begin
     Y -= 1000 * deltaTime;
			end;

   if IsKeyDown(VK_S) then
   begin
     Y += 1000 * deltaTime;
			end;

end;

procedure TSwordsman.Draw;
begin
   DrawTexture(Texture.TextureID, Self.X, Self.Y, Self.Z, Self.Width, Self.Height, 4);
end;

end.

