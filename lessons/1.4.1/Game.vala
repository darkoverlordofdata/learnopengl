using GL;
using GLFW;
using Stbi;
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
    public uint EBO = 0;
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

        var frag = readTextFile("assets/shaders/4.1.texture.fs");
        var vert = readTextFile("assets/shaders/4.1.texture.vs");

        shaders = new Shaders(frag, vert).Compile();

        float vertices[] = {
            // positions          // colors           // texture coords
             0.5f,  0.5f, 0.0f,   1.0f, 0.0f, 0.0f,   1.0f, 1.0f, // top right
             0.5f, -0.5f, 0.0f,   0.0f, 1.0f, 0.0f,   1.0f, 0.0f, // bottom right
            -0.5f, -0.5f, 0.0f,   0.0f, 0.0f, 1.0f,   0.0f, 0.0f, // bottom left
            -0.5f,  0.5f, 0.0f,   1.0f, 1.0f, 0.0f,   0.0f, 1.0f  // top left 
        };
        uint indices[] = {  
            0, 1, 3, // first triangle
            1, 2, 3  // second triangle
        };

        VBO = 0;
        VAO = 0;
        EBO = 0;
        glGenVertexArrays(1, &VAO);
        glGenBuffers(1, &VBO);
        glGenBuffers(1, &EBO);
        // bind the Vertex Array Object first, then bind and set 
        // vertex buffer(s), and then configure vertex attributes(s).
        glBindVertexArray(VAO);

        glBindBuffer(GL_ARRAY_BUFFER, VBO);
        glBufferData(GL_ARRAY_BUFFER, vertices.length*sizeof(float), vertices, GL_STATIC_DRAW);

        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices.length*sizeof(uint), indices, GL_STATIC_DRAW);

        // position attribute
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 8 * (int)sizeof(float), (void*)0);
        glEnableVertexAttribArray(0);
        // color attribute
        glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 8 * (int)sizeof(float), (void*)(3* sizeof(float)));
        glEnableVertexAttribArray(1);
        // texture coord attribute
        glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 8 * (int)sizeof(float), (void*)(6 * sizeof(float)));
        glEnableVertexAttribArray(2);

        // load and create a texture 
        // -------------------------
        uint texture  = 0;
        glGenTextures(1, &texture);
        glBindTexture(GL_TEXTURE_2D, texture); // all upcoming GL_TEXTURE_2D operations now have effect on this texture object
        // set the texture wrapping parameters
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);	// set texture wrapping to GL_REPEAT (default wrapping method)
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
        // set texture filtering parameters
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        // load image, create texture and generate mipmaps
        int width = 0;
        int height = 0;
        int nrChannels = 0;
        // The FileSystem::getPath(...) is part of the GitHub repository so we can find files on any IDE/platform; replace it with your own image path.
        stbi_uc *data = stbi_load("C:/Users/darko/Documents/GitHub/LearnOpenGL/resources/textures/container.jpg", &width, &height, &nrChannels, 0);
        if (data != null)
        {
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, (void*)data);
            glGenerateMipmap(GL_TEXTURE_2D);
        }
        else
        {
            print("Failed to load texture\n");
        }
        stbi_image_free(data);
            


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
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, null);

        // glDrawArrays(PrimitiveType.Triangles, 0, 3);

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

