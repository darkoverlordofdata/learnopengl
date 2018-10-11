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

    public Shaders(string? frag=null, string? vert=null)
    {
        fragmentSource = new string[0];
        fragmentLength = new int[0];
        if (frag != null ) {
            fragmentSource = { frag };
            fragmentLength = { frag.length };
        } 

        vertexSource = new string[0];
        vertexLength = new int[0];
        if (vert != null) {
            vertexSource = { vert };
            vertexLength = { vert.length };
        }
    }

    public void Add(string fragment, string vertex)
    {
        fragmentSource.resize(fragmentSource.length+1);
        fragmentLength.resize(fragmentLength.length+1);
        fragmentSource[fragmentSource.length-1] = fragment;
        fragmentLength[fragmentLength.length-1] = fragment.length;

        vertexSource.resize(vertexSource.length+1);
        vertexLength.resize(vertexLength.length+1);
        vertexSource[vertexSource.length-1] = vertex;
        vertexLength[vertexLength.length-1] = vertex.length;
    }

    public Shaders Compile()
    {
        fragmentShader = compileFragment();
        vertexShader = compileVertex();
        shaderProgram = linkProgram(fragmentShader, vertexShader);
        return this;
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
		glShaderSource(vertexShader, 1, vertexSource , vertexLength);
        glCompileShader(vertexShader);        
        glGetShaderiv(vertexShader, ShaderParameter.CompileStatus, &success);
        if (success != 1)
        {
            glGetShaderInfoLog(vertexShader, 512, null, infoLog);
            print("ERROR::SHADER::VERTEX::COMPILATION_FAILED %d %s\n", success, (string)infoLog);
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
		glShaderSource(fragmentShader, 1, fragmentSource , fragmentLength);
        glCompileShader(fragmentShader);        
        glGetShaderiv(fragmentShader, ShaderParameter.CompileStatus, &success);
        if (success != 1)
        {
            glGetShaderInfoLog(fragmentShader, 512, null, infoLog);
            print("ERROR::SHADER::FRAGMENT::COMPILATION_FAILED %d %s\n", success, (string)infoLog);
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
            print("ERROR::SHADER::PROGRAM::LINKING_FAILED %d %s\n", success, (string)infoLog);
        }
        glDeleteShader(vertexShader);
        glDeleteShader(fragmentShader);
        return shaderProgram;
    }
}
