# glfw vs sdl

very similar, glfw is a bit simpler and doesn't force oop on you.
to get sdl extras like image loading and fonts requires extra libraries.
For sdl, this is sdl_image, etc. or with glfw, i can use stb.

glfw - simpler, fewer dependencies


# sfml

No emscripten support. sfml wraps open gl, this makes it easy to use but also takes away choice of version support. I need to use ES3.0 compatability to target opengl on browser and desktop with the same codebase.

# resources

*.png requires both GL_RGBA flags set for emscripten. desktop works when 1st is just GL_RGB:

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA,...

# timestep

//https://gafferongames.com/post/fix_your_timestep/
//http://www.fabiensanglard.net/timer_and_framerate/index.php

// The amount of time we want to simulate each step, in milliseconds
// (written as implicit frame-rate)
timeDelta = 1000/30
timeAccumulator = 0
while ( game should run )
{
  timeSimulatedThisIteration = 0
  startTime = currentTime()

  while ( timeAccumulator >= timeDelta )
  {
    stepGameState( timeDelta )
    timeAccumulator -= timeDelta
    timeSimulatedThisIteration += timeDelta
  }

  stepAnimation( timeSimulatedThisIteration )

  renderFrame() // OpenGL frame drawing code goes here

  handleUserInput()

  timeAccumulator += currentTime() - startTime 
}
===========================================================================
===========================================================================
===========================================================================
===========================================================================

glm by-val or struct based
cglm - by-ref or class based


There are no classes anyway in c, so ultimately, this is not struct vs class. This is about by-ref vs by-val semantics.

When using explicit by val structs, I have to use a ref or address-of operator for almost every call. The main differene is that with classes, the address-of is implicit. The real difference is assigning a copy. By value makes a deep copy. by ref only copies the ref. 

Missing one might trigger an obscure bug somewhere else, or it might be a performance issue, or it may crash the program. I don't see the benefit.
Construction might be faster by an unmeasurable amount...