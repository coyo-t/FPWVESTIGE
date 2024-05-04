/// @desc
var mx = meta_master.get_inp("mouse_x");
var my = meta_master.get_inp("mouse_y");

var m_over = point_in_bbox(mx, my) || meta_master.get_inp("ctrl_down");

if (is_anim_playing) 
{
	cctv_anim_frame = animate_and_return(cctv_anim, cctv_anim_frame, is_cctv_active * 2 - 1);
	cctv_anim_frame = clamp(cctv_anim_frame, -1, cctv_anim_count);
}

if (cctv_anim_frame <= -1 || cctv_anim_frame >= cctv_anim_count)
{
	is_anim_playing = false;
	
}

if (is_enabled)
{
	if (m_over && !was_mouse_over && !mouse_still_over)
	{
		is_cctv_active ^= true;
		mouse_still_over = true;
		is_anim_playing = true;
	
	}

	was_mouse_over = m_over;

	if (!m_over && mouse_still_over)
	{
		mouse_still_over = false;
	}
	
} else {
	is_cctv_active = false;
}

mouse_still_over |= is_anim_playing;

is_cctv_on = cctv_anim_frame >= cctv_anim_count;

image_blend = is_cctv_active ? colour_active : colour_inactive;

play_flip_sound();

lyrmngr_cctv.set_vis(is_cctv_on);

if (is_enabled)
{
	if (is_cctv_on && was_cctv_on != is_cctv_on)
	{
		obj_labyrinth_visuals.change_state(room_states.cctv);

	} 
	else if (!is_cctv_on && was_cctv_on != is_cctv_on)
	{
		obj_labyrinth_visuals.change_state(room_states.lizz);

	}
	
}

//static shit
if (audio_exists(cctv_static_sound))
{
	cctv_static_pos = audio_sound_get_track_position(cctv_static_sound);
	
} else {
	cctv_static_sound = audio_play_sound(cctv_static_sound_asset, 10, true);
	audio_sound_set_track_position(cctv_static_sound, cctv_static_pos);
	audio_pause_sound(cctv_static_sound);
	
}

if (is_cctv_on)
{
	audio_resume_sound(cctv_static_sound);
	var pitch = ((cctv_static_intensity / 255) * 2 - 1);
	audio_sound_pitch(cctv_static_sound, cctv_static_pitch + pitch * (irandom(1)*0.025));
	audio_sound_gain(cctv_static_sound, cctv_static_volume + (pitch * cctv_static_volume_multi), 0);
	
	obj_power.affect_drain(1);
	
	if (irandom(100) < 15)
	{
		cctv_static_intensity += irandom_range(-32, 64);
	}
	
} else {
	audio_pause_sound(cctv_static_sound);
}

if (is_anim_playing)
{
	meta_pause.can_pause = false;
}
