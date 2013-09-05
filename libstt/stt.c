/*
    SDLSumo - Simple DirectMedia Layer 1.2.15 Luajit binding
    Copyright (C) 2013 Paul Furber

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

    Paul Furber
    paul.furber@gmail.com
*/

#include <SDL.h>
#include <SDL_ttf.h>


#define STT_FONT_POOL_SIZE 256

// an array of pointers to TTF_Fonts accessed by handle
TTF_Font *font_pool[STT_FONT_POOL_SIZE];

typedef struct _STT_Font {

        Uint32 handle;

} STT_Font;

#define SDL_TTF_MAJOR_VERSION   2 
#define SDL_TTF_MINOR_VERSION   0
#define SDL_TTF_PATCHLEVEL	11

#define  UNICODE_BOM_NATIVE	0xFEFF
#define  UNICODE_BOM_SWAPPED	0xFFFE


#define  TTF_STYLE_NORMAL	0x00
#define  TTF_STYLE_BOLD		0x01
#define  TTF_STYLE_ITALIC	0x02
#define  TTF_STYLE_UNDERLINE	0x04
#define  TTF_STYLE_STRIKETHROUGH 0x08

#define  TTF_HINTING_NORMAL     0
#define  TTF_HINTING_LIGHT      1
#define  TTF_HINTING_MONO       2
#define  TTF_HINTING_NONE       3

int  STT_Init(void);

STT_Font *  STT_OpenFont(const char *file, int ptsize);

/*
STT_Font *  STT_OpenFontIndex(const char *file, int ptsize, long index);
STT_Font *  STT_OpenFontRW(SDL_RWops *src, int freesrc, int ptsize);
STT_Font *  STT_OpenFontIndexRW(SDL_RWops *src, int freesrc, int ptsize, long index);
*/

/*
int  STT_GetFontStyle(const STT_Font *font);
void  STT_SetFontStyle(STT_Font *font, int style);
int  STT_GetFontOutline(const STT_Font *font);
void  STT_SetFontOutline(STT_Font *font, int outline);
*/

/*
int  STT_GetFontHinting(const STT_Font *font);
void  STT_SetFontHinting(STT_Font *font, int hinting);
*/

/*
int  STT_FontHeight(const STT_Font *font);
int  STT_FontAscent(const STT_Font *font);
int  STT_FontDescent(const STT_Font *font);
int  STT_FontLineSkip(const STT_Font *font);
int  STT_GetFontKerning(const STT_Font *font);
void  STT_SetFontKerning(STT_Font *font, int allowed);
long  STT_FontFaces(const STT_Font *font);
int  STT_FontFaceIsFixedWidth(const STT_Font *font);
char *  STT_FontFaceFamilyName(const STT_Font *font);
char *  STT_FontFaceStyleName(const STT_Font *font);
int  STT_GlyphIsProvided(const STT_Font *font, uint16_t ch);
int  STT_GlyphMetrics(STT_Font *font, uint16_t ch,
				     int *minx, int *maxx,
                                     int *miny, int *maxy, int *advance);

int  STT_SizeText(STT_Font *font, const char *text, int *w, int *h);
int  STT_SizeUTF8(STT_Font *font, const char *text, int *w, int *h);
int  STT_SizeUNICODE(STT_Font *font, const uint16_t *text, int *w, int *h);

*/

SDL_Surface *  STT_RenderText_Solid(STT_Font *font,
		                    const char *text, SDL_Color fg);

/* SDL_Surface *  STT_RenderUTF8_Solid(STT_Font *font, */
/* 				const char *text, SDL_Color fg); */
/* SDL_Surface *  STT_RenderUNICODE_Solid(STT_Font *font, */
/* 				const uint16_t *text, SDL_Color fg); */

/* SDL_Surface *  STT_RenderGlyph_Solid(STT_Font *font, */
/* 					uint16_t ch, SDL_Color fg); */

/* SDL_Surface *  STT_RenderText_Shaded(STT_Font *font, */
/* 				const char *text, SDL_Color fg, SDL_Color bg); */
/* SDL_Surface *  STT_RenderUTF8_Shaded(STT_Font *font, */
/* 				const char *text, SDL_Color fg, SDL_Color bg); */
/* SDL_Surface *  STT_RenderUNICODE_Shaded(STT_Font *font, */
/* 				const uint16_t *text, SDL_Color fg, SDL_Color bg); */
/* SDL_Surface *  STT_RenderGlyph_Shaded(STT_Font *font, */
/* 				uint16_t ch, SDL_Color fg, SDL_Color bg); */

SDL_Surface *  STT_RenderText_Blended(STT_Font *font,
				const char *text, SDL_Color fg);

/* SDL_Surface *  STT_RenderUTF8_Blended(STT_Font *font, */
/* 				const char *text, SDL_Color fg); */
/* SDL_Surface *  STT_RenderUNICODE_Blended(STT_Font *font, */
/* 				const uint16_t *text, SDL_Color fg); */

/* SDL_Surface *  STT_RenderGlyph_Blended(STT_Font *font, */
/* 						uint16_t ch, SDL_Color fg); */

void  STT_CloseFont(STT_Font *font);
void  STT_Quit(void);
int  STT_WasInit(void);


/* int STT_GetFontKerningSize(STT_Font *font, int prev_index, int index); */

Uint32 STT_get_handle() 
{

        Uint32 i;

        for (i=0; i<STT_FONT_POOL_SIZE; i++) {

                if (font_pool[i] == NULL) {
                        return i;
                }
        }

        fprintf (stderr, "Font pool exhausted\n");
        return (-1);
}

STT_Font *STT_Font_new()
{
        STT_Font *font = (STT_Font *)malloc(sizeof(STT_Font));
        if (font == NULL) {
                fprintf (stderr, "Unable to allocate font\n");
                return NULL;
        }
        font->handle = STT_get_handle();    
        return font;
}

int STT_Init(void)
{
        return TTF_Init();
}
        
STT_Font * STT_OpenFont(const char *file, int ptsize)
{
        TTF_Font *ttf_font;
        STT_Font *font = STT_Font_new();
        
        ttf_font = TTF_OpenFont(file, ptsize);
        if (ttf_font == NULL) {
                fprintf (stderr, "Unable to open font\n");
                return (NULL);
        }
        // Some lazy defaults
        TTF_SetFontStyle(ttf_font, TTF_STYLE_NORMAL);
	TTF_SetFontOutline(ttf_font, 0); 
	TTF_SetFontKerning(ttf_font, 1); 
	TTF_SetFontHinting(ttf_font, TTF_HINTING_NORMAL); 
        
        font_pool[font->handle] = ttf_font;
        return font;
}

SDL_Surface *  STT_RenderText_Solid(STT_Font *font,
		                    const char *text, SDL_Color fg)
{
        return TTF_RenderText_Solid(font_pool[font->handle], text, fg);
}

SDL_Surface *  STT_RenderText_Blended(STT_Font *font,
                                      const char *text, SDL_Color fg)
{
        return TTF_RenderText_Blended(font_pool[font->handle], text, fg);
}


void STT_CloseFont(STT_Font *font)
{
        TTF_CloseFont(font_pool[font->handle]);
        font_pool[font->handle] = NULL;
        free (font);
}

void STT_Quit(void)
{
        TTF_Quit();

}

int STT_WasInit(void)
{
        return TTF_WasInit();
}
