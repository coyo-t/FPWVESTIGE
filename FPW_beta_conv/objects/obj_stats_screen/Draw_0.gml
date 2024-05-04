/// @desc

if (on_camera(bbox_left, bbox_top, bbox_right, bbox_bottom, view_camera[view_current]))
{
	screen_surface = surface_create_unexist(screen_surface, screen_size, screen_size);
	
	surface_set_target(screen_surface);
	{
		draw_clear(c_black);
		draw_push_state();
		
		//the monitor screen
		if (startup_ended)
		{
			draw_sprite_stretched_ext(background, 0, 0, 0, screen_size, screen_size, c_dkgrey, 1.);
			draw_set_font(_G.font_debug);
			var screen_string = "";

			var time_mngr = obj_cycle_manager;
			var psi_mngr  = obj_psych;
			var pwr_mngr  = obj_power;

			//time
			screen_string += "Time:\n" + string(time_mngr.cycle_time_normal * 100) +"%\n";
			//psychosis
			screen_string += "Madness:\n" + string(psi_mngr.madness_normalized * 100) +"\n";

			//power level
			screen_string += "Aux Power:\n"+string((pwr_mngr.level/pwr_mngr.level_max)*100)+"%\n";
			//drain rate
			screen_string += "Usage:" + string(string_repeat("#", floor(abs(pwr_mngr.drain_rate)+0.5)))+"\n";
			
			//screen_string += "WHATS WRONG?";
			
			draw_text_transformed(8, 8, screen_string, 2, 2, 0);
	
			//todo, spooky happenings on the scren
	
			//crt effects
			set_blend_multi();
	
			var vx = view_get_wport(view_current);
			var vy = view_get_hport(view_current);
	
			view_set_wport(view_current, screen_size);
			view_set_hport(view_current, screen_size);
	
			draw_sprite_tiled(
				spr_stats_phosphor, 0, 
				0, floor(time() * 12)
			);
	
			gpu_set_blendmode(bm_add);
	
			draw_sprite_tiled_ext(
				spr_stats_scanline, 0, 
				0, floor(time() * 60),
				1, 1.2, scanline_shade, 1.
			);

			view_set_wport(view_current, vx);
			view_set_hport(view_current, vy);
			
		}
		
		// startup flash
		if (!startup_ended || (startup_ended && startup_fade > 0))
		{
			gpu_set_blendmode(bm_normal);
			
			draw_sprite_stretched_ext(
				startup_anim, clamp(startup_timer, 0, startup_timer_end - 1), 
				0, 0, screen_size, screen_size, 
				c_white, startup_fade
			);
			
		}
		
		set_blend_multi();
		
		draw_sprite(spr_stats_vinyet, 0, 0, 0);

		gpu_set_blendmode(bm_normal);

		draw_pop_state();
		
	} surface_reset_target();
	
	//now actually draw the screen model
	matrix_world_set(matrix_build(0,0,screen_z,0,0,0,model_size,model_size,1));
	gpu_push_state();
	gpu_set_alphatestenable(true);
	gpu_set_texfilter(true);
	vertex_submit(model_monitor, pr_trianglelist, surface_get_texture(screen_surface));
	gpu_pop_state();
	matrix_world_reset();
	
}
