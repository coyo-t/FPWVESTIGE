/// @desc
if (audio_exists(madness_sound))
{
	madness_sound_pos = audio_sound_get_track_position(madness_sound);
	
} else {
	madness_sound = audio_play_sound(madness_sound_asset, 10, true);
	audio_sound_set_track_position(madness_sound, madness_sound_pos);
	audio_pause_sound(madness_sound);
}

if (madness > 1)
{
	if (audio_is_paused(madness_sound))
	{
		audio_resume_sound(madness_sound);
	}
	
	audio_sound_gain(madness_sound, madness_normalized, 2);
	
} else {
	if (audio_sound_get_gain(madness_sound) == 0)
		audio_pause_sound(madness_sound);
	else
		audio_sound_gain(madness_sound, 0., 2);
}

if (madness >= madness_max - 1)
{
	if (audio_is_playing(madness_haluc_sound))
	{
		audio_sound_pitch(madness_haluc_sound, 0.83);
	}
	
	if (madness_haluc_cooldown <= 0)
	{
		madness_haluc_cooldown = madness_haluc_cooldown_max + m_random_range(-5, 5);
		
		if (!audio_is_playing(madness_haluc_sound))
		{
			var ind;
			do
			{
				ind = floor(random(1) * ((array_size(madness_haluc_sfx) - 1) * 0.5)) * 2;
			} until (ind != madness_haluc_last)
			
			madness_haluc_last = ind;
			madness_haluc_sound = audio_play_sound(madness_haluc_sfx[ind], 10, false);
			audio_sound_gain(madness_haluc_sound, madness_haluc_sfx[ind + 1], 0.);
			
		}
		
	} else {
		madness_haluc_cooldown -= dt();
	}
	
}
