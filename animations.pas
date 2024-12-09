unit Animations;

{$mode DelphiUnicode}

interface

uses
  Classes, SysUtils, Graphics, Generics.Collections;

type

  
		{ TAnimation }

  TAnimation = record
    AnimationTexture  : TTexture;
    NumberOfFrames : Integer;
    AnimationSpeed : Double;

  constructor Create(NumberOfFrames: Integer; AnimationSpeed: Double;
				AnimationTexture: TTexture);

  end;


		{ TAnimations }

  TAnimations = class

  public

    constructor Create;
    procedure AddAnimation(AnimationName : String; NumberOfFrames : Integer; AnimationSpeed : Double; AnimationTexture : TTexture);
    procedure PlayAnimation(AnimationName : String);

  private

    Animations: TDictionary<String, TAnimation>;


		end;



implementation

{ TAnimation }

constructor TAnimation.Create(NumberOfFrames: Integer;
		AnimationSpeed: Double; AnimationTexture: TTexture);
begin
  Self.AnimationTexture := AnimationTexture;
  Self.AnimationSpeed := AnimationSpeed;
  Self.NumberOfFrames := NumberOfFrames;
end;



{ TAnimations }

constructor TAnimations.Create;
begin

  Animations := TDictionary<String, TAnimation>.Create;

end;

procedure TAnimations.AddAnimation(AnimationName: String;
		NumberOfFrames: Integer; AnimationSpeed: Double; AnimationTexture: TTexture);
begin

  Self.Animations.Add(AnimationName, TAnimation.Create(NumberOfFrames, AnimationSpeed, AnimationTexture));

end;

procedure TAnimations.PlayAnimation(AnimationName: String);
var
  anim : TAnimation;
  timer : double;
begin

  anim := Self.Animations[AnimationName];





end;

end.

