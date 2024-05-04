var mx = fpw.get_mouse_x();
var my = fpw.get_mouse_y();

var is_clicked = mouse_check_button_pressed(mb_left);

for (var i = 0; i < array_length(cam_buttons);)
{
	var cam = cam_buttons[i++];
	var inside = cam.point_inside(mx, my);
	
	if (is_clicked && inside)
	{
		obj_cctv_cam_button.is_active_cam = false;
		cam.is_active_cam = true;
		active_cam_instance = cam;
		break;
	}
	
}

