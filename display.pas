unit Display;

{$mode DelphiUnicode}

interface

uses
  Classes, SysUtils, Windows, Graphics, Input;

type

		{ TDisplay }

  TDisplay = class

    public

      constructor Create(Width, Height, X, Y : Integer; windowTitle : String; var Renderer : TGraphics);
      function getWindowHandle : HANDLE;
      function isRunning : Boolean;
      procedure processMessages;
      procedure swapBuffers;
      procedure setContext;
      procedure setWindowText(Text: String);

    private

      X, Y : Integer;
      Width, Height : Integer;
      ClientWidth, ClientHeight : Integer;
      windowTitle : String;
      Renderer : TGraphics;

      Running : Boolean;

      hWindow : HWND;

      hDevContext : HDC;
      hGLContext : HGLRC;

      Message : TMSG;

      procedure setupPFD;

      function windowProc(MSG : UINT; WPARAM : WPARAM; LPARAM : LPARAM) : LRESULT; STDCALL;



		end;

var
  WC : TWNDCLASSEXW;
  PFD : TPIXELFORMATDESCRIPTOR;
  hInstance : HINST;
  Rect : TRect;

implementation

function DummyProc(HWND : HWND; MSG : UINT; WPARAM : WPARAM; LPARAM : LPARAM) : LRESULT; STDCALL;
var
  d : TDisplay;
begin


  d := TDisplay(GetWindowLongPtrW(HWND, GWLP_USERDATA));

  if Assigned(d) then
  begin
  Result := d.windowProc(MSG, WPARAM, LPARAM);
		end
  else

  Result := DefWindowProcW(HWND, MSG, WPARAM, LPARAM);

end;

{ TDisplay }

constructor TDisplay.Create(Width, Height, X, Y: Integer; windowTitle: String;
		var Renderer: TGraphics);
begin

  Self.Width := Width;
  Self.Height := Height;
  Self.X := X;
  Self.Y := Y;
  Self.windowTitle := windowTitle;
  Self.Renderer := Renderer;

  Self.Running := True;

  hInstance := MainInstance;

  if WC.cbSize <> SizeOf(TWNDCLASSEXW) then
  begin

    FillChar(WC, SizeOf(TWNDCLASSEXW), 0);

    WC.cbSize := SizeOf(TWNDCLASSEXW);
    WC.style := CS_VREDRAW or CS_HREDRAW;
    WC.lpfnWndProc := @DummyProc;
    WC.cbClsExtra := 0;
    WC.cbWndExtra := SizeOf(Pointer);//SizeOf(TDisplay);
    WC.hInstance := hInstance;
    WC.hIcon := LoadIcon(0, IDI_APPLICATION);
    WC.hCursor := LoadCursor(0, IDC_CROSS);
    WC.hbrBackground := 0;
    WC.lpszMenuName := nil;
    WC.lpszClassName := 'displayClass';
    WC.hIconSm := LoadIcon(hInstance, IDI_APPLICATION);

		end;


  if RegisterClassExW(@WC) = 0 then
  begin
    MessageBoxW(0, 'Failed to register class', 'Error', MB_OK);
		end;

   Self.hWindow := CreateWindowExW(
   0,
   'displayClass',
   @Self.windowTitle[1],
   WS_OVERLAPPEDWINDOW,
   Self.X,
   Self.Y,
   Self.Width,
   Self.Height,
   0,
   0,
   hInstance,
   nil
   );

   if Self.hWindow = 0 then
   begin
     MessageBoxW(0,'Failed to create window', 'Error', MB_OK);
     Exit;
   end;

   Input.currentHWND := Self.hWindow;


   Self.hDevContext := GetDC(Self.hWindow);
   setupPFD;
   Self.hGLContext := wglCreateContext(Self.hDevContext);
   wglMakeCurrent(Self.hDevContext, Self.hGLContext);

   ShowWindow(Self.hWindow, SW_SHOW);
   UpdateWindow(Self.hWindow);

   SetWindowLongPtrW(Self.hWindow, GWLP_USERDATA, LONG_PTR(Self));

   Renderer.Init;

   GetClientRect(self.hWindow, @Rect);
   Self.ClientWidth := Rect.Width;
   Self.ClientHeight := Rect.Height;
   Renderer.setViewport(ClientWidth, ClientHeight);


end;

function TDisplay.getWindowHandle: HANDLE;
begin
  result := self.hWindow;
end;

function TDisplay.isRunning: Boolean;
begin
 Result := Self.Running;
end;

procedure TDisplay.processMessages;
begin

   while PeekMessage(@Self.Message, 0, 0, 0, PM_NOREMOVE) do
   begin

    if not GetMessage(@Self.Message, 0, 0, 0) then
    begin
    Self.Running := False;
    Exit;

				end;

    TranslateMessage(@Self.Message);
    DispatchMessage(@Self.Message);


   end;


 end;

procedure TDisplay.swapBuffers;
begin
  Windows.SwapBuffers(Self.hDevContext);
end;

procedure TDisplay.setContext;
begin
  wglMakeCurrent(self.hDevContext, self.hGLContext);
end;

procedure TDisplay.setWindowText(Text : String);
begin
  Windows.SetWindowTextW(hWindow, @Text[1]);
end;

procedure TDisplay.setupPFD;
var
  pixelformat : integer;
begin


  FillChar(PFD, SizeOf(TPIXELFORMATDESCRIPTOR), 0);
  PFD.nSize := SizeOf(TPIXELFORMATDESCRIPTOR);
  PFD.nVersion := 1;
  PFD.dwFlags := PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER;
  PFD.iPixelType := PFD_TYPE_RGBA;
  PFD.iLayerType := PFD_MAIN_PLANE;
  PFD.cColorBits := 32;
  PFD.cRedBits := 8;
  PFD.cGreenBits := 8;
  PFD.cBlueBits := 8;
  PFD.cAlphaBits := 8;
  PFD.cDepthBits := 24;

  pixelformat := ChoosePixelFormat(hDevContext, @PFD);
  SetPixelFormat(hDevContext, pixelformat, @PFD);

end;

function TDisplay.windowProc(MSG: UINT; WPARAM: WPARAM;
		LPARAM: LPARAM): LRESULT; STDCALL;

var
  Rect : TRect;

begin

 case MSG of

 WM_CLOSE:
  begin
    PostQuitMessage(0);
  end;

 WM_SIZE:
  begin

   GetWindowRect(Self.hWindow, @Rect);

   Self.Width := Rect.Width;
   Self.Height:= Rect.Height;

   Self.Renderer.setViewport(LOWORD(LPARAM), HIWORD(LPARAM));
   end;

 end;


 Result := DefWindowProcW(Self.hWindow, MSG, WPARAM, LPARAM);

end;


end.

