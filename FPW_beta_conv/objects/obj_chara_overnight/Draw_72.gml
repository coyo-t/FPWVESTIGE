/// @desc
var sect_inst = obj_cctv.cctv_current_sector_id;

if (current_sector == sect_inst.sector_name && obj_cctv.is_cctv_on)
{
	ds_stack_push(obj_cctv_visuals.dwrt_queue, dwrt_cctv_ekka_garble_1);
	
	if (!audio_is_playing(garble_sound_id) && garble_sound_target != -1)
	{
		garble_sound_id = audio_play_sound(garble_sound_target, 3, false);
		audio_sound_gain(garble_sound_id, garble_volume, 0);
		audio_sound_set_track_position(garble_sound_id, garble_length - cooldown);
		audio_sound_pitch(garble_sound_id, 1 + random_range(-garble_pitch_variation, garble_pitch_variation));
		
	} else if (audio_is_playing(garble_sound_id) && garble_sound_target != -1) {
		
	}
	
} else {
	audio_stop_sound(garble_sound_id);
	
}
