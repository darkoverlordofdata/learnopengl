#include <stdio.h>
#include <stdlib.h>
/**
 * STB Library includes
 */
#define STB_IMAGE_IMPLEMENTATION
#include "stb/stb_image.h"
#define STB_TRUETYPE_IMPLEMENTATION
#include "stb/stb_truetype.h"

unsigned char* stb_load_font(char* path, char* word, int b_w, int b_h, int l_h)
{
    long size;
    unsigned char* ttf_buffer;
    FILE* fontFile = fopen(path, "rb");
    fseek(fontFile, 0, SEEK_END);
    size = ftell(fontFile); /* how long is the file ? */
    fseek(fontFile, 0, SEEK_SET); /* reset */
    ttf_buffer = malloc(size);
    
    fread(ttf_buffer, size, 1, fontFile);
    fclose(fontFile);

    /* prepare font */
    // stbtt_fontinfo* &info = malloc(sizeof(stbtt_fontinfo));
    stbtt_fontinfo info;
    if (!stbtt_InitFont(&info, ttf_buffer, stbtt_GetFontOffsetForIndex(ttf_buffer,0)))
    {
        printf("failed\n");
    }
    // int b_w = 512; /* bitmap width */
    // int b_h = 128; /* bitmap height */
    // int l_h = 128; /* line height */

    /* create a bitmap for the phrase */
    unsigned char* bitmap = malloc(b_w * b_h);
    
    /* calculate font scaling */
    float scale = stbtt_ScaleForPixelHeight(&info, l_h);

    int x = 0;
       
    int ascent, descent, lineGap;
    stbtt_GetFontVMetrics(&info, &ascent, &descent, &lineGap);
    
    ascent *= scale;
    descent *= scale;
    
    int i;
    for (i = 0; i < strlen(word); ++i)
    {
        /* get bounding box for character (may be offset to account for chars that dip above or below the line */
        int c_x1, c_y1, c_x2, c_y2;
        stbtt_GetCodepointBitmapBox(&info, word[i], scale, scale, &c_x1, &c_y1, &c_x2, &c_y2);
        
        /* compute y (different characters have different heights */
        int y = ascent + c_y1;
        
        /* render character (stride and offset is important here) */
        int byteOffset = x + (y  * b_w);
        stbtt_MakeCodepointBitmap(&info, bitmap + byteOffset, c_x2 - c_x1, c_y2 - c_y1, b_w, scale, scale, word[i]);
        
        /* how wide is this character */
        int ax;
        stbtt_GetCodepointHMetrics(&info, word[i], &ax, 0);
        x += ax * scale;
        
        /* add kerning */
        int kern;
        kern = stbtt_GetCodepointKernAdvance(&info, word[i], word[i + 1]);
        x += kern * scale;
    }
    free(ttf_buffer);
    return bitmap;

}

