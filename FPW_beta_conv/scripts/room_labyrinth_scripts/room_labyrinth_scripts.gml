function scr_labyrinth_init () begin
	texture_prefetch("labyrinth");
	texture_prefetch("cctv");
	texture_prefetch("xscare");
	texture_prefetch("screen_decor");
	texture_prefetch("temp");

	with (class_char_ai) { post_create(); }

end


function scr_lab_disable_room () begin
	obj_labyrinth_visuals.state_alterable = false;
	obj_cctv.set_active(false);
	obj_cctv.is_enabled = false;
	obj_power.is_enabled = false;
	class_doorButton.is_enabled = false;
	class_doorButton.is_on = false;
	obj_lightButton.is_enabled = false;
	obj_lightButton.is_on = false;
	class_char_ai.is_enabled = 0;
	meta_pause.can_pause_latch = true;
	meta_pause.can_pause = false;
	obj_calm_tv.disable();

end
