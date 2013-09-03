--require 'pl'
--require 'pl.utils'

local ffi = require 'ffi'
package.path = "../lua/?.lua;" .. package.path

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
local image=sumo['image']


sdl.SDL_Init(sdl.SDL_INIT_VIDEO)
local screen = sdl.SDL_SetVideoMode(1280, 720, 32, sdl.SDL_SWSURFACE)

local bg = image.IMG_Load("bg720.png")
sdl.SDL_UpperBlit(bg, nil, screen, nil)


stt.STT_Init()
local font = stt.STT_OpenFont("/usr/share/fonts/truetype/ttf-dejavu/DejaVuSansMono.ttf", 48)

local color = ffi.new("SDL_Color")
color.r = 0xFF
color.g = 0xFF
color.b = 0xFF

local text = stt.STT_RenderText_Blended(font, "Welcome to sdlsumo!", color)
stt.STT_CloseFont(font)

sdl.SDL_UpperBlit(text, nil, screen, nil)

sdl.SDL_Flip(screen)

local event = ffi.new("SDL_Event")

while event.type ~= sdl.SDL_QUIT do

    if sdl.SDL_PollEvent(event) > 0 then
        local sym, mod = event.key.keysym.sym, event.key.keysym.mod
        if event.type == sdl.SDL_KEYUP then
            if sym == sdl.SDLK_ESCAPE then
                event.type = sdl.SDL_QUIT
                sdl.SDL_PushEvent( event )
            end
        end
    end
end


stt.STT_Quit()
sdl.SDL_Quit()
