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
using System.Collections.Generic;

// Collision Detection

public enum Direction 
{
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

/**
 * Find the direction this target was hit from
 */
Direction VectorDirection(Vec2 target)
{
    Vec2[] compass = {
        new Vec2( 0f,  1f),	// up
        new Vec2( 1f,  0f),	// right
        new Vec2( 0f, -1f),	// down
        new Vec2(-1f,  0f)	// left
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

/**
 * Check for a collision between circular object and rectangle
 */
public Collision CheckCollision(BallObject one, GameObject two) // AABB - AABB collision
{
    // Get center point circle first 
    var center = new Vec2(one.Position.X + one.Radius, one.Position.Y + one.Radius);
    // Calculate AABB info (center, half-extents)
    var bbHalf = new Vec2(two.Size.X / 2, two.Size.Y / 2);
    var bbCenter = new Vec2(two.Position.X + bbHalf.X, two.Position.Y + bbHalf.Y);
    // Get difference vector between both centers
    var clamped = new Vec2(center.X-bbCenter.X, center.Y-bbCenter.Y);
    var bbMinus = new Vec3(-bbHalf.X, -bbHalf.Y);
    glm_vec2_clampv(clamped, bbMinus, bbHalf);
    // Add clamped value to AABB_center and we get the value of box closest to circle
    var closest = new Vec2(bbCenter.X + clamped.X, bbCenter.Y + clamped.Y);
    // Retrieve vector between center circle and closest point AABB and check if length <= radius
    var difference = new Vec2(closest.X - center.X, closest.Y - center.Y);
    //return glm_vec2_len(difference) < one.Radius;
    if (glm_vec2_len(difference) <= one.Radius)
        return { true, VectorDirection(difference), difference };
    else
        return { false, Direction.UP, new Vec2(0, 0) };

}