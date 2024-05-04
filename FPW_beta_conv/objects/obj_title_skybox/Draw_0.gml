/// @desc
if (do_draw_skybox)
{
	var cam = view_camera[0];
	
	gpu_push_state();
	gpu_set_texfilter(true);
	camera_set_view_mat(sky_cam, sky_viewmat);
	gpu_set_ztestenable(false);
	gpu_set_cullmode(cull_noculling);
	
	camera_apply(sky_cam);

	matrix_world_set(matrix_build(
		0,0,0,
		0,0,0,
		8,8,8
	));

	for (var i = 0; i < array_size(sky_mdl); i++)
	{
		vertex_submit(
			sky_mdl[i],
			pr_trianglelist,
			sprite_get_texture(sky_mdl_tex[i], 0)
		);
	}

	matrix_world_reset();
	camera_apply(cam);
	gpu_pop_state();
	
}
