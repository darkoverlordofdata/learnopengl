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
using System.IO;
using System.Collections.Generic;
using Glm;

/// GameLevel holds all Tiles as part of a Breakout level and 
/// hosts functionality to Load/render levels from the harddisk.
public class GameLevel : Object
{
    // Level state
    public ArrayList<GameObject> Bricks = new ArrayList<GameObject>();
    // Constructor
    public GameLevel() 
    { 

    }
    // Loads level from file
    public void Load(string file, int levelWidth, int levelHeight)
    {
        // Clear old data
        Bricks.Clear();
        // Load from file
        // int tileCode;
        GameLevel level;
        string? line = null;
        var fhandle = new FileHandle(ResourceManager.ROOT+file);
        var fstream = new BufferedReader(
                            new InputStreamReader(
                                new FileInputStream.FromFile(fhandle.file)));
        var tileData = new ArrayList<ArrayList<int>>();
        do 
        {
            line = fstream.ReadLine();
            if (line != null) {
                line = line.trim();
                var row = new ArrayList<int>();
                foreach (var tileCode in line.split(" "))
                    row.Add(int.parse(tileCode));
                tileData.Add(row);

            }
        } while (line != null);
        if (tileData.Count > 0)
            init(tileData, levelWidth, levelHeight);

        // std::ifstream fstream(file);
        // var tileData = new ArrayList<ArrayList<int>>();
        // if (fstream)
        // {
        //     while (std::getline(fstream, line)) // Read each line from level file
        //     {
        //         std::istringstream sstream(line);
        //         var row = new ArrayList<int>();
        //         while (sstream >> tileCode) // Read each word seperated by spaces
        //             row.Add(tileCode);
        //         tileData.Add(row);
        //     }
        //     if (tileData.size() > 0)
        //         init(tileData, levelWidth, levelHeight);
        // }
    }
    // Render level
    public void Draw(SpriteRenderer renderer)
    {
        foreach (GameObject tile in Bricks)
            if (!tile.Destroyed)
                tile.Draw(renderer);
    }
    // Check if the level is completed (all non-solid tiles are destroyed)
    public bool IsCompleted()
    {
        foreach (GameObject tile in Bricks)
            if (!tile.IsSolid && !tile.Destroyed)
                return false;
        return true;
    }

    // Initialize level from tile data
    void init(ArrayList<ArrayList<int>> tileData, int levelWidth, int levelHeight)
    {
        // Calculate dimensions
        int height = tileData.Count;
        int width = tileData[0].Count; // Note we can index vector at [0] since this function is only called if height > 0
        float unit_width = levelWidth / (float)width, unit_height = levelHeight / height; 
        // Initialize level tiles based on tileData		
        for (int y = 0; y < height; ++y)
        {
            for (int x = 0; x < width; ++x)
            {
                // Check block type from level data (2D level array)
                if (tileData[y][x] == 1) // Solid
                {
                    var pos = new Vec2(unit_width * x, unit_height * y);
                    var size = new Vec2(unit_width, unit_height);
                    var obj = new GameObject(pos, size, ResourceManager.GetTexture("block_solid"), new Vec3(0.8f, 0.8f, 0.7f));
                    obj.IsSolid = true;
                    Bricks.Add(obj);
                }
                else if (tileData[y][x] > 1)	// Non-solid; now determine its color based on level data
                {
                    Vec3 color = new Vec3(1f, 1f, 1f); // original: white
                    if (tileData[y][x] == 2)
                        color = new Vec3(0.2f, 0.6f, 1.0f);
                    else if (tileData[y][x] == 3)
                        color = new Vec3(0.0f, 0.7f, 0.0f);
                    else if (tileData[y][x] == 4)
                        color = new Vec3(0.8f, 0.8f, 0.4f);
                    else if (tileData[y][x] == 5)
                        color = new Vec3(1.0f, 0.5f, 0.0f);

                    var pos = new Vec2(unit_width * x, unit_height * y);
                    var size = new Vec2(unit_width, unit_height);
                    Bricks.Add(new GameObject(pos, size, ResourceManager.GetTexture("block"), color));
                }
            }
        }
    }
}