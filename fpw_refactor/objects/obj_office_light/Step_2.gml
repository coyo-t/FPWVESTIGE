if (light_on != was_light_on)
{
	var s = sfx_flashlight_toggle;
	
	if (audio_is_playing(sound_toggle)) audio_stop_sound(sound_toggle);
	
	sound_toggle = audio_play_sound(s, 10, false);
	
	audio_sound_gain(sound_toggle, .45, 0);
	audio_sound_pitch(sound_toggle, 1.05 + random_range(-.05, .03));
	
}

// if the light is on, then play the sound.
if (light_on && !audio_is_playing(sound_buzz))
{
	var s = sfx_fluroLight;
	sound_buzz = audio_play_sound(s, 10, true);
	audio_sound_gain(sound_buzz, buzz_volume, 0);
	
}
else if (!light_on && audio_is_playing(sound_buzz))
{
	audio_stop_sound(sound_buzz);
}

if (audio_is_playing(sound_buzz))
{
	audio_sound_pitch(sound_buzz, buzz_pitch);
	audio_sound_gain(sound_buzz, buzz_volume, 2);
	
}

was_light_on = light_on;
