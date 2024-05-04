/// @desc
debug_push_string("MEAT", created_by);
debug_push_string("frame", anim_frame);

if (scr_trigger() && !triggered)
{	
	triggered = true;
	if (!audio_is_playing(sfx))
	{
		sfx = audio_play_sound(sound, 10, false);
		
		
	}
	obj_labyrinth_visuals.change_state(room_states.lizz);
	scr_lab_disable_room();
	obj_office_player.is_enabled = false;
	obj_office_player.is_enabled_override = true;
}

if (triggered && anim_frame >= sprite_get_number(anim))
{
	audio_stop_all();
	room_goto(room_death);
}
