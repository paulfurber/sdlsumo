require 'pl'
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
