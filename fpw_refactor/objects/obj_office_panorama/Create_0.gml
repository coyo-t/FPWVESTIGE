// how is the model data ordered
vertex_format_begin();
vertex_format_add_position();
vertex_format_add_texcoord();
vertex_format_add_colour();
format = vertex_format_end();


// load the model, using an intermediary buffer, as
// vertex buffers cant be directly created from files
var mb = buffer_load(BASEPATH+"models/pano_flat_nrm_2d.vbm");
model = vertex_create_buffer_from_buffer(mb, format);
buffer_delete(mb);


// we need a middle-man surface to get and distort the screen
// this is because gamemaker doesnt let a surface draw itself
// to itself. it used to, but recently it stopped letting you.
// this includes the application surface (which is the screen).

surf = -1;
sw = view_get_wport(0);
sh = view_get_hport(0);

// this buffer will be used to rapidly move the image data from the screen
// to the middleman surface. its much faster than drawing the appsurf to
// the middleman
surf_buff = buffer_create(
	sw * sh * 4,
	buffer_fast,
	1
);

// bitshifting to the right once for whole numbers
// is equivelent to dividing by two rounded down
// >> 2 is division by 4
// >> 3 is / 8
// ect
lut_w = sw >> 3;
lut_h = sh >> 3;
pano_lut = -1;
lut_xy_type = buffer_f16;
lut_xy_sz = buffer_sizeof(lut_xy_type);
lut_stride = lut_xy_sz << 1;

// we create the lookup table in two passes, one for the X and one for the Y
// floating point numbers are 4 bytes long. unfortunately, so is one RGBA
// value for a pixel in a surface. so to get all four bytes we need to do
// two passes. see shader_pano_lut.fsh for how we do this shader-side.
// its a bitch
// do note that because of the shader inadquacies the precision is very janky
// GLSL ES 2.0 is a shitty and old model T that doesnt let you do anything fun
// i could solve this by having more passes? but really the smooth LUT func
// does the job well enough for things that *need* to follow the cursor, 
// and everything else can use the unsmoothened func since its not seen
begin
	pano_lut = buffer_create(lut_w * lut_h * lut_stride, buffer_fixed, 1);
	surf = surface_create(lut_w, lut_h);
	
#region function that does axis getting shit
	///@func __render_pano_axis_to_lut
	///@param axis_to_render
	///@param lut_index_offset
	var __render_pano_axis_to_lut = function (_dir, offset)
	{
		switch (_dir)
		{
			case "HORI":
				_dir = $49524F48; // "HORI"
				break;
			case "VERT":
				_dir = $54524556; // "VERT"
				break;
			default:
				throw ("invalid direction argument!");
				break;
		}
		
		var sha = fx_pano_lut;
		var dir = shader_get_uniform(sha, "dir");
		
		// draw the coord axis to the surface with the shader
		draw_clear_alpha(0., 1.);
		shader_set(sha);
			shader_set_uniform_i(dir, _dir);
			vertex_submit(model, pr_trianglelist, -1);
		shader_reset();
		
		// get the basically garbage looking texture
		// but actually contains juicy data
		buffer_get_surface(surf_buff, surf, 0);
		
		var bytes = 3;
		
		// convert the horribly mangled data back into something
		// kind-of usable.
		// seriously, fuck GLSL ES 2.0.
		for (var i = 0; i < (lut_w * lut_h); i++)
		{
			var coord = 0;
			
			for (var _i = 0; _i < bytes; _i++)
			{
				var _c = buffer_peek(surf_buff, (i * 4) + _i, buffer_u8);
				_c = floor(_c / 255 * (1000 - 1));
				_c = _c * power(10, 3 * (bytes - (_i + 1)));
				
				coord += _c;
				
			}
			
			coord /= power(10, 3 * bytes);
			buffer_poke(pano_lut, i * lut_stride + offset, lut_xy_type, coord);
		}
		
	}
#endregion
	
	// draw the model's UVs to the surface.
	surface_set_target(surf);
	{
		matrix_stack_push(matrix_build(lut_w >> 1, lut_h >> 1, 0, 0,0,0, lut_w, lut_h, 1));
		matrix_set(matrix_world, matrix_stack_top());
		
		__render_pano_axis_to_lut("HORI", 0);
		__render_pano_axis_to_lut("VERT", lut_xy_sz);
		
		matrix_stack_pop();
		matrix_set(matrix_world, matrix_build_identity());
	}
	
	surface_reset_target();
	surface_free(surf);
end


// todo: how to extrapolate?

///@func remap_coord
///@param x
///@param y
///@param min_x
///@param min_y
///@param max_x
///@param max_y
function remap_coord (_x, _y, _min_x, _min_y, _max_x, _max_y)
{
	// in case the coordinate is outside the bounds, add the distance its outside back
	// just cause.
	var xdist = ((_x - _max_x) * (_x > _max_x)) - ((_min_x - _x) * (_x < _min_x));
	var ydist = ((_y - _max_y) * (_y > _max_y)) - ((_min_y - _y) * (_y < _min_y));
	
	_x = (_x - _min_x) / (_max_x - _min_x);
	_y = (_y - _min_y) / (_max_y - _min_y);
	
	_x = clamp(_x * (lut_w - 1), 0, lut_w - 1);
	_y = clamp(_y * (lut_h - 1), 0, lut_h - 1);
	
	var mix_x = frac(_x);
	var mix_y = frac(_y);
	
	var i_lo = (floor(_y) * lut_w + floor(_x)) * lut_stride;
	var i_hi = (ceil(_y)  * lut_w + ceil(_x))  * lut_stride;
	
	var u = (buffer_peek(pano_lut, i_lo, lut_xy_type) * (1. - mix_x) +
	         buffer_peek(pano_lut, i_hi, lut_xy_type) * mix_x);
	
	var v = (buffer_peek(pano_lut, i_lo + lut_xy_sz, lut_xy_type) * (1. - mix_y) +
	         buffer_peek(pano_lut, i_hi + lut_xy_sz, lut_xy_type) * mix_y);
	
	_x = u * (_max_x - _min_x) + _min_x;
	_y = v * (_max_y - _min_y) + _min_y;
	
	return [_x + xdist, _y + ydist];
}
