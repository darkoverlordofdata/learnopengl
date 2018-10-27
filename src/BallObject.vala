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
using Glm;


public class BallObject : GameObject
{
    // Ball state	
    public float Radius;
    public bool Stuck;

    public BallObject.Empty()
    {
        base.Empty();
        Rotation = 12.5f;
        Stuck = true;
    }

    public BallObject(Vec2 pos, float radius, Vec2 velocity, Texture2D sprite)
    {
        base(pos, new Vec2(radius*2, radius*2), sprite, new Vec3(1f, radius*2, radius*2), velocity);
        Radius = radius;
        Stuck = true;
    }


    public Vec2 Move(float dt, int window_width)
    {
        // If not stuck to player board
        if (!Stuck)
        { 
            // Move the ball
            Position.X += Velocity.X * dt;
            Position.Y += Velocity.Y * dt;
            // Position += Velocity * dt;
            // Check if outside window bounds; if so, reverse velocity and restore at correct position
            if (Position.X <= 0.0f)
            {
                Velocity.X = -Velocity.X;
                Position.X = 0.0f;
            }
            else if (Position.X + Size.X >= window_width)
            {
                Velocity.X = -Velocity.X;
                Position.X = window_width - Size.X;
            }
            if (Position.Y <= 0.0f)
            {
                Velocity.Y = -Velocity.Y;
                Position.Y = 0.0f;
            }
        
        }
        return Position;
    }

    public void Reset(Vec2 position, Vec2 velocity)
    {
        Position = position;
        Velocity = velocity;
        Stuck = true;
    }
}