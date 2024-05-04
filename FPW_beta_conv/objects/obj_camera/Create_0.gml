/// @desc

// why yes, this is a shitty hack
// how nice of you to notice!
view_cam = -1;

if (room == room_labyrinth_office || room == room_labyrinth_pre)
{
	if (instance_number(object_index) > 1)
	{
		instance_destroy(id, false);
	}
}

view_cam = camera_create_view(0, 0, RESW, RESH);//view_camera[0];

offset_x = 0;
offset_y = 0;

//var _view_width = camera_get_view_width(view_cam);
//pos_min = 0;
//pos_max = room_width - _view_width;

audio_listener_orientation(0, 0, 1, 0, -1, 0);
