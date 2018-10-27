using System;
using Stb;

public class Image : Object
{
    int width;
    int height;
    int channels;
    IntPtr pixels;
    static bool first = true;

    /**
     * pixel width
     */
    public int Width { get { return width; } }
    /**
     * pixel height
     */
    public int Height { get { return height; } }
    /**
     * number of channels - rgb = 3, rgba = 4
     */
    public int Channels { get { return channels; } }
    /**
     * pixel data
     */
    public void* Pixels { get { return pixels; } } /** We could expose pixels as 
                                                        StbI.Image, but that would 
                                                        make a leaky abstraction  
                                                    */

    /**
     * Create a new image from the file path
     */
    public Image(string path)
    {
        if (first)
        {
            Stb.set_flip_vertically_on_load(1);
            first = false;
        }

        pixels = Stb.load(path, out width, out height, out channels, 0);
        if (pixels == null) 
            print("Unable to open %s\n", path);
    }

    /**
     * Frees the image pixel data
     */
    public void Dispose()
    {
        if (pixels != null) 
            Stb.image_free(pixels);
    }
}
