/*******************************************************************
** This code is part of Breakout.
**
** Breakout is free software: you can redistribute it and/or modify
** it under the terms of the CC BY 4.0 license as published by
** Creative Commons, either version 4 of the License, or (at your
** option) any later version.
******************************************************************/
using GL;
using GLFW;
using System;
using cglm; // class based version


// Represents the current state of the game
public enum GameState {
    GAME_ACTIVE,
    GAME_MENU,
    GAME_WIN
}

static int main (string[] args) 
{
    return new Game().Run();
}

// Game holds all game-related state and functionality.
// Combines all game-related data into a single class for
// easy access to each of the components and manageability.
public class Game : Object
{
    public GameState State;
    public GLboolean keys[1024];
    public GLuint Width;
    public GLuint Height;

    public Game(int width, int height)
    {
        this.width = width;
        this.height = height;
        this.state = GameState.GAME_ACTIVE;
    }

    ~Game()
    {

    }

    void Init()
    {

    }

    void Update(GLfloat dt)
    {

    }

    void ProcessInput(GLfloat dt)
    {

    }

    void Render()
    {

    }
}

