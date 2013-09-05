
    -- SDLSumo - Simple DirectMedia Layer 1.2.15 Luajit binding
    -- Copyright (C) 2013 Paul Furber

    -- This library is free software; you can redistribute it and/or
    -- modify it under the terms of the GNU Lesser General Public
    -- License as published by the Free Software Foundation; either
    -- version 2.1 of the License, or (at your option) any later version.

    -- This library is distributed in the hope that it will be useful,
    -- but WITHOUT ANY WARRANTY; without even the implied warranty of
    -- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    -- Lesser General Public License for more details.

    -- You should have received a copy of the GNU Lesser General Public
    -- License along with this library; if not, write to the Free Software
    -- Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

    -- Paul Furber
    -- paul.furber@gmail.com


local ffi = require("ffi")

-- table of all the SDL ffi modules
local sdlsumo = {}

local debug = false

local function debug_print(msg)
    if debug then
        print (msg)
    end    
end

-- error placeholder function for xpcall
local function load_err()
end

-- if SDL loads, add it to sdlsumo and include its definitions
local ok = xpcall(ffi.load, load_err, 'SDL')
if ok then
    local sdl = ffi.load("SDL")
    sdlsumo['sdl'] = sdl

    -- SDL 1.2.15 definitions
    ffi.cdef[[

// SDL_version.h

enum {
        SDL_MAJOR_VERSION	=1,
        SDL_MINOR_VERSION	=2,
        SDL_PATCHLEVEL		=15,
};

typedef struct SDL_version {
	uint8_t major;
	uint8_t minor;
	uint8_t patch;
} SDL_version;

// SDL.h
enum {
        SDL_INIT_TIMER		= 0x00000001,
        SDL_INIT_AUDIO		= 0x00000010,
        SDL_INIT_VIDEO		= 0x00000020,
        SDL_INIT_CDROM		= 0x00000100,
        SDL_INIT_JOYSTICK	= 0x00000200,
        SDL_INIT_NOPARACHUTE	= 0x00100000,
        SDL_INIT_EVENTTHREAD	= 0x01000000,
        SDL_INIT_EVERYTHING	= 0x0000FFFF,
};

int SDL_Init(uint32_t flags);
uint32_t SDL_WasInit(uint32_t flags);
void SDL_Quit(void);

// SDL_stdinc.h

typedef enum {
	SDL_FALSE = 0,
	SDL_TRUE  = 1,
} SDL_bool;

// SDL_rwops.h

typedef struct SDL_RWops {

	int (*seek)(struct SDL_RWops *context, int offset, int whence);
	int (*read)(struct SDL_RWops *context, void *ptr, int size, int maxnum);
	int (*write)(struct SDL_RWops *context, const void *ptr, int size, int num);
	int (*close)(struct SDL_RWops *context);

	uint32_t type;
	union {
	    struct {
		int autoclose;
	 	void *fp;         // was FILE *fp
	    } stdio;
	    struct {
		uint8_t *base;
	 	uint8_t *here;
		uint8_t *stop;
	    } mem;
	    struct {
		void *data1;
	    } unknown;
	} hidden;

} SDL_RWops;


SDL_RWops * SDL_RWFromFile(const char *file, const char *mode);
SDL_RWops * SDL_RWFromFP(void *fp, int autoclose);
SDL_RWops * SDL_RWFromMem(void *mem, int size);
SDL_RWops * SDL_RWFromConstMem(const void *mem, int size);
SDL_RWops * SDL_AllocRW(void);
void SDL_FreeRW(SDL_RWops *area);

enum {
        
        RW_SEEK_SET	= 0,	/**< Seek from the beginning of data */
        RW_SEEK_CUR	= 1,	/**< Seek relative to current read point */
        RW_SEEK_END	= 2,	/**< Seek relative to the end of data */        
};

/*
#define SDL_RWseek(ctx, offset, whence)	(ctx)->seek(ctx, offset, whence)
#define SDL_RWtell(ctx)			(ctx)->seek(ctx, 0, RW_SEEK_CUR)
#define SDL_RWread(ctx, ptr, size, n)	(ctx)->read(ctx, ptr, size, n)
#define SDL_RWwrite(ctx, ptr, size, n)	(ctx)->write(ctx, ptr, size, n)
#define SDL_RWclose(ctx)		(ctx)->close(ctx)
*/

uint16_t SDL_ReadLE16(SDL_RWops *src);
uint16_t SDL_ReadBE16(SDL_RWops *src);
uint32_t SDL_ReadLE32(SDL_RWops *src);
uint32_t SDL_ReadBE32(SDL_RWops *src);
uint64_t SDL_ReadLE64(SDL_RWops *src);
uint64_t SDL_ReadBE64(SDL_RWops *src);


int SDL_WriteLE16(SDL_RWops *dst, uint16_t value);
int SDL_WriteBE16(SDL_RWops *dst, uint16_t value);
int SDL_WriteLE32(SDL_RWops *dst, uint32_t value);
int SDL_WriteBE32(SDL_RWops *dst, uint32_t value);
int SDL_WriteLE64(SDL_RWops *dst, uint64_t value);
int SDL_WriteBE64(SDL_RWops *dst, uint64_t value);

// SDL_audio.h

typedef struct SDL_AudioSpec {
	int freq;	
	uint16_t format;	
	uint8_t  channels;
	uint8_t  silence;	
	uint16_t samples;	
	uint16_t padding;	
	uint32_t size;	
	void (*callback)(void *userdata, uint8_t *stream, int len);
	void  *userdata;
} SDL_AudioSpec;


// Warning - assumes little endian arch
enum {
        
        AUDIO_U8	= 0x0008,
        AUDIO_S8	= 0x8008,
        AUDIO_U16LSB	= 0x0010,
        AUDIO_S16LSB	= 0x8010,
        AUDIO_U16MSB	= 0x1010,
        AUDIO_S16MSB	= 0x9010,
        AUDIO_U16	= AUDIO_U16LSB,
        AUDIO_S16	= AUDIO_S16LSB,
        AUDIO_U16SYS	= AUDIO_U16LSB,
        AUDIO_S16SYS	= AUDIO_S16LSB,
};

typedef struct SDL_AudioCVT {
	int needed;			
	uint16_t src_format;		
	uint16_t dst_format;		
	double rate_incr;		
	uint8_t *buf;			
	int    len;			
	int    len_cvt;			
	int    len_mult;		
	double len_ratio; 	
	void (*filters[10])(struct SDL_AudioCVT *cvt, uint16_t format);
	int filter_index;	
} SDL_AudioCVT;


int SDL_AudioInit(const char *driver_name);
void SDL_AudioQuit(void);
char * SDL_AudioDriverName(char *namebuf, int maxlen);
int SDL_OpenAudio(SDL_AudioSpec *desired, SDL_AudioSpec *obtained);

typedef enum {
	SDL_AUDIO_STOPPED = 0,
	SDL_AUDIO_PLAYING,
	SDL_AUDIO_PAUSED
} SDL_audiostatus;

SDL_audiostatus SDL_GetAudioStatus(void);
void SDL_PauseAudio(int pause_on);
SDL_AudioSpec * SDL_LoadWAV_RW(SDL_RWops *src, int freesrc, SDL_AudioSpec *spec, uint8_t **audio_buf, uint32_t *audio_len);

/*
#define SDL_LoadWAV(file, spec, audio_buf, audio_len) \
SDL_LoadWAV_RW(SDL_RWFromFile(file, "rb"),1, spec,audio_buf,audio_len)
*/

void SDL_FreeWAV(uint8_t *audio_buf);
int SDL_BuildAudioCVT(SDL_AudioCVT *cvt,
		uint16_t src_format, uint8_t src_channels, int src_rate,
		uint16_t dst_format, uint8_t dst_channels, int dst_rate);

int SDL_ConvertAudio(SDL_AudioCVT *cvt);


enum {
        SDL_MIX_MAXVOLUME = 128,
};

void SDL_MixAudio(uint8_t *dst, const uint8_t *src, uint32_t len, int volume);
void SDL_LockAudio(void);
void SDL_UnlockAudio(void);

void SDL_CloseAudio(void);

// SDL_cdrom.h
// Not converted

// SDL_cpu.h

SDL_bool SDL_HasRDTSC(void);
SDL_bool SDL_HasMMX(void);
SDL_bool SDL_HasMMXExt(void);
SDL_bool SDL_Has3DNow(void);
SDL_bool SDL_Has3DNowExt(void);
SDL_bool SDL_HasSSE(void);
SDL_bool SDL_HasSSE2(void);
SDL_bool SDL_HasAltiVec(void);

// SDL_endian.h
// Not converted

// SDL_error.h
void SDL_SetError(const char *fmt, ...);
char * SDL_GetError(void);
void SDL_ClearError(void);

typedef enum {
	SDL_ENOMEM,
	SDL_EFREAD,
	SDL_EFWRITE,
	SDL_EFSEEK,
	SDL_UNSUPPORTED,
	SDL_LASTERROR
} SDL_errorcode;

void SDL_Error(SDL_errorcode code);

// SDL_keysym.h

typedef enum {

	SDLK_UNKNOWN		= 0,
	SDLK_FIRST		= 0,
	SDLK_BACKSPACE		= 8,
	SDLK_TAB		= 9,
	SDLK_CLEAR		= 12,
	SDLK_RETURN		= 13,
	SDLK_PAUSE		= 19,
	SDLK_ESCAPE		= 27,
	SDLK_SPACE		= 32,
	SDLK_EXCLAIM		= 33,
	SDLK_QUOTEDBL		= 34,
	SDLK_HASH		= 35,
	SDLK_DOLLAR		= 36,
	SDLK_AMPERSAND		= 38,
	SDLK_QUOTE		= 39,
	SDLK_LEFTPAREN		= 40,
	SDLK_RIGHTPAREN		= 41,
	SDLK_ASTERISK		= 42,
	SDLK_PLUS		= 43,
	SDLK_COMMA		= 44,
	SDLK_MINUS		= 45,
	SDLK_PERIOD		= 46,
	SDLK_SLASH		= 47,
	SDLK_0			= 48,
	SDLK_1			= 49,
	SDLK_2			= 50,
	SDLK_3			= 51,
	SDLK_4			= 52,
	SDLK_5			= 53,
	SDLK_6			= 54,
	SDLK_7			= 55,
	SDLK_8			= 56,
	SDLK_9			= 57,
	SDLK_COLON		= 58,
	SDLK_SEMICOLON		= 59,
	SDLK_LESS		= 60,
	SDLK_EQUALS		= 61,
	SDLK_GREATER		= 62,
	SDLK_QUESTION		= 63,
	SDLK_AT			= 64,
	/* 
	   Skip uppercase letters
	 */
	SDLK_LEFTBRACKET	= 91,
	SDLK_BACKSLASH		= 92,
	SDLK_RIGHTBRACKET	= 93,
	SDLK_CARET		= 94,
	SDLK_UNDERSCORE		= 95,
	SDLK_BACKQUOTE		= 96,
	SDLK_a			= 97,
	SDLK_b			= 98,
	SDLK_c			= 99,
	SDLK_d			= 100,
	SDLK_e			= 101,
	SDLK_f			= 102,
	SDLK_g			= 103,
	SDLK_h			= 104,
	SDLK_i			= 105,
	SDLK_j			= 106,
	SDLK_k			= 107,
	SDLK_l			= 108,
	SDLK_m			= 109,
	SDLK_n			= 110,
	SDLK_o			= 111,
	SDLK_p			= 112,
	SDLK_q			= 113,
	SDLK_r			= 114,
	SDLK_s			= 115,
	SDLK_t			= 116,
	SDLK_u			= 117,
	SDLK_v			= 118,
	SDLK_w			= 119,
	SDLK_x			= 120,
	SDLK_y			= 121,
	SDLK_z			= 122,
	SDLK_DELETE		= 127,

        
	SDLK_WORLD_0		= 160,		
	SDLK_WORLD_1		= 161,
	SDLK_WORLD_2		= 162,
	SDLK_WORLD_3		= 163,
	SDLK_WORLD_4		= 164,
	SDLK_WORLD_5		= 165,
	SDLK_WORLD_6		= 166,
	SDLK_WORLD_7		= 167,
	SDLK_WORLD_8		= 168,
	SDLK_WORLD_9		= 169,
	SDLK_WORLD_10		= 170,
	SDLK_WORLD_11		= 171,
	SDLK_WORLD_12		= 172,
	SDLK_WORLD_13		= 173,
	SDLK_WORLD_14		= 174,
	SDLK_WORLD_15		= 175,
	SDLK_WORLD_16		= 176,
	SDLK_WORLD_17		= 177,
	SDLK_WORLD_18		= 178,
	SDLK_WORLD_19		= 179,
	SDLK_WORLD_20		= 180,
	SDLK_WORLD_21		= 181,
	SDLK_WORLD_22		= 182,
	SDLK_WORLD_23		= 183,
	SDLK_WORLD_24		= 184,
	SDLK_WORLD_25		= 185,
	SDLK_WORLD_26		= 186,
	SDLK_WORLD_27		= 187,
	SDLK_WORLD_28		= 188,
	SDLK_WORLD_29		= 189,
	SDLK_WORLD_30		= 190,
	SDLK_WORLD_31		= 191,
	SDLK_WORLD_32		= 192,
	SDLK_WORLD_33		= 193,
	SDLK_WORLD_34		= 194,
	SDLK_WORLD_35		= 195,
	SDLK_WORLD_36		= 196,
	SDLK_WORLD_37		= 197,
	SDLK_WORLD_38		= 198,
	SDLK_WORLD_39		= 199,
	SDLK_WORLD_40		= 200,
	SDLK_WORLD_41		= 201,
	SDLK_WORLD_42		= 202,
	SDLK_WORLD_43		= 203,
	SDLK_WORLD_44		= 204,
	SDLK_WORLD_45		= 205,
	SDLK_WORLD_46		= 206,
	SDLK_WORLD_47		= 207,
	SDLK_WORLD_48		= 208,
	SDLK_WORLD_49		= 209,
	SDLK_WORLD_50		= 210,
	SDLK_WORLD_51		= 211,
	SDLK_WORLD_52		= 212,
	SDLK_WORLD_53		= 213,
	SDLK_WORLD_54		= 214,
	SDLK_WORLD_55		= 215,
	SDLK_WORLD_56		= 216,
	SDLK_WORLD_57		= 217,
	SDLK_WORLD_58		= 218,
	SDLK_WORLD_59		= 219,
	SDLK_WORLD_60		= 220,
	SDLK_WORLD_61		= 221,
	SDLK_WORLD_62		= 222,
	SDLK_WORLD_63		= 223,
	SDLK_WORLD_64		= 224,
	SDLK_WORLD_65		= 225,
	SDLK_WORLD_66		= 226,
	SDLK_WORLD_67		= 227,
	SDLK_WORLD_68		= 228,
	SDLK_WORLD_69		= 229,
	SDLK_WORLD_70		= 230,
	SDLK_WORLD_71		= 231,
	SDLK_WORLD_72		= 232,
	SDLK_WORLD_73		= 233,
	SDLK_WORLD_74		= 234,
	SDLK_WORLD_75		= 235,
	SDLK_WORLD_76		= 236,
	SDLK_WORLD_77		= 237,
	SDLK_WORLD_78		= 238,
	SDLK_WORLD_79		= 239,
	SDLK_WORLD_80		= 240,
	SDLK_WORLD_81		= 241,
	SDLK_WORLD_82		= 242,
	SDLK_WORLD_83		= 243,
	SDLK_WORLD_84		= 244,
	SDLK_WORLD_85		= 245,
	SDLK_WORLD_86		= 246,
	SDLK_WORLD_87		= 247,
	SDLK_WORLD_88		= 248,
	SDLK_WORLD_89		= 249,
	SDLK_WORLD_90		= 250,
	SDLK_WORLD_91		= 251,
	SDLK_WORLD_92		= 252,
	SDLK_WORLD_93		= 253,
	SDLK_WORLD_94		= 254,
	SDLK_WORLD_95		= 255,		

	SDLK_KP0		= 256,
	SDLK_KP1		= 257,
	SDLK_KP2		= 258,
	SDLK_KP3		= 259,
	SDLK_KP4		= 260,
	SDLK_KP5		= 261,
	SDLK_KP6		= 262,
	SDLK_KP7		= 263,
	SDLK_KP8		= 264,
	SDLK_KP9		= 265,
	SDLK_KP_PERIOD		= 266,
	SDLK_KP_DIVIDE		= 267,
	SDLK_KP_MULTIPLY	= 268,
	SDLK_KP_MINUS		= 269,
	SDLK_KP_PLUS		= 270,
	SDLK_KP_ENTER		= 271,
	SDLK_KP_EQUALS		= 272,

	SDLK_UP			= 273,
	SDLK_DOWN		= 274,
	SDLK_RIGHT		= 275,
	SDLK_LEFT		= 276,
	SDLK_INSERT		= 277,
	SDLK_HOME		= 278,
	SDLK_END		= 279,
	SDLK_PAGEUP		= 280,
	SDLK_PAGEDOWN		= 281,


	SDLK_F1			= 282,
	SDLK_F2			= 283,
	SDLK_F3			= 284,
	SDLK_F4			= 285,
	SDLK_F5			= 286,
	SDLK_F6			= 287,
	SDLK_F7			= 288,
	SDLK_F8			= 289,
	SDLK_F9			= 290,
	SDLK_F10		= 291,
	SDLK_F11		= 292,
	SDLK_F12		= 293,
	SDLK_F13		= 294,
	SDLK_F14		= 295,
	SDLK_F15		= 296,


	SDLK_NUMLOCK		= 300,
	SDLK_CAPSLOCK		= 301,
	SDLK_SCROLLOCK		= 302,
	SDLK_RSHIFT		= 303,
	SDLK_LSHIFT		= 304,
	SDLK_RCTRL		= 305,
	SDLK_LCTRL		= 306,
	SDLK_RALT		= 307,
	SDLK_LALT		= 308,
	SDLK_RMETA		= 309,
	SDLK_LMETA		= 310,
	SDLK_LSUPER		= 311,
	SDLK_RSUPER		= 312,
	SDLK_MODE		= 313,
	SDLK_COMPOSE		= 314,

	SDLK_HELP		= 315,
	SDLK_PRINT		= 316,
	SDLK_SYSREQ		= 317,
	SDLK_BREAK		= 318,
	SDLK_MENU		= 319,
	SDLK_POWER		= 320,
	SDLK_EURO		= 321,
	SDLK_UNDO		= 322,


	SDLK_LAST
} SDLKey;


typedef enum {
	KMOD_NONE  = 0x0000,
	KMOD_LSHIFT= 0x0001,
	KMOD_RSHIFT= 0x0002,
	KMOD_LCTRL = 0x0040,
	KMOD_RCTRL = 0x0080,
	KMOD_LALT  = 0x0100,
	KMOD_RALT  = 0x0200,
	KMOD_LMETA = 0x0400,
	KMOD_RMETA = 0x0800,
	KMOD_NUM   = 0x1000,
	KMOD_CAPS  = 0x2000,
	KMOD_MODE  = 0x4000,
	KMOD_RESERVED = 0x8000,
        KMOD_CTRL = 	(KMOD_LCTRL|KMOD_RCTRL),
        KMOD_SHIFT=	(KMOD_LSHIFT|KMOD_RSHIFT),
        KMOD_ALT=	(KMOD_LALT|KMOD_RALT),
        KMOD_META=	(KMOD_LMETA|KMOD_RMETA),
} SDLMod;

// SDL_keyboard.h

typedef struct SDL_keysym {
	uint8_t scancode;	
	SDLKey sym;		
	SDLMod mod;		
	uint16_t unicode;	
} SDL_keysym;

enum {
        SDL_ALL_HOTKEYS = 		0xFFFFFFFF,
};

int SDL_EnableUNICODE(int enable);

enum {
        SDL_DEFAULT_REPEAT_DELAY	= 500,
        SDL_DEFAULT_REPEAT_INTERVAL	= 30,
};

int SDL_EnableKeyRepeat(int delay, int interval);
void SDL_GetKeyRepeat(int *delay, int *interval);
uint8_t * SDL_GetKeyState(int *numkeys);
SDLMod SDL_GetModState(void);
void SDL_SetModState(SDLMod modstate);
char * SDL_GetKeyName(SDLKey key);



// SDL_mouse.h
// TODO!

// SDL_events.h

enum {
        SDL_RELEASED	= 0,
        SDL_PRESSED	= 1,
};

typedef enum {
       SDL_NOEVENT = 0,		
       SDL_ACTIVEEVENT,		
       SDL_KEYDOWN,		
       SDL_KEYUP,		
       SDL_MOUSEMOTION,		
       SDL_MOUSEBUTTONDOWN,	
       SDL_MOUSEBUTTONUP,	
       SDL_JOYAXISMOTION,	
       SDL_JOYBALLMOTION,	
       SDL_JOYHATMOTION,	
       SDL_JOYBUTTONDOWN,	
       SDL_JOYBUTTONUP,		
       SDL_QUIT,		
       SDL_SYSWMEVENT,		
       SDL_EVENT_RESERVEDA,	
       SDL_EVENT_RESERVEDB,	
       SDL_VIDEORESIZE,		
       SDL_VIDEOEXPOSE,		
       SDL_EVENT_RESERVED2,	
       SDL_EVENT_RESERVED3,	
       SDL_EVENT_RESERVED4,	
       SDL_EVENT_RESERVED5,	
       SDL_EVENT_RESERVED6,	
       SDL_EVENT_RESERVED7,	

       SDL_USEREVENT = 24,
       SDL_NUMEVENTS = 32,
} SDL_EventType;

typedef enum {
	SDL_ACTIVEEVENTMASK	= (1<<(SDL_ACTIVEEVENT)),
	SDL_KEYDOWNMASK		= (1<<(SDL_KEYDOWN)),
	SDL_KEYUPMASK		= (1<<(SDL_KEYUP)),
	SDL_KEYEVENTMASK	= (1<<(SDL_KEYDOWN))| (1<<(SDL_KEYUP)),
	SDL_MOUSEMOTIONMASK	= (1<<(SDL_MOUSEMOTION)),
	SDL_MOUSEBUTTONDOWNMASK	= (1<<(SDL_MOUSEBUTTONDOWN)),
	SDL_MOUSEBUTTONUPMASK	= (1<<(SDL_MOUSEBUTTONUP)),
	SDL_MOUSEEVENTMASK	= (1<<(SDL_MOUSEMOTION))| (1<<(SDL_MOUSEBUTTONDOWN))
            |(1<<(SDL_MOUSEBUTTONUP)),
        SDL_JOYAXISMOTIONMASK	= (1<<(SDL_JOYAXISMOTION)),
	SDL_JOYBALLMOTIONMASK	= (1<<(SDL_JOYBALLMOTION)),
	SDL_JOYHATMOTIONMASK	= (1<<(SDL_JOYHATMOTION)),
	SDL_JOYBUTTONDOWNMASK	= (1<<(SDL_JOYBUTTONDOWN)),
	SDL_JOYBUTTONUPMASK	= (1<<(SDL_JOYBUTTONUP)),
	SDL_JOYEVENTMASK	= (1<<(SDL_JOYAXISMOTION))| (1<<(SDL_JOYBALLMOTION))|
            (1<<(SDL_JOYHATMOTION)) |
            (1<<(SDL_JOYBUTTONDOWN)) |
            (1<<(SDL_JOYBUTTONUP)),
	SDL_VIDEORESIZEMASK	= (1<<(SDL_VIDEORESIZE)),
	SDL_VIDEOEXPOSEMASK	= (1<<(SDL_VIDEOEXPOSE)),
	SDL_QUITMASK		= (1<<(SDL_QUIT)),
	SDL_SYSWMEVENTMASK	= (1<<(SDL_SYSWMEVENT))
} SDL_EventMask ;

enum {
        SDL_ALLEVENTS	=	0xFFFFFFFF,
};

typedef struct SDL_ActiveEvent {
	uint8_t type;	/**< SDL_ACTIVEEVENT */
	uint8_t gain;	/**< Whether given states were gained or lost (1/0) */
	uint8_t state;	/**< A mask of the focus states */
} SDL_ActiveEvent;


typedef struct SDL_KeyboardEvent {
	uint8_t type;	/**< SDL_KEYDOWN or SDL_KEYUP */
	uint8_t which;	/**< The keyboard device index */
	uint8_t state;	/**< SDL_PRESSED or SDL_RELEASED */
	SDL_keysym keysym;
} SDL_KeyboardEvent;

typedef struct SDL_MouseMotionEvent {
	uint8_t type;	/**< SDL_MOUSEMOTION */
	uint8_t which;	/**< The mouse device index */
	uint8_t state;	/**< The current button state */
	uint16_t x, y;	/**< The X/Y coordinates of the mouse */
	int16_t xrel;	/**< The relative motion in the X direction */
	int16_t yrel;	/**< The relative motion in the Y direction */
} SDL_MouseMotionEvent;

typedef struct SDL_MouseButtonEvent {
	uint8_t type;	/**< SDL_MOUSEBUTTONDOWN or SDL_MOUSEBUTTONUP */
	uint8_t which;	/**< The mouse device index */
	uint8_t button;	/**< The mouse button index */
	uint8_t state;	/**< SDL_PRESSED or SDL_RELEASED */
	uint16_t x, y;	/**< The X/Y coordinates of the mouse at press time */
} SDL_MouseButtonEvent;

typedef struct SDL_JoyAxisEvent {
	uint8_t type;	/**< SDL_JOYAXISMOTION */
	uint8_t which;	/**< The joystick device index */
	uint8_t axis;	/**< The joystick axis index */
	int16_t value;	/**< The axis value (range: -32768 to 32767) */
} SDL_JoyAxisEvent;

typedef struct SDL_JoyBallEvent {
	uint8_t type;	/**< SDL_JOYBALLMOTION */
	uint8_t which;	/**< The joystick device index */
	uint8_t ball;	/**< The joystick trackball index */
	int16_t xrel;	/**< The relative motion in the X direction */
	int16_t yrel;	/**< The relative motion in the Y direction */
} SDL_JoyBallEvent;

typedef struct SDL_JoyHatEvent {
	uint8_t type;	/**< SDL_JOYHATMOTION */
	uint8_t which;	/**< The joystick device index */
	uint8_t hat;	/**< The joystick hat index */
	uint8_t value;	/**< The hat position value:
			 *   SDL_HAT_LEFTUP   SDL_HAT_UP       SDL_HAT_RIGHTUP
			 *   SDL_HAT_LEFT     SDL_HAT_CENTERED SDL_HAT_RIGHT
			 *   SDL_HAT_LEFTDOWN SDL_HAT_DOWN     SDL_HAT_RIGHTDOWN
			 *  Note that zero means the POV is centered.
			 */
} SDL_JoyHatEvent;

typedef struct SDL_JoyButtonEvent {
	uint8_t type;	/**< SDL_JOYBUTTONDOWN or SDL_JOYBUTTONUP */
	uint8_t which;	/**< The joystick device index */
	uint8_t button;	/**< The joystick button index */
	uint8_t state;	/**< SDL_PRESSED or SDL_RELEASED */
} SDL_JoyButtonEvent;

typedef struct SDL_ResizeEvent {
	uint8_t type;	/**< SDL_VIDEORESIZE */
	int w;		/**< New width */
	int h;		/**< New height */
} SDL_ResizeEvent;

typedef struct SDL_ExposeEvent {
	uint8_t type;	/**< SDL_VIDEOEXPOSE */
} SDL_ExposeEvent;

typedef struct SDL_QuitEvent {
	uint8_t type;	/**< SDL_QUIT */
} SDL_QuitEvent;

typedef struct SDL_UserEvent {
	uint8_t type;	/**< SDL_USEREVENT through SDL_NUMEVENTS-1 */
	int code;	/**< User defined event code */
	void *data1;	/**< User defined data pointer */
	void *data2;	/**< User defined data pointer */
} SDL_UserEvent;

struct SDL_SysWMmsg;
typedef struct SDL_SysWMmsg SDL_SysWMmsg;
typedef struct SDL_SysWMEvent {
	uint8_t type;
	SDL_SysWMmsg *msg;
} SDL_SysWMEvent;

typedef union SDL_Event {
	uint8_t type;
	SDL_ActiveEvent active;
	SDL_KeyboardEvent key;
	SDL_MouseMotionEvent motion;
	SDL_MouseButtonEvent button;
	SDL_JoyAxisEvent jaxis;
	SDL_JoyBallEvent jball;
	SDL_JoyHatEvent jhat;
	SDL_JoyButtonEvent jbutton;
	SDL_ResizeEvent resize;
	SDL_ExposeEvent expose;
	SDL_QuitEvent quit;
	SDL_UserEvent user;
	SDL_SysWMEvent syswm;
} SDL_Event;


void SDL_PumpEvents(void);

typedef enum {
	SDL_ADDEVENT,
	SDL_PEEKEVENT,
	SDL_GETEVENT
} SDL_eventaction;

int SDL_PeepEvents(SDL_Event *events, int numevents,
				SDL_eventaction action, uint32_t mask);
int SDL_PollEvent(SDL_Event *event);
int SDL_WaitEvent(SDL_Event *event);
int SDL_PushEvent(SDL_Event *event);
typedef int (*SDL_EventFilter)(const SDL_Event *event);
void SDL_SetEventFilter(SDL_EventFilter filter);
SDL_EventFilter SDL_GetEventFilter(void);

enum {
        SDL_QUERY        = -1,
        SDL_IGNORE	 = 0, 
        SDL_DISABLE	 = 0,
        SDL_ENABLE	 = 1,
};
 
uint8_t SDL_EventState(uint8_t type, int state);

// SDL_loadso.h
// Not included

// SDL_mutex.h
// Not included



// SDL_thread.h
// FIXME

// SDL_timer.h


enum {
        SDL_TIMESLICE=		10,
};
       
enum {
        TIMER_RESOLUTION=	10,
};

uint32_t SDL_GetTicks(void);
void SDL_Delay(uint32_t ms);
typedef uint32_t (*SDL_TimerCallback)(uint32_t interval);
int SDL_SetTimer(uint32_t interval, SDL_TimerCallback callback);
typedef uint32_t (*SDL_NewTimerCallback)(uint32_t interval, void *param);
typedef struct _SDL_TimerID *SDL_TimerID;
SDL_TimerID SDL_AddTimer(uint32_t interval, SDL_NewTimerCallback callback, void *param);
SDL_bool SDL_RemoveTimer(SDL_TimerID t);

// SDL_video.h

enum {
        SDL_ALPHA_OPAQUE = 255,
        SDL_ALPHA_TRANSPARENT = 0,
};

typedef struct SDL_Rect {
	int16_t x, y;
	uint16_t w, h;
} SDL_Rect;

typedef struct SDL_Color {
	uint8_t r;
	uint8_t g;
	uint8_t b;
	uint8_t unused;
} SDL_Color;

typedef struct SDL_Palette {
	int       ncolors;
	SDL_Color *colors;
} SDL_Palette;

typedef struct SDL_PixelFormat {
	SDL_Palette *palette;
	uint8_t  BitsPerPixel;
	uint8_t  BytesPerPixel;
	uint8_t  Rloss;
	uint8_t  Gloss;
	uint8_t  Bloss;
	uint8_t  Aloss;
	uint8_t  Rshift;
	uint8_t  Gshift;
	uint8_t  Bshift;
	uint8_t  Ashift;
	uint32_t Rmask;
	uint32_t Gmask;
	uint32_t Bmask;
	uint32_t Amask;

	uint32_t colorkey;
	uint8_t  alpha;
} SDL_PixelFormat;

typedef struct SDL_Surface {
	uint32_t flags;				/**< Read-only */
	SDL_PixelFormat *format;		/**< Read-only */
	int w, h;				/**< Read-only */
	uint16_t pitch;				/**< Read-only */
	void *pixels;				/**< Read-write */
	int offset;				/**< Private */

	struct private_hwdata *hwdata;

	SDL_Rect clip_rect;			/**< Read-only */
	uint32_t unused1;				/**< for binary compatibility */

	uint32_t locked;				/**< Private */

	struct SDL_BlitMap *map;		/**< Private */

	unsigned int format_version;		/**< Private */

	int refcount;				/**< Read-mostly */
} SDL_Surface;

enum {
        
        SDL_SWSURFACE	= 0x00000000,
        SDL_HWSURFACE	= 0x00000001,	
        SDL_ASYNCBLIT	= 0x00000004,
};

enum {
        
        SDL_ANYFORMAT =	0x10000000,
        SDL_HWPALETTE =	0x20000000,
        SDL_DOUBLEBUF =	0x40000000,
        SDL_FULLSCREEN =	0x80000000,
        SDL_OPENGL =      0x00000002,
        SDL_OPENGLBLIT =	0x0000000A,
        SDL_RESIZABLE =	0x00000010,
        SDL_NOFRAME =	0x00000020,
        
        SDL_HWACCEL =	0x00000100,
        SDL_SRCCOLORKEY =	0x00001000,
        SDL_RLEACCELOK =	0x00002000,
        SDL_RLEACCEL =	0x00004000,
        SDL_SRCALPHA =	0x00010000,
        SDL_PREALLOC =	0x01000000,
};
 

/*
#define SDL_MUSTLOCK(surface)	\
  (surface->offset ||		\
  ((surface->flags & (SDL_HWSURFACE|SDL_ASYNCBLIT|SDL_RLEACCEL)) != 0))

typedef int (*SDL_blit)(struct SDL_Surface *src, SDL_Rect *srcrect,
			struct SDL_Surface *dst, SDL_Rect *dstrect);

*/

typedef struct SDL_VideoInfo {
	uint32_t hw_available :1;	/**< Flag: Can you create hardware surfaces? */
	uint32_t wm_available :1;	/**< Flag: Can you talk to a window manager? */
	uint32_t UnusedBits1  :6;
	uint32_t UnusedBits2  :1;
	uint32_t blit_hw      :1;	/**< Flag: Accelerated blits HW --> HW */
	uint32_t blit_hw_CC   :1;	/**< Flag: Accelerated blits with Colorkey */
	uint32_t blit_hw_A    :1;	/**< Flag: Accelerated blits with Alpha */
	uint32_t blit_sw      :1;	/**< Flag: Accelerated blits SW --> HW */
	uint32_t blit_sw_CC   :1;	/**< Flag: Accelerated blits with Colorkey */
	uint32_t blit_sw_A    :1;	/**< Flag: Accelerated blits with Alpha */
	uint32_t blit_fill    :1;	/**< Flag: Accelerated color fill */
	uint32_t UnusedBits3  :16;
	uint32_t video_mem;	/**< The total amount of video memory (in K) */
	SDL_PixelFormat *vfmt;	/**< Value: The format of the video surface */
	int    current_w;	/**< Value: The current video mode width */
	int    current_h;	/**< Value: The current video mode height */
} SDL_VideoInfo;


enum {
        
        SDL_YV12_OVERLAY=  0x32315659,
        SDL_IYUV_OVERLAY=  0x56555949,
        SDL_YUY2_OVERLAY=  0x32595559,
        SDL_UYVY_OVERLAY=  0x59565955,
        SDL_YVYU_OVERLAY=  0x55595659,

};

typedef struct SDL_Overlay {
	uint32_t format;				/**< Read-only */
	int w, h;				/**< Read-only */
	int planes;				/**< Read-only */
	uint16_t *pitches;			/**< Read-only */
	uint8_t **pixels;				/**< Read-write */

	struct private_yuvhwfuncs *hwfuncs;
	struct private_yuvhwdata *hwdata;
	uint32_t hw_overlay :1;	/**< Flag: This overlay hardware accelerated? */
	uint32_t UnusedBits :31;

} SDL_Overlay;

typedef enum {
        SDL_GL_RED_SIZE=0,
        SDL_GL_GREEN_SIZE,
        SDL_GL_BLUE_SIZE,
        SDL_GL_ALPHA_SIZE,
        SDL_GL_BUFFER_SIZE,
        SDL_GL_DOUBLEBUFFER,
        SDL_GL_DEPTH_SIZE,
        SDL_GL_STENCIL_SIZE,
        SDL_GL_ACCUM_RED_SIZE,
        SDL_GL_ACCUM_GREEN_SIZE,
        SDL_GL_ACCUM_BLUE_SIZE,
        SDL_GL_ACCUM_ALPHA_SIZE,
        SDL_GL_STEREO,
        SDL_GL_MULTISAMPLEBUFFERS,
        SDL_GL_MULTISAMPLESAMPLES,
        SDL_GL_ACCELERATED_VISUAL,
        SDL_GL_SWAP_CONTROL
} SDL_GLattr;

enum {
        SDL_LOGPAL = 0x01,
        SDL_PHYSPAL = 0x02,
};


int SDL_VideoInit(const char *driver_name, uint32_t flags);
void SDL_VideoQuit(void);
char * SDL_VideoDriverName(char *namebuf, int maxlen);
SDL_Surface * SDL_GetVideoSurface(void);
const SDL_VideoInfo * SDL_GetVideoInfo(void);
int SDL_VideoModeOK(int width, int height, int bpp, uint32_t flags);
SDL_Rect ** SDL_ListModes(SDL_PixelFormat *format, uint32_t flags);
SDL_Surface * SDL_SetVideoMode
			(int width, int height, int bpp, uint32_t flags);

void SDL_UpdateRects
		(SDL_Surface *screen, int numrects, SDL_Rect *rects);
void SDL_UpdateRect
		(SDL_Surface *screen, int32_t x, int32_t y, uint32_t w, uint32_t h);
int SDL_Flip(SDL_Surface *screen);

int SDL_SetGamma(float red, float green, float blue);
int SDL_SetGammaRamp(const uint16_t *red, const uint16_t *green, const uint16_t *blue);
int SDL_GetGammaRamp(uint16_t *red, uint16_t *green, uint16_t *blue);

int SDL_SetColors(SDL_Surface *surface, 
			SDL_Color *colors, int firstcolor, int ncolors);
int SDL_SetPalette(SDL_Surface *surface, int flags,
				   SDL_Color *colors, int firstcolor,
				   int ncolors);

uint32_t SDL_MapRGB (const SDL_PixelFormat * const format, const uint8_t r, const uint8_t g, const uint8_t b);
uint32_t SDL_MapRGBA (const SDL_PixelFormat * const format,  const uint8_t r, const uint8_t g, const uint8_t b, const uint8_t a);
void SDL_GetRGB(uint32_t pixel,	const SDL_PixelFormat * const fmt, uint8_t *r, uint8_t *g, uint8_t *b);
void SDL_GetRGBA(uint32_t pixel, const SDL_PixelFormat * const fmt, uint8_t *r, uint8_t *g, uint8_t *b, uint8_t *a);

/*
#define SDL_AllocSurface    SDL_CreateRGBSurface
*/

SDL_Surface * SDL_CreateRGBSurface (uint32_t flags, int width, int height, int depth, 
			uint32_t Rmask, uint32_t Gmask, uint32_t Bmask, uint32_t Amask);
SDL_Surface * SDL_CreateRGBSurfaceFrom(void *pixels, int width, int height, int depth, int pitch,
			uint32_t Rmask, uint32_t Gmask, uint32_t Bmask, uint32_t Amask);
void SDL_FreeSurface(SDL_Surface *surface);
int SDL_LockSurface(SDL_Surface *surface);
void SDL_UnlockSurface(SDL_Surface *surface);
SDL_Surface * SDL_LoadBMP_RW(SDL_RWops *src, int freesrc);
int SDL_SaveBMP_RW (SDL_Surface *surface, SDL_RWops *dst, int freedst);

int SDL_SetColorKey (SDL_Surface *surface, uint32_t flag, uint32_t key);

int SDL_SetAlpha(SDL_Surface *surface, uint32_t flag, uint8_t alpha);
SDL_bool SDL_SetClipRect(SDL_Surface *surface, const SDL_Rect *rect);
void SDL_GetClipRect(SDL_Surface *surface, SDL_Rect *rect);
SDL_Surface * SDL_ConvertSurface(SDL_Surface *src, SDL_PixelFormat *fmt, uint32_t flags);

int SDL_UpperBlit(SDL_Surface *src, SDL_Rect *srcrect,	 SDL_Surface *dst, SDL_Rect *dstrect);
int SDL_LowerBlit(SDL_Surface *src, SDL_Rect *srcrect,	 SDL_Surface *dst, SDL_Rect *dstrect);
int SDL_FillRect(SDL_Surface *dst, SDL_Rect *dstrect, uint32_t color);

SDL_Surface * SDL_DisplayFormat(SDL_Surface *surface);
SDL_Surface * SDL_DisplayFormatAlpha(SDL_Surface *surface);

SDL_Overlay * SDL_CreateYUVOverlay(int width, int height,
				uint32_t format, SDL_Surface *display);

int SDL_LockYUVOverlay(SDL_Overlay *overlay);
void SDL_UnlockYUVOverlay(SDL_Overlay *overlay);
int SDL_DisplayYUVOverlay(SDL_Overlay *overlay, SDL_Rect *dstrect);

void SDL_FreeYUVOverlay(SDL_Overlay *overlay);

int SDL_GL_LoadLibrary(const char *path);
void * SDL_GL_GetProcAddress(const char* proc);
int SDL_GL_SetAttribute(SDL_GLattr attr, int value);
int SDL_GL_GetAttribute(SDL_GLattr attr, int* value);
void SDL_GL_SwapBuffers(void);

void SDL_WM_SetCaption(const char *title, const char *icon);
void SDL_WM_GetCaption(char **title, char **icon);
void SDL_WM_SetIcon(SDL_Surface *icon, uint8_t *mask);
int SDL_WM_IconifyWindow(void);
int SDL_WM_ToggleFullScreen(SDL_Surface *surface);

typedef enum {
	SDL_GRAB_QUERY = -1,
	SDL_GRAB_OFF = 0,
	SDL_GRAB_ON = 1,
	SDL_GRAB_FULLSCREEN	/**< Used internally */
} SDL_GrabMode;

SDL_GrabMode SDL_WM_GrabInput(SDL_GrabMode mode);

]]

else
    -- bail here if no SDL since it's fatal
    assert (nil, "Unable to load SDL shared library\n")
end

ok = xpcall(ffi.load, load_err, 'stt')
if ok then
    local stt  = ffi.load("stt")
    sdlsumo['stt'] = stt
    
    ffi.cdef[[

typedef struct _STT_Font {

        uint32_t handle;

} STT_Font;


int  STT_Init(void);

STT_Font * STT_OpenFont(const char *file, int ptsize);

SDL_Surface * STT_RenderText_Solid(STT_Font *font, const char *text, SDL_Color fg);

SDL_Surface * STT_RenderText_Blended(STT_Font *font, const char *text, SDL_Color fg);

void STT_CloseFont(STT_Font *font);
void STT_Quit(void);
int STT_WasInit(void);

]]

-- if no joy then just mark it as nil in the sumo table
else
    debug_print ("Unable to load stt\n")
    sdlsumo['stt'] = nil
end

-- now try SDL_Image
local ok = xpcall(ffi.load, load_err, 'SDL_image')
if ok then
    local image = ffi.load("SDL_image")
    sdlsumo['image'] = image

    -- SDL_image 1.2.12 definitions
    ffi.cdef[[

enum {
        SDL_IMAGE_MAJOR_VERSION	= 1,
        SDL_IMAGE_MINOR_VERSION	= 2,
        SDL_IMAGE_PATCHLEVEL	        = 12,
};

const SDL_version *  IMG_Linked_Version(void);

typedef enum
{
        IMG_INIT_JPG = 0x00000001,
        IMG_INIT_PNG = 0x00000002,
        IMG_INIT_TIF = 0x00000004,
        IMG_INIT_WEBP = 0x00000008,
} IMG_InitFlags;

int IMG_Init(int flags);
void IMG_Quit(void);

SDL_Surface * IMG_LoadTyped_RW(SDL_RWops *src, int freesrc, char *type);
SDL_Surface * IMG_Load(const char *file);
SDL_Surface * IMG_Load_RW(SDL_RWops *src, int freesrc);

int IMG_InvertAlpha(int on);

int IMG_isICO(SDL_RWops *src);
int IMG_isCUR(SDL_RWops *src);
int IMG_isBMP(SDL_RWops *src);
int IMG_isGIF(SDL_RWops *src);
int IMG_isJPG(SDL_RWops *src);
int IMG_isLBM(SDL_RWops *src);
int IMG_isPCX(SDL_RWops *src);
int IMG_isPNG(SDL_RWops *src);
int IMG_isPNM(SDL_RWops *src);
int IMG_isTIF(SDL_RWops *src);
int IMG_isXCF(SDL_RWops *src);
int IMG_isXPM(SDL_RWops *src);
int IMG_isXV(SDL_RWops *src);
int IMG_isWEBP(SDL_RWops *src);

SDL_Surface * IMG_LoadICO_RW(SDL_RWops *src);
SDL_Surface * IMG_LoadCUR_RW(SDL_RWops *src);
SDL_Surface * IMG_LoadBMP_RW(SDL_RWops *src);
SDL_Surface * IMG_LoadGIF_RW(SDL_RWops *src);
SDL_Surface * IMG_LoadJPG_RW(SDL_RWops *src);
SDL_Surface * IMG_LoadLBM_RW(SDL_RWops *src);
SDL_Surface * IMG_LoadPCX_RW(SDL_RWops *src);
SDL_Surface * IMG_LoadPNG_RW(SDL_RWops *src);
SDL_Surface * IMG_LoadPNM_RW(SDL_RWops *src);
SDL_Surface * IMG_LoadTGA_RW(SDL_RWops *src);
SDL_Surface * IMG_LoadTIF_RW(SDL_RWops *src);
SDL_Surface * IMG_LoadXCF_RW(SDL_RWops *src);
SDL_Surface * IMG_LoadXPM_RW(SDL_RWops *src);
SDL_Surface * IMG_LoadXV_RW(SDL_RWops *src);
SDL_Surface * IMG_LoadWEBP_RW(SDL_RWops *src);

SDL_Surface * IMG_ReadXPMFromArray(char **xpm);

]]

-- mark it as nil if not found
else
    debug_print ("Unable to load SDL_image\n")
    sdlsumo['image'] = nil
end


ok = xpcall(ffi.load, load_err, 'SDL_mixer')
if ok then
    local mixer = ffi.load("SDL_mixer")
    sdlsumo['mixer'] = mixer

    -- SDL_mixer 1.2.12 definitions

ffi.cdef[[

char * SDL_AudioDriverName(char *namebuf, int maxlen);

enum {
    SDL_MIXER_MAJOR_VERSION	= 1,
    SDL_MIXER_MINOR_VERSION	= 2,
    SDL_MIXER_PATCHLEVEL        = 12,
};

const SDL_version * Mix_Linked_Version(void);

typedef enum
{
    MIX_INIT_FLAC        = 0x00000001,
    MIX_INIT_MOD         = 0x00000002,
    MIX_INIT_MP3         = 0x00000004,
    MIX_INIT_OGG         = 0x00000008,
    MIX_INIT_FLUIDSYNTH  = 0x00000010,
    
} MIX_InitFlags;

int Mix_Init(int flags);
void Mix_Quit(void);

enum {
    MIX_CHANNELS	= 8,
};

enum {
    MIX_DEFAULT_FREQUENCY	= 22050,
    MIX_DEFAULT_FORMAT	        = AUDIO_S16LSB,
    MIX_DEFAULT_CHANNELS	= 2,
    MIX_MAX_VOLUME		= 128,
};

typedef struct Mix_Chunk {
	int allocated;
	uint8_t *abuf;
	uint32_t alen;
	uint8_t volume;		/* Per-sample volume, 0-128 */
} Mix_Chunk;

typedef enum {
	MIX_NO_FADING,
	MIX_FADING_OUT,
	MIX_FADING_IN
} Mix_Fading;

typedef enum {
	MUS_NONE,
	MUS_CMD,
	MUS_WAV,
	MUS_MOD,
	MUS_MID,
	MUS_OGG,
	MUS_MP3,
	MUS_MP3_MAD,
	MUS_FLAC,
	MUS_MODPLUG
} Mix_MusicType;

// FIXME! 
typedef struct _Mix_Music Mix_Music;

int Mix_OpenAudio(int frequency, uint16_t format, int channels,
							int chunksize);

int Mix_AllocateChannels(int numchans);

int Mix_QuerySpec(int *frequency,uint16_t *format,int *channels);

Mix_Chunk * Mix_LoadWAV_RW(SDL_RWops *src, int freesrc);

/*
#define Mix_LoadWAV(file)	Mix_LoadWAV_RW(SDL_RWFromFile(file, "rb"), 1)
*/

Mix_Music * Mix_LoadMUS(const char *file);

Mix_Music * Mix_LoadMUS_RW(SDL_RWops *rw);
Mix_Music * Mix_LoadMUSType_RW(SDL_RWops *rw, Mix_MusicType type, int freesrc);

Mix_Chunk * Mix_QuickLoad_WAV(uint8_t *mem);
Mix_Chunk * Mix_QuickLoad_RAW(uint8_t *mem, uint32_t len);

void Mix_FreeChunk(Mix_Chunk *chunk);
void Mix_FreeMusic(Mix_Music *music);

int Mix_GetNumChunkDecoders(void);
const char * Mix_GetChunkDecoder(int index);
int Mix_GetNumMusicDecoders(void);
const char * Mix_GetMusicDecoder(int index);

Mix_MusicType Mix_GetMusicType(const Mix_Music *music);

void Mix_SetPostMix(void (*mix_func)(void *udata, uint8_t *stream, int len), void *arg);

void Mix_HookMusic(void (*mix_func) (void *udata, uint8_t *stream, int len), void *arg);

void Mix_HookMusicFinished(void (*music_finished)(void));

void * Mix_GetMusicHookData(void);
void Mix_ChannelFinished(void (*channel_finished)(int channel));


enum {
    MIX_CHANNEL_POST  = -2,
};

typedef void (*Mix_EffectFunc_t)(int chan, void *stream, int len, void *udata);
typedef void (*Mix_EffectDone_t)(int chan, void *udata);


int Mix_RegisterEffect(int chan, Mix_EffectFunc_t f, Mix_EffectDone_t d, void *arg);

int Mix_UnregisterEffect(int channel, Mix_EffectFunc_t f);
int Mix_UnregisterAllEffects(int channel);

/*
#define MIX_EFFECTSMAXSPEED  "MIX_EFFECTSMAXSPEED"
*/

int Mix_SetPanning(int channel, uint8_t left, uint8_t right);
int Mix_SetPosition(int channel, int16_t angle, uint8_t distance);
int Mix_SetDistance(int channel, uint8_t distance);
int Mix_SetReverseStereo(int channel, int flip);

int Mix_ReserveChannels(int num);
int Mix_GroupChannel(int which, int tag);
int Mix_GroupChannels(int from, int to, int tag);
int Mix_GroupAvailable(int tag);
int Mix_GroupCount(int tag);
int Mix_GroupOldest(int tag);
int Mix_GroupNewer(int tag);

/*
#define Mix_PlayChannel(channel,chunk,loops) Mix_PlayChannelTimed(channel,chunk,loops,-1)
*/

int Mix_PlayChannelTimed(int channel, Mix_Chunk *chunk, int loops, int ticks);
int Mix_PlayMusic(Mix_Music *music, int loops);

int Mix_FadeInMusic(Mix_Music *music, int loops, int ms);
int Mix_FadeInMusicPos(Mix_Music *music, int loops, int ms, double position);

/* 
#define Mix_FadeInChannel(channel,chunk,loops,ms) Mix_FadeInChannelTimed(channel,chunk,loops,ms,-1)
*/

int Mix_FadeInChannelTimed(int channel, Mix_Chunk *chunk, int loops, int ms, int ticks);

int Mix_Volume(int channel, int volume);
int Mix_VolumeChunk(Mix_Chunk *chunk, int volume);
int Mix_VolumeMusic(int volume);

int Mix_HaltChannel(int channel);
int Mix_HaltGroup(int tag);
int Mix_HaltMusic(void);

int Mix_ExpireChannel(int channel, int ticks);

int Mix_FadeOutChannel(int which, int ms);
int Mix_FadeOutGroup(int tag, int ms);
int Mix_FadeOutMusic(int ms);

Mix_Fading Mix_FadingMusic(void);
Mix_Fading Mix_FadingChannel(int which);

void Mix_Pause(int channel);
void Mix_Resume(int channel);
int Mix_Paused(int channel);

void Mix_PauseMusic(void);
void Mix_ResumeMusic(void);
void Mix_RewindMusic(void);
int Mix_PausedMusic(void);

int Mix_SetMusicPosition(double position);

int Mix_Playing(int channel);
int Mix_PlayingMusic(void);

int Mix_SetMusicCMD(const char *command);

int Mix_SetSynchroValue(int value);
int Mix_GetSynchroValue(void);

int Mix_SetSoundFonts(const char *paths);
const char*  Mix_GetSoundFonts(void);
int Mix_EachSoundFont(int (*function)(const char*, void*), void *data);
Mix_Chunk *  Mix_GetChunk(int channel);

void Mix_CloseAudio(void);

/* We will use SDL for reporting errors
#define Mix_SetError	SDL_SetError
#define Mix_GetError	SDL_GetError
*/

]]

-- mark it as nil if not found
else
    debug_print ("Unable to load SDL_mixer\n")
    sdlsumo['mixer'] = nil
end

return sdlsumo
