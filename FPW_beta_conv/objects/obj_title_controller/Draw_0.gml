/// @desc
//var cam = view_camera[0];
//var cstate = curr_state;

//if (cstate.do_draw_skybox)
//{
//	gpu_push_state();
//	gpu_set_texfilter(true);
//	camera_set_view_mat(bg_cam, bg_viewmat);
//	gpu_set_ztestenable(false);
	
//	camera_apply(bg_cam);

//	matrix_world_set(matrix_build(
//		0,0,0,
//		0,0,0,
//		8,8,8
//	));

//	vertex_submit(sphere_mdl, pr_trianglelist, sprite_get_texture(spr_title_envbkd, 0));

//	matrix_world_reset();
//	camera_apply(cam);
//	gpu_pop_state();
	
//}

scr_lyr_inv_camera(true);

draw_text($F, $F, "yaw: " + string(bg_obj.sky_yaw) + "\npitch: "+string(bg_obj.sky_pitch));

scr_lyr_inv_camera(true);
