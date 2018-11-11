/*******************************************************************
** This code is part of Breakout.
**
** Breakout is free software: you can redistribute it and/or modify
** it under the terms of the CC BY 4.0 license as published by
** Creative Commons, either version 4 of the License, or (at your
** option) any later version.
******************************************************************/
using Glm;
using System;


// Container object for holding all state relevant for a single
// game object entity. Each object in the game likely needs the
// minimal of state as described within GameObject.
public class GameObject : Object
{
    // Object state
    public Vec2 Position;
    public Vec2 Size;
    public Vec2 Velocity;
    public Vec3 Color;
    public float Rotation;
    public bool IsSolid;
    public bool Destroyed;
    // Render state
    public Texture2D? Sprite;	

    public GameObject(
        Vec2 pos, 
        Vec2 size, 
        Texture2D sprite, 
        Vec3 color = new Vec3(1f, 1f, 1f), 
        Vec2 velocity = new Vec2(0f, 0f))
    {
        Position = pos;
        Size = size;
        Velocity = velocity;
        Color = color;
        Rotation = 0f;
        Sprite = sprite;
        IsSolid = false;
        Destroyed = false;
    }
    
    // Draw sprite
    public void Draw(SpriteRenderer renderer)
    {
        renderer.DrawSprite(Sprite, Position, Size, Rotation, Color);
    }
}