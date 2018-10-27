emcc ^
    -w ^
    -O2 ^
    -std=c99 ^
    -fdeclspec ^
    -o www/index.html ^
    -s WASM=1 ^
    -s EMULATE_FUNCTION_POINTER_CASTS=1 ^
    -s USE_WEBGL2=1 ^
    -s USE_GLFW=3 ^
    -s FULL_ES3=1 ^
    --embed-file assets/shaders/7.2.camera.fs ^
    --embed-file assets/shaders/7.2.camera.vs ^
    --preload-file assets/images/awesomeface.png ^
    --preload-file assets/images/container.jpg ^
    --use-preload-plugins ^
    -D__EMSCRIPTEN__ ^
    -DGLIB_COMPILATION ^
    -DG_DISABLE_CHECKS ^
    -DGOBJECT_COMPILATION ^
    -I./include ^
    -I./.lib/zerog/include ^
    -I./.lib/soil/include ^
    -I./.lib/glm/include ^
    -IC:/Users/darko/Documents/GitHub/glib ^
    -IC:/Users/darko/Documents/GitHub/glib/glib ^
    -IC:/Users/darko/Documents/GitHub/glib/gobject ^
    -IC:/msys64/mingw64/lib/libffi-3.2.1/include ^
    @files