/// @desc
if (visible)
{
	surface = surface_create_unexist(surface, sprite_width, sprite_height);
	mdl_surface = surface_create_unexist(mdl_surface, sprite_width, sprite_height);

	if (surface_exists(surface) && surface_exists(mdl_surface))
	{
		surface_set_target(surface);
		draw_clear(c_black);
		surface_reset_target();
	
		surface_set_target(mdl_surface);
		draw_clear(c_black);
		surface_reset_target();
	
		gpu_push_state();
		gpu_set_colourwriteenable(1, 1, 1, 0);
		surface_copy_part(surface, 0, 0, application_surface, 0, 0, sprite_width, sprite_height);
		gpu_pop_state();
	
		gpu_push_state();
	
		gpu_set_texfilter(true);
		surface_set_target(mdl_surface);
		var trans = matrix_get(matrix_world);
	
		camera_apply(camera);
	
		matrix_set(matrix_world, matrix_build(
			0, 0, 0, 0,0,0, 1,1,1
		));
	
		vertex_submit(model, pr_trianglelist, surface_get_texture(surface));

		matrix_set(matrix_world, trans);
		gpu_pop_state();
		camera_apply(view_camera[0]);
		surface_reset_target();
	
		draw_surface(mdl_surface, x, y);
	
	}

}
