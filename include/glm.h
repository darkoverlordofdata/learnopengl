#ifndef _GLM_H_
#define _GLM_H_

#include "cglm/cglm.h"
/*
 *   well I thunk thunk thunk thunk 
 *   a lot about it 
 *   realized my thunk is nuthin' 
 *   but a lot of funk - Jefferson Airplane
 */

typedef struct _Thunk Thunk;
typedef struct _Thunk 
{
    int ref_count;
    int size;
};

typedef struct _Vec2 Vec2;
typedef struct _Vec2
{
    union {
        vec2 data;
        struct {
            float x;
            float y;
        };
    };
};

typedef struct _Vec3 Vec3;
typedef struct _Vec3
{
    union {
        vec3 data;
        struct {
            float x;
            float y;
            float z;
        };
    };
};

typedef struct _Vec4 Vec4;
typedef struct _Vec4
{
    union {
        vec4 data;
        struct {
            float w;
            float x;
            float y;
            float z;
        };
    };
};

typedef struct _Quat Quat;
typedef struct _Quat 
{
    union {
        vec4 data;
        struct {
            float w;
            float x;
            float y;
            float z;
        };
    };
};

typedef struct _Mat3 Mat3;
typedef struct _Mat3 
{
    mat3 data;    
};

typedef struct _Mat4 Mat4;
typedef struct _Mat4
{
    mat4 data;    
};

/**
 * Thunked versions of all the objects
 */
typedef struct _ThunkVec2 ThunkVec2;
typedef struct _ThunkVec2
{
    Thunk thunk;
    Vec2 data;
};

typedef struct _ThunkVec3 ThunkVec3;
typedef struct _ThunkVec3 
{
    Thunk thunk;
    Vec3 data;
};

typedef struct _ThunkVec4 ThunkVec4;
typedef struct _ThunkVec4 
{
    Thunk thunk;
    Vec4 data;
};

typedef struct _ThunkQuat ThunkQuat;
typedef struct _ThunkQuat 
{
    Thunk thunk;
    Vec4 data;
};

typedef struct _ThunkMat3 ThunkMat3;
typedef struct _ThunkMat3 
{
    Thunk thunk;
    mat3 data;    
};

typedef struct _ThunkMat4 ThunkMat4;
typedef struct _ThunkMat4
{
    Thunk thunk;
    mat4 data;    
};

/**
 * New functions
 */
void* glm_ref(void* this);
void  glm_unref(void* this);
Vec2* glm_vec2_new(float x, float y);
Vec3* glm_vec3_new(float x, float y, float z);
Vec4* glm_vec4_new(float w, float x, float y, float z);
Quat* glm_quat_new();
Mat3* glm_mat3_new(float value);
Mat4* glm_mat4_new(float value);


#endif // _GLM_H_
