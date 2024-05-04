function scr_layer_notrans_begin ()
{
	static vmat = camera_get_view_mat(view_camera[1]);
	
	if (event_type == ev_draw && event_number == 0)
	{
		matrix_general_push(camera_get_view_mat(view_camera[0]));
		camera_set_view_mat(view_camera[0], vmat);
		camera_apply(view_camera[0]);
	}
}


function scr_layer_notrans_end ()
{
	if (event_type == ev_draw && event_number == 0)
	{
		camera_set_view_mat(view_camera[0], matrix_general_pop());
		camera_apply(view_camera[0]);
	}
}
