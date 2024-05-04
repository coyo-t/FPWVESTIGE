/// @desc
if (room == room_labyrinth_pre)
{
	var cam = obj_camera.view_cam;
	cam = is_undefined(cam) ? camera_get_default() : cam;
	view_set_camera(0, cam);
	camera_apply(cam);
	
}
