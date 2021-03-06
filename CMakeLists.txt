cmake_minimum_required ( VERSION 3.1 )
###################################################################################
#
#   Build emtest
#
###################################################################################
project ( emtest VERSION 0.0.1 )

#
set ( VERSION 0.0.1 )
set ( RELEASE_NAME emtest )

#
# enable features
#
include ( CMakeToolsHelpers OPTIONAL )
list ( APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/vala)
find_package (PkgConfig)
find_package (Vala REQUIRED)

#
#   libraries - sources & packages
#
add_subdirectory ( .lib/glm )
add_subdirectory ( .lib/system )
add_subdirectory ( .lib/jasmine )
add_subdirectory ( .lib/zerog )
if (EXISTS ${CMAKE_SOURCE_DIR}/data AND NOT DEFINED ZEROG )
    add_subdirectory (data)
    list ( APPEND RESOURCES ${resources_gresource_xml_C_FILE} )
endif ()

#
#   generated code configuration
#
configure_file ( 
    ${CMAKE_SOURCE_DIR}/src/Config.vala.base 
    ${CMAKE_BINARY_DIR}/src/Config.vala 
)
file (RELATIVE_PATH CONFIG_VALA ${CMAKE_SOURCE_DIR} ${CMAKE_BINARY_DIR}/src/Config.vala)

#
#   application source
#
list ( APPEND VALA_SOURCES ${CONFIG_VALA} )
list ( APPEND VALA_SOURCES src/Shader.vala )
list ( APPEND VALA_SOURCES src/main.vala )
#
#   application includes
#
set ( INCLUDES "${INCLUDES};./include" )
set ( INCLUDES "${INCLUDES};C:\\msys64\\mingw64\\include\\freetype2" )
#
#   pkg-config dependencies
#

#
add_definitions ( ${DEPS_CFLAGS} )
link_libraries ( ${DEPS_LIBRARIES} )
link_directories ( ${DEPS_LIBRARY_DIRS} )

#
#   compiler options
#
list ( APPEND VALAC_OPTIONS --disable-warnings --enable-experimental )
list ( APPEND VALAC_OPTIONS --vapidir=${CMAKE_SOURCE_DIR})
# list ( APPEND VALAC_OPTIONS --define __EMSCRIPTEN__ )

# Vapis: 
set ( CUSTOM_VAPIS "${CUSTOM_VAPIS};src/vapis/freetype2.vapi" )
set ( CUSTOM_VAPIS "${CUSTOM_VAPIS};src/vapis/gl.vapi" )
set ( CUSTOM_VAPIS "${CUSTOM_VAPIS};src/vapis/emscripten.vapi" )
set ( CUSTOM_VAPIS "${CUSTOM_VAPIS};src/vapis/stb.vapi" )
set ( CUSTOM_VAPIS "${CUSTOM_VAPIS};src/vapis/glfw3.vapi" )
# Libs: 
set ( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -lglfw3" )
set ( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -lglew32" )
set ( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -lopengl32" )
set ( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -lfreetype" )

set ( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -w -std=c99 -O3" )

# definitions 
add_definitions( -DGLIB_COMPILATION ) 
add_definitions( -DG_DISABLE_CHECKS ) 
add_definitions( -DGOBJECT_COMPILATION ) 

include_directories(AFTER ${INCLUDES})
#
#   compile vala code
#
include (ValaVersion)
ensure_vala_version (0.26 MINIMUM)
include (ValaPrecompile)
vala_precompile (
    VALA_C ${PROJECT_NAME}
        ${VALA_SOURCES}
    PACKAGES
        ${PACKAGES}
    CUSTOM_VAPIS
        ${CUSTOM_VAPIS}
    OPTIONS
        ${VALAC_OPTIONS}
    )

#
#   compile ccode & link executable
#
add_executable ( ${PROJECT_NAME} ${VALA_C} ${C_SOURCES} ${RESOURCES} )

target_link_libraries ( ${PROJECT_NAME} glfw3 glew32 opengl32 freetype )
install (TARGETS ${PROJECT_NAME} RUNTIME DESTINATION . )

if (EXISTS ${CMAKE_SOURCE_DIR}/data AND DEFINED ZEROG)
    install ( DIRECTORY ${CMAKE_SOURCE_DIR}/data/assets DESTINATION . )
    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} 
            -E 
            copy_directory
            ${CMAKE_SOURCE_DIR}/data/assets 
            $<TARGET_FILE_DIR:${PROJECT_NAME}>/assets 
    )    
elseif (EXISTS ${CMAKE_SOURCE_DIR}/assets)
    install ( DIRECTORY ${CMAKE_SOURCE_DIR}/assets DESTINATION . )
    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} 
            -E 
            copy_directory
            ${CMAKE_SOURCE_DIR}/assets 
            $<TARGET_FILE_DIR:${PROJECT_NAME}>/assets 
    )    
endif ()

include (CPack)

# (generated from template: default. Do not modify. )
