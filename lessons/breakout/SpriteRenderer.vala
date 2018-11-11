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

// Texture2D is able to store and configure a texture in OpenGL.
// It also hosts utility functions for easy management.
public class SpriteRenderer
{
    Shader shader; 
    uint quadVAO;

    public SpriteRenderer(Shader shader)
    {
        this.shader = shader;
        initRenderData();
    }

    ~SpriteRenderer()
    {
        glDeleteVertexArrays(1, &quadVAO);
    }

    public void DrawSprite(
            Texture2D texture, 
            Vec2 position, 
            Vec2 size = new Vec2(10, 10), 
            float rotate = 0f, 
            Vec3 color = new Vec3(1f, 1f, 1f))
    {
        // Prepare transformations
        Mat4 model = new Mat4();
        glm_mat4_identity(model);
        glm_translate(model, new Vec3(position.X, position.Y, 0f));  
        // First translate (transformations are: scale happens first, then rotation and then finall translation happens; reversed order)
        glm_translate(model, new Vec3(0.5f * size.X, 0.5f * size.Y, 0f)); 
        // Move origin of rotation to center of quad
        glm_rotate(model, rotate, new Vec3(0f, 0f, 1f)); // Then rotate
        glm_translate(model, new Vec3(-0.5f * size.X, -0.5f * size.Y, 0f)); 
        // Move origin back
        glm_scale(model, new Vec3(size.X, size.Y, 1f)); // Last scale

        shader.Use();
        shader.SetMatrix4("model", model);          // uniform mat4 model;
        shader.SetVector3("spriteColor", color);    // uniform vec3 spriteColor;

        glActiveTexture(GL_TEXTURE0);
        texture.Bind();
        glBindVertexArray(quadVAO);
        glDrawArrays(GL_TRIANGLES, 0, 6);
        glBindVertexArray(0);
    }

    void initRenderData()
    {
        // Configure VAO/VBO
        uint VBO = 0;
        float[] vertices = { 
            // Pos      // Tex
            0f, 1f,     0f, 1f,
            1f, 0f,     1f, 0f,
            0f, 0f,     0f, 0f, 

            0f, 1f,     0f, 1f,
            1f, 1f,     1f, 1f,
            1f, 0f,     1f, 0f
        };

        glGenVertexArrays(1, &quadVAO);     // returns n vertex array object names in arrays. 
        glGenBuffers(1, &VBO);              // returns n buffer object names in buffers.

        glBindBuffer(GL_ARRAY_BUFFER, VBO); // binds a buffer object to the specified buffer binding point. 
                                            // create a new data store for a buffer object
        glBufferData(GL_ARRAY_BUFFER, sizeof(float)*vertices.length, vertices, GL_STATIC_DRAW);

        glBindVertexArray(quadVAO);         // binds the vertex array object with quadVAO
        glEnableVertexAttribArray(0);       // enable the generic vertex attribute array specified by index.
                                            // specify the location and data format of the array of 
                                            // generic vertex attributes at index index to use when rendering
        glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, (GLsizei)(4 * sizeof(float)), (GLvoid*)0);
                                            // reset:
        glBindBuffer(GL_ARRAY_BUFFER, 0);   // break the binding.
        glBindVertexArray(0);               // break the binding.
    }
}