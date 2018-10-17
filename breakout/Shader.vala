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


// General purpsoe shader object. Compiles from file, generates
// compile/link-time error messages and hosts several utility 
// functions for easy management.
public class Shader : Object
{
    enum Type
    {
        VERTEX = GL_VERTEX_SHADER, 
        FRAGMENT = GL_FRAGMENT_SHADER, 
#if (!__EMSCRIPTEN__)
        GEOMETRY = GL_GEOMETRY_SHADER, 
#endif
        PROGRAM = -1
    }

    // State
    public GLuint ID; 
    // Constructor
    public Shader(int version=300, string profile="es")
    {
        /** 
        * Create a new shader
        * Use version 300 es for emscripten
        */
        this.version = version;
        this.profile = profile;
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
        var vertex = loadShader((Type)GL_VERTEX_SHADER, vertexPath);
        var fragment = loadShader((Type)GL_FRAGMENT_SHADER, fragmentPath);
#if (!__EMSCRIPTEN__)
        var geometry = loadShader((Type)GL_GEOMETRY_SHADER, geometryPath);
#endif
        // link program
        ID = glCreateProgram();
        glAttachShader(ID, vertex);
        glAttachShader(ID, fragment);
#if (!__EMSCRIPTEN__)
        if (geometryPath != null) glAttachShader(ID, geometry);
#endif
        glLinkProgram(ID);
        checkCompileErrors(ID, Type.PROGRAM);
        // delete the shaders as they're linked into our program now and no longer necessery
        glDeleteShader(vertex);
        glDeleteShader(fragment);
#if (!__EMSCRIPTEN__)
        if (geometryPath != null) glDeleteShader(geometry);
#endif
        return this;

    }
    // Utility functions
    public void SetFloat(string name, GLfloat value, GLboolean useShader = GL_FALSE)
    {
        if (useShader)
            Use();
        glUniform1f(glGetUniformLocation(ID, name), value); 

    }
    public void SetInteger(string name, GLint value, GLboolean useShader = GL_FALSE)
    {
        if (useShader)
            Use();
        glUniform1i(glGetUniformLocation(ID, name), value); 

    }
    public void SetVector2f(string name, GLfloat x, GLfloat y, GLboolean useShader = GL_FALSE)
    {
        if (useShader)
            Use();
        glUniform2f(glGetUniformLocation(ID, name), x, y); 

    }
    public void SetVector2f(string name, Vec2 value, GLboolean useShader = GL_FALSE)
    {
        if (useShader)
            Use();
        glUniform2fv(glGetUniformLocation(ID, name), 1, value); 

    }
    public void SetVector3f(string name, GLfloat x, GLfloat y, GLfloat z, GLboolean useShader = GL_FALSE)
    {
        if (useShader)
            Use();
        glUniform3f(glGetUniformLocation(ID, name), x, y, z); 

    }
    public void SetVector3f(string name, Vec3 value, GLboolean useShader = GL_FALSE)
    {
        if (useShader)
            Use();
        glUniform3fv(glGetUniformLocation(ID, name), 1, value); 

    }
    public void SetVector4f(string name, GLfloat x, GLfloat y, GLfloat z, GLfloat w, GLboolean useShader = GL_FALSE)
    {
        if (useShader)
            Use();
        glUniform4f(glGetUniformLocation(ID, name), x, y, z, w); 

    }
    public void SetVector4f(string name, Vec4 value, GLboolean useShader = GL_FALSE)
    {
        if (useShader)
            Use();
        glUniform4fv(glGetUniformLocation(ID, name), 1, value); 

    }
    public void SetMatrix4(string name, Mat4 matrix, GLboolean useShader = GL_FALSE)
    {
        if (useShader)
            Use();
        glUniformMatrix4fv(glGetUniformLocation(ID, name), 1, GL_FALSE, mat);

    }

    /*
     * Load and compile a shader
     */
    uint loadShader(Type type, string? path = null)
    {
        if (path == null) return 0;

        var version = VERSION.printf(version, profile);

        var shaderCode = readTextFile(path);
        string[] shaderSource = { version, HEADER, shaderCode };
        int[] sourceLength = { version.length, HEADER.length, shaderCode.length };
        var shader = glCreateShader(type);
        glShaderSource(shader, shaderSource.length, shaderSource , sourceLength);
        glCompileShader(shader);        
        checkCompileErrors(shader, type);
        return shader;
    }


    // Checks if compilation or linking failed and if so, print the error logs
    void checkCompileErrors(GLuint shader, string type)
    {
        GLint success = GL_FALSE;
        GLchar infoLog[1024];

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
    /*
     * Read in a text file
     */
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

    public const string VERSION = "#version %d %s";
    public const string HEADER = """
#
#ifdef GL_ES
precision mediump float;
#endif
""";
}