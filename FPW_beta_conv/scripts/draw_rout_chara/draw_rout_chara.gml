function dwrt_cctv_ekka_garble_1 () begin
	var cc = spr_cctv_static;
	_G.m_random_scale = 0.21;
	obj_cctv.cctv_static_intensity += m_irandom_range(-128, 255);
	obj_cctv.cctv_static_intensity = clamp(obj_cctv.cctv_static_intensity, 0, 255);

	var blendmodes = [
		bm_zero, 
		bm_one, 
		bm_src_colour, 
		bm_inv_src_colour, 
		bm_src_alpha, 
		bm_inv_src_alpha, 
		bm_dest_alpha, 
		bm_inv_dest_alpha, 
		bm_dest_colour, 
		bm_inv_dest_colour, 
		bm_src_alpha_sat
	];

	//if (!audio_is_playing(sfx_ekkathink_suiyubi))
	//{
	//	var s = audio_play_sound(sfx_ekkathink_suiyubi, 4, false);
	//	audio_sound_gain(s, 0.8, 0);
	//}

	surface_resize(surface_x, RESW, RESH);
	surface_resize(surface_y, RESW, RESH);

	var outSurf = surface_x;

	surface_set_target(surface_x);
	gpu_push_state();
	gpu_set_colourwriteenable(p_irandom(1), p_irandom(1), p_irandom(1), true);
	draw_sprite_stretched(
		cc, time() * sprite_get_speed(cc), 
		0, 0,
		RESW, RESH
	);

	gpu_set_blendmode(bm_subtract);
	gpu_set_colourwriteenable(true, true, true, false);
	var stat = spr_cctv_interf;
	draw_sprite_stretched(
		stat, time() * sprite_get_speed(stat),
		0, 0, RESW, RESH
	);

	//draw overnight
	gpu_set_blendmode(bm_add);
	stat = spr_ekka_legacy;
	var hw = RESW*.5;
	var hh = RESH*.5;
	var sprw = sprite_get_width(stat) * .5 * 2;
	var sprh = sprite_get_height(stat) * .5 * 2;
	var vari = 32;
	var hvari = vari*.5;

	draw_sprite_pos(
		stat, m_irandom(1),
		(hw - sprw) + m_random_range(-vari, hvari), (hh - sprh) + m_random_range(-vari, hvari),
		(hw + sprw) + m_random_range(-hvari, vari), (hh - sprh) + m_random_range(-vari, hvari),
		(hw + sprw) + m_random_range(-hvari, vari), (hh + sprh) + m_random_range(-hvari, vari),
		(hw - sprw) + m_random_range(-vari, hvari), (hh + sprh) + m_random_range(-hvari, vari),
		1
	);

	//draw_sprite_ext(
	//	stat, m_irandom(1),
	//	RESW*.5 + m_irandom_range(-2, 2), 
	//	RESH*.5 + m_irandom_range(-2, 2), 
	//	4, 
	//	4, 
	//	0, c_white, 1.
	//);

	stat = spr_ekka_circuit;
	draw_sprite_stretched(
		stat, time() * sprite_get_speed(stat),
		0, 0, RESW, RESH
	);

	gpu_set_blendmode(bm_subtract);
	stat = spr_cctv_unknownError;
	draw_sprite_stretched(
		stat, time() * sprite_get_speed(stat),
		0, 0, RESW, RESH
	);

	surface_reset_target();
	gpu_set_blendmode(bm_normal);

	if (irandom(1))
	{
		surface_set_target(surface_y);
		gpu_push_state();
	
		gpu_set_texfilter(true);
		var trans = matrix_get(matrix_world);
		var cam = view_get_camera(0);
	
		camera_apply(camera_perspective);
	
		matrix_set(matrix_world, matrix_build(
			0, 0, 0, 0,0,0, 1,1,1
		));
	
		vertex_submit(obj_panorama_labyrinth.model, pr_trianglelist, surface_get_texture(surface_x));

		matrix_set(matrix_world, trans);
		gpu_pop_state();
		camera_apply(cam);

		surface_reset_target();

		outSurf = surface_y;
	
	} else {

	}

	gpu_set_blendmode_ext(
		blendmodes[m_irandom_range(0, array_size(blendmodes) - 1)],
		blendmodes[m_irandom_range(0, array_size(blendmodes) - 1)]
	);
	draw_surface_ext(
		outSurf, 
		0, 0,
		1, 1, 0,
		make_colour_rgb(m_irandom_range(128, 255), m_irandom_range(128, 255), m_irandom_range(128, 255)),
		1.
	);

	gpu_pop_state();
	_G.m_random_scale = 1.;

end


function dwrt_lizz_panic () begin
	//panic
	var ssurf = screen_surface;
	//gpu_set_blendmode_ext_sepalpha(bm_zero, bm_inv_src_colour, bm_one, bm_src_alpha);

	with (obj_psych)
	{
		var mnrm = madness_normalized;
		var mx = mnrm * 255;
	
		begin
			var px = m_random_range(0., 8);
			var py = m_random_range(0., 8);
			gpu_set_blendmode(bm_subtract);
			draw_surface_stretched_ext(
				ssurf,
				-px, -py,
				RESW + px + m_random_range(0., 8), RESH + py + m_random_range(0., 8),
				make_colour_shade((mx + m_random_range(-mnrm * 32, mnrm * 32)) * .5), 1.
			);
		end

		if (madness_show_sprite && mnrm >= 0.4)
		{
			gpu_set_blendmode(madness_sprite_blendmode);
			shader_set(sha_rBlur_spr);
			repeat (4)
			{
				var dr = irandom_range(0, 255);
				shader_send("amount_x", m_random_range(0., madness_sprite_blur)); // 0.05
				shader_send("amount_y", m_random_range(0., madness_sprite_blur)); // 0.05
		
				var spr = madness_current_sprite;
				var spr_ind = time() * sprite_get_speed(madness_current_sprite);
				var spr_uvs = sprite_get_uvs(spr, spr_ind);
				shader_set_uniform_f_array(
					shader_get_uniform(shader_current(), "uvs"), 
					[spr_uvs[0], spr_uvs[1], spr_uvs[2], spr_uvs[3]]
				);
		
				var sh = irandom_range(mx * .25, mx * .5);
				var maxi = madness_sprite_wigout ? 1 : HEXCOL;
				shader_set_uniform_f_array(
					shader_get_uniform(shader_current(), "col"), 
					[sh * maxi, sh * maxi, sh * maxi, 1.]
				);
			
				//vertex_submit(madness_mesh, pr_trianglelist, sprite_get_texture(madness_current_sprite, spr_ind));
			
				draw_sprite_pos(
					spr, spr_ind,
					-random_range(0, dr), -random_range(0, dr),
					RESW+random_range(0, dr), -random_range(0, dr),
					RESW+random_range(0, dr), RESH+random_range(0, dr),
					-random_range(0, dr), RESH+random_range(0, dr),
					1.
				);
			}
			shader_reset();
	
		}

		gpu_set_blendmode(bm_subtract);
		draw_sprite_stretched_ext(
			spr_lizz_panic, time() * sprite_get_speed(spr_lizz_panic),
			0, 0, RESW, RESH, make_colour_shade(mx), 1.
		);

		gpu_set_blendmode(bm_max);
		draw_sprite_stretched_ext(
			spr_lizz_panic_snow, time() * sprite_get_speed(spr_lizz_panic_snow),
			0, 0, RESW, RESH, make_colour_shade(mx * .5), 1.
		);


		//keep this one in mind for reverse tunnel vision effect?
		//gpu_set_blendmode_ext(bm_dest_colour, bm_zero);
		//draw_sprite_stretched(
		//	spr_mattis_panic, time() * sprite_get_speed(spr_mattis_panic),
		//	0, 0, RESW, RESH
		//);

		gpu_set_blendmode(bm_normal);
		
	}

end
