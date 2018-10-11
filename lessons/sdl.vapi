/*
The MIT License (MIT)

Copyright (c) <2018> <sdl vapi>

SDL2 definitions used for xna port.


Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
[CCode (cheader_filename = "SDL2/SDL.h")]
namespace Sdl 
{
	[CCode (cname = "SDL_GL_GetProcAddress")]
	public void* SDL_GL_GetProcAddress (string proc);

	[CCode (cname = "SDL_GL_GetProcAddress")]
	public T LoadEntryPoint<T> (string proc);

	private unowned string GetString (IntPtr handle)
	{
		if (handle == IntPtr.Zero) return "";

		var ptr = (char*)handle;
        while (*ptr != 0)
			ptr++;
			
		var len = ptr - (char*)handle;
		var bytes = new char[len];
		return (string) GLib.Memory.copy (bytes, handle, len);
	} 

	[SimpleType, CCode (cname = "SDL_JoystickGUID")]
	public struct Guid
	{
		[CCode (cname = "data", has_length = false)]
		public uint8 Data[16];

		public string to_string ()
		{
			return "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x".printf (
				Data[0],  Data[1], Data[2], Data[3], 
				Data[4],  Data[5], 
				Data[6],  Data[7],
				Data[8],  Data[9], 
				Data[10], Data[11], Data[12], Data[13], Data[14], Data[15]);
		}
	}
	  
	[Flags]
	public enum InitFlags 
	{
		[CCode (cname = "SDL_INIT_VIDEO")]
		Video,
		[CCode (cname = "SDL_INIT_JOYSTICK")]
		Joystick,
		[CCode (cname = "SDL_INIT_HAPTIC")]
		Haptic,
		[CCode (cname = "SDL_INIT_GAMECONTROLLER")]
		GameController
	}


	[CCode (cname = "SDL_EventType", cheader_filename = "SDL2/SDL_events.h")]
	public enum EventType 
	{
		[CCode (cname = "SDL_FIRSTEVENT")]
		First, 
		[CCode (cname = "SDL_QUIT")]
		Quit,

		[CCode (cname = "SDL_WINDOWEVENT")]
        WindowEvent,
		[CCode (cname = "SDL_SYSWMEVENT")]
        SysWM,

		[CCode (cname = "SDL_KEYDOWN")]
        KeyDown,
		[CCode (cname = "SDL_KEYUP")]
        KeyUp,
		[CCode (cname = "SDL_TEXTEDITING")]
        TextEditing,
		[CCode (cname = "SDL_TEXTINPUT")]
        TextInput,

		[CCode (cname = "SDL_MOUSEMOTION")]
        MouseMotion,
		[CCode (cname = "SDL_MOUSEBUTTONDOWN")]
        MouseButtonDown,
		[CCode (cname = "SDL_MOUSEBUTTONUP")]
        MouseButtonup,
		[CCode (cname = "SDL_MOUSEWHEEL")]
        MouseWheel,

		[CCode (cname = "SDL_JOYAXISMOTION")]
        JoyAxisMotion,
		[CCode (cname = "SDL_JOYBALLMOTION")]
        JoyBallMotion,
		[CCode (cname = "SDL_JOYHATMOTION")]
        JoyHatMotion,
		[CCode (cname = "SDL_JOYBUTTONDOWN")]
        JoyButtonDown,
		[CCode (cname = "SDL_JOYBUTTONUP")]
        JoyButtonUp,
		[CCode (cname = "SDL_JOYDEVICEADDED")]
        JoyDeviceAdded,
		[CCode (cname = "SDL_JOYDEVICEREMOVED")]
        JoyDeviceRemoved,

		[CCode (cname = "SDL_CONTROLLERAXISMOTION")]
        ControllerAxisMotion,
		[CCode (cname = "SDL_CONTROLLERBUTTONDOWN")]
        ControllerButtonDown,
		[CCode (cname = "SDL_CONTROLLERBUTTONUP")]
        ControllerButtonUp,
		[CCode (cname = "SDL_CONTROLLERDEVICEADDED")]
        ControllerDeviceAdded,
		[CCode (cname = "SDL_CONTROLLERDEVICEREMOVED")]
        ControllerDeviceRemoved,
		[CCode (cname = "SDL_CONTROLLERDEVICEREMAPPED")]
        ControllerDeviceRemapped,

		[CCode (cname = "SDL_FINGERDOWN")]
        FingerDown,
		[CCode (cname = "SDL_FINGERUP")]
        FingerUp,
		[CCode (cname = "SDL_FINGERMOTION")]
        FingerMotion,

		[CCode (cname = "SDL_DOLLARGESTURE")]
        DollarGesture,
		[CCode (cname = "SDL_DOLLARRECORD")]
        DollarRecord,
		[CCode (cname = "SDL_MULTIGESTURE")]
        MultiGesture,

		[CCode (cname = "SDL_CLIPBOARDUPDATE")]
        ClipboardUpdate,

		[CCode (cname = "SDL_DROPFILE")]
        DropFile,

		[CCode (cname = "SDL_AUDIODEVICEADDED")]
        AudioDeviceAdded,
		[CCode (cname = "SDL_AUDIODEVICEREMOVED")]
        AudioDeviceRemoved,

		[CCode (cname = "SDL_RENDER_TARGETS_RESET")]
        RenderTargetsReset,
		[CCode (cname = "SDL_RENDER_DEVICE_RESET")]
        RenderDeviceReset,

		[CCode (cname = "SDL_USEREVENT")]
        UserEvent,

		[CCode (cname = "SDL_LASTEVENT")]
        Last

	}

	[SimpleType, CCode (cname = "SDL_CommonEvent", cheader_filename = "SDL2/SDL_events.h")]
	public struct CommonEvent  
	{
		[CCode (cname = "type")]
		public Sdl.EventType Type;
		[CCode (cname = "timestamp")]
		public uint32 Timestamp;
	}


	[CCode (cname = "SDL_eventaction", cheader_filename = "SDL2/SDL_events.h")]
	public enum EventAction 
	{
		[CCode (cname = "SDL_ADDEVENT")]
		AddEvent, 
		[CCode (cname = "SDL_PEEKEVENT")]
		PeekEvent, 
		[CCode (cname = "SDL_GETEVENT")]
		GetEvent
	}

	[SimpleType, CCode (cname = "SDL_Event", cheader_filename = "SDL2/SDL_events.h")]
	public struct Event 
	{
		[CCode (cname = "type")]
		public Sdl.EventType Type;
		[CCode (cname = "window")]
		public Sdl.Window.Event Window;
		[CCode (cname = "key")]
		public Sdl.Keyboard.Event Key;
		[CCode (cname = "motion")]
		public Sdl.Mouse.MotionEvent Motion;
		[CCode (cname = "edit")]
		public Sdl.Keyboard.TextEditingEvent Edit;
		[CCode (cname = "text")]
		public Sdl.Keyboard.TextInputEvent Text;
		[CCode (cname = "wheel")]
		public Sdl.Mouse.WheelEvent Wheel;
		[CCode (cname = "jdevice")]
		public Sdl.Joystick.DeviceEvent JoystickDevice;
		[CCode (cname = "cdevice")]
		public Sdl.GameController.DeviceEvent ControllerDevice;
	}

	[SimpleType, CCode (cname = "SDL_Point", cheader_filename = "SDL2/SDL_rect.h")]
	public struct Point {
		[CCode (cname = "x")]
		public int X;
		[CCode (cname = "y")]
		public int Y;
	}

	[SimpleType, CCode (cname = "SDL_Rect", cheader_filename = "SDL2/SDL_rect.h")]
	public struct Rect : Point
	{
		[CCode (cname = "w")]
		public int Width;
		[CCode (cname = "h")]
		public int Height;
	}

	[SimpleType, CCode (cname = "SDL_version", cheader_filename = "SDL2/SDL_version.h")]
	public struct Version 
	{
		[CCode (cname = "major")]
		public uint8 Major;
		[CCode (cname = "minor")]
		public uint8 Minor;
		[CCode (cname = "patch")]
		public uint8 Patch;
	}

	[CCode (cname = "SDL_RWops")]
	public struct RWops
	{
		[CCode (cname = "type")]
		public uint32 Type;
	}
	
	[CCode (cname = "SDL_Init")]
	private static int SDL_Init (int flags);
	
	public static int Init (int flags) {
		GetErrorInt (SDL_Init (flags));
	}
		

	[CCode (cname = "SDL_GL_GetCurrentWindow")]
	public static IntPtr GetCurrentWindow ();

	[CCode (cname = "SDL_DisableScreenSaver")]
	public static void DisableScreenSaver ();

	[CCode (cname = "SDL_GetVersion")]
	public static void GetVersion (out Version v);

	[CCode (cname = "SDL_PollEvent")]
	public static int PollEvent (out Sdl.Event ev);

	[CCode (cname = "SDL_PumpEvents")]
	public static void PumpEvents ();

	[CCode (cname = "SDL_PeepEvents")]
	public static void PeepEvents (Sdl.Event[] events, EventAction action,
		uint32 minType, uint32 maxType);

	[CCode (cname = "SDL_CreateRGBSurfaceFrom")]
	public IntPtr CreateRGBSurfaceFrom (IntPtr pixels, int width, int height, int depth,
		int pitch, uint32 rMask, uint32 gMask, uint32 bMask, uint32 aMask);

	[CCode (cname = "SDL_FreeSurface")]
		public void FreeSurface (IntPtr surface);

	[CCode (cname = "SDL_GetError")]
	public static unowned string SDL_GetError ();

	//  private string getErrorStr ()
	//  {
	//  	return GetString (SDL_GetError ());
	//  }

    private int GetErrorInt (int value)
    {
        if (value < 0)
			GLib.stdout.printf (SDL_GetError ());
		return value;
	}

	private IntPtr GetErrorPtr (string name, IntPtr? pointer)
    {
		if (pointer == IntPtr.Zero)
			GLib.stdout.printf ("%s: %s\n", name, SDL_GetError ());
		return pointer;
	}
	
	[CCode (cname = "SDL_ClearError")]
    public static extern void ClearError ();
	
	[CCode (cname = "SDL_GetHint", cheader_filename = "SDL2/SDL_hints.h")]
	public static unowned string GetHint (string name);

	[CCode (cname = "SDL_LoadBMP_RW")]
	public IntPtr LoadBMP_RW (IntPtr src, int freesrc = 0);

	[CCode (cname = "SDL_Quit")]
	public static void Quit ();

	[CCode (cname = "SDL_RWFromMem")]
	public static RWops* RWFromMem (void* mem, int size);

	[CCode (cname = "SDL_RWFromFile")]
	public static RWops* RWFromFile (string file, string mode);

	[CCode (cname = "SDL_RWread")]
	public static size_t RWread (RWops* rw, void* ptr, size_t size, size_t maxnum);
	
	[CCode (cname = "SDL_SetHint", cheader_filename = "SDL2/SDL_hints.h")]
	public static bool SetHint (string name, string hintValue);

	[CCode (cname = "SDL_GetPerformanceFrequency")]
	public static uint64 GetPerformanceFrequency ();

	[CCode (cname = "SDL_GetPerformanceCounter")]
	public static uint64 GetPerformanceCounter ();
			
	[CCode (cname = "SDL_Delay")]
	public static void Delay (uint32 ms);
			
	

	[CCode (cname = "SDL_Window", cheader_filename = "SDL2/SDL_video.h")]
	public class Window 
	{
		[CCode (cname = "SDL_WINDOWPOS_UNDEFINED_MASK")]
		public static const uint8 PosUndefined;

		[CCode (cname = "SDL_WINDOWPOS_CENTERED_MASK")]
		public static const uint8 PosCentered;

		[CCode (cname = "SDL_WindowEventID", cheader_filename = "SDL2/SDL_events.h")]
		public enum EventId 
		{
			[CCode (cname = "SDL_WINDOWEVENT_NONE")]
			None, 
			[CCode (cname = "SDL_WINDOWEVENT_SHOWN")]
            Shown,
			[CCode (cname = "SDL_WINDOWEVENT_HIDDEN")]
            Hidden,
			[CCode (cname = "SDL_WINDOWEVENT_EXPOSED")]
            Exposed,
			[CCode (cname = "SDL_WINDOWEVENT_MOVED")]
            Moved,
			[CCode (cname = "SDL_WINDOWEVENT_RESIZED")]
            Resized,
			[CCode (cname = "SDL_WINDOWEVENT_SIZE_CHANGED")]
            SizeChanged,
			[CCode (cname = "SDL_WINDOWEVENT_MINIMIZED")]
            Minimized,
			[CCode (cname = "SDL_WINDOWEVENT_MAXIMIZED")]
            Maximized,
			[CCode (cname = "SDL_WINDOWEVENT_RESTORED")]
            Restored,
			[CCode (cname = "SDL_WINDOWEVENT_ENTER")]
            Enter,
			[CCode (cname = "SDL_WINDOWEVENT_LEAVE")]
            Leave,
			[CCode (cname = "SDL_WINDOWEVENT_FOCUS_GAINED")]
            FocusGained,
			[CCode (cname = "SDL_WINDOWEVENT_FOCUS_LOST")]
            FocusLost,
			[CCode (cname = "SDL_WINDOWEVENT_CLOSE")]
            Close,
		}

		[Flags, CCode (cname = "SDL_WindowFlags", cheader_filename = "SDL2/SDL_video.h")]
		public enum State 
		{
			[CCode (cname = "SDL_WINDOW_FULLSCREEN")] 
			Fullscreen,
			[CCode (cname = "SDL_WINDOW_OPENGL")] 
			OpenGL,
			[CCode (cname = "SDL_WINDOW_SHOWN")] 
			Shown,
			[CCode (cname = "SDL_WINDOW_HIDDEN")] 
			Hidden,
			[CCode (cname = "SDL_WINDOW_BORDERLESS")] 
			Borderless,
			[CCode (cname = "SDL_WINDOW_RESIZABLE")] 
			Resizable,
			[CCode (cname = "SDL_WINDOW_MINIMIZED")] 
			Minimized,
			[CCode (cname = "SDL_WINDOW_MAXIMIZED")] 
			Maximized,
			[CCode (cname = "SDL_WINDOW_GRABBED")] 
			Grabbed,
			[CCode (cname = "SDL_WINDOW_INPUT_FOCUS")] 
			InputFocus,
			[CCode (cname = "SDL_WINDOW_MOUSE_FOCUS")] 
			MouseFocus,
			[CCode (cname = "SDL_WINDOW_FULLSCREEN_DESKTOP")] 
			FullscreenDesktop,
			[CCode (cname = "SDL_WINDOW_FOREIGN")] 
			Foreign,
			[CCode (cname = "SDL_WINDOW_ALLOW_HIGH_DPI")] 
			AllowHighDPI,
			[CCode (cname = "SDL_WINDOW_MOUSE_CAPTURE")] 
			MouseCapture
		}

		[SimpleType, CCode (cname = "SDL_WindowEvent", cheader_filename = "SDL2/SDL_events.h")]
		public struct Event : CommonEvent
		{
			[CCode (cname = "windowID")]
			public uint32 WindowID;
			[CCode (cname = "event")]
			public EventId EventID;
			[CCode (cname = "data1")]
			public int32 Data1;
			[CCode (cname = "data2")]
			public int32 Data2;
		}

		[CCode (cname = " SDL_SYSWM_TYPE", cheader_filename = "SDL2/SDL_syswm.h")]
		public enum SysWMType 
		{
			[CCode (cname = "SDL_SYSWM_UNKNOWN")] 
            Unknown,
			[CCode (cname = "SDL_SYSWM_WINDOWS")] 
            Windows,
			[CCode (cname = "SDL_SYSWM_X11")] 
			X11, 
			[CCode (cname = "SDL_SYSWM_DIRECTFB")] 
            Directfb,
			[CCode (cname = "SDL_SYSWM_COCOA")] 
            Cocoa,
			[CCode (cname = "SDL_SYSWM_UIKIT")] 
            UiKit,
			[CCode (cname = "SDL_SYSWM_WAYLAND")] 
            Wayland,
			[CCode (cname = "SDL_SYSWM_MIR")] 
            Mir,
			[CCode (cname = "SDL_SYSWM_WINRT")] 
            WinRt,
			[CCode (cname = "SDL_SYSWM_ANDROID")] 
            Android
		}
		
		[CCode (cname = "SDL_SysWMinfo", cheader_filename = "SDL2/SDL_syswm.h")]
		public struct SDL_SysWMinfo 
		{
			[CCode (cname = "version")]
			public Sdl.Version Version;
			[CCode (cname = "subsystem")]
			public SysWMType Subsystem;
			[CCode (cname = "window")]
			public IntPtr Window;
		}

		[CCode (cname = "SDL_CreateWindow")]
		private static IntPtr SDL_CreateWindow (string title, int x, int y, int w, int h, uint32 flags);

		public static IntPtr Create (string title, int x, int y, int w, int h, uint32 flags) 
		{
			return GetErrorPtr ("SDL_CreateWindow", SDL_CreateWindow (title, x, y, w, h, flags));
		}

		[CCode (cname = "SDL_DestroyWindow")]
        public static void Destroy (IntPtr window);
		
		[CCode (cname = "SDL_GetWindowDisplayIndex")]
        private static int SDL_GetWindowDisplayIndex (IntPtr window);
		
        public static int GetDisplayIndex (IntPtr window)
        {
            return GetErrorInt (SDL_GetWindowDisplayIndex (window));
        }

		[CCode (cname = "SDL_GetWindowFlags")]
		public static uint32 GetWindowFlags (IntPtr window);
	
		[CCode (cname = "SDL_SetWindowIcon")]
		public static void SetIcon (IntPtr window, IntPtr icon);

		[CCode (cname = "SDL_GetWindowPosition")]
		public static void GetPosition (IntPtr window, out int x, out int y);
		
		[CCode (cname = "SDL_GetWindowSize")]
		public static void GetSize (IntPtr window, out int w, out int h);
		
		[CCode (cname = "SDL_SetWindowBordered")]
		public static void SetBordered (IntPtr window, bool int);

		[CCode (cname = "SDL_SetWindowFullscreen")]
		private static int SDL_SetWindowFullscreen (IntPtr window, int flags);

        public static void SetFullscreen (IntPtr window, int flags)
        {
            GetErrorInt (SDL_SetWindowFullscreen (window, flags));
        }

		[CCode (cname = "SDL_SetWindowPosition")]
		public static void SetPosition (IntPtr window, int x, int y);
	
		[CCode (cname = "SDL_SetWindowResizable")]
		public static void SetResizable (IntPtr window, bool resizable);
	
		[CCode (cname = "SDL_SetWindowSize")]
		public static void SetSize (IntPtr window, int w, int h);

		[CCode (cname = "SDL_SetWindowTitle")]
		public static void SetTitle (IntPtr window, string title);

		[CCode (cname = "SDL_ShowWindow")]
		public static void Show (IntPtr window);

		[CCode (cname = "SDL_GetWindowWMInfo", cheader_filename = "SDL2/SDL_syswm.h")]
		public bool GetWindowWMInfo (IntPtr window, ref SDL_SysWMinfo sysWMinfo);

        [CCode (cname = "SDL_GetWindowBordersSize")]
        public static int GetBorderSize (IntPtr window, out int top, out int left, out int right, out int bottom);
		
	}

	public class Display 
	{
		[CCode (cname = "SDL_DisplayMode", cheader_filename = "SDL2/SDL_video.h")]
		public struct Mode 
		{
			[CCode (cname = "format")]
			public uint Format;
			[CCode (cname = "w")]
			public int Width;
			[CCode (cname = "h")]
			public int Height;
			[CCode (cname = "refresh_rate")]
			public int RefreshRate;
			[CCode (cname = "driverdata")]
			public IntPtr DriverData;
		}
	
		[CCode (cname = "SDL_GetDisplayBounds")]
		private static int SDL_GetDisplayBounds (int displayIndex, out Rect rect);

        public static void GetBounds (int displayIndex, out Rect rect)
        {
            GetErrorInt (SDL_GetDisplayBounds (displayIndex, out rect));
		}
		
		[CCode (cname = "SDL_GetCurrentDisplayMode")]
		private static int SDL_GetCurrentDisplayMode (int displayIndex, out Mode mode);

		public static void GetCurrentDisplayMode (int displayIndex, out Mode mode)
        {
            GetErrorInt (SDL_GetCurrentDisplayMode (displayIndex, out mode));
        }

		[CCode (cname = "SDL_GetDisplayMode")]
		private static int SDL_GetDisplayMode (int displayIndex, int modeIndex, out Mode mode);

		public static void GetDisplayMode (int displayIndex, int modeIndex, out Mode mode)
        {
            GetErrorInt (SDL_GetDisplayMode (displayIndex, modeIndex, out mode));
        }

		[CCode (cname = "SDL_GetClosestDisplayMode")]
		private static int SDL_GetClosestDisplayMode (int displayIndex, int modeIndex, out Mode mode);

        public static void GetClosestDisplayMode (int displayIndex, int modeIndex, out Mode mode)
        {
            GetErrorInt (SDL_GetDisplayMode (displayIndex, modeIndex, out mode));
        }

		[CCode (cname = "SDL_GetDisplayName")]
		public static unowned string? GetDisplayName (int index);

		[CCode (cname = "SDL_GetNumDisplayModes")]
		private static int SDL_GetNumDisplayModes (int displayIndex);

		public static int GetNumDisplayModes (int displayIndex)
        {
            return GetErrorInt (SDL_GetNumDisplayModes (displayIndex));
		}

		[CCode (cname = "SDL_GetNumVideoDisplays")]
		private static int SDL_GetNumVideoDisplays ();
		
        public static int GetNumVideoDisplays ()
        {
            return GetErrorInt (SDL_GetNumVideoDisplays ());
        }
	
		[CCode (cname = "SDL_GetWindowDisplayIndex")]
		private static int SDL_GetWindowDisplayIndex (IntPtr window);
	
        public static int GetWindowDisplayIndex (IntPtr window)
        {
            return GetErrorInt (SDL_GetWindowDisplayIndex (window));
        }
	}

	[CCode (cname = "SDL_Renderer", cheader_filename = "SDL2/SDL_render.h")]
	public class Renderer 
	{
		[CCode (cname = "SDL_CreateRenderer")]
		public static IntPtr Create (IntPtr window, int index, uint32 flags);
		[Flags, CCode (cname = "SDL_RendererFlags", cheader_filename = "SDL2/SDL_render.h")]
		public enum Flags 
		{
			[CCode (cname = "SDL_RENDERER_SOFTWARE")] 
			Software, 
			[CCode (cname = "SDL_RENDERER_ACCELERATED")] 
			Accelerated,
			[CCode (cname = "SDL_RENDERER_PRESENTVSYNC")] 
			PresentVsync, 
			[CCode (cname = "SDL_RENDERER_TARGETTEXTURE")] 
			TargetTexture
		}


		[CCode (cname = "SDL_CreateTextureFromSurface")]
		public static IntPtr TextureFromSurface (IntPtr renderer, IntPtr surface);

		[CCode (cname = "SDL_RenderCopy")]
		public static int Copy (IntPtr renderer, IntPtr texture, Rect? srcrect=null, Rect? dstrect=null);

		[CCode (cname = "SDL_RenderCopyEx")]
		public static int CopyEx (IntPtr renderer, IntPtr texture, Rect? srcrect, Rect? dstrect, double angle, Point? center, int flip);

		[CCode (cname = "SDL_RenderPresent")]
		public static void Present (IntPtr renderer);

	}
	
	public class GL 
	{
		[CCode (cname = "SDL_GLattr", cheader_filename = "SDL2/SDL_video.h")]
		public enum Attribute
		{
			[CCode (cname = "SDL_GL_RED_SIZE")]
			RedSize, 
			[CCode (cname = "SDL_GL_GREEN_SIZE")] 
            GreenSize,
			[CCode (cname = "SDL_GL_BLUE_SIZE")] 
            BlueSize,
			[CCode (cname = "SDL_GL_ALPHA_SIZE")]
            AlphaSize,
			[CCode (cname = "SDL_GL_BUFFER_SIZE")] 
            BufferSize,
			[CCode (cname = "SDL_GL_DOUBLEBUFFER")] 
            DoubleBuffer,
			[CCode (cname = "SDL_GL_DEPTH_SIZE")] 
            DepthSize,
			[CCode (cname = "SDL_GL_STENCIL_SIZE")]
            StencilSize,
			[CCode (cname = "SDL_GL_ACCUM_RED_SIZE")] 
            AccumRedSize,
			[CCode (cname = "SDL_GL_ACCUM_GREEN_SIZE")] 
            AccumGreenSize,
			[CCode (cname = "SDL_GL_ACCUM_BLUE_SIZE")]
            AccumBlueSize,
			[CCode (cname = "SDL_GL_ACCUM_ALPHA_SIZE")] 
            AccumAlphaSize,
			[CCode (cname = "SDL_GL_STEREO")] 
            Stereo,
			[CCode (cname = "SDL_GL_MULTISAMPLEBUFFERS")]
            MultiSampleBuffers,
			[CCode (cname = "SDL_GL_MULTISAMPLESAMPLES")] 
            MultiSampleSamples,
			[CCode (cname = "SDL_GL_ACCELERATED_VISUAL")]
            AcceleratedVisual,
			[CCode (cname = "SDL_GL_RETAINED_BACKING")]
            RetainedBacking,
			[CCode (cname = "SDL_GL_CONTEXT_MAJOR_VERSION")] 
            ContextMajorVersion,
			[CCode (cname = "SDL_GL_CONTEXT_MINOR_VERSION")]
            ContextMinorVersion,
			[CCode (cname = "SDL_GL_CONTEXT_EGL")]
            ContextEgl,
			[CCode (cname = "SDL_GL_CONTEXT_FLAGS")] 
            ContextFlags,
			[CCode (cname = "SDL_GL_CONTEXT_PROFILE_MASK")]
            ContextProfileMask,
			[CCode (cname = "SDL_GL_SHARE_WITH_CURRENT_CONTEXT")] 
            ShareWithCurrentContext,
			[CCode (cname = "SDL_GL_FRAMEBUFFER_SRGB_CAPABLE")]
            FramebufferSRGBCapable,
			[CCode (cname = "SDL_GL_CONTEXT_RELEASE_BEHAVIOR")]
            ContextReleaseBehaviour
		}

		[CCode (cname = "SDL_GL_CreateContext")]
		private static IntPtr SDL_GL_CreateContext (IntPtr window);

        public static IntPtr CreateContext (IntPtr window)
        {
            return GetErrorPtr ("SDL_GL_CreateContext", SDL_GL_CreateContext (window));
        }

		[CCode (cname = "SDL_GL_DeleteContext")]
        public static void DeleteContext (IntPtr context);
		
		[CCode (cname = "SDL_GL_GetCurrentContext")]
		private static IntPtr SDL_GL_GetCurrentContext ();

		public static IntPtr GetCurrentContext ()
        {
            return GetErrorPtr ("SDL_GL_GetCurrentContext", SDL_GL_GetCurrentContext ());
		}

		[CCode (cname = "SDL_GL_GetSwapInterval")]
		public static int GetSwapInterval ();
	
		[CCode (cname = "SDL_GL_MakeCurrent")]
		public static int MakeCurrent (IntPtr window, IntPtr context);

		[CCode (cname = "SDL_GL_SetAttribute")]
		private static int SDL_GL_SetAttribute (Attribute attr, int val);

        public static int SetAttribute (Attribute attr, int value)
        {
            return GetErrorInt (SDL_GL_SetAttribute (attr, value));
        }
		
		[CCode (cname = "SDL_GL_SetSwapInterval")]
		public static int SetSwapInterval (int interval);

		[CCode (cname = "SDL_GL_SwapWindow")]
		public static void SwapWindow (IntPtr window);

	}

	public class Mouse
	{
		[CCode (cname = "Uint8")]
		public enum Button 
		{
			[CCode (cname = "SDL_BUTTON_LEFT")]
			Left,
			[CCode (cname = "SDL_BUTTON_MIDDLE")]
			Middle,
			[CCode (cname = "SDL_BUTTON_RIGHT")]
			Right,
			[CCode (cname = "SDL_BUTTON_X1MASK")]
			X1Mask,
			[CCode (cname = "SDL_BUTTON_X2MASK")]
			X2Mask
		}

		[CCode (cname = "SDL_SystemCursor", cheader_filename = "SDL2/SDL_mouse.h")]
		public enum SystemCursor 
		{
			[CCode (cname = "SDL_SYSTEM_CURSOR_ARROW")]
            Arrow,
			[CCode (cname = "SDL_SYSTEM_CURSOR_IBEAM")] 
            IBeam,
			[CCode (cname = "SDL_SYSTEM_CURSOR_WAIT")] 
            Wait,
			[CCode (cname = "SDL_SYSTEM_CURSOR_CROSSHAIR")] 
            Crosshair,
			[CCode (cname = "SDL_SYSTEM_CURSOR_WAITARROW")] 
            WaitArrow,
			[CCode (cname = "SDL_SYSTEM_CURSOR_SIZENWSE")]
            SizeNWSE,
			[CCode (cname = "SDL_SYSTEM_CURSOR_SIZENESW")] 
            SizeNESW,
			[CCode (cname = "SDL_SYSTEM_CURSOR_SIZEWE")] 
            SizeWE,
			[CCode (cname = "SDL_SYSTEM_CURSOR_SIZENS")] 
            SizeNS,
			[CCode (cname = "SDL_SYSTEM_CURSOR_SIZEALL")] 
            SizeAll,
			[CCode (cname = "SDL_SYSTEM_CURSOR_NO")] 
            No,
			[CCode (cname = "SDL_SYSTEM_CURSOR_HAND")]
            Hand
		}

		[SimpleType, CCode (cname = "SDL_MouseMotionEvent", cheader_filename = "SDL2/SDL_events.h")]
		public struct MotionEvent : CommonEvent
		{
			[CCode (cname = "windowID")]
			public uint32 WindowID;
			[CCode (cname = "which")]
			public uint32 Which;
			[CCode (cname = "button")]
			public uint8 Button;
			[CCode (cname = "state")]
			public uint8 State;
			[CCode (cname = "clicks")]
			public uint8 Clicks;
			[CCode (cname = "padding1")]
			public uint8 Padding1;
			[CCode (cname = "x")]
			public int32 X;
			[CCode (cname = "y")]
			public int32 Y;
		}
		
		[SimpleType, CCode (cname = "SDL_MouseWheelEvent", cheader_filename = "SDL2/SDL_events.h")]
		public struct WheelEvent : CommonEvent
		{
			[CCode (cname = "windowID")]
			public uint32 WindowID;
			[CCode (cname = "which")]
			public uint32 Which;
			[CCode (cname = "x")]
			public int32 X;
			[CCode (cname = "y")]
			public int32 Y;
			[CCode (cname = "direction")]
			public uint32 Direction;
		}

		[CCode (cname = "SDL_CreateColorCursor")]
		private static IntPtr SDL_CreateColorCursor (IntPtr surface, int x, int y);

        public static IntPtr CreateColorCursor (IntPtr surface, int x, int y)
        {
            return GetErrorPtr ("SDL_CreateColorCursor", SDL_CreateColorCursor (surface, x, y));
        }

		[CCode (cname = "SDL_CreateSystemCursor")]
		private static IntPtr SDL_CreateSystemCursor (SystemCursor id);
        public static IntPtr CreateSystemCursor (SystemCursor id)
        {
            return GetErrorPtr ("SDL_CreateSystemCursor", SDL_CreateSystemCursor (id));
        }

		[CCode (cname = "SDL_FreeCursor")]
        public static void FreeCursor (IntPtr cursor);
		
		[CCode (cname = "SDL_GetMouseState")]
		public static Button GetState (out int x, out int y);

		[CCode (cname = "SDL_GetGlobalMouseState")]
		public static Button GetGlobalState (out int x, out int y);

		[CCode (cname = "SDL_SetCursor")]
        public static void SetCursor (IntPtr cursor);

		[CCode (cname = "SDL_ShowCursor")]
        public static int ShowCursor (int toggle);

		[CCode (cname = "SDL_WarpMouseInWindow")]
		public static void WarpInWindow (IntPtr window, int x, int y);
	
	}

	public class Keyboard
	{
		[SimpleType, CCode (cname = "SDL_Keysym", cheader_filename = "SDL2/SDL_keyboard.h")]
		public struct Keysym 
		{
			[CCode (cname = "scancode")]
			public int Scancode;
			[CCode (cname = "sym")]
			public int Sym;
			[CCode (cname = "mod")]
			public Keymod Mod;
			[CCode (cname = "unicode")]
			public uint32 Unicode;
		}

		[CCode (cname = "SDL_Keymod", cheader_filename = "SDL2/SDL_keyboard.h")]
		public enum Keymod 
		{
			[CCode (cname = "KMOD_NONE")]
            None,
			[CCode (cname = "KMOD_LSHIFT")] 
			LeftShift,
			[CCode (cname = "KMOD_RSHIFT")]
			RightShift,
			[CCode (cname = "KMOD_LCTRL")]
			LeftCtrl,
			[CCode (cname = "KMOD_RCTRL")]
			RightCtrl,
			[CCode (cname = "KMOD_LALT")]
			LeftAlt,
			[CCode (cname = "KMOD_RALT")]
			RightAlt,
			[CCode (cname = "KMOD_LGUI")]
			LeftGui,
			[CCode (cname = "KMOD_RGUI")]
			RightGui,
			[CCode (cname = "KMOD_NUM")]
			NumLock,
			[CCode (cname = "KMOD_CAPS")]
			CapsLock,
			[CCode (cname = "KMOD_MODE")]
			AltGr,
			[CCode (cname = "KMOD_RESERVED")]
			Reserved,
			[CCode (cname = "KMOD_CTRL")]
			Ctrl,
			[CCode (cname = "KMOD_SHIFT")]
			Shift,
			[CCode (cname = "KMOD_ALT")]
			Alt,
			[CCode (cname = "KMOD_GUI")]
			Gui
		}

		[SimpleType, CCode (cname = "SDL_KeyboardEvent", cheader_filename = "SDL2/SDL_events.h")]
		public struct Event : CommonEvent
		{
			[CCode (cname = "windowID")]
			public uint32 WindowID;
			[CCode (cname = "state")]
			public uint8 State;
			[CCode (cname = "repeat")]
			public uint8 Repeat;
			[CCode (cname = "padding2")]
			public uint8 Padding2;
			[CCode (cname = "padding3")]
			public uint8 Padding3;
			[CCode (cname = "keysym")]
            public Keysym Keysym;
		}

		[SimpleType, CCode (cname = "SDL_TextEditingEvent", cheader_filename = "SDL2/SDL_events.h")]
		public struct TextEditingEvent : CommonEvent
		{
			[CCode (cname = "WindowID")]
			public uint32 windowID;
			[CCode (cname = "text", array_null_terminated = true)]
            public char Text [32];
			[CCode (cname = "start")]
            public int Start;
			[CCode (cname = "length")]
            public int Length;

		}
		
		[SimpleType, CCode (cname = "SDL_TextInputEvent", cheader_filename = "SDL2/SDL_events.h")]
		public struct TextInputEvent : CommonEvent
		{
			[CCode (cname = "WindowID")]
			public uint32 windowID;
			[CCode (cname = "text", array_null_terminated = true )]
            public char Text [32];

		}

		[CCode (cname = "SDL_GetModState")]
        public static Keymod GetModState ();
	
	}

    public class Joystick
    {
		[CCode (cname = "Uint8", cheader_filename = "SDL2/SDL_events.h")]
		public enum Hat 
		{
			[CCode (cname = "SDL_HAT_CENTERED")]
			Centered,
			[CCode (cname = "SDL_HAT_UP")]
			Up,
			[CCode (cname = "SDL_HAT_RIGHT")]
			Right,
			[CCode (cname = "SDL_HAT_DOWN")]
			Down,
			[CCode (cname = "SDL_HAT_LEFT")]
			Left
		}

		[SimpleType, CCode (cname = "SDL_JoyDeviceEvent", cheader_filename = "SDL2/SDL_events.h")]
		public struct DeviceEvent : CommonEvent
		{
			[CCode (cname = "windowID")]
			public uint32 WindowID;
			[CCode (cname = "which")]
			public int Which;
		}
				
		[CCode (cname = "SDL_JoystickClose")]
        public static void Close (IntPtr joystick);
		
		[CCode (cname = "SDL_JoystickFromInstanceID")]
		private static IntPtr SDL_JoystickFromInstanceID (int joyid);

        public static IntPtr FromInstanceID (int joyid)
        {
            return GetErrorPtr ("SDL_JoystickFromInstanceID", SDL_JoystickFromInstanceID (joyid));
        }

		[CCode (cname = "SDL_JoystickGetAxis")]
		public static int16 GetAxis (IntPtr joystick, int axis);

		[CCode (cname = "SDL_JoystickGetButton")]
		public static uint8 GetButton (IntPtr joystick, int button);

		[CCode (cname = "SDL_JoystickGetGUID")]
		public static Guid GetGUID (IntPtr joystick);

		[CCode (cname = "SDL_JoystickGetHat")]
		public static Hat GetHat (IntPtr joystick, int hat);

		[CCode (cname = "SDL_JoystickInstanceID")]
		public static int InstanceID (IntPtr joystick);

		[CCode (cname = "SDL_JoystickOpen")]
		private static IntPtr SDL_JoystickOpen (int device_index);

        public static IntPtr Open (int deviceIndex)
        {
            return GetErrorPtr ("SDL_JoystickOpen", SDL_JoystickOpen (deviceIndex));
        }

		[CCode (cname = "SDL_JoystickNumAxes")]
		private static int SDL_JoystickNumAxes (IntPtr joystick);

        public static int NumAxes (IntPtr joystick)
        {
            return GetErrorInt (SDL_JoystickNumAxes (joystick));
        }
		
		[CCode (cname = "SDL_JoystickNumButtons")]
		private static int SDL_JoystickNumButtons (IntPtr joystick);

        public static int NumButtons (IntPtr joystick)
        {
            return GetErrorInt (SDL_JoystickNumButtons (joystick));
        }

		[CCode (cname = "SDL_JoystickNumHats")]
		private static int SDL_JoystickNumHats (IntPtr joystick);

        public static int NumHats (IntPtr joystick)
        {
            return GetErrorInt (SDL_JoystickNumHats (joystick));
        }

		[CCode (cname = "SDL_NumJoysticks")]
		private static int SDL_NumJoysticks ();

        public static int NumJoysticks ()
        {
            return GetErrorInt (SDL_NumJoysticks ());
        }
		
	
	}

    public class GameController
	{
		[CCode (cheader_filename = "SDL2/SDL_gamecontroller.h")]
		public enum Axis 
		{
			[CCode (cname = "SDL_CONTROLLER_AXIS_INVALID")] 
            Invalid,
			[CCode (cname = "SDL_CONTROLLER_AXIS_LEFTX")]
            LeftX,
			[CCode (cname = "SDL_CONTROLLER_AXIS_LEFTY")]
            LeftY,
			[CCode (cname = "SDL_CONTROLLER_AXIS_RIGHTX")]
            RightX,
			[CCode (cname = "SDL_CONTROLLER_AXIS_RIGHTY")]
            RightY,
			[CCode (cname = "SDL_CONTROLLER_AXIS_TRIGGERLEFT")]
            TriggerLeft,
			[CCode (cname = "SDL_CONTROLLER_AXIS_TRIGGERRIGHT")]
            TriggerRight,
			[CCode (cname = "SDL_CONTROLLER_AXIS_MAX")]
            Max
		}

		[CCode (cheader_filename = "SDL2/SDL_gamecontroller.h")]
		public enum Button 
		{
			[CCode (cname = "SDL_CONTROLLER_BUTTON_INVALID")]
            Invalid,
			[CCode (cname = "SDL_CONTROLLER_BUTTON_A")]
            A,
			[CCode (cname = "SDL_CONTROLLER_BUTTON_B")]
            B,
			[CCode (cname = "SDL_CONTROLLER_BUTTON_X")]
            X,
			[CCode (cname = "SDL_CONTROLLER_BUTTON_Y")]
            Y,
			[CCode (cname = "SDL_CONTROLLER_BUTTON_BACK")]
            Back,
			[CCode (cname = "SDL_CONTROLLER_BUTTON_GUIDE")]
            Guide,
			[CCode (cname = "SDL_CONTROLLER_BUTTON_START")]
            Start,
			[CCode (cname = "SDL_CONTROLLER_BUTTON_LEFTSTICK")]
            LeftStick,
			[CCode (cname = "SDL_CONTROLLER_BUTTON_RIGHTSTICK")]
            RightStick,
			[CCode (cname = "SDL_CONTROLLER_BUTTON_LEFTSHOULDER")]
            LeftShoulder,
			[CCode (cname = "SDL_CONTROLLER_BUTTON_RIGHTSHOULDER")]
            RightShoulder,
			[CCode (cname = "SDL_CONTROLLER_BUTTON_DPAD_UP")]
            DpadUp,
			[CCode (cname = "SDL_CONTROLLER_BUTTON_DPAD_DOWN")]
            DpadDown,
			[CCode (cname = "SDL_CONTROLLER_BUTTON_DPAD_LEFT")]
            DpadLeft,
			[CCode (cname = "SDL_CONTROLLER_BUTTON_DPAD_RIGHT")]
            DpadRight,
			[CCode (cname = "SDL_CONTROLLER_BUTTON_MAX")]
            Max
		}

		[SimpleType, CCode (cname = "SDL_ControllerDeviceEvent", cheader_filename = "SDL2/SDL_events.h")]
		public struct DeviceEvent : CommonEvent
		{
			[CCode (cname = "which")]
			public int Which;
		}

		[CCode (cname = "SDL_GameControllerAddMapping")]
		public static int AddMapping (string mappingString);

		[CCode (cname = "SDL_GameControllerAddMappingsFromRW")]
		public static int AddMappingFromRw (IntPtr rw, int freerw = 1);

		[CCode (cname = "SDL_GameControllerClose")]
		public static void Close (IntPtr gamecontroller);

		[CCode (cname = "SDL_JoystickFromInstanceID")]
		private static IntPtr SDL_GameControllerFromInstanceID (int joyid);
	
        public static IntPtr FromInstanceID (int joyid)
        {
            return GetErrorPtr ("SDL_JoystickFromInstanceID", SDL_GameControllerFromInstanceID (joyid));
        }

		[CCode (cname = "SDL_GameControllerGetAxis")]
		public static int16 GetAxis (IntPtr gamecontroller, Axis axis);
	
		[CCode (cname = "SDL_GameControllerGetButton")]
		public static uint8 GetButton (IntPtr gamecontroller, Button button);

		[CCode (cname = "SDL_GameControllerGetJoystick")]
		private static IntPtr SDL_GameControllerGetJoystick (IntPtr gamecontroller);

        public static IntPtr GetJoystick (IntPtr gamecontroller)
        {
            return GetErrorPtr ("SDL_GameControllerGetJoystick", SDL_GameControllerGetJoystick (gamecontroller));
        }

		[CCode (cname = "SDL_IsGameController")]
		public static uint8 IsGameController (int joystickIndex);

		[CCode (cname = "SDL_GameControllerMapping")]
		public static string? GetMapping (IntPtr gamecontroller);


		[CCode (cname = "SDL_GameControllerOpen")]
		private static IntPtr SDL_GameControllerOpen (int joystickIndex);
	
        public static IntPtr Open (int joystickIndex)
        {
            return GetErrorPtr ("SDL_GameControllerOpen", SDL_GameControllerOpen (joystickIndex));
        }

		[CCode (cname = "SDL_GameControllerName")]
		public static string? GetName (IntPtr gamecontroller);

	}

    public class Haptic
	{

		[CCode (cname = "SDL_HAPTIC_INFINITY")]
		public const uint Infinity;

		public enum EffectId 
		{
			[CCode (cname = "SDL_HAPTIC_LEFTRIGHT")]
			LeftRight
		}


		[CCode (cname = "SDL_HapticLeftRight", cheader_filename = "SDL2/SDL_haptic.h")]
		public struct Effect 
		{
			[CCode (cname = "type")]
			public uint32 Type;
			[CCode (cname = "length")]
			public uint32 Length;
			[CCode (cname = "large_magnitude")]
			public uint16 LargeMagnitude;
			[CCode (cname = "small_magnitude")]
			public uint16 SmallMagnitude;
		}

		[CCode (cname = "SDL_HapticClose")]
		public static void Close (IntPtr haptic);

		[CCode (cname = "SDL_HapticEffectSupported")]
		public static int EffectSupported (IntPtr haptic, ref Effect effect);

		[CCode (cname = "SDL_JoystickIsHaptic", cheader_filename = "SDL2/SDL_haptic.h")]
		public static int IsHaptic (IntPtr joystick);
	
		[CCode (cname = "SDL_HapticNewEffect")]
		private static int SDL_HapticNewEffect (IntPtr haptic, ref Effect effect);
		
        public static void NewEffect (IntPtr haptic, ref Effect effect)
        {
            GetErrorInt (SDL_HapticNewEffect (haptic, ref effect));
		}
		
		[CCode (cname = "SDL_HapticOpen")]
		public static IntPtr Open (int device_index);
		
		[CCode (cname = "SDL_HapticOpenfromJoystick")]
		private static IntPtr SDL_HapticOpenfromJoystick (IntPtr joystick);
		
        public static IntPtr OpenFromJoystick (IntPtr joystick)
        {
            return GetErrorPtr ("SDL_HapticOpenfromJoystick", SDL_HapticOpenfromJoystick (joystick));
		}
		
		[CCode (cname = "SDL_HapticRumbleInit")]
		private static int SDL_HapticRumbleInit (IntPtr haptic);
		
        public static void RumbleInit (IntPtr haptic)
        {
            GetErrorInt (SDL_HapticRumbleInit (haptic));
		}
		
		[CCode (cname = "SDL_HapticRumblePlay")]
		private static int SDL_HapticRumblePlay (IntPtr haptic, float strength, uint length);

        public static void RumblePlay (IntPtr haptic, float strength, uint length)
        {
            GetErrorInt (SDL_HapticRumblePlay (haptic, strength, length));
		}
		
		[CCode (cname = "SDL_HapticRumbleSupported")]
		private static int SDL_HapticRumbleSupported (IntPtr haptic);

        public static int RumbleSupported (IntPtr haptic)
        {
            return GetErrorInt (SDL_HapticRumbleSupported (haptic));
        }
		
		[CCode (cname = "SDL_HapticRunEffect")]
		private static int SDL_HapticRunEffect (IntPtr haptic, int effect, uint iterations);
		
        public static void RunEffect (IntPtr haptic, int effect, uint iterations)
        {
            GetErrorInt (SDL_HapticRunEffect (haptic, effect, iterations));
		}
		
		[CCode (cname = "SDL_HapticStopAll")]
		private static int SDL_HapticStopAll (IntPtr haptic);

        public static void StopAll (IntPtr haptic)
        {
            GetErrorInt (SDL_HapticStopAll (haptic));
		}
		
		[CCode (cname = "SDL_HapticUpdateEffect")]
		private static int SDL_HapticUpdateEffect (IntPtr haptic, int effect, ref Effect data);
		
        public static void UpdateEffect (IntPtr haptic, int effect, ref Effect data)
        {
            GetErrorInt (SDL_HapticUpdateEffect (haptic, effect, ref data));
        }

	}

	[CCode (cheader_filename = "SDL2/SDL_image.h")]
	public class Image
	{
		[Flags, CCode (cname = "IMG_InitFlags")]
		public enum InitFlags {
			[CCode (cname = "IMG_INIT_JPG")]
			Jpg,
			[CCode (cname = "IMG_INIT_PNG")]
			Png,
			[CCode (cname = "IMG_INIT_TIF")]
			Tif,
			[CCode (cname = "IMG_INIT_WEBP")]
			Webp
		}
		[CCode (cname = "IMG_Init")]
		public static int Init (int flags);
	
		[CCode (cname = "IMG_Quit")]
		public static void Quit ();

		[CCode (cname = "IMG_Load")]
		public static IntPtr Load (string file);
	
		[CCode (cname = "IMG_Load_RW")]
		public static IntPtr LoadRw (IntPtr src, bool freesrc = false);
	
		[CCode (cname = "IMG_LoadTyped_RW")]
		public static IntPtr LoadRwTyped (IntPtr src, bool freesrc, string type);
	
		[CCode (cname = "IMG_LoadTexture")]
		public static IntPtr LoadTexture (IntPtr renderer, string file);
	
		[CCode (cname = "IMG_LoadTexture_RW")]
		public static IntPtr LoadTextureRw (IntPtr renderer, IntPtr src, bool freesrc = false);
	
		[CCode (cname = "IMG_LoadTextureTyped_RW")]
		public static IntPtr LoadTextureRwTyped (IntPtr renderer, IntPtr src, bool freesrc, string type);
	
		[CCode (cname = "IMG_InvertAlpha")]
		public static int invertAlpha (int on);
	
		[CCode (cname = "IMG_LoadCUR_RW")]
		public static IntPtr LoadCUR (IntPtr src);
	
		[CCode (cname = "IMG_LoadICO_RW")]
		public static IntPtr LoadICO (IntPtr src);
	
		[CCode (cname = "IMG_LoadBMP_RW")]
		public static IntPtr LoadBMP (IntPtr src);
	
		[CCode (cname = "IMG_LoadPNM_RW")]
		public static IntPtr LoadPNM (IntPtr src);
	
		[CCode (cname = "IMG_LoadXPM_RW")]
		public static IntPtr LoadXPM (IntPtr src);
	
		[CCode (cname = "IMG_LoadXCF_RW")]
		public static IntPtr LoadXCF (IntPtr src);
	
		[CCode (cname = "IMG_LoadPCX_RW")]
		public static IntPtr LoadPCX (IntPtr src);
	
		[CCode (cname = "IMG_LoadGIF_RW")]
		public static IntPtr LoadGIF (IntPtr src);
	
		[CCode (cname = "IMG_LoadJPG_RW")]
		public static IntPtr LoadJPG (IntPtr src);
	
		[CCode (cname = "IMG_LoadTIF_RW")]
		public static IntPtr LoadTIF (IntPtr src);
	
		[CCode (cname = "IMG_LoadPNG_RW")]
		public static IntPtr LoadPNG (IntPtr src);
	
		[CCode (cname = "IMG_LoadTGA_RW")]
		public static IntPtr LoadTGA (IntPtr src);
	
		[CCode (cname = "IMG_LoadLBM_RW")]
		public static IntPtr LoadLBM (IntPtr src);
	
		[CCode (cname = "IMG_LoadXV_RW")]
		public static IntPtr LoadXV (IntPtr src);
	
		[CCode (cname = "IMG_LoadWEBP_RW")]
		public static IntPtr LoadWEBP (IntPtr src);
	
		[CCode (cname = "IMG_ReadXPMFromArray")]
		public static IntPtr readXPM (string[] xpmdata);
	
		//!Info
	
		[CCode (cname = "IMG_isCUR")]
		public static bool IsCUR (IntPtr src);
	
		[CCode (cname = "IMG_isICO")]
		public static bool IsICO (IntPtr src);
	
		[CCode (cname = "IMG_isBMP")]
		public static bool IsBMP (IntPtr src);
	
		[CCode (cname = "IMG_isPNM")]
		public static bool IsPNM (IntPtr src);
	
		[CCode (cname = "IMG_isXPM")]
		public static bool IsXPM (IntPtr src);
	
		[CCode (cname = "IMG_isXCF")]
		public static bool IsXCF (IntPtr src);
	
		[CCode (cname = "IMG_isPCX")]
		public static bool IsPCX (IntPtr src);
	
		[CCode (cname = "IMG_isGIF")]
		public static bool IsGIF (IntPtr src);
	
		[CCode (cname = "IMG_isJPG")]
		public static bool IsJPG (IntPtr src);
	
		[CCode (cname = "IMG_isTIF")]
		public static bool IsTIF (IntPtr src);
	
		[CCode (cname = "IMG_isPNG")]
		public static bool IsPNG (IntPtr src);
	
		[CCode (cname = "IMG_isLBM")]
		public static bool IsLBM (IntPtr src);
	
		[CCode (cname = "IMG_isXV")]
		public static bool IsXV (IntPtr src);
	
		[CCode (cname = "IMG_isWEBP")]
		public static bool IsWEBP (IntPtr src);
			
	}
	
	[CCode (cheader_filename = "SDL2/SDL_ttf.h")]
	public class Ttf
	{
		[CCode (cname = "TTF_Init")]
		public static int Init ();

		[CCode (cname = "TTF_Quit")]
		public static void Quit ();

		[CCode (cname = "TTF_OpenFont")]
		public static IntPtr Open (string file, int ptsize);

		[CCode (cname = "TTF_OpenFontRW")]
		public static IntPtr OpenRw (IntPtr src, int freesrc = 0, int ptsize);

		
	}

	[CCode (cheader_filename = "SDL2/SDL_mixer.h")]
	public class Mixer
	{
		[CCode (cname = "Mix_OpenAudio")]
		public static int Init (int frequency, int format, int channels, int chunksize);
	
		[CCode (cname = "Mix_CloseAudio")]
		public static void Quit ();

		[CCode (cname = "Mix_LoadWAV_RW")]
		public static IntPtr OpenRw (IntPtr src, int freesrc = 0);

		[CCode (cname = "Mix_LoadWAV")]
		public static IntPtr Open (string file);

		[CCode (cname = "Mix_PlayChannel")]
		public static int Play (int channel, IntPtr chunk, int loops = 0);
		
	}

}			
