/*
The MIT License (MIT)

Copyright (c) <2018> <xna.framework vapi>

Corange definitions used for xna port.

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
[Version (since = "0.8.0")] // Corange v0.8.0
[CCode (cprefix = "", lower_case_cprefix = "", cheader_filename = "glm.h")]
namespace glm
{
    /**
     * Not the real glm, but a reasonable fascimile made using c
     */
	
	[SimpleType, CCode (cname = "vec2")]
	public struct vec2 
	{
		[CCode (cname = "x")]
		public float X;
		[CCode (cname = "y")]
		public float Y;

		[CCode (cname = "vec2_new")]
		public vec2 (float x, float y);
		[CCode (cname = "vec2_zero")]
		private static vec2 zero();
		public static vec2 Zero { owned get { return zero();}}
		[CCode (cname = "vec2_one")]
		private static vec2 one();
		// needs ownership or it will reset to zero due to disposal
		public static vec2 One { owned get { return one();}}
		
		[CCode (cname = "vec2_add")]
		public vec2 Add(vec2 other);
		[CCode (cname = "vec2_sub")]
		public vec2 Sub(vec2 other);
		[CCode (cname = "vec2_mul")]
		public vec2 Multiply(float fac);
		[CCode (cname = "vec2_mul_vec2")]
		public vec2 Mul(vec2 other);
		[CCode (cname = "vec2_div")]
		public vec2 Divide(float fac);
		[CCode (cname = "vec2_div_vec2")]
		public vec2 Div(vec2 other);
		[CCode (cname = "vec2_pow")]
		public vec2 Pow(float exp);
		[CCode (cname = "vec2_neg")]
		public vec2 Neg();
		[CCode (cname = "vec2_abs")]
		public vec2 Abs();
		[CCode (cname = "vec2_floor")]
		public vec2 Floor();
		[CCode (cname = "vec2_fmod")]
		public vec2 FMod(float val);
		
		[CCode (cname = "vec2_max")]
		public vec2 Max(float x);
		[CCode (cname = "vec2_min")]
		public vec2 Min(float x);
		[CCode (cname = "vec2_clamp")]
		public vec2 Clamp(float b, float t);
		
		[CCode (cname = "vec2_equ")]
		public bool Equals(vec2 other);
		
		[CCode (cname = "vec2_dot")]
		public float Dot(vec2 other);
		[CCode (cname = "vec2_length_sqrd")]
		public float LengthSquared();
		[CCode (cname = "vec2_length")]
		public float Length();
		[CCode (cname = "vec2_dist_sqrd")]
		public float DistSquared(vec2 other);
		[CCode (cname = "vec2_dist")]
		public float Dist(vec2 other);
		[CCode (cname = "vec2_dist_manhattan")]
		public float DistManhattan(vec2 other);
		[CCode (cname = "vec2_normalize")]
		public vec2 Normalize();
		
		[CCode (cname = "vec2_reflect")]
		public vec2 Reflect(vec2 other);
		
		[CCode (cname = "vec2_from_string")]
		public vec2 Parse(string s);
		[CCode (cname = "vec2_print")]
		public void Print();
		
		[CCode (cname = "vec2_to_array")]
		public void ToArray(ref float result);
		
		[CCode (cname = "vec2_hash")]
		public int GetHashCode();
		[CCode (cname = "vec2_mix_hash")]
		public int MixHash();
		
		[CCode (cname = "vec2_saturate")]
		public vec2 Saturate();
		[CCode (cname = "vec2_lerp")]
		public vec2 Lerp(vec2 other, float amount);
		[CCode (cname = "vec2_smoothstep")]
		public vec2 SmoothStep(vec2 other, float amount);
		[CCode (cname = "vec2_smootherstep")]
		public vec2 SmootherStep(vec2 other, float amount);

		public string to_string()
		{
			return @"{X:$X, Y:$Y}";
		}
		public vec2 Copy()
		{
			return { X, Y };
		}
		public void Clone(vec2 other)
		{
			X = other.X;
			Y = other.Y;
		}
				
	}

	[SimpleType, CCode (cname = "vec3")]
	public struct vec3 
	{
		[CCode (cname = "x")]
		public float X;
		[CCode (cname = "y")]
		public float Y;
		[CCode (cname = "z")]
		public float Z;

		[CCode (cname = "vec3_new")]
		public vec3 (float x, float y, float z);
		[CCode (cname = "vec3_zero")]
		private static vec3 zero();
		public static vec3 Zero { get { return zero();}}
		[CCode (cname = "vec3_one")]
		private static vec3 one();
		public static vec3 One { get { return one();}}
		[CCode (cname = "vec3_up")]
		private static vec3 up();
		public static vec3 Up { get { return up();}}
		[CCode (cname = "vec3_red")]
		private static vec3 red();
		public static vec3 Red { get { return red();}}
		[CCode (cname = "vec3_green")]
		private static vec3 green();
		public static vec3 Green { get { return green();}}
		[CCode (cname = "vec3_blue")]
		private static vec3 blue();
		public static vec3 Blue { get { return blue();}}
		[CCode (cname = "vec3_white")]
		private static vec3 white();
		public static vec3 White { get { return white();}}
		[CCode (cname = "vec3_black")]
		private static vec3 black();
		public static vec3 Black { get { return black();}}
		[CCode (cname = "vec3_grey")]
		private static vec3 grey();
		public static vec3 Grey { get { return grey();}}
		[CCode (cname = "vec3_light_grey")]
		private static vec3 lightGrey();
		public static vec3 LightGrey { get { return lightGrey();}}
		[CCode (cname = "vec3_dark_grey")]
		private static vec3 darkGrey();
		public static vec3 DarkGrey { get { return darkGrey();}}
		
		[CCode (cname = "vec3_add")]
		public vec3 Add(vec3 other);
		[CCode (cname = "vec3_sub")]
		public vec3 Sub(vec3 other);
		[CCode (cname = "vec3_mul")]
		public vec3 Multiply(float fac);
		[CCode (cname = "vec3_mul_vec3")]
		public vec3 MulVec3(vec3 other);
		[CCode (cname = "vec3_div")]
		public vec3 Divide(float fac);
		[CCode (cname = "vec3_div_vec3")]
		public vec3 DivVec3(vec3 other);
		[CCode (cname = "vec3_pow")]
		public vec3 Pow(float fac);
		[CCode (cname = "vec3_neg")]
		public vec3 Neg();
		[CCode (cname = "vec3_abs")]
		public vec3 Abs();
		[CCode (cname = "vec3_floor")]
		public vec3 Floor();
		[CCode (cname = "vec3_fmod")]
		public vec3 FMod(float val);
		
		[CCode (cname = "vec3_equ")]
		public bool Equals(vec3 other);
		[CCode (cname = "vec3_neq")]
		public bool NotEquals(vec3 other);
		
		[CCode (cname = "vec3_dot")]
		public float Dot(vec3 other);
		[CCode (cname = "vec3_length_sqrd")]
		public float LengthSquared();
		[CCode (cname = "vec3_length")]
		public float Length();
		[CCode (cname = "vec3_dist_sqrd")]
		public float DistSquared(vec3 other);
		[CCode (cname = "vec3_dist")]
		public float Dist(vec3 other);
		[CCode (cname = "vec3_dist_manhattan")]
		public float DistManhattan(vec3 other);
		[CCode (cname = "vec3_cross")]
		public vec3 Cross(vec3 other);
		[CCode (cname = "vec3_normalize")]
		public vec3 Normalize();
		
		[CCode (cname = "vec3_reflect")]
		public vec3 Reflect(vec3 other);
		[CCode (cname = "vec3_project")]
		public vec3 Project(vec3 other);
		
		[CCode (cname = "vec3_from_string")]
		public vec3 Parse(string s);
		[CCode (cname = "vec3_print")]
		public void Print();
		
		[CCode (cname = "vec3_to_array")]
		public void ToArray(ref float result);
		
		[CCode (cname = "vec3_hash")]
		public int GetHashCode();
		
		[CCode (cname = "vec3_saturate")]
		public vec3 Saturate();
		[CCode (cname = "vec3_lerp")]
		public vec3 Lerp(vec3 other, float amount);
		[CCode (cname = "vec3_smoothstep")]
		public vec3 SmoothStep(vec3 other, float amount);
		[CCode (cname = "vec3_smootherstep")]
		public vec3 SmootherStep(vec3 other, float amount);

		public string to_string()
		{
			return @"{X:$X, Y:$Y, Z:$Z}";
		}
				
	}

	[SimpleType, CCode (cname = "vec4")]
	public struct vec4 
	{
		[CCode (cname = "x")]
		public float X;
		[CCode (cname = "y")]
		public float Y;
		[CCode (cname = "z")]
		public float Z;
		[CCode (cname = "w")]
		public float W;

		[CCode (cname = "vec4_new")]
		public vec4 (float x, float y, float z, float w);
		[CCode (cname = "vec4_zero")]
		public static vec4 Zero();
		[CCode (cname = "vec4_one")]
		public static vec4 one();
		[CCode (cname = "vec4_red")]
		public static vec4 Red();
		[CCode (cname = "vec4_green")]
		public static vec4 Green();
		[CCode (cname = "vec4_blue")]
		public static vec4 Blue();
		[CCode (cname = "vec4_white")]
		public static vec4 White();
		[CCode (cname = "vec4_black")]
		public static vec4 Black();
		[CCode (cname = "vec4_grey")]
		public static vec4 Grey();
		[CCode (cname = "vec4_light_grey")]
		public static vec4 LightGrey();
		[CCode (cname = "vec4_dark_grey")]
		public static vec4 DarkGrey();
		
		[CCode (cname = "vec4_add")]
		public vec4 Add(vec4 v2);
		[CCode (cname = "vec4_sub")]
		public vec4 Sub(vec4 v2);
		[CCode (cname = "vec4_mul")]
		public vec4 Multiply(float fac);
		[CCode (cname = "vec4_mul_vec4")]
		public vec4 MulVec4(vec4 v2);
		[CCode (cname = "vec4_div")]
		public vec4 Divide(float fac);
		[CCode (cname = "vec4_pow")]
		public vec4 Pow(float fac);
		[CCode (cname = "vec4_neg")]
		public vec4 Neg();
		[CCode (cname = "vec4_abs")]
		public vec4 Abs();
		[CCode (cname = "vec4_floor")]
		public vec4 Floor();
		[CCode (cname = "vec4_fmod")]
		public vec4 FMod(float val);
		[CCode (cname = "vec4_sqrt")]
		public vec4 Sqrt();
		
		[CCode (cname = "vec4_max")]
		public vec4 Max(vec4 v2);
		[CCode (cname = "vec4_min")]
		public vec4 Min(vec4 v2);
		[CCode (cname = "vec4_equ")]
		public bool Equals(vec4 v2);
		
		[CCode (cname = "vec4_dot")]
		public float Dot(vec4 v2);
		[CCode (cname = "vec4_length_sqrd")]
		public float LengthSquared();
		[CCode (cname = "vec4_length")]
		public float Length();
		[CCode (cname = "vec4_dist_sqrd")]
		public float DistSquared(vec4 v2);
		[CCode (cname = "vec4_dist")]
		public float Dist(vec4 v2);
		[CCode (cname = "vec4_dist_manhattan")]
		public float DistManhattan(vec4 v2);
		[CCode (cname = "vec4_normalize")]
		public vec4 Normalize();
		
		[CCode (cname = "vec4_reflect")]
		public vec4 Reflect(vec4 v2);
		
		[CCode (cname = "vec4_from_string")]
		public vec4 Parse(string s);
		[CCode (cname = "vec4_print")]
		public void Print();
		
		[CCode (cname = "vec4_to_array")]
		public void ToArray(ref float result);
		
		[CCode (cname = "vec3_to_homogeneous")]
		public vec4 ToHomogeneous(vec3 v);
		[CCode (cname = "vec4_from_homogeneous")]
		public vec3 FromHomogeneous();
		
		[CCode (cname = "vec4_hash")]
		public int GetHashCode();
		
		[CCode (cname = "vec4_saturate")]
		public vec4 Saturate();
		[CCode (cname = "vec4_lerp")]
		public vec4 Lerp(vec4 v2, float amount);
		[CCode (cname = "vec4_smoothstep")]
		public vec4 SmoothStep(vec4 v2, float amount);
		[CCode (cname = "vec4_smootherstep")]
		public vec4 SmootherStep(vec4 v2, float amount);
		[CCode (cname = "vec4_nearest_interp")]
		public vec4 NearestInterp(vec4 v2, float amount);
		
		[CCode (cname = "vec4_binearest_interp")]
		public vec4 BinearestInterp(vec4 top_left, vec4 top_right, vec4 bottom_left, vec4 bottom_right, float x_amount, float y_amount);
		[CCode (cname = "vec4_bilinear_interp")]
		public vec4 BilinearInterp(vec4 top_left, vec4 top_right, vec4 bottom_left, vec4 bottom_right, float x_amount, float y_amount);
	}
		
	[SimpleType, CCode (cname = "quat")]
	public struct quat 
	{
		[CCode (cname = "x")]
		public float X;
		[CCode (cname = "y")]
		public float Y;
		[CCode (cname = "z")]
		public float Z;
		[CCode (cname = "w")]
		public float W;

		[CCode (cname = "quat_new")]
		public quat (float x, float y, float z, float w);
		[CCode (cname = "quat_id")]
		public static quat Identity();
		[CCode (cname = "quat_from_euler")]
		public static quat FromEuler(vec3 r);
		[CCode (cname = "quat_angle_axis")]
		public static quat AngleAxis(float angle, vec3 axis);
		[CCode (cname = "quat_rotation_x")]
		public static quat RotationX(float angle);
		[CCode (cname = "quat_rotation_y")]
		public static quat RotationY(float angle);
		[CCode (cname = "quat_rotation_z")]
		public static quat RotationZ(float angle);
		
		[CCode (cname = "quat_at")]
		public float At(int i);
		[CCode (cname = "quat_real")]
		public float Real();
		[CCode (cname = "quat_imaginaries")]
		public vec3 Imaginaries();
		
		[CCode (cname = "quat_to_angle_axis")]
		public void ToAngleAxis(ref vec3 axis, ref float angle);
		[CCode (cname = "quat_to_euler")]
		public vec3 ToEuler();
		
		[CCode (cname = "quat_neg")]
		public quat Neg();
		[CCode (cname = "quat_dot")]
		public float Dot(quat other);
		[CCode (cname = "quat_scale")]
		public quat Scale(float f);
		[CCode (cname = "quat_mul_quat")]
		public quat Mul(quat other);
		[CCode (cname = "quat_mul_vec3")]
		public vec3 MulVec3(vec3 v);
		
		[CCode (cname = "quat_inverse")]
		public quat Inverse();
		[CCode (cname = "quat_unit_inverse")]
		public quat UnitInverse();
		[CCode (cname = "quat_length")]
		public float Length();
		[CCode (cname = "quat_normalize")]
		public quat Normalize();
		
		[CCode (cname = "quat_exp")]
		public quat Exp(vec3 w);
		[CCode (cname = "quat_log")]
		public vec3 Log();
		
		[CCode (cname = "quat_slerp")]
		public quat SLerp(quat other, float amount);
		
		[CCode (cname = "quat_constrain")]
		public quat Constrain(vec3 axis);
		[CCode (cname = "quat_constrain_y")]
		public quat ConstrainY();
		
		[CCode (cname = "quat_distance")]
		public float Distance(quat other);
		[CCode (cname = "quat_interpolate")]
		public quat Interpolate(ref quat other, ref float ws, int count);
	}
	
	[SimpleType, CCode (cname = "quat_dual")]
	public struct dquat 
	{
		[CCode (cname = "real")]
		public quat Real;
		[CCode (cname = "dual")]
		public quat Dual;

		[CCode (cname = "quat_dual_new")]
		public dquat (dquat real, dquat dual);
		[CCode (cname = "quat_dual_id")]
		public static dquat Identity();
		[CCode (cname = "quat_dual_transform")]
		public static dquat Transform(quat q, vec3 t);
		[CCode (cname = "quat_dual_mul")]
		public dquat Mul(dquat q1);
		[CCode (cname = "quat_dual_mul_vec3")]
		public vec3 MulVec3(vec3 v);
		[CCode (cname = "quat_dual_mul_vec3_rot")]
		public vec3 MulVec3Rot(vec3 v);
	}
	
	[SimpleType, CCode (cname = "mat2")]
	public struct mat2 
	{
		[CCode (cname = "xx")]
		public float M11; 
		[CCode (cname = "xy")]
		public float M12;
		[CCode (cname = "yx")]
		public float M21; 
		[CCode (cname = "yy")]
		public float M22;

		[CCode (cname = "mat2_new")]
		public mat2 (float m11, float m12, float m21, float m22);
		[CCode (cname = "mat2_id")]
		public static mat2 Identity();
		[CCode (cname = "mat2_zero")]
		public static mat2 Zero();

		[CCode (cname = "mat2_mul_mat2")]
		public mat2 Mul(mat2 other);
		[CCode (cname = "mat2_mul_vec2")]
		public vec2 MulVec2(vec2 other);
		[CCode (cname = "mat2_transpose")]
		public mat2 Transpose();
		[CCode (cname = "mat2_det")]
		public float Det();
		[CCode (cname = "mat2_inverse")]
		public mat2 Inverse();
		[CCode (cname = "mat2_to_array")]
		public void ToArray(ref float result);
		[CCode (cname = "mat2_print")]
		public void Print();
		[CCode (cname = "mat2_rotation")]
		public mat2 Rotation(float a);
	}


	[SimpleType, CCode (cname = "mat3")]
	public struct mat3 
	{
		[CCode (cname = "xx")]
		public float M11; 
		[CCode (cname = "xy")]
		public float M12; 
		[CCode (cname = "xz")]
		public float M13;
		[CCode (cname = "yz")]
		public float M21; 
		[CCode (cname = "yy")]
		public float M22; 
		[CCode (cname = "yz")]
		public float M23;
		[CCode (cname = "zx")]
		public float M31; 
		[CCode (cname = "zy")]
		public float M32; 
		[CCode (cname = "zz")]
		public float M33;

		[CCode (cname = "mat3_new")]
		public mat3 (float m11, float m12, float m13,
					float m21, float m22, float m23,
					float m31, float m32, float m33);
		[CCode (cname = "mat3_id")]
		public static mat3 Identity();
		[CCode (cname = "mat3_zero")]
		public static mat3 Zero();
		[CCode (cname = "mat3_scale")]
		public static mat3 Scale(vec3 s);
		[CCode (cname = "mat3_rotation_x")]
		public static mat3 RotationX(float a);
		[CCode (cname = "mat3_rotation_y")]
		public static mat3 RotationY(float a);
		[CCode (cname = "mat3_rotation_z")]
		public static mat3 RotationZ(float a);
		[CCode (cname = "mat3_rotation_angle_axis")]
		public static mat3 RotationAngleAxis(float angle, vec3 axis);

		[CCode (cname = "mat3_mul_mat3")]
		public mat3 Mul(mat3 other);
		[CCode (cname = "mat3_mul_vec3")]
		public vec3 MulVec3(vec3 other);
		
		[CCode (cname = "mat3_transpose")]
		public mat3 Transpose();
		[CCode (cname = "mat3_det")]
		public float Det();
		[CCode (cname = "mat3_inverse")]
		public mat3 Inverse();
		
		[CCode (cname = "mat3_to_array")]
		public void ToArray(ref float result);
		[CCode (cname = "mat3_print")]
		public void Print();
	}

	[SimpleType, CCode (cname = "mat4")]
	public struct mat4 
	{
		[CCode (cname = "xx")]
		public float M11; 
		[CCode (cname = "xy")]
		public float M12; 
		[CCode (cname = "xz")]
		public float M13;
		[CCode (cname = "xw")]
		public float M14;
		[CCode (cname = "yz")]
		public float M21; 
		[CCode (cname = "yy")]
		public float M22; 
		[CCode (cname = "yz")]
		public float M23;
		[CCode (cname = "yw")]
		public float M24;
		[CCode (cname = "zx")]
		public float M31; 
		[CCode (cname = "zy")]
		public float M32; 
		[CCode (cname = "zz")]
		public float M33;
		[CCode (cname = "zw")]
		public float M34;
		[CCode (cname = "wx")]
		public float M41; 
		[CCode (cname = "wy")]
		public float M42; 
		[CCode (cname = "wz")]
		public float M43;
		[CCode (cname = "ww")]
		public float M44;
		
		[CCode (cname = "mat4_new")]
		public mat4 (float m11, float m12, float m13, float m14,
					float m21, float m22, float m23, float m24,
					float m31, float m32, float m33, float m34,
					float m41, float m42, float m43, float m44);

		[CCode (cname = "mat4_id")]
		public static mat4 Identity();
		[CCode (cname = "mat4_zero")]
		public static mat4 Zero();

		[CCode (cname = "mat4_at")]
		public float At(int i, int j);
		[CCode (cname = "mat4_set")]
		public mat4 Set(int x, int y, float v);
		[CCode (cname = "mat4_transpose")]
		public mat4 Transpose();
		
		[CCode (cname = "mat4_mul_mat4")]
		public mat4 Multiply(mat4 other);
		
		[CCode (cname = "mat4_mul_vec4")]
		public vec4 MulVec4(vec4 v);
		[CCode (cname = "mat4_mul_vec3")]
		public vec3 MulVec3(vec3 v);
		
		[CCode (cname = "mat4_det")]
		public float Det();
		[CCode (cname = "mat4_inverse")]
		public mat4 Invert();
		
		[CCode (cname = "mat3_to_mat4")]
		public static mat4 mat3Tomat4(mat3 m);
		[CCode (cname = "mat4_to_mat3")]
		public mat3 Tomat3();
		[CCode (cname = "mat4_to_quat")]
		public quat Toquat();
		[CCode (cname = "mat4_to_quat_dual")]
		public dquat Todquat();
		
		[CCode (cname = "mat4_to_array")]
		public void ToArray(ref float result);
		[CCode (cname = "mat4_to_array_trans")]
		public void ToArrayTrans(ref float result);
		
		[CCode (cname = "mat4_print")]
		public void Print();
		
		[CCode (cname = "mat4_translation")]
		public static mat4 Translation(vec3 v);
		[CCode (cname = "mat4_scale")]
		public static mat4 Scale(vec3 v);

		[CCode (cname = "mat4_rotate")]
		public mat4 Rotate(float a);
		[CCode (cname = "mat4_translate")]
		public mat4 Translate(vec3 v);
	
		[CCode (cname = "mat4_rotation_x")]
		public static mat4 RotationX(float a);
		[CCode (cname = "mat4_rotation_y")]
		public static mat4 RotationY(float a);
		[CCode (cname = "mat4_rotation_z")]
		public static mat4 RotationZ(float a);
		[CCode (cname = "mat4_rotation_axis_angle")]
		public static mat4 RotationAxisAngle(vec3 axis, float angle);
		
		[CCode (cname = "mat4_rotation_euler")]
		public static mat4 RotationEuler(float x, float y, float z);
		[CCode (cname = "mat4_rotation_quat")]
		public static mat4 Rotation(quat q);
		[CCode (cname = "mat4_rotation_quat_dual")]
		public static mat4 RotationDual(dquat q);
		
		[CCode (cname = "mat4_view_look_at")]
		public static mat4 ViewLookAt(vec3 position, vec3 target, vec3 up);
		[CCode (cname = "mat4_perspective")]
		public static mat4 Perspective(float fov, float near_clip, float far_clip, float ratio);
		[CCode (cname = "mat4_orthographic")]
		public static mat4 Orthographic(float left, float right, float bottom, float top, float near, float far);
		
		[CCode (cname = "mat4_world")]
		public static mat4 World(vec3 position, vec3 scale, quat rotation);
		
		[CCode (cname = "mat4_lerp")]
		public mat4 Lerp(mat4 other, float amount);
		[CCode (cname = "mat4_smoothstep")]
		public mat4 SmoothStep(mat4 other, float amount);
															
	}
}
