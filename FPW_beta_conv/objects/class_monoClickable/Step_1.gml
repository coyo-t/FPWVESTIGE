/// @desc
var _mx, _my;

if (noCameraOffset)
{
	_mx = meta_master.get_inp("mouse_x");
	_my = meta_master.get_inp("mouse_y");
	
} else {
	var pos = obj_panorama_labyrinth.dist_pos();

	_mx = pos[0];
	_my = pos[1];
}

wasClicked = false;

was_mouse_over = point_in_rectangle(_mx, _my, bounds[0], bounds[1], bounds[2], bounds[3]);

if (was_mouse_over && mouse_check_button_pressed(mouseButton))
{
	wasClicked = true;
	clickOffset_x = _mx - bounds[0];
	clickOffset_x = _my - bounds[1];
}

