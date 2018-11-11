/* stb Vala Bindings
 * Copyright (c) 2018 Bruce Davidspn <darkoverlordofdata@gmail.com>
 * 
 * ***********************************************************************
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ***********************************************************************
 * 
 */
[CCode (lower_case_cprefix ="stbi_", cheader_filename="stb.h")]
namespace Stb
{
    public IntPtr load (string filename, out int width, out int height, out int channels_in_file, int desired_channels);
    public void image_free (void* retval_from_stbi_load);
    public void set_flip_vertically_on_load (int flag_true_if_should_flip);

    [CCode (cname = "stb_load_font")]
    public IntPtr load_font(char* path, char* word, int b_w, int b_h, int l_h);


    //  [Contact, CCode (cprefix = "stbtt_", cname = "stbtt_fontinfo", unref_function = "", cheader_filename="stb/stb_truetype.h")]
    //  public class Font : IntPtr 
    //  { 
    //      public void* userdata;
    //      public uchar* data;
    //      public int fontstart;
    //      public int numGlyphs;
    //      public int loca;
    //      public int head;
    //      public int glyf;
    //      public int hhea;
    //      public int hmtx;
    //      public int kern;
    //      public int gpos;
    //      public int index_map;
    //      public int indexToLocFormat;
    //      public stbtt__buf cff;                    // cff font data
    //      public stbtt__buf charstrings;            // the charstring index
    //      public stbtt__buf gsubrs;                 // global charstring subroutines index
    //      public stbtt__buf subrs;                  // private charstring subroutines index
    //      public stbtt__buf fontdicts;              // array of font dicts
    //      public stbtt__buf fdselect;               // map from glyph to fontdict

    //  }

    //  [SimpleType]
    //  [CCode (cname = "stbtt_fontinfo")]
    //  public struct stbtt_fontinfo { } 

    //  [SimpleType]
    //  [CCode (cname = "stbtt__buf")]
    //  public struct stbtt__buf
    //  {
    //      public uchar *data;
    //      public int cursor;
    //      public int size;
    //  }


    //  [CCode (cname = "stbtt_InitFont")]
    //  public bool InitFont(stbtt_fontinfo *info, uchar *data, int offset);
    //  public float ScaleForPixelHeight(stbtt_fontinfo *info, float pixels);
    //  public void GetFontVMetrics(stbtt_fontinfo *info, int *ascent, int *descent, int *lineGap);    
    //  public void GetCodepointBitmapBox(stbtt_fontinfo *font, int codepoint, float scale_x, float scale_y, int *ix0, int *iy0, int *ix1, int *iy1);
    //  public void MakeCodepointBitmap(stbtt_fontinfo *info, uchar *output, int out_w, int out_h, int out_stride, float scale_x, float scale_y, int codepoint);
    //  public void GetCodepointHMetrics(stbtt_fontinfo *info, int codepoint, int *advanceWidth, int *leftSideBearing);
    //  public int GetCodepointKernAdvance(stbtt_fontinfo *info, int ch1, int ch2);



}