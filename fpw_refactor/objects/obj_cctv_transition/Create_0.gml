toggle_min = 0;
toggle_max = sprite_get_number(sprite_index) - 1;

target_frame = -1;

frame = 0;
oframe = frame;

initial_speed = image_speed;

sfx = -1;

fire_target_events = true;

parent = -1;

function tick (gs)
{
	oframe = frame;
	if (target_frame != -1)
	{
		visible = true;
		//frame = animate_and_return(sprite_index, frame, image_speed);
		frame = frame + (sprite_get_speed(sprite_index) * (image_speed / gs.timer.get_tps()));
	
		if (fire_target_events)
		{
			//we're flipping up
			if (image_speed == initial_speed && frame >= target_frame)
			{
				gs.queue_state_change("cctv");
				target_frame = -1;
			}
			//we're flipping down
			if (image_speed == -initial_speed && frame <= target_frame)
			{
				target_frame = -1;
			}
		}
	}
}

function draw (gs)
{
	if (target_frame != -1)
	{
		draw_sprite_ext(
			sprite_index, floor((frame - oframe) * gs.timer.a + oframe),
			0, 0,
			appsurf_w / sprite_width, appsurf_h / sprite_height, 0,
			c_white, 1.
		);
	}
}


function flip_up (gs, keep_frame)
{
	if (keep_frame == undefined || !keep_frame)
	{
		frame = toggle_min;
	}
	
	image_speed = initial_speed;
	target_frame = toggle_max;
	parent.set_interaction(false);
	
	if (audio_is_playing(sfx))
	{
		audio_stop_sound(sfx);
	}
	
	sfx = audio_play_sound(sfx_cam_up, 1, false);
	audio_sound_gain(sfx, 0.5, 0);
	
}

function flip_down (gs, keep_frame)
{
	if (keep_frame == undefined || !keep_frame)
		frame = toggle_min;
	
	image_speed = -initial_speed;
	frame = toggle_max;
	target_frame = toggle_min;
	parent.set_interaction(true);
	//obj_cctv_toggle.set_cctv_state(false);

	if (audio_is_playing(sfx))
	{
		audio_stop_sound(sfx);
	}
	
	sfx = audio_play_sound(sfx_cam_down, 1, false);
	audio_sound_gain(sfx, 0.5, 0);

}

function is_animating ()
{
	return target_frame != -1;
}
