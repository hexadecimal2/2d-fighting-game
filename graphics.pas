unit Graphics;

{$mode DelphiUnicode}

interface

uses
 Classes, SysUtils, GL, glu, GLext, Input, Imaging, ImagingTypes;

type

	{ TColor }

 TColor = record
  R, G, B, A: single;

  constructor Create(R, G, B, A : Single);

 end;

 TTexture = record

  TextureID: GLuint;
  Width, Height: integer;
  Format: string;

 end;

 GLuint = cardinal;

 { TGraphics }

 TGraphics = class

 public

  constructor Create;
  procedure Init;
  procedure Refresh(R, G, B, A: single); overload;
  procedure Refresh(Color: TColor); overload;
  procedure setViewport(Width, Height: integer);
  procedure drawSquare(x, y, z: Single; color: TColor);


 private

  Width, Height: integer;
 end;


procedure DrawTexture(Texture: GLuint; X, Y, Z: single; Width, Height: integer;
 Scale: integer = 1);
function LoadTexture(Path: string): TTexture;

procedure BeginTransparency;
procedure EndTransparency;

implementation

{ TColor }

constructor TColor.Create(R, G, B, A: Single);
begin
  Self.R := R;
  Self.G := G;
  Self.B := B;
  Self.A := A;
end;

{ TGraphics }

constructor TGraphics.Create;
begin
end;

procedure TGraphics.Init;
begin

 if Load_GL_VERSION_2_1() then
 begin

 Load_WGL_EXT_swap_control;

 glEnable(GL_DEPTH_TEST);
 glEnable(GL_BLEND);
 glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

 wglSwapIntervalEXT(0);

	end
 else
 begin
 Writeln('Could not load OPENGL 2.1');
 ReadLn;
 Exit;
 end;

end;

procedure TGraphics.Refresh(R, G, B, A: single);
begin

 glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
 glClearColor(R, G, B, A);


end;

procedure TGraphics.Refresh(Color: TColor);
begin
 glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
 glClearColor(Color.R, Color.G, Color.B, Color.A);
end;

procedure TGraphics.setViewport(Width, Height: integer);
begin

 if Height = 0 then
 begin
  Self.Height := 1;
 end;

 Self.Height := Height;
 Self.Width := Width;

 glViewport(0, 0, Self.Width, Self.Height);

 glMatrixMode(GL_PROJECTION);
 glLoadIdentity;
 glOrtho(0, Self.Width, Self.Height, 0, 1, -1);

 glMatrixMode(GL_MODELVIEW);

end;

procedure TGraphics.drawSquare(x, y, z : Single; color : TColor);
begin

 glPushMatrix;

 glLoadIdentity;
 glTranslatef(x, y, z);

 glBegin(GL_QUADS);

 glColor4f(color.R, color.G, color.B, color.A);

 glVertex3f(0, 0, 0);
 glVertex3f(100, 0, 0);
 glVertex3f(100, 100, 0);
 glVertex3f(0, 100, 0);

 glEnd;

 glPopMatrix;

end;

procedure DrawTexture(Texture: GLuint; X, Y, Z: single; Width, Height: integer;
 Scale: integer = 1);
begin

  glEnable(GL_TEXTURE_2D);
  glBindTexture(GL_TEXTURE_2D, texture);

  glPushMatrix;

  glLoadIdentity;

  glTranslatef(X, Y, Z);

  glBegin(GL_QUADS);

  glColor4f(1, 1, 1, 1);

  //top left
  glTexCoord2f(0, 1);
  glVertex3f(0, 0, 0);

  //bottom left
  glTexCoord2f(0, 0);
  glVertex3f(0, Height * Scale, 0);

  //bottom right
  glTexCoord2f(1, 0);
  glVertex3f(Width * Scale, Height * Scale, 0);

  //top right
  glTexCoord2f(1, 1);
  glVertex3f(Width * Scale, 0, 0);

  glEnd;

  glPopMatrix;


end;


function LoadTexture(Path: string): TTexture;
var
 img: TImageData;
 texture: GLuint;
begin

 try

  InitImage(img);
  LoadImageFromFile(path, img);

  FlipImage(img);
  ConvertImage(img, ifA8R8G8B8);


  glGenTextures(1, @texture);
  glBindTexture(GL_TEXTURE_2D, texture);

  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
  glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, GL_TRUE);

  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, img.Width, img.Height, 0,
   GL_BGRA, GL_UNSIGNED_BYTE, img.Bits);



  Result.Width := img.Width;
  Result.Height := img.Height;
  Result.TextureID := Texture;
  Result.Format := GetFormatName(img.Format);

  FreeImage(img);

 except
  on E: Exception do
  begin
   WriteLn(E.Message);
  end;

 end;
end;

procedure BeginTransparency;
begin
 glDepthMask(GL_FALSE);
end;

procedure EndTransparency;
begin
 glDepthMask(GL_TRUE);
end;


end.
