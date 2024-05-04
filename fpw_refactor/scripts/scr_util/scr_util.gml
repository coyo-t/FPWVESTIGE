#macro BASEPATH            "./bin/"
//#macro Testing:BASEPATH    "./bin_dbg/"
//#macro SCREENSHOT_SAVE_LOC "C:/Users/Chymic/Pictures/gmDebugImg/"
#macro SCREENSHOT_SAVE_LOC @"D:\_images\gmDebugImg\fpw_2_2\"


function lerp_dt (value1, value2, fac) 
{
	return lerp(value1, value2, 1. - power(fac, DT));
}


function point_in_bbox (_x, _y)
{
	return point_in_rectangle(_x, _y, bbox_left, bbox_top, bbox_right, bbox_bottom);
}

///@arg fov_degrees
///@arg width
///@arg height
function fov_v2h (fov, width, height)
{
	return radtodeg(2. * arctan(tan(degtorad(fov) * .5) * (width / height)));
}


///@arg fov_degrees
///@arg width
///@arg height
function fov_h2v (fov, width, height)
{
	return fov_v2h(fov, height, width);
}

// basically just stolen from this
// https://github.com/milojs/base32-js/blob/master/lib/base32.js
global.__BASE32_LOOKUPTABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";

///@arg buffer
///@arg offset
///@arg length
function buffer_base32_encode (f, ofs, sz)
{
	var tbl = global.__BASE32_LOOKUPTABLE;
	
	if (!buffer_exists(f))
	{
		return "";
	}
	
	if (buffer_get_type(f) != buffer_wrap)
	{
		sz = min(sz, buffer_get_size(f));
	}
	
	var bits = 0;
	var skip = 0;
	var s = "";
	
	for (var i = 0; i < sz;)
	{
		var byte = buffer_peek(f, i + ofs, buffer_u8);
		
		if (skip < 0)
		{
			bits |= (byte >> (-skip));
		}
		else
		{
			bits = (byte << skip) & 248;
		}
	
		if (skip > 3)
		{
			skip -= 8;
			i++;
			continue;
		}
		
		if (skip < 4)
		{
			s += string_char_at(tbl, (bits >> 3) + 1);
			skip += 5;
		}
		
	}
	
	if (skip < 0)
	{
		s += string_char_at(tbl, (bits >> 3) + 1);
	}
	
	return s;
}

///@arg base32_string
function buffer_base32_decode (s)
{
	s = string_upper(s);
	var f = buffer_create(32, buffer_grow, 1);
	var byte = 0;
	var skip = 0;
	
	var tbl = (function (ts) {
		var outm = ds_map_create();
		for (var i = 0; i < string_length(ts); i++)
		{
			outm[? string_char_at(ts, i+1)] = i;
		}
		return outm;
	})(global.__BASE32_LOOKUPTABLE);
	
	var len = string_length(s);
	for (var i = 0; i < len; i++)
	{
		var ch = string_char_at(s, i+1);
		if (!ds_map_exists(tbl, ch))
		{
			continue;
		}
		
		ch = tbl[?ch] << 3;
		byte |= ch >> skip;
		skip += 5;
		
		if (skip >= 8)
		{
			buffer_write(f, buffer_u8, byte);
			skip -= 8;
			
			if (skip > 0)
			{
				byte = (ch << (5 - skip)) & $FF;
				continue;
			}
			
			byte = 0;
		}
	}
	
	ds_map_destroy(tbl);
	
	buffer_resize(f, buffer_tell(f));
	
	return f;
}
