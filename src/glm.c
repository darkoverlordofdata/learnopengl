/**
 * Extend cglm for Vala
 * 
 * 
 */
#include "glm.h"
/*
 * Were going to trick Vala into thinking that a vector is a
 * class.  So we simulate multple inheritance, by assuming a 2nd 
 * self pointer at an 8 byte thunk prior to the this pointer.
 * We now have a reference counted compact class!
 * 
 * Thunk--------------------------------
 *          ref_count
 *          size (0, 2, 3, 4, 3x3, 4x4)
 * Vector--------------------------------
 *  this --> data[0]
 *          data[1]
 *          data[2]
 *          data[...]
 * 
 */

/**
 * Thunked Ref
 */
void* glm_ref(void* this)
{
    Thunk* self = (Thunk*)((unsigned long)this-sizeof(Thunk));
    self->ref_count = self->ref_count+1;
    return this;
}

/**
 * Thunked Unref
 */
void glm_unref(void* this)
{
    Thunk* self = (Thunk*)((unsigned long)this-sizeof(Thunk));
    if (self->ref_count == 1)
        free(self);
    else
        self->ref_count = self->ref_count-1;
}

/**
 * Creates new Vector2
 * 
 */
Vec2* glm_vec2_new(float x, float y)
{
    ThunkVec2* this = malloc(sizeof(ThunkVec2));
    this->thunk.ref_count = 1;
    this->thunk.size = sizeof(vec2)/sizeof(float);
    this->data.x = x;
    this->data.y = y;
    return &this->data;
}

/**
 * Creates new Vector3
 * 
 */
Vec3* glm_vec3_new(float x, float y, float z)
{
    ThunkVec3* this = malloc(sizeof(ThunkVec3));
    this->thunk.ref_count = 1;
    this->thunk.size = sizeof(vec3)/sizeof(float);
    this->data.x = x;
    this->data.y = y;
    this->data.z = z;
    return &this->data;
}

/**
 * Creates new Vector4
 * 
 */
Vec4* glm_vec4_new(float w, float x, float y, float z)
{
    ThunkVec4* this = malloc(sizeof(ThunkVec4));
    this->thunk.ref_count = 1;
    this->thunk.size = sizeof(vec4)/sizeof(float);
    memset(&this->data, 0, sizeof(vec4));
    this->data.x = x;
    this->data.y = y;
    this->data.z = z;
    this->data.w = w;
    return &this->data;
}

/**
 * Creates new Quaternion
 * defults to Identity
 * 
 */
Quat* glm_quat_new()
{
    ThunkQuat* this = malloc(sizeof(ThunkQuat));
    this->thunk.ref_count = 1;
    this->thunk.size = sizeof(vec4)/sizeof(float);
    glm_quat_identity(&this->data);
    return &this->data;
}

/**
 * Creates new Matrix3
 * defults to Identity
 * 
 */
Mat3* glm_mat3_new(float value)
{
    ThunkMat3* this = malloc(sizeof(ThunkMat3));
    this->thunk.ref_count = 1;
    this->thunk.size = sizeof(mat3)/sizeof(float);
    if (value == 0.0f) {
        memset(&this->data, 0, sizeof(mat3));
    } else {
        glm_mat3_identity(&this->data);
        if (value != 1.0f)
            glm_mat3_scale(&this->data, value);
    }
    return &this->data;
}

/**
 * Creates new Matrix4
 * defults to Identity
 * 
 */
Mat4* glm_mat4_new(float value)
{
    ThunkMat4* this = malloc(sizeof(ThunkMat4));
    this->thunk.ref_count = 1;
    this->thunk.size = sizeof(mat4)/sizeof(float);
    if (value == 0.0f) {
        memset(&this->data, 0, sizeof(mat4));
    } else {
        glm_mat4_identity(&this->data);
        if (value != 1.0f)
            glm_mat4_scale(&this->data, value);
    }
    return &this->data;
}

