/// @desc
//var vert = buffer_peek(model, 1, buffer_vbuffer);
//vert += sin(time() * 2) * 4;
//buffer_poke(model, 0, buffer_vbuffer, vert);
//print(buffer_peek(model, 1, buffer_vbuffer));

#region wut
/*
mouse_coold = max(mouse_coold - dt(), 0);

var m_w = floor((window_get_width() * .5) + 0.5);
var m_h = floor((window_get_height() * .5) + 0.5);

var mb_down  = meta_master.input[?"mb_left_down"];
var mb_check = meta_master.input[?"mb_left_held"];
var mb_up    = meta_master.input[?"mb_left_up"];

if (mb_check)
{
	var mx = mb_down ? m_w : window_mouse_get_x();
	var my = mb_down ? m_h : window_mouse_get_y();
	if (mb_down)
	{
		mouse_coold = (1 / game_get_speed(gamespeed_microseconds)) + 0.02;
	}
	
	window_mouse_set(m_w, m_h);
	
	if (mouse_coold == 0)
	{
		cam_yaw   += ((mx - m_w) / m_w) * mouse_sens * 10;
		cam_pitch += ((my - m_h) / m_h) * mouse_sens * 10;
	}
}

cam_fov_y -= (meta_master.input[?"mwheel_up"] - meta_master.input[?"mwheel_down"]) * 0.5;

camera_set_proj_mat(
	camera,
	matrix_build_projection_perspective_fov(
		cam_fov_y, RESA, 0.01, 2400
	)
);
//camera_set_proj_mat(
//	camera,
//	matrix_build_projection_perspective_fov(
//		cam_fov_y + m_random_range(-4, 4), RESA + m_random_range(-0.1, 0.1), 0.01, 2400
//	)
//);

cam_yaw   = cam_yaw % 360;
cam_pitch = clamp(cam_pitch, -90, 90);
*/
#endregion