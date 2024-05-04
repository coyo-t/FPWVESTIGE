/// @desc

if (start_centred)
{
	x = room_width * 0.5 - RESW * 0.5;
}

if (instance_number(object_index) > 1)
{
	instance_destroy(id, false);
}

is_enabled = true;
is_enabled_override = false;

bounds_left = 0;
bounds_top = 0;

bounds_right  = room_width - RESW;
bounds_bottom = room_height - RESH;

cent_x = RESW*.5;
cent_y = RESH*.5;

trigger_x_max = trigger_x_size * (2/3);
trigger_y_max = trigger_y_size * (2/3);

speed_x_velocity = 0;
speed_y_velocity = 0;

hardStop = false;

ignore_bounds = false;
