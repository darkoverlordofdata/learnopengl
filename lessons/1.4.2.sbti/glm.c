/*
The MIT License (MIT)

Copyright (c) <2018> <>

Corange definitions used for gl math.

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
#include "glm.h"

int rawcast(float x) {
  union {
    float f;
    int i;
  } u;
  u.f = x;
  return u.i;
}

float max(float x, float y) {
  return x > y ? x : y;
}

float min(float x, float y) {
  return x < y ? x : y;
}

float clamp(float x, float bottom, float top) {
  x = max(x, bottom);
  x = min(x, top);
  return x;
}

bool between(float x, float bottom, float top) {
  return (x > bottom) && (x < top);
}

bool between_or(float x, float bottom, float top) {
  return (x >= bottom) && (x <= top);
}

float saturate(float x) {
  x = max(x, 0.0);
  x = min(x, 1.0);
  return x;
}

float lerp(float p1, float p2, float amount) {
  return (p2 * amount) + (p1 * (1-amount));
}

float smoothstep(float p1, float p2, float amount) {
  float scaled_amount = amount*amount*(3 - 2*amount);
  return lerp( p1, p2, scaled_amount );
}

float smootherstep(float p1, float p2, float amount) {
  float scaled_amount = amount*amount*amount*(amount*(amount*6 - 15) + 10);
  return lerp( p1, p2, scaled_amount );
}

float cosine_interp(float p1, float p2, float amount) {
   float mu2 = (1-cos(amount*M_PI))/2;
   return (p2*(1-mu2)+p1*mu2);
}

float nearest_interp(float p1, float p2, float amount) {
  amount = roundf(amount);
  if (amount) { return p2; }
  else { return p1; }
}

float cubic_interp(float p1, float p2, float p3, float p4, float amount) {
  
  float amount_sqrd = amount * amount;
  float amount_cubd = amount * amount * amount;
  
  float a1 = p4 - p3 - p2 + p1;
  float a2 = p1 - p2 - a1;
  float a3 = p3 - p1;
  float a4 = p2;
  
  return (a1 * amount_cubd) + (a2 * amount_sqrd) + (a3 * amount) + a4;
}

float binearest_interp(float tl, float tr, float bl, float br, float x_amount, float y_amount) {
  
  x_amount = roundf(x_amount);
  y_amount = roundf(y_amount);
  
  if( x_amount && !y_amount ) { return br; }
  if( !x_amount && y_amount ) { return tl; }
  if( !x_amount && !y_amount ) { return bl; }
  if( x_amount && y_amount ) { return tr; }
  
  return 0.0f;
}

float bilinear_interp(float tl, float tr, float bl, float br, float x_amount, float y_amount) {
  float left = lerp(tl, bl, y_amount);
  float right = lerp(tr,br,  y_amount);
  return lerp(right, left, x_amount);
}

float bicosine_interp(float tl, float tr, float bl, float br, float x_amount, float y_amount) {
  float left = cosine_interp(tl, bl, y_amount);
  float right = cosine_interp(tr, br, y_amount);
  return cosine_interp(right, left, x_amount);
}

float bismoothstep_interp(float tl, float tr, float bl, float br, float x_amount, float y_amount) {
  float left = smoothstep(tl, bl, y_amount);
  float right = smoothstep(tr, br, y_amount);
  return smoothstep(right, left, x_amount);
}

float bismootherstep_interp(float tl, float tr, float bl, float br, float x_amount, float y_amount) {

  float left = smootherstep(tl, bl, y_amount);
  float right = smootherstep(tr, br, y_amount);
  return smootherstep(right, left, x_amount);
}

vec2 vec2_new(float x, float y) {
  vec2 v;
  v.x = x;
  v.y = y;
  return v;
}

vec2 vec2_zero() {
  return vec2_new(0, 0);
}

vec2 vec2_one() {
  return vec2_new(1, 1);
}

vec2 vec2_add(vec2 v1, vec2 v2) {
  vec2 v;
  v.x = v1.x + v2.x;
  v.y = v1.y + v2.y;
  return v;
}

vec2 vec2_sub(vec2 v1, vec2 v2) {
  vec2 v;
  v.x = v1.x - v2.x;
  v.y = v1.y - v2.y;
  return v;
}

vec2 vec2_div(vec2 v, float fac) {
  v.x = v.x / fac;
  v.y = v.y / fac;
  return v;
}

vec2 vec2_div_vec2(vec2 v1, vec2 v2) {
  v1.x = v1.x / v2.x;
  v1.y = v1.y / v2.y;
  return v1;
}

vec2 vec2_mul(vec2 v, float fac) {
  v.x = v.x * fac;
  v.y = v.y * fac;
  return v;
}

vec2 vec2_mul_vec2(vec2 v1, vec2 v2) {
  vec2 v;
  v.x = v1.x * v2.x;
  v.y = v1.y * v2.y;
  return v;
}

vec2 vec2_pow(vec2 v, float exp) {
  v.x = pow(v.x, exp);
  v.y = pow(v.y, exp);
  return v;
}

vec2 vec2_neg(vec2 v) {
  v.x = -v.x;
  v.y = -v.y;
  return v;
}

vec2 vec2_abs(vec2 v) {
  v.x = fabs(v.x);
  v.y = fabs(v.y);
  return v;
}

vec2 vec2_floor(vec2 v) {
  v.x = floor(v.x);
  v.y = floor(v.y);
  return v;
}

vec2 vec2_fmod(vec2 v, float val) {
  v.x = fmod(v.x, val);
  v.y = fmod(v.y, val);
  return v;
}

vec2 vec2_max(vec2 v, float x) {
  v.x = max(v.x, x);
  v.y = max(v.y, x);
  return v;
}

vec2 vec2_min(vec2 v, float x) {
  v.x = min(v.x, x);
  v.y = min(v.y, x);
  return v;
}

vec2 vec2_clamp(vec2 v, float b, float t) {
  v.x = clamp(v.x, b, t);
  v.y = clamp(v.y, b, t);
  return v;
}

void vec2_print(vec2 v) {
  printf("vec2(%4.2f,%4.2f)", v.x, v.y);
}

float vec2_dot(vec2 v1, vec2 v2) {
  return (v1.x * v2.x) + (v1.y * v2.y);
}

float vec2_length_sqrd(vec2 v) {
  float length = 0.0;
  length += v.x * v.x;
  length += v.y * v.y;
  return length;
}

float vec2_length(vec2 v) {
  return sqrt(vec2_length_sqrd(v));
}

float vec2_dist_sqrd(vec2 v1, vec2 v2) {
  return (v1.x - v2.x) * (v1.x - v2.x) + 
         (v1.y - v2.y) * (v1.y - v2.y);
}

float vec2_dist(vec2 v1, vec2 v2) {
  return sqrt(vec2_dist_sqrd(v1, v2));
}

float vec2_dist_manhattan(vec2 v1, vec2 v2) {
  return fabs(v1.x - v2.x) + fabs(v1.y - v2.y);
}

vec2 vec2_normalize(vec2 v) {
  float len = vec2_length(v);
  return vec2_div(v, len);
}

vec2 vec2_reflect(vec2 v1, vec2 v2) {
  return vec2_sub(v1, vec2_mul(v2, 2 * vec2_dot(v1, v2)));
}

vec2 vec2_from_string(char* s) {

  char* pEnd;
  double d1, d2;
  d1 = strtod(s,&pEnd);
  d2 = strtod(pEnd,NULL);  

  vec2 v;
  v.x = d1;
  v.y = d2;
  
  return v;
}

bool vec2_equ(vec2 v1, vec2 v2) {
  if(!(v1.x == v2.x)) { return false; }
  if(!(v1.y == v2.y)) { return false; }
  return true;
}

void vec2_to_array(vec2 v, float* out) {
  out[0] = v.x;
  out[1] = v.y;
}

int vec2_hash(vec2 v) {
  return abs(rawcast(v.x) ^ rawcast(v.y));
}

int vec2_mix_hash(vec2 v) {

  int raw_vx = abs(rawcast(v.x));
  int raw_vy = abs(rawcast(v.y));

  int h1 = raw_vx << 1;
  int h2 = raw_vy << 3;
  int h3 = raw_vx >> 8;
  
  int h4 = raw_vy << 7;
  int h5 = raw_vx >> 12;
  int h6 = raw_vy >> 15;

  int h7 = raw_vx << 2;
  int h8 = raw_vy << 6;
  int h9 = raw_vx >> 2;
  
  int h10 = raw_vy << 9;
  int h11 = raw_vx >> 21;
  int h12 = raw_vy >> 13;
  
  int res1 = h1 ^ h2 ^ h3;
  int res2 = h4 ^ h5 ^ h6;
  int res3 = h7 ^ h8 ^ h9;
  int res4 = h10 ^ h11 ^ h12;
  
  return (res1 * 10252247) ^ (res2 * 70209673) ^ (res3 * 104711) ^ (res4 * 63589);
}

vec2 vec2_saturate(vec2 v) {
  v.x = saturate(v.x);
  v.y = saturate(v.y);
  return v;
}

vec2 vec2_lerp(vec2 v1, vec2 v2, float amount) {
  vec2 v;
  v.x = lerp(v1.x, v2.x, amount);
  v.y = lerp(v1.y, v2.y, amount);
  return v;
}

vec2 vec2_smoothstep(vec2 v1, vec2 v2, float amount) {
  float scaled_amount = amount*amount*(3 - 2*amount);
  return vec2_lerp( v1, v2, scaled_amount );
}

vec2 vec2_smootherstep(vec2 v1, vec2 v2, float amount) {
  float scaled_amount = amount*amount*amount*(amount*(amount*6 - 15) + 10);
  return vec2_lerp( v1, v2, scaled_amount );
}

/* vec3 */

vec3 vec3_new(float x, float y, float z) {
  vec3 v;
  v.x = x;
  v.y = y;
  v.z = z;
  return v;
}

vec3 vec3_zero() {
  return vec3_new(0, 0, 0);
}

vec3 vec3_one() {
  return vec3_new(1, 1, 1);
}

vec3 vec3_red() {
  return vec3_new(1, 0, 0);
}

vec3 vec3_green() {
  return vec3_new(0, 1, 0);
}

vec3 vec3_blue() {
  return vec3_new(0, 0, 1);
}

vec3 vec3_white() {
  return vec3_new(1, 1, 1);
}

vec3 vec3_black() {
  return vec3_new(0, 0, 0);
}

vec3 vec3_grey() {
  return vec3_new(0.5, 0.5, 0.5);
}

vec3 vec3_light_grey() {
  return vec3_new(0.75,0.75,0.75);
}

vec3 vec3_dark_grey() {
  return vec3_new(0.25,0.25,0.25);
}

vec3 vec3_up() {
  return vec3_new(0, 1, 0);
}

vec3 vec3_add(vec3 v1, vec3 v2) {
  vec3 v;
  v.x = v1.x + v2.x;
  v.y = v1.y + v2.y;
  v.z = v1.z + v2.z;
  return v;
}

vec3 vec3_sub(vec3 v1, vec3 v2) {
  vec3 v;
  v.x = v1.x - v2.x;
  v.y = v1.y - v2.y;
  v.z = v1.z - v2.z;
  return v;
}

vec3 vec3_div(vec3 v, float fac) {
  v.x = v.x / fac;
  v.y = v.y / fac;
  v.z = v.z / fac;
  return v;
}

vec3 vec3_div_vec3(vec3 v1, vec3 v2) {
  vec3 v;
  v.x = v1.x / v2.x;
  v.y = v1.y / v2.y;
  v.z = v1.z / v2.z;
  return v;
}

vec3 vec3_mul(vec3 v, float fac) {
  v.x = v.x * fac;
  v.y = v.y * fac;
  v.z = v.z * fac;
  return v;
}

vec3 vec3_mul_vec3(vec3 v1, vec3 v2) {
  vec3 v;
  v.x = v1.x * v2.x;
  v.y = v1.y * v2.y;
  v.z = v1.z * v2.z;
  return v;
}

vec3 vec3_pow(vec3 v, float exp) {
  v.x = pow(v.x, exp);
  v.y = pow(v.y, exp);
  v.z = pow(v.z, exp);
  return v;
}

vec3 vec3_neg(vec3 v) {
  v.x = -v.x;
  v.y = -v.y;
  v.z = -v.z;
  return v;
}

vec3 vec3_abs(vec3 v) {
  v.x = fabs(v.x);
  v.y = fabs(v.y);
  v.z = fabs(v.z);
  return v;
}

vec3 vec3_floor(vec3 v) {
  v.x = floor(v.x);
  v.y = floor(v.y);
  v.z = floor(v.z);
  return v;
}

vec3 vec3_fmod(vec3 v, float val) {
  v.x = fmod(v.x, val);
  v.y = fmod(v.y, val);
  v.z = fmod(v.z, val);
  return v;
}

void vec3_print(vec3 v) {
  printf("vec3(%4.2f,%4.2f,%4.2f)", v.x, v.y, v.z);
}

float vec3_dot(vec3 v1, vec3 v2) {
  return (v1.x * v2.x) + (v1.y * v2.y) + (v1.z * v2.z);
}

vec3 vec3_cross(vec3 v1, vec3 v2) {
  vec3 v;
  v.x = (v1.y * v2.z) - (v1.z * v2.y);
  v.y = (v1.z * v2.x) - (v1.x * v2.z);
  v.z = (v1.x * v2.y) - (v1.y * v2.x);
  return v;
}

float vec3_length_sqrd(vec3 v) {
  float length = 0.0;
  length += v.x * v.x;
  length += v.y * v.y;
  length += v.z * v.z;
  return length;
}

float vec3_length(vec3 v) {
  return sqrt(vec3_length_sqrd(v));
}

float vec3_dist_sqrd(vec3 v1, vec3 v2) {
  return (v1.x - v2.x) * (v1.x - v2.x) + 
         (v1.y - v2.y) * (v1.y - v2.y) + 
         (v1.z - v2.z) * (v1.z - v2.z);
}

float vec3_dist(vec3 v1, vec3 v2) {
  return sqrt(vec3_dist_sqrd(v1, v2));
}

float vec3_dist_manhattan(vec3 v1, vec3 v2) {
  return fabs(v1.x - v2.x) + fabs(v1.y - v2.y) + fabs(v1.z - v2.z);
}

vec3 vec3_normalize(vec3 v) {
  float len = vec3_length(v);
  if (len == 0.0) {
    return vec3_zero();
  } else {
    return vec3_div(v, len);
  }
}

vec3 vec3_reflect(vec3 v1, vec3 v2) {
  return vec3_sub(v1, vec3_mul(v2, 2 * vec3_dot(v1, v2)));
}

vec3 vec3_project(vec3 v1, vec3 v2) {
  return vec3_sub(v1, vec3_mul(v2, vec3_dot(v1, v2)));
}

vec3 vec3_from_string(char* s) {
  
  char* pEnd;
  double d1, d2, d3;
  d1 = strtod(s,&pEnd);
  d2 = strtod(pEnd,&pEnd);  
  d3 = strtod(pEnd,NULL);  

  vec3 v;
  v.x = d1;
  v.y = d2;
  v.z = d3;
  
  return v;

}

bool vec3_equ(vec3 v1, vec3 v2) {
  if (v1.x != v2.x) { return false; }
  if (v1.y != v2.y) { return false; }
  if (v1.z != v2.z) { return false; }
  return true;
}

bool vec3_neq(vec3 v1, vec3 v2) {
  if (v1.x != v2.x) { return true; }
  if (v1.y != v2.y) { return true; }
  if (v1.z != v2.z) { return true; }
  return false;
}

void vec3_to_array(vec3 v, float* out) {
  
  out[0] = v.x;
  out[1] = v.y;
  out[2] = v.z;
  
}

int vec3_hash(vec3 v) {
  return abs( rawcast(v.x) ^ rawcast(v.y) ^ rawcast(v.z) );
}

vec4 vec3_to_homogeneous(vec3 v){
  return vec4_new(v.x, v.y, v.z, 1.0);
};

vec3 vec3_saturate(vec3 v) {
  v.x = saturate(v.x);
  v.y = saturate(v.y);
  v.z = saturate(v.z);
  return v;
}

vec3 vec3_lerp(vec3 v1, vec3 v2, float amount) {
  vec3 v;
  v.x = lerp(v1.x, v2.x, amount);
  v.y = lerp(v1.y, v2.y, amount);
  v.z = lerp(v1.z, v2.z, amount);
  return v;
}

vec3 vec3_smoothstep(vec3 v1, vec3 v2, float amount) {
  float scaled_amount = amount*amount*(3 - 2*amount);
  return vec3_lerp( v1, v2, scaled_amount );
}

vec3 vec3_smootherstep(vec3 v1, vec3 v2, float amount) {
  float scaled_amount = amount*amount*amount*(amount*(amount*6 - 15) + 10);
  return vec3_lerp( v1, v2, scaled_amount );
}

/* vec4 */

vec4 vec4_new(float x, float y, float z, float w) {
  vec4 v;
  v.x = x;
  v.y = y;
  v.z = z;
  v.w = w;
  return v;
}

vec4 vec4_zero() {
  return vec4_new(0, 0, 0, 0);
}

vec4 vec4_one() {
  return vec4_new(1, 1, 1, 1);
}

vec4 vec4_red() {
  return vec4_new(1,0,0,1);
}

vec4 vec4_green() {
  return vec4_new(0,1,0,1);
}

vec4 vec4_blue() {
  return vec4_new(0,0,1,1);
}

vec4 vec4_white() {
  return vec4_new(1,1,1,1);
}

vec4 vec4_black() {
  return vec4_new(0,0,0,1);
}

vec4 vec4_grey() {
  return vec4_new(0.5,0.5,0.5, 1);
}

vec4 vec4_light_grey() {
  return vec4_new(0.75,0.75,0.75, 1);
}

vec4 vec4_dark_grey() {
  return vec4_new(0.25,0.25,0.25, 1);
}

vec4 vec4_add(vec4 v1, vec4 v2) {
  vec4 v;
  v.x = v1.x + v2.x;
  v.y = v1.y + v2.y;
  v.z = v1.z + v2.z;
  v.w = v1.w + v2.w;
  return v;
}

vec4 vec4_sub(vec4 v1, vec4 v2) {
  vec4 v;
  v.x = v1.x - v2.x;
  v.y = v1.y - v2.y;
  v.z = v1.z - v2.z;
  v.w = v1.w - v2.w;
  return v;
}

vec4 vec4_div(vec4 v, float fac) {
  v.x = v.x / fac;
  v.y = v.y / fac;
  v.z = v.z / fac;
  v.w = v.w / fac;
  return v;
}

vec4 vec4_mul(vec4 v, float fac) {
  v.x = v.x * fac;
  v.y = v.y * fac;
  v.z = v.z * fac;
  v.w = v.w * fac;
  return v;
}

vec4 vec4_mul_vec4(vec4 v1, vec4 v2) {
  vec4 v;
  v.x = v1.x * v2.x;
  v.y = v1.y * v2.y;
  v.z = v1.z * v2.z;
  v.w = v1.w * v2.w;
  return v;
}

vec4 vec4_pow(vec4 v, float exp) {
  v.x = pow(v.x, exp);
  v.y = pow(v.y, exp);
  v.z = pow(v.z, exp);
  v.w = pow(v.w, exp);
  return v;
}

vec4 vec4_neg(vec4 v) {
  v.x = -v.x;
  v.y = -v.y;
  v.z = -v.z;
  v.w = -v.w;
  return v;
}

vec4 vec4_abs(vec4 v) {
  v.x = fabs(v.x);
  v.y = fabs(v.y);
  v.z = fabs(v.z);
  v.w = fabs(v.w);
  return v;
}

vec4 vec4_floor(vec4 v) {
  v.x = floor(v.x);
  v.y = floor(v.y);
  v.z = floor(v.z);
  v.w = floor(v.w);
  return v;
}

vec4 vec4_fmod(vec4 v, float val) {
  v.x = fmod(v.x, val);
  v.y = fmod(v.y, val);
  v.z = fmod(v.z, val);
  v.w = fmod(v.w, val);
  return v;  
}

vec4 vec4_sqrt(vec4 v) {
  v.x = sqrt(v.x);
  v.y = sqrt(v.y);
  v.z = sqrt(v.z);
  v.w = sqrt(v.w);
  return v;  
}

void vec4_print(vec4 v) {
  printf("vec4(%4.2f, %4.2f, %4.2f, %4.2f)", v.x, v.y, v.z,  v.w);
}

float vec4_dot(vec4 v1, vec4 v2) {
  return  (v1.x * v2.x) + (v1.y * v2.y) + (v1.z * v2.z) + (v1.w * v2.w);
}

float vec4_length_sqrd(vec4 v) {
  float length = 0.0;
  length += v.x * v.x;
  length += v.y * v.y;
  length += v.z * v.z;
  length += v.w * v.w;
  return length;
}

float vec4_length(vec4 v) {
  return sqrt(vec4_length_sqrd(v));
}

float vec4_dist_sqrd(vec4 v1, vec4 v2) {
  return (v1.x - v2.x) * (v1.x - v2.x) + 
         (v1.y - v2.y) * (v1.y - v2.y) +
         (v1.y - v2.z) * (v1.y - v2.z) +
         (v1.y - v2.w) * (v1.y - v2.w);
}

float vec4_dist(vec4 v1, vec4 v2) {
  return sqrt(vec4_dist_sqrd(v1, v2));
}

float vec4_dist_manhattan(vec4 v1, vec4 v2) {
  return fabs(v1.x - v2.x) + fabs(v1.y - v2.y) + fabs(v1.z - v2.z) + fabs(v1.w - v2.w);
}

vec4 vec4_normalize(vec4 v) {
  float len = vec4_length(v);
  if (len == 0.0) {
    return vec4_zero();
  } else {
    return vec4_div(v, len);
  }
}

vec4 vec4_reflect(vec4 v1, vec4 v2) {
  return vec4_sub(v1, vec4_mul(v2, 2 * vec4_dot(v1, v2)));
}

vec4 vec4_from_string(char* s) {
  char* end;
  double d1, d2, d3, d4;
  d1 = strtod(s,&end);
  d2 = strtod(end,&end);  
  d3 = strtod(end,&end);  
  d4 = strtod(end,NULL);  

  vec4 v;
  v.x = d1;
  v.y = d2;
  v.z = d3;
  v.w = d4;
  
  return v;
}

vec4 vec4_max(vec4 v1, vec4 v2) {
  v1.x = max(v1.x, v2.x);
  v1.y = max(v1.y, v2.y);
  v1.z = max(v1.z, v2.z);
  v1.w = max(v1.w, v2.w);
  return v1;
}

vec4 vec4_min(vec4 v1, vec4 v2) {
  v1.x = min(v1.x, v2.x);
  v1.y = min(v1.y, v2.y);
  v1.z = min(v1.z, v2.z);
  v1.w = min(v1.w, v2.w);
  return v1;
}

bool vec4_equ(vec4 v1, vec4 v2) {
  if(!(v1.x == v2.x)) { return false; }
  if(!(v1.y == v2.y)) { return false; }
  if(!(v1.z == v2.z)) { return false; }
  if(!(v1.w == v2.w)) { return false; }
  return true;
}

void vec4_to_array(vec4 v, float* out) {
  out[0] = v.x;
  out[1] = v.y;
  out[2] = v.z;
  out[3] = v.w;
}

vec3 vec4_from_homogeneous(vec4 v) {
  vec3 vec = vec3_new(v.x,v.y,v.z);
  return vec3_div(vec, v.w);
};

int vec4_hash(vec4 v) {
  return abs( rawcast(v.x) ^ rawcast(v.y) ^ rawcast(v.z) ^ rawcast(v.w) );
}

vec4 vec4_saturate(vec4 v) {

  v.x = saturate(v.x);
  v.y = saturate(v.y);
  v.z = saturate(v.z);
  v.w = saturate(v.w);
  
  return v;
}

vec4 vec4_lerp(vec4 v1, vec4 v2, float amount) {
  vec4 v;
  v.x = lerp(v1.x, v2.x, amount);
  v.y = lerp(v1.y, v2.y, amount);
  v.z = lerp(v1.z, v2.z, amount);
  v.w = lerp(v1.w, v2.w, amount);
  return v;
}

vec4 vec4_smoothstep(vec4 v1, vec4 v2, float amount) {
  float scaled_amount = amount*amount*(3 - 2*amount);
  return vec4_lerp( v1, v2, scaled_amount );
}

vec4 vec4_smootherstep(vec4 v1, vec4 v2, float amount) {
  float scaled_amount = amount*amount*amount*(amount*(amount*6 - 15) + 10);
  return vec4_lerp( v1, v2, scaled_amount );
}

vec4 vec4_nearest_interp(vec4 v1, vec4 v2, float amount) {
  vec4 v;
  v.w = nearest_interp(v1.w, v2.w, amount);
  v.x = nearest_interp(v1.x, v2.x, amount);
  v.y = nearest_interp(v1.y, v2.y, amount);
  v.z = nearest_interp(v1.z, v2.z, amount);
  return v;
}

vec4 vec4_binearest_interp(vec4 tl, vec4 tr, vec4 bl, vec4 br, float x_amount, float y_amount) {

  vec4 v;
  v.x = binearest_interp( tl.x, tr.x, bl.x, br.x, x_amount, y_amount );
  v.y = binearest_interp( tl.y, tr.y, bl.y, br.y, x_amount, y_amount );
  v.z = binearest_interp( tl.z, tr.z, bl.z, br.z, x_amount, y_amount );
  v.w = binearest_interp( tl.w, tr.w, bl.w, br.w, x_amount, y_amount );
  
  return v;

}

vec4 vec4_bilinear_interp(vec4 tl, vec4 tr, vec4 bl, vec4 br, float x_amount, float y_amount) {

  vec4 v;
  v.x = bilinear_interp( tl.x, tr.x, bl.x, br.x, x_amount, y_amount );
  v.y = bilinear_interp( tl.y, tr.y, bl.y, br.y, x_amount, y_amount );
  v.z = bilinear_interp( tl.z, tr.z, bl.z, br.z, x_amount, y_amount );
  v.w = bilinear_interp( tl.w, tr.w, bl.w, br.w, x_amount, y_amount );
  
  return v;

}

quat quat_id() {
  return quat_new(0, 0, 0, 1);
}

quat quat_new(float x, float y, float z, float w) {
  quat q;
  q.x = x;
  q.y = y;
  q.z = z;
  q.w = w;
  return q;
}

float quat_at(quat q, int i) {
  
  float* values = (float*)(&q);
  return values[i];

}

float quat_real(quat q) {
  return q.w;
}

vec3 quat_imaginaries(quat q) {
  return vec3_new(q.x, q.y, q.z);
}

quat quat_from_euler(vec3 r) {
  
  float fc1 = cosf( r.z / 2.0f );
  float fc2 = cosf( r.x / 2.0f );
  float fc3 = cosf( r.y / 2.0f );

  float fs1 = sinf( r.z / 2.0f );
  float fs2 = sinf( r.x / 2.0f );
  float fs3 = sinf( r.y / 2.0f );

  return quat_new(
    fc1 * fc2 * fs3 - fs1 * fs2 * fc3,
    fc1 * fs2 * fc3 + fs1 * fc2 * fs3,
    fs1 * fc2 * fc3 - fc1 * fs2 * fs3,
    fc1 * fc2 * fc3 + fs1 * fs2 * fs3
  );
  
}

quat quat_angle_axis(float angle, vec3 axis) {

  float sine = sinf( angle / 2.0f );
  float cosine = cosf( angle / 2.0f );

  return quat_normalize(quat_new(
    axis.x * sine,
    axis.y * sine,
    axis.z * sine,
    cosine));
    
}

quat quat_rotation_x(float angle) {
  return quat_angle_axis(angle, vec3_new(1,0,0));
}

quat quat_rotation_y(float angle) {
  return quat_angle_axis(angle, vec3_new(0,1,0));
}

quat quat_rotation_z(float angle) {
  return quat_angle_axis(angle, vec3_new(0,0,1));
}

void quat_to_angle_axis(quat q, vec3* axis, float* angle) {

  *angle = 2.0f * acosf( q.w );

  float divisor = sinf( *angle / 2.0f );

  if( fabs( divisor ) < FLT_EPSILON ) {
  
    axis->x = 0.0f;
    axis->y = 1.0f;
    axis->z = 0.0f;
    
  } else {
    
    axis->x = q.x / divisor;
    axis->y = q.y / divisor;
    axis->z = q.z / divisor;
    *axis = vec3_normalize(*axis);
    
  }

}

vec3 quat_to_euler(quat q) {

  float sqrx = q.x * q.x;
  float sqry = q.y * q.y;
  float sqrz = q.z * q.z;
  float sqrw = q.w * q.w;
  
  return vec3_new(
    asinf( -2.0f * ( q.x * q.z - q.y * q.w ) ),
    atan2f( 2.0f * ( q.y * q.z + q.x * q.w ), (-sqrx - sqry + sqrz + sqrw) ),
    atan2f( 2.0f * ( q.x * q.y + q.z * q.w ), ( sqrx - sqry - sqrz + sqrw) ));
    
}

quat quat_mul_quat(quat q1, quat q2) {

  return quat_new(
    (q1.w * q2.x) + (q1.x * q2.w) + (q1.y * q2.z) - (q1.z * q2.y),
    (q1.w * q2.y) - (q1.x * q2.z) + (q1.y * q2.w) + (q1.z * q2.x),
    (q1.w * q2.z) + (q1.x * q2.y) - (q1.y * q2.x) + (q1.z * q2.w),
    (q1.w * q2.w) - (q1.x * q2.x) - (q1.y * q2.y) - (q1.z * q2.z));

}

vec3 quat_mul_vec3(quat q, vec3 v) {

  quat work = q;
  work = quat_mul_quat(work, quat_normalize(quat_new(v.x, v.y, v.z, 0.0)));
  work = quat_mul_quat(work, quat_inverse(q));

  vec3 res = vec3_new(work.x, work.y, work.z);
  
  return vec3_mul(res, vec3_length(v));

}

quat quat_inverse(quat q) {

  float	scale = quat_length(q);
  quat result = quat_unit_inverse(q);

  if ( scale > FLT_EPSILON ) {    
    result.x /= scale;
    result.y /= scale;
    result.z /= scale;
    result.w /= scale;
  }
  
  return result;
}

quat quat_unit_inverse(quat q) {
  return quat_new(-q.x, -q.y, -q.z, q.w);
}

float quat_length(quat q) {
  return sqrtf(q.x*q.x + q.y*q.y + q.z*q.z + q.w*q.w);
}

quat quat_normalize(quat q) {

  float scale = quat_length(q);

  if ( scale > FLT_EPSILON ) {
    return quat_new(
      q.x / scale,
      q.y / scale,
      q.z / scale,
      q.w / scale);
  } else {
    return quat_new(0,0,0,0);
  }
  
}

quat quat_slerp(quat from, quat to, float amount) {
  
  float scale0, scale1;
  float	afto1[4];
  float cosom = from.x * to.x + from.y * to.y + from.z * to.z + from.w * to.w;
  
  if ( cosom < 0.0f ) {
    cosom = -cosom; 
    afto1[0] = -to.x;
    afto1[1] = -to.y;
    afto1[2] = -to.z;
    afto1[3] = -to.w;
  } else {
    afto1[0] = to.x;
    afto1[1] = to.y;
    afto1[2] = to.z;
    afto1[3] = to.w;
  }
  
  const float QUATERNION_DELTA_COS_MIN = 0.01f;

  if ( (1.0f - cosom) > QUATERNION_DELTA_COS_MIN ) {
    /* This is a standard case (slerp). */
    float omega = acosf(cosom);
    float sinom = sinf(omega);
    scale0 = sinf((1.0f - amount) * omega) / sinom;
    scale1 = sinf(amount * omega) / sinom;
  } else {
    /* "from" and "to" quaternions are very close */
    /*  so we can do a linear interpolation.      */
    scale0 = 1.0f - amount;
    scale1 = amount;
  }

  return quat_new(
    (scale0 * from.x) + (scale1 * afto1[0]),
    (scale0 * from.y) + (scale1 * afto1[1]),
    (scale0 * from.z) + (scale1 * afto1[2]),
    (scale0 * from.w) + (scale1 * afto1[3]));

}

float quat_dot(quat q1, quat q2) {
  return q1.x * q2.x + q1.y * q2.y + q1.z * q2.z + q1.w * q2.w;
}

quat quat_exp(vec3 w) {

  float theta = sqrt(vec3_dot(w, w));
  float len = theta < FLT_EPSILON ? 1 : sin(theta) / theta;
  vec3 v = vec3_mul(w, len);
  
  return quat_new(v.x, v.y, v.z, cos(theta));
}

vec3 quat_log(quat q) {
  
  float len = vec3_length(quat_imaginaries(q));
  float angle = atan2(len, q.w);
  
  len = len > FLT_EPSILON ? angle / len : 1;
  
  return vec3_mul(quat_imaginaries(q), len);
  
}

static quat quat_get_value(float t, vec3 axis) {
	return quat_exp( vec3_mul(axis, t / 2.0) );
}

quat quat_constrain(quat q, vec3 axis) {

  const quat orient = quat_new(0, 0, 0, 1);
	
	vec3 vs = quat_imaginaries(q);
	vec3 v0 = quat_imaginaries(orient);

	float a = q.w * orient.w + vec3_dot(vs, v0);
	float b = orient.w * vec3_dot(axis, vs) - q.w * vec3_dot(axis, v0) + vec3_dot(vs, vec3_mul_vec3(axis, v0));

	float alpha = atan2(a, b);

	float t1 = -2 * alpha + M_PI;
	float t2 = -2 * alpha - M_PI;
  
	if ( quat_dot(q, quat_get_value(t1, axis)) > 
       quat_dot(q, quat_get_value(t2, axis)) ) {
		return quat_get_value(t1, axis);
	}

	return quat_get_value(t2, axis);
}

quat quat_constrain_y(quat q) {
  return quat_constrain(q, vec3_new(0, 1, 0)); 
}

float quat_distance(quat q0, quat q1) {
  quat comb = quat_mul_quat(quat_inverse(q0), q1);
  return sin(vec3_length(quat_log(comb)));
}

quat quat_neg(quat q) {
  q.x = -q.x;
  q.y = -q.y;
  q.z = -q.z;
  q.w = -q.w;
  return q;
}

quat quat_scale(quat q, float f) {
  q.x = q.x * f;
  q.y = q.y * f;
  q.z = q.z * f;
  q.w = q.w * f;
  return q;
}

quat quat_interpolate(quat* qs, float* ws, int count) {
  
	quat ref = quat_id();
  quat ref_inv = quat_inverse(ref);
	
  vec3 acc = vec3_zero();

	for (int i = 0; i < count; i++ ) {
    
    vec3 qlog0 = quat_log(quat_mul_quat(ref_inv, qs[i]));
    vec3 qlog1 = quat_log(quat_mul_quat(ref_inv, quat_neg(qs[i])));
    
		if (vec3_length(qlog0) < vec3_length(qlog1) ) {
			acc = vec3_add(acc, vec3_mul(qlog0, ws[i]));
		} else {
			acc = vec3_add(acc, vec3_mul(qlog1, ws[i]));
    }
  }
  
  quat res = quat_mul_quat(ref, quat_exp(acc));
  
	return quat_normalize(res);
  
}

quat_dual quat_dual_new(quat real, quat dual) {
  quat_dual qd;
  qd.real = real;
  qd.dual = dual;
  return qd;
}

quat_dual quat_dual_id() {
  return quat_dual_new(quat_id(), vec4_zero());
}

quat_dual quat_dual_transform(quat q, vec3 t) {
  quat_dual qd;
  qd.real = q;
  qd.dual = quat_new(
     0.5 * ( t.x * q.w + t.y * q.z - t.z * q.y),
     0.5 * (-t.x * q.z + t.y * q.w + t.z * q.x),
     0.5 * ( t.x * q.y - t.y * q.x + t.z * q.w),
    -0.5 * ( t.x * q.x + t.y * q.y + t.z * q.z)
  );
  return qd;
}

quat_dual quat_dual_mul(quat_dual q0, quat_dual q1) {
  return quat_dual_new(
    quat_mul_quat(q0.real, q1.real), 
    vec4_add(
      quat_mul_quat(q0.real, q1.dual), 
      quat_mul_quat(q0.dual, q1.real)));
}

quat_dual quat_dual_normalize(quat_dual q) {
  float l = quat_length(q.real);
  quat real = vec4_mul(q.real, 1.0 / l);
  quat dual = vec4_mul(q.dual, 1.0 / l);
  return quat_dual_new(real, vec4_sub(dual, vec4_mul(real, quat_dot(real, dual))));
}

vec3 quat_dual_mul_vec3(quat_dual q, vec3 v) {
  
  vec3 rvc = vec3_cross(quat_imaginaries(q.real), v);
  vec3 real = vec3_cross(quat_imaginaries(q.real), vec3_add(rvc, vec3_mul(v, q.real.w)));

  vec3 rdc = vec3_cross(quat_imaginaries(q.real), quat_imaginaries(q.dual));  
  vec3 rimg = vec3_mul(quat_imaginaries(q.real), q.dual.w);
  vec3 dimg = vec3_mul(quat_imaginaries(q.dual), q.real.w);
  
  vec3 dual = vec3_sub(rimg, vec3_add(dimg, rdc));
  
  return vec3_add(v, vec3_add(vec3_mul(real, 2), vec3_mul(dual, 2)));
}

vec3 quat_dual_mul_vec3_rot(quat_dual q, vec3 v) {
  
  vec3 rvc = vec3_cross(quat_imaginaries(q.real), v);
  vec3 real = vec3_cross(quat_imaginaries(q.real), vec3_add(rvc, vec3_mul(v, q.real.w)));
  
  return vec3_add(v, vec3_mul(real, 2.0));
}

/* Matrix Functions */

mat2 mat2_id() {
  mat2 mat;
  mat.xx = 1.0f; mat.xy = 0.0f;
  mat.yx = 0.0f; mat.yy = 1.0f;
  return mat;
}

mat2 mat2_zero() {
  mat2 mat;
  mat.xx = 0.0f; mat.xy = 0.0f;
  mat.yx = 0.0f; mat.yy = 0.0f;
  return mat;
}

mat2 mat2_new(float xx, float xy, float yx, float yy) {
  mat2 mat;
  mat.xx = xx;
  mat.xy = xy;
  mat.yx = yx;
  mat.yy = yy;
  return mat;
}

mat2 mat2_mul_mat2(mat2 m1, mat2 m2) {
  mat2 mat;
  
  mat.xx = m1.xx * m2.xx + m1.xy * m2.yx;
  mat.xy = m1.xx * m2.xy + m1.xy * m2.yy;
  mat.yx = m1.yx * m2.xx + m1.yy * m2.yx;
  mat.yy = m1.yx * m2.xy + m1.yy * m2.yy;
  
  return mat;
}

vec2 mat2_mul_vec2(mat2 m, vec2 v) {
  vec2 vec;
  
  vec.x = v.x * m.xx + v.y * m.xy;
  vec.y = v.x * m.yx + v.y * m.yy;
  
  return vec;
}

mat2 mat2_transpose(mat2 m) {
  mat2 ret;
  ret.xx = m.xx;
  ret.xy = m.yx;
  ret.yx = m.xy;
  ret.yy = m.yy;
  return ret;
}

float mat2_det(mat2 m) {
  return m.xx * m.yy - m.xy * m.yx;
}

mat2 mat2_inverse(mat2 m) {

  float det = mat2_det(m);
  float fac = 1.0 / det;
  
  mat2 ret;
  
  ret.xx = fac * m.yy;
  ret.xy = fac * -m.xy;
  ret.yx = fac * -m.yx;
  ret.yy = fac * m.xx;
  
  return ret;
}

void mat2_to_array(mat2 m, float* out) {
  
  out[0] = m.xx;
  out[1] = m.xy;
  out[2] = m.yx;
  out[3] = m.yy;
  
}

void mat2_print(mat2 m) {
  printf("|%4.2f, %4.2f|\n", m.xx, m.xy);
  printf("|%4.2f, %4.2f|\n", m.yx, m.yy);
}

mat2 mat2_rotation(float a) {
  mat2 m;
  
  m.xx = cos(a);
  m.xy = -sin(a);
  m.yx = sin(a);
  m.yy = cos(a);
  
  return m;
}

/* Matrix 3x3 */

mat3 mat3_zero() {
  mat3 mat;
  
  mat.xx = 0.0f;
  mat.xy = 0.0f;
  mat.xz = 0.0f;
  
  mat.yx = 0.0f;
  mat.yy = 0.0f;
  mat.yz = 0.0f;
  
  mat.zx = 0.0f;
  mat.zy = 0.0f;
  mat.zz = 0.0f;
  
  return mat;
}

mat3 mat3_id() {
  mat3 mat;
  
  mat.xx = 1.0f;
  mat.xy = 0.0f;
  mat.xz = 0.0f;
  
  mat.yx = 0.0f;
  mat.yy = 1.0f;
  mat.yz = 0.0f;
  
  mat.zx = 0.0f;
  mat.zy = 0.0f;
  mat.zz = 1.0f;
  
  return mat;
}

mat3 mat3_new(float xx, float xy, float xz,
              float yx, float yy, float yz,
              float zx, float zy, float zz) {
  mat3 mat;
  
  mat.xx = xx;
  mat.xy = xy;
  mat.xz = xz;
  
  mat.yx = yx;
  mat.yy = yy;
  mat.yz = yz;
  
  mat.zx = zx;
  mat.zy = zy;
  mat.zz = zz;
  
  return mat;
}

mat3 mat3_mul_mat3(mat3 m1, mat3 m2) {
  mat3 mat;

  mat.xx = (m1.xx * m2.xx) + (m1.xy * m2.yx) + (m1.xz * m2.zx);
  mat.xy = (m1.xx * m2.xy) + (m1.xy * m2.yy) + (m1.xz * m2.zy);
  mat.xz = (m1.xx * m2.xz) + (m1.xy * m2.yz) + (m1.xz * m2.zz);

  mat.yx = (m1.yx * m2.xx) + (m1.yy * m2.yx) + (m1.yz * m2.zx);
  mat.yy = (m1.yx * m2.xy) + (m1.yy * m2.yy) + (m1.yz * m2.zy);
  mat.yz = (m1.yx * m2.xz) + (m1.yy * m2.yz) + (m1.yz * m2.zz);

  mat.zx = (m1.zx * m2.xx) + (m1.zy * m2.yx) + (m1.zz * m2.zx);
  mat.zy = (m1.zx * m2.xy) + (m1.zy * m2.yy) + (m1.zz * m2.zy);
  mat.zz = (m1.zx * m2.xz) + (m1.zy * m2.yz) + (m1.zz * m2.zz);
  
  return mat;
  
}

vec3 mat3_mul_vec3(mat3 m, vec3 v) {

  vec3 vec;
  
  vec.x = (m.xx * v.x) + (m.xy * v.y) + (m.xz * v.z);
  vec.y = (m.yx * v.x) + (m.yy * v.y) + (m.yz * v.z);
  vec.z = (m.zx * v.x) + (m.zy * v.y) + (m.zz * v.z);
  
  return vec;

}

mat3 mat3_transpose(mat3 m) {
  mat3 ret;
  ret.xx = m.xx;
  ret.xy = m.yx;
  ret.xz = m.zx;
  
  ret.yx = m.xy;
  ret.yy = m.yy;
  ret.yz = m.zy;
  
  ret.zx = m.xz;
  ret.zy = m.yz;
  ret.zz = m.zz;
  return ret;
}

float mat3_det(mat3 m) {
  return (m.xx * m.yy * m.zz) + (m.xy * m.yz * m.zx) + (m.xz * m.yx * m.zy) -
         (m.xz * m.yy * m.zx) - (m.xy * m.yx * m.zz) - (m.xx * m.yz * m.zy);
}

mat3 mat3_inverse(mat3 m) {

  float det = mat3_det(m);
  float fac = 1.0 / det;
  
  mat3 ret;
  ret.xx = fac * mat2_det(mat2_new(m.yy, m.yz, m.zy, m.zz));
  ret.xy = fac * mat2_det(mat2_new(m.xz, m.xy, m.zz, m.zy));
  ret.xz = fac * mat2_det(mat2_new(m.xy, m.xz, m.yy, m.yz));
  
  ret.yx = fac * mat2_det(mat2_new(m.yz, m.yx, m.zz, m.zx));
  ret.yy = fac * mat2_det(mat2_new(m.xx, m.xz, m.zx, m.zz));
  ret.yz = fac * mat2_det(mat2_new(m.xz, m.xx, m.yz, m.yx));
  
  ret.zx = fac * mat2_det(mat2_new(m.yx, m.yy, m.zx, m.zy));
  ret.zy = fac * mat2_det(mat2_new(m.xy, m.xx, m.zy, m.zx));
  ret.zz = fac * mat2_det(mat2_new(m.xx, m.xy, m.yx, m.yy));
  
  return ret;
  
}

void mat3_to_array(mat3 m, float* out) {

  out[0] = m.xx;
  out[1] = m.yx;
  out[2] = m.zx;
  
  out[3] = m.xy;
  out[4] = m.yy;
  out[5] = m.zy;
  
  out[6] = m.xz;
  out[7] = m.yz;
  out[8] = m.zz;
  
}

void mat3_print(mat3 m) {
  printf("|%4.2f, %4.2f, %4.2f|\n", m.xx, m.xy, m.xz);
  printf("|%4.2f, %4.2f, %4.2f|\n", m.yx, m.yy, m.yz);
  printf("|%4.2f, %4.2f, %4.2f|\n", m.zx, m.zy, m.zz);
}

mat3 mat3_rotation_x(float a) {

  mat3 m = mat3_id();
  
  m.yy = cos(a);
  m.yz = -sin(a);
  m.zy = sin(a);
  m.zz = cos(a);
  
  return m;
  
}

mat3 mat3_scale(vec3 s) {
  
  mat3 m = mat3_id();
  m.xx = s.x;
  m.yy = s.y;
  m.zz = s.z;  
  return m;

}

mat3 mat3_rotation_y(float a) {

  mat3 m = mat3_id();
  
  m.xx = cos(a);
  m.xz = sin(a);
  m.zx = -sin(a);
  m.zz = cos(a);

  return m;
  
}

mat3 mat3_rotation_z(float a) {

  mat3 m = mat3_id();
  
  m.xx = cos(a);
  m.xy = -sin(a);
  m.yx = sin(a);
  m.yy = cos(a);

  return m;
  
}

mat3 mat3_rotation_angle_axis(float a, vec3 v) {
  
  mat3 m;

  float c = cos(a);
  float s = sin(a);
  float nc = 1 - c;
  
  m.xx = v.x * v.x * nc + c;
  m.xy = v.x * v.y * nc - v.z * s;
  m.xz = v.x * v.z * nc + v.y * s;
  
  m.yx = v.y * v.x * nc + v.z * s;
  m.yy = v.y * v.y * nc + c;
  m.yz = v.y * v.z * nc - v.x * s;
  
  m.zx = v.z * v.x * nc - v.y * s;
  m.zy = v.z * v.y * nc + v.x * s;
  m.zz = v.z * v.z * nc + c;
  
  return m;
}

/* Matrix 4x4 */

mat4 mat4_zero() {
  mat4 mat;
  
  mat.xx = 0.0f;
  mat.xy = 0.0f;
  mat.xz = 0.0f;
  mat.xw = 0.0f;
  
  mat.yx = 0.0f;
  mat.yy = 0.0f;
  mat.yz = 0.0f;
  mat.yw = 0.0f;
  
  mat.zx = 0.0f;
  mat.zy = 0.0f;
  mat.zz = 0.0f;
  mat.zw = 0.0f;
  
  mat.wx = 0.0f;
  mat.wy = 0.0f;
  mat.wz = 0.0f;
  mat.ww = 0.0f;
  
  return mat;
}

mat4 mat4_id(){
  
  mat4 mat = mat4_zero();
  
  mat.xx = 1.0f;
  mat.yy = 1.0f;
  mat.zz = 1.0f;
  mat.ww = 1.0f;
  
  
  return mat;
}

float mat4_at(mat4 m, int x, int y) {
  float* arr = (float*)(&m);
  return arr[x + (y*4)];  
}

mat4 mat4_set(mat4 m, int x, int y, float v) {
  
  float* arr = (float*)(&m);
  arr[x + (y*4)] = v;
  
  return m;
}

mat4 mat4_new(float xx, float xy, float xz, float xw,
              float yx, float yy, float yz, float yw,
              float zx, float zy, float zz, float zw,
              float wx, float wy, float wz, float ww) {
         
  mat4 mat;
  
  mat.xx = xx;
  mat.xy = xy;
  mat.xz = xz;
  mat.xw = xw;
  
  mat.yx = yx;
  mat.yy = yy;
  mat.yz = yz;
  mat.yw = yw;
  
  mat.zx = zx;
  mat.zy = zy;
  mat.zz = zz;
  mat.zw = zw;
  
  mat.wx = wx;
  mat.wy = wy;
  mat.wz = wz;
  mat.ww = ww;
  
  return mat;
}

mat4 mat4_transpose(mat4 m) {
  mat4 mat;
  
  mat.xx = m.xx;
  mat.xy = m.yx;
  mat.xz = m.zx;
  mat.xw = m.wx;
  
  mat.yx = m.xy;
  mat.yy = m.yy;
  mat.yz = m.zy;
  mat.yw = m.wy;
  
  mat.zx = m.xz;
  mat.zy = m.yz;
  mat.zz = m.zz;
  mat.zw = m.wz;
  
  mat.wx = m.xw;
  mat.wy = m.yw;
  mat.wz = m.zw;
  mat.ww = m.ww;
  
  return mat;
}

mat4 mat3_to_mat4(mat3 m) {

  mat4 mat;
  
  mat.xx = m.xx;
  mat.xy = m.xy;
  mat.xz = m.xz;
  mat.xw = 0.0f;
  
  mat.yx = m.yx;
  mat.yy = m.yy;
  mat.yz = m.yz;
  mat.yw = 0.0f;
  
  mat.zx = m.zx;
  mat.zy = m.zy;
  mat.zz = m.zz;
  mat.zw = 0.0f;
  
  mat.wx = 0.0f;
  mat.wy = 0.0f;
  mat.wz = 0.0f;
  mat.ww = 1.0f;
  
  return mat;
}

mat4 mat4_mul_mat4(mat4 m1, mat4 m2) {

  mat4 mat;

  mat.xx = (m1.xx * m2.xx) + (m1.xy * m2.yx) + (m1.xz * m2.zx) + (m1.xw * m2.wx);
  mat.xy = (m1.xx * m2.xy) + (m1.xy * m2.yy) + (m1.xz * m2.zy) + (m1.xw * m2.wy);
  mat.xz = (m1.xx * m2.xz) + (m1.xy * m2.yz) + (m1.xz * m2.zz) + (m1.xw * m2.wz);
  mat.xw = (m1.xx * m2.xw) + (m1.xy * m2.yw) + (m1.xz * m2.zw) + (m1.xw * m2.ww);
  
  mat.yx = (m1.yx * m2.xx) + (m1.yy * m2.yx) + (m1.yz * m2.zx) + (m1.yw * m2.wx);
  mat.yy = (m1.yx * m2.xy) + (m1.yy * m2.yy) + (m1.yz * m2.zy) + (m1.yw * m2.wy);
  mat.yz = (m1.yx * m2.xz) + (m1.yy * m2.yz) + (m1.yz * m2.zz) + (m1.yw * m2.wz);
  mat.yw = (m1.yx * m2.xw) + (m1.yy * m2.yw) + (m1.yz * m2.zw) + (m1.yw * m2.ww);
 
  mat.zx = (m1.zx * m2.xx) + (m1.zy * m2.yx) + (m1.zz * m2.zx) + (m1.zw * m2.wx);
  mat.zy = (m1.zx * m2.xy) + (m1.zy * m2.yy) + (m1.zz * m2.zy) + (m1.zw * m2.wy);
  mat.zz = (m1.zx * m2.xz) + (m1.zy * m2.yz) + (m1.zz * m2.zz) + (m1.zw * m2.wz);
  mat.zw = (m1.zx * m2.xw) + (m1.zy * m2.yw) + (m1.zz * m2.zw) + (m1.zw * m2.ww);
  
  mat.wx = (m1.wx * m2.xx) + (m1.wy * m2.yx) + (m1.wz * m2.zx) + (m1.ww * m2.wx);
  mat.wy = (m1.wx * m2.xy) + (m1.wy * m2.yy) + (m1.wz * m2.zy) + (m1.ww * m2.wy);
  mat.wz = (m1.wx * m2.xz) + (m1.wy * m2.yz) + (m1.wz * m2.zz) + (m1.ww * m2.wz);
  mat.ww = (m1.wx * m2.xw) + (m1.wy * m2.yw) + (m1.wz * m2.zw) + (m1.ww * m2.ww);
  
  return mat;
  
}

vec4 mat4_mul_vec4(mat4 m, vec4 v) {
  
  vec4 vec;
  
  vec.x = (m.xx * v.x) + (m.xy * v.y) + (m.xz * v.z) + (m.xw * v.w);
  vec.y = (m.yx * v.x) + (m.yy * v.y) + (m.yz * v.z) + (m.yw * v.w);
  vec.z = (m.zx * v.x) + (m.zy * v.y) + (m.zz * v.z) + (m.zw * v.w);
  vec.w = (m.wx * v.x) + (m.wy * v.y) + (m.wz * v.z) + (m.ww * v.w);
  
  return vec;
}

vec3 mat4_mul_vec3(mat4 m, vec3 v) {
  
  vec4 v_homo = vec4_new(v.x, v.y, v.z, 1);
  v_homo = mat4_mul_vec4(m, v_homo);
  
  v_homo = vec4_div(v_homo, v_homo.w);
  
  return vec3_new(v_homo.x, v_homo.y, v_homo.z);
}

mat3 mat4_to_mat3(mat4 m) {

  mat3 mat;
  
  mat.xx = m.xx;
  mat.xy = m.xy;
  mat.xz = m.xz;
  
  mat.yx = m.yx;
  mat.yy = m.yy;
  mat.yz = m.yz;
  
  mat.zx = m.zx;
  mat.zy = m.zy;
  mat.zz = m.zz;
  
  return mat;
  
}

quat mat4_to_quat(mat4 m) {

  float tr = m.xx + m.yy + m.zz;

  if (tr > 0.0f) {
    
    float s = sqrtf( tr + 1.0f );
    
    float w = s / 2.0f;
    float x = ( mat4_at(m, 1, 2) - mat4_at(m, 2, 1) ) * (0.5f / s);
    float y = ( mat4_at(m, 2, 0) - mat4_at(m, 0, 2) ) * (0.5f / s);
    float z = ( mat4_at(m, 0, 1) - mat4_at(m, 1, 0) ) * (0.5f / s);
    return quat_new(x, y, z, w);
    
  } else {
    
    int nxt[3] = {1, 2, 0};
    float q[4];
    int  i, j, k;
    
    i = 0;
    if ( mat4_at(m, 1, 1) > mat4_at(m, 0, 0) ) {	i = 1;	}
    if ( mat4_at(m, 2, 2) > mat4_at(m, i, i) ) {	i = 2;	}
    j = nxt[i];
    k = nxt[j];

    float s = sqrtf( (mat4_at(m, i, i) - (mat4_at(m, j, j) + mat4_at(m, k, k))) + 1.0f );

    q[i] = s * 0.5f;

    if ( s != 0.0f )	{	s = 0.5f / s;	}

    q[3] = ( mat4_at(m, j, k) - mat4_at(m, k, j) ) * s;
    q[j] = ( mat4_at(m, i, j) + mat4_at(m, j, i) ) * s;
    q[k] = ( mat4_at(m, i, k) + mat4_at(m, k, i) ) * s;

    return quat_new(q[0], q[1], q[2], q[3]);
  }

}

quat_dual mat4_to_quat_dual(mat4 m) {
  quat rotation = mat4_to_quat(m);
  vec3 translation = mat4_mul_vec3(m, vec3_zero());
  return quat_dual_transform(rotation, translation);
}

float mat4_det(mat4 m) {
  
  float cofact_xx =  mat3_det(mat3_new(m.yy, m.yz, m.yw, m.zy, m.zz, m.zw, m.wy, m.wz, m.ww));
  float cofact_xy = -mat3_det(mat3_new(m.yx, m.yz, m.yw, m.zx, m.zz, m.zw, m.wx, m.wz, m.ww));
  float cofact_xz =  mat3_det(mat3_new(m.yx, m.yy, m.yw, m.zx, m.zy, m.zw, m.wx, m.wy, m.ww));
  float cofact_xw = -mat3_det(mat3_new(m.yx, m.yy, m.yz, m.zx, m.zy, m.zz, m.wx, m.wy, m.wz));
  
  return (cofact_xx * m.xx) + (cofact_xy * m.xy) + (cofact_xz * m.xz) + (cofact_xw * m.xw);
}

mat4 mat4_inverse(mat4 m) {
    
  float det = mat4_det(m);
  float fac = 1.0 / det;
  
  mat4 ret;
  ret.xx = fac *  mat3_det(mat3_new(m.yy, m.yz, m.yw, m.zy, m.zz, m.zw, m.wy, m.wz, m.ww));
  ret.xy = fac * -mat3_det(mat3_new(m.yx, m.yz, m.yw, m.zx, m.zz, m.zw, m.wx, m.wz, m.ww));
  ret.xz = fac *  mat3_det(mat3_new(m.yx, m.yy, m.yw, m.zx, m.zy, m.zw, m.wx, m.wy, m.ww));
  ret.xw = fac * -mat3_det(mat3_new(m.yx, m.yy, m.yz, m.zx, m.zy, m.zz, m.wx, m.wy, m.wz));
  
  ret.yx = fac * -mat3_det(mat3_new(m.xy, m.xz, m.xw, m.zy, m.zz, m.zw, m.wy, m.wz, m.ww));
  ret.yy = fac *  mat3_det(mat3_new(m.xx, m.xz, m.xw, m.zx, m.zz, m.zw, m.wx, m.wz, m.ww));
  ret.yz = fac * -mat3_det(mat3_new(m.xx, m.xy, m.xw, m.zx, m.zy, m.zw, m.wx, m.wy, m.ww));
  ret.yw = fac *  mat3_det(mat3_new(m.xx, m.xy, m.xz, m.zx, m.zy, m.zz, m.wx, m.wy, m.wz));
  
  ret.zx = fac *  mat3_det(mat3_new(m.xy, m.xz, m.xw, m.yy, m.yz, m.yw, m.wy, m.wz, m.ww));
  ret.zy = fac * -mat3_det(mat3_new(m.xx, m.xz, m.xw, m.yx, m.yz, m.yw, m.wx, m.wz, m.ww));
  ret.zz = fac *  mat3_det(mat3_new(m.xx, m.xy, m.xw, m.yx, m.yy, m.yw, m.wx, m.wy, m.ww));
  ret.zw = fac * -mat3_det(mat3_new(m.xx, m.xy, m.xz, m.yx, m.yy, m.yz, m.wx, m.wy, m.wz));
  
  ret.wx = fac * -mat3_det(mat3_new(m.xy, m.xz, m.xw, m.yy, m.yz, m.yw, m.zy, m.zz, m.zw));
  ret.wy = fac *  mat3_det(mat3_new(m.xx, m.xz, m.xw, m.yx, m.yz, m.yw, m.zx, m.zz, m.zw));
  ret.wz = fac * -mat3_det(mat3_new(m.xx, m.xy, m.xw, m.yx, m.yy, m.yw, m.zx, m.zy, m.zw));
  ret.ww = fac *  mat3_det(mat3_new(m.xx, m.xy, m.xz, m.yx, m.yy, m.yz, m.zx, m.zy, m.zz));
  
  ret = mat4_transpose(ret);
  
  return ret;
}

void mat4_to_array(mat4 m, float* out) {
  
  out[0] = m.xx;
  out[1] = m.yx;
  out[2] = m.zx;
  out[3] = m.wx;

  out[4] = m.xy;
  out[5] = m.yy;
  out[6] = m.zy;
  out[7] = m.wy;
  
  out[8] = m.xz;
  out[9] = m.yz;
  out[10] = m.zz;
  out[11] = m.wz;
  
  out[12] = m.xw;
  out[13] = m.yw;
  out[14] = m.zw;
  out[15] = m.ww;
  
}

void mat4_to_array_trans(mat4 m, float* out) {
  
  out[0] = m.xx;
  out[1] = m.xy;
  out[2] = m.xz;
  out[3] = m.xw;

  out[4] = m.yx;
  out[5] = m.yy;
  out[6] = m.yz;
  out[7] = m.yw;
  
  out[8] = m.zx;
  out[9] = m.zy;
  out[10] = m.zz;
  out[11] = m.zw;
  
  out[12] = m.wx;
  out[13] = m.wy;
  out[14] = m.wz;
  out[15] = m.ww;
  
}

void mat4_print(mat4 m) {

  printf("|%4.2f, %4.2f, %4.2f, %4.2f|\n", m.xx, m.xy, m.xz, m.xw);
  printf("|%4.2f, %4.2f, %4.2f, %4.2f|\n", m.yx, m.yy, m.yz, m.yw);
  printf("|%4.2f, %4.2f, %4.2f, %4.2f|\n", m.zx, m.zy, m.zz, m.zw);
  printf("|%4.2f, %4.2f, %4.2f, %4.2f|\n", m.wx, m.wy, m.wz, m.ww);
  
}

mat4 mat4_view_look_at(vec3 position, vec3 target, vec3 up) {
  
  vec3 zaxis = vec3_normalize( vec3_sub(target, position) );
  vec3 xaxis = vec3_normalize( vec3_cross(up, zaxis) );
  vec3 yaxis = vec3_cross(zaxis, xaxis);

  mat4 view_matrix = mat4_id();
  view_matrix.xx = xaxis.x;
  view_matrix.xy = xaxis.y;
  view_matrix.xz = xaxis.z;
  
  view_matrix.yx = yaxis.x;
  view_matrix.yy = yaxis.y;
  view_matrix.yz = yaxis.z;
  
  view_matrix.zx = -zaxis.x;
  view_matrix.zy = -zaxis.y;
  view_matrix.zz = -zaxis.z;
  
  view_matrix = mat4_mul_mat4(view_matrix, mat4_translation(vec3_neg(position)) );
  
  return view_matrix;
}

mat4 mat4_perspective(float fov, float near_clip, float far_clip, float ratio) {
  
  float right, left, bottom, top;
  
  right = -(near_clip * tanf(fov));
  left = -right;
  
  top = ratio * near_clip * tanf(fov);
  bottom = -top;
  
  mat4 proj_matrix = mat4_zero();
  proj_matrix.xx = (2.0 * near_clip) / (right - left);
  proj_matrix.yy = (2.0 * near_clip) / (top - bottom);
  proj_matrix.xz = (right + left) / (right - left);
  proj_matrix.yz = (top + bottom) / (top - bottom);
  proj_matrix.zz = (-far_clip - near_clip) / (far_clip - near_clip);
  proj_matrix.wz = -1.0;
  proj_matrix.zw = ( -(2.0 * near_clip) * far_clip) / (far_clip - near_clip);
  
  return proj_matrix;
}

mat4 mat4_orthographic(float left, float right, float bottom, float top, float clip_near, float clip_far) {

  mat4 m = mat4_id();
  
  m.xx = 2 / (right - left);
  m.yy = 2 / (top - bottom);
  m.zz = 1 / (clip_near - clip_far);
  
  m.xw = -1 - 2 * left / (right - left);
  m.yw =  1 + 2 * top  / (bottom - top);
  m.zw = clip_near / (clip_near - clip_far);
  
  return m;

}

mat4 mat4_translation(vec3 v) {

  mat4 m = mat4_id();
  m.xw = v.x;
  m.yw = v.y;
  m.zw = v.z;

  return m;
  
}

mat4 mat4_scale(vec3 v) {

  mat4 m = mat4_id();
  m.xx = v.x;
  m.yy = v.y;
  m.zz = v.z;

  return m;
}

mat4 mat4_rotation_x(float a) {

  mat4 m = mat4_id();
  
  m.yy = cos(a);
  m.yz = -sin(a);
  m.zy = sin(a);
  m.zz = cos(a);
  
  return m;
  
}

mat4 mat4_rotation_y(float a) {

  mat4 m = mat4_id();
  
  m.xx = cos(a);
  m.xz = sin(a);
  m.zx = -sin(a);
  m.zz = cos(a);

  return m;
  
}

mat4 mat4_rotation_z(float a) {

  mat4 m = mat4_id();
  
  m.xx = cos(a);
  m.xy = -sin(a);
  m.yx = sin(a);
  m.yy = cos(a);

  return m;
  
}

mat4 mat4_rotation_axis_angle(vec3 v, float angle) {

  mat4 m = mat4_id();

  float c = cos(angle);
  float s = sin(angle);
  float nc = 1 - c;
  
  m.xx = v.x * v.x * nc + c;
  m.xy = v.x * v.y * nc - v.z * s;
  m.xz = v.x * v.z * nc + v.y * s;
  
  m.yx = v.y * v.x * nc + v.z * s;
  m.yy = v.y * v.y * nc + c;
  m.yz = v.y * v.z * nc - v.x * s;
  
  m.zx = v.z * v.x * nc - v.y * s;
  m.zy = v.z * v.y * nc + v.x * s;
  m.zz = v.z * v.z * nc + c;
  
  return m;

}

mat4 mat4_rotation_euler(float x, float y, float z) {

  mat4 m = mat4_zero();

  float cosx = cos(x);
  float cosy = cos(y);
  float cosz = cos(z);
  float sinx = sin(x);
  float siny = sin(y);
  float sinz = sin(z);

  m.xx = cosy * cosz;
  m.yx = -cosx * sinz + sinx * siny * cosz;
  m.zx = sinx * sinz + cosx * siny * cosz;

  m.xy = cosy * sinz;
  m.yy = cosx * cosz + sinx * siny * sinz;
  m.zy = -sinx * cosz + cosx * siny * sinz;

  m.xz = -siny;
  m.yz = sinx * cosy;
  m.zz = cosx * cosy;

  m.ww = 1;
  
  return m;
}

mat4 mat4_rotation_quat(vec4 q) {

  float x2 = q.x + q.x; 
  float y2 = q.y + q.y; 
  float z2 = q.z + q.z;
  float xx = q.x * x2;  
  float yy = q.y * y2;  
  float wx = q.w * x2;  
  float xy = q.x * y2;   
  float yz = q.y * z2;   
  float wy = q.w * y2;
  float xz = q.x * z2;
  float zz = q.z * z2;  
  float wz = q.w * z2;  
  
  return mat4_new(
    1.0f - ( yy + zz ),	xy - wz, xz + wy,	0.0f,
    xy + wz, 1.0f - ( xx + zz ), yz - wx, 0.0f,
    xz - wy, yz + wx, 1.0f - ( xx + yy ), 0.0f,
    0.0f,	0.0f, 0.0f,	1.0f);
    
}

mat4 mat4_rotation_quat_dual(quat_dual q) {
  
  float rx = q.real.x, ry = q.real.y, rz = q.real.z, rw = q.real.w;
  float tx = q.dual.x, ty = q.dual.y, tz = q.dual.z, tw = q.dual.w;

  mat4 m = mat4_id();
  m.xx = rw*rw + rx*rx - ry*ry - rz*rz;              
  m.xy = 2.f*(rx*ry - rw*rz);                        
  m.xz = 2*(rx*rz + rw*ry);
  m.yx = 2*(rx*ry + rw*rz);                                  
  m.yy = rw*rw - rx*rx + ry*ry - rz*rz;      
  m.yz = 2*(ry*rz - rw*rx);
  m.zx = 2*(rx*rz - rw*ry);                                  
  m.zy = 2*(ry*rz + rw*rx);                          
  m.zz = rw*rw - rx*rx - ry*ry + rz*rz;

  m.xw = -2*tw*rx + 2*rw*tx - 2*ty*rz + 2*ry*tz;
  m.yw = -2*tw*ry + 2*tx*rz - 2*rx*tz + 2*rw*ty;
  m.zw = -2*tw*rz + 2*rx*ty + 2*rw*tz - 2*tx*ry;

  return m;
}

mat4 mat4_world(vec3 position, vec3 scale, quat rotation) {
  
  mat4 pos_m, sca_m, rot_m, result;
  
  pos_m = mat4_translation(position);
  rot_m = mat4_rotation_quat(rotation);
  sca_m = mat4_scale(scale);
  
  result = mat4_id();
  result = mat4_mul_mat4( result, pos_m );
  result = mat4_mul_mat4( result, rot_m );
  result = mat4_mul_mat4( result, sca_m );
  
  return result;
  
}

mat4 mat4_lerp(mat4 m1, mat4 m2, float amount) {
  mat4 m;
  
  m.xx = lerp(m1.xx, m2.xx, amount);
  m.xy = lerp(m1.xy, m2.xy, amount);
  m.xz = lerp(m1.xz, m2.xz, amount);
  m.xw = lerp(m1.xw, m2.xw, amount);
  
  m.yx = lerp(m1.yx, m2.yx, amount);
  m.yy = lerp(m1.yy, m2.yy, amount);
  m.yz = lerp(m1.yz, m2.yz, amount);
  m.yw = lerp(m1.yw, m2.yw, amount);
  
  m.zx = lerp(m1.zx, m2.zx, amount);
  m.zy = lerp(m1.zy, m2.zy, amount);
  m.zz = lerp(m1.zz, m2.zz, amount);
  m.zw = lerp(m1.zw, m2.zw, amount);
  
  m.wx = lerp(m1.wx, m2.wx, amount);
  m.wy = lerp(m1.wy, m2.wy, amount);
  m.wz = lerp(m1.wz, m2.wz, amount);
  m.ww = lerp(m1.ww, m2.ww, amount);
  
  return m;
}

mat4 mat4_smoothstep(mat4 m1, mat4 m2, float amount) {
  mat4 m;
  
  m.xx = smoothstep(m1.xx, m2.xx, amount);
  m.xy = smoothstep(m1.xy, m2.xy, amount);
  m.xz = smoothstep(m1.xz, m2.xz, amount);
  m.xw = smoothstep(m1.xw, m2.xw, amount);
  
  m.yx = smoothstep(m1.yx, m2.yx, amount);
  m.yy = smoothstep(m1.yy, m2.yy, amount);
  m.yz = smoothstep(m1.yz, m2.yz, amount);
  m.yw = smoothstep(m1.yw, m2.yw, amount);
  
  m.zx = smoothstep(m1.zx, m2.zx, amount);
  m.zy = smoothstep(m1.zy, m2.zy, amount);
  m.zz = smoothstep(m1.zz, m2.zz, amount);
  m.zw = smoothstep(m1.zw, m2.zw, amount);
  
  m.wx = smoothstep(m1.wx, m2.wx, amount);
  m.wy = smoothstep(m1.wy, m2.wy, amount);
  m.wz = smoothstep(m1.wz, m2.wz, amount);
  m.ww = smoothstep(m1.ww, m2.ww, amount);
  
  return m;
}

