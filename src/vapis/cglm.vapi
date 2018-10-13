/*
 * Copyright (c) 2018 Bruce Davidspn <darkoverlordofdata@gmail.com>

The MIT License (MIT)


Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
[Version (since = "0.4.9")] // cglm v0.4.9
[CCode (cprefix = "", lower_case_cprefix = "", cheader_filename = "glm.h")]
namespace glm
{
	public const int CGLM_VERSION_MAJOR;
	public const int CGLM_VERSION_MINOR;
	public const int CGLM_VERSION_PATCH;

	/**
	 * Vec2
	 */
	[Compact]
	[CCode (cname = "Vec2", ref_function = "glm_ref", unref_function = "glm_unref")]
	public class Vec2 
	{ 
		public float data[2];
		public float x;
		public float y;

		[CCode (cname = "glm_vec2_new")]
		public Vec2(float x = 0f, float y = 0f);
		[CCode (cname = "glm_vec2_print")]
		public void Print(GLib.FileStream ostream = GLib.stdout);
	}
	
	/**
	 * Vec3
	 */
	[Compact]
	[CCode (cname = "Vec3", ref_function = "glm_ref", unref_function = "glm_unref")]
	public class Vec3 
	{ 
		public float data[3];
		public float x;
		public float y;
		public float z;

		[CCode (cname = "glm_vec3_new")]
		public Vec3(float x = 0f, float y = 0f, float z = 0f);
		[CCode (cname = "glm_vec3_print")]
		public void Print(GLib.FileStream ostream = GLib.stdout);
	}

	/**
	 * Vec4
	 */
	[Compact]
	[CCode (cname = "Vec4", ref_function = "glm_ref", unref_function = "glm_unref")]
	public class Vec4 
	{ 
		public float data[4];
		public float w;
		public float x;
		public float y;
		public float z;

		[CCode (cname = "glm_vec4_new")]
		public Vec4(float w = 0f, float x = 0f, float y = 0f, float z = 0f);
		[CCode (cname = "glm_vec4_print")]
		public void Print(GLib.FileStream ostream = GLib.stdout);
	}

	/**
	 * Quat
	 */
	[Compact]
	[CCode (cname = "Quat", ref_function = "glm_ref", unref_function = "glm_unref")]
	public class Quat 
	{ 
		public float data[4];
		public float w;
		public float x;
		public float y;
		public float z;

		[CCode (cname = "glm_quat_new")]
		public Quat();
		[CCode (cname = "glm_quat_print")]
		public void Print(GLib.FileStream ostream = GLib.stdout);
	}

	/**
	 * Mat3
	 */
	[Compact]
	[CCode (cname = "Mat3", ref_function = "glm_ref", unref_function = "glm_unref")]
	public class Mat3 
	{ 
		public float[] data[3];

		[CCode (cname = "glm_mat3_new")]
		public Mat3(float value = 1f);
		[CCode (cname = "glm_mat3_print")]
		public void Print(GLib.FileStream ostream = GLib.stdout);

	}

	/**
	 * Mat4
	 */
	[Compact]
	[CCode (cname = "Mat4", ref_function = "glm_ref", unref_function = "glm_unref")]
	public class Mat4 
	{ 
		public float[] data[4];

		[CCode (cname = "glm_mat4_new")]
		public Mat4(float value = 1f);
		[CCode (cname = "glm_mat4_print")]
		public void Print(GLib.FileStream ostream = GLib.stdout);
	}

	//  [SimpleType]
	//  [CCode (cname = "vec2", has_type_id  = false)]
	//  public struct vec2 { float data[2]; }

	//  [SimpleType]
	//  [CCode (cname = "vec3", has_type_id  = false)]
	//  public struct vec3 { float data[3]; }

	//  [SimpleType]
	//  [CCode (cname = "vec4", has_type_id  = false)]
	//  public struct vec4 { float data[4]; }

	//  [SimpleType]
	//  [CCode (cname = "quat", has_type_id  = false)]
	//  public struct quat { float data[4]; }

	public void  glm_cross(float* a, float* b, float* d);
	public float glm_dot(float* a, float* b);
	public void  glm_normalize(float* v);
	public void  glm_normalize_to(float* v, float* dest);
	public int 	 glm_sign(int val);
	public float glm_signf(float val);
	public float glm_rad(float deg);
	public float glm_deg(float rad);
	public void  glm_make_rad(float* deg);
	public void  glm_make_deg(float* rad);
	public float glm_pow2(float X);
	public float glm_min(float a, float b);
	public float glm_max(float a, float b);
	public float glm_clamp(float val, float minVal, float maxVal);
	public float glm_clamp_to(float val);
	public float glm_lerp(float from, float to, float t);
	public bool  glm_eq(float a, float b);
	public float glm_percent(float from, float to, float current);
	public float glm_percentc(float from, float to, float current);
	public float glm_quatv(float* q, float angle, float* axis);
	public float glm_unprojecti(float* pos, float* invMat, float* vp, float* dest);
	public float glm_unproject(float* pos, float* m, float* vp, float* dest);
	public float glm_project(float* pos, float* m, float* vp, float* dest);
	public void  glm_translate(Mat4 m, float* v);
	public void  glm_translate_to(float* m, float* v, float* dest);
	public void  glm_translate_x(float* m, float x);
	public void  glm_translate_y(float* m, float y);
	public void  glm_translate_z(float* m, float z);
	public void  glm_translate_make(float* m, float* v);
	public void  glm_scale_to(float* m, float* v, float* dest);
	public void  glm_scale_make(float* m, float* v);
	public void  glm_scale(float* m, float* v);
	public void  glm_scale_uni(float* m, float s);
	public void  glm_rotate_x(float* m, float angle, float* dest);
	public void  glm_rotate_y(float* m, float angle, float* dest);
	public void  glm_rotate_z(float* m, float angle, float* dest);
	public void  glm_rotate_make(float* m, float angle, float* axis);
	public void  glm_rotate(float* m, float angle, float* axis);
	public void  glm_rotate_at(float* m, float* pivot, float angle, float* axis);
	public void  glm_rotate_atm(float* m, float* pivot, float angle, float* axis);
	public void  glm_decompose_scalev(float* m, float* s);
	public bool  glm_uniscaled(float* m, float* s);
	public void  glm_decompose_rs(float* m, float* r, float* s);	
	public void  glm_decompose(float* m, float* t, float* r, float* s);
	public void  glm_perspective(float fovy, float aspect, float nearVal, float farVal, float* dest);
	public void  glm_lookat(float* eye, float* center, float* up, float* dest);

	public void  glm_mat3_copy(float* mat, float* dest);
	public void  glm_mat3_print(float* matrix, GLib.FileStream ostream);
	public void  glm_mat3_identity(float* mat);
	public void  glm_mat3_mul(float* m1, float* m2, float* dest);
	public void  glm_mat3_transpose_to(float* m, float* dest);
	public void  glm_mat3_transpose(float* m);
	public void  glm_mat3_mulv(float* m, float* v, float* dest);
	public void  glm_mat3_quat(float* m, float* dest);
	public void  glm_mat3_scale(float* m, float s);
	public float glm_mat3_det(float* m);
	public void  glm_mat3_inv(float* mat, float* dest);
	public void  glm_mat3_swap_col(float* mat, int col1, int col2);
	public void  glm_mat3_swap_row(float* mat, int row1, int row2);

	public void  glm_mat4_copy(float* mat, float* dest);
	public void  glm_mat4_print(float* matrix, GLib.FileStream ostream);
	public void  glm_mat4_identity(float* mat);
	public void  glm_mat4_pick3(float* mat, float* dest);
	public void  glm_mat4_pick3t(float* mat, float* dest);
	public void  glm_mat4_ins3(float* mat, float* dest);
	public void  glm_mat4_mul(float* m1, float* m2, float* dest);
	public void  glm_mat4_mulN(float* matrices, uint len, float* dest);
	public void  glm_mat4_mulv(float* m, float* v, float* dest);
	public void  glm_mat4_quat(float* m, float* dest);
	public void  glm_mat4_mulv3(float* m, float* v, float last, float* dest);
	public void  glm_mat4_transpose_to(float* m, float* dest);
	public void  glm_mat4_transpose(float* m);
	public void  glm_mat4_scale_p(float* m, float s);
	public void  glm_mat4_scale(float* m, float s);
	public float glm_mat4_det(float* m);
	public void  glm_mat4_inv(float* mat, float* dest);
	public void  glm_mat4_inv_fast(float* mat, float* dest);
	public void  glm_mat4_swap_col(float* mat, int col1, int col2);
	public void  glm_mat4_swap_row(float* mat, int row1, int row2);


	public void  glm_versor_print(float* versor, GLib.FileStream ostream);
	public void  glm_quat(float* q, float angle, float x, float y, float z);
	public void  glm_quat_identity(float* q);
	public void  glm_quat_identity_array(float* q, size_t count);
	public void  glm_quat_init(float* q, float x, float y, float z, float w);
	public void  glm_quat_copy(float* q, float* dest);
	public float glm_quat_norm(float* q);
	public void  glm_quat_normalize_to(float* q, float* dest);
	public void  glm_quat_normalize(float* q);
	public float glm_quat_dot(float* p, float* q);
	public void  glm_quat_conjugate(float* q, float* dest);
	public void  glm_quat_inv(float* q, float* dest);
	public void  glm_quat_add(float* p, float* q, float* dest);
	public void  glm_quat_sub(float* p, float* q, float* dest);
	public float glm_quat_real(float* q);
	public void  glm_quat_imag(float* q, float* dest);
	public void  glm_quat_imagn(float* q, float* dest);
	public float Imagglm_quat_imaglenLen(float* q);
	public float glm_quat_angle(float* q);
	public void  glm_quat_axis(float* q, float* dest);
	public void  glm_quat_mul(float* p, float* q, float* dest);
	public void  glm_quat_mat4(float* q, float* dest);
	public void  glm_quat_mat4t(float* q, float* dest);
	public void  glm_quat_mat3(float* q, float* dest);
	public void  glm_quat_mat3t(float* q, float* dest);
	public void  glm_quat_lerp(float* from, float* to, float t, float* dest);
	public void  glm_quat_slerp(float* from, float* to, float t, float* dest);
	public void  glm_quat_look(float* eye, float* ori, float* dest);
	public void  glm_quat_for(float* dir, float* fwd, float* up, float* dest);
	public void  glm_quat_forp(float* from, float* to, float* fwd, float* up, float* dest);
	public void  glm_quat_rotatev(float* q, float* v, float* dest);
	public void  glm_quat_rotate(float* m, float* q, float* dest);
	public void  glm_quat_rotate_at(float* m, float* q, float* pivot);
	public void  glm_quat_rotate_atm(float* m, float* q, float* pivot);


	public void  glm_vec3(float* v4, float* dest);
	public void  glm_vec3_print(float* vec, GLib.FileStream ostream);

	
	public void  glm_vec_copy(float* v3, float* dest);
	public void  glm_vec_zero(float* v);
	public void  glm_vec_one(float* v);
	public float glm_vec_dot(float* a, float* b);
	public void  glm_vec_cross(float* a, float* b, float* d);
	public float glm_vec_norm2(float* v);
	public float glm_vec_norm(float* v);
	public void  glm_vec_add(float* a, float* b, float* dest);
	public void  glm_vec_adds(float* v, float s, float* dest);
	public void  glm_vec_sub(float* a, float* b, float* dest);
	public void  glm_vec_subs(float* v, float s, float* dest);
	public void  glm_vec_mul(float* a, float* b, float* dest);
	public void  glm_vec_scale(float* v, float s, float* dest);
	public void  glm_vec_scale_as(float* v, float s, float* dest);
	public void  glm_vec_div(float* a, float* b, float* dest);
	public void  glm_vec_divs(float* v, float s, float* dest);
	public void  glm_vec_addadd(float* a, float* b, float* dest);
	public void  glm_vec_subadd(float* a, float* b, float* dest);
	public void  glm_vec_muladd(float* a, float* b, float* dest);
	public void  glm_vec_muladds(float* a, float s, float* dest);
	public void  glm_vec_flipsign(float* v);
	public void  glm_vec_flipsign_to(float* v, float* dest);
	public void  glm_vec_inv(float* v);
	public void  glm_vec_normalize(float* v);
	public void  glm_vec_normalize_to(float* v, float* dest);
	public float glm_vec_angle(float* v1, float* v2);
	public void  glm_vec_rotate(float* v, float angle, float* axis);
	public void  glm_vec_rotate_m4(float* m, float v, float* dest);
	public void  glm_vec_rotate_m3(float* m, float v, float* dest);
	public void  glm_vec_proj(float* a, float* b, float* dest);
	public void  glm_vec_center(float* v1, float* v2, float* dest);
	public float glm_vec_distance2(float* v1, float* v2);
	public float glm_vec_distance(float* v1, float* v2);
	public void  glm_vec_maxv(float* v1, float* v2, float* dest);
	public void  glm_vec_minv(float* v1, float* v2, float* dest);
	public void  glm_vec_ortho(float* v, float* dest);
	public void  glm_vec_clamp(float* v, float minVal, float maxVal);
	public void  glm_vec_mulv(float* a, float* b, float* d);
	public void  glm_vec_broadcast(float val, float* d);
	public bool  glm_vec_eq(float* v, float val);
	public bool  glm_vec_eq_eps(float* v, float val);
	public bool  glm_vec_eq_all(float* v);
	public bool  glm_vec_eqv(float* v1, float* v2);
	public bool  glm_vec_eqv_eps(float* v1, float* v2);
	public float glm_vec_max(float* v);
	public float glm_vec_min(float* v);
	public bool  glm_vec_isnan(float* v);
	public bool  glm_vec_isinf(float* v);
	public bool  glm_vec_isvalid(float* v);
	public void  glm_vec_sign(float* v, float* dest);
	public void  glm_vec_sqrt(float* v, float* dest);

	public void  glm_vec4(float* v4, float* dest);
	public void  glm_vec4_print(float* vec, GLib.FileStream ostream);
	public void  glm_vec4_copy3(float* a, float* dest);
	public void  glm_vec4_copy(float* a, float* dest);
	public void  glm_vec4_ucopy(float* a, float* dest);
	public void  glm_vec4_zero(float* v);
	public void  glm_vec4_one(float* v);
	public float glm_vec4_dot(float* a, float* b);
	public float glm_vec4_norm2(float* v);
	public void  glm_vec4_norm(float* v);
	public void  glm_vec4_add(float* a, float* b, float* dest);
	public void  glm_vec4_adds(float* v, float s, float* dest);
	public void  glm_vec4_sub(float* a, float* b, float* dest);
	public void  glm_vec4_subs(float* v, float s, float* dest);
	public void  glm_vec4_mul(float* a, float* b, float* dest);
	public void  glm_vec4_scale(float* v, float s, float* dest);
	public void  glm_vec4_scale_as(float* v, float s, float* dest);
	public void  glm_vec4_div(float* a, float* b, float* dest);
	public void  glm_vec4_divs(float* v, float s, float* dest);
	public void  glm_vec4_addadd(float* a, float* b, float* dest);
	public void  glm_vec4_subadd(float* a, float* b, float* dest);
	public void  glm_vec4_muladd(float* a, float* b, float* dest);
	public void  glm_vec4_muladds(float* v, float s, float* dest);
	public void  glm_vec4_flipsign(float* v);
	public void  glm_vec4_flipsign_to(float* v, float* dest);
	public void  glm_vec4_inv(float* v);
	public void  glm_vec4_inv_to(float* v, float* dest);
	public void  glm_vec4_normalize_to(float* vec, float* dest);
	public void  glm_vec4_normalize(float* v);
	public float glm_vec4_distance(float* v1, float* v2);
	public void  glm_vec4_maxv(float* v1, float* v2, float* dest);
	public void  glm_vec4_minv(float* v1, float* v2, float* dest);
	public void  glm_vec4_clamp(float* v, float minVal, float maxVal);
	public void  glm_vec4_lerp(float* from, float* to, float t, float* dest);
	public void  glm_vec4_broadcast(float val, float* d);
	public bool  glm_vec4_eq(float* v, float val);
	public bool  glm_vec4_eq_eps(float* v, float val);
	public bool  glm_vec4_eq_all(float* v);
	public bool  glm_vec4_eqv(float* v1, float* v2);
	public bool  glm_vec4_eqv_eps(float* v1, float* v2);
	public float glm_vec4_max(float* v);
	public float glm_vec4_min(float* v);
	public bool  glm_vec4_isnan(float* v);
	public bool  glm_vec4_isinf(float* v);
	public bool  glm_vec4_isvalid(float* v);
	public void  glm_vec4_sign(float* v, float* dest);
	public void  glm_vec4_sqrt(float* v, float* dest);

	//------------------------------------------------------------------
	[CCode (cname = "glm_translate")]
	public void  glm_translatef(Mat4 m, 
		[CCode (array_length = false)]float[] v);

	[CCode (cname = "glm_rotate")]
	public void  glm_rotatef(float* m, float angle, 
		[CCode (array_length = false)]float[] axis);

	[CCode (cname = "glm_vec_copy")]
	public void  glm_vec_copyf([CCode (array_length = false)]float[] v3, float* dest);

}