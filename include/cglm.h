#ifndef _GLM_H_
#define _GLM_H_
/**
 * Vector/Matrix types for use with Vala
 */
#include "cglm/cglm.h"

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
    int ref_count;
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
    int ref_count;
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
    int ref_count;
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
    int ref_count;
};

typedef struct _Mat3 Mat3;
typedef struct _Mat3 
{
    mat3 data;    
    int ref_count;
};

typedef struct _Mat4 Mat4;
typedef struct _Mat4
{
    mat4 data;    
    int ref_count;
};



/**
 * Api extension
 */
Vec2* glm_vec2_new(float x, float y);
Vec2* glm_vec2_ref(Vec2* this);
void  glm_vec2_unref(Vec2* this);

Vec3* glm_vec3_new(float x, float y, float z);
Vec3* glm_vec3_ref(Vec3* this);
void  glm_vec3_unref(Vec3* this);

Vec4* glm_vec4_new(float w, float x, float y, float z);
Vec4* glm_vec4_ref(Vec4* this);
void  glm_vec4_unref(Vec4* this);

Quat* glm_quat_new();
Quat* glm_quat_ref(Quat* this);
void  glm_quat_unref(Quat* this);

Mat3* glm_mat3_new(float value);
Mat3* glm_mat3_ref(Mat3* this);
void  glm_mat3_unref(Mat3* this);

Mat4* glm_mat4_new(float value);
Mat4* glm_mat4_ref(Mat4* this);
void  glm_mat4_unref(Mat4* this);

#endif // _GLM_H_
