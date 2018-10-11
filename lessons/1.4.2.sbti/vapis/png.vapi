/* libpng Vala Bindings
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
#if (__EMSCRIPTEN__) 
[CCode (cprefix = "", lower_case_cprefix ="", cheader_filename="png.h")]
#else
[CCode (cprefix = "", lower_case_cprefix ="", cheader_filename="libpng16/png.h")]
#endif
namespace Png
{

    public const string PNG_LIBPNG_VER_STRING;
    public const int PNG_TRANSFORM_STRIP_16;
    public const int PNG_TRANSFORM_PACKING;
    public const int PNG_TRANSFORM_EXPAND;

    [CCode (has_target = false)]
    public delegate void png_error_ptr(Image p, char* c);

    [Compact]
    [CCode(cname = "png_infop", free_function = "")]
    public class Info { } 


    [Compact]
    [CCode(cname = "png_structp", free_function = "")]
    public class Image 
    { 
        [CCode(cname="png_create_read_struct")]
        public Image(
            char* user_png_ver = PNG_LIBPNG_VER_STRING, 
            void* error_ptr = null, 
            png_error_ptr? error_fn = null, 
            png_error_ptr? warn_fn = null
        );

        [CCode(cname="png_create_info_struct")]
        public Info CreateInfo();

        [CCode(cname="png_init_io")]
        public void InitIo(
            Stdio.FILE? fp
        );

        [CCode(cname="png_set_sig_bytes")]
        public void SetSigBytes(
            int num_bytes
        );

        [CCode(cname="png_read_png")]
        public void Read(
            Info info, 
            int transforms, 
            void* params
        );

        [CCode(cname="png_get_IHDR")]
        public uint32 GetIhdr(
            Info info,
            uint32* width,
            uint32* height,
            int* bit_depth,
            int* colorType,
            int* interlace_method,
            int* compression_method,
            int* filter_method
        );

        [CCode(cname="png_get_rowbytes")]
        public uint32 GetRowbytes(
            Info info
        );

        [CCode(cname="png_get_rows")]
        public uchar** GetRows(
            Info info
        );

    } 



    public void png_destroy_read_struct(
        Image? png_pp, 
        Info? info_pp, 
        Info? end_info
    );



    public bool LoadPngImage(
        string name, 
        ref int outWidth, 
        ref int outHeight, 
        ref bool outHasAlpha, 
        ref uchar *outData
    ) {
        Image png;
        Info info;
        int sigRead = 0;
        int colorType, interlaceType;
        Stdio.FILE? fp;
        
        if ((fp = Stdio.FILE.open(name, "rb")) == null) {
            GLib.print("file %s not found\n", name);
            return false;
        }
        
        /* Create and initialize the png_struct
        * with the desired error handler
        * functions.  If you want to use the
        * default stderr and longjump method,
        * you can supply null for the last
        * three parameters.  We also supply the
        * the compiler header file version, so
        * that we know if the application
        * was compiled with a compatible version
        * of the library.  REQUIRED
        */
        png = new Image();
        
        if (png == null) {
            fp = null;
            return false;
        }
        
        /* Allocate/initialize the memory
        * for image information.  REQUIRED. */
        info = png.CreateInfo();
        if (info == null) {
            fp = null;
            png_destroy_read_struct(png, null, null);
            return false;
        }
        
        /* Set error handling if you are
        * using the setjmp/longjmp method
        * (this is the normal method of
        * doing things with libpng).
        * REQUIRED unless you  set up
        * your own error handlers in
        * the png_create_read_struct()
        * earlier.
        */
        // try {
        //     /* Free all of the memory associated
        //     * with the png and info */
        //     png_destroy_read_struct(&png, &info, null);
        //     fp = null;
        //     /* If we get here, we had a
        //     * problem reading the file */
        //     return false;
        // } catch (GLib.Error e) {
        //     GLib.print("%s", e.message);
        //     throw e;
        // }

        
        /* Set up the output control if
        * you are using standard C streams */
        png.InitIo(fp);
        
        /* If we have already
        * read some of the signature */
        png.SetSigBytes(sigRead);
        
        /*
        * If you have enough memory to read
        * in the entire image at once, and
        * you need to specify only
        * transforms that can be controlled
        * with one of the PNG_TRANSFORM_*
        * bits (this presently excludes
        * dithering, filling, setting
        * background, and doing gamma
        * adjustment), then you can read the
        * entire image (including pixels)
        * into the info structure with this
        * call
        *
        * PNG_TRANSFORM_STRIP_16 |
        * PNG_TRANSFORM_PACKING  forces 8 bit
        * PNG_TRANSFORM_EXPAND forces to
        *  expand a palette into RGB
        */
        png.Read(info, PNG_TRANSFORM_STRIP_16 | PNG_TRANSFORM_PACKING | PNG_TRANSFORM_EXPAND, null);
        
        uint32 width, height;
        int bit_depth;
        png.GetIhdr(info, &width, &height, &bit_depth, &colorType,
                    &interlaceType, null, null);
        outWidth = (int)width;
        outHeight = (int)height;
        
        uint row_bytes = png.GetRowbytes(info);
        uchar* data = (uchar*) GLib.malloc(row_bytes * outHeight);

        GLib.print("data = %d\n", (int)data);        
        uchar** row_pointers = png.GetRows(info);
        
        uchar* src;
        uchar* dst;

        GLib.print("row_bytes = %d", (int)row_bytes);
        GLib.print("w=%d, h=%d\n", (int)width, (int)height);

        uint baseAddress = (uint)data;
        GLib.print("sizeof = %d\n", (int)sizeof(uchar*));

        for (int i = 0; i < outHeight; i++) {
            // note that png is ordered top to
            // bottom, but OpenGL expect it bottom to top
            // so the order or swapped
            src = row_pointers[i];
            dst = (uchar*)(baseAddress+(row_bytes * (outHeight-1-i)));

            GLib.Memory.set(dst, 0, row_bytes);
            GLib.Memory.copy(dst, src, row_bytes);
        }
        outData = data;
        /* Clean up after the read,
        * and free any memory allocated */
        png_destroy_read_struct(png, info, null);
        
        /* Close the file */
        fp = null;
        
        /* That's it */
        return true;
    }

}