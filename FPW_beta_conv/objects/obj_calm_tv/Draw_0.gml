/// @desc
if (is_enabled)
{
	if (on_camera(bbox_left, bbox_top, bbox_right, bbox_bottom, view_camera[view_current]))
	{
		screen_surface = surface_create_unexist(screen_surface, screen_size, screen_size);
	
		surface_set_target(screen_surface);
		{
			draw_push_state();
			if (is_tv_on)
			{
				//draw_clear(is_tv_on ? c_fuchsia : c_purple);
			
			
			
			
				gpu_set_blendmode(bm_normal);

			
			} else {
				//draw_clear(c_black);
			}
			draw_pop_state();
		} surface_reset_target();
	
		//now actually draw the screen model
		matrix_world_set(matrix_build(0,0,screen_z,0,0,0,model_size,model_size,1));
		gpu_push_state();
		gpu_set_alphatestenable(true);
		gpu_set_texfilter(true);
		vertex_submit(model_monitor, pr_trianglelist, surface_get_texture(screen_surface));
		gpu_pop_state();
		matrix_world_reset();
	
	}
}
