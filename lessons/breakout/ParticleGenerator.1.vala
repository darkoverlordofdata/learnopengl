 /*******************************************************************
** This code is part of Breakout.
**
** Breakout is free software: you can redistribute it and/or modify
** it under the terms of the CC BY 4.0 license as published by
** Creative Commons, either version 4 of the License, or (at your
** option) any later version.
******************************************************************/
using GL;
using Glm; 
using System;

// Represents a single particle and its state
public class Particle : Object 
{
    public Vec2 Position;
    public Vec2 Velocity;
    public Vec4 Color;
    public float Life;
    public Particle()
    {
        Position = new Vec2(0f, 0f);
        Velocity = new Vec2(0f, 0f);
        Color = new Vec4(1f, 1f, 1f, 1f);
        Life = 0;
    }
}

// ParticleGenerator acts as a container for rendering a large number of 
// particles by repeatedly spawning and updating particles and killing 
// them after a given amount of time.
public class ParticleGenerator : Object
{
    Rand rand { get; private owned set; default = new Rand(); }
    // State
    GenericArray<Particle> particles;
    uint amount;
    
    // Render state
    Shader shader;
    Texture2D texture;
    uint VAO;
    // Stores the index of the last particle used (for quick access to next dead particle)
    int lastUsedParticle = 0;

    public ParticleGenerator(Shader shader, Texture2D texture, uint amount)
    {
        this.shader = shader;
        this.texture = texture;
        this.amount = amount;
        particles = new GenericArray<Particle>(amount);
        init();
    }

    // Update all particles
    public void Update(float dt, GameObject object, uint newParticles, Vec2 offset = new Vec2(0.0f, 0.0f))
    {
        // Add new particles 
        for (int i = 0; i < newParticles; ++i)
        {
            int unusedParticle = firstUnusedParticle();
            respawnParticle(particles[unusedParticle], object, offset);
        }
        // Update all particles
        for (int i = 0; i < amount; ++i)
        {
            var p = particles[i];
            p.Life -= dt; // reduce life
            if (p.Life > 0.0f)
            {	// particle is alive, thus update
                p.Position.X -= p.Velocity.X * dt; 
                p.Position.Y -= p.Velocity.Y * dt; 
                p.Color.Z -= dt * 2.5f;
            }
        }
    }

    // Render all particles
    public void Draw()
    {
        // Use additive blending to give it a 'glow' effect

        glBlendFunc(GL_SRC_ALPHA, GL_ONE);
        shader.Use();
        particles.foreach((particle) => {
            if (particle.Life > 0.0f)
            {
                shader.SetVector2("offset", particle.Position);
                shader.SetVector4("color", particle.Color);
                texture.Bind();
                glBindVertexArray(VAO);
                glDrawArrays(GL_TRIANGLES, 0, 6);
                glBindVertexArray(0);
            }
        });
        // Don't forget to reset to default blending mode
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    }

    // Initializes buffer and vertex attributes
    void init()
    {
        // Set up mesh and attribute properties
        uint VBO = 0;
        float[] particle_quad = {
            0.0f, 1.0f, 0.0f, 1.0f,
            1.0f, 0.0f, 1.0f, 0.0f,
            0.0f, 0.0f, 0.0f, 0.0f,

            0.0f, 1.0f, 0.0f, 1.0f,
            1.0f, 1.0f, 1.0f, 1.0f,
            1.0f, 0.0f, 1.0f, 0.0f
        }; 
        glGenVertexArrays(1, &VAO);
        glGenBuffers(1, &VBO);
        glBindVertexArray(VAO);
        // Fill mesh buffer
        glBindBuffer(GL_ARRAY_BUFFER, VBO);
        glBufferData(GL_ARRAY_BUFFER, sizeof(float)*particle_quad.length, particle_quad, GL_STATIC_DRAW);
        // Set mesh attributes
        glEnableVertexAttribArray(0);
        glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, (int)(4 * sizeof(float)), (void*)0);
        glBindVertexArray(0);

        // Create amount default particle instances
        for (int i = 0; i < amount; ++i)
            particles.add(new Particle());
    }

    // Returns the first Particle index that's currently unused e.g. Life <= 0.0f or 0 if no particle is currently inactive
    int firstUnusedParticle()
    {
        // First search from last used particle, this will usually return almost instantly
        for (int i = lastUsedParticle; i < amount; ++i){
            if (particles[i].Life <= 0.0f){
                lastUsedParticle = i;
                return i;
            }
        }
        // Otherwise, do a linear search
        for (int i = 0; i < lastUsedParticle; ++i){
            if (particles[i].Life <= 0.0f){
                lastUsedParticle = i;
                return i;
            }
        }
        // All particles are taken, override the first one (note that if it repeatedly hits this case, more particles should be reserved)
        lastUsedParticle = 0;
        return 0;
    }

    // Respawns particle
    void respawnParticle(Particle particle, GameObject object, Vec2 offset = new Vec2(0.0f, 0.0f))
    {
        float random = (float)(((rand.next_int() % 100) - 50) / 10.0f);
        float rColor = 0.5f + (float)((rand.next_int() % 100) / 100.0f);
        // float random = (float)rand.double_range(-5, 5);
        // float rColor = (float)rand.double_range(0, 1);
        particle.Position.X = object.Position.X + random + offset.X;
        particle.Position.Y = object.Position.Y + random + offset.Y;
        particle.Color = new Vec4(rColor, rColor, rColor, 1.0f);
        particle.Life = 1.0f;
        particle.Velocity.X *= (object.Velocity.X * 0.1f);
        particle.Velocity.Y *= (object.Velocity.Y * 0.1f);
    }
}
