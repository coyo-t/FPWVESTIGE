///@arg sprite
function minecraft_create_mesh(argument0) {
	var tex = argument0;

	var mesh = vertex_create_buffer();

	var spr_w = sprite_get_width(tex);
	var spr_h = sprite_get_height(tex);
	var w_inc = 1 / spr_w;
	var h_inc = 1 / spr_h;
	var alpha_threshold = 0.5;

	var surf = surface_create(spr_w, spr_h);
	surface_set_target(surf);
	gpu_push_state();
	gpu_set_colourwriteenable(1,1,1,1);
	draw_clear_alpha(c_black, 0.);
	draw_sprite(tex, 0, 0, 0);
	gpu_pop_state();
	surface_reset_target();

	vertex_begin(mesh, _G.vform_shadeless);

	var pixels = [];
	for (var iy = 0; iy < spr_h; iy++)
	{
		for (var ix = 0; ix < spr_w; ix++)
		{
			var col = surface_getpixel_ext(surf, ix, iy);
			var alp = ((col >> 24) & $FF) / 255; //extract alpha componant and normalize
			col &= $FFFFFF; //chop off alpha componant from colour
		
			//fyi dumbass, colour is never used.
			pixels[ix, iy] = alp;
		
		}
	
	}

	for (var iy = 0; iy < spr_h; iy++)
	{
		for (var ix = 0; ix < spr_w; ix++)
		{
			var alp = pixels[ix, iy];
		
			if (alp <= alpha_threshold) { continue; } else
			{
				var nbr_u = (iy - 1 >= 0)    ? pixels[ix, iy - 1] : -1;
				var nbr_d = (iy + 1 < spr_h) ? pixels[ix, iy + 1] : -1;
				var nbr_l = (ix - 1 >= 0)    ? pixels[ix - 1, iy] : -1;
				var nbr_r = (ix + 1 < spr_w) ? pixels[ix + 1, iy] : -1;
			
			
				var coord_x = ix / spr_w;
				var coord_y = 1 - (iy / spr_h);
				var px = ix - (spr_w * .5);
				var py = iy - (spr_h * .5);
				var front = 0.5;
			
				//todo, separate the front and back parts, and rearrange verts so that backface culling
				//will work properlly
				//or not. idc
			
				//left face
				if (nbr_l == -1 || nbr_l <= alpha_threshold)
				{
					var sh = make_colour_shade(255 * (2/4));
					vertex_add_kms(mesh, px, py, -front, coord_x, coord_y, sh);
					vertex_add_kms(mesh, px, py, front, coord_x, coord_y, sh);
					vertex_add_kms(mesh, px, py + 1, -front, coord_x, coord_y, sh);
				
					vertex_add_kms(mesh, px, py + 1, -front, coord_x, coord_y, sh);
					vertex_add_kms(mesh, px, py, front, coord_x, coord_y, sh);
					vertex_add_kms(mesh, px, py + 1, front, coord_x, coord_y, sh);
				
				}
			
				//right face
				if (nbr_r == -1 || nbr_r <= alpha_threshold)
				{
					var sh = make_colour_shade(255 * (2/4));
					vertex_add_kms(mesh, px+1, py, -front, coord_x, coord_y, sh);
					vertex_add_kms(mesh, px+1, py, front, coord_x, coord_y, sh);
					vertex_add_kms(mesh, px+1, py + 1, -front, coord_x, coord_y, sh);
				
					vertex_add_kms(mesh, px+1, py + 1, -front, coord_x, coord_y, sh);
					vertex_add_kms(mesh, px+1, py, front, coord_x, coord_y, sh);
					vertex_add_kms(mesh, px+1, py + 1, front, coord_x, coord_y, sh);
				
				}
			
				//up face
				if (nbr_u == -1 || nbr_u <= alpha_threshold)
				{
					var sh = make_colour_shade(255 * (3/4));
					vertex_add_kms(mesh, px, py, -front, coord_x, coord_y, sh);
					vertex_add_kms(mesh, px + 1, py, -front, coord_x, coord_y, sh);
					vertex_add_kms(mesh, px, py, front, coord_x, coord_y, sh);
				
					vertex_add_kms(mesh, px, py, front, coord_x, coord_y, sh);
					vertex_add_kms(mesh, px + 1, py, -front, coord_x, coord_y, sh);
					vertex_add_kms(mesh, px + 1, py, front, coord_x, coord_y, sh);
				
				}
			
				//bottom face
				if (nbr_d == -1 || nbr_d <= alpha_threshold)
				{
					var sh = make_colour_shade(255 * (1/4));
					vertex_add_kms(mesh, px, py+1, -front, coord_x, coord_y, sh);
					vertex_add_kms(mesh, px + 1, py+1, -front, coord_x, coord_y, sh);
					vertex_add_kms(mesh, px, py+1, front, coord_x, coord_y, sh);
				
					vertex_add_kms(mesh, px, py+1, front, coord_x, coord_y, sh);
					vertex_add_kms(mesh, px + 1, py+1, -front, coord_x, coord_y, sh);
					vertex_add_kms(mesh, px + 1, py+1, front, coord_x, coord_y, sh);
				
				}
			
				//front and back faces
				repeat (2)
				{
					vertex_add_kms(mesh, px, py, front, coord_x, coord_y, c_white);
					vertex_add_kms(mesh, px + 1, py, front, coord_x + w_inc, coord_y, c_white);
					vertex_add_kms(mesh, px, py + 1, front, coord_x, coord_y - h_inc, c_white);
			
					vertex_add_kms(mesh, px, py + 1, front, coord_x, coord_y - h_inc, c_white);
					vertex_add_kms(mesh, px + 1, py, front, coord_x + w_inc, coord_y, c_white);
					vertex_add_kms(mesh, px + 1, py + 1, front, coord_x + w_inc, coord_y -  h_inc, c_white);
					front *= -1;
				
				}
			
			}
		
		}
	
	}

	vertex_end(mesh);
	surface_free(surf);

	return mesh;



}
