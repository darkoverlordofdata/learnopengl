using GL;
using GLFW;
using System;
using glm;


static int main (string[] args) 
{
    return new Game().Run();
}

public class Game : Object
{
    const int FPS = 60;
    const double FRAME_RATE = 1.0/(double)FPS;
    const GLsizei WIDTH = 800;
    const GLsizei HEIGHT = 600;
    static Game Instance;
    uint VBO = 0;
    uint VAO = 0;
    uint EBO = 0;
    uint texture1 = 0;
    uint texture2 = 0;
    GLFWwindow* window;
    Shader shader;
    Image img;

    public Game()
    {
        Instance = this;
    }

    public int Run() 
    {
        print("Compiled with Vala %s\n", Constants.VALA_VERSION);
        print("Starting GLFW context, OpenGL 3.0\n");

        glfwInit();
        // #if (__EMSCRIPTEN__)
        glfwWindowHint(GLFW_VERSION_MAJOR, 3);
        glfwWindowHint(GLFW_VERSION_MINOR, 0);
        // #else
        // glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
        // glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);        
        // glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
        // #if (__APPLE__)
        // glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
        // #endif
        // #endif

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

        shader = new Shader("5.1.texture.vs", "5.1.texture.fs");

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
        glGenTextures(1, &texture1);
        glBindTexture(GL_TEXTURE_2D, texture1); // all upcoming GL_TEXTURE_2D operations now have effect on this texture object
        // set the texture wrapping parameters
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);	// set texture wrapping to GL_REPEAT (default wrapping method)
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
        // set texture filtering parameters
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

        img = new Image("assets/images/container.jpg");
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, img.Width, img.Height, 0, GL_RGB, GL_UNSIGNED_BYTE, img.Pixels);
        glGenerateMipmap(GL_TEXTURE_2D);

        // texture 2
        // ---------
        glGenTextures(1, &texture2);
        glBindTexture(GL_TEXTURE_2D, texture2);
        // set the texture wrapping parameters
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);	// set texture wrapping to GL_REPEAT (default wrapping method)
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
        // set texture filtering parameters
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

        img = new Image("assets/images/awesomeface.png");
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, img.Width, img.Height, 0, GL_RGBA, GL_UNSIGNED_BYTE, img.Pixels);
        glGenerateMipmap(GL_TEXTURE_2D);

        // tell opengl for each sampler to which texture unit it belongs to (only has to be done once)
        // -------------------------------------------------------------------------------------------
        shader.Use(); 
        shader.SetInt("texture1", 0);
        shader.SetInt("texture2", 1);


#if (__EMSCRIPTEN__) 

        Emscripten.set_main_loop(() => Instance.Update(), -1, 0);

#else
        while (glfwWindowShouldClose(window) != GL_TRUE) Update();
        glDeleteVertexArrays(1, &VAO);
        glDeleteBuffers(1, &VBO);

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
        glClear(GL_COLOR_BUFFER_BIT);

        // bind textures on corresponding texture units
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, texture1);
        glActiveTexture(GL_TEXTURE1);
        glBindTexture(GL_TEXTURE_2D, texture2);

        var trans = Mat4.Create();
        Mat4.Identity(trans);
        Translate(trans, { 0.5f, -0.5f, 0.0f });
        Rotate(trans, (float)glfwGetTime(), { 0.0f, 0.0f, 1.0f });

        GLint transformLoc = glGetUniformLocation(shader.ID, "transform");
        glUniformMatrix4fv(transformLoc, 1, GL_FALSE, &trans[0,0]);

        glBindVertexArray(VAO); // seeing as we only have a single VAO there's no need to bind it every time, but we'll do so to keep things a bit more organized
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, null);

        glfwSwapBuffers(window);
        glfwPollEvents();
#if (!__EMSCRIPTEN__) 
        glfwWaitEventsTimeout(FRAME_RATE);
#endif
    }


    public void ProcessInput(GLFWwindow* window)
    {
        if (glfwGetKey(window, Key.ESCAPE) == ButtonState.PRESS)
        {
            glfwSetWindowShouldClose(window, GL_TRUE);
        }
    }

}

