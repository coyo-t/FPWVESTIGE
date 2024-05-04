var c = view_camera[0];

var xp = obj_office_player.int_x;
camera_set_view_pos(c, xp, 0);

audio_listener_position(xp + (camera_get_view_width(c) / 2), room_height / 2, -400);
