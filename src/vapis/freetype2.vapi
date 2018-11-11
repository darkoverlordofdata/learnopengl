/* emscripten Vala Bindings
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
 * **********************   *************************************************
 * 
 */
[CCode (cprefix = "", lower_case_cprefix ="", cheader_filename="ft2build.h,freetype/freetype.h")]
namespace Freetype2
{

    [SimpleType] public struct FT_Bool: uchar { }
    [SimpleType] public struct FT_FWord: short { }
    [SimpleType] public struct FT_UFWord: ushort { }
    [SimpleType] public struct FT_Char: char { }
    [SimpleType] public struct FT_Byte: uchar { }
    [SimpleType] public struct FT_Int32: int { }
    [SimpleType] public struct FT_UInt32: uint { }
    [SimpleType] public struct FT_Tag: FT_UInt32 { }
    [SimpleType] public struct FT_String: char { }
    [SimpleType] public struct FT_Short: short { }
    [SimpleType] public struct FT_UShort: ushort { }
    [SimpleType] public struct FT_Int: int { }
    [SimpleType] public struct FT_UInt: uint { }
    [SimpleType] public struct FT_Long: long { }
    [SimpleType] public struct FT_ULong: ulong { }
    [SimpleType] public struct FT_F2Dot14: short { }
    [SimpleType] public struct FT_F26Dot6: long { }
    [SimpleType] public struct FT_Fixed: long { }
    [SimpleType] public struct FT_Error: int { }
    //  [SimpleType] public struct FT_Pointer: void* { }
    [SimpleType] public struct FT_Offset: size_t { }
    [SimpleType] public struct FT_Pos: long { }
    //  [SimpleType] public struct FT_PtrDist: ptrdiff_t { }

    [SimpleType] public struct FT_UnitVector
    { 
        public FT_F2Dot14  x;
        public FT_F2Dot14  y;
    }
    [SimpleType] public struct FT_Matrix
    {
        public FT_Fixed xx;
        public FT_Fixed xy;
        public FT_Fixed yx;
        public FT_Fixed yy;
    }
    [SimpleType] public struct FT_Data
    {
        public FT_Byte* pointer;
        public FT_Int length;
    }

    [SimpleType] public struct FT_Vector
    { 
        public FT_Pos  x;
        public FT_Pos  y;
    }


    public delegate void FT_Generic_Finalizer(void* object);


    [Compact, CCode (cname = "FT_Library", free_function = "FT_Done_FreeType")]
    public class FT_Library { }
	[SimpleType, CCode (cname = "struct FT_LibraryRec_")]
    public struct FT_LibraryRec { }
    
    [Compact, CCode (cname = "FT_Face", free_function = "FT_Done_Face")]
    public class FT_Face {  }
	[SimpleType, CCode (cname = "struct FT_FaceRec_")]
    public struct FT_FaceRec
    { 
        public FT_GlyphSlot      glyph;
    }

    [Compact, CCode (cname = "FT_Glyph", free_function = "FT_Done_Glyph", cheader_filename="freetype/ftglyph.h")]
    public class FT_Glyph 
    { 
        public FT_Bitmap         bitmap;
    }
	[SimpleType, CCode (cname = "struct FT_GlyphRec_", cheader_filename="freetype/ftglyph.h")]
    public struct FT_GlyphRec 
    { 
        public FT_Bitmap         bitmap;
    }

    public bool FT_Glyph_To_Bitmap(  ref FT_Glyph    the_glyph,
                                FT_Render_Mode  render_mode,
                                FT_Vector*      origin,
                                FT_Bool         destroy );

    [CCode (cprefix = "FT_RENDER_MODE_", cname = "int", has_type_id = false)]
    public enum FT_Render_Mode 
    {
        NORMAL = 0,
        LIGHT,
        MONO,
        LCD,
        LCD_V,
        MAX
    }
                            

	[Compact, CCode (cname = "FT_GlyphSlot", free_function = "FT_Done_GlyphSlot")]
    public class FT_GlyphSlot { }
    [SimpleType, CCode (cname = "struct FT_GlyphSlotRec_")]
    public struct FT_GlyphSlotRec
    {
        public FT_Vector         advance;
        public FT_Bitmap         bitmap;
        public FT_Int            bitmap_left;
        public FT_Int            bitmap_top;
    }


	[SimpleType, CCode (cname = "FT_Bitmap")]
    public struct FT_Bitmap 
    { 
        public int rows;
        public int width;
        public int pitch;
        public uchar* buffer;
        public ushort num_grays;
        public uchar pixel_mode;
        public uchar palette_mode;
        public void* palette;
    }

    public const int FT_LOAD_RENDER;
    
    [CCode (cname = "FT_Init_FreeType")]
    public bool FT_Init_FreeType(out FT_Library alibrary);

    [CCode (cname = "FT_New_Face")]
    public bool FT_New_Face(FT_Library library, string filepathname, long face_index, out FT_Face aname);

    [CCode (cname = "FT_Set_Pixel_Sizes")]
    public bool FT_Set_Pixel_Sizes(FT_Face face, uint pixel_width, uint pixel_height);

    [CCode (cname = "FT_Load_Char")]
    public bool FT_Load_Char(FT_Face face, ulong char_code, int32 load_flags);

    [CCode (cname = "FT_Get_Glyph")]
    public bool FT_Get_Glyph(FT_GlyphSlot slot, out FT_Glyph aglyph);

}
