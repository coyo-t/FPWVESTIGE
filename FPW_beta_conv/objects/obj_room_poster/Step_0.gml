/// @desc

if (obj_labyrinth_visuals.state == room_states.lizz && wasClicked)
{
	if (audio_is_playing(sfx))
		audio_stop_sound(sfx);
	
	var ran = 0.05;
	sfx = audio_play_sound(sfx_asset, 2, false);
	//audio_sound_set_track_position(sfx, 0.3);
	audio_sound_pitch(sfx, 1 + random_range(-ran, ran));
	
}
