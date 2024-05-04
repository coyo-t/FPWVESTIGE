/// @desc mostly debug shit lives here
if (DEBUG) begin
	if (get_inp("screenshot"))
	{
		var d = date_current_datetime();
		var year = date_get_year(d);
		var month = date_get_month(d);
		var day = date_get_day(d);
		var time_h = date_get_hour(d);
		var time_m = date_get_minute(d);
		var time_s = date_get_second(d);
		
		var date = stringf("y%s-m%s-d%s h%s-m%s-s%s", year, month, day, time_h, time_m, time_s);
		
		screenshot_surface = surface_create_unexist(
			screenshot_surface, 
			surface_get_width(application_surface), surface_get_height(application_surface)
		);
		
		surface_set_target(screenshot_surface);
		draw_clear_alpha(c_black, 1.);
		gpu_set_colourwriteenable(1,1,1,0);
		draw_surface(application_surface, 0, 0);
		gpu_set_colourwriteenable(1,1,1,1);
		surface_reset_target();
		
		surface_save(
			screenshot_surface,
			stringf("%s%s %s.png", SCREENSHOT_SAVE_LOC, game_project_name, date)
		);
	}

	if (keyboard_check_pressed(vk_f6)) plrdat_save(true);
	
	debug_push_string("rot", save_data[? SAVEKEY_CYCLE]);
	
end
