/**
 * Extend cglm for Vala
 * 
 * ref counted Compact vector/matrix 
 * classes for use with the cglm api
 */
#include <stddef.h>
#include <string.h>
#include "cglm.h"

/**
 * Vec2 constructor
 * 
 */
Vec2* glm_vec2_new(float x, float y)
{
    Vec2* this = malloc(sizeof(Vec2));
    this->ref_count = 1;
    this->x = x;
    this->y = y;
    return this;
}

Vec2* glm_vec2_ref(Vec2* this) {
    this->ref_count++;
    return this;
}

void  glm_vec2_unref(Vec2* this) {
    if (this->ref_count == 1) free(this);
    else this->ref_count--;
}

/**
 * Vec3 constructor
 * 
 */
Vec3* glm_vec3_new(float x, float y, float z)
{
    Vec3* this = malloc(sizeof(Vec3));
    this->ref_count = 1;
    this->x = x;
    this->y = y;
    this->z = z;
    return this;
}

Vec3* glm_vec3_ref(Vec3* this) {
    this->ref_count++;
    return this;
}   

void  glm_vec3_unref(Vec3* this) {
    if (this->ref_count == 1) free(this);
    else this->ref_count--;
}


/**
 * Vec4 constructor
 * 
 */
Vec4* glm_vec4_new(float w, float x, float y, float z)
{
    Vec4* this = malloc(sizeof(Vec4));
    this->ref_count = 1;
    this->x = x;
    this->y = y;
    this->z = z;
    this->w = w;
    return this;
}

Vec4* glm_vec4_ref(Vec4* this) {
    this->ref_count++;
    return this;
}   

void  glm_vec4_unref(Vec4* this) {
    if (this->ref_count == 1) free(this);
    else this->ref_count--;
}

/**
 * Quat constructor
 * 
 */
Quat* glm_quat_new()
{
    Quat* this = malloc(sizeof(Quat));
    this->ref_count = 1;
    glm_quat_identity(this);
    return this;
}

Quat* glm_quat_ctor(float x, float y, float z, float w)
{
    Quat* this = malloc(sizeof(Quat));
    this->ref_count = 1;
    glm_quat_init(this, x, y, z, w);
    return this;
}

Quat* glm_quat_ref(Quat* this) {
    this->ref_count++;
    return this;
}   

void  glm_quat_unref(Quat* this) {
    if (this->ref_count == 1) free(this);
    else this->ref_count--;
}


/**
 * Mat3 constructor
 * 
 */
Mat3* glm_mat3_new(float value)
{
    Mat3* this = malloc(sizeof(Mat3));
    this->ref_count = 1;
    if (value == 0.0f) {
        memset(this, 0, sizeof(Mat3));
    } else {
        glm_mat3_identity(this);
        if (value != 1.0f)
            glm_mat3_scale(this, value);
    }
    return this;
}

Mat3* glm_mat3_ref(Mat3* this) {
    this->ref_count++;
    return this;
}   

void glm_mat3_unref(Mat3* this) {
    if (this->ref_count == 1) free(this);
    else this->ref_count--;
}

/**
 * Mat4 constructor
 * 
 */
Mat4* glm_mat4_new(float value)
{
    Mat4* this = malloc(sizeof(Mat4));
    this->ref_count = 1;

    if (value == 0.0f) {
        memset(this, 0, sizeof(Mat4));
    } else {
        glm_mat4_identity(this);
        if (value != 1.0f)
            glm_mat4_scale(this, value);
    }
    return this;
}

Mat4* glm_mat4_ref(Mat4* this) {
    this->ref_count++;
    return this;
}   

void  glm_mat4_unref(Mat4* this) {
    if (this->ref_count == 1) free(this);
    else this->ref_count--;
}
