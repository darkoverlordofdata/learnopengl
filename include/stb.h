#ifndef _STB_H_
#define _STB_H_

#include "stb/stb_image.h"
#include "stb/stb_truetype.h"

unsigned char* stb_load_font(char* path, char* word, int b_w, int b_h, int l_h);

#endif // _STB_H_
