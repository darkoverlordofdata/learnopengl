/*******************************************************************
** This code is part of Breakout.
**
** Breakout is free software: you can redistribute it and/or modify
** it under the terms of the CC BY 4.0 license as published by
** Creative Commons, either version 4 of the License, or (at your
** option) any later version.
******************************************************************/
using GL;
using System;

// Texture2D is able to store and configure a texture in OpenGL.
// It also hosts utility functions for easy management.
public class Texture2D : Object
{
    // Holds the ID of the texture object, used for all texture operations to reference to this particlar texture
    public uint ID;
    // Texture image dimensions
    public uint Width;
    public uint Height; // Width and height of loaded image in pixels
    // Texture Format
    public int InternalFormat; // Format of texture object
    public int ImageFormat; // Format of loaded image
    // Texture configuration
    int WrapS; // Wrapping mode on S axis
    int WrapT; // Wrapping mode on T axis
    int FilterMin; // Filtering mode if texture pixels < screen pixels
    int FilterMag; // Filtering mode if texture pixels > screen pixels
    // Constructor (sets default texture modes)
    public Texture2D()
    {
        Width = 0;
        Height = 0;
        InternalFormat = GL_RGB;
        ImageFormat = GL_RGB;
        WrapS = GL_REPEAT;
        WrapT = GL_REPEAT;
        FilterMin = GL_LINEAR;
        FilterMag = GL_LINEAR;
        glGenTextures(1, &ID);
    }

    // Generates texture from image data
    public void Generate(int width, int height, IntPtr data)
    {
        Width = width;
        Height = height;
        // Create Texture
        glBindTexture(GL_TEXTURE_2D, ID);
        glTexImage2D(GL_TEXTURE_2D, 0, InternalFormat, (GLsizei)width, (GLsizei)height, 0, ImageFormat, GL_UNSIGNED_BYTE, (GLvoid*)data);
        // Set Texture wrap and filter modes
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, WrapS);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, WrapT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, FilterMin);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, FilterMag);
        // Unbind texture
        glBindTexture(GL_TEXTURE_2D, 0);
    }
    
    // Binds the texture as the current active GL_TEXTURE_2D texture object
    public void Bind()
    {
        glBindTexture(GL_TEXTURE_2D, ID);
    }
}

