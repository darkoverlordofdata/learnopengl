#ifndef _GLM_H_
#define _GLM_H_

#include "cglm/cglm.h"


typedef struct _Vector Vector;
typedef struct _Vector 
{
    int ref_count;
    int size;
    float data; // placeholder for the actual vector
};


typedef struct _Vector2 Vector2;
typedef struct _Vector2
{
    int ref_count;
    int size;
    vec2 data;    
};

typedef struct _Vector3 Vector3;
typedef struct _Vector3 
{
    int ref_count;
    int size;
    vec3 data;    
};

typedef struct _Vector4 Vector4;
typedef struct _Vector4 
{
    int ref_count;
    int size;
    vec4 data;    
};

typedef struct _Quaternion Quaternion;
typedef struct _Quaternion 
{
    int ref_count;
    int size;
    vec4 data;    
};

typedef struct _Matrix3 Matrix3;
typedef struct _Matrix3 
{
    int ref_count;
    int size;
    mat3 data;    
};

typedef struct _Matrix4 Matrix4;
typedef struct _Matrix4
{
    int ref_count;
    int size;
    mat4 data;    
};

void*       glm_ref(void* this);
void        glm_unref(void* this);
Vector2*    glm_vector2_new(float x, float y);
Vector3*    glm_vector3_new(float x, float y, float z);
Vector4*    glm_vector4_new(float w, float x, float y, float z);
Quaternion* glm_quaternion_new();
Matrix3*    glm_matrix3_new(float value);
Matrix4*    glm_matrix4_new(float value);


#endif // _GLM_H_
