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

// ParticleGenerator acts as a container for rendering a large number of 
// particles by repeatedly spawning and updating particles and killing 
// them after a given amount of time.
public class ParticleGenerator : Object
{
    struct Vector2
    {
        float X;
        float Y;
    }

    struct Vector4
    {
        float W;
        float X;
        float Y;
        float Z;
    }

    // Represents a single particle and its state
    struct Particle
    {
        Vector2 Position;
        Vector2 Velocity;
        Vector4 Color;
        float Life;
        public Particle()
        {
            Position = { 0f, 0f };
            Velocity = { 0f, 0f };
            Color = { 1f, 1f, 1f, 1f };
            Life = 0;
        }
    }

    Rand rand { get; private owned set; default = new Rand(); }
    // State
    Particle[] particles;
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
        init();
    }

    // Update all particles
    public void Update(float dt, GameObject object, uint newParticles, float offsetX = 0.0f, float offsetY = 0.0f)
    {
        // Add new particles 
        for (int i = 0; i < newParticles; i++)
        {
            int unusedParticle = firstUnusedParticle();
            respawnParticle(ref particles[unusedParticle], object, { offsetX, offsetY });
        }
        // Update all particles
        for (int i = 0; i < amount; i++)
        {
            particles[i].Life -= dt; // reduce life
            if (particles[i].Life > 0.0f)
            {	// particle is alive, thus update
                particles[i].Position.X -= particles[i].Velocity.X * dt; 
                particles[i].Position.Y -= particles[i].Velocity.Y * dt; 
                particles[i].Color.Z -= dt * 2.5f;
            }
        }
    }

    // Render all particles
    public void Draw()
    {
        // Use additive blending to give it a 'glow' effect
        glBlendFunc(GL_SRC_ALPHA, GL_ONE);
        shader.Use();
        for (var i = 0; i < particles.length; i++)
        {
            if (particles[i].Life > 0.0f)
            {
                shader.SetVector2("offset", &particles[i].Position);
                shader.SetVector4("color",  &particles[i].Color);

                texture.Bind();
                glBindVertexArray(VAO);
                glDrawArrays(GL_TRIANGLES, 0, 6);
                glBindVertexArray(0);
            }
        }
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
        particles = new Particle[amount];
        for (int i = 0; i < amount; i++)
            particles[i] = { };
    }

    // Returns the first Particle index that's currently unused e.g. Life <= 0.0f or 0 if no particle is currently inactive
    int firstUnusedParticle()
    {
        // First search from last used particle, this will usually return almost instantly
        for (int i = lastUsedParticle; i < amount; i++){
            if (particles[i].Life <= 0.0f){
                lastUsedParticle = i;
                return i;
            }
        }
        // Otherwise, do a linear search
        for (int i = 0; i < lastUsedParticle; i++){
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
    void respawnParticle(ref Particle particle, GameObject object, Vector2 offset = { 0.0f, 0.0f })
    {
        float random = (float)(((rand.next_int() % 100) - 50) / 10.0f);
        float rColor = 0.5f + (float)((rand.next_int() % 100) / 100.0f);
        particle.Position.X = object.Position.X + random + offset.X;
        particle.Position.Y = object.Position.Y + random + offset.Y;
        particle.Color = { rColor, rColor, 0, 0.75f };
        particle.Life = 1.0f;
        particle.Velocity.X *= (object.Velocity.X * 0.1f);
        particle.Velocity.Y *= (object.Velocity.Y * 0.1f);
    }
}
