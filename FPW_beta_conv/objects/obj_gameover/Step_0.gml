/// @desc

var over = point_in_bbox(
	mouse_x_real(), mouse_y_real(),
);

image_blend = over ? c_white : c_grey;

if (over && mouse_check_button_pressed(mb_left))
{
	room_goto(room_labyrinth_office);
	
}
