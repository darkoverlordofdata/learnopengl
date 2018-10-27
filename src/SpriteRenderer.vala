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

// Texture2D is able to store and configure a texture in OpenGL.
// It also hosts utility functions for easy management.
public class SpriteRenderer
{
    Shader shader; 
    GLuint quadVAO;

    public SpriteRenderer(Shader shader)
    {
        this.shader = shader;
        initRenderData();

    }
    ~SpriteRenderer()
    {
        glDeleteVertexArrays(1, &this.quadVAO);
    }

    public void DrawSprite(Texture2D texture, Vec2 position, 
            Vec2 size = new Vec2(10, 10), GLfloat rotate = 0.0f, 
            Vec3 color = new Vec3(1.0f))
    {
        // Prepare transformations
        shader.Use();
        Mat4 model = new Mat4();
        glm_mat4_identity(model);

        glm_translate(model, new Vec3(position.X, position.Y, 0.0f));  
        // First translate (transformations are: scale happens first, then rotation and then finall translation happens; reversed order)

        glm_translate(model, new Vec3(0.5f * size.X, 0.5f * size.Y, 0.0f)); 
        // Move origin of rotation to center of quad
        glm_rotate(model, rotate, new Vec3(0.0f, 0.0f, 1.0f)); // Then rotate
        glm_translate(model, new Vec3(-0.5f * size.X, -0.5f * size.Y, 0.0f)); 
        // Move origin back

        glm_scale(model, new Vec3(size.X, size.Y, 1.0f)); // Last scale

        shader.SetMatrix4("model", model);

        // Render textured quad
        shader.SetVector3("spriteColor", color);

        glActiveTexture(GL_TEXTURE0);
        texture.Bind();

        glBindVertexArray(quadVAO);
        glDrawArrays(GL_TRIANGLES, 0, 6);
        glBindVertexArray(0);

    }

    void initRenderData()
    {
        // Configure VAO/VBO
        GLuint VBO = 0;
        GLfloat[] vertices = { 
            // Pos      // Tex
            0.0f, 1.0f, 0.0f, 1.0f,
            1.0f, 0.0f, 1.0f, 0.0f,
            0.0f, 0.0f, 0.0f, 0.0f, 

            0.0f, 1.0f, 0.0f, 1.0f,
            1.0f, 1.0f, 1.0f, 1.0f,
            1.0f, 0.0f, 1.0f, 0.0f
        };

        glGenVertexArrays(1, &this.quadVAO);
        glGenBuffers(1, &VBO);

        glBindBuffer(GL_ARRAY_BUFFER, VBO);
        glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat)*vertices.length, vertices, GL_STATIC_DRAW);

        glBindVertexArray(this.quadVAO);
        glEnableVertexAttribArray(0);
        glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, (GLsizei)(4 * sizeof(GLfloat)), (GLvoid*)0);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glBindVertexArray(0);

    }
}