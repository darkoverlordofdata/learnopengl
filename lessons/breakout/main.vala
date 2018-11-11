/*******************************************************************
** This code is part of Breakout.
**
** Breakout is free software: you can redistribute it and/or modify
** it under the terms of the CC BY 4.0 license as published by
** Creative Commons, either version 4 of the License, or (at your
** option) any later version.
******************************************************************/
using GL;
using GLFW3;
using System;

static int main (string[] args) 
{
    return new Breakout().Run();
}

class Breakout : Object 
{
    public static Breakout Instance; 
    public static Game game;
    public static bool Done = false;

    #if (__EMSCRIPTEN__)
    const int VERSION = 300;
    const string PROFILE = "es";
    #else
    const int VERSION = 330;
    const string PROFILE = "core";
    #endif
    const int SCREEN_WIDTH = 800;
    const int SCREEN_HEIGHT = 600;
    float deltaTime = 0f;
    float lastFrame = 0f;
    GLFWwindow* window;

    public Breakout()
    {
        glfwInit();
        glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, VERSION/100);
        glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, (VERSION%100)/10);
        glfwWindowHint(GLFW_RESIZABLE, GL_FALSE);
        glfwWindowHint(GLFW_OPENGL_PROFILE, 
            VERSION < 320 
                ? GLFW_OPENGL_ANY_PROFILE 
                : PROFILE == "core" 
                    ? GLFW_OPENGL_CORE_PROFILE 
                    : GLFW_OPENGL_COMPAT_PROFILE );

        window = glfwCreateWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Breakout", null, null);
        glfwMakeContextCurrent(window);

        glewExperimental = true;
        glewInit();
        glGetError(); 
        glfwSetKeyCallback(window, KeyCallback);
        glViewport(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        glEnable(GL_CULL_FACE);
        glEnable(GL_BLEND);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        Instance = this;
    }

    public int Run()
    {
        new ResourceManager(VERSION, PROFILE);
        game = new Game(SCREEN_WIDTH, SCREEN_HEIGHT);
        game.Init();
        game.State = GameState.ACTIVE;
        #if (__EMSCRIPTEN__)
        Emscripten.set_main_loop(() => Instance.Update(), -1, 0);
        #else
        while (!glfwWindowShouldClose(window)) Update();
        #endif
        if (Done) Instance = null;
        return 0;
    }

    public void Update()
    {
        var currentFrame = (float)glfwGetTime();
        deltaTime = currentFrame - lastFrame;
        lastFrame = currentFrame;
        glfwPollEvents();
        game.ProcessInput(deltaTime);
        game.Update(deltaTime);
        glClearColor(0, 0, 0, 1);
        glClear(GL_COLOR_BUFFER_BIT);
        game.Render();
        glfwSwapBuffers(window);
    }

    ~Breakout()
    {
        // Delete all resources as loaded using the resource manager
        ResourceManager.Clear();
        glfwTerminate();
        game = null;
        print("~Breakout\n");
    }
}

void KeyCallback(GLFWwindow* window, int key, int scancode, int action, int mode)
{
    // When a user presses the escape key, we set the WindowShouldClose property to true, closing the application
    if (key == GLFW_KEY_ESCAPE && action == GLFW_PRESS)
    {
        glfwSetWindowShouldClose(window, GL_TRUE);
        Breakout.Done = true;
    }
    if (key >= 0 && key < 1024)
    {
        if (action == GLFW_PRESS)
            Breakout.game.Keys[key] = true;
        else if (action == GLFW_RELEASE)
            Breakout.game.Keys[key] = false;
    }
}