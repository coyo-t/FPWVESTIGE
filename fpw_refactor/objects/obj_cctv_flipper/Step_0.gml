if (target_frame != -1)
{
	visible = true;
	frame = animate_and_return(sprite_index, frame, image_speed);
	
	if (fire_target_events)
	{
		//we're flipping up
		if (image_speed == initial_speed && frame >= target_frame)
		{
			obj_cctv_toggle.set_cctv_state(true);
			target_frame = -1;
		}
		//we're flipping down
		if (image_speed == -initial_speed && frame <= target_frame)
		{
			target_frame = -1;
		}
	}
}

