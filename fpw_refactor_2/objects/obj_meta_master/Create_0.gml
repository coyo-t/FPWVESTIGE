//#macro BASEPATH            "./bin/"
//#macro Testing:BASEPATH    "./bin_dbg/"
//#macro SCREENSHOT_SAVE_LOC "C:/Users/Chymic/Pictures/gmDebugImg/"
//#macro SCREENSHOT_SAVE_LOC @"D:\_images\gmDebugImg\fpw_2_2\"

audio_master_gain(0.75);

function build_year_week_tag ()
{
	var date = date_current_datetime();
	return tostr(date_get_year(date) - 2000)+"w"+tostr(date_get_week(date));
}

function save_screenshot ()
{
	var ssurf = surface_create(appsurf_w, appsurf_h);
	surface_set_target(ssurf);
		draw_clear_alpha(c_black, 1.);
		gpu_push_state();
		gpu_set_blendenable(0);
		gpu_set_colourwriteenable(1,1,1,0);
		draw_surface(appsurf, 0, 0);
		gpu_pop_state();
	surface_reset_target();
	
	var date = date_current_datetime();
	var fname = (
		build_year_week_tag()+
		";"+tostr(date_get_minute(date))+
		";"+tostr(date_get_second(date))
	);
	surface_save(ssurf, SCREENSHOT_SAVE_LOC+fname+".png");
	
	surface_free(ssurf);
}
