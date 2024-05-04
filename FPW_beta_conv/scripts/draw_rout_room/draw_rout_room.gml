function dwrt_light_left () begin
	var cici = obj_chara_cici.current_sector == "airlock_l";
	var mati = obj_chara_mattis.current_sector == "airlock_l";

	var spr_torch = spr_t_room_torch_l;
	var spr_cici  = spr_room_cici_hall_l;
	var spr_mati  = spr_room_mattis_hall_l;

	if (cici || mati)
	{
		light_surface = surface_create_unexist_depthless(light_surface, sprite_get_width(spr_torch), sprite_get_height(spr_torch));
		var l_ox = sprite_get_xoffset(spr_torch);
		var l_oy = sprite_get_yoffset(spr_torch);
	
		var g = gpu_get_state();
		gpu_set_blendmode(bm_normal);
		surface_set_target(light_surface); {
			draw_clear(c_black);
			draw_sprite(
				spr_torch, 0,
				l_ox,
				l_oy
			);
	
			if (cici && !mati)
			{
				draw_sprite_ext(spr_cici, 0, 0, 0, 2, 2, 0, c_white, 1.);
			}
	
			if (mati)
			{
				draw_sprite(spr_mati, 0, 0, 0);
			}
	
	

		} surface_reset_target();
	
		gpu_set_state(g);
		draw_surface_ext(light_surface, -l_ox, -l_oy, 1, 1, 0, image_blend, image_alpha);
	
		ds_map_destroy(g);
	
	} else {
		draw_sprite_ext(spr_torch, 0, 0, 0, 1, 1, 0, image_blend, image_alpha);
	}


end


function dwrt_light_right () begin
	var cici = obj_chara_cici.current_sector == "airlock_r";
	
	var spr_torch = spr_t_room_torch_r;
	var spr_cici  = spr_room_cici_hall_r;

	if (cici)
	{
		light_surface = surface_create_unexist_depthless(light_surface, sprite_get_width(spr_torch), sprite_get_height(spr_torch));
		var l_ox = sprite_get_xoffset(spr_torch);
		var l_oy = sprite_get_yoffset(spr_torch);
	
		var g = gpu_get_state();
		gpu_set_blendmode(bm_normal);
		surface_set_target(light_surface); {
			draw_clear(c_black);
			draw_sprite(
				spr_torch, 0,
				l_ox,
				l_oy
			);
	
			if (cici)
			{
				draw_sprite_ext(spr_cici, 0, 0, 0, 2, 2, 0, c_white, 1.);
			}

		} surface_reset_target();
	
		gpu_set_state(g);
		draw_surface_ext(light_surface, -l_ox, -l_oy, 1, 1, 0, image_blend, image_alpha);
	
		ds_map_destroy(g);
	
	} else {
		draw_sprite_ext(spr_torch, 0, 0, 0, 1, 1, 0, image_blend, image_alpha);
	}

end


function dwrt_light_centre () begin
	var grun = obj_chara_grun.current_sector == "interro";
	var cici = obj_chara_cici.current_sector == "interro";
	var jakl = obj_chara_jakl.current_sector == "interro";
	var mati = obj_chara_mattis.current_sector == "interro";

	var spr_torch = spr_t_room_torch_m;
	var spr_grun = spr_t_room_window_grun;
	var spr_cici = spr_t_room_window_cici;
	var spr_jakl = spr_t_room_window_jakl;
	var spr_mati = spr_t_room_window_mattis;

	//var col = colour_mix(light_colour_lo, light_colour_hi, timeline_pos_nrm);

	if (grun || cici || jakl || mati) {
		light_surface = surface_create_unexist_depthless(light_surface, sprite_get_width(spr_torch), sprite_get_height(spr_torch));
		var l_ox = sprite_get_xoffset(spr_torch);
		var l_oy = sprite_get_yoffset(spr_torch);
	
		var g = gpu_get_state();
		gpu_set_blendmode(bm_normal);
		surface_set_target(light_surface);
		draw_clear(c_black);
		draw_sprite(
			spr_torch, 0,
			l_ox,
			l_oy
		);
	
		if (!mati) {
			if (grun) then
				draw_sprite(spr_grun, 0, l_ox, l_oy);
			
			if (cici) then
				draw_sprite(spr_cici, 0, l_ox, l_oy);
			
			if (jakl) then
				draw_sprite(spr_jakl, 0, l_ox, l_oy);
			
		} else {
			draw_sprite(spr_mati, 0, l_ox, l_oy);
		}
		surface_reset_target();
	
		gpu_set_state(g);
		draw_surface_ext(light_surface, -l_ox, -l_oy, 1, 1, 0, image_blend, image_alpha);
	
		ds_map_destroy(g);
	
	} else {
		draw_sprite_ext(spr_torch, 0, 0, 0, 1, 1, 0, image_blend, image_alpha);
	
	}

end

