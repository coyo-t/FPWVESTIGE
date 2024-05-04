/// @desc

//var cam = camera_get_default();
var cam = -1;

switch (state) begin
	case room_states.power_out:
		if (!audio_is_playing(sound_breathe))
		{
			sound_breathe = audio_play_sound(sfx_breath, 10, true);
		}
		
		cam = obj_camera.view_cam;
		lyrmngr_cctv.set_vis(false);
		lyrmngr_office.set_vis(true);
		break;
		
	case room_states.grun_kill:
		cam = obj_camera.view_cam;
		lyrmngr_cctv.set_vis(false);
		lyrmngr_office.set_vis(true);
		break;
		
	case room_states.lizz:
		//draw the base room
		cam = obj_camera.view_cam;
		lyrmngr_cctv.set_vis(false);
		lyrmngr_office.set_vis(true);
		
		//if (DEBUG)
		//{
		//	camera_apply(obj_camera.view_cam);
		//	draw_push_state();
		//	draw_set_colour(c_yellow);
		//	for (var i = 0; i < ds_list_size(d_points); ++i)
		//	{
		//		var p = d_points[| i];
		//		draw_cross(p[0], p[1], 32);
		//	}
		//	draw_pop_state();
		//}
		break;
	
	case room_states.cctv:
		if (obj_cctv.is_anim_playing)
		{
			cam = obj_camera.view_cam;
			lyrmngr_cctv.set_vis(false);
		} else {
			cam = obj_cctv_visuals.camera_no_offset;
			lyrmngr_cctv.set_vis(true);
		}
		break;
	
end


view_set_camera(0, cam);
camera_apply(cam);
