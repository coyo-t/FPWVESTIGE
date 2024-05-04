/// @desc
if (!is_enabled) exit;

level += dt() * drain_rate;
level = max(level, 0.);

//if keyboard_check_pressed(ord("R")) then level = 0;

drain_rate = -1;

if (level == 0)
{
	obj_labyrinth_visuals.change_state(room_states.power_out);
	scr_lab_disable_room();
	class_monitors.visible = false;
	
	if (!played_sound)
	{
		played_sound = true;
		var s = audio_play_sound(sfx_spark, 10, false);
		audio_sound_gain(s, 1., 0);
		
		s = audio_play_sound(sfx_powerdown, 10, false);
		audio_sound_gain(s, .75, 0);
		audio_sound_pitch(s, 0.6);
		audio_sound_gain(s, .5, 255);
	}
	
}
