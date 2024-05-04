/// @desc
if (cycle_time >= cycle_time_end)
{
	meta_master.last_frame();
	audio_stop_all();
	room_goto(room_beat_cycle);
}

