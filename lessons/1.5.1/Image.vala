using System;

public class Image : Object
{
    int width;
    int height;
    int channels;
    StbI.Image pixels;
    static bool first = true;

    public int Width { get { return width; } }
    public int Height { get { return height; } }
    public int Channels { get { return channels; } }
    public void* Pixels { get { return pixels; } } /** We could expose pixels as 
                                                        StbI.Image, but that would 
                                                        make a leaky abstraction  
                                                    */

    public Image(string path)
    {
        if (first)
        {
            StbI.set_flip_vertically_on_load(1);
            first = false;
        }

        pixels = StbI.load(path, out width, out height, out channels, 0);
        if (pixels == null) 
            print("Unable to open %s\n", path);
    }

    public void Dispose()
    {
        if (pixels != null) 
            StbI.image_free(pixels);
    }
}
