/*******************************************************************
** This code is part of Breakout.
**
** Breakout is free software: you can redistribute it and/or modify
** it under the terms of the CC BY 4.0 license as published by
** Creative Commons, either version 4 of the License, or (at your
** option) any later version.
******************************************************************/
using GL;
using GLEW;
using GLFW3;
using System;
using System.Collections.Generic;
using Glm;

// Represents the current state of the game
public enum GameState {
    GAME_ACTIVE,
    GAME_MENU,
    GAME_WIN
}
public enum Direction {
	UP,
	RIGHT,
	DOWN,
	LEFT
}

public struct Collision
{
    public bool isTrue;
    public Direction dir;
    public Vec2 vec;
}

Direction VectorDirection(Vec2 target)
{
    Vec2[] compass = {
        new Vec2( 0f, 1f),	// up
        new Vec2( 1f, 0f),	// right
        new Vec2( 0f,-1f),	// down
        new Vec2(-1f, 0f)	// left
    };
    float max = 0f;
    int best_match = -1;
    glm_vec2_normalize(target);
    for (int i = 0; i < 4; i++)
    {
        float dot_product = glm_vec2_dot(target, compass[i]);
        if (dot_product > max)
        {
            max = dot_product;
            best_match = i;
        }
    }
    return (Direction)best_match;
}    


public Collision CheckCollision(BallObject one, GameObject two) // AABB - AABB collision
{
    // Get center point circle first 
    var center = new Vec2(one.Position.X + one.Radius, one.Position.Y + one.Radius);
    // Calculate AABB info (center, half-extents)
    var aabb2e = new Vec2(two.Size.X / 2, two.Size.Y / 2);
    var aabb_center = new Vec2(
        two.Position.X + aabb2e.X, 
        two.Position.Y + aabb2e.Y
    );
    // Get difference vector between both centers
    var clamped = new Vec2(center.X-aabb_center.X, center.Y-aabb_center.Y);
    var aabb2eNeg = new Vec3(-aabb2e.X, -aabb2e.Y);
    glm_vec2_clampv(clamped, aabb2eNeg, aabb2e);
    // Add clamped value to AABB_center and we get the value of box closest to circle
    var closest = new Vec2(aabb_center.X + clamped.X, aabb_center.Y + clamped.Y);
    // Retrieve vector between center circle and closest point AABB and check if length <= radius
    var difference = new Vec2(closest.X - center.X, closest.Y - center.Y);
    //return glm_vec2_len(difference) < one.Radius;
    if (glm_vec2_len(difference) <= one.Radius)
        return { true, VectorDirection(difference), difference };
    else
        return { false, Direction.UP, new Vec2(0, 0) };

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

    // Initial velocity of the Ball
    Vec2 INITIAL_BALL_VELOCITY = new Vec2(100f, -350f);
    // Radius of the ball object
    const float BALL_RADIUS = 12.5f;
    
    BallObject Ball; 
  


    public Game(int width, int height)
    {
        Width = width;
        Height = height;
        State = GameState.GAME_ACTIVE;
        // new ResourceManager(330, "core");
        new ResourceManager(300, "es");
    }   

    ~Game()
    {
        Renderer = null;
        Player = null;
        Ball = null;
        print("Bye!\n");

    }

    public void Init()
    {
        // Load shaders
        ResourceManager.LoadShader("shaders/sprite.vs", "shaders/sprite.frag", null, "sprite");
        // Configure shaders
        Mat4 projection = new Mat4();
        glm_mat4_identity(projection);
        glm_ortho(0f, (float)Width, (float)Height, 0f, -1f, 1f, projection);
        ResourceManager.GetShader("sprite").Use().SetInteger("image", 0);
        ResourceManager.GetShader("sprite").SetMatrix4("projection", projection);
        // Set render-specific controls
        Renderer = new SpriteRenderer(ResourceManager.GetShader("sprite"));
        // Load textures
        ResourceManager.LoadTexture("textures/awesomeface.png", true, "face");
        ResourceManager.LoadTexture("textures/paddle.png", true, "paddle");
        // Load textures
        ResourceManager.LoadTexture("textures/background.jpg", false, "background");
        ResourceManager.LoadTexture("textures/awesomeface.png", true, "face");
        ResourceManager.LoadTexture("textures/block.png", false, "block");
        ResourceManager.LoadTexture("textures/block_solid.png", false, "block_solid");
        // Load levels
        var one = new GameLevel();  one.Load("levels/one.lvl", Width, (int)(Height * 0.5));
        var two = new GameLevel();  two.Load("levels/two.lvl", Width, (int)(Height * 0.5));
        var three = new GameLevel(); three.Load("levels/three.lvl", Width, (int)(Height * 0.5));
        var four = new GameLevel(); four.Load("levels/four.lvl", Width, (int)(Height * 0.5));
        Levels.Add(one);
        Levels.Add(two);
        Levels.Add(three);
        Levels.Add(four);
        Level = 1;        

        var playerPos = new Vec2(
            Width / 2 - PLAYER_SIZE.X / 2, 
            Height - PLAYER_SIZE.Y
        );
        Player = new GameObject(playerPos, PLAYER_SIZE, ResourceManager.GetTexture("paddle"));

        var ballPos = new Vec2(
            playerPos.X + PLAYER_SIZE.X / 2 - BALL_RADIUS,
            playerPos.Y + -BALL_RADIUS * 2
        );
        Ball = new BallObject(ballPos, BALL_RADIUS, INITIAL_BALL_VELOCITY,
            ResourceManager.GetTexture("face"));

    }

    public void Update(float dt)
    {
        // Update objects
        Ball.Move(dt, Width);
        // Check for collisions
        DoCollisions();
        if (Ball.Position.Y >= Height) // Did ball reach bottom edge?
        {
            ResetLevel();
            ResetPlayer();
        }        
    }

    public void ProcessInput(float dt)
    {
        if (State == GameState.GAME_ACTIVE)
        {
            float velocity = PLAYER_VELOCITY * dt;
            // Move playerboard
            if (Keys[GLFW_KEY_A])
            {
                if (Player.Position.X >= 0)
                    Player.Position.X -= velocity;
                    if (Ball.Stuck)
                        Ball.Position.X -= velocity;
            }
            if (Keys[GLFW_KEY_D])
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
        // Renderer.DrawSprite(ResourceManager.GetTexture("face"), 
        //     new Vec2(200, 200), new Vec2(300, 400), 45f, new Vec3(0f, 1f, 0f));
        if (State == GameState.GAME_ACTIVE)
        {
            // Draw background
            Renderer.DrawSprite(ResourceManager.GetTexture("background"), new Vec2(0, 0), new Vec2(Width, Height), 0f);
            // Draw level
            Levels[Level].Draw(Renderer);
            // print("(%f,%f)\n", Player.Position.X, Player.Position.Y);
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

    void ResetLevel()
    {
        if (Level == 0)Levels[0].Load("levels/one.lvl", Width, (int)(Height * 0.5f));
        else if (Level == 1)
            Levels[1].Load("levels/two.lvl", Width, (int)(Height * 0.5f));
        else if (Level == 2)
            Levels[2].Load("levels/three.lvl", Width, (int)(Height * 0.5f));
        else if (Level == 3)
            Levels[3].Load("levels/four.lvl", Width, (int)(Height * 0.5f));
    }

    void ResetPlayer()
    {
        // Reset player/ball stats
        Player.Size = PLAYER_SIZE;
        Player.Position = new Vec2(Width / 2 - PLAYER_SIZE.X / 2, Height - PLAYER_SIZE.Y);
        var pos = new Vec2(PLAYER_SIZE.X / 2 - BALL_RADIUS, -(BALL_RADIUS * 2));
        Ball.Reset(new Vec2(Player.Position.X + pos.X, Player.Position.Y + pos.Y), INITIAL_BALL_VELOCITY);
    }
}

