/// @desc

// Inherit the parent event
event_inherited();

var watched = cctv_viewing();

if (is_running && watched && running_timer >= 0)
{
	if (!audio_exists(running_cctv_sfx))
	{
		running_cctv_sfx = audio_play_sound(running_sector.sfx, 4, false);
	}
	
}

if (audio_exists(running_cctv_sfx))
{
	if (watched)
	{
		audio_sound_gain(running_cctv_sfx, running_cctv_sfx_vol, 0);
	} else {
		audio_sound_gain(running_cctv_sfx, 0., 0);
	}

	if (!is_running || running_timer < 0)
	{
		audio_stop_sound(running_cctv_sfx);
	}
}
