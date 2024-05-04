enum VFormat
{
	colour,
	position_2d,
	position_3d,
	texcoord,
	normal,
	custom
}

_G.vertex_formats = ds_map_create();

//todo: make a vertex format struct, so things like the original order
// and data can be kept track of.
///@arg codes_or_array
function vertex_format_create(args)
{
	#region jump table
	static jt = (function ()
	{
		var _jt = [];
		_jt[VFormat.colour]      = vertex_format_add_colour;
		_jt[VFormat.position_2d] = vertex_format_add_position;
		_jt[VFormat.position_3d] = vertex_format_add_position_3d;
		_jt[VFormat.texcoord]    = vertex_format_add_texcoord;
		return _jt;
	})()
	#endregion
	
	//first check to see if we're given an array, or if we should just use the arguments themselves
	var arr;
	var arr_size;
	
	if (!is_array(args))
	{
		arr = [];
		var i = 0;
		repeat (argument_count)
			array_push(arr, argument[i++]);

		arr_size = argument_count;
	}
	else
	{
		arr = args;
		arr_size = array_length(args);
	}
	
	// check to see if this vertex format has already been created
	// if it does, just return it
	var s_ver = "";

	for (var i = 0; i < arr_size;)
	{
		var ff = arr[i++];
		s_ver += tostr(ff) + " ";
		
		if (ff == VFormat.custom)
		{
			s_ver += "t"+tostr(arr[i++]) + " ";
			s_ver += "u"+tostr(arr[i++]) + " ";
		}
		
	}
	
	if (ds_map_exists(_G.vertex_formats, s_ver))
		return _G.vertex_formats[? s_ver];
	
	// otherwise, begin constructing the vertex format
	vertex_format_begin();
	
	for (var i = 0; i < arr_size;)
	{
		var code = arr[i++];
		
		if (code == VFormat.custom)
		{
			var type  = arr[i++];
			var usage = arr[i++];
			vertex_format_add_custom(type, usage);
		}
		else
			jt[code]();
		
	}
	
	var f = vertex_format_end();
	_G.vertex_formats[? s_ver] = f;
	
	return f;
	
}

_G.vform_shadeless    = vertex_format_create(VFormat.position_3d, VFormat.texcoord, VFormat.colour);
_G.vform_shadeless_2d = vertex_format_create(VFormat.position_2d, VFormat.texcoord, VFormat.colour);
_G.vform_only_colour  = vertex_format_create(VFormat.position_3d, VFormat.colour);


function draw_line_3d (vb, x0, y0, z0, x1, y1, z1, _c)
{
	_c = (_c & $FF00FF00) | ((_c & $00FF0000) >> 16) | ((_c & $000000FF) << 16);
	vertex_position_3d(vb, x0, y0, z0);
	vertex_argb(vb, _c);
	vertex_position_3d(vb, x1, y1, z1);
	vertex_argb(vb, _c);
}

function add_point_3d_uv (vb, _x, _y, _z, _u, _v, _c)
{
	_c = (_c & $FF00FF00) | ((_c & $00FF0000) >> 16) | ((_c & $000000FF) << 16);
	vertex_position_3d(vb, _x, _y, _z);
	vertex_texcoord(vb, _u, _v);
	vertex_argb(vb, _c);
}

function draw_cube_outline (vb, x0, y0, z0, x1, y1, z1, _c)
{
	draw_line_3d(vb, x0,y0,z0, x1,y0,z0, _c); // 000 100
	draw_line_3d(vb, x0,y0,z0, x0,y1,z0, _c); // 000 010
	draw_line_3d(vb, x0,y1,z0, x1,y1,z0, _c); // 010 110
	draw_line_3d(vb, x1,y0,z0, x1,y1,z0, _c); // 100 110
	
	draw_line_3d(vb, x0,y0,z1, x1,y0,z1, _c); // 001 101
	draw_line_3d(vb, x0,y0,z1, x0,y1,z1, _c); // 001 011
	draw_line_3d(vb, x0,y1,z1, x1,y1,z1, _c); // 011 111
	draw_line_3d(vb, x1,y0,z1, x1,y1,z1, _c); // 101 111
	
	draw_line_3d(vb, x0,y0,z0, x0,y0,z1, _c); // 000 001
	draw_line_3d(vb, x0,y1,z0, x0,y1,z1, _c); // 010 011
	draw_line_3d(vb, x1,y0,z0, x1,y0,z1, _c); // 100 101
	draw_line_3d(vb, x1,y1,z0, x1,y1,z1, _c); // 110 111
}

