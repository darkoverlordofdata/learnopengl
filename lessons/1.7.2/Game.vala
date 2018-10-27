using GL;
using GLFW;
using System;
using Glm; // class based version

static int main (string[] args) 
{
    return new Game().Run();
    
}

public class Game : Object
{
    const int FPS = 60;
    const double FRAME_RATE = 1.0/(double)FPS;
    const GLsizei SCR_WIDTH = 800;
    const GLsizei SCR_HEIGHT = 600;
    static Game Instance;
    uint VBO = 0;
    uint VAO = 0;
    uint texture1 = 0;
    uint texture2 = 0;
    GLFWwindow* window;
    Shader ourShader;
    Image img;
    Mat4 projection;
    Mat4 model;
    Mat4 view;
    Vec3 eye;
    Vec3 axis        = new Vec3(1.0f,  0.3f,  0.5f);
    Vec3 pivot       = new Vec3(0.0f,  0.0f, -3.0f);
    Vec3 center      = new Vec3(0.0f,  0.0f,  0.0f);
    Vec3 up          = new Vec3(0.0f,  1.0f,  0.0f);
    Vec3 cameraPos   = new Vec3(0.0f,  0.0f,  3.0f);
    Vec3 cameraFront = new Vec3(0.0f,  0.0f, -1.0f);
    Vec3 cameraUp    = new Vec3(0.0f,  1.0f,  0.0f);
    Vec3[] cubePositions;

    public bool firstMouse = true;
    public float yaw   = -90.0f;	// yaw is initialized to -90.0 degrees since a yaw of 0.0 results in a direction vector pointing to the right so we initially rotate a bit to the left.
    public float pitch =  0.0f;
    public float lastX =  800.0f / 2.0f;
    public float lastY =  600.0f / 2.0f;
    public float fov   =  45.0f;
    // timing
    float deltaTime = 0.0f;	// time between current frame and last frame
    float lastFrame = 0.0f;

    public Game()
    {
        Instance = this;
    }

    public int Run() 
    {
        print("Compiled with Vala %s\n", Constants.VALA_VERSION);
        print("Starting GLFW context, OpenGL 3.0\n");

        glfwInit();
        #if (__EMSCRIPTEN__)
        glfwWindowHint(GLFW_VERSION_MAJOR, 3);
        glfwWindowHint(GLFW_VERSION_MINOR, 0);
        #else
        glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
        glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);        
        glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
        #if (__APPLE__)
        glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
        #endif
        #endif

        window = glfwCreateWindow(SCR_WIDTH, SCR_HEIGHT, "LearnOpenGL with Vala", null, null);
        if (window == null)
        {
            print("Failed to create GLFW window" );
            glfwTerminate();
            return -1;
        }
        glfwMakeContextCurrent(window);
        glfwSetFramebufferSizeCallback(window, 
            (window, width, height) => glViewport(0, 0, width, height));

        glfwSetCursorPosCallback(window, (winddow, xpos, ypos) => {
            if (Instance.firstMouse)
            {
                Instance.lastX = (float)xpos;
                Instance.lastY = (float)ypos;
                Instance.firstMouse = false;
            }

            float xoffset = (float)xpos - Instance.lastX;
            float yoffset = Instance.lastY - (float)ypos; // reversed since y-coordinates go from bottom to top
            Instance.lastX = (float)xpos;
            Instance.lastY = (float)ypos;

            float sensitivity = 0.05f; // change this value to your liking
            xoffset *= sensitivity;
            yoffset *= sensitivity;

            Instance.yaw += xoffset;
            Instance.pitch += yoffset;

            // make sure that when pitch is out of bounds, screen doesn't get flipped
            if (Instance.pitch > 89.0f)
                Instance.pitch = 89.0f;
            if (Instance.pitch < -89.0f)
                Instance.pitch = -89.0f;

            var front = new Vec3();
            front.X = Math.cosf(glm_rad(Instance.yaw)) * Math.cosf(glm_rad(Instance.pitch));
            front.Y = Math.sinf(glm_rad(Instance.pitch));
            front.Z = Math.sinf(glm_rad(Instance.yaw)) * Math.cosf(glm_rad(Instance.pitch));
            glm_normalize_to(front, Instance.cameraFront);
        });

        glfwSetScrollCallback(window, (window, xoffset, yoffset) => {
            if (Instance.fov >= 1.0f && Instance.fov <= 45.0f)
                Instance.fov -= (float)yoffset;
            if (Instance.fov <= 1.0f)
                Instance.fov = 1.0f;
            if (Instance.fov >= 45.0f)
                Instance.fov = 45.0f;
        });

        #if (!__EMSCRIPTEN__)
        if (gladLoadGL() == 0)
        {
            print("Failed to initialize OpenGL context\n");
            return -1;
        }
        #endif

        glEnable(GL_DEPTH_TEST);

        ourShader = new Shader().Load("7.2.camera.vs", "7.2.camera.fs");
        
        float vertices[] = 
        {
            -0.5f, -0.5f, -0.5f,  0.0f, 0.0f,
             0.5f, -0.5f, -0.5f,  1.0f, 0.0f,
             0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
             0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
            -0.5f,  0.5f, -0.5f,  0.0f, 1.0f,
            -0.5f, -0.5f, -0.5f,  0.0f, 0.0f,

            -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
             0.5f, -0.5f,  0.5f,  1.0f, 0.0f,
             0.5f,  0.5f,  0.5f,  1.0f, 1.0f,
             0.5f,  0.5f,  0.5f,  1.0f, 1.0f,
            -0.5f,  0.5f,  0.5f,  0.0f, 1.0f,
            -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,

            -0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
            -0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
            -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
            -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
            -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
            -0.5f,  0.5f,  0.5f,  1.0f, 0.0f,

             0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
             0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
             0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
             0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
             0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
             0.5f,  0.5f,  0.5f,  1.0f, 0.0f,

            -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
             0.5f, -0.5f, -0.5f,  1.0f, 1.0f,
             0.5f, -0.5f,  0.5f,  1.0f, 0.0f,
             0.5f, -0.5f,  0.5f,  1.0f, 0.0f,
            -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
            -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,

            -0.5f,  0.5f, -0.5f,  0.0f, 1.0f,
             0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
             0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
             0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
            -0.5f,  0.5f,  0.5f,  0.0f, 0.0f,
            -0.5f,  0.5f, -0.5f,  0.0f, 1.0f
        };   
        // world space positions of our cubes
        cubePositions = {
            new Vec3( 0.0f,  0.0f,  0.0f),
            new Vec3( 2.0f,  5.0f, -15.0f),
            new Vec3(-1.5f, -2.2f, -2.5f),
            new Vec3(-3.8f, -2.0f, -12.3f),
            new Vec3 (2.4f, -0.4f, -3.5f),
            new Vec3(-1.7f,  3.0f, -7.5f),
            new Vec3( 1.3f, -2.0f, -2.5f),
            new Vec3( 1.5f,  2.0f, -2.5f),
            new Vec3( 1.5f,  0.2f, -1.5f),
            new Vec3(-1.3f,  1.0f, -1.5f)
        };
    
        VBO = 0;
        VAO = 0;
        glGenVertexArrays(1, &VAO);
        glGenBuffers(1, &VBO);

        glBindVertexArray(VAO);

        glBindBuffer(GL_ARRAY_BUFFER, VBO);
        glBufferData(GL_ARRAY_BUFFER, vertices.length*sizeof(float), vertices, GL_STATIC_DRAW);

        // position attribute
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 5 * (int)sizeof(float), (void*)0);
        glEnableVertexAttribArray(0);
        // texture coord attribute
        glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 5 * (int)sizeof(float), (void*)(3 * sizeof(float)));
        glEnableVertexAttribArray(1);

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

        // note: since the projection matrix rarely changes it's often best practice to set it outside the main loop only once.
        model = new Mat4();
        view = new Mat4();
        projection = new Mat4();
        // glm_perspective(glm_rad(45.0f), (float)SCR_WIDTH / (float)SCR_HEIGHT, 0.1f, 100.0f, projection);
                
        // tell opengl for each sampler to which texture unit it belongs to (only has to be done once)
        // -------------------------------------------------------------------------------------------
        ourShader.Use(); 
        ourShader.SetInt("texture1", 0);
        ourShader.SetInt("texture2", 1);
        ourShader.SetMat4("projection", projection);

#if (__EMSCRIPTEN__) 

        // Emscripten.set_main_loop(() => Instance.Update(), FPS, 0);
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
        // per-frame time logic
        // --------------------
        float currentFrame = (float)glfwGetTime();
        deltaTime = currentFrame - lastFrame;
        lastFrame = currentFrame;

        // input
        // -----
        ProcessInput(window);
        if (glfwWindowShouldClose(window) == GL_TRUE) 
            return;
            
        // render
        // ------
        glClearColor(0.2f, 0.3f, 0.3f, 1f);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        // bind textures on corresponding texture units
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, texture1);
        glActiveTexture(GL_TEXTURE1);
        glBindTexture(GL_TEXTURE_2D, texture2);

        // activate ourShader
        ourShader.Use();
        //========================================================

        // pass projection matrix to shader (note that in this case it could change every frame)
        glm_mat4_identity(projection);
        glm_perspective(glm_rad(fov), (float)SCR_WIDTH / (float)SCR_HEIGHT, 0.1f, 100.0f, projection);

        ourShader.SetMat4("projection", projection);

        // camera/view transformation)
        glm_mat4_identity(view);
        glm_vec_add(cameraPos, cameraFront, center);
        glm_lookat(cameraPos, center, cameraUp, view);
        ourShader.SetMat4("view", view);

        // render boxes
        glBindVertexArray(VAO);
        for (int i = 0; i < 10; i++)
        {
            // calculate the model matrix for each object and pass it to shader before drawing
            glm_mat4_identity(model);
            glm_translate(model, cubePositions[i]);
            float angle = 20.0f * i;
            glm_rotate(model, glm_rad(angle), axis);
            ourShader.SetMat4("model", model);

            glDrawArrays(GL_TRIANGLES, 0, 36);
        }

        //========================================================
        // glfw: swap buffers and poll IO events (keys pressed/released, mouse moved etc.)
        // -------------------------------------------------------------------------------
        glfwSwapBuffers(window);
        glfwPollEvents();
#if (!__EMSCRIPTEN__) 
        glfwWaitEventsTimeout(FRAME_RATE);
#endif
    }

    public void ProcessInput(GLFWwindow* window)
    {
        var scaled = new Vec3();
        var cross = new Vec3();

        if (glfwGetKey(window, Key.ESCAPE) == ButtonState.PRESS)
        {
            glfwSetWindowShouldClose(window, GL_TRUE);
        }

        float cameraSpeed = 2.5f * deltaTime; 
        if (glfwGetKey(window, Key.W) == ButtonState.PRESS)
        {
            glm_vec_scale(cameraFront, cameraSpeed, scaled);
            glm_vec_add(cameraPos, scaled, cameraPos);
            // cameraPos += cameraSpeed * cameraFront;
        }
        if (glfwGetKey(window, Key.S) == ButtonState.PRESS)
        {
            glm_vec_scale(cameraFront, cameraSpeed, scaled);
            glm_vec_sub(cameraPos, scaled, cameraPos);
            // cameraPos -= cameraSpeed * cameraFront;
        }
        if (glfwGetKey(window, Key.A) == ButtonState.PRESS)
        {
            glm_cross(cameraFront, cameraUp, cross);
            glm_normalize(cross);
            glm_vec_scale(cross, cameraSpeed, cross);
            glm_vec_sub(cameraPos, cross, cameraPos);
            // cameraPos -= glm::normalize(glm::cross(cameraFront, cameraUp)) * cameraSpeed;
        }
        if (glfwGetKey(window, Key.D) == ButtonState.PRESS)
        {
            glm_cross(cameraFront, cameraUp, cross);
            glm_normalize(cross);
            glm_vec_scale(cross, cameraSpeed, cross);
            glm_vec_add(cameraPos, cross, cameraPos);
            // cameraPos += glm::normalize(glm::cross(cameraFront, cameraUp)) * cameraSpeed;
        }
    }
}

