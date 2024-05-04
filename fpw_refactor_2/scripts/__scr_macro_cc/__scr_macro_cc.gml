_G.__MS_PERCENT = 1/1000000;

#macro             sdm show_debug_message
#macro           tostr string
#macro         degrees radtodeg
#macro         radians degtorad
//#macro identity_matrix matrix_build_identity()
#macro            DSKT @"C:\Users\Chymic\Desktop\"
#macro              _G global
#macro             nil undefined
#macro          is_nil is_undefined
#macro              DT (delta_time * _G.__MS_PERCENT)
#macro            TIME (get_timer() * _G.__MS_PERCENT)
#macro         appsurf application_surface
#macro       appsurf_w surface_get_width(appsurf)
#macro       appsurf_h surface_get_height(appsurf)
#macro       appsurf_r (appsurf_w / appsurf_h)
#macro     matrix_proj matrix_projection

globalvar SQRT2;
SQRT2 = 1/sqrt(2);

globalvar EPSL;
EPSL = math_get_epsilon();

#region buffer macros
#macro      sizeof buffer_sizeof
#macro buffer_size buffer_get_size

#macro       u8 buffer_u8     // byte
#macro       s8 buffer_s8     // char
#macro      u16 buffer_u16    // ushort
#macro      s16 buffer_s16    // short
#macro      u32 buffer_u32    // uint
#macro      s32 buffer_s32    // int
#macro      u64 buffer_u64    // long  (gamemaker has no signed 64 bit read.)
#macro      s64 buffer_u64    // ulong (i think u64 counts as s64, needs testing.)
#macro      f16 buffer_f16    // half
#macro      f32 buffer_f32    // single / float
#macro      f64 buffer_f64    // double
#macro string_t buffer_string // null terminated unicode string
#macro   text_t buffer_text   // interprets all bytes from the seek position to the end as a string
#macro   bool_t buffer_bool   // one byte, 0 is FALSE, non-zero is TRUE
                              // todo: put in feature request for buffer_read_byte_flag(buffer, mask);

#macro   u8_size 1//sizeof(u8)
#macro   s8_size 1//sizeof(s8)
#macro  u16_size 2//sizeof(u16)
#macro  s16_size 2//sizeof(s16)
#macro  u32_size 4//sizeof(u32)
#macro  s32_size 4//sizeof(s32)
#macro  u64_size 8//sizeof(u64)
#macro  s64_size 8//sizeof(u64)
#macro  f16_size 2//sizeof(f16)
#macro  f32_size 4//sizeof(f32)
#macro  f64_size 8//sizeof(f64)
#macro bool_size 1//sizeof(bool_t)

#macro      seek_set buffer_seek_start
#macro      seek_end buffer_seek_end
#macro seek_relative buffer_seek_relative
#macro   seek_offset seek_relative

#region buffer min/max values.
// fyi: gamemaker doesnt have a constant for a
// "buffer_s64", however in my testing
// u64 *is* s64, and there is no u64.
// because uh.. reasons.
#macro  buffer_s8_min -128
#macro  buffer_s8_max  127
	
#macro buffer_s16_min -32768
#macro buffer_s16_max  32767

#macro buffer_s32_min -2147483648
#macro buffer_s32_max  2147483647

#macro buffer_s64_min -9223372036854775808
#macro buffer_s64_max  922337203685477580


#macro  buffer_u8_min 0
#macro  buffer_u8_max 255

#macro buffer_u16_min 0
#macro buffer_u16_max 65535

#macro buffer_u32_min 0
#macro buffer_u32_max 4294967295

#macro buffer_u64_min 0
#macro buffer_u64_max 18446744073709551615
#endregion


#endregion
