var click = mouse_check_button(mb_left);

//check to see if our parent door is fully open (if we have one)
var can_toggle;

if (parent_door != -1)
{
	with (parent_door)
	{
		var pinf = states[state];
		can_toggle = (curr_frame == pinf.cmax) && (state == OfficeDoorStates.open);
	}
}
else
	can_toggle = true;

// I suppose can_toggle can be &'d with is_enabled to effectively disable the light.
// shrug.
if (can_toggle && is_enabled)
{
	var mpos = obj_office_director.get_mouse_pano_pos();
	var in_bounds = hitbox.point_inside(mpos[0], mpos[1]);
	
	if (!last_mouse && !light_on) || (light_on)
	{
		light_on = click && in_bounds;
	}
	else
	{
		light_on = false;
	}
} 
else
{
	light_on = false;
}

last_mouse = click;
