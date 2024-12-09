unit Stage;

{$mode DelphiUnicode}

interface

uses
  Classes, SysUtils, Graphics, Generics.Collections;

type

		{ TStage }

  TStage = class

    public

      procedure SetStage(StageName : String; Texture : TTexture);
      Procedure Draw;

    private

      Texture : TTexture;
      StageName : String;
		end;

implementation

{ TStage }

procedure TStage.SetStage(StageName: String; Texture : TTexture);
begin

    Self.Texture := Texture;
    Self.StageName := StageName;

end;

procedure TStage.Draw;
begin

    DrawTexture(Texture.TextureID, 0, 0, 0, Texture.Width, Texture.Height);
end;

end.

