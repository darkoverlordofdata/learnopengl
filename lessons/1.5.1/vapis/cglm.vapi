/*
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
[CCode (cprefix = "glm_", lower_case_cprefix = "glm_", cheader_filename = "cglm/cglm.h")]
namespace glm
{
	public const int CGLM_VERSION_MAJOR;
	public const int CGLM_VERSION_MINOR;
	public const int CGLM_VERSION_PATCH;

	//  public static float[,] M(float[,] m) { return m; }

	//  public static float[] V(float x, float y, float z)
	//  {
	//  	return { x, y, z };
	//  }

	//  public static float[] Q(float w, float x, float y, float z)
	//  {
	//  	return { w, x, y, z };
	//  }

	[CCode (cname = "glm_cross")]
	public static void Cross(float* a, float* b, float* d);

	[CCode (cname = "glm_dot")]
	public static float Dot(float* a, float* b);

	[CCode (cname = "glm_normalize")]
	public static void Normalize(float* v);
	
	[CCode (cname = "glm_normalize_to")]
	public static void NormalizeTo(float* v, float* dest);
	
	[CCode (cname = "glm_sign")]
	public static int Sign(int val);
	
	[CCode (cname = "glm_signf")]
	public static float Signf(float val);
	
	[CCode (cname = "glm_rad")]
	public static float Rad(float deg);
	
	[CCode (cname = "glm_deg")]
	public static float Deg(float rad);
	
	[CCode (cname = "glm_make_rad")]
	public static void MakeRad(float* deg);
	
	[CCode (cname = "glm_make_deg")]
	public static void MakeDeg(float* rad);
	
	[CCode (cname = "glm_pow2")]
	public static float Pow2(float X);
	
	[CCode (cname = "glm_min")]
	public static float Min(float a, float b);
	
	[CCode (cname = "glm_max")]
	public static float Max(float a, float b);
	
	[CCode (cname = "glm_clamp")]
	public static float Clamp(float val, float minVal, float maxVal);
	
	[CCode (cname = "glm_clamp_zo")]
	public static float ClampZo(float val);
	
	[CCode (cname = "glm_lerp")]
	public static float Lerp(float from, float to, float t);

	[CCode (cname = "glm_eq")]
	public static bool Eq(float a, float b);
	
	[CCode (cname = "glm_percent")]
	public static float Percent(float from, float to, float current);
	
	[CCode (cname = "glm_percentc")]
	public static float Percentc(float from, float to, float current);

	[CCode (cname = "glm_quatv")]
	public static float Quatv(float* q, float angle, float* axis);

	[CCode (cname = "glm_unprojecti")]
	public static float UnProjectI(float* pos, float* invMat, float* vp, float* dest);

	[CCode (cname = "glm_unproject")]
	public static float UnProject(float* pos, float* m, float* vp, float* dest);

	[CCode (cname = "glm_project")]
	public static float Project(float* pos, float* m, float* vp, float* dest);

	[CCode (cname = "glm_translate")]
	public static void Translate(
		[CCode (array_length = false)] float[,] m, 
		[CCode (array_length = false)] float[] v);
	//  public static void Translate(float* m, float* v);

	[CCode (cname = "glm_translate_to")]
	public static void TranslateTo(float* m, float* v, float* dest);

	[CCode (cname = "glm_translate_x")]
	public static void TranslateX(float* m, float x);

	[CCode (cname = "glm_translate_y")]
	public static void TranslateY(float* m, float y);

	[CCode (cname = "glm_translate_z")]
	public static void TranslateZ(float* m, float z);

	[CCode (cname = "glm_translate_make")]
	public static void TranslateMake(float* m, float* v);

	[CCode (cname = "glm_scale_to")]
	public static void ScaleTo(float* m, float* v, float* dest);

	[CCode (cname = "glm_scale_make")]
	public static void ScaleMake(float* m, float* v);

	[CCode (cname = "glm_scale")]
	public static void Scale(float* m, float* v);

	[CCode (cname = "glm_scale_uni")]
	public static void ScaleUni(float* m, float s);

	[CCode (cname = "glm_rotate_x")]
	public static void RotateX(float* m, float angle, float* dest);

	[CCode (cname = "glm_rotate_y")]
	public static void RotateY(float* m, float angle, float* dest);

	[CCode (cname = "glm_rotate_z")]
	public static void RotateZ(float* m, float angle, float* dest);

	[CCode (cname = "glm_rotate_make")]
	public static void RotateMake(float* m, float angle, float* axis);

	[CCode (cname = "glm_rotate")]
	public static void Rotate(
		[CCode (array_length = false)] float[,] m, 
		float angle, 
		[CCode (array_length = false)] float[] axis
	);

	//[CCode (array_length = false)]
	[CCode (cname = "glm_rotate_at")]
	public static void RotateAt(float* m, float* pivot, float angle, float* axis);

	[CCode (cname = "glm_rotate_atm")]
	public static void RotateAtm(float* m, float* pivot, float angle, float* axis);

	[CCode (cname = "glm_decompose_scalev")]
	public static void DecomposeScalev(float* m, float* s);

	[CCode (cname = "glm_uniscaled")]
	public static bool Uniscaled(float* m, float* s);

	[CCode (cname = "glm_decompose_rs")]
	public static void DecomposeRs(float* m, float* r, float* s);

	[CCode (cname = "glm_decompose")]
	public static void Decompose(float* m, float* t, float* r, float* s);

	[Compact, CCode (cname = "mat3")]
	public class Mat3
	{
		public static float[,] Create()
		{
			return new float[3,3];
		}
		[CCode (cname = "glm_mat3_copy")]
		public static void Copy(float* mat, float* dest);

		[CCode (cname = "glm_mat3_identity")]
		public static void Identity([CCode (array_length = false)] float[,] mat);

		[CCode (cname = "glm_mat3_mul")]
		public static void Mul(float* m1, float* m2, float* dest);

		[CCode (cname = "glm_mat3_transpose_to")]
		public static void TransposeTo(float* m, float* dest);

		[CCode (cname = "glm_mat3_transpose")]
		public static void Transpose(float* m);

		[CCode (cname = "glm_mat3_mulv")]
		public static void Mulv(float* m, float* v, float* dest);

		[CCode (cname = "glm_mat3_quat")]
		public static void Quat(float* m, float* dest);

		[CCode (cname = "glm_mat3_scale")]
		public static void Scale(float* m, float s);

		[CCode (cname = "glm_mat3_det")]
		public static float Det(float* m);

		[CCode (cname = "glm_mat3_inv")]
		public static void Inv(float* mat, float* dest);

		[CCode (cname = "glm_mat3_swap_col")]
		public static void SwapCol(float* mat, int col1, int col2);

		[CCode (cname = "glm_mat3_swap_row")]
		public static void SwapRow(float* mat, int row1, int row2);
	}

	[Compact, CCode (cname = "mat4")]
	public class Mat4 
	{
		public static float[,] Create()
		{
			return new float[4,4];
		}

		[CCode (cname = "glm_mat4_copy")]
		public static void Copy(float* mat, float* dest);

		[CCode (cname = "glm_mat4_identity")]
		public static void Identity(float* mat);

		[CCode (cname = "glm_mat4_pick3")]
		public static void Pick3(float* mat, float* dest);

		[CCode (cname = "glm_mat4_pick3t")]
		public static void Pick4(float* mat, float* dest);

		[CCode (cname = "glm_mat4_ins3")]
		public static void Ins3(float* mat, float* dest);

		[CCode (cname = "glm_mat4_mul")]
		public static void Mul(float* m1, float* m2, float* dest);

		[CCode (cname = "glm_mat4_mulN")]
		public static void MulN(float** matrices, uint len, float* dest);

		[CCode (cname = "glm_mat4_mulv")]
		public static void Mulv(float* m, float* v, float* dest);

		[CCode (cname = "glm_mat4_quat")]
		public static void Quat(float* m, float* dest);

		[CCode (cname = "glm_mat4_mulv3")]
		public static void Mulv3(float* m, float* v, float last, float* dest);

		[CCode (cname = "glm_mat4_transpose_to")]
		public static void TransposeTo(float* m, float* dest);

		[CCode (cname = "glm_mat4_transpose")]
		public static void Transpose(float* m);

		[CCode (cname = "glm_mat4_scale_p")]
		public static void ScaleP(float* m, float s);

		[CCode (cname = "glm_mat4_scale")]
		public static void Scale(float* m, float s);

		[CCode (cname = "glm_mat4_det")]
		public static float Det(float* m);

		[CCode (cname = "glm_mat4_inv")]
		public static void Inv(float* mat, float* dest);

		[CCode (cname = "glm_mat4_inv_fast")]
		public static void InvFast(float* mat, float* dest);

		[CCode (cname = "glm_mat4_swap_col")]
		public static void SwapCol(float* mat, int col1, int col2);

		[CCode (cname = "glm_mat4_swap_row")]
		public static void SwapRow(float* mat, int row1, int row2);
	}

	[Compact, CCode (cname = "quat")]
	public class Quat 
	{
		public static float[] Create()
		{
			return new float[4];
		}

		[CCode (cname = "glm_quat")]
		public static void Make(float* q, float angle, float x, float y, float z);
	
		[CCode (cname = "glm_quat_identity")]
		public static void Identity(float* q);

		[CCode (cname = "glm_quat_identity_array")]
		public static void IdentityArray(float** q, size_t count);

		[CCode (cname = "glm_quat_init")]
		public static void Init(float* q, float x, float y, float z, float w);

		[CCode (cname = "glm_quat_copy")]
		public static void Copy(float* q, float* dest);

		[CCode (cname = "glm_quat_norm")]
		public static float Norm(float* q);

		[CCode (cname = "glm_quat_normalize_to")]
		public static void NormalizeTo(float* q, float* dest);

		[CCode (cname = "glm_quat_normalize")]
		public static void Normalize(float* q);

		[CCode (cname = "glm_quat_dot")]
		public static float Dot(float* p, float* q);

		[CCode (cname = "glm_quat_conjugate")]
		public static void Conjugate(float* q, float* dest);

		[CCode (cname = "glm_quat_inv")]
		public static void Inv(float* q, float* dest);

		[CCode (cname = "glm_quat_add")]
		public static void Add(float* p, float* q, float* dest);

		[CCode (cname = "glm_quat_sub")]
		public static void Sub(float* p, float* q, float* dest);

		[CCode (cname = "glm_quat_real")]
		public static float Real(float* q);

		[CCode (cname = "glm_quat_imag")]
		public static void Imag(float* q, float* dest);

		[CCode (cname = "glm_quat_imagn")]
		public static void Imagn(float* q, float* dest);

		[CCode (cname = "glm_quat_imaglen")]
		public static float ImagLen(float* q);

		[CCode (cname = "glm_quat_angle")]
		public static float Angle(float* q);

		[CCode (cname = "glm_quat_axis")]
		public static void Axis(float* q, float* dest);

		[CCode (cname = "glm_quat_mul")]
		public static void Mul(float* p, float* q, float* dest);

		[CCode (cname = "glm_quat_mat4")]
		public static void Mat4(float* q, float* dest);

		[CCode (cname = "glm_quat_mat4t")]
		public static void Mat4t(float* q, float* dest);

		[CCode (cname = "glm_quat_mat3")]
		public static void Mat3(float* q, float* dest);

		[CCode (cname = "glm_quat_mat3t")]
		public static void Mat3t(float* q, float* dest);

		[CCode (cname = "glm_quat_lerp")]
		public static void Lerp(float* from, float* to, float t, float* dest);

		[CCode (cname = "glm_quat_slerp")]
		public static void SLerp(float* from, float* to, float t, float* dest);

		[CCode (cname = "glm_quat_look")]
		public static void Look(float* eye, float* ori, float* dest);

		[CCode (cname = "glm_quat_for")]
		public static void For(float* dir, float* fwd, float* up, float* dest);

		[CCode (cname = "glm_quat_forp")]
		public static void Forp(float* from, float* to, float* fwd, float* up, float* dest);

		[CCode (cname = "glm_quat_rotatev")]
		public static void Rotatev(float* q, float* v, float* dest);

		[CCode (cname = "glm_quat_rotate")]
		public static void Rotate(float* m, float* q, float* dest);

		[CCode (cname = "glm_quat_rotate_at")]
		public static void RotateAt(float* m, float* q, float* pivot);

		[CCode (cname = "glm_quat_rotate_atm")]
		public static void RotateAtm(float* m, float* q, float* pivot);
	}
	

	[Compact, CCode (cname = "vec2")]
	public class Vec2 
	{
	}

	[Compact, CCode (cname = "vec3")]
	public class Vec3
	{
		public static float[] Create(float x = 0f, float y = 0f, float z = 0f)
		{
			return { x, y, z };
			//  return new float[3];
		}
		[CCode (cname = "glm_vec3")]
		public static void Make(float* v3, float last, float* dest);
	
		[CCode (cname = "glm_vec_copy")]
		public static void Copy(float* v3, float* dest);

		[CCode (cname = "glm_vec_zero")]
		public static void Zero(float* v);

		[CCode (cname = "glm_vec_one")]
		public static void One(float* v);

		[CCode (cname = "glm_vec_dot")]
		public static float Dot(float* a, float* b);
	
		[CCode (cname = "glm_vec_cross")]
		public static void Cross(float* a, float* b, float* d);

		[CCode (cname = "glm_vec_norm2")]
		public static float Norm2(float* v);

		[CCode (cname = "glm_vec_norm")]
		public static float Norm(float* v);

		[CCode (cname = "glm_vec_add")]
		public static float Add(float* a, float* b, float* dest);

		[CCode (cname = "glm_vec_adds")]
		public static float Adds(float* v, float s, float* dest);

		[CCode (cname = "glm_vec_sub")]
		public static float Sub(float* a, float* b, float* dest);

		[CCode (cname = "glm_vec_subs")]
		public static float Subs(float* v, float s, float* dest);

		[CCode (cname = "glm_vec_mul")]
		public static float Mul(float* a, float* b, float* dest);

		[CCode (cname = "glm_vec_scale")]
		public static float Scale(float* v, float s, float* dest);

		[CCode (cname = "glm_vec_scale_as")]
		public static float ScaleAs(float* v, float s, float* dest);

		[CCode (cname = "glm_vec_div")]
		public static float Div(float* a, float* b, float* dest);

		[CCode (cname = "glm_vec_divs")]
		public static float Divs(float* v, float s, float* dest);

		[CCode (cname = "glm_vec_addadd")]
		public static float AddAdd(float* a, float* b, float* dest);

		[CCode (cname = "glm_vec_subadd")]
		public static float SubAdd(float* a, float* b, float* dest);

		[CCode (cname = "glm_vec_muladd")]
		public static float MulAdd(float* a, float* b, float* dest);

		[CCode (cname = "glm_vec_muladds")]
		public static float MulAdds(float* a, float s, float* dest);

		[CCode (cname = "glm_vec_flipsign")]
		public static void FlipSign(float* v);

		[CCode (cname = "glm_vec_flipsign_to")]
		public static void FlipSignTo(float* v, float* dest);

		[CCode (cname = "glm_vec_inv")]
		public static void Inv(float* v);

		[CCode (cname = "glm_vec_normalize")]
		public static void Normalize(float* v);

		[CCode (cname = "glm_vec_normalize_to")]
		public static void NormalizeTo(float* v, float* dest);

		[CCode (cname = "glm_vec_angle")]
		public static float Angle(float* v1, float* v2);

		[CCode (cname = "glm_vec_rotate")]
		public static void Rotate(float* v, float angle, float* axis);

		[CCode (cname = "glm_vec_rotate_m4")]
		public static void RotateM4(float* m, float v, float* dest);
	
		[CCode (cname = "glm_vec_rotate_m3")]
		public static void RotateM3(float* m, float v, float* dest);
	
		[CCode (cname = "glm_vec_proj")]
		public static void Proj(float* a, float* b, float* dest);
	
		[CCode (cname = "glm_vec_center")]
		public static void Center(float* v1, float* v2, float* dest);
		
		[CCode (cname = "glm_vec_distance2")]
		public static float Diatance2(float* v1, float* v2);
	
		[CCode (cname = "glm_vec_distance")]
		public static float Diatance(float* v1, float* v2);
	
		[CCode (cname = "glm_vec_maxv")]
		public static void Maxv(float* v1, float* v2, float* dest);
	
		[CCode (cname = "glm_vec_minv")]
		public static void Minv(float* v1, float* v2, float* dest);

		[CCode (cname = "glm_vec_ortho")]
		public static void Ortho(float* v, float* dest);

		[CCode (cname = "glm_vec_clamp")]
		public static void Clamp(float* v, float minVal, float maxVal);

		[CCode (cname = "glm_vec_mulv")]
		public static void Mulv(float* a, float* b, float* d);

		[CCode (cname = "glm_vec_broadcast")]
		public static void Broadcast(float val, float* d);

		[CCode (cname = "glm_vec_eq")]
		public static bool Eq(float* v, float val);

		[CCode (cname = "glm_vec_eq_eps")]
		public static bool EqEps(float* v, float val);

		[CCode (cname = "glm_vec_eq_all")]
		public static bool EqAll(float* v);

		[CCode (cname = "glm_vec_eqv")]
		public static bool Eqv(float* v1, float* v2);

		[CCode (cname = "glm_vec_eqv_eps")]
		public static bool EqvEps(float* v1, float* v2);

		[CCode (cname = "glm_vec_max")]
		public static float Max(float* v);

		[CCode (cname = "glm_vec_min")]
		public static float Min(float* v);

		[CCode (cname = "glm_vec_isnan")]
		public static bool IsNan(float* v);

		[CCode (cname = "glm_vec_isinf")]
		public static bool IsInf(float* v);

		[CCode (cname = "glm_vec_isvalid")]
		public static bool IsValid(float* v);

		[CCode (cname = "glm_vec_sign")]
		public static void Sign(float* v, float* dest);

		[CCode (cname = "glm_vec_sqrt")]
		public static void Sqrt(float* v, float* dest);
	}

	[Compact, CCode (cname = "vec4")]
	public class Vec4 
	{
		public static float[] Create()
		{
			return new float[4];
		}
		[CCode (cname = "glm_vec4")]
		public static void Make(float* v4, float* dest);
		
		[CCode (cname = "glm_vec4_copy3")]
		public static void Copy3(float* a, float* dest);

		[CCode (cname = "glm_vec4_copy")]
		public static void Copy(float* a, float* dest);

		[CCode (cname = "glm_vec4_ucopy")]
		public static void UCopy(float* a, float* dest);

		[CCode (cname = "glm_vec4_zero")]
		public static void Zero(float* v);

		[CCode (cname = "glm_vec4_one")]
		public static void One(float* v);

		[CCode (cname = "glm_vec4_dot")]
		public static float Dot(float* a, float* b);

		[CCode (cname = "glm_vec4_norm2")]
		public static float Norm2(float* v);

		[CCode (cname = "glm_vec4_norm")]
		public static void Norm(float* v);

		[CCode (cname = "glm_vec4_add")]
		public static void Add(float* a, float* b, float* dest);

		[CCode (cname = "glm_vec4_adds")]
		public static void Adds(float* v, float s, float* dest);

		[CCode (cname = "glm_vec4_sub")]
		public static void Sub(float* a, float* b, float* dest);

		[CCode (cname = "glm_vec4_subs")]
		public static void Subs(float* v, float s, float* dest);

		[CCode (cname = "glm_vec4_mul")]
		public static void Mul(float* a, float* b, float* d);

		[CCode (cname = "glm_vec4_scale")]
		public static void Scale(float* v, float s, float* dest);

		[CCode (cname = "glm_vec4_scale_as")]
		public static void ScaleAs(float* v, float s, float* dest);

		[CCode (cname = "glm_vec4_div")]
		public static void Div(float* a, float* b, float* d);

		[CCode (cname = "glm_vec4_divs")]
		public static void Divs(float* v, float s, float* dest);

		[CCode (cname = "glm_vec4_addadd")]
		public static void AddAdd(float* a, float* b, float* dest);

		[CCode (cname = "glm_vec4_subadd")]
		public static void SubAdd(float* a, float* b, float* dest);

		[CCode (cname = "glm_vec4_muladd")]
		public static void MulAdd(float* a, float* b, float* dest);

		[CCode (cname = "glm_vec4_muladds")]
		public static void MulAdds(float* v, float s, float* dest);

		[CCode (cname = "glm_vec4_flipsign")]
		public static void FlipSign(float* v);

		[CCode (cname = "glm_vec4_flipsign_to")]
		public static void FlipSignTo(float* v, float* dest);

		[CCode (cname = "glm_vec4_inv")]
		public static void Inv(float* v);

		[CCode (cname = "glm_vec4_inv_to")]
		public static void InvTo(float* v, float* dest);

		[CCode (cname = "glm_vec4_normalize_to")]
		public static void NormalizeTo(float* vec, float* dest);

		[CCode (cname = "glm_vec4_normalize")]
		public static void Normalize(float* v);

		[CCode (cname = "glm_vec4_distance")]
		public static float Distance(float* v1, float* v2);

		[CCode (cname = "glm_vec4_maxv")]
		public static void Maxv(float* v1, float* v2, float* dest);

		[CCode (cname = "glm_vec4_minv")]
		public static void Minv(float* v1, float* v2, float* dest);

		[CCode (cname = "glm_vec4_clamp")]
		public static void Clamp(float* v, float minVal, float maxVal);

		[CCode (cname = "glm_vec4_lerp")]
		public static void Lerp(float* from, float* to, float t, float* dest);

		[CCode (cname = "glm_vec4_broadcast")]
		public static void Broadcast(float val, float* d);

		[CCode (cname = "glm_vec4_eq")]
		public static bool Eq(float* v, float val);

		[CCode (cname = "glm_vec4_eq_eps")]
		public static bool EqEps(float* v, float val);

		[CCode (cname = "glm_vec4_eq_all")]
		public static bool EqAll(float* v);

		[CCode (cname = "glm_vec4_eqv")]
		public static bool Eqv(float* v1, float* v2);

		[CCode (cname = "glm_vec4_eqv_eps")]
		public static bool EqvEps(float* v1, float* v2);

		[CCode (cname = "glm_vec4_max")]
		public static float Max(float* v);

		[CCode (cname = "glm_vec4_min")]
		public static float Min(float* v);

		[CCode (cname = "glm_vec4_isnan")]
		public static bool IsNan(float* v);

		[CCode (cname = "glm_vec4_isinf")]
		public static bool IsInf(float* v);

		[CCode (cname = "glm_vec4_isvalid")]
		public static bool IsValid(float* v);

		[CCode (cname = "glm_vec4_sign")]
		public static void Sign(float* v, float* dest);

		[CCode (cname = "glm_vec4_sqrt")]
		public static void Sqrt(float* v, float* dest);
	}

}