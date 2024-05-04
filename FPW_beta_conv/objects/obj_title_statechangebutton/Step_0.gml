/// @desc
if (is_my_state)
{
	var mx = meta_master.get_inp("mouse_x_room");
	var my = meta_master.get_inp("mouse_y_room");

	var tcont = obj_title_controller;

	if (point_in_bbox(mx, my) && meta_master.get_inp("mb_left_down"))
	{
		var succ = tcont.change_state(target_state);
	
		if (succ) // haha succ funny sex joek hahahaahahaahahahahHAHAHAHAHAHA
		{
			with (object_index)
			{
				is_my_state = tcont.current_state_name() == resident_state;
				
				if (audio_is_playing(sfx))
					audio_stop_sound(sfx);
			}
	
			if (move_instant)
				tcont.force_current_posangle();
	
			sfx = audio_play_sound(sfx_click_menu, 0, false);
		
		}
	
	}

}

