require 'pl'
local ffi = require 'ffi'
package.path = "../lua/?.lua;" .. package.path

local sumo = require 'sdlsumo'

if sumo['sdl'] then
    print ("Loaded SDL")
end

if sumo['ttf'] then
    print ("Loaded SDL_ttf")
end

if sumo['image'] then
    print ("Loaded SDL_image")
end

if sumo['mixer'] then
    print ("Loaded SDL_mixer")
end

local sdl=sumo['sdl']
local ttf=sumo['ttf']


sdl.SDL_Init(sdl.SDL_INIT_VIDEO)
local screen = sdl.SDL_SetVideoMode(1024,768,sdl.SDL_SWSURFACE, 32)

local font = ffi.new("TTF_Font")
font = ttf.TTF_OpenFont("/usr/share/fonts/truetype/ttf-dejavu/DejaVuSansMono.ttf", 48)


ttf.TTF_SetFontStyle(font,ttf.TTF_STYLE_NORMAL)

ttf.TTF_SetFontOutline(font, 0)
ttf.TTF_SetFontHinting(font, ttf.TTF_HINTING_NORMAL)
ttf.TTF_SetFontKerning(font, 1)



Color = ffi.metatype("SDL_Color", {})
color = Color(0xFF, 0x00, 0x00, 0)

text = ttf.TTF_RenderText_Blended(font, "Welcome to sdlsumo!", color)


sdl.SDL_BLit(text, 0, screen, 0)

sdl.SDL_UpdateRects()

io.read("*l")

sdl.SDL_Quit()
