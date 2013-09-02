#SDLSumo

##Rationale

SDLSumo is a single file ffi binding to Luajit 2.0.x for SDL-1.2.15, SDL_Image-1.2.12,
SDL_Mixer-1.2.15 and SDL_TTF-2.0.11. SDL_TTF is wrapped in a very similar API called
STT (Sumo TrueType) that avoids the rabbit hole complexity of the freetype
headers. 

SDLSumo solves Luajit's limitation in that files containing ffi.cdef
declarations may not be required more than once (otherwise
redefinition errors occur). By keeping things to a single file, all
dependencies are included in one shot.

##Requirements
Luajit 2.0.x
SDL-1.2.15

Optional (even though this is the whole point of SDLSumo - to
be able to use all the SDL libraries you want from Luajit):

SDL_ttf-2.0.x
SDL_mixer-1.2.15
SDL_image-1.2.12

##Usage

The SDLSumo module returns a table of Luajit references to dynamic
libraries indexed by name. If the library could not be loaded, the
table entry will be nil. SDL itself is required obviously but no other
combination of the others is required. I chose the combination of
these four because it seems to be the most useful.

    local ffi = require 'ffi'
    local sumo = require 'sdlsumo'

    if sumo['sdl'] then
       print ("Loaded SDL")
    end
    if sumo['stt'] then
        print ("Loaded STT")
    end
    if sumo['image'] then
        print ("Loaded SDL_image")
    end
    if sumo['mixer'] then
        print ("Loaded SDL_mixer")
    end

    local sdl=sumo['sdl']
    local stt=sumo['stt']

    sdl.SDL_Init(sdl.SDL_INIT_VIDEO)
    local screen = sdl.SDL_SetVideoMode(1024,768,sdl.SDL_SWSURFACE, 32)

    stt.STT_Init()
    local font = stt.STT_OpenFont("/usr/share/fonts/truetype/ttf-dejavu/DejaVuSansMono.ttf", 48)

    local color = ffi.new("SDL_Color")
    color.r = 0xFF
    color.g = 0x00
    color.b = 0x00

    local text = stt.STT_RenderText_Blended(font, "Welcome to sdlsumo!", color)
    stt.STT_CloseFont(font)

    sdl.SDL_UpperBlit(text, nil, screen, nil)

    sdl.SDL_Flip(screen)

    io.read("*l")

    stt.STT_Quit()
    sdl.SDL_Quit()

##Installation

    cd libstt
    sudo make install
    cd ../lua
    cp sdlsumo.lua /your/lua5.1/module/path

##Issues

STT is unfinished. SDL_Mixer is untested. Coming soon.

I'm a beginner at Lua - there could well be hacks and bad practices. 
Let me know please.

##Thanks

Dimiter "malkia" Stanev for UFO - a superb all-singing, all-dancing
Luajit ffi library. Check it out at http://github.com/malkia/ufo
SDLSumo's SDL bindings are pinched lock, stock and barrel from here.

Steve Donovan, author of the Penlight Lua libraries
(http://github.com/stevedonovan/Penlight). He's a great Lua programmer 
and he lives in my town. What are the odds? 

(SDLSumo does not depend on Penlight - I just continue to learn lots from
reading it and using it.)

