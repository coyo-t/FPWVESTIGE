/// @desc
#region movement

if (room == room_labyrinth_office && !is_enabled_override)
	is_enabled = !obj_cctv.is_cctv_active;

//next time im just doing player movement from scratch.
var which_moment = speed_decel;
var dist_x = 0;
var dist_y = 0;
var bounds_x_equal = room_width > RESW;
var bounds_y_equal = room_height > RESH;
var mx = meta_master.get_inp("mouse_x");
var my = meta_master.get_inp("mouse_y");

if (is_enabled)
{
	var trig_dist_x = clamp((mx - (RESW - trigger_x_size)) / trigger_x_max, 0.0, 1.0);
	trig_dist_x    -= clamp(((trigger_x_size - mx) / trigger_x_max), 0.0, 1.0);
	
	var trig_dist_y = clamp((my - (RESH - trigger_y_size)) / trigger_y_max, 0.0, 1.0);
	trig_dist_y    -= clamp(((trigger_y_size - my) / trigger_y_max), 0.0, 1.0);
	
	trig_dist_x += meta_master.get_inp("move_right") - meta_master.get_inp("move_left");
	trig_dist_y += meta_master.get_inp("move_down") - meta_master.get_inp("move_up");
	
	var over_x = trig_dist_x != 0;
	var over_y = trig_dist_y != 0;
	
	if (over_x || over_y)
	{
		which_moment = speed_accel;
		
		var diag = 1;
		if ((bounds_x_equal && bounds_y_equal) || ignore_bounds) then
			diag = over_x && over_y ? SQRT2 : 1;
		
		dist_x = clamp(trig_dist_x, -1, 1) * (speed_max * diag);
		dist_y = clamp(trig_dist_y, -1, 1) * (speed_max * diag);
		
	}

}

speed_x_velocity = (hardStop && !is_enabled) 
	? 0 
	: lerp_dt_1d(
			speed_x_velocity, 
			dist_x, 
			which_moment * 10000
		);

x += speed_x_velocity * dt();

speed_y_velocity = (hardStop && !is_enabled) 
	? 0 
	: lerp_dt_1d(
			speed_y_velocity, 
			dist_y, 
			which_moment * 10000
		);

y += speed_y_velocity * dt();

if (!ignore_bounds)
{
	speed_x_velocity = (bounds_right < x || x < bounds_left) ? 0 : speed_x_velocity;
	x = clamp(x, bounds_left, bounds_right);
	
	speed_y_velocity = (bounds_bottom < y || y < bounds_top) ? 0 : speed_y_velocity;
	y = clamp(y, bounds_top, bounds_bottom);
	
}

#endregion
