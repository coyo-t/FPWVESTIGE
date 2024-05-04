toggle_min = 0;
toggle_max = sprite_get_number(sprite_index) - 1;

target_frame = -1;

frame = 0;

initial_speed = image_speed;

sfx = -1;

fire_target_events = true;

function flip_up (keep_frame)
{
	if (keep_frame == undefined || !keep_frame)
		frame = toggle_min;
		
	image_speed = initial_speed;
	target_frame = toggle_max;
	obj_office_director.set_interaction(false);
	
	if (audio_is_playing(sfx))
		audio_stop_sound(sfx);
	
	sfx = audio_play_sound(sfx_cam_up, 1, false);
	audio_sound_gain(sfx, 0.5, 0);
	
}

function flip_down (keep_frame)
{
	if (keep_frame == undefined || !keep_frame)
		frame = toggle_min;
	
	image_speed = -initial_speed;
	frame = toggle_max;
	target_frame = toggle_min;
	obj_office_director.set_interaction(true);
	obj_cctv_toggle.set_cctv_state(false);

	if (audio_is_playing(sfx))
		audio_stop_sound(sfx);
	
	sfx = audio_play_sound(sfx_cam_down, 1, false);
	audio_sound_gain(sfx, 0.5, 0);

}

function is_animating ()
{
	return target_frame != -1;
	
}
