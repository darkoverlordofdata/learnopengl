/**
 * Extend cglm for Vala
 * 
 * 
 */
#include "glm.h"

/**
 * Creates new Vec2
 * 
 */
void glm_vec2_ctor(Vec2* this, float x, float y)
{
    this->x = x;
    this->y = y;
}

// Vec2* glm_vec2_dup (const Vec2* this)
// {
// 	Vec2* dup;
// 	dup = malloc(sizeof(Vec2));
// 	memcpy (dup, this, sizeof (Vec2));
// 	return dup;
// }


/*
 * Creates new Vec3
 * 
 */
void glm_vec3_ctor(Vec3* this, float x, float y, float z)
{
    this->x = x;
    this->y = y;
    this->z = z;
}

// Vec3* glm_vec3_dup (const Vec3* this)
// {
// 	Vec3* dup;
// 	dup = malloc(sizeof(Vec3));
// 	memcpy (dup, this, sizeof (Vec3));
// 	return dup;
// }


/**
 * Creates new Vec4
 * 
 */
void glm_vec4_ctor(Vec4* this, float w, float x, float y, float z)
{
    this->x = x;
    this->y = y;
    this->z = z;
    this->w = w;
}

// Vec4* glm_vec4_dup (const Vec4* this)
// {
// 	Vec4* dup;
// 	dup = malloc(sizeof(Vec4));
// 	memcpy (dup, this, sizeof (Vec4));
// 	return dup;
// }


/**
 * Creates new Quation
 * defults to Identity
 * 
 */
void glm_quat_ctor(Quat* this)
{
    glm_quat_identity(this);
}

// Quat* glm_quat_dup (const Quat* this)
// {
// 	Quat* dup;
// 	dup = malloc(sizeof(Quat));
// 	memcpy (dup, this, sizeof (Quat));
// 	return dup;
// }



/**
 * Creates new Mat3
 * defults to Identity
 * 
 */
void glm_mat3_ctor(Mat3* this, float value)
{
    if (value == 0.0f) {
        memset(this, 0, sizeof(mat3));
    } else {
        glm_mat3_identity(this);
        if (value != 1.0f)
            glm_mat3_scale(this, value);
    }
}

// Mat3* glm_mat3_dup (const Mat3* this)
// {
// 	Mat3* dup;
// 	dup = malloc(sizeof(Mat3));
// 	memcpy (dup, this, sizeof (Mat3));
// 	return dup;
// }

/**
 * Creates new Mat4
 * defults to Identity
 * 
 */
void glm_mat4_ctor(Mat4* this, float value)
{
    if (value == 0.0f) {
        memset(this, 0, sizeof(mat4));
    } else {
        glm_mat4_identity(this);
        if (value != 1.0f)
            glm_mat4_scale(this, value);
    }
}

// Mat4* glm_mat4_dup (const Mat4* this)
// {
// 	Mat4* dup;
// 	dup = malloc(sizeof(Mat4));
// 	memcpy (dup, this, sizeof (Mat4));
// 	return dup;
// }

