# emtest

a bunch of examples from https://learnopengl.com/ ported to vala.


Vala + OpenGL 3.00 es (Compatability Profile at https://glad.dav1d.de/)

## dependencies

uses [doran package manager](https://github.com/darkoverlordofdata/doran.git)

glfw3 for window and event handling.
emscripten - optional 
uses glad loader for desktop, gles handle loading in emscripten.
soil for image loading.
cglm headers for matrix math.

## emscripten

The build is not integrated into cmake, so...

When __EMSCRIPTEM__ is set, you will get this error from cmake:

    [build] C:/Users/darko/Documents/GitHub/learnopengl/build/src/Game.c:13:10: fatal error: 'emscripten/emscripten.h' file not found
    [build] #include "emscripten/emscripten.h"
    [build]          ^~~~~~~~~~~~~~~~~~~~~~~~~
    [build] 1 error generated.

At that point, use ctrl-B to tun the emcc build. F5 to launch in chrome.


## goal

re-boot vala game, instead of SDL2/OpenGL/Corange

use GLFW/OpenGL/glm/soil