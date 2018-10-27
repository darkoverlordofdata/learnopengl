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
[CCode (lower_case_cprefix ="stbi_", cheader_filename="stb/stb_image.h,stb/stb_truetype.h")]
namespace Stb
{
    [Compact, CCode(cname = "stbi_uc", free_function = "stbi_image_free")]
    public class Image : IntPtr
    { 
        [CCode (cname = "stbi_set_flip_vertically_on_load")]
        public static void FlipVertically (int flip);
        [CCode (cname = "stbi_load")]
        public static Image Load (string filename, out int width, out int height, out int channels_in_file, int desired_channels = 0);
        [CCode (cname = "stbi_image_free")]
        public void Dispose ();

    }
    public IntPtr load (string filename, out int width, out int height, out int channels_in_file, int desired_channels);
    public void image_free (void* retval_from_stbi_load);
    public void set_flip_vertically_on_load (int flag_true_if_should_flip);


    [Contact, CCode (cprefix = "stbtt_", cname = "stbtt_fontinfo", unref_function = "", cheader_filename="stb/stb_truetype.h")]
    public class Font : IntPtr 
    { 
        public void* userdata;
        public uchar* data;
        public int fontstart;
        public int numGlyphs;
        public int loca;
        public int head;
        public int glyf;
        public int hhea;
        public int hmtx;
        public int kern;
        public int gpos;
        public int index_map;
        public int indexToLocFormat;
        public stbtt__buf cff;                    // cff font data
        public stbtt__buf charstrings;            // the charstring index
        public stbtt__buf gsubrs;                 // global charstring subroutines index
        public stbtt__buf subrs;                  // private charstring subroutines index
        public stbtt__buf fontdicts;              // array of font dicts
        public stbtt__buf fdselect;               // map from glyph to fontdict

        public static Font Create (string path)
        {
            Stdio.Stat buf;
            Stdio.FILE fontFile = Stdio.FILE.open(path, "rb");
            Stdio.fstat(fontFile.fileno(), out buf);
            long size = (long)buf.st_size;
            char* ttf_buffer = new char[size];
            fontFile.read(ttf_buffer, 1, size);
            stbtt_fontinfo* tmp = (stbtt_fontinfo*)GLib.malloc(sizeof(stbtt_fontinfo));
            InitFont(tmp, ttf_buffer, 0);
            Font font;
            GLib.Memory.copy(&font, &tmp, 8);
            return font;
        }
        public float ScaleForPixelHeight (float pixels);
        public void GetFontVMetrics (int *ascent, int *descent, int *lineGap);    
        public void GetCodepointBitmapBox (int codepoint, float scale_x, float scale_y, int *ix0, int *iy0, int *ix1, int *iy1);
        public void MakeCodepointBitmap (uchar *output, int out_w, int out_h, int out_stride, float scale_x, float scale_y, int codepoint);
        public void GetCodepointHMetrics (int codepoint, int *advanceWidth, int *leftSideBearing);
        public int GetCodepointKernAdvance (int ch1, int ch2);

        public uchar* CreateBitmap(string text, int w, int h, int l)
        {
            uchar* bitmap = GLib.malloc(w * h);

            float scale = ScaleForPixelHeight(l);
            GLib.print("scale = %f\n", scale);
            int x = 0;
            int ascent, descent, lineGap;
            GetFontVMetrics(&ascent, &descent, &lineGap);
            ascent = (int)(ascent * scale);
            descent = (int)(descent * scale);
            int i;
            for (i = 0; i < text.length; ++i)
            {
                /* get bounding box for character (may be offset to account for chars that dip above or below the line */
                int c_x1, c_y1, c_x2, c_y2;
                GetCodepointBitmapBox(text[i], scale, scale, &c_x1, &c_y1, &c_x2, &c_y2);
                
                /* compute y (different characters have different heights */
                int y = ascent + c_y1;
                
                /* render character (stride and offset is important here) */
                int byteOffset = x + (y  * w);
                MakeCodepointBitmap(bitmap + byteOffset, c_x2 - c_x1, c_y2 - c_y1, w, scale, scale, text[i]);
                
                /* how wide is this character */
                int ax;
                int lsb = 0;
                GetCodepointHMetrics(text[i], &ax, &lsb);
                x = x + (int)(ax * scale);
                
                /* add kerning */
                int kern;
                kern = GetCodepointKernAdvance(text[i], text[i + 1]);
                x = x + (int)(kern * scale);
            }
            return bitmap;
        }
    }

    [SimpleType]
    [CCode (cname = "stbtt_fontinfo")]
    public struct stbtt_fontinfo { } 

    [SimpleType]
    [CCode (cname = "stbtt__buf")]
    public struct stbtt__buf
    {
        public uchar *data;
        public int cursor;
        public int size;
    }


    public int InitFont(stbtt_fontinfo *info, uchar *data, int offset);
    //  public float ScaleForPixelHeight(stbtt_fontinfo *info, float pixels);
    //  public void GetFontVMetrics(stbtt_fontinfo *info, int *ascent, int *descent, int *lineGap);    
    //  public void GetCodepointBitmapBox(stbtt_fontinfo *font, int codepoint, float scale_x, float scale_y, int *ix0, int *iy0, int *ix1, int *iy1);
    //  public void MakeCodepointBitmap(stbtt_fontinfo *info, uchar *output, int out_w, int out_h, int out_stride, float scale_x, float scale_y, int codepoint);
    //  public void GetCodepointHMetrics(stbtt_fontinfo *info, int codepoint, int *advanceWidth, int *leftSideBearing);
    //  public int GetCodepointKernAdvance(stbtt_fontinfo *info, int ch1, int ch2);



}