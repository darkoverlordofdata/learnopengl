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
using System;
using System.IO;

// General purpsoe shader object. Compiles from file, generates
// compile/link-time error messages and hosts several utility 
// functions for easy management.
public class Shader : Object
{
    enum Type
    {
        VERTEX = GL_VERTEX_SHADER, 
        FRAGMENT = GL_FRAGMENT_SHADER, 
        GEOMETRY = GL_GEOMETRY_SHADER, 
        PROGRAM = -1
    }

    // State
    public uint ID; 
    public int Version;
    public string Profile;
    // Constructor
    public Shader(int version=300, string profile="es")
    {
        /** 
        * Create a new shader
        * Use version 300 es for emscripten
        */
        Version = version;
        Profile = profile;
    }
    // Sets the current shader as active
    public Shader Use()
    {
        glUseProgram(ID);
        return this;
    }
    // Compiles the shader from given source code
    // Note: geometry source code is optional 
    public void Compile(string vertexSource, string fragmentSource, string? geometrySource = null) 
    {
        uint sVertex, sFragment, gShader = 0;
        string[] source;
        int[] length;
        var version = VERSION.printf(Version, Profile);

        // Vertex Shader
        source = { version, HEADER, vertexSource };
        length = { version.length, HEADER.length, vertexSource.length };
        sVertex = glCreateShader(GL_VERTEX_SHADER);
        glShaderSource(sVertex, source.length, source, length);
        glCompileShader(sVertex);
        checkCompileErrors(sVertex, Type.VERTEX);
        // Fragment Shader
        source = { version, HEADER, fragmentSource };
        length = { version.length, HEADER.length, fragmentSource.length };
        sFragment = glCreateShader(GL_FRAGMENT_SHADER);
        glShaderSource(sFragment, source.length, source, length);
        glCompileShader(sFragment);
        checkCompileErrors(sFragment, Type.FRAGMENT);
        // If geometry shader source code is given, also compile geometry shader
        if (geometrySource != null)
        {
            source = { version, HEADER, geometrySource };
            length = { version.length, HEADER.length, geometrySource.length };
            gShader = glCreateShader(GL_GEOMETRY_SHADER);
            glShaderSource(gShader, source.length, source, length);
            glCompileShader(gShader);
            checkCompileErrors(gShader, Type.GEOMETRY);
        }
        // Shader Program
        this.ID = glCreateProgram();
        glAttachShader(this.ID, sVertex);
        glAttachShader(this.ID, sFragment);
        if (geometrySource != null)
            glAttachShader(this.ID, gShader);
        glLinkProgram(this.ID);
        checkCompileErrors(this.ID, Type.PROGRAM);
        // Delete the shaders as they're linked into our program now and no longer necessery
        glDeleteShader(sVertex);
        glDeleteShader(sFragment);
        if (geometrySource != null)
            glDeleteShader(gShader);

    }
    // Utility functions
    public void SetFloat(string name, float value, GLboolean useShader = GL_FALSE)
    {
        if (useShader == GL_TRUE)
            Use();
        glUniform1f(glGetUniformLocation(ID, name), value); 

    }
    public void SetInteger(string name, int value, GLboolean useShader = GL_FALSE)
    {
        if (useShader == GL_TRUE)
            Use();
        glUniform1i(glGetUniformLocation(ID, name), value); 

    }
    public void SetVector2f(string name, float x, float y, GLboolean useShader = GL_FALSE)
    {
        if (useShader == GL_TRUE)
            Use();
        glUniform2f(glGetUniformLocation(ID, name), x, y); 

    }
    public void SetVector2(string name, void* value, GLboolean useShader = GL_FALSE)
    {
        if (useShader == GL_TRUE)
            Use();
        glUniform2fv(glGetUniformLocation(ID, name), 1, value); 

    }
    public void SetVector3f(string name, float x, float y, float z, GLboolean useShader = GL_FALSE)
    {
        if (useShader == GL_TRUE)
            Use();
        glUniform3f(glGetUniformLocation(ID, name), x, y, z); 

    }
    public void SetVector3(string name, void* value, GLboolean useShader = GL_FALSE)
    {
        if (useShader == GL_TRUE)
            Use();
        glUniform3fv(glGetUniformLocation(ID, name), 1, value); 

    }
    public void SetVector4f(string name, float x, float y, float z, float w, GLboolean useShader = GL_FALSE)
    {
        if (useShader == GL_TRUE)
            Use();
        glUniform4f(glGetUniformLocation(ID, name), x, y, z, w); 

    }
    public void SetVector4(string name, void* value, GLboolean useShader = GL_FALSE)
    {
        if (useShader == GL_TRUE)
            Use();
        glUniform4fv(glGetUniformLocation(ID, name), 1, value); 

    }
    public void SetMatrix4(string name, Mat4 matrix, GLboolean useShader = GL_FALSE)
    {
        if (useShader == GL_TRUE)
            Use();
        glUniformMatrix4fv(glGetUniformLocation(ID, name), 1, GL_FALSE, matrix);

    }

    // Checks if compilation or linking failed and if so, print the error logs
    void checkCompileErrors(uint shader, Type type)
    {
        int success = GL_FALSE;
        char infoLog[1024];

        if (type != Type.PROGRAM)
        {
            glGetShaderiv(shader, GL_COMPILE_STATUS, &success);
            if (success != GL_TRUE)
            {
                glGetShaderInfoLog(shader, 1024, null, infoLog);
                print("Error %s compiling %s\n-- --------------------------------------------------- --\n", (string)infoLog, type.to_string());
            }
        }
        else
        {
            glGetProgramiv(shader, GL_LINK_STATUS, &success);
            if (success != GL_TRUE)
            {
                glGetProgramInfoLog(shader, 1024, null, infoLog);
                print("Error %s linking %s\n-- --------------------------------------------------- --\n", (string)infoLog, type.to_string());
            }
        }
    }

    public const string VERSION = "#version %d %s";
    public const string HEADER = """
#
#ifdef GL_ES
precision mediump float;
#endif
""";
}