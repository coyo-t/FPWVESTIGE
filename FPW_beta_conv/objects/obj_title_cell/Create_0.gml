/// @desc
var tcont = obj_title_controller;
var cx = floor(x / room_width);
var cy = floor(y / room_height);

if (convert_from_blender)
{
	//pitch seems to be unadulterated. included here for posterity incase it turns out to be
	skybox_angles[0] = skybox_angles[0];
	skybox_angles[1] = -skybox_angles[1];// + 180;
	skybox_angles[2]  = -skybox_angles[2];
}

tcont.menustates[?cell_name] = new tcont.menu_state(
	skybox_angles[0], skybox_angles[1], skybox_angles[2],
	cx, cy,
	do_draw_skybox,
	fov
);

if (is_intitial_cell || instance_count == 1)
{
	tcont.change_state(cell_name);
	tcont.force_current_posangle();
}
