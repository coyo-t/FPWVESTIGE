/// @desc
if (can_pause && (pause_room != noone && pause_room != -1))
{
	if (meta_master.get_inp("pause"))
	{
		if (stop_sounds)
		{
			audio_stop_all();
		}
		
		if (room == pause_room)
		{
			room_goto(stasis_room);
			alarm[0] = 1;
			gpu_set_state(stasis_gpu_state);
		
		} else {
			meta_master.last_frame();
			stasis_room = room;
			stasis_room_was_pers = room_persistent;
			room_persistent = true;
			persistent = true;
			stasis_gpu_state = gpu_get_state();

			room_goto(pause_room);
		
		}
	
	}
	
}
