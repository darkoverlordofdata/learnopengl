/**
 * Fragment shader
 */
public const string FragmentShaderSource = 
"""#version 300 es
/**
 * Default fragment shader
 */
#ifdef GL_ES
precision mediump float;
#endif
out vec4 FragColor;
void main()
{
    FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);
}
""";

/**
 * Vertex shader
 */
public const string VertexShaderSource = 
"""#version 300 es
/**
 * Default vertex shader
 */
layout (location = 0) in vec3 aPos;
void main()
{
    gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
}
""";
