/*******************************************************************
** This code is part of Breakout.
**
** Breakout is free software: you can redistribute it and/or modify
** it under the terms of the CC BY 4.0 license as published by
** Creative Commons, either version 4 of the License, or (at your
** option) any later version.
******************************************************************/
using GL;
using Stb;
using System;
using System.IO;
using System.Collections.Generic;

// A static singleton ResourceManager class that hosts several
// functions to load Textures and Shaders. Each loaded texture
// and/or shader is also stored for future reference by string
// handles. All functions and resources are static and no 
// public constructor is defined.
public class ResourceManager : Object
{
    public const string ROOT = "assets/";
    // Resource storage
    static Dictionary<string, Shader> Shaders = new Dictionary<string, Shader>();
    static Dictionary<string, Texture2D> Textures = new Dictionary<string, Texture2D>();

    static int Version;
    static string Profile;
    // public static Font? TheFont = null;

    /**
     * Initialize the resource manager singleton dictionaries
     *
     * @param   version to use for shaders
     * @param   profile to use for shaders
     */
    public ResourceManager(int version=300, string profile="es") 
    {
        Version = version;
        Profile = profile;
    } // to initialize the static objects
    
    // Loads (and generates) a shader program from file loading vertex, fragment (and geometry) shader's source code. If gShaderFile is not nullptr, it also loads a geometry shader
    public static Shader LoadShader(string vShaderFile, string fShaderFile, string gShaderFile, string name)
    {
        Shaders[name] = loadShaderFromFile(vShaderFile, fShaderFile, gShaderFile);
        return Shaders[name];
    }
    // Retrieves a stored sader
    public static Shader GetShader(string name)
    {
        return Shaders[name];
    }
    // Loads (and generates) a texture from file
    public static Texture2D LoadTexture(string file, bool alpha, string name)
    {
        Textures[name] = loadTextureFromFile(file, alpha);
        return Textures[name];
    }
    // Retrieves a stored texture
    public static Texture2D GetTexture(string name)
    {
        return Textures[name];
    }
    // Properly de-allocates all loaded resources
    public static void Clear()
    {
        // (Properly) delete all shaders	
        foreach (var iter in Shaders.Keys)
            glDeleteProgram(Shaders[iter].ID);
        // (Properly) delete all textures
        foreach (var iter in Textures.Keys)
            glDeleteTextures(1, &Textures[iter].ID);

    }

    // Loads and generates a shader from file
    static Shader loadShaderFromFile(string vShaderFile, string fShaderFile, string gShaderFile = null)
    {
        // 1. Retrieve the vertex/fragment source code from filePath
        string? vertexCode = null;
        string? fragmentCode = null;
        string? geometryCode = null;
        try
        {
            vertexCode = readTextFile(vShaderFile); 
            fragmentCode = readTextFile(fShaderFile);
            // If geometry shader path is present, also load a geometry shader
            if (gShaderFile != null)
                geometryCode = readTextFile(gShaderFile);
        }
        catch (Exception e)
        {
            print("ERROR::SHADER: Failed to read shader files\n");
        }
        // 2. Now create shader object from source code
        Shader shader = new Shader(Version, Profile);
        shader.Compile(vertexCode, fragmentCode, geometryCode);
        return shader;

    }

    // Loads a single texture from file
    static Texture2D loadTextureFromFile(string file, bool alpha)
    {
        // Create Texture object
        Texture2D texture = new Texture2D();
        if (alpha)
        {
            texture.InternalFormat = GL_RGBA;
            texture.ImageFormat = GL_RGBA;
        }
        // Load image
        int width;
        int height;
        int channels;
        IntPtr image = Stb.load(ROOT+file, out width, out height, out channels, texture.ImageFormat == GL_RGBA ? 4 : 3);
        // Now generate texture
        texture.Generate(width, height, image);
        // And finally free image data
        Stb.image_free(image);
        return texture;
    }

    static string? readTextFile(string path)
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
}