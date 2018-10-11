using GL;
using GLFW;
using System;
using System.IO;
#if (__EMSCRIPTEN__)
using Emscripten;
#endif

/**
 * Shaders class
 *
 * manage loading, compiling, and linking shaders
 */
public class Shader : Object
{
    const string ROOT = "assets/shaders/";

    private uint id;

    public uint ID { get { return id; } }

    public enum Type
    {
        VERTEX, FRAGMENT, PROGRAM
    }

    public Shader(string vertPath, string fragPath)
    {
        var vertexCode = readTextFile(vertPath);
        var fragmentCode = readTextFile(fragPath);

        string[] vertexSource = { VERSION, HEADER, vertexCode };
        int[] vertexLength = { VERSION.length, HEADER.length, vertexCode.length };

        string[] fragmentSource = { VERSION, HEADER, fragmentCode };
        int[] fragmentLength = { VERSION.length, HEADER.length, fragmentCode.length };

        // compile vertex shader
        var vertex = glCreateShader(GL_VERTEX_SHADER);
		glShaderSource(vertex, vertexSource.length, vertexSource , vertexLength);
        glCompileShader(vertex);
        checkCompileErrors(vertex, Type.VERTEX);

        // compile fragment shader
        var fragment = glCreateShader(GL_FRAGMENT_SHADER);
		glShaderSource(fragment, fragmentSource.length, fragmentSource , fragmentLength);
        glCompileShader(fragment);        
        checkCompileErrors(fragment, Type.FRAGMENT);

        // link program
        id = glCreateProgram();
        glAttachShader(id, vertex);
        glAttachShader(id, fragment);
        glLinkProgram(id);
        checkCompileErrors(id, Type.PROGRAM);
        // delete the shaders as they're linked into our program now and no longer necessery
        glDeleteShader(vertex);
        glDeleteShader(fragment);

    }

    public void Use()
    {
        glUseProgram(id);
    }

    // utility uniform functions
    // ------------------------------------------------------------------------
    public void SetBool(string name, bool value)
    {         
        glUniform1i(glGetUniformLocation(id, name), (int)value); 
    }
    // ------------------------------------------------------------------------
    public void SetInt(string name, int value)
    { 
        glUniform1i(glGetUniformLocation(id, name), value); 
    }
    // ------------------------------------------------------------------------
    public void SetFloat(string name, float value) 
    { 
        glUniform1f(glGetUniformLocation(id, name), value); 
    }

    // ------------------------------------------------------------------------
    // void SetVec2v(string name, ref glm.vec2[] value) 
    // { 
    //     glUniform2fv(glGetUniformLocation(id, name), 1, (float*)&value[0]); 
    // }

    void SetVec2(string name, float x, float y) 
    { 
        glUniform2f(glGetUniformLocation(id, name), x, y); 
    }
    // ------------------------------------------------------------------------
    // void SetVec3v(string name, ref glm.vec3[] value) 
    // { 
    //     glUniform3fv(glGetUniformLocation(id, name), 1, (float*)&value[0]); 
    // }

    void SetVec3(string name, float x, float y, float z) 
    { 
        glUniform3f(glGetUniformLocation(id, name), x, y, z); 
    }
    // ------------------------------------------------------------------------
    // void SetVec4v(string name, ref glm.vec4[] value) 
    // { 
    //     glUniform4fv(glGetUniformLocation(id, name), 1, (float*)&value[0]); 
    // }

    void SetVec4(string name, float x, float y, float z, float w) 
    { 
        glUniform4f(glGetUniformLocation(id, name), x, y, z, w); 
    }
    // ------------------------------------------------------------------------
    // void SetMat2(string name, ref glm.mat2[] mat) 
    // {
    //     glUniformMatrix2fv(glGetUniformLocation(id, name), 1, GL_FALSE, (float*)&mat[0]);
    // }
    // ------------------------------------------------------------------------
    // void SetMat3(string name, ref glm.mat3[] mat) 
    // {
    //     glUniformMatrix3fv(glGetUniformLocation(id, name), 1, GL_FALSE, (float*)&mat[0]);
    // }
    // ------------------------------------------------------------------------
    // void SetMat4(string name, ref glm.mat4[] mat) 
    // {
    //     glUniformMatrix4fv(glGetUniformLocation(id, name), 1, GL_FALSE, (float*)&mat[0]);
    // }


    void checkCompileErrors(GLuint shader, Type type)
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

    public const string VERSION = "#version 300 es";
    public const string HEADER = """
#
#ifdef GL_ES
precision mediump float;
#endif
""";
}
