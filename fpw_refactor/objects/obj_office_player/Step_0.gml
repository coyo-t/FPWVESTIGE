var which_moment = spd_decel;
var vec = 0;

if (is_enabled)
{
	var mx = fpw.get_mouse_x();
	
	var inp_l = -keyboard_check(ord("A"));
	var inp_r = keyboard_check(ord("D"));
	
	var dist_l = 0;
	var dist_r = 0;
	
	if (mx <= inactive_l || mx >= inactive_r)
	{
		which_moment = spd_accel;
	
		var dist_l = clamp(inactive_l - mx, 0, trigger_size_min) / -trigger_size_min;
		var dist_r = clamp(mx - inactive_r, 0, trigger_size_min) / trigger_size_min;
	
		dist_l *= x > limit_min;
		dist_r *= x < limit_max;
		
	}
	
	dist_l = min(dist_l, inp_l);
	dist_r = max(dist_r, inp_r);
	
	vec = (dist_l + dist_r);
	
	vec *= spd_max;
	
}

if (is_enabled || (!is_enabled && !hard_stop && velocity != 0))
{
	velocity = lerp_dt(velocity, vec, 1 / (which_moment * 1000));

	x += velocity * DT;

	if (x < limit_min || x > limit_max)
	{
		x = clamp(x, limit_min, limit_max);
		velocity = 0;
	}

	int_x = floor(x);
	
}

if (!is_enabled && hard_stop)
{
	velocity = 0;
}
