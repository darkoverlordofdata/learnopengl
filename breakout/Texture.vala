/*******************************************************************
** This code is part of Breakout.
**
** Breakout is free software: you can redistribute it and/or modify
** it under the terms of the CC BY 4.0 license as published by
** Creative Commons, either version 4 of the License, or (at your
** option) any later version.
******************************************************************/
using GL;
using GLFW;
using System;
using cglm; // class based version


// Texture2D is able to store and configure a texture in OpenGL.
// It also hosts utility functions for easy management.
public class Texture : Object
{
    // Holds the ID of the texture object, used for all texture operations to reference to this particlar texture
    public GLuint ID;
    // Texture image dimensions
    public GLuint Width;
    public GLuint Height; // Width and height of loaded image in pixels
    // Texture Format
    public GLuint Internal_Format; // Format of texture object
    public GLuint Image_Format; // Format of loaded image
    // Texture configuration
    public GLuint Wrap_S; // Wrapping mode on S axis
    public GLuint Wrap_T; // Wrapping mode on T axis
    public GLuint Filter_Min; // Filtering mode if texture pixels < screen pixels
    public GLuint Filter_Max; // Filtering mode if texture pixels > screen pixels
    // Constructor (sets default texture modes)
    public Texture2D()
    {
        Width = 0;
        Height = 0;
        Internal_Format = GL_RGB;
        Image_Format = GL_RGB;
        Wrap_S = GL_REPEAT;
        Wrap_T = GL_REPEAT;
        Filter_Min = GL_LINEAR;
        Filter_Maz = GL_LINEAR;
        glGenTextures(1, &ID);
    }
    // Generates texture from image data
    public void Generate(GLuint width, GLuint height, uchar* data)
    {
        Width = width;
        Height = height;
        // Create Texture
        glBindTexture(GL_TEXTURE_2D, ID);
        glTexImage2D(GL_TEXTURE_2D, 0, Internal_Format, width, height, 0, Image_Format, GL_UNSIGNED_BYTE, data);
        // Set Texture wrap and filter modes
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, Wrap_S);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, Wrap_T);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, Filter_Min);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, Filter_Max);
        // Unbind texture
        glBindTexture(GL_TEXTURE_2D, 0);
    }
    // Binds the texture as the current active GL_TEXTURE_2D texture object
    void Bind()
    {
        glBindTexture(GL_TEXTURE_2D, ID);
    }
}