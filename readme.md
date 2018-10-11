# emtest

a bunch of examples from https://learnopengl.com/ ported to vala.


Vala + OpenGL 3.00 es (Compatability Profile at https://glad.dav1d.de/)

## dependencies

glfw3 for window and eventing.
emscripten - optional (requires zerog)
uses glad loader for desktop, gles handle loading in emscripten.
stbi for image loading.
cglm headers for matrix math.

## emscripten

The build is not integrated into cmake, so...

When __EMSCRIPTEM__ is set, you will get this error from cmake:

    [build] C:/Users/darko/Documents/GitHub/emtest/build/src/Game.c:13:10: fatal error: 'emscripten/emscripten.h' file not found
    [build] #include "emscripten/emscripten.h"
    [build]          ^~~~~~~~~~~~~~~~~~~~~~~~~
    [build] 1 error generated.

At that point, use ctrl-B to tun the emcc build. F5 to launch chrome.