/// @desc
if (alpha_active) {
	image_alpha = lerp_dt(image_alpha, 1., math_get_epsilon());
}

if (timeline_position < flicker_timeline_max) {
	timeline_running = true;
	timeline_pos_nrm = timeline_position / flicker_timeline_max;
	
} else {
	timeline_running = false;
	timeline_pos_nrm = 1;
	
}

if (was_on != is_on) {
	var s = sfx_flashlight_toggle;
	if audio_is_playing(s) then audio_stop_sound(s);
	
	var ss = audio_play_sound(s, 10, false);

	audio_sound_gain(ss, 0.75, 0);
	audio_sound_pitch(ss, 1.05 + random_range(-0.05, 0.03));
	
}

if (is_on && !audio_is_playing(sound_buzz)) {
	var s = sfx_fluroLight;
	sound_buzz = audio_play_sound(s, 10, true);
	audio_sound_gain(sound_buzz, sound_buzz_volume, 0);
	
} else if (!is_on && audio_is_playing(sound_buzz))
{
	audio_stop_sound(sound_buzz);
}

if (audio_is_playing(sound_buzz)) {
	if (timeline_running) {
		var tls = timeline_running ? timeline_pos_nrm : 1;
		audio_sound_gain(sound_buzz, sound_buzz_volume * tls, 2);
		audio_sound_pitch(sound_buzz, sound_buzz_pitch - (tls * sound_buzz_pitch_vari));
		
	} else {
		audio_sound_pitch(sound_buzz, sound_buzz_pitch);
		audio_sound_gain(sound_buzz, sound_buzz_volume, 2);
		
	}
	
}

was_on = is_on;
last_mouse = mouse_down;
