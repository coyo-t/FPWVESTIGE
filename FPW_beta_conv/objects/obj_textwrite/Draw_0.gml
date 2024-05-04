/// @desc
var info = bfont_info;
var s = info[?"sprite"];
var chars = info[?"chars"];

var accum_x = 0;
var accum_y = 0;

var drawp_x = 32;
var drawp_y = 32;

var off_x = 0;
var off_y = 0;

var scale_x = 3;
var scale_y = 3;

var z = depth;

gpu_push_state();
gpu_set_cullmode(cull_noculling);
draw_push_state();

matrix_world_set(matrix_build(
	drawp_x, drawp_y, z,
	0,0,0,
	scale_x, scale_y, 1
));
vertex_begin(char_vbuff, _G.vform_shadeless);
var submitted = false;

for (var i = 0; i <= t_dialog_ind; i++)
{
	var elm = t_dialog[i];
	
	if (is_string(elm))
	{
		if (elm == "\n")
		{
			accum_x = 0;
			accum_y += info[?"base_height"] + info[?"space_y"];
		}
		else if (elm == "\t")
		{
			accum_x += info[?"tab_size"];
		}
		else if (ds_map_exists(chars, elm))
		{
			var char = chars[?elm];
			
			{
				var chance = irandom($FFF) < 1;
				var ran = 1;
				off_x = irandom_range(-ran, ran) * chance;
				off_y = irandom_range(-ran, ran) * chance;
			}
			
			var quadx1 = accum_x + off_x;
			var quady1 = accum_y + off_y;
			var quadx2 = quadx1 + char[?"w"];
			var quady2 = quady1 + char[?"h"];
				
			var spr_tex = sprite_get_texture(s, 0);
			var spr_uvs = sprite_get_uvs(s, 0);
			var spr_tex_w = texture_get_texel_width(spr_tex);
			var spr_tex_h = texture_get_texel_height(spr_tex);
			
			var quad_u1 = spr_uvs[0] + (char[?"x"] * spr_tex_w);
			var quad_v1 = spr_uvs[1] + (char[?"y"] * spr_tex_h);
			var quad_u2 = spr_uvs[0] + ((char[?"x"] + char[?"w"]) * spr_tex_w);
			var quad_v2 = spr_uvs[1] + ((char[?"y"] + char[?"h"]) * spr_tex_h);
			
			//var quad_c = draw_get_colour();
			var quad_a = draw_get_alpha();
				
			var skew = 2;

			create_char_quad(
				char_vbuff,
				_cqp(quadx1 + skew, quady1, quad_u1, quad_v1, tw_state.point_cols[0], quad_a), // top left
				_cqp(quadx2 + skew, quady1, quad_u2, quad_v1, tw_state.point_cols[1], quad_a), // top right
				_cqp(quadx1 - skew, quady2, quad_u1, quad_v2, tw_state.point_cols[2], quad_a), // bottom left
				_cqp(quadx2 - skew, quady2, quad_u2, quad_v2, tw_state.point_cols[3], quad_a) // bottom right
			);
				
			submitted = true;
				
			accum_x += char[?"w"] + info[?"space_x"];
			
		}
		
	}
	else if (elm == Textwrite_type.cmd_draw)
	{
		var cmd = t_dialog[++i];
		if (ds_map_exists(cmds, cmd))
			cmds[?cmd]();
			
		continue;
		
	}
	else if (elm == Textwrite_type.cmd_step)
	{
		i++;
		continue;
	}
	

}

vertex_end(char_vbuff);
	
if (submitted)
	vertex_submit(char_vbuff, pr_trianglelist, spr_tex);

matrix_world_reset();

//camera_set_view_mat(cact, cmat);
//camera_apply(cact);

gpu_pop_state();
draw_pop_state();

//matrix_world_reset();
