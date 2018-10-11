using GL;
using GLFW;
using System;
using System.IO;
#if (__EMSCRIPTEN__)
using Emscripten;
#endif

static int main (string[] args) 
{
    return new Game().Run();
}

public class Game : Object
{
    public const double FRAME_RATE = 1/60;
    public const GLsizei WIDTH = 800;
    public const GLsizei HEIGHT = 600;
    public uint VBO = 0;
    public uint VAO = 0;
    public GLFWwindow* window;
    public static Game Instance;
    public Shaders shaders;

    public Game()
    {
        Instance = this;
    }

    public int Run() 
    {
        print("Compiled with Vala %s\n", Constants.VALA_VERSION);
        print("Starting GLFW context, OpenGL 3.0\n");
        glfwInit();
        glfwWindowHint(GLFW_VERSION_MAJOR, 3);
        glfwWindowHint(GLFW_VERSION_MINOR, 0);

        window = glfwCreateWindow(WIDTH, HEIGHT, "LearnOpenGL with Vala", null, null);
        if (window == null)
        {
            print("Failed to create GLFW window" );
            glfwTerminate();
            return -1;
        }
        glfwMakeContextCurrent(window);
        glfwSetFramebufferSizeCallback(window, 
            (window, width, height) => glViewport(0, 0, width, height));

        #if (!__EMSCRIPTEN__)
        if (gladLoadGL() == 0)
        {
            print("Failed to initialize OpenGL context\n");
            return -1;
        }
        #endif

        var vert = readTextFile("assets/shaders/vertex.glsl");
        var frag = readTextFile("assets/shaders/fragment.glsl");

        shaders = new Shaders(frag, vert).Compile();

        float vertices[] = {
            // positions         // colors
            0.5f, -0.5f, 0.0f,  1.0f, 0.0f, 0.0f,   // bottom right
           -0.5f, -0.5f, 0.0f,  0.0f, 1.0f, 0.0f,   // bottom left
            0.0f,  0.5f, 0.0f,  0.0f, 0.0f, 1.0f    // top 
        };   

        VBO = 0;
        VAO = 0;
        glGenVertexArrays(1, &VAO);
        glGenBuffers(1, &VBO);
        // bind the Vertex Array Object first, then bind and set 
        // vertex buffer(s), and then configure vertex attributes(s).
        glBindVertexArray(VAO);

        glBindBuffer(BufferTarget.ArrayBuffer, VBO);
        glBufferData(BufferTarget.ArrayBuffer, vertices.length*sizeof(float), vertices, BufferUsageHint.StaticDraw);

        // glVertexAttribPointer(0, 3, VertexAttribPointerType.Float, GL_FALSE, 3 * (int)sizeof(float), (void*)0);
        // glEnableVertexAttribArray(0);

        // position attribute
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 6 * (int)sizeof(float), (void*)0);
        glEnableVertexAttribArray(0);
        // color attribute
        glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 6 * (int)sizeof(float), (void*)(3* sizeof(float)));
        glEnableVertexAttribArray(1);


#if (__EMSCRIPTEN__) 

        emscripten_set_main_loop(() => Instance.Update(), -1, 0);

#else
        while (glfwWindowShouldClose(window) != GL_TRUE) Update();
        // glDeleteVertexArrays(1, &VAO);
        // glDeleteBuffers(1, &VBO);

         glfwTerminate();

#endif
        return 0;
    }

    public void Update()
    {
        ProcessInput(window);
        if (glfwWindowShouldClose(window) == GL_TRUE) 
            return;

        glClearColor(0.2f, 0.3f, 0.3f, 1f);
        glClear(ClearBufferMask.ColorBufferBit);

        shaders.Use();
        glBindVertexArray(VAO); // seeing as we only have a single VAO there's no need to bind it every time, but we'll do so to keep things a bit more organized
        glDrawArrays(PrimitiveType.Triangles, 0, 3);

        glfwSwapBuffers(window);
        glfwPollEvents();
        // glfwWaitEventsTimeout(FRAME_RATE);
    }


    public void ProcessInput(GLFWwindow* window)
    {
        if (glfwGetKey(window, Key.ESCAPE) == ButtonState.PRESS)
        {
            glfwSetWindowShouldClose(window, GL_TRUE);
        }
    }

    string? readTextFile(string path)
    {
        string? line = null;
        string? text = "";
        var frag_file = new FileHandle(path);
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

