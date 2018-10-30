/*******************************************************************
** This code is part of Breakout.
**
** Breakout is free software: you can redistribute it and/or modify
** it under the terms of the CC BY 4.0 license as published by
** Creative Commons, either version 4 of the License, or (at your
** option) any later version.
******************************************************************/
using Glm;
using GLFW3;
using System;
using System.Collections.Generic;

// Represents the current state of the game
public enum GameState 
{
    ACTIVE,
    MENU,
    WIN,
    DONE
}
// Game holds all game-related state and functionality.
// Combines all game-related data into a single class for
// easy access to each of the components and manageability.
public class Game : Object
{
    public GameState State;
    public bool Keys[1024];
    public int Width;
    public int Height;

    SpriteRenderer Renderer;
    ArrayList<GameLevel> Levels = new ArrayList<GameLevel>();
    int Level;

    Vec2 PLAYER_SIZE = new Vec2(100, 20);
    const float PLAYER_VELOCITY = 500f;
    GameObject Player;

    Vec2 INITIAL_BALL_VELOCITY = new Vec2(100f, -350f);
    const float BALL_RADIUS = 12.5f;
    BallObject Ball; 

    public Game(int width, int height)
    {
        Width = width;
        Height = height;
        State = GameState.ACTIVE;
    }   

    public void Init()
    {
        // Load shaders
        ResourceManager.LoadShader("shaders/sprite.vs", "shaders/sprite.frag", null, "sprite");

        // Load textures
        ResourceManager.LoadTexture("textures/paddle.png", true, "paddle");
        ResourceManager.LoadTexture("textures/background.jpg", false, "background");
        ResourceManager.LoadTexture("textures/awesomeface.png", true, "face");
        ResourceManager.LoadTexture("textures/block.png", false, "block");
        ResourceManager.LoadTexture("textures/block_solid.png", false, "block_solid");

        // Load levels
        Levels.Add(new GameLevel("levels/one.lvl",  Width, (int)(Height * 0.5)));
        Levels.Add(new GameLevel("levels/two.lvl",  Width, (int)(Height * 0.5)));
        Levels.Add(new GameLevel("levels/three.lvl",Width, (int)(Height * 0.5)));
        Levels.Add(new GameLevel("levels/four.lvl", Width, (int)(Height * 0.5)));
        Level = 1;        

        Mat4 projection = new Mat4();
        glm_mat4_identity(projection);
        glm_ortho(0f, (float)Width, (float)Height, 0f, -1f, 1f, projection);

        // Configure Shaders
        var shader = ResourceManager.GetShader("sprite");
        shader.Use(); 
        shader.SetMatrix4("projection", projection);    //  uniform mat4 projection;
        shader.SetInteger("image", 0);                  //  uniform sampler2D image;

        // Set Game Objects
        var playerPos = new Vec2(Width / 2 - PLAYER_SIZE.X / 2, Height - PLAYER_SIZE.Y);
        Player = new GameObject(playerPos, PLAYER_SIZE, ResourceManager.GetTexture("paddle"));

        var ballPos = new Vec2(playerPos.X + PLAYER_SIZE.X / 2 - BALL_RADIUS, playerPos.Y + -BALL_RADIUS * 2);
        Ball = new BallObject(ballPos, BALL_RADIUS, INITIAL_BALL_VELOCITY, ResourceManager.GetTexture("face"));

        // Set renderer
        Renderer = new SpriteRenderer(shader);
    }

    public void Update(float dt)
    {
        Ball.Move(dt, Width);
        DoCollisions();
        if (Ball.Position.Y >= Height) // Did ball reach bottom edge?
        {
            Levels[Level].Reset();
            ResetPlayer();
        }        
    }

    public void ProcessInput(float dt)
    {
        if (State == GameState.ACTIVE)
        {
            float velocity = PLAYER_VELOCITY * dt;

            if (Keys[GLFW_KEY_A] || Keys[GLFW_KEY_LEFT])
            {
                if (Player.Position.X >= 0)
                    Player.Position.X -= velocity;
                    if (Ball.Stuck)
                        Ball.Position.X -= velocity;
            }

            if (Keys[GLFW_KEY_D] || Keys[GLFW_KEY_RIGHT])
            {
                if (Player.Position.X <= Width - Player.Size.X)
                    Player.Position.X += velocity;
                    if (Ball.Stuck)
                        Ball.Position.X += velocity;
            }

            if (Keys[GLFW_KEY_SPACE])
                Ball.Stuck = false;
        }
    }

    public void Render()
    {
        if (State == GameState.ACTIVE)
        {
            Renderer.DrawSprite(ResourceManager.GetTexture("background"), new Vec2(0, 0), new Vec2(Width, Height), 0f);
            Levels[Level].Draw(Renderer);
            Player.Draw(Renderer);          
            Ball.Draw(Renderer);
        }
    }

    public void DoCollisions()
    {
        foreach (GameObject box in Levels[Level].Bricks)
        {
            if (!box.Destroyed)
            {
                Collision collision = CheckCollision(Ball, box);
                if (collision.isTrue)
                {
                    // Destroy block if not solid
                    if (!box.IsSolid)
                        box.Destroyed = true;
                    // Collision resolution
                    Direction dir = collision.dir;
                    Vec2 diff_vector = collision.vec;
                    if (dir == Direction.LEFT || dir == Direction.RIGHT) // Horizontal collision
                    {
                        Ball.Velocity.X = -Ball.Velocity.X; // Reverse horizontal velocity
                        // Relocate
                        float penetration = Ball.Radius - Math.fabsf(diff_vector.X);
                        if (dir == Direction.LEFT)
                            Ball.Position.X += penetration; // Move ball to right
                        else
                            Ball.Position.X -= penetration; // Move ball to left;
                    }
                    else // Vertical collision
                    {
                        Ball.Velocity.Y = -Ball.Velocity.Y; // Reverse vertical velocity
                        // Relocate
                        float penetration = Ball.Radius - Math.fabsf(diff_vector.Y);
                        if (dir == Direction.UP)
                            Ball.Position.Y -= penetration; // Move ball back up
                        else
                            Ball.Position.Y += penetration; // Move ball back down
                    }
                }
            }
        }

        Collision result = CheckCollision(Ball, Player);
        if (!Ball.Stuck && result.isTrue)
        {
            // Check where it hit the board, and change velocity based on where it hit the board
            float centerBoard = Player.Position.X + Player.Size.X / 2;
            float distance = (Ball.Position.X + Ball.Radius) - centerBoard;
            float percentage = distance / (Player.Size.X / 2);
            // Then move accordingly
            float strength = 2f;
            Vec2 oldVelocity = Ball.Velocity;
            Ball.Velocity.X = INITIAL_BALL_VELOCITY.X * percentage * strength; 
            // Ball.Velocity.Y = -Ball.Velocity.Y;
            Ball.Velocity.Y = -1 * Math.fabsf(Ball.Velocity.Y);

            var length = glm_vec2_len(oldVelocity);
            glm_vec2_normalize(Ball.Velocity);
            Ball.Velocity.X *= length;
            Ball.Velocity.Y *= length;
         } 
    }

    void ResetPlayer()
    {
        // Reset player/ball stats
        Player.Size = PLAYER_SIZE;
        Player.Position = new Vec2(Width / 2 - PLAYER_SIZE.X / 2, Height - PLAYER_SIZE.Y);
        var pos = new Vec2(PLAYER_SIZE.X / 2 - BALL_RADIUS, -(BALL_RADIUS * 2));
        Ball.Reset(new Vec2(Player.Position.X + pos.X, Player.Position.Y + pos.Y), INITIAL_BALL_VELOCITY);
    }

    ~Game()
    {
        Renderer = null;
        Player = null;
        Ball = null;
        print("~Game\n");
    }
}