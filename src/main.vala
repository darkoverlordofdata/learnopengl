/*******************************************************************
** This code is part of Breakout.
**
** Breakout is free software: you can redistribute it and/or modify
** it under the terms of the CC BY 4.0 license as published by
** Creative Commons, either version 4 of the License, or (at your
** option) any later version.
******************************************************************/
using GL;
using Glm;
using GLFW3;
using System;
using System.IO;
using System.Collections.Generic;
using Freetype2;

// Properties
#if (__EMSCRIPTEN__)
const int VERSION = 300;
const string PROFILE = "es";
#else
const int VERSION = 300;
const string PROFILE = "es";
#endif
const int WIDTH = 800;
const int HEIGHT = 600;
const string ROOT = "assets/";

public struct IVec2
{
    int X;
    int Y;
}
/// Holds all state information relevant to a character as loaded using FreeType
public struct Character 
{
    uint TextureID;     // ID handle of the glyph texture
    IVec2 Size;         // Size of glyph
    IVec2 Bearing;      // Offset from baseline to left/top of glyph
    long Advance;       // Horizontal offset to advance to next glyph

}

const int GL_RED = 0x1903; // decimal value: 6403
const int GL_ALPHA = 0x1906; // decimal value: 6406
const int GL_LUMINANCE = 0x1909; // decimal value: 6409
const int GL_LUMINANCE_ALPHA = 0x190A; // decimal value: 6410

Dictionary<uchar, Character?> Characters;
uint VAO;
uint VBO;

GLFWwindow* window;
Shader shader;


static int main (string[] args) 
{
    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, VERSION/100);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, (VERSION%100)/10);
    glfwWindowHint(GLFW_RESIZABLE, GL_FALSE);
    glfwWindowHint(GLFW_OPENGL_PROFILE, 
        VERSION < 320 
            ? GLFW_OPENGL_ANY_PROFILE 
            : PROFILE == "core" 
                ? GLFW_OPENGL_CORE_PROFILE 
                : GLFW_OPENGL_COMPAT_PROFILE );

    window = glfwCreateWindow(WIDTH, HEIGHT, "LearnOpenGL", null, null);
    glfwMakeContextCurrent(window);

    glewExperimental = true;
    glewInit();
    glGetError(); 

    // Define the viewport dimensions
    glViewport(0, 0, WIDTH, HEIGHT);

    // Set OpenGL options
    glEnable(GL_CULL_FACE);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    // Compile and setup the shader
    shader = new Shader(VERSION, PROFILE);
    shader.Compile(readTextFile("shaders/text.vs"), readTextFile("shaders/text.frag"));
    var projection = new Mat4();
	glm_ortho(0f, (float)WIDTH, 0f, (float)HEIGHT, 0f, 1f, projection);
    shader.Use();
    shader.SetMatrix4("projection", projection);

    Characters = new Dictionary<uchar, Character?>();
    FT_Library ft;
    // All functions return a value different than 0 whenever an error occurred
    if (FT_Init_FreeType(out ft))
        print("ERROR::FREETYPE: Could not init FreeType Library");

    // Load font as face
    FT_Face face;
    if (FT_New_Face(ft, "assets/fonts/LiberationSansBold.ttf", 0, out face))
        print("ERROR::FREETYPE: Failed to load font");

    // Set size to load glyphs as
    FT_Set_Pixel_Sizes(face, 0, 48);

    // Disable byte-alignment restriction
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1); 

    //FT_Bitmap_Convert(ftLib, &face->glyph->bitmap, &bitmap, 4);

    // Load first 128 characters of ASCII set
    for (uchar c = 0; c < 128; c++)
    {
        // Load character glyph 
        if (FT_Load_Char(face, c, FT_LOAD_RENDER))
        {
            print("ERROR::FREETYTPE: Failed to load Glyph");
            continue;
        }
        // Generate texture
        uint texture = 0;
        glGenTextures(1, &texture);
        glBindTexture(GL_TEXTURE_2D, texture);

        var glyph = (FT_GlyphSlotRec*)((FT_FaceRec*)face)->glyph;
        glTexImage2D(
            GL_TEXTURE_2D,
            0,
            GL_RED,
            (GLsizei)glyph.bitmap.width,
            (GLsizei)glyph.bitmap.rows,
            0,
            GL_RED,
            GL_UNSIGNED_BYTE,
            (void*)glyph.bitmap.buffer
        );

        // FT_Glyph aglyph;
        // var error = FT_Get_Glyph( ((FT_FaceRec*)face)->glyph, out aglyph );
        // FT_Glyph_To_Bitmap(ref aglyph, FT_Render_Mode.NORMAL, null, 0);

        // glTexImage2D(
        //     GL_TEXTURE_2D,
        //     0,
        //     GL_RGB,
        //     (GLsizei)glyph.bitmap.width,
        //     (GLsizei)glyph.bitmap.rows,
        //     0,
        //     GL_RGB,
        //     GL_UNSIGNED_INT,
        //     (void*)aglyph.bitmap
        // );
        

        // Set texture options
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        // Now store character for later use
        IVec2 size = { glyph.bitmap.width, glyph.bitmap.rows };
        IVec2 bearing = { glyph.bitmap_left, glyph.bitmap_top };
        Character character = { texture, size, bearing, glyph.advance.x };
        Characters[c] = character;
    }
    glBindTexture(GL_TEXTURE_2D, 0);
    // Destroy FreeType once we're finished

    
    // Configure VAO/VBO for texture quads
    glGenVertexArrays(1, &VAO);
    glGenBuffers(1, &VBO);
    glBindVertexArray(VAO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * 6 * 4, null, GL_DYNAMIC_DRAW);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, (int)(4 * sizeof(GLfloat)), (void*)0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);

    #if (__EMSCRIPTEN__)
    Emscripten.set_main_loop(() => Update(), -1, 0);
    #else
    while (!glfwWindowShouldClose(window)) Update();
    glfwTerminate();
    #endif
    return 0;

}

public void Update()
{
    // Game loop
    #if (!__EMSCRIPTEN__)
    if (glfwGetKey(window, Key.ESCAPE) == ButtonState.PRESS)
    {
        glfwSetWindowShouldClose(window, GL_TRUE);
    }
    #endif
    // Check and call events
    glfwPollEvents();

    // Clear the colorbuffer
    glClearColor(0.2f, 0.3f, 0.3f, 1f);
    glClear(GL_COLOR_BUFFER_BIT);

    // print("This is sample text\n");
    // print("(C) LearnOpenGL.com\n");
    RenderText(shader, "This is sample text", 25f, 25f, 1f, new Vec3(0.5f, 0.8f, 0.2f));
    RenderText(shader, "(C) LearnOpenGL.com", 540f, 570f, 0.5f, new Vec3(0.3f, 0.7f, 0.9f));
    
    // Swap the buffers
    glfwSwapBuffers(window);



}

void RenderText(Shader shader, string text, float x, float y, float scale, Vec3 color)
{
    // Activate corresponding render state	
    shader.Use();
    glUniform3f(glGetUniformLocation(shader.ID, "textColor"), color.X, color.Y, color.Z);
    glActiveTexture(GL_TEXTURE0);
    glBindVertexArray(VAO);

    // Iterate through all characters
    // for (c = text.begin(); c != text.end(); c++) 
    for (var i=0; i<text.length; i++)
    {
        var c = text[i];
        Character ch = Characters[c];

        float xpos = x + ch.Bearing.X * scale;
        float ypos = y - (ch.Size.Y - ch.Bearing.Y) * scale;

        float w = ch.Size.X * scale;
        float h = ch.Size.Y * scale;
        // Update VBO for each character
        float[] vertices = {
            xpos,     ypos + h,   0f, 0f,            
            xpos,     ypos,       0f, 1f,
            xpos + w, ypos,       1f, 1f,

            xpos,     ypos + h,   0f, 0f,
            xpos + w, ypos,       1f, 1f,
            xpos + w, ypos + h,   1f, 0f           
        };
        // Render glyph texture over quad
        glBindTexture(GL_TEXTURE_2D, ch.TextureID);
        // Update content of VBO memory
        glBindBuffer(GL_ARRAY_BUFFER, VBO);
        glBufferSubData(GL_ARRAY_BUFFER, 0, vertices.length*sizeof(float), vertices); // Be sure to use glBufferSubData and not glBufferData

        glBindBuffer(GL_ARRAY_BUFFER, 0);
        // Render quad
        glDrawArrays(GL_TRIANGLES, 0, 6);
        // Now advance cursors for next glyph (note that advance is number of 1/64 pixels)
        x += (ch.Advance >> 6) * scale; // Bitshift by 6 to get value in pixels (2^6 = 64 (divide amount of 1/64th pixels by 64 to get amount of pixels))
    }
    glBindVertexArray(0);
    glBindTexture(GL_TEXTURE_2D, 0);
}

string? readTextFile(string path)
{
    string? line = null;
    string? text = "";
    var frag_file = new FileHandle(ROOT+path);
    var frag_reader = new BufferedReader(
                        new InputStreamReader(
                            new FileInputStream.FromFile(frag_file.file)));

    do 
    {
        line = frag_reader.ReadLine();
        text = text + line+"\n";
    } while (line != null);
    return text;
}
