/// @desc

begin
	var i = 0;
	var scale = 4;
	var space = 8;
	repeat (array_size(textures))
	{
		var spr_w = sprite_get_width(textures[i]);
		var xp = 32 + (spr_w * scale * i) + (space * i);
		draw_sprite_ext(
			textures[i], 0, 
			xp, 
			32, 
			scale, scale,
		
			0, c_white, 1
		);
		
		if (current == i)
		{
			draw_push_state();
			var hsp = space * .5;
			draw_rectangle(xp - hsp, 32 - hsp, xp + spr_w * scale + hsp, 32 + spr_w * scale + hsp, true);
			draw_set_valign(fa_top);
			draw_text(
				xp - hsp, 32 + spr_w * scale + hsp,
				tex_names[current] + "\nIndex: " + string(current)
			);
			
			draw_pop_state();
		}
		
		i++;

	}
	
end

matrix_world_set(
	matrix_build(
		0,0,0,
		0,0,(((mouse_y_real() - (RESH * .5)) / RESH) * 90),
		1, 1, 1
	)
);

matrix_multiply_world(
	matrix_build(
		RESW*.5,
		RESH*.5 - ((sin(time()) * 32) - 16),
		0,
		0,time() * 90,0,
		16, 16, 16
	)
);

vertex_submit(meshes[?tex_names[current]], pr_trianglelist, sprite_get_texture(textures[current], 0));

matrix_world_reset();
