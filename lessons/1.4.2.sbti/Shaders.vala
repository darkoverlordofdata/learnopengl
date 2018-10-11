using GL;
using GLFW;
using System;
#if (__EMSCRIPTEN__)
using Emscripten;
#endif

/**
 * Shaders class
 *
 * manage loading, compiling, and linking shaders
 */
public class Shaders : Object
{
    private string[] fragmentSource;
    private int[] fragmentLength;

    private string[] vertexSource;
    private int[] vertexLength;

    private uint fragmentShader;
    private uint vertexShader;
    private uint shaderProgram;

    public uint ShaderProgram { get { return shaderProgram; } }

    public Shaders(string frag, string vert)
    {
        fragmentSource = { VERSION, HEADER, frag };
        fragmentLength = { VERSION.length, HEADER.length, frag.length };

        vertexSource = { VERSION, HEADER, vert };
        vertexLength = { VERSION.length, HEADER.length, vert.length };

        fragmentShader = compileFragment();
        vertexShader = compileVertex();
        shaderProgram = linkProgram(fragmentShader, vertexShader);
    }

    public void Use()
    {
        glUseProgram(shaderProgram);
    }

    // utility uniform functions
    // ------------------------------------------------------------------------
    public void SetBool(string name, bool value)
    {         
        glUniform1i(glGetUniformLocation(shaderProgram, name), (int)value); 
    }
    // ------------------------------------------------------------------------
    public void SetInt(string name, int value)
    { 
        glUniform1i(glGetUniformLocation(shaderProgram, name), value); 
    }
    // ------------------------------------------------------------------------
    public void SetFloat(string name, float value) 
    { 
        glUniform1f(glGetUniformLocation(shaderProgram, name), value); 
    }

    private uint compileVertex()
    {
        // build and compile our shader program
        // ------------------------------------
        char infoLog[512];
        var success = 0;
        var vertexShader = glCreateShader(ShaderType.VertexShader);
		glShaderSource(vertexShader, vertexSource.length, vertexSource , vertexLength);
        glCompileShader(vertexShader);        
        glGetShaderiv(vertexShader, ShaderParameter.CompileStatus, &success);
        if (success != 1)
        {
            glGetShaderInfoLog(vertexShader, 512, null, infoLog);
            print("Error: vertex shader compile failed %d %s\n", success, (string)infoLog);
        }
        return vertexShader; 
    }

    private uint compileFragment()
    {
        // build and compile our shader program
        // ------------------------------------
        char infoLog[512];
        var success = 0;
        var fragmentShader = glCreateShader(ShaderType.FragmentShader);
		glShaderSource(fragmentShader, fragmentSource.length, fragmentSource , fragmentLength);
        glCompileShader(fragmentShader);        
        glGetShaderiv(fragmentShader, ShaderParameter.CompileStatus, &success);
        if (success != 1)
        {
            glGetShaderInfoLog(fragmentShader, 512, null, infoLog);
            print("Error: fragment shader compile failed %d %s\n", success, (string)infoLog);
        }
        return fragmentShader; 
    }

    private uint linkProgram(uint vertexShader, uint fragmentShader)
    {
        // link shaders
        shaderProgram = glCreateProgram();
        glAttachShader(shaderProgram, vertexShader);
        glAttachShader(shaderProgram, fragmentShader);
        glLinkProgram(shaderProgram);

        // check for linking errors
        var success = 0;
        char infoLog[512];
        glGetProgramiv(shaderProgram, GetProgramParameter.LinkStatus, &success);
        if (success != 1) {
            glGetProgramInfoLog(shaderProgram, 512, null, infoLog);
            print("Error: shader link failed %d %s\n", success, (string)infoLog);
        }
        glDeleteShader(vertexShader);
        glDeleteShader(fragmentShader);
        return shaderProgram;
    }

    public const string VERSION = "#version 300 es";
    public const string HEADER = """
#
#ifdef GL_ES
precision mediump float;
#endif
""";
}
