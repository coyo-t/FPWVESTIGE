///@arg manual_override
function scr_lyr_inv_camera () begin
	static cam_w = -1;
	static cam_h = -1;
	static cmat = -1;
	
	if ((event_type == ev_draw && event_number == 0) || (argument_count > 0 && argument[0]))
	{
		if (cmat == -1)
		{
			var view = view_current;
			var cam = camera_get_active();
			var vw  = view_wport[view];
			var vh  = view_hport[view];
			cam_w   = camera_get_view_width(cam);
			cam_h   = camera_get_view_height(cam);
		
			cmat = camera_get_view_mat(cam)
		
			camera_set_view_size(cam, vw, vh);
			camera_set_view_mat(cam, matrix_build(-vw/2, -vh/2, 0, 0,0,0, 1,1,1));
			camera_apply(cam);
			
			gpu_push_state();
			gpu_set_ztestenable(false);
			
		}
		else
		{
			var cam = view_camera[view_current];
		
			camera_set_view_mat(cam, cmat);
			camera_set_view_size(cam, cam_w, cam_h);
			camera_apply(cam);
			
			cmat = -1;
			gpu_pop_state();
			
		}
		
	}
end


function scr_lyr_cctv_begin () begin
	//matrix_stack_push(matrix_get(matrix_world));
	//matrix_set(matrix_world, camera_inverse_mat());

end


function scr_lyr_cctv_end () begin
	//matrix_set(matrix_world, matrix_stack_top());
	//matrix_stack_pop();

end


function scr_lyr_cctv_panel_begin () begin
	matrix_stack_push(matrix_get(matrix_world));
	matrix_set(matrix_world, camera_inverse_mat());

end


function scr_lyr_cctv_panel_end () begin
	matrix_set(matrix_world, matrix_stack_top());
	matrix_stack_pop();

end


function scr_lyr_calmtv_begin () begin
	if (event_type == ev_draw && event_number == 0)
	{
		with (obj_calm_tv)
		{
			if (is_tv_on)
			{
				screen_surface = surface_create_unexist(screen_surface, screen_size, screen_size);
				surface_set_target(screen_surface);
			
			}
		}
	}
end


function scr_lyr_calmtv_end () begin
	var i = obj_calm_tv;
	if (i.is_tv_on && event_type == ev_draw && event_number == 0)
	{
		surface_reset_target();
	}
end
