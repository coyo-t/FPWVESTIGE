var mx, my;
{
	var mpos = obj_office_director.get_mouse_pano_pos();
	mx = mpos[0];
	my = mpos[1];
}

var click = mouse_check_button(mb_left);
var in_bounds = hitbox.point_inside(mx, my);

var check = click && in_bounds;
//i should separate these into two separate objects buuuut whatever.
var s = state;
var s_info = states[state];

//door
switch (s)
{
	case OfficeDoorStates.open:
		if (curr_frame == s_info.cmax)
		{
			is_fully_closed = false;
		}
		
	break;
	
	case OfficeDoorStates.closed:
		is_fully_closed = (curr_frame / s_info.anim_count) > closed_threshold;
		
	break;

}

if (is_enabled)
{
	//button
	switch (s)
	{
		case OfficeDoorStates.open:
			if (check && !is_fully_closed)
			{
				set_state(OfficeDoorStates.closed);
			}
		
		break;
	
		case OfficeDoorStates.closed:
			if ((!check && !is_fully_closed) || (!check && curr_frame == s_info.cmax))
			{
				set_state(OfficeDoorStates.open);
			}
		
		break;

	}
	
}

curr_frame = animate_and_return(s_info.anim, curr_frame, 1);
curr_frame = clamp(curr_frame, 0, s_info.cmax);
