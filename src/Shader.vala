using GL;
using GLFW;
using glm;
using System;
using System.IO;
#if (__EMSCRIPTEN__)
using Emscripten;
#endif

/**
 * Shaders class
 *
 * manage a set of shaders
 */
public class Shader : Object
{
    public uint ID { get { return id; } }

    const string ROOT = "assets/shaders/";
    uint id;
    int version;
    string profile;

    enum Type
    {
        VERTEX = GL_VERTEX_SHADER, 
        FRAGMENT = GL_FRAGMENT_SHADER, 
        // GEOMETRY = GL_GEOMETRY_SHADER, 
        PROGRAM = -1
    }

    /** 
     * Create a new shader
     * Use version 300 es for emscripten
     */
    public Shader(int version=300, string profile="es")
    {
        this.version = version;
        this.profile = profile;
    }

    /**
     * Load in the glsl files
     */
    public Shader Load(string vertexPath, string fragmentPath, string? geometryPath = null)
    {
        var vertex = loadShader((Type)GL_VERTEX_SHADER, vertexPath);
        var fragment = loadShader((Type)GL_FRAGMENT_SHADER, fragmentPath);
        // var geometry = loadShader((Type)GL_GEOMETRY_SHADER, geometryPath);

        // link program
        id = glCreateProgram();
        glAttachShader(id, vertex);
        glAttachShader(id, fragment);
        // if (geometryPath != null) glAttachShader(id, geometry);
        glLinkProgram(id);
        checkCompileErrors(id, Type.PROGRAM);
        // delete the shaders as they're linked into our program now and no longer necessery
        glDeleteShader(vertex);
        glDeleteShader(fragment);
        // if (geometryPath != null) glDeleteShader(geometry);
        return this;
    }

    // Set this as the current shader to use
    // ------------------------------------------------------------------------
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
    public void SetVec2v(string name, Vec2 value) 
    { 
        glUniform2fv(glGetUniformLocation(id, name), 1, value); 
    }

    public void SetVec2(string name, float x, float y) 
    { 
        glUniform2f(glGetUniformLocation(id, name), x, y); 
    }
    // ------------------------------------------------------------------------
    public void SetVec3v(string name, Vec3 value) 
    { 
        glUniform3fv(glGetUniformLocation(id, name), 1, value); 
    }

    public void SetVec3(string name, float x, float y, float z) 
    { 
        glUniform3f(glGetUniformLocation(id, name), x, y, z); 
    }
    // ------------------------------------------------------------------------
    public void SetVec4v(string name, Vec4 value) 
    { 
        glUniform4fv(glGetUniformLocation(id, name), 1, value); 
    }

    public void SetVec4(string name, float x, float y, float z, float w) 
    { 
        glUniform4f(glGetUniformLocation(id, name), x, y, z, w); 
    }
    // ------------------------------------------------------------------------
    public void SetMat3(string name, Mat3 mat) 
    {
        glUniformMatrix3fv(glGetUniformLocation(id, name), 1, GL_FALSE, mat);
    }
    // ------------------------------------------------------------------------
    public void SetMat4(string name, Mat4 mat) 
    {
        glUniformMatrix4fv(glGetUniformLocation(id, name), 1, GL_FALSE, mat);
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

    /*
     * Check returned compiler results
     */
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

